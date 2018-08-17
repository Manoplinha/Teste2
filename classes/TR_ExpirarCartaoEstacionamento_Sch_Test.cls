@istest
public  with sharing class TR_ExpirarCartaoEstacionamento_Sch_Test {
    
    @isTest static void TestExpiraCartaoEstacionamentoJob() { 
        
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        Anc_Utils_cls.LogToSystemDebug('Criando conta');
        Account act = new Account(); 
        act.FirstName ='Conta de Teste Cartao Estacionamento ';
        act.LastName ='silva';
        act.TW1_CPF__c='51885550006';
        act.TW1_CNPJ__c='32226149000180';
        act.Phone = '2144447555';
        act.PersonMobilePhone = '21981384578';
        act.RecordTypeId = varecodtype.id;
        insert act;
        Anc_Utils_cls.LogToSystemDebug('conta criada ' + act);
        
        Anc_Utils_cls.LogToSystemDebug('Criando fidelidade');
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        vafidelidade.TW1_Modalidade__c='Prospect';
        vafidelidade.TW1_Nome_Cliente__c=act.id;
        insert vafidelidade;       
        Anc_Utils_cls.LogToSystemDebug('Fidelidade criada ' + vafidelidade);
        
        /*
        TW1_Shopping__c shopping = new TW1_Shopping__c();
        shopping.TW1_SGL_Empreendimento__c = 'RDB';
        shopping.Name = 'Rio Design Barra';
        
        Insert shopping;
                
        Anc_Utils_cls.LogToSystemDebug('Shopping criado ' + shopping);
        */
        
        
        Anc_Utils_cls.LogToSystemDebug('Criando cartao de estacionamento');
        TW1_Cartoes_Estacionamento__c cartaoestacionamento = new TW1_Cartoes_Estacionamento__c();
		//cartaoestacionamento.Name ='Cartao Estacionamento Teste';
        cartaoestacionamento.TW1_Numero_Fidelidade__c = vafidelidade.Id;        
        cartaoestacionamento.TW1_Data_inicio__c = Date.today() - 2;
		cartaoestacionamento.TW1_Data_Fim__c = Date.today() - 1;
        cartaoestacionamento.TW1_Status__c = 'Ativo';
        Insert cartaoestacionamento;
        Anc_Utils_cls.LogToSystemDebug('Cartao de Estacionamento Criado ' + cartaoestacionamento);
        
        
        Test.startTest();  
        Anc_ScheaduleUtils_cls.scheadule('TR_Cartoes_Estacionamento_SCH', DateTime.now().addMinutes(1)); 
        Test.stopTest(); 
    } 
}