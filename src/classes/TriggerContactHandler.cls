/**Purpose:Tasks To Validate  domain of Contact with the Account Domain.

Created by: Rahul Sharma
    
Created Date : 12-12-24
    
Rivision Log: V:1.0

Code Coverage : 94 % (17/18)
    
 **/

// Apex Trigger/Framework Assignment

public class TriggerContactHandler extends TriggerHandler{
    private static List<Contact__c> newListOfContact;
    private static Map<Id, Contact__c> oldMapOfContact;
    private static Map<Id, Contact__c> newMapOfContact;

    // Constructor to initialize trigger context variables
    public TrainingSessionHandler() {
        newListOfContact = (List<Contact__c>) Trigger.new;
        oldMapOfContact = (Map<Id, Contact__c>) Trigger.oldMap;
        newMapOfContact = (Map<Id, Contact__c>) Trigger.newMap;
    }

    // BEFORE INSERT Trigger Handler Logic
    public override void beforeInsert() {
       
    }

    // AFTER INSERT Trigger Handler Logic
    public override void afterInsert() {
        
        
    }

    // BEFORE UPDATE Trigger Handler Logic
    public override void beforeUpdate() {
        
    }

    // AFTER UPDATE Trigger Handler Logic
    public override void afterUpdate() {
       
    }

    // BEFORE DELETE Trigger Handler Logic
    public override void beforeDelete() {
        // Logic for before delete can be added here, if needed
    }

    // AFTER DELETE Trigger Handler Logic
    public override void afterDelete() {
        // Pass only oldMap for delete (since no new records exist during delete)
        
    }

    // AFTER UNDELETE Trigger Handler Logic
    public override void afterUndelete() {
       
    }

    /**Purpose:Tasks To Validate  domain of Contact with the Account Domain.

Created by: Rahul Sharma
    
Created Date : 12-12-24
    
Rivision Log: V:1.0

 **/
    public static void domainCheck(List<Contact> contactList, Map<Id,Contact> oldMap){
        try{
        Set<Id> IdSet =New Set<Id>();
        for(Contact con : contactList){
            IdSet.add(con.AccountId);
        }
        List<Account> accountList = [SELECT Id, Domain__c FROM Account WHERE Id IN :IdSet];
        Map<Id , Account> AccountMap = New Map<Id,Account>();
        for(account ac : accountList){
            AccountMap.put((Id)(ac.Id), (Account)(ac) );
            
        }
        if (!accountMap.isEmpty()) {
    for (Contact con : contactList) {
        if (con.Email != null && con.AccountId != null) {
            Account acc = accountMap.get(con.AccountId);
            if (acc != null && acc.Domain__c != null) {
                String[] emailParts = con.Email.split('@');
                if (emailParts.size() > 1 && emailParts[1].equals(acc.Domain__c)) {
                    
                } else {
                   
                    con.addError('The email domain must match the Account domain.');
                }
            }
        }
    }
}
        }catch(Exception e){
            System.debug(e.getMessage());
            
        }

        }
    }