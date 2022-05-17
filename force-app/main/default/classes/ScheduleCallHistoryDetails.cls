global class ScheduleCallHistoryDetails implements Schedulable{
    global void execute(SchedulableContext SC) {
        DateTime dt= date.today();
        system.enqueueJob(New GetCallHistoryDetails(dt.format('YYYY-MM-dd'),dt.format('YYYY-MM-dd')));
    }
}