/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-22-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-21-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class NotificationService {

    public static Boolean sendResult=true;
    public static String sendErrorMessage;

    // send Email message with preddefined Template
    public static void sendEmail( EmailTemplate emailTemplate, Invoice__c currentInvoice, List <Id> filesList ){

        String billingEmail=currentInvoice.InvoiceTemplate__r.Account__r.BillingEmail__c;
        String emailSubject= 'Rechnung '+ currentInvoice.Name + ' Lesitungszeitraum '+ currentInvoice.PerformanceMonth__c + ' - Salesforce Technical Architect';
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        try{
            message.setSenderDisplayName('Lanespot Solutions'); 
            message.setUseSignature(false);
            message.setBccSender(false); 
            message.setSaveAsActivity(false);
            message.setSubject(emailSubject);
            message.setEntityAttachments(filesList);
            message.setHtmlBody(emailTemplate.htmlvalue);
            message.toAddresses = new String[] { billingEmail};
            String[] bccAddresses = new String[] {Constants.BccEmailAddresses};
            // Add the BCC addresses
            message.setBccAddresses(bccAddresses);
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            System.debug('The email was sent successfully. '+results[0].success);

        }catch(Exception e){
            sendResult=false;
            sendErrorMessage=Constants.ERROR_MESSAGE+e.getMessage();
            System.debug(Constants.ERROR_MESSAGE+e.getMessage());
        }
     }
}