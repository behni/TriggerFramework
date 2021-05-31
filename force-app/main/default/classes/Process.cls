public abstract with sharing class Process implements IProcess {
      public List<SObject> newList{get;set;}
      public List<SObject> oldList{get;set;}
      
      public Map<ID, SObject> newMap{get;set;}
      public Map<ID, SObject> oldMap{get;set;}
    
      public String event;

      public void setNew(List<SObject> scope, Map<Id, SObject> scopeMap) {
          this.newList = scope;
          this.newMap = scopeMap;	
      }
        
      public void setOld(List<SObject> scope, Map<Id, SObject> scopeMap) {
      	  this.oldList = scope;
          this.oldMap = scopeMap;
      }
    
      public void setEvent(String event) {
      	  this.event = event;  
      }
      
      public abstract IProcess run();

      public virtual void scope() {}

      public virtual List<SObject> returnScope() {
          return newList;
	  }
    
      public virtual Map<Id, SObject> returnScopeMap() {
          return newMap;
	  }
    
      public virtual List<SObject> returnOldScope() {
          return oldList;
	  }
    
      public virtual Map<Id, SObject> returnOldScopeMap() {
          return oldMap;
	  }
}
