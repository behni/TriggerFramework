public without sharing class TriggerHandler {
      public enum TriggerEvent {
            beforeInsert,
            beforeUpdate,
            beforeDelete,
            beforeUndelete,
            afterInsert,
            afterUpdate,
            afterDelete,
            afterUndelete
      }

      private String sObjectType;      
      private List<IProcess> processList;
      private TriggerQuery queryConfiguration;
      private static Set<String> executedClasses;      

      static {
            executedClasses = new Set<String>();
      }

      public TriggerHandler(String sObjectType) {
          system.debug(sObjectType);
            this.sObjectType = sObjectType;
            this.queryConfiguration = new TriggerQuery();
            this.processList = new List<IProcess>();
      }

      public void manage() {
          	String event = getEvent();
            system.debug('Event: ' + event);
            List<TriggerDefinition__mdt> foundTriggers = queryConfiguration.getTrigger(sObjectType, event);
            if(foundTriggers != null) {
                  for(TriggerDefinition__mdt def : foundTriggers) {
                   IProcess process = getInstance(def);
                   if(process != null) {
                         if(!executedClasses.contains(def.ApexClassName__c)) {
                               processList.add(process);
                               if(!def.acceptReentrancy__c) {
                                    executedClasses.add(def.ApexClassName__c);
                               }
                         }
                   }
                  }
            }
            forward(event);
            finish();
      }

      private void forward(String event) {
            List<SObject> newScope = Trigger.new;
            List<SObject> oldScope = Trigger.old;
            Map<Id, SObject> oldMap = Trigger.oldMap;
            Map<Id, SObject> newMap = Trigger.newMap;
            for(IProcess process : processList) {
                  process.setNew(newScope, newMap);
                  process.setOld(oldScope, oldMap);
                  process.setEvent(event);
                  try {
                   process.scope();
                   process.run();
                  } catch (Exception ex) {
                   ExceptionHandler errorHandler = new ExceptionHandler();
                   errorHandler.addDebugInfo(ex);
                   errorHandler.push();
                  } finally {
                   newScope = process.returnScope();
                   oldScope = process.returnOldScope();
                   oldMap = process.returnOldScopeMap();
                   newMap = process.returnScopeMap();
                  }
            }
      }

      private void finish() {
            processList.clear();
      }

      private String getEvent() {
            TriggerEvent evt;

            if(Trigger.isBefore) {
                  if(Trigger.isInsert) {
                   evt = TriggerEvent.beforeInsert;
                  } else if(Trigger.isUpdate) {
                   evt = TriggerEvent.beforeUpdate;
                  } else if(Trigger.isDelete) {
                   evt = TriggerEvent.beforeDelete;
                  } 
            } else if(Trigger.isAfter) {
                  if(Trigger.isInsert) {
                   evt = TriggerEvent.afterInsert;
                  } else if(Trigger.isUpdate) {
                   evt = TriggerEvent.afterUpdate;
                  } else if(Trigger.isDelete) {
                   evt = TriggerEvent.afterDelete;
                  } else if(Trigger.isUndelete) {
                   evt = TriggerEvent.afterUndelete;
                  }
            }

            String eventname;
            if(evt != null) {
                  eventname = evt.name();
            }

            return eventname;
      }

      private IProcess getInstance(TriggerDefinition__mdt t) {
            IProcess instance;
            try {
                  instance = (IProcess) System.Type.forName(t.ApexClassName__c).newInstance();
            } catch (Exception ex) {
                   ExceptionHandler errorHandler = new ExceptionHandler();
                   errorHandler.addDebugInfo(ex);
                   errorHandler.push();
            }

            return instance;
      }

}
