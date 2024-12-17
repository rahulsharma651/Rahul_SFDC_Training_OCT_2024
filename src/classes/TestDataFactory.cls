public class TestDataFactory {
    
    // Create a list of 20 test contacts
    public static List<Contact> createContacts() {
        List<Contact> contacts = new List<Contact>();
        try {
            Integer count = 20;
            for (Integer i = 1; i <= count; i++) {
                Contact con = new Contact(
                    LastName = 'Test' + i,
                    Email = i + '@abcd.com'
                );
                contacts.add(con);
            }
            insert contacts;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return contacts;
    }

    // Create a single test contact
    public static Contact createContact() {
        Contact con = new Contact(LastName = 'Test');
        try {
            insert con;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return con;
    }

    // Create a training session
    public static Training_Session__c createTrainingSession() {
        Training_Session__c session = new Training_Session__c(Name__c = 'TestSession');
        try {
            insert session;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return session;
    }

    // Create attendees for a given contact and session
    public static List<Attendee__c> createAttendees(Contact con, Training_Session__c session, Integer count) {
        List<Attendee__c> attendees = new List<Attendee__c>();
        try {
            for (Integer i = 0; i < count; i++) {
                Attendee__c attendee = new Attendee__c(Contact__c = con.Id, Attendee_Count_Lookup__c = session.Id);
                attendees.add(attendee);
            }
            insert attendees;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return attendees;
    }

    // Create a map of old attendees for update tests
    public static Map<Id, Attendee__c> createOldMap(List<Attendee__c> attendees) {
        Map<Id, Attendee__c> oldMap = new Map<Id, Attendee__c>();
        try {
            for (Attendee__c attendee : attendees) {
                Attendee__c oldAttendee = new Attendee__c(Id = attendee.Id, Contact__c = attendee.Contact__c);
                oldMap.put(oldAttendee.Id, oldAttendee);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return oldMap;
    }

    // Method to simulate deletion of a non-existent record
    public static void deleteNonExistentRecord() {
        try {
            // Attempt to delete a non-existent attendee record
            delete [SELECT Id FROM Attendee__c WHERE Id = '001000000000000AAA'];
        } catch (DmlException e) {
            System.debug('Expected exception: ' + e.getMessage());
            System.assert(e.getMessage().contains('attempting to delete a non-existent record'), 'Expected DmlException when deleting a non-existent record');
        }
    }
}