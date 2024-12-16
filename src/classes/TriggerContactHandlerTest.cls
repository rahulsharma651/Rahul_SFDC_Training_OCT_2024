@isTest
public class TriggerContactHandlerTest {
    private static Set<Id> contactIds = new Set<Id>();

    public static void setUpTestdata() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            Account acc = new Account(Name = 'Test' + i, Domain__c = 'example.com');
            accounts.add(acc);
        }
        insert accounts;

        List<Contact> contactList = new List<Contact>();
        for (Account acc : accounts) {
            Contact con = new Contact(LastName = 'Test' + acc.Name, AccountId = acc.Id, Email = 'user@example.com');
            contactList.add(con);
        }
        insert contactList;

        Account mismatchedAccount = new Account(Name = 'Mismatch', Domain__c = 'wrongdomain.com');
        insert mismatchedAccount;
        Contact mismatchContact = new Contact(LastName = 'Mismatch', AccountId = mismatchedAccount.Id, Email = 'user@example.com');
        insert mismatchContact;

        contactIds.addAll(new Map<Id, Contact>(contactList).keySet());
        contactIds.add(mismatchContact.Id);
    }

    @isTest
    public static void testTriggerContactHandler() {
        setUpTestdata();

        List<Contact> contactList = [SELECT Id, LastName, Email, AccountId FROM Contact WHERE Id IN :contactIds];
        Map<Id, Contact> oldMap = new Map<Id, Contact>([SELECT Id, LastName, Email, AccountId FROM Contact WHERE Id IN :contactIds]);

        Test.startTest();
        triggerContactHandler.domainCheck(contactList, oldMap);
        Test.stopTest();

        List<Contact> resultContacts = [SELECT Id, Email FROM Contact WHERE Id IN :contactIds];
        System.assertEquals(6, resultContacts.size(), 'Expected 6 contacts');
        System.assertEquals('user@example.com', resultContacts[0].Email, 'Expected Email to be user@example.com');
    }

    @isTest
    public static void testTriggerContactHandlerNegative() {
        setUpTestdata();

        // Add a Contact with a mismatched email domain
        Account acc = [SELECT Id, Name, Domain__c FROM Account WHERE Domain__c = 'wrongdomain.com' LIMIT 1];
        Contact invalidContact = new Contact(LastName = 'Mismatch', AccountId = acc.Id, Email = 'user@wrongdomain.com');
        insert invalidContact;
        contactIds.add(invalidContact.Id);

        List<Contact> contactList = [SELECT Id, LastName, Email, AccountId FROM Contact WHERE Id IN :contactIds];
        Map<Id, Contact> oldMap = new Map<Id, Contact>([SELECT Id, LastName, Email, AccountId FROM Contact WHERE Id IN :contactIds]);

        Test.startTest();
        try {
            triggerContactHandler.domainCheck(contactList, oldMap);
            update invalidContact; 
            System.assert(false, 'Expected DmlException for mismatched domain but none was thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The email domain must match the Account domain'), 'Expected domain mismatch error but got: ' + e.getMessage());
        }
        Test.stopTest();
    }
}