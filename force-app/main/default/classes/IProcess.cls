public interface IProcess {
    IProcess run();
    void scope();
    List<SObject> returnScope();
    List<SObject> returnOldScope();
    Map<Id, SObject> returnScopeMap();
    Map<Id, SObject> returnOldScopeMap();

    void setNew(List<SObject> scope, Map<Id, SObject> scopeMap);
    void setOld(List<SObject> scope, Map<Id, SObject> scopeMap);
    void setEvent(String event);
}
