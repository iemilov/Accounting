/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-27-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class TestDataFactory {

    /***********************************************************************************************************************************************************************
    *                                                                           TEST CONSTANT DATA                                                                           *
    ***********************************************************************************************************************************************************************/
    public static final String ERROR_MESSAGE = 'An error has occurred: ';
    public static final Id EmailTemplate_SendInvoice_DE_ID = System.Label.EmailTemplate_SendInvoice_DE;
    public static final Id EmailTemplate_SendInvoice_EN_ID = System.Label.EmailTemplate_SendInvoice_EN;

    public static Contact createContact (){

        Contact conObj = new Contact();
        conObj.LastName = 'Test BillingContact';
        conObj.Email = 'test@mail.com';

        insert conObj;

        return conObj;
    }

    public static Invoice__c createInvoice (String language, Id contactId){

        Invoice__c invoiceObj = new Invoice__c();
        invoiceObj.Language__c = language;
        invoiceObj.Status__c = 'Draft';

        insert invoiceObj;
        return invoiceObj;

    }
    
    public static Id createFile (Blob filebody, String filename ){

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = 'invoice.pdf';
        conVer.Title = 'Invoice_'+filename + '_'+ date.today().format();
        conVer.VersionData = filebody;

        try{
            insert conVer;
        }catch(Exception e){
            System.debug(Constants.ERROR_MESSAGE+e.getMessage());
        }

        return conVer.Id;

    }

    /*public static Milestone1_Task__c createTask (String taskName, Id milestoneId){

        Milestone1_Task__c task = new Milestone1_Task__c();
        task.name = taskName;
        task.Project_Milestone__c = milestoneId;

        return task;
    }*/


    public static Milestone1_Project__c createProject (String projectName){
        Milestone1_Project__c proj = new Milestone1_Project__c();
        proj.name = projectName;

        return proj;
    }

    public static Milestone1_Milestone__c createMilestone (String milestoneName, Id projectId){

        Milestone1_Milestone__c ms1 = new Milestone1_Milestone__c();

        ms1.name= milestoneName;
        ms1.Project__c= projectId;
        
        return ms1;
    }
}