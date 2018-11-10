({
	loadDataToCalendar :function(component,data){  
        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaMonth'
            },
            editable: true,
            allDaySlot: false,
            events:data,
            eventClick: function(event, jsEvent, view) {
              var editRecordEvent = $A.get("e.force:editRecord");
              editRecordEvent.setParams({
              "recordId": event.id
            });
               editRecordEvent.fire();
           },
            dayClick :function(dt, jsEvent, view) { 
              var selectedDate =new Date(dt);
              var datetime = new Date(Date.UTC(selectedDate.getUTCFullYear(),selectedDate.getUTCMonth(),selectedDate.getUTCDate(),selectedDate.getUTCHours(),selectedDate.getUTCMinutes(),0,0));
              console.log(datetime);
              var createRecordEvent = $A.get("e.force:createRecord");
              var splitUrl=window.window.location.pathname.split("/");
              var whoId='';
              if(splitUrl!=null && splitUrl.length==6){
                   whoId=splitUrl[4];
              }
              console.log(whoId);
              createRecordEvent.setParams({
                    "entityApiName": "Event",
                    "defaultFieldValues": {
                    	'StartDateTime' :  datetime,
                        'Subject':'Meeting',
                        'WhoId':whoId
                }
                });
    			createRecordEvent.fire();
          },
    });
    },
       
    
    formatFullCalendarData : function(component,events) {
        var jsonDataArray = [];
        for(var i = 0;i < events.length;i++){
            console.log(events[i].StartDateTime+' '+events[i].StartDateTime);
            jsonDataArray.push({
                'title':events[i].Subject,
                'start':events[i].StartDateTime,
                'end':events[i].EndDateTime,
                'id':events[i].Id
            });
        }
      
        return jsonDataArray;
    },
     
    fetchCalenderEvents : function(component) {
         var action=component.get("c.getAllEvents");
         action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data= response.getReturnValue();
                var jsonArr = this.formatFullCalendarData(component,response.getReturnValue());
                component.set("v.Objectlist",jsonArr);
                 this.loadDataToCalendar(component,jsonArr);
           
            } else if (state === "ERROR") {
                                 
            }
        });
        
        $A.enqueueAction(action);
       
    }, 

})