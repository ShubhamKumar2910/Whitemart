global class ScheduleWSInventoryDetails implements Schedulable{
    global void execute(SchedulableContext SC) {
        DateTime dt= date.today();
        system.enqueueJob(New GetWondersoftInventory(dt.format('YYYY-MM-dd'),dt.format('YYYY-MM-dd')));
    }
}