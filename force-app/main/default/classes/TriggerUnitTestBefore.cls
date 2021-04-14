public class TriggerUnitTestBefore extends Process {
      public override IProcess run() {
            //call business logic here
            setBefore();
          
            system.debug(event); //--> String result: beforeInsert
      
            return this;
      }

      private void setBefore() {
            //holds before records in a List
            List<TriggerUnitTest__c> objList = (List<TriggerUnitTest__c>) oldList;
                  
            //holds before records in a map
            Map<Id, TriggerUnitTest__c> objMap = (Map<Id, TriggerUnitTest__c>) oldMap;
                  
            //sets records in before context to be avaliable in new context
            for(TriggerUnitTest__c record : (List<TriggerUnitTest__c>) newList) {
                              record.BeforeCheck__c = true;
            }
      }
}
