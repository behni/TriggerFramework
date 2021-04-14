# Aspect Oriented Trigger Framework in Salesforce
## Install the application:
====================================
 
<a href="https://githubsfdeploy.herokuapp.com?owner=behni&amp;repo=TriggerFramework">
  <img src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png" alt="Deploy to Salesforce" />
</a>

## Intruduction
The framework provides an easy configuration of your companies trigger environments. It solves all best practice pattern and gives the developer an easy possibility, to add business logic to the environment over simple configuration. The only think which the developer must make sure is to add the trigger for the particular object with all events, pass the handler class and implement the business logic in an separate apex class, which implements the handler interface. The developer has then the possibility, to control all the trigger logic of the custom metadata, which needs the class name of the apex class and the object name. The complete event configuration is happening then over custom metadata.

## Summary
This framework provides an easy way to handle the complete apex trigger environment in Salesforce over custom objects. The framework handles all best practises, which are recommended by Salesforce:
* best practise trigger framework
* one trigger per object
* business logic can be abstracted in an own layer
* configure all events over a custom object (insert, update, delete, undelete)
* configure context over custom object (before, after)
* configure reentrancy over custom object
* control order of execution
* control reentrancy of trigger
* quick adding possibility of code while runtime (also remove)

## How to use
Define a trigger for the object with all operations and pass the sObject Name:
```java
trigger TriggerUnitTestTrigger on TriggerUnitTest__c (
  before insert, 
  before update, 
  before delete, 
  after insert, 
  after update, 
  after delete, 
  after undelete) {

  TriggerHandler manager = new TriggerHandler('TriggerUnitTest__c');
  manager.manage();
}
```

Implement the business logic and pass it to the framework.
To access records in after context (also before update), use newList or newMap, for example:
```java
public class TriggerUnitTestAfter extends Process {
  public override IProcess run() {
    //call business logic here
    cloneItem();
  
    return this;
  }
  
  private void cloneItem() {
    //holds the after context records and records in before update in a list
    List<TriggerUnitTest__c> newObjList = (List<TriggerUnitTest__c>) newList;

    //holds ther after context and before update records in a map
    Map<Id, TriggerUnitTest__c> newObjMap = (Map<Id, TriggerUnitTest__c>) newMap;
      
    TriggerUnitTest__c cloneItem = newObjList.get(0).clone();
    INSERT cloneItem;
  }
}
```
Consider that newMap is only available in before update, after insert, after update, and after undelete triggers.

To access records in before context, use newList or newMap to assign records and oldList and oldMap to fetch before records in an after context or before update, for example:
```java
public class TriggerUnitTestBefore extends Process {
  public override IProcess run() {
    //call business logic here
    setBefore();
  
    return this;
  }
  
  private void setBefore() {
    //holds before update and after context trigger records in a list
    List<TriggerUnitTest__c> oldObjList = (List<TriggerUnitTest__c>) oldList;
      
    //holds before records in a map (only possible for after triggers and before update triggers)
    Map<Id, TriggerUnitTest__c> oldObjMap = (Map<Id, TriggerUnitTest__c>) oldMap;
      
    //sets records in before context to be avaliable in new context (in before context only newList/newMap)
    for(TriggerUnitTest__c record : (List<TriggerUnitTest__c>) newList) {
        record.BeforeCheck__c = true;
    }
  }
}
```
Consider that oldMap is only available in update and delete triggers.

You can also read out the event directly in the handler class to dispatch related behaviours:

```java
public class TriggerUnitTestBefore extends Process {
  public override IProcess run() {
    system.debug(event);
    
    /* String which contains either
    * beforeInsert, beforeUpdate, beforeDelete
    * afterInsert, afterUpdate, afterDelete, afterUndelete
    * please consider the strings are case sensitive
    *
    */
  
    return this;
  }
}
```

Create a new record under custom Metadata Trigger Definitions:
* Class Name: TriggerUnitTestAfter
* Object: TriggerUnitTest__c
* Set the context (before/after)
* Set the event over the checkbox
* Set the order, let it on 1 if no order execution is necessary
* When the trigger is allewd to reantrance, set the checkbox to allow it
* Activate the trigger with the active checkbox
