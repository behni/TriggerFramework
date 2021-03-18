public class TriggerHandler {
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
            this.sObjectType = sObjectType;
            this.queryConfiguration = new TriggerQuery();
            this.processList = new List<IProcess>();
      }

      public void manage() {
            List<TriggerDefinition__mdt> foundTriggers = queryConfiguration.getTrigger(sObjectType, getEvent());
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
            forward();
            finish();
      }

      private void forward() {
            List<SObject> newScope = Trigger.new;
            for(IProcess process : processList) {
                  process.setNew(newScope, Trigger.newMap);
                  process.setOld(Trigger.old, Trigger.oldMap);
                  try {
                   process.scope();
                   process.run();
                  } catch (Exception ex) {
                   ExceptionHandler errorHandler = new ExceptionHandler();
                   errorHandler.addDebugInfo(ex);
                   errorHandler.push();
                  } finally {
                   newScope = process.returnScope();
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