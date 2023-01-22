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
public with sharing class Constants {

    public static final String ERROR_MESSAGE =	'An error has occurred: ';
    public static final String EmailTemplate_SendInvoice_DE_ID = System.Label.EmailTemplate_SendInvoice_DE;
    public static final String EmailTemplate_SendInvoice_EN_ID = System.Label.EmailTemplate_SendInvoice_EN;
    // set bcc addresses for invoice sending, (e.g personam email for tracking purposes, Steuerberater)
    public static final String BccEmailAddresses = System.Label.BccAddresses;
}