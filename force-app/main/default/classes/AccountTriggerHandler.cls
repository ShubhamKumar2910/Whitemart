public class AccountTriggerHandler {
    
    Public static void UpdateTaskSubjectOnFieldUpdate(Map<id, Account> AccountOldmap, Map<id, Account> AccountNewMap){
        
        Set<Id> AccountIdsListToFetchTask = new Set<Id>();
        Set<Id> taskIdsListToupdate = new Set<Id>();
        if(!AccountNewMap.isEmpty()){
            for(Account acc : AccountNewMap.values()){
                if(acc.Next_Purchase_Date__c != Null && acc.Next_Purchase_Date__c != AccountOldmap.get(acc.Id).Next_Purchase_Date__c){
                    AccountIdsListToFetchTask.add(acc.Id);
                }
            }
            
            List<Task> TaskListToUpdate = [Select id, Subject, whoId, WhatId, ActivityDate From Task Where WhatId IN :AccountIdsListToFetchTask ];
            
            List<Task> taskListToBeUpdated = new List<task>();
            if(!TaskListToUpdate.isEmpty()){
                For(Task tas : TaskListToUpdate){
                    if(tas.Subject == 'Happy Call'){
                        tas.Status = 'Completed';
                        taskListToBeUpdated.add(tas);
                    }
                }
            }
            update taskListToBeUpdated;
        }
        
    }

}