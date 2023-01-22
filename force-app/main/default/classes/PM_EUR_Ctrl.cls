/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PM_EUR_Ctrl {

    public Income income {get;set;}
    public Expense expense {get;set;}
    public Integer currentYear{get;set;}
    public Decimal profit{get;set;}
    public Decimal paidTaxesFinal{get;set;}

    public PM_EUR_Ctrl() {
        //currentYear = System.Today().year();
        String year= EURConfig__mdt.getInstance('CurrentYear').Year__c;
        currentYear=integer.valueof(year);
        income=getIncomes(currentYear);
        expense=getExpenses(income.paid_taxes, currentYear);
        profit=getProfit(income.total_income, expense.total_expense);
    }

    private static Income getIncomes(Integer currentYear) {
        Income tmpIncome = new Income();
        Decimal tmp_taxed_income=0;
        Decimal tmp_paid_taxes=0;
 
        for (Invoice__c invoice: [SELECT AmountNetto__c, VAT__c FROM Invoice__c WHERE CALENDAR_YEAR(InvoiceSentDate__c) =:currentYear and status__c!='Draft']){
            tmp_taxed_income=tmp_taxed_income+invoice.AmountNetto__c;
            tmp_paid_taxes=tmp_paid_taxes+invoice.VAT__c;
            tmpIncome.taxed_income=tmp_taxed_income;
            tmpIncome.paid_taxes=tmp_paid_taxes;
            tmpIncome.total_income= tmpIncome.taxed_income+tmpIncome.paid_taxes;
        }

        return tmpIncome;
    }

    private static Expense getExpenses(Decimal liableTaxes, Integer currentYear) {
        Expense exp = new Expense();

        Decimal paid_input_taxes_temp=0;

        Decimal operating_outcomes_temp=0;
        Decimal property_outcomes_temp=0;
        Decimal afa_temp=0;
        Decimal fully_deductible_outcomes_temp=0;
        Decimal limited_deductible_outcomes_temp=0;
        Decimal vehicle_outcomes_temp=0;
        Decimal total_expense_temp=0;
        // variable privat Entnahmen
        Decimal private_outcomes_temp=0;

        for (Expense__c expense: [SELECT AmountNetto__c, VAT__c, Type__c, Subcategory__c FROM Expense__c WHERE CALENDAR_YEAR(DateIncurred__c)=:currentYear]){
            
            switch on expense.type__c {
                when 'Betriebsausgaben' {
                    operating_outcomes_temp=operating_outcomes_temp + expense.AmountNetto__c;
                    exp.operating_outcomes=operating_outcomes_temp;
                }
                when 'Afa' {
                    afa_temp=afa_temp+expense.AmountNetto__c;
                    exp.afa=afa_temp;
                }
                when 'Raumkosten und sonstige Grundstücksaufwendungen' {
                    property_outcomes_temp=property_outcomes_temp+expense.AmountNetto__c;
                    exp.property_outcomes=property_outcomes_temp;
                }
                when 'Sonstige unbeschränkt abziehbare Betriebsausgaben' {
                    fully_deductible_outcomes_temp=fully_deductible_outcomes_temp+expense.AmountNetto__c;
                    exp.fully_deductible_outcomes=fully_deductible_outcomes_temp;
                    
                }
                when 'Beschränkt abziehbare Betriebsausgaben und Gewerbesteuer' {
                    limited_deductible_outcomes_temp=limited_deductible_outcomes_temp+expense.AmountNetto__c;
                    exp.limited_deductible_outcomes=limited_deductible_outcomes_temp;
                }
                when 'Kraftfahrzeugkosten und andere Fahrtkosten' {
                    vehicle_outcomes_temp=vehicle_outcomes_temp+expense.AmountNetto__c;
                    exp.vehicle_outcomes=vehicle_outcomes_temp;
                }
            }
            paid_input_taxes_temp=paid_input_taxes_temp+expense.VAT__c;
            total_expense_temp=total_expense_temp+expense.AmountNetto__c;
            exp.paid_input_taxes=liableTaxes-paid_input_taxes_temp;
            exp.total_expense=total_expense_temp+exp.paid_input_taxes;

            // start of private outcomes
            /*switch on expense.subcategory__c {
                when 'Krankenkasse' {
                    private_outcomes_temp=private_outcomes_temp+expense.AmountNetto__c;
                    private_outcomes=private_outcomes_temp;
                }
                when 'Rente' {

                }
                when 'Spenden' {

                }
                when 'Kinderbetreuung' {
                    private_outcomes_temp=private_outcomes_temp+expense.AmountNetto__c;
                    private_outcomes=private_outcomes_temp;
                }
                when 'Andere Privatentnahmen' {

                }
            }*/


        }

        return exp;
    }

    private static Decimal getProfit(Decimal total_income, Decimal total_expense) {
        return total_income-total_expense;
    }

    
    public class Income{
        public Decimal taxed_income {get;set;}
        public Decimal taxedfree_income {get;set;}
        public Decimal paid_taxes {get;set;}
        public Decimal refunded_taxes {get;set;}
        public Decimal private_car_use {get;set;}
        public Decimal total_income {get;set;}
    }

    public class Expense{
        public Decimal paid_input_taxes{get;set;}
        public Decimal total_expense{get;set;}
        public Decimal operating_outcomes {get;set;}
        public Decimal property_outcomes {get;set;}
        public Decimal afa {get;set;}
        public Decimal fully_deductible_outcomes {get;set;}
        public Decimal limited_deductible_outcomes {get;set;}
        public Decimal vehicle_outcomes {get;set;}
        // private Entnahmen
        public Decimal private_outcomes {get;set;}

    }
}