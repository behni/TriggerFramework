public class TriggerQuery {
      public List<TriggerDefinition__mdt> getTrigger(String sObjectType, String eventName) {
            List<TriggerDefinition__mdt> triggers;
            String filter;
            if(String.isNotBlank(eventname)) {
                  if(eventName.containsIgnoreCase('before')) {
                        if(eventName.containsIgnoreCase('insert')) {
                              filter = 'Context__c = \'before\' AND isInsert__c = true';
                        } else if(eventName.containsIgnoreCase('update')) {
                              filter = 'Context__c = \'before\' AND isUpdate__c = true';
                        } else if(eventName.containsIgnoreCase('delete')) {
                              filter = 'Context__c = \'before\' AND isDelete__c = true';
                        }
                  } else if(eventName.containsIgnoreCase('after')) {
                        if(eventName.containsIgnoreCase('insert')) {
                              filter = 'Context__c = \'after\' AND isInsert__c = true';
                        } else if(eventName.containsIgnoreCase('update')) {
                              filter = 'Context__c = \'after\' AND isUpdate__c = true';
                        } else if(eventName.containsIgnoreCase('undelete')) {
                              filter = 'Context__c = \'after\' AND isUndelete__c = true';
                        } else if(eventName.containsIgnoreCase('delete')) {
                              filter = 'Context__c = \'after\' AND isDelete__c = true';
                        }
                  }

                  String orderBy = ' ORDER BY Order_Number__c ASC';
                  String query = 'Select Id, ApexClassName__c, acceptReentrancy__c FROM TriggerDefinition__mdt WHERE isActive__c = true AND ObjectName__c = :sObjectType AND ' + filter + orderBy;

                  try {
                        triggers = (List<TriggerDefinition__mdt>) Database.query(query);
                  } catch (Exception e) {
                        System.debug('Trigger not found: ' + sObjectType);
                  }
            }

            return triggers;
      }
}
