/**Purpose:Tasks To Perform DML operations, Retrieval of records and Insert, Update Deletion of Records .

Created by: Rahul Sharma
    
Created Date : 27-11-24
    
Rivision Log: V:1.1
    
 **/
// Assignment 1-Scenario1-Task1
public class TrainingSessionManager {
    
    
    public enum SessionType {WEBINAR,WORKSHOP,SEMINAR}
    
    /**
 * 
 *   @description    :   Method to insert Training_Session__c records.
 *
 *   @args           :   string NameInsert
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 27/11/2024 - Developer Name - Rahul Sharma
 *		        
 * 
 **/
    public static void create() {try{
            Training_Session__c Tss1 = new Training_Session__c(Name__c = 'Vaibhav', Location__c = 'US');
            insert Tss1;
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
    }
    
    // Method to get a Training Session record by its Name field
    
    
    /**
 * 
 *   @description    :   Method to delete Training_Session__c records.
 *
 *   @args           :   string NameToDelete
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 28/11/2014 - Developer Name - Rahul Sharma
 *		       
 * 
 **/

    public void getSessionByName() {
        try{
            List<Training_Session__c> results = [SELECT Id, Name__c, Location__c 
                                             FROM Training_Session__c 
                                             ];
            System.debug(results);
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        
    }
    /**
 * 
 *   @description    :  Method to delete Training_Session__c records.
 *
 *   @args           :   string NameToUpdate
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 07/08/2024 - Developer Name - Rahul Sharma
 *		        
 * 
 **/

    public static void UpdateRecords(string NameToUpdate){try{
            list<Training_Session__c> UpdateList = new list<Training_Session__c>();
            UpdateList = [SELECT Id ,Name__c , Location__c FROM Training_Session__c WHERE Name__c=:NameToUpdate LIMIT 1];
            for(Training_Session__c Tr : UpdateList){
                Tr.Name__c='trainingSession2';
            }
            update UpdateList;
            System.debug(UpdateList);
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
    }
    /**
 * 
 *   @description    :   Description of the method
 *
 *   @args           :   
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 01/12/2024 - Developer Name - Rahul Sharma
 *		      
 * 
 **/

    public void DeleteRecord(string RecordToBeDeleted){
        list<training_Session__c> Del = [SELECT Id, Name__c ,  Location__c FROM Training_Session__c WHERE Name__c=: RecordToBeDeleted LIMIT 1];
        delete Del;
        System.debug(Del);
    }
    //Assignment1-Scenario1-task2
    /**
 * 
 *   @description    :   Implement a method to add attendees to a training session, 
 *                       ensuring that each attendee is only added once using a Set<Id>
 *
 *   @args           :   string Attendee, string TrainingSession
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 30/11/2024 - Developer Name - Rahul Sharma
 *		        :    V1.2 - Modified - 01/12/2024 - Developer Name - Rahul Sharma
 * 
 **/

    public static void AttendeeAdd(string Attendee, string TrainingSession){
        try{
            List<Attendee__c> allAttendeeList = [SELECT Id FROM Attendee__c WHERE Name__c=:Attendee];
            Id AttendeeId = AllAttendeeList[0].Id;
            list<Training_Session__c> TrainingSessionList = [SELECT Id FROM Training_Session__c WHERE Name__c = :TrainingSession LIMIT 1];
            Id sessionId = trainingSessionList[0].Id;
            
          
            List<Attendee__c> existingAttendees = [SELECT Name__c FROM Attendee__c WHERE Attendee_Count_Lookup__r.Id = :sessionId];
            Set<String> existingAttendeeNames = new Set<String>();
            for (Attendee__c existingAttendee : existingAttendees)
            { existingAttendeeNames.add(existingAttendee.Name__c); }
            if(!existingAttendeeNames.contains(Attendee)){
                Attendee__c ToAddAttendee = new Attendee__c();
                ToAddAttendee.Name__c = Attendee;
                ToAddAttendee.Attendee_Count_Lookup__c = sessionId;
                
                insert ToAddAttendee;
            }
            if(existingAttendeeNames.contains(Attendee)){
                
            }
            
            System.debug(TrainingSessionList);
           
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
    }}
  // Assignment1-Scenario1-Task3
   /**
 * 
 *   @description    :   Use of Enum within a method
 *
 *   @args           :   List<Training_Session__c> sessions
 *
 *   @return         :   
 *
 *   @revision Log   :   V1.1 - Created  - 01/12/2024 - Developer Name - Rahul Sharma
 *		        
 * 
 **/

    public static void categorizeTrainingSessions(List<Training_Session__c> sessions) {
        try{
        for (Training_Session__c session : sessions) {
            if (session.Name.contains('Webinar')) {
                session.Session_Type__c = SessionType.WEBINAR.name();
            } else if (session.Name.contains('Workshop')) {
                session.Session_Type__c = SessionType.WORKSHOP.name();
            } else if (session.Name.contains('Seminar')) {
                session.Session_Type__c = SessionType.SEMINAR.name();
            } else {
                session.Session_Type__c = 'OTHER';
            }
        }
        update sessions;
        }catch(Exception e){e.getmessage();}
    }

    
    
    /**
 * 
 *   @description    :   Document how the safe navigation operator improves the robustness of your code.
 *
 *   @args           :   SessionName
 *
 *   @return         :   AttendeeSet
 *
 *   @revision Log   :   V1.1 - Created  - 01/12/2024 - Developer Name - Rahul Sharma
 *		        
 * 
 **/
    public static Set<Attendee__c> Testing(string SessionName){
        try{
            list<Training_Session__c> Session = new list<Training_Session__c>();
            Session = [SELECT Id FROM Training_Session__c WHERE Name__c=:SessionName LIMIT 1];
            string TSessionId = Session[0].Id;
            list<Attendee__c> AttendeeRecords = [SELECT Name__c , Id FROM Attendee__c WHERE Attendee_count_Lookup__r.Id =: TSessionId ];
            Set<Attendee__c> AttendeeSet = new set<Attendee__c>();
            for(Attendee__c att : AttendeeRecords){
                AttendeeSet.add(att);
            }
            
            return AttendeeSet?.isEmpty() == True ? AttendeeSet : new Set<Attendee__c>();
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            return new Set<Attendee__c>();
        }
    }
    //Assignment1-Scenario2-Task1
    /**
 * 
 *   @description    :   Document how the safe navigation operator improves the robustness of your code.
 *
 *   @args           :   
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 01/12/2024 - Developer Name - Rahul Sharma
 *		        
 * 
 **/

    public static void NavigaterTest(){
        try{
        List<Training_Session__c> SessionList = new List<Training_Session__c>();
        SessionList = [SELECT Id, Name, Name__c, Location__c FROM Training_Session__c];
        
        List<String> Attendee = new List<String>();
        
  
        for(Training_Session__c ts: SessionList){
            
            String AttendeeString = ts?.Location__c;
            Attendee.add(AttendeeString);
            
            
        }
      System.debug(Attendee);  
    }catch (Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            
        }
    }
    // Assignment 1-Scenario-3-Task-1
    /**
 * 
 *   @description    :   Description of the method
 *
 *   @args           :   
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 01/12/2024 - Developer Name - Rahul Sharma
 *		        
 * 
 **/

    public static Map<String, String> getTrainingSessionsWithAttendees() {
        try {
            Map<String, String> allRecords = new Map<String, String>();
            List<Training_Session__c> trainingSessions = new List<Training_Session__c>();
            trainingSessions = [SELECT Id, Name__c FROM Training_Session__c];
            
            List<Attendee__c> attendeeRecords = new List<Attendee__c>();
            for (Training_Session__c ts : trainingSessions) {
                attendeeRecords = [SELECT Id, Name__c, Email__c, Phone__c FROM Attendee__c WHERE Attendee_Count_Lookup__r.Id = :ts.Id];
                
                system.debug(attendeeRecords);
                
                String attendeeDetails = '';
                for (Attendee__c ac : attendeeRecords) {
                    attendeeDetails += 'Name: ' + ac.Name__c + ', Email: ' + ac.Email__c + ', Phone: ' + ac.Phone__c + '; ';
                }
                allRecords.put(ts.Name__c, attendeeDetails);
            }
            
            System.debug(allRecords);
            return allRecords;
            
        } catch (Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            
            return new Map<String, String>();
        }
    }
     
    





    // Assignment-1-Scenario-3-Task-2
    /**
 * 
 *   @description    :   Perform DML operations (insert, update, delete) on Training_Session__c records within
 *                       the TrainingSessionManager class.Handle exceptions gracefully and log any errors.
 *
 *   @args           :   sessionName
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 07/08/2017 - Developer Name - Rahul Sharma
 *		        
 * 
 **/

    public static void insertTrainingSession(String sessionName) {
        try {
            Training_Session__c newSession = new Training_Session__c(Name__c = sessionName);
            insert newSession;
            System.debug('Training Session Inserted: ' + newSession.Id);
        } catch (DmlException e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
    /**
 * 
 *   @description    :   method to Add Training Session Records.
 *
 *   @args           :   sessionName, NewName
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 07/08/2024 - Developer Name - rahul Sharma
 *		          
 * 
 **/

    public static void updateTrainingSession(String sessionName, String newName) {
        try {
            Training_Session__c sessionToUpdate = [SELECT Id, Name__c FROM Training_Session__c WHERE Name__c = :sessionName LIMIT 1];
            sessionToUpdate.Name__c = newName;
            update sessionToUpdate;
            System.debug('Training session updated successfully: ' + sessionToUpdate.Id);
        } catch (QueryException qe) {
            System.debug('No training session found with the name: ' + sessionName);
        } catch (DmlException de) {
            System.debug('An error occurred while updating the training session: ' + de.getMessage());
        } catch (Exception e) {
            System.debug('An unexpected error occurred: ' + e.getMessage());
        }
    }
    /**
 * 
 *   @description    :   Methd to delete Training Session Records.
 *
 *   @args           :   sessionName
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 07/08/2017 - Developer Name - Rahul Sharma
 *		        :   
 * 
 **/

    public static void deleteTrainingSession(String sessionName) {
        try {
            Training_Session__c sessionToDelete = [SELECT Id FROM Training_Session__c WHERE Name__c = :sessionName LIMIT 1];
            delete sessionToDelete;
            System.debug('Training session deleted successfully: ' + sessionToDelete.Id);
        } catch (QueryException qe) {
            System.debug('No training session found with the name: ' + sessionName);
        } catch (DmlException de) {
            System.debug('Error occured while deleting Record ' + de.getMessage());
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    /**
 * 
 *   @description    :   Perform DML operations (insert, update, delete) on Training_Session__c records within the TrainingSessionManager class.
 *                       Handle exceptions gracefully and log any errors.
 *
 *   @args           :   attendeesToInsert, attendeesToUpdate, attendeesToDelete
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 07/08/2017 - Developer Name - Rahul Sharma
 *		            
 * 
 **/

    public static void manageAttendees(List<Attendee__c> attendeesToInsert, List<Attendee__c> attendeesToUpdate, List<Attendee__c> attendeesToDelete) {
        try {
            if (!attendeesToInsert.isEmpty()) {
                insert attendeesToInsert;
                System.debug('Attendees inserted successfully.');
            }
            
            if (!attendeesToUpdate.isEmpty()) {
                update attendeesToUpdate;
                System.debug('Attendees updated successfully.');
            }
            
            if (!attendeesToDelete.isEmpty()) {
                delete attendeesToDelete;
                System.debug('Attendees deleted successfully.');
            }
        } catch (DmlException e) {
            System.debug(e.getMessage());
        }
    }
    // Assignment-2-Scenario-1-Task-1
    
    
    /**
 * 
 *   @description    :   Create custom labels for session types and use them in your Apex class methods to generate messages.
 *
 *   @args           :   sessionType
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 01/12/2024 - Developer Name - Comment
 *		        :    
 * 
 **/

    public static String generateSessionMessage(String sessionType) {
        String sessionTypeLabel;
        
        // Determine the appropriate label based on the session type
        if (sessionType == 'Webinar') {
            sessionTypeLabel = System.Label.SessionType_Webinar;
        } else if (sessionType == 'Workshop') {
            sessionTypeLabel = System.Label.SessionType_Workshop;
        }
        
        
        String message = 'You have selected a ' + sessionTypeLabel + ' session.';
        System.debug(message);
        return message;
    }
    /**
 * 
 *   @description    :   Write complex SOQL queries to fetch training sessions
 *                       based on specific criteria such as date, type, and attendee count.

 *
 *   @args           :   specificDate, specificType
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 07/08/2017 - Developer Name - Comment
 *		        :    V1.2 - Modified - 05/08/2018 - Developer Name - Comment
 * 
 **/

    public static void ComplexQuery(Date specificDate, String specificType) {
    Integer minimumAttendeeCount = 1;
    List<AggregateResult> complexQuery = [SELECT Attendee_Count_Lookup__c, COUNT(Id) Total_Attendee__c
                                          FROM Attendee__c
                                          WHERE Attendee_Count_Lookup__c IN (SELECT Id
                                                                             FROM Training_Session__c
                                                                             WHERE Session_Date__c = :specificDate
                                                                             AND Session_type__c = :specificType)
                                          GROUP BY Attendee_Count_Lookup__c
                                          HAVING COUNT(Id) > :minimumAttendeeCount];

    for (AggregateResult ar : complexQuery) {
        System.debug('Training Session ID: ' + ar.get('Attendee_Count_Lookup__c') + ', Total Attendees: ' + ar.get('Total_Attendee__c'));
    }
}
/**
 * 
 *   @description    :   Implement bulk insert, update, and delete operations using  Database.update() with the allOrNone parameter set to false.

 *
 *   @args           :   specificDate, specificType
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 073/12/2024 - Developer Name - Rahul Sharma
 *		        
 * 
 **/
   public static void bulkInsert(List<SObject> recordsToInsert) {
    try {
        Database.SaveResult[] insertResults = Database.insert(recordsToInsert, false);
        for (Database.SaveResult sr : insertResults) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted record ID: ' + sr.getId());
            } else {
                for (Database.Error error : sr.getErrors()) {
                    System.debug('Error inserting record: ' + error.getMessage());
                }
            }
        }
    } catch (DmlException e) {
        System.debug('A DML exception occurred: ' + e.getMessage());
    } catch (Exception e) {
        System.debug('An unexpected exception occurred: ' + e.getMessage());
    }
}
/**
 * 
 *   @description    :    Implement bulk insert, update, and delete operations using  Database.update() with the allOrNone parameter set to false.
 *
 *   @args           :   List<SObject> recordsToUpdate,String Email
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 03/12/2024 - Developer Name - Rahul Sharma
 *		        :    
 * 
 **/

    public static void bulkUpdate(List<SObject> recordsToUpdate,String Email) {
        try{
            
            for(SObject obj : recordsToUpdate){
                {
                Attendee__c at = (Attendee__c)obj;
                at.Phone__c = Email ;
                }
        Database.SaveResult[] updateResults = Database.update(recordsToUpdate, false);
        for (Database.SaveResult sr : updateResults) {
            if (sr.isSuccess()) {
                System.debug('Successfully updated record ID: ' + sr.getId());
            } else {
                for (Database.Error error : sr.getErrors()) {
                    System.debug('Error updating record: ' + error.getMessage());
                }
            }
        }}
        }catch (DmlException e) {
        System.debug('A DML exception occurred: ' + e.getMessage());
    } catch (Exception e) {
        System.debug('An unexpected exception occurred: ' + e.getMessage());
    }     
    }
/**
 * 
 *   @description    :    Implement bulk delete operations using Database.delete()
 *                        with the allOrNone parameter set to false.
 *
 *   @args           :   
 *
 *   @return         :   void
 *
 *   @revision Log   :   V1.1 - Created  - 03/12/2024 - Developer Name - Rahul Sharma
 *		        :  
 * 
 **/

    public static void bulkDelete(List<SObject> recordsToDelete) {
        try{
        Database.DeleteResult[] deleteResults = Database.delete(recordsToDelete, false);
        for (Database.DeleteResult dr : deleteResults) {
            if (dr.isSuccess()) {
                System.debug('Successfully deleted record ID: ' + dr.getId());
            } else {
                for (Database.Error error : dr.getErrors()) {
                    System.debug('Error deleting record: ' + error.getMessage());
                }
            }
        }}
        catch (DmlException e) {
        System.debug('A DML exception occurred: ' + e.getMessage());
    } catch (Exception e) {
        System.debug('An unexpected exception occurred: ' + e.getMessage());
    }
    }   
}