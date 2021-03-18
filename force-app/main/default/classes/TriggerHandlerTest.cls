@isTest
public class TriggerHandlerTest {
    static testMethod void afterAndBeforeInsert() {
		TriggerUnitTest__c uTest = new TriggerUnitTest__c();
        
        Test.startTest();
        INSERT uTest;
        Test.stopTest();
        
        List<TriggerUnitTest__c> records = [Select Id From TriggerUnitTest__c WHERE BeforeCheck__c = true];
        system.assertEquals(2, records.size());
    }
    
    static testMethod void afterAndBeforeUpdate() {
		TriggerUnitTest__c uTest = new TriggerUnitTest__c();
        INSERT uTest; 
        
        Test.startTest();
		UPDATE uTest;
        Test.stopTest();
        
        List<TriggerUnitTest__c> records = [Select Id From TriggerUnitTest__c];
        system.assertEquals(2, records.size());
    }
    
    static testMethod void afterAndBeforeDelete() {
		TriggerUnitTest__c uTest = new TriggerUnitTest__c();
        INSERT uTest;
        
        Test.startTest();
        DELETE uTest;
        Test.stopTest();
        
        List<TriggerUnitTest__c> records = [Select Id From TriggerUnitTest__c];
        system.assertEquals(1, records.size());
    }
    
    static testMethod void afterAndBeforeUndelete() {
		TriggerUnitTest__c uTest = new TriggerUnitTest__c();
        INSERT uTest;
        DELETE uTest;
        
        Test.startTest();
		UNDELETE uTest;
        Test.stopTest();
        
        List<TriggerUnitTest__c> records = [Select Id From TriggerUnitTest__c];
        system.assertEquals(2, records.size());
    }
}