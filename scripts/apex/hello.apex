// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);




SELECT Id,name, Developername, Subject FROM EmailTemplate where DeveloperName='Send_Invoice_1602844205597'

system.debug('testsss '+Constants.EmailTemplate_SendInvoice_DE_ID);