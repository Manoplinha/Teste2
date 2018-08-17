public with sharing class TW1_Ancar_NotaFiscal_Participante_cls {
	
    public static void processoParticipante(NTFS__c Ntfs)
    {
        recordtype vaRecordtype = [ SELECT Id, Name FROM recordtype WHERE Name ='Promoção' LIMIT 1 ];
        
		//Buscar participante por shopping e Cliente
		List<Participante__c> participante = [Select Id,TW1_Antigo__c,TW1_Dia_da_participacao__c,TW1_Novo__c,TW1_Promocao__c,TW1_Shopping__c,TW1_Cliente__c
            From Participante__c where TW1_Shopping__c=:Ntfs.TW1_Shopping__c And TW1_Cliente__c=:Ntfs.TW1_Cliente__c And recordtypeId =: vaRecordtype.Id Order By CreatedDate desc];
        
        if(participante == null || participante.size() == 0){
            //Criar registro de participante e criar registro de participaçao diaria
            Participante__c participanteNovo = new Participante__c();
            participanteNovo.RecordTypeId = vaRecordtype.Id;
            participanteNovo.TW1_Novo__c = true;
            participanteNovo.TW1_Dia_da_participacao__c = DateTime.now().Date();
            participanteNovo.TW1_Cliente__c = Ntfs.TW1_Cliente__c;
            participanteNovo.TW1_Shopping__c = Ntfs.TW1_Shopping__c;
            participanteNovo.TW1_Promocao__c = Ntfs.TW1_Promocao__c;
            insert participanteNovo;
            
            TW1_Participacao_diaria__c participacaoDiaria = new TW1_Participacao_diaria__c();
            participacaoDiaria.TW1_Formas_de_Pagamento__c = Ntfs.Forma_de_Pagamento_Picklist__c;
            participacaoDiaria.TW1_Data_de_participacao__c = DateTime.now().Date();
            participacaoDiaria.TW1_Participante__c = participanteNovo.Id;
            participacaoDiaria.TW1_Valor__c = Ntfs.TW1_Valor_RS__c;
            participacaoDiaria.TW1_Cliente__c = Ntfs.TW1_Cliente__c;
            
            insert participacaoDiaria;
            
            Ntfs.TW1_Participante__c = participanteNovo.Id;
        }
        else{
            boolean participouflag = true;
            
                for(Participante__c participanteCorrente : participante){
                
                if(participanteCorrente.TW1_Promocao__c == Ntfs.TW1_Promocao__c){
                    //- Participante Novo/Antigo - Concatenar participação diaria
                    Date data = DateTime.now().Date(); 
                    //Buscar registros de participação diaria para o dia vingente
                    List<TW1_Participacao_diaria__c> participacaoDiariaget = [Select Id,TW1_Data_de_participacao__c,TW1_Formas_de_Pagamento__c,TW1_Participante__c,TW1_Valor__c From TW1_Participacao_diaria__c where TW1_Cliente__c=:Ntfs.TW1_Cliente__c And TW1_Data_de_participacao__c=:data];
	                    
                    if(participacaoDiariaget.size() > 0 ){
                        //Somar o valor da nota nocampo valor da participação diaria
                        participacaoDiariaget[0].TW1_Data_de_participacao__c = DateTime.now().Date(); 
                        participacaoDiariaget[0].TW1_Valor__c += Ntfs.TW1_Valor_RS__c;
                        participacaoDiariaget[0].TW1_Formas_de_Pagamento__c = participacaoDiariaget[0].TW1_Formas_de_Pagamento__c + ';' + Ntfs.Forma_de_Pagamento_Picklist__c;
                        
                        update participacaoDiariaget;
                        
                        Ntfs.TW1_Participante__c = participanteCorrente.Id;
                        
                    }else{
                        //Criar registro de participante e criar registro de participaçao diaria
                        TW1_Participacao_diaria__c participacaoDiaria = new TW1_Participacao_diaria__c();
                        participacaoDiaria.TW1_Formas_de_Pagamento__c = Ntfs.Forma_de_Pagamento_Picklist__c;
                        participacaoDiaria.TW1_Data_de_participacao__c = DateTime.now().Date();
                        participacaoDiaria.TW1_Participante__c = participanteCorrente.Id;
                        participacaoDiaria.TW1_Valor__c = Ntfs.TW1_Valor_RS__c;
                        participacaoDiaria.TW1_Cliente__c = Ntfs.TW1_Cliente__c;
                
                		insert participacaoDiaria;
                        
                        Ntfs.TW1_Participante__c = participanteCorrente.Id;
                    }
                       
            		 participouflag = false;
                }
                    
              }
            
            //participante Antigo- flag - mas primeira vez nessa promoção - e primeira vez na participação diaria
            if(participouflag){
                //Criar registro de participante e criar registro de participaçao diaria
                Participante__c participanteNovo = new Participante__c();
                participanteNovo.RecordTypeId = vaRecordtype.Id;
                participanteNovo.TW1_Antigo__c = true;
                participanteNovo.TW1_Dia_da_participacao__c = DateTime.now().Date();
                participanteNovo.TW1_Cliente__c = Ntfs.TW1_Cliente__c;
                participanteNovo.TW1_Shopping__c = Ntfs.TW1_Shopping__c;
                participanteNovo.TW1_Promocao__c = Ntfs.TW1_Promocao__c;
                insert participanteNovo;
                
                TW1_Participacao_diaria__c participacaoDiaria = new TW1_Participacao_diaria__c();
                participacaoDiaria.TW1_Formas_de_Pagamento__c = Ntfs.Forma_de_Pagamento_Picklist__c;
                participacaoDiaria.TW1_Data_de_participacao__c = DateTime.now().Date();
                participacaoDiaria.TW1_Participante__c = participanteNovo.Id;
                participacaoDiaria.TW1_Valor__c = Ntfs.TW1_Valor_RS__c;
                participacaoDiaria.TW1_Cliente__c = Ntfs.TW1_Cliente__c;
                
                insert participacaoDiaria;
                
                Ntfs.TW1_Participante__c = participanteNovo.Id;
            }
        }
    }
}