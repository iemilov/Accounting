/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-23-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class PM_InvoiceUtils {

    public static void updateInvoiceStatus (Invoice__c invoice){
       try{     
            invoice.Status__c='sent';
            invoice.InvoiceSentDate__c=Date.today();

            update invoice;
        }catch(Exception e){
            System.debug(Constants.ERROR_MESSAGE+e.getMessage());
        }
    }

    // To Do currently is set by the VF page controller PM_generateInvoicePDF_VF_CTRL
    public void setInvoiceAmount (Invoice__c invoice, Decimal totalamount){
        try{     
            invoice.AmountNetto__c=totalamount;
            invoice.VAT__c=0.19*totalamount;
            invoice.AmountTotal__c=invoice.AmountNetto__c+invoice.VAT__c;
            update invoice;
         }catch(Exception e){
             System.debug(Constants.ERROR_MESSAGE+e.getMessage());
         }
     }

    // this method sets the total amount of netto invoices for the current month
    public static void upsertRevenues(){
        AggregateResult invoicesAmount = [SELECT SUM(AmountNetto__c) total
            FROM Invoice__c
            where InvoiceSentDate__c=THIS_MONTH];
        List<Revenue__c> revList= new List<Revenue__c>();
        Revenue__c rev= new Revenue__c();
        rev.type__c='Invoicing';
        rev.DateIncurred__c= Date.today();
        rev.AmountNetto__c=(Decimal)invoicesAmount.get('total');
        List <Revenue__c> existingRevenues=getRevenues('Invoicing');
        rev.id=!existingRevenues.isEmpty()?existingRevenues.get(0).id:null;
        revList.add(rev);
        try {
            upsert revList;
        }catch(Exception e){
            System.debug(Constants.ERROR_MESSAGE+e.getMessage());
        }
    }

    private static List <Revenue__c> getRevenues(String type){
        return [select id from Revenue__c where CreatedDate=THIS_MONTH and type__c=:type];
    }


}