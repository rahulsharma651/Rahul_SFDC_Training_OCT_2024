/**Purpose: Creation of test class to Write down a trigger to roll up and calculate the 
 * Count of Trigger Session attended by the Contact.
 * 
 * Created by: Rahul Sharma
 * Created Date: 14-12-2024
 * Revision Log: V:1.1
 **/
// Assignment 
@isTest
public class TrainingSessionHandlerTest {

    private static Set<Id> contactIds = new Set<Id>();
    private static List<Contact> contacts = new List<Contact>();
    private static Training_Session__c testSession;
    
    @TestSetup
    public static void setUpTestData() {
        try {
            // Create test data for contacts and training session
            contacts = TestDataFactory.createContacts();
            testSession = TestDataFactory.createTrainingSession();

            // Create attendees for the first contact
            List<Attendee__c> attendees = TestDataFactory.createAttendees(contacts[0], testSession, 10);
            for (Attendee__c att : attendees) {
                contactIds.add(att.Contact__c);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

    // Insert Scenarios
    @isTest
    public static void testSingleInsert() {
        Contact con = contacts[0];
        Attendee__c attendee = new Attendee__c(Contact__c = con.Id, Attendee_Count_Lookup__c = testSession.Id);

        Test.startTest();
        insert attendee; // This triggers beforeInsert and afterInsert
        Test.stopTest();

        // Verify that the Contact session count is updated
        Contact updatedContact = [SELECT Id, Number__c FROM Contact WHERE Id = :con.Id];
        System.assertEquals(1, updatedContact.Number__c, 'Expected session count to be updated to 1 after inserting attendee');
    }

    @isTest
    public static void testBulkInsert() {
        List<Attendee__c> attendees = new List<Attendee__c>();
        Contact con = contacts[0];
        for (Integer i = 0; i < 200; i++) {
            attendees.add(new Attendee__c(Contact__c = con.Id, Attendee_Count_Lookup__c = testSession.Id));
        }

        Test.startTest();
        insert attendees; // This triggers beforeInsert and afterInsert
        Test.stopTest();

        // Verify that the Contact session count is updated to 200
        Contact updatedContact = [SELECT Id, Number__c FROM Contact WHERE Id = :con.Id];
        System.assertEquals(200, updatedContact.Number__c, 'Expected session count to be updated to 200 after inserting 200 attendees');
    }

    // Update Scenarios
    @isTest
    public static void testSingleRecordUpdate() {
        List<Attendee__c> attendees = [SELECT Id, Contact__c FROM Attendee__c LIMIT 1];
        Attendee__c attendee = attendees[0];
        attendee.Contact__c = contacts[1].Id; // Update the contact of the attendee

        Test.startTest();
        update attendee; // This triggers beforeUpdate and afterUpdate
        Test.stopTest();

        // Verify that the second contact's session count is updated
        Contact updatedContact = [SELECT Id, Number__c FROM Contact WHERE Id = :contacts[1].Id];
        System.assertEquals(1, updatedContact.Number__c, 'Expected session count to be updated to 1 for the second contact');
    }

    @isTest
    public static void testBulkUpdate() {
        List<Attendee__c> attendees = [SELECT Id, Contact__c FROM Attendee__c];
        for (Attendee__c attendee : attendees) {
            attendee.Contact__c = contacts[1].Id; // Update all attendees' contact
        }

        Test.startTest();
        update attendees; // This triggers beforeUpdate and afterUpdate
        Test.stopTest();

        // Verify that the second contact's session count is updated
        Contact updatedContact = [SELECT Id, Number__c FROM Contact WHERE Id = :contacts[1].Id];
        System.assertEquals(10, updatedContact.Number__c, 'Expected session count to be updated to 10 for the second contact after bulk update');
    }

    // Delete Scenarios
    @isTest
    public static void testSingleRecordDelete() {
        List<Attendee__c> attendees = [SELECT Id FROM Attendee__c LIMIT 1];
        delete attendees; // This triggers beforeDelete

        Test.startTest();
        delete attendees; // This triggers afterDelete
        Test.stopTest();

        // Verify the attendee was deleted
        List<Attendee__c> remainingAttendees = [SELECT Id FROM Attendee__c WHERE Id = :attendees[0].Id];
        System.assertEquals(0, remainingAttendees.size(), 'Expected attendee to be deleted');

        // Verify the contact's session count is updated after delete
        Contact updatedContact = [SELECT Id, Number__c FROM Contact WHERE Id = :attendees[0].Contact__c];
        System.assertEquals(9, updatedContact.Number__c, 'Expected session count to be updated to 9 after deleting an attendee');
    }

    @isTest
    public static void testBulkDelete() {
        List<Attendee__c> attendees = [SELECT Id FROM Attendee__c];
        delete attendees; // This triggers beforeDelete

        Test.startTest();
        delete attendees; // This triggers afterDelete
        Test.stopTest();

        // Verify all attendees were deleted
        List<Attendee__c> remainingAttendees = [SELECT Id FROM Attendee__c];
        System.assertEquals(0, remainingAttendees.size(), 'Expected all attendees to be deleted');

        // Verify the contact's session count is updated after delete
        Contact updatedContact = [SELECT Id, Number__c FROM Contact WHERE Id = :contacts[0].Id];
        System.assertEquals(0, updatedContact.Number__c, 'Expected session count to be updated to 0 after deleting all attendees');
    }

    // Test afterUndelete scenario
    @isTest
    public static void testAfterUndelete() {
        // Step 1: Delete an Attendee record
        Attendee__c attToDelete = [SELECT Id FROM Attendee__c LIMIT 1];
        delete attToDelete;

        // Verify the record is deleted
        List<Attendee__c> deletedAttendees = [SELECT Id FROM Attendee__c WHERE Id = :attToDelete.Id];
        System.assertEquals(0, deletedAttendees.size(), 'Expected the attendee to be deleted.');

        // Step 2: Now undelete the same Attendee record
        undelete attToDelete; // This triggers afterUndelete

        // Step 3: Verify that afterUndelete logic was executed by checking any changes
        Attendee__c undeletedAttendee = [SELECT Id, Contact__c, Attendee_Count_Lookup__c FROM Attendee__c WHERE Id = :attToDelete.Id];

        // Assert that the record is undeleted
        System.assertNotEquals(null, undeletedAttendee, 'The attendee should be undeleted.');
        
        // Assuming afterUndelete logic includes updating the session count
        Contact relatedContact = [SELECT Id, Number__c FROM Contact WHERE Id = :undeletedAttendee.Contact__c];
        System.assertNotEquals(null, relatedContact.Number__c, 'The related contact session count should be updated after undelete.');
    }

    // Test afterUpdate scenario
    @isTest
    public static void testAfterUpdate() {
        List<Attendee__c> attendees = [SELECT Id FROM Attendee__c];
        Attendee__c attendeeToUpdate = attendees[0];

        // Step 1: Update the attendee record
        attendeeToUpdate.Contact__c = contacts[1].Id; // Change Contact__c to trigger afterUpdate logic

        Test.startTest();
        update attendeeToUpdate; // This triggers afterUpdate
        Test.stopTest();

        // Step 2: Verify that the `updateContactSessionCounts` method in afterUpdate was called
        Contact updatedContact = [SELECT Id, Number__c FROM Contact WHERE Id = :contacts[1].Id];
        System.debug('Updated Contact: ' + updatedContact);

        // Example assertion: Check if the session count has been updated
        System.assertNotEquals(null, updatedContact.Number__c, 'The session count on the Contact should be updated.');
    }

}