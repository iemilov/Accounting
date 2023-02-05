/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-28-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class PM_generateInvoicePDF_CTRL {

    public static String messageResponse ='success';
    static final String TIME_STATUS='Ready to bill';
    public static Invoice__c currentInvoice;
    public static EmailTemplate emailTemplate;

    @AuraEnabled
    public static String executeActivitiesOnInvoice (Id invoiceId, String language){

        pageReference pdfInvoiceTemplate = language == 'German' ? Page.PM_generateInvoicePDF_DE: Page.PM_generateInvoicePDF_EN;

        if (language == 'German'){
            emailTemplate=[SELECT Id,name,Body,htmlvalue, Subject FROM EmailTemplate where DeveloperName=:Constants.EmailTemplate_SendInvoice_DE_ID];
        } else if (language == 'English'){
            emailTemplate=[SELECT Id,name,Body,htmlvalue, Subject FROM EmailTemplate where DeveloperName=:Constants.EmailTemplate_SendInvoice_EN_ID];
        } else {
            system.debug('no templaze has beed selected');
        }

        List <Invoice__c> currentInvoiceList= [select Id, InvoiceTemplate__r.Name, PerformanceMonth__c, InvoiceTemplate__r.Account__r.BillingEmail__c, InvoiceTemplate__c, Status__c, Name FROM Invoice__c where id=:invoiceId WITH SECURITY_ENFORCED];
        Id currentInvoiceId=currentInvoiceList.get(0).Id;
        if (!currentInvoiceList.IsEmpty()){
            currentInvoice = currentInvoiceList.get(0);
        }
        
        pdfInvoiceTemplate.getParameters().put('id',currentInvoiceId);
        //Blob body = pdfInvoiceTemplate.getContentAsPDF();
        Blob body;
        if(Test.isRunningTest()){
            body = blob.valueOf('test');
        }else {
            body = pdfInvoiceTemplate.getContentAsPDF();
        }

            //create a pdf file from the VF page
            Id documentId = FileService.createFile(body, currentInvoice);
            // add or created relation of invoice file to email template and invoice record
            List<Id> listOfRecs = new List<Id>();
            ListOfRecs.add(currentInvoiceId);
            FileService.AttachOrReplaceFilesToRecords(documentId, listOfRecs);
            
            // send email to the customer with the attached invoice as pdf file
            List <Id> filesList = new List <Id>();
            filesList.add(documentId);


            NotificationService.sendEmail(emailTemplate, currentInvoice,filesList);
            if (NotificationService.sendResult){
                PM_InvoiceUtils.updateInvoiceStatus(currentInvoice);
                PM_InvoiceUtils.upsertRevenues();
                PM_TimeCard_Service.updateTimeCardStatus(currentInvoice);

            }
            else {
                messageResponse = NotificationService.sendErrorMessage;
            }
        
        return messageResponse;
    }

    private static Boolean validateTimeStatus (Id invoiceTemplateId){
        Boolean allTimesBilled;
        Map<ID, TimeCard__c> m = new Map<ID, TimeCard__c>([SELECT Status__c FROM TimeCard__c where InvoiceTemplate__c=:invoiceTemplateId]);
        for (ID idKey : m.keyset()) {
            // if only one record is ready to bill, set the parameter to true
            if (String.valueOf(m.get(idKey))==TIME_STATUS){
                allTimesBilled= true;
            } else{
                allTimesBilled= false;
            }
        }
        return allTimesBilled;
    }
}