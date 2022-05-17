trigger triggerOnLead on Lead (After insert,Before Insert) {
    TextLocalMessageonLeadCreation handler = new TextLocalMessageonLeadCreation();
    if(Trigger.isInsert && Trigger.isAfter){
        handler.leadInsert(Trigger.new);
        handler.assignLead(Trigger.new);
    } 
    if(Trigger.isInsert && Trigger.isbefore){
        handler.updateCompanyBeforeInsert(Trigger.new);
    } 
}