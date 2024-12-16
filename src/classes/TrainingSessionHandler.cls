/**Purpose:Tasks To Perform DML operations, Retrieval of records and Insert, Update Deletion of Records .

Created by: Rahul Sharma
    
Created Date : 27-11-24
    
Rivision Log: V:1.1

Code Coverage : 89 % (33/37)
    
 **/
// Apex Trigger/Framework Assignment
public class TrainingSessionHandler extends TriggerHandler {
    // Static class variables for trigger context
    private static List<Attendee__c> newListOfAttendee;
    private static Map<Id, Attendee__c> oldMapOfAttendee;
    private static Map<Id, Attendee__c> newMapOfAttendee;

    // Constructor to initialize trigger context variables
    public TrainingSessionHandler() {
        newListOfAttendee = (List<Attendee__c>) Trigger.new;
        oldMapOfAttendee = (Map<Id, Attendee__c>) Trigger.oldMap;
        newMapOfAttendee = (Map<Id, Attendee__c>) Trigger.newMap;
    }

    // BEFORE INSERT Trigger Handler Logic
    public override void beforeInsert() {
        // Logic for before insert can be added here, if needed
    }

    // AFTER INSERT Trigger Handler Logic
    public override void afterInsert() {
        // Pass both parameters: newList and null for the oldMap
        updateContactSessionCounts(newListOfAttendee, null);
    }

    // BEFORE UPDATE Trigger Handler Logic
    public override void beforeUpdate() {
        // Logic for before update can be added here, if needed
    }

    // AFTER UPDATE Trigger Handler Logic
    public override void afterUpdate() {
        // Pass both parameters: newList and oldMap
        updateContactSessionCounts(newListOfAttendee, oldMapOfAttendee);
    }

    // BEFORE DELETE Trigger Handler Logic
    public override void beforeDelete() {
        // Logic for before delete can be added here, if needed
    }

    // AFTER DELETE Trigger Handler Logic
    public override void afterDelete() {
        // Pass only oldMap for delete (since no new records exist during delete)
        updateContactSessionCounts(null, oldMapOfAttendee);
    }

    // AFTER UNDELETE Trigger Handler Logic
    public override void afterUndelete() {
        // Logic for after undelete can be added here, if needed
    }

    // Method to update Contact session counts
    public static void updateContactSessionCounts(List<Attendee__c> newList, Map<Id, Attendee__c> oldMap) {
        Set<Id> contactIds = new Set<Id>();

        // Collect Contact IDs from newly inserted or updated Attendees
        if (newList != null) {
            for (Attendee__c att : newList) {
                if (att.Contact__c != null) {
                    contactIds.add(att.Contact__c);
                }
            }
        }

        // Collect Contact IDs from old map (if deleting or updating records)
        if (oldMap != null) {
            for (Attendee__c att : oldMap.values()) {
                if (att.Contact__c != null) {
                    contactIds.add(att.Contact__c);
                }
            }
        }

        // Return early if no contact IDs are found
        if (contactIds.isEmpty()) {
            return;
        }

        // Aggregate query to count sessions for each contact
        Map<Id, Integer> contactSessionCounts = new Map<Id, Integer>();

        // Perform an aggregate query to count the number of sessions attended by each contact
        AggregateResult[] sessionCounts = [
            SELECT Contact__c, COUNT(Id) totalSessions
            FROM Attendee__c
            WHERE Contact__c IN :contactIds
            GROUP BY Contact__c
        ];

        // Store the session counts in a map
        for (AggregateResult ar : sessionCounts) {
            contactSessionCounts.put((Id) ar.get('Contact__c'), (Integer) ar.get('totalSessions'));
        }

        // Prepare list of Contacts to update
        List<Contact> contactsToUpdate = new List<Contact>();

        // Create Contact records with updated session counts (Number__c field)
        for (Id contactId : contactSessionCounts.keySet()) {
            Contact contact = new Contact(
                Id = contactId,
                Number__c = contactSessionCounts.get(contactId) // Update the Number__c field with session count
            );
            contactsToUpdate.add(contact);
        }

        // Perform the update on the Contact records if there are any to update
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}