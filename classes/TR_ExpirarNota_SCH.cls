global without sharing class TR_ExpirarNota_SCH implements Schedulable{
    global TR_ExpirarNota_SCH() {
    } 
    
    global void execute(SchedulableContext paSchedulableContext) { 
        Anc_ScheaduleUtils_cls.abortScheadule(paSchedulableContext);  
        executeJob();
    }
    
    @future
    private static void executeJob(){
        
        Anc_Utils_cls.LogToSystemDebug('Inicio do processamento TR_ExpirarNota_SCH.executeJob');
        try 
        {  
            // get data 
            system.debug('');
            Anc_Utils_cls.LogToSystemDebug('obtendo dados...');
            new TR_NotaApp().VerificarExpiracaoNota(); 
            Anc_Utils_cls.LogToSystemDebug('processando informação...');
        }
        catch(Anc_Utils_cls.Cal_Exception e)
        {   
            System.debug('TR_ExpirarNota_SCH.executeJob error: ' + e.getMessage()); 
        }
        finally{
            if(!Test.isRunningTest())
                scheaduleJobAgain();
        }  
        Anc_Utils_cls.LogToSystemDebug('Fim do processamento executeJob.executeJob');
    }
    
    private static void scheaduleJobAgain(){
        //Produção
        Anc_ScheaduleUtils_cls.scheadule('TR_ExpirarNota_SCH', DateTime.now().addMinutes(480));
    }
}