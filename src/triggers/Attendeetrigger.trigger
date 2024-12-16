trigger Attendeetrigger on Attendee__c (after insert, after update, after delete, after undelete) {
    New trainingSessionHandler().run();
}