public virtual class TriggerHandler {
    // Static map of handler name and loop count
    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;
    
    // The current context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext context;
    
    // Indicates if the trigger is executing
    @TestVisible
    private Boolean isTriggerExecuting;

    // Static initialization
    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
    }
    
    // Constructor
    public TriggerHandler() {
        this.setTriggerContext();
    }
    
    /***************************************
    * Public instance methods
    ***************************************/
    
    // Main method that will be called during execution
    public void run() {
        if (!validateRun()) {
            return;
        }
        addToLoopCount();
        
        // Dispatch to the correct handler method based on the context
        switch on this.context {
            when BEFORE_INSERT {
                this.beforeInsert();
            }
            when BEFORE_UPDATE {
                this.beforeUpdate();
            }
            when BEFORE_DELETE {
                this.beforeDelete();
            }
            when AFTER_INSERT {
                this.afterInsert();
            }
            when AFTER_UPDATE {
                this.afterUpdate();
            }
            when AFTER_DELETE {
                this.afterDelete();
            }
            when AFTER_UNDELETE {
                this.afterUndelete();
            }
        }
    }
    
    // Set max loop count for the handler
    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }
    
    // Clear the max loop count
    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }
    
    /***************************************
    * Public static methods
    ***************************************/
    
    // Bypass handler
    public static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }
    
    // Clear bypass for a handler
    public static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }
    
    // Check if handler is bypassed
    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }
    
    // Clear all bypasses
    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }
    
    /***************************************
    * Private instance methods
    ***************************************/
    
    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {
        if (!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        } else {
            this.isTriggerExecuting = true;
        }

        // Set the trigger context based on the conditions
        if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
            (ctx != null && ctx == 'before insert')) {
            this.context = TriggerContext.BEFORE_INSERT;
        } else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
                   (ctx != null && ctx == 'before update')) {
            this.context = TriggerContext.BEFORE_UPDATE;
        } else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
                   (ctx != null && ctx == 'before delete')) {
            this.context = TriggerContext.BEFORE_DELETE;
        } else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
                   (ctx != null && ctx == 'after insert')) {
            this.context = TriggerContext.AFTER_INSERT;
        } else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
                   (ctx != null && ctx == 'after update')) {
            this.context = TriggerContext.AFTER_UPDATE;
        } else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
                   (ctx != null && ctx == 'after delete')) {
            this.context = TriggerContext.AFTER_DELETE;
        } else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
                   (ctx != null && ctx == 'after undelete')) {
            this.context = TriggerContext.AFTER_UNDELETE;
        }
    }

    // Increment the loop count
    @TestVisible
    private void addToLoopCount() {
        String handlerName = getHandlerName();
        if (TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
            if (exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' +
                    String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }

    // Make sure this trigger should continue to run
    @TestVisible
    private Boolean validateRun() {
        if (!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        return !TriggerHandler.bypassedHandlers.contains(getHandlerName());
    }

    // Get the handler name (based on the class name)
    @TestVisible
    private String getHandlerName() {
        System.debug('handler name' + this.toString());
        return this.toString().substringBefore(':');
    }

    /***************************************
    * Context-specific methods for override
    ***************************************/
    
    @TestVisible
    protected virtual void beforeInsert() {}
    @TestVisible
    protected virtual void beforeUpdate() {}
    @TestVisible
    protected virtual void beforeDelete() {}
    @TestVisible
    protected virtual void afterInsert() {}
    @TestVisible
    protected virtual void afterUpdate() {}
    @TestVisible
    protected virtual void afterDelete() {}
    @TestVisible
    protected virtual void afterUndelete() {}

    /***************************************
    * Inner classes
    ***************************************/
    
    // Inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {
        private Integer max;
        private Integer count;

        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }

        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }

        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }

        public Boolean exceeded() {
            return this.max >= 0 && this.count > this.max;
        }

        public Integer getMax() {
            return this.max;
        }

        public Integer getCount() {
            return this.count;
        }

        public void setMax(Integer max) {
            this.max = max;
        }
    }

    // Enum for possible trigger contexts
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
        AFTER_UNDELETE
    }

    // Exception class
    public class TriggerHandlerException extends Exception {}
}