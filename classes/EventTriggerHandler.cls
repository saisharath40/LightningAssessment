public class EventTriggerHandler {
    public static void sendEmail(List<Event> eventsList){
       if(eventsList!=null && eventsList.size()>0){
           List<Event> eventsToBeProcessed=new List<Event>();
           Set<Id> contactIds=new Set<Id>();
            for(Event e:eventsList){
                if(e.whoId!=null){
                    eventsToBeProcessed.add(e);
                    contactIds.add(e.whoId);
                }
            }
           List<Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();
           Map<Id,Contact> contactsMap=new Map<Id,Contact>([Select id,firstName,lastname,email from Contact where ID in: contactIds]);
           for (Event e :eventsToBeProcessed) {
              Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
              List<String> sendTo = new List<String>();
              sendTo.add(contactsMap.get(e.whoId).email);
              mail.setToAddresses(sendTo);
              mail.setReplyTo('sharath.sai12@gmail.com');
              mail.setSenderDisplayName('Joe');
              mail.setSubject('Meeting Appointment');
              Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.filename = 'meeting.ics';
                    attach.ContentType = 'text/calendar;';
                    attach.inline = true;
                    attach.body=invite(e.StartDateTime,e.EndDateTime,contactsMap.get(e.whoId).Email);
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
                    String body = 'Dear ' +contactsMap.get(e.whoId).FirstName + ' '+contactsMap.get(e.whoId).LastName+' ,';
                    body+=' \n'+' Your Appointment with Joe is Scheduled .For more details, please logon to Salesforce' ;
              mail.setHtmlBody(body);
              mails.add(mail);
              
        }
        Messaging.sendEmail(mails);
       }
    }
    
     public static Blob invite(Datetime startTime, DateTime endTime,String recipient){
        //Invite message for Appointment
        String nowString = '';
        System.debug(startTime+' '+endTime);
        Datetime nowDT = Datetime.now();
        nowString += nowDT.year();
        nowString += ('0' + nowDT.month()).right(2);
        nowString += ('0' + nowDT.day()).right(2);
        nowString += 'T';
        nowString += ('0' + nowDT.hour()).right(2);
        nowString += ('0' + nowDT.minute()).right(2);
        nowString += ('0' + nowDT.second()).right(2);
        nowString += 'Z';
            
        String startString = '';
        startString += startTime.year();
        startString += ('0' + startTime.month()).right(2);
        startString += ('0' + startTime.day()).right(2);
        startString += 'T';
        startString += ('0' + startTime.hour()).right(2);
        startString += ('0' + startTime.minute()).right(2);
        startString += ('0' + startTime.second()).right(2);
       	startString += 'Z';
    
        String endString = '';
        endString += endTime.year();
        endString += ('0' + endTime.month()).right(2);
        endString += ('0' + endTime.day()).right(2);
        endString += 'T';
        endString += ('0' + endTime.hour()).right(2);
        endString += ('0' + endTime.minute()).right(2);
        endString += ('0' + endTime.second()).right(2);
        endString += 'Z';
        //endString+='+05:30';
        String txtInvite = '';
        txtInvite += 'BEGIN:VCALENDAR\n';
        txtInvite += 'PRODID:-//Google Inc//Google Calendar 70.9054//EN\n';
        txtInvite += 'VERSION:2.0\n';
        txtInvite += 'CALSCALE:GREGORIAN\n';
        txtInvite += 'METHOD:REQUEST\n';
        txtInvite += 'BEGIN:VEVENT\n';
        txtInvite += 'DTSTART:' +startString  + '\n';
        txtInvite += 'DTEND:' + endString + '\n';
        txtInvite += 'DTSTAMP:' + startString+ '\n';
        txtInvite += 'ORGANIZER;CN=' + UserInfo.getUserName() + ':MAILTO:' + UserInfo.getUserEmail() + '\n';
        txtInvite += 'ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=\n';
        txtInvite += ' TRUE;X-NUM-GUESTS=0:mailto:' + recipient + '\n';
        txtInvite += 'CREATED:' + nowString + '\n';
        txtInvite += 'LAST-MODIFIED:' + nowString + '\n';
        txtInvite += 'LOCATION:ONLINE\n';
        txtInvite += 'STATUS:CONFIRMED\n';
        txtInvite += 'SUMMARY: Meeting Invite with ' + recipient + '\n';
        txtInvite += 'TRANSP:OPAQUE\n';
        txtInvite += 'END:VEVENT\n';
        txtInvite += 'END:VCALENDAR\n';
        return Blob.valueOf(txtInvite);
    }
    
    public static void checkMeetingTime(List<Event> eventList){
        if(eventList!=null && eventList.size()>0){
            for(Event e:eventList){
                System.debug(e.StartDateTime+' '+e.EndDateTime+' '+DateTime.now());
                if(e.StartDateTime < DateTime.now() || e.EndDateTime < DateTime.now()){
                    e.addError('Event Start DateTime & End DateTime should be in the future only');
                }  
            }   
        } 
    }
}