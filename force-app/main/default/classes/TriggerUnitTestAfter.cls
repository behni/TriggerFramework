public class TriggerUnitTestAfter extends Process {
    public override IProcess run() {
        //call business logic here
        cloneItem();
    
        return this;
    }
    
    private void cloneItem() {
        List<TriggerUnitTest__c> objList = (List<TriggerUnitTest__c>) newList;
        Map<Id, TriggerUnitTest__c> objMap = (Map<Id, TriggerUnitTest__c>) newMap;
            
        TriggerUnitTest__c cloneItem = objList.get(0).clone();
        INSERT cloneItem;
    }
}