public class OrderTriggerHandler {
    
    public static void CreateTaskOnOrderCreation(List<order> orderList){
        list<Task> taskList = new list<Task>();
        if(!orderList.isempty()){
            for(order ord : orderList){
                Task tas = new task();
                tas.Subject = 'Happy Call';
                tas.WhatId = ord.AccountId;
                tas.WhoId = ord.account.ownerId;
                tas.ActivityDate = system.today() + 2;
                taskList.add(tas);
            }
        }
        insert taskList;
    }
}