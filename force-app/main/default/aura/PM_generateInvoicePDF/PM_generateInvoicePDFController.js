({
    recordLoaded : function(component, event, helper) {
        var language = component.get("v.invoice.Language__c");
        var status = component.get("v.invoice.Status__c");
        var url = component.get("v.invoice.InvoiceUrl__c");
        component.set("v.getLanguage", language);
        component.set("v.getInvoiceStatus", status); 
        component.set("v.getInvoiceUrl", url);
    },

    handleClick: function(component, event, helper) {
        var recId = component.get("v.recordId");
        var invoiceLanguage = component.get("v.invoice.Language__c");
        component.set("v.showMsg", true);
        let toastMessageSuccess= {
            title: "Success!",
            message: '',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        };

        let toastMessageError= {
            title: "Error!",
            message: '',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        };
        var action = component.get("c.executeActivitiesOnInvoice");
        
        action.setParams({ invoiceId:recId, language:invoiceLanguage });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('########### ' + state);
            console.log('########### ' + response.getReturnValue());
            
            if (state === "SUCCESS") {
                
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                if (response.getReturnValue()!=="success"){
                    toastMessageError.message="Error message: " + response.getReturnValue();
                    toastEvent.setParams(toastMessageError);
                    toastEvent.fire();
                } else {
                    toastMessageSuccess.message="Success message: " + response.getReturnValue();
                    toastEvent.setParams(toastMessageSuccess);
                    toastEvent.fire();
                }
                
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        toastMessageError.message="Error message: " + errors[0].message;
                        toastEvent.setParams(toastMessageError);
                        toastEvent.fire();
                    }
                } else {
                    toastMessageError.message="Unknow error. Please contact your admin ";
                    toastEvent.setParams(toastMessageError);
                    toastEvent.fire();
                }
            }
        });

        $A.enqueueAction(action);

        
        
    },
    handleCancel : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})