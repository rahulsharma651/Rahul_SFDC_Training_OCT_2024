trigger ContactTrigger on Contact (before insert, after insert , before update, after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            TriggerContactHandler.domainCheck(Trigger.New,Trigger.oldMap);
        }
        if(Trigger.isUpdate){
            TriggerContactHandler.domainCheck(Trigger.New,Trigger.oldMap);
        }
    }
    if(Trigger.isAfter){
        
    }
}