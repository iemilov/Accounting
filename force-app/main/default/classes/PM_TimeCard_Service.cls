/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-28-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PM_TimeCard_Service {

    // set status to billed
    public static void updateTimeCardStatus(Invoice__c invoice){

        List <TimeCard__c> timeCardsToUpdate = [SELECT id, Hours__c, status__c, Invoice__c from TimeCard__c where status__c='Ready to bill' and InvoiceTemplate__c=:invoice.InvoiceTemplate__c];

        for (TimeCard__c tc: timeCardsToUpdate ){
            tc.Status__c='Billed';
            tc.Invoice__c=invoice.id;
            tc.InvoiceTemplate__c=null;
        }

        update timeCardsToUpdate;

    }
}