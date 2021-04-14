public interface IProcess {
    IProcess run();
    void scope();
    List<SObject> returnScope();

    void setNew(List<SObject> scope, Map<Id, SObject> scopeMap);
    void setOld(List<SObject> scope, Map<Id, SObject> scopeMap);
    void setEvent(String event);
}
