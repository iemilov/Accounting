/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-16-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-21-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class FileService {
    public FileService() {

    }

    /**
    * @description 
    * @author Ivan Emilov | 05-13-2021 
    * @param filebody 
    * @param filename 
    * @return Id 
    **/
    public static Id createFile (Blob filebody, Invoice__c invoice ){

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = 'invoice.pdf';
        conVer.Title = 'Invoice_' + invoice.name + '_' + invoice.InvoiceTemplate__r.Name + '_' + date.today().format();
        conVer.VersionData = filebody;

        try{
            insert conVer;
            if(Test.isRunningTest()){}
        }catch(Exception e){
            System.debug(Constants.ERROR_MESSAGE+e.getMessage());
        }

        return conVer.Id;

    }
        
    public static void AttachOrReplaceFilesToRecords (Id documentId, List <Id> parentIdList){

        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:documentId].ContentDocumentId;
        List <ContentDocumentLink> conDocLinkListCurrent = [SELECT id FROM ContentDocumentLink WHERE LinkedEntityId in:parentIdList];
        
        if (conDocLinkListCurrent.size()>0){
            try{
                delete conDocLinkListCurrent;
            }catch(Exception e){
                System.debug(Constants.ERROR_MESSAGE+e.getMessage());
            }
            AttachFilesToRecords(conDocId, parentIdList);
        }
        else {
            AttachFilesToRecords(conDocId, parentIdList);
        }
    }

    private static void AttachFilesToRecords (Id conDocId, List <Id> parentIdList){
        List <ContentDocumentLink> conDocLinkList = new List <ContentDocumentLink>();
            for (Integer i=0; i<parentIdList.size(); i++){
                ContentDocumentLink conDocLink = new ContentDocumentLink (
                    LinkedEntityId=parentIdList.get(i),
                    ContentDocumentId=conDocId,
                    shareType = 'V');
                conDocLinkList.add(conDocLink);  
            }
            try{
                insert conDocLinkList;
            }catch(Exception e){
                System.debug(Constants.ERROR_MESSAGE+e.getMessage());
            }
    }
}