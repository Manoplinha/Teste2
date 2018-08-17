public class TR_NotaApp {
    /// Método para verificar se a nota está expirada, passou 90 dias da nota
    public void VerificarExpiracaoNota()
    {
        TR_Historico_Rep historicoRepository = new TR_Historico_Rep();
        List<TW1_Historico__c> listaHistorico = historicoRepository.GetHistoricocExpiradoEmDias(90);
        Anc_Utils_cls.LogToSystemDebug('Histórico retornado ' + listaHistorico);
        for(TW1_Historico__c item : listaHistorico)
        {
            item.TW1_Status__c = 'Expirada';
        }
        
        update listaHistorico;
        Anc_Utils_cls.LogToSystemDebug('Lista atualizada ' + listaHistorico);
    }
}