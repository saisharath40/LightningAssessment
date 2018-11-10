@RestResource(urlMapping='/Events/*')
global with sharing class EventConfirmCancel {
    @HttpPatch
    global static ID updateCaseFields() {
        RestRequest request = RestContext.request;
        String confirmParam=RestContext.request.params.get('Confirm');
        String eventId='';
        if(request.requestURI.contains('?')){
            eventId = request.requestURI.substring(
        	request.requestURI.lastIndexOf('/')+1,request.requestURI.lastIndexOf('?'));
        }
        Event myEvent = [SELECT Id,Confirm__c FROM Event WHERE Id = :eventId];
        if(confirmParam!=null ){
            if ( confirmParam == 'Yes'){
                myEvent.Confirm__c=true;
            }else if(confirmParam == 'No' ){
                myEvent.Confirm__c=false;
            }
        }
        update myEvent;
        return myEvent.Id;
    }    
}