/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PM_generateInvoicePDF_VF_CTRL {

    static final String TIME_STATUS='Ready to bill';
    public Invoice__c invoice {get;set;} 
    public List <TimeCard__c> times {get;set;}
    public Map <Integer,InvoicePosition> positionsMap {get;set;}
    public Decimal total_amount_all_resources {get;set;}
  
    public PM_generateInvoicePDF_VF_CTRL(ApexPages.StandardController controller) {
        invoice = (Invoice__c)controller.getRecord();
        System.debug('Salesforce id in ' + invoice);
        Id templateId = getTemplateId(invoice);
        times=getTimes(templateId);
        positionsMap= getInvoicePositions(times, templateId);
        // temp
    }

    public PageReference updateInvoice(){
        PM_InvoiceUtils invoiceUtils = new PM_InvoiceUtils();
        invoiceUtils.setInvoiceAmount(invoice, total_amount_all_resources);
        return null;
    }


    public List <TimeCard__c> getTimes(Id templateId) {
        return [SELECT Date__c, Invoicetemplate__c, Description__c, Project__r.Name, Hours__c, Resource__c
        FROM TimeCard__c
        WHERE Invoicetemplate__c=:templateId
        AND Status__c=:TIME_STATUS
        order by Date__c asc];
    }

    public Id getTemplateId(Invoice__c invoice) {
        return [select id, InvoiceTemplate__c from Invoice__c where id=:invoice.id].InvoiceTemplate__c;
    }

    public Map <Integer,InvoicePosition> getInvoicePositions(List <TimeCard__c> times, Id templateId) {
        total_amount_all_resources=0;
        Map <Integer,InvoicePosition> positionsMap = new Map <Integer,InvoicePosition>();
        List <AssignResourse__c> resources=[select Contact__c, DailyRate__c, ProjectRole__c from AssignResourse__c where InvoiceTemplate__c=:templateId];
        
        for(Integer i=0; i<resources.size(); i++){
            Decimal hours = 0;
            Decimal amount;
            for (TimeCard__c t: times){
                if (t.Resource__c==resources[i].Contact__c){
                    hours = hours + t.Hours__c;
                    amount=hours*resources[i].DailyRate__c;
                    InvoicePosition invoicePosition = new InvoicePosition(resources[i].ProjectRole__c,resources[i].DailyRate__c, hours, amount );
                    positionsMap.put(i+1, invoicePosition);
                }
            }
            if (!positionsMap.KeySet().IsEmpty()){
                total_amount_all_resources=total_amount_all_resources + positionsMap.get(i+1).amount;
            }
        }
        return positionsMap;
    }

    public class InvoicePosition{
        public String provided_service {get;set;}
        public Decimal daily_rate {get;set;}
        public Decimal worked_hours {get;set;}
        public Decimal amount {get;set;}

        public InvoicePosition(String provided_service, Decimal daily_rate, Decimal worked_hours, Decimal amount) {
            this.provided_service = provided_service;
            this.daily_rate = daily_rate;
            this.worked_hours= worked_hours;
            this.amount=amount;
        }
    }
}