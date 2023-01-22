/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-31-2022
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

}