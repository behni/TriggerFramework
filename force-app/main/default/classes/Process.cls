public abstract with sharing class Process implements IProcess {
      public List<SObject> newList{get;set;}
      public List<SObject> oldList;
      
      public Map<ID, SObject> newMap{get;set;}
      public Map<ID, SObject> oldMap;

      public void setNew(List<SObject> scope, Map<Id, SObject> scopeMap) {
          this.newList = scope;
          this.newMap = scopeMap;	
      }
        
      public void setOld(List<SObject> scope, Map<Id, SObject> scopeMap) {
      	  this.oldList = scope;
          this.oldMap = scopeMap;
      }
      public abstract IProcess run();

      public virtual void scope() {}

      public virtual List<SObject> returnScope() {
          return newList;
      }
}
