public class CalendarController {
  @AuraEnabled
    public static list<Event> getAllEvents(){
       //Getting all the events
      list<Event> eventlist =[Select id,whoid, EndDateTime,StartDateTime,Subject from Event where ownerId=:Userinfo.getUserId()] ;
      return eventlist;
    }
    
}