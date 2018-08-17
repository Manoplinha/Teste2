public class TR_Cartoes_Estacionamento_App {
    TR_Cartoes_Estacionamento_Rep cartaoEstacRepository = new TR_Cartoes_Estacionamento_Rep();
    
    /// Método para atualizar cartao de estacionamento que está expirado
    public void AtualizaCartoesEstacionamento()
    {        
        List<TW1_Cartoes_Estacionamento__c> listaCartaoEstac = cartaoEstacRepository.GetCartoesExpirados();
        Anc_Utils_cls.LogToSystemDebug('Cartoes retornado ' + listaCartaoEstac);
     
        for(TW1_Cartoes_Estacionamento__c item : listaCartaoEstac)
        {
            Anc_Utils_cls.LogToSystemDebug('modificou o status para inativo ');
            item.TW1_Status__c = 'Inativo';
        }
        
        update listaCartaoEstac;
        Anc_Utils_cls.LogToSystemDebug('Lista atualizada ' + listaCartaoEstac);
    }
}