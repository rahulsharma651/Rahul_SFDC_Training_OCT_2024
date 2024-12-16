public class TriggerContactHandler{
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