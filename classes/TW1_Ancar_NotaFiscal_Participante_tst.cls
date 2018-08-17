@isTest
private class TW1_Ancar_NotaFiscal_Participante_tst {
    
    ////teste cliente antigo mas que nao participou ainda da promoção
    static testMethod void testdoClienteAntigoShopping() {
        
        recordtype vaRecordtype = [ SELECT Id, Name FROM recordtype WHERE Name ='Promoção' LIMIT 1 ];
        
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837329';
        acc.LastName ='Caruzo';
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        acc.CEP__c = '12345-678';
        
        Insert acc;
        
        TW1_Shopping__c shopping = new TW1_Shopping__c();
        shopping.TW1_SGL_Empreendimento__c = 'BPS';
        shopping.Name = 'Barra Shopping';
        
        Insert shopping;
        
        TW1_Parametros_Promocao__c promocao = new TW1_Parametros_Promocao__c();
        promocao.Name = 'Promo Teste Tabajara';
        promocao.TW1_Troca_por__c = 'Brinde';
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        
        Insert promocao;
        
        Participante__c participanteNovo = new Participante__c();
        participanteNovo.RecordTypeId = vaRecordtype.id;
        participanteNovo.TW1_Novo__c = true;
        participanteNovo.TW1_Dia_da_participacao__c = DateTime.now().Date();
        participanteNovo.TW1_Cliente__c = acc.ID;
        participanteNovo.TW1_Shopping__c = shopping.ID;
        participanteNovo.TW1_Promocao__c = promocao.ID;
        insert participanteNovo;
        
        TW1_Participacao_diaria__c participacaoDiaria = new TW1_Participacao_diaria__c();
        participacaoDiaria.Formas_de_Pagamento__c = 'Visa platinum';
        participacaoDiaria.TW1_Data_de_participacao__c = DateTime.now().Date();
        participacaoDiaria.TW1_Participante__c = participanteNovo.Id;
        participacaoDiaria.TW1_Valor__c = 100;
        
        insert participacaoDiaria;
        
        NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.TW1_Forma_de_pagamento__c = 'Visa platinum';
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Visa platinum';
        notasFiscais.TW1_Valor_RS__c = 100;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = DateTime.now().Date();
        
        insert notasFiscais;
        
    }
    
    //teste cliente novo no shopping
    static testMethod void testdoClienteNovoShopping() {
        
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837329';
        acc.LastName ='Caruzo';
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        acc.CEP__c = '12345-678';
        
        Insert acc;
        
        TW1_Shopping__c shopping = new TW1_Shopping__c();
        shopping.TW1_SGL_Empreendimento__c = 'BPS';
        shopping.Name = 'Barra Shopping';
        
        Insert shopping;
        
        TW1_Parametros_Promocao__c promocao = new TW1_Parametros_Promocao__c();
        promocao.Name = 'Promo Teste Tabajara';
        promocao.TW1_Troca_por__c = 'Brinde';
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        
        Insert promocao;
        
        
        NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.TW1_Forma_de_pagamento__c = 'Visa platinum';
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Visa platinum';
        notasFiscais.TW1_Valor_RS__c = 100;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = DateTime.now().Date();
        
        insert notasFiscais;
    }
    
    //teste cliente novo recorrente na promoção    
    static testMethod void testdoClienteAntigoRecorrenteShopping() {
        
        recordtype vaRecordtype = [ SELECT Id, Name FROM recordtype WHERE Name ='Promoção' LIMIT 1 ];
        
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837329';
        acc.LastName ='Caruzo';
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        acc.CEP__c = '12345-678';
        
        Insert acc;
        
        TW1_Shopping__c shopping = new TW1_Shopping__c();
        shopping.TW1_SGL_Empreendimento__c = 'BPS';
        shopping.Name = 'Barra Shopping';
        
        Insert shopping;
        
        TW1_Parametros_Promocao__c promocao = new TW1_Parametros_Promocao__c();
        promocao.Name = 'Promo Teste Tabajara';
        promocao.TW1_Troca_por__c = 'Brinde';
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        
        Insert promocao;
        
        Participante__c participanteNovo = new Participante__c();
        participanteNovo.RecordTypeId = vaRecordtype.id;
        participanteNovo.TW1_Novo__c = true;
        participanteNovo.TW1_Dia_da_participacao__c = DateTime.now().Date();
        participanteNovo.TW1_Cliente__c = acc.ID;
        participanteNovo.TW1_Shopping__c = shopping.ID;
        participanteNovo.TW1_Promocao__c = promocao.ID;
        insert participanteNovo;
        
        TW1_Participacao_diaria__c participacaoDiaria = new TW1_Participacao_diaria__c();
        participacaoDiaria.Formas_de_Pagamento__c = 'Visa platinum';
        participacaoDiaria.TW1_Data_de_participacao__c = DateTime.now().Date();
        participacaoDiaria.TW1_Participante__c = participanteNovo.Id;
        participacaoDiaria.TW1_Valor__c = 100;
        
        insert participacaoDiaria;
        
        NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.TW1_Forma_de_pagamento__c = 'Visa platinum';
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Visa platinum';
        notasFiscais.TW1_Valor_RS__c = 100;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = DateTime.now().Date();
        insert notasFiscais;
        
        NTFS__c notasFiscaiss = new NTFS__c();
        notasFiscaiss.TW1_Forma_de_pagamento__c = 'Visa platinum';
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Visa platinum';
        notasFiscaiss.TW1_Valor_RS__c = 100;
        notasFiscaiss.TW1_Cliente__c=acc.Id;
        notasFiscaiss.TW1_Shopping__c= Shopping.Id;
        notasFiscaiss.TW1_Data_da_Nota__c = DateTime.now().Date();
        
        insert notasFiscaiss;
        
        TW1_Ancar_Handler_NotaFiscalParticipante J = New TW1_Ancar_Handler_NotaFiscalParticipante(true, 1);
        J.bulkBefore();
        J.bulkAfter();
        SObject s;
        J.beforeUpdate(s,s);
        J.afterInsert(s);
        J.afterUpdate(s,s);
        J.afterDelete(s);
        J.OnUndelete(s);
        J.andFinally();
    }
}