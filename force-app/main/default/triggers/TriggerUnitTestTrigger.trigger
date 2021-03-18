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