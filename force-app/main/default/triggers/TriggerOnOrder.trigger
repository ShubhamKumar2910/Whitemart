trigger TriggerOnOrder on Order (after insert) {
    
    if(trigger.isAfter){
        if(trigger.isinsert){
            OrderTriggerHandler.CreateTaskOnOrderCreation(trigger.new);
        }
    }

}