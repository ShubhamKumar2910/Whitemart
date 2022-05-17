trigger TriggerOnAccount on Account (after update) {
    
    if(trigger.isafter){
        if(trigger.isupdate){
            AccountTriggerHandler.UpdateTaskSubjectOnFieldUpdate(Trigger.OldMap, Trigger.NewMap);
        }
    }

}