@isTest
public class ScheduleCallHistoryDetails_Test {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    public static testmethod void testCallHistoryschedule(){
        Test.setMock(HttpCalloutMock.class, new CallHistorycalloutMock());
        Test.startTest();
        String jobId = System.schedule('CallHistoryScheduledApexTest',CRON_EXP, new ScheduleCallHistoryDetails());   

        Test.stopTest();    
    }


}