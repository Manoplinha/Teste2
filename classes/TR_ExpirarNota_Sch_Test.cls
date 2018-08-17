@istest
public  with sharing class TR_ExpirarNota_Sch_Test {
    
    @isTest static void TestExpiraNotaJob() { 
        
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        Anc_Utils_cls.LogToSystemDebug('Criando conta');
        Account act = new Account(); 
        act.FirstName ='Teste';
        act.LastName ='silva';
        act.TW1_CPF__c='74745710569';
        act.TW1_CNPJ__c='27364928000101';
        act.Phone = '2133337444';
        act.PersonMobilePhone = '21999984578';
        act.RecordTypeId = varecodtype.id;
        insert act;
        Anc_Utils_cls.LogToSystemDebug('conta criada ' + act);
        
        Anc_Utils_cls.LogToSystemDebug('Criando fidelidade');
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        vafidelidade.TW1_Modalidade__c='Prospect';
        vafidelidade.TW1_Nome_Cliente__c=act.id;
        insert vafidelidade;       
        Anc_Utils_cls.LogToSystemDebug('Fidelidade criada ' + vafidelidade);
        
        TW1_Shopping__c shopping = new TW1_Shopping__c();
        shopping.TW1_SGL_Empreendimento__c = 'RDB';
        shopping.Name = 'Rio Design Barra';
        
        Insert shopping;
        
        recordtype rtAcc = [Select Id,Name From recordtype where Name='Loja' Limit 1];
        Anc_Utils_cls.LogToSystemDebug('Criando Loja');
        Account accLoja = new Account();
        accLoja.Name = 'Loja Americanas';
        accLoja.RecordTypeId = rtAcc.Id;
        accLoja.TW1_Shopping__c = shopping.Id;
        Insert accLoja;
        Anc_Utils_cls.LogToSystemDebug('Loja criada ' + accLoja);
        
        Anc_Utils_cls.LogToSystemDebug('Criando Historico');
        TW1_Historico__c historico = new TW1_Historico__c();
        historico.TW1_Fidelidade__c = vafidelidade.Id;
        historico.TW1_Loja__c = accLoja.Id;
        historico.TW1_Status__c = 'Válida';
        historico.TW1_Data_da_Nota__c = Date.today().addDays(-95);
        historico.TW1_Valor_RS__c = 120;
        insert historico;
        Anc_Utils_cls.LogToSystemDebug('Historico criado ' + historico);
        
        Test.startTest();  
        Anc_ScheaduleUtils_cls.scheadule('TR_ExpirarNota_SCH', DateTime.now().addMinutes(1)); 
        Test.stopTest(); 
    } 
}