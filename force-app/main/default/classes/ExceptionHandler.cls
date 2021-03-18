public class ExceptionHandler {

  private List<DebugData> listDebugData;

  public ExceptionHandler() {
    listDebugData = new List<DebugData>();
  }

  public void addDebugInfo(Exception ex) {
    DebugData dd = new DebugData(ex);
    listDebugData.add(dd);
  }

  public void push() {
    List<TriggerDebug__c> debugInfos = new List<TriggerDebug__c>();
    for(DebugData dd : listDebugData) {
      TriggerDebug__c di = new TriggerDebug__c();
      di.Message__c = dd.message;
      di.StackTrace__c = dd.stackTrace;
      di.LineNumber__c = dd.lineNumber;
      di.ExceptionType__c = dd.exceptionType;
      debugInfos.add(di);
    }
    if(!debugInfos.isEmpty()) {
      INSERT debugInfos;
      listDebugData.clear();
    }
  }

  public class DebugData {
    public String message{get; private set;}
    public String exceptionType{get; private set;}
    public Integer lineNumber{get; private set;}
    public String stackTrace{get; private set;}

    public DebugData(Exception ex) {
      this.message = ex.getMessage();
      this.exceptionType = ex.getTypeName();
      this.lineNumber = ex.getLineNumber();
      this.stackTrace = ex.getStackTraceString();
    }
  }

  public class ApexException extends Exception{}
}