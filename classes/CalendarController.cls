public class CalendarController {
  @AuraEnabled
    public static list<Event> getAllEvents(){
      list<Event> eventlist =[Select id,whoid, EndDateTime,StartDateTime,Subject from Event where ownerId=:Userinfo.getUserId()] ;
      return eventlist;
    }
    
}