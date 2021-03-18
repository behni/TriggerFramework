@isTest
public class ExceptionHandlerTest {
    static testMethod void insertError() {
        Test.startTest();
        try {
            Account a = new Account();
            UPDATE a;
        } catch(Exception ex) {
         	ExceptionHandler errorHandler = new ExceptionHandler();
        	errorHandler.addDebugInfo(ex);
        	errorHandler.push();   
        }
        Test.stopTest();
        
        List<TriggerDebug__c> debugs = [Select id From TriggerDebug__c];
        system.assert(debugs.size() > 0);
    }
}