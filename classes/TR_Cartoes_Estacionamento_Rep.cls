public class TR_Cartoes_Estacionamento_Rep {
    public List<TW1_Cartoes_Estacionamento__c> GetCartoesExpirados()
    {
        return [SELECT id
				FROM TW1_Cartoes_Estacionamento__c 
				where TW1_Data_fim__c < Today
                AND TW1_Status__c != 'Inativo'
                LIMIT 1000];
    }
}