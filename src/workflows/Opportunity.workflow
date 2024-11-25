<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Declined</fullName>
        <description>Approval Declined</description>
        <protected>false</protected>
        <recipients>
            <recipient>rahul.sharma@fexle.com.training.prod</recipient>
            <type>user</type>
        </recipients>
        
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Discount_Approved1</template>
    </alerts>
    <alerts>
        <fullName>Notify_Submitter_of_Discount_Request_Approval</fullName>
        <ccEmails>rahul.sharma@fexle.com</ccEmails>
        <description>Notify Submitter of Discount Request Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Discount_Approved1</template>
    </alerts>
    <fieldUpdates>
        <fullName>Checked_Discount_box</fullName>
        <field>Discount_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Checked Discount box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OA_Opportunity_Approval</fullName>
        <field>Discount_Approved__c</field>
        <literalValue>0</literalValue>
        <name>OA Opportunity Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Discount_Approved_Checkbox</fullName>
        <field>Discount_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Set Discount Approved Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
