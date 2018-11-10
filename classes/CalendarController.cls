public class CalendarController {
  @AuraEnabled
    public static list<Event> getAllEvents(){
      list<Event> eventlist =[Select id,whoid, EndDateTime,StartDateTime,Subject from Event where createdById=:Userinfo.getUserId()] ;
      return eventlist;
    }
    
}