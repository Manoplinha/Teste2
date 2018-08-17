public with sharing class TW1_Ancar_Handler_NotaFiscalParticipante	implements ITrigger
{	
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    // Construtor
    public TW1_Ancar_Handler_NotaFiscalParticipante(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void bulkBefore()
    {
        
    }
    
    public void bulkAfter()
    {
    }
    
    public void beforeInsert(SObject so)
    {	
        TW1_Ancar_NotaFiscal_Participante_cls.processoParticipante((NTFS__c) so);
	}
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {

    }
    
    public void beforeDelete(SObject so)
    {	
        
    }
    
    public void afterInsert(SObject so)
    {	
        //Contact acc = (Contact)so;
        //TW1_Sinc_Google_com_ContaHandler.CriaAccount(acc);
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    public void OnUndelete(SObject restoredSObject){
    }
    
    
    public void andFinally()
    {
        
    }

}