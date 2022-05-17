public class ScoreCardTriggerHelper {
    
    public static void beforeInsert(List<Scorecard__c> newList,List<Scorecard__c> oldList)
    {
        Set<Id> accountIds = new Set<Id>();
        for(Scorecard__c sc : newList){
            if(sc.Enabled__c == true){
                accountIds.add(sc.Id);
            }
        }
        List<Scorecard__c> ListTobeUpdated = [select id,Enabled__C from Scorecard__c where Enabled__C = true AND ID NOT IN:accountIds];
        for(Scorecard__c sc:ListTobeUpdated){
            sc.Enabled__C=false;
        }
        system.debug('ListTobeUpdated'+ListTobeUpdated);
        update ListTobeUpdated;
    }
    
}