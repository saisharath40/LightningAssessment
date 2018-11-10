trigger EventTrigger on Event (after insert,after update,before insert, before update) {
    if(Trigger.isAfter){
       EventTriggerHandler.sendEmail(Trigger.new);    
    }
    else if(Trigger.isBefore){
        EventTriggerHandler.checkMeetingTime(Trigger.new); 
    }
}