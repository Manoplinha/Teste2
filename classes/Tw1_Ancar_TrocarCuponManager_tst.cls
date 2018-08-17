@istest
private class Tw1_Ancar_TrocarCuponManager_tst {
    
    
    static testMethod void testdoCuponManagerGet() {
        
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837398';
        acc.LastName ='Caruzo';
        acc.DDD__c = 21;
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        acc.TW1_Data_Nascimento__c = Date.newInstance(1999, 06,04);
        acc.CEP__c = '12345-678';
        
        Insert acc;
        
        
        
        TW1_Shopping__c shopping = new TW1_Shopping__c();
        shopping.TW1_SGL_Empreendimento__c = 'BPS';
        shopping.Name = 'Barra Shopping';
        
        Insert shopping;
        
        TW1_Operador__c operador  = new TW1_Operador__c();
        operador.Name = 'Leonardo';
        operador.TW1_Email__c = 'leonardo@gmail.com';
        operador.TW1_Empresa__c = 'Triscal';
        operador.TW1_Senha__c = '123456';
        operador.TW1_Nome_do_Usuario__c = 'leo';
        operador.TW1_Shopping__c = shopping.Id; 
        operador.TW1_Tipo__c = 'Coordenador';
        
        Insert operador;
        
        TW1_Parametros_Promocao__c promocao = new TW1_Parametros_Promocao__c();
        promocao.Name = 'Promo Teste Tabajara';
        promocao.TW1_Troca_por__c = 'Brinde';
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        promocao.TW1_Data_Inicio__c = DateTime.now().date();
        promocao.TW1_Valor_Min_NTFS__c = 100;
        promocao.TW1_Max_Brinde_Clientes__c = 23;
        promocao.Max_Cupom__c = 33;
        promocao.Max_Bonus_Cliente__c =23;
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Troca_por__c = 'Ambos';
        promocao.TW1_Condicoes_especiais_cart_credito__c = true;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.Max_Brindes_por_Troca__c = 23;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        promocao.Tw1_CobrarBrinde__c = true;
        
        
        Insert promocao;
        
        
        TW1_Caixa__c vaCaixa = new TW1_Caixa__c();
        vaCaixa.Name = 'Caixa Marcao';
        vaCaixa.TW1_Operador__c = operador.Id;
        vaCaixa.TW1_Data_de_Abertura__c = DateTime.now().date();
        vaCaixa.CreatedDate = DateTime.now().date();
        
        Insert vaCaixa;   
        
        TW1_Brinde__c brinde = new TW1_Brinde__c();
        brinde.Name = 'Caneta';
        brinde.Valor__c = 10;
        brinde.Tipo__c = 'produto';
        Insert brinde;
        
        TW1_Stand__c stand = new TW1_Stand__c();
        stand.Name = 'Stand 1';
        stand.TW1_Shopping__c = shopping.Id; 
        Insert stand;
        
        TW1_Brindes_da_Promocao__c BrindePromocao = new TW1_Brindes_da_Promocao__c();
        BrindePromocao.TW1_Brinde__c = brinde.Id;
        BrindePromocao.TW1_Promocao__c = promocao.Id;
        Insert BrindePromocao;
        
        TW1_Estorno_Brindes__c BrindesEstornados = new TW1_Estorno_Brindes__c();
        BrindesEstornados.TW1_Cliente__c = acc.Id;
        BrindesEstornados.TW1_Parametros_da_Promocao__c = promocao.Id;
        BrindesEstornados.TW1_Operador__c = operador.Id;
        BrindesEstornados.TW1_Brinde_Retirado__c = brinde.Id;
        BrindesEstornados.TW1_Brinde_devolvido__c = brinde.Id;
        BrindesEstornados.TW1_Data_de_Extorno__c = DateTime.now().date();
        
        Insert BrindesEstornados;
        
        
        TW1_Terminal__c Terminal = new TW1_Terminal__c();
        Terminal.TW1_Stand__c = stand.Id;
        Terminal.TW1_Operador__c= operador.Id;
        Insert Terminal;
        
        
        TW1_Cupom__c Cupons = new TW1_Cupom__c();
        Cupons.TW1_Nome_do_Cliente__c = acc.Id;
        Cupons.TW1_Parametro_Promocao__c = promocao.Id;
        Insert Cupons;
        
        TW1_Brindes_Entregues__c BrindesEntregues = new TW1_Brindes_Entregues__c();
        BrindesEntregues.TW1_Brinde__c = brinde.Id;
        BrindesEntregues.TW1_Cliente__c = acc.Id;
        BrindesEntregues.Parametros_da_Promocao__c = promocao.Id;
        BrindesEntregues.Tipo__c = 'Produto';
        Insert BrindesEntregues;
        
        recordtype vaRecordtype = [ SELECT Id, Name FROM recordtype WHERE Name ='Promoção' LIMIT 1 ];
        
        Participante__c participanteNovo = new Participante__c();
        participanteNovo.RecordTypeId = vaRecordtype.id;
        participanteNovo.TW1_Novo__c = true;
        participanteNovo.TW1_Dia_da_participacao__c = DateTime.now().Date();
        participanteNovo.TW1_Cliente__c = acc.ID;
        participanteNovo.TW1_Shopping__c = shopping.ID;
        participanteNovo.TW1_Promocao__c = promocao.ID;
        insert participanteNovo;
        
        
        
        NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Participante__c = participanteNovo.Id;
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 510;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais;
        
        NTFS__c notasFiscais2 = new NTFS__c();
        notasFiscais2.TW1_Forma_de_pagamento__c = 'Dinheiro';
        notasFiscais2.TW1_Participante__c = participanteNovo.Id;
        notasFiscais2.Forma_de_Pagamento_Picklist__c = 'Dinheiro';
        notasFiscais2.TW1_Valor_RS__c = 590;
        notasFiscais2.TW1_Cliente__c=acc.Id;
        notasFiscais2.TW1_Shopping__c= Shopping.Id;
        notasFiscais2.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais2;
        
        NTFS__c notasFiscais3 = new NTFS__c();
        notasFiscais3.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais3.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais3.TW1_Participante__c = participanteNovo.Id;
        notasFiscais3.TW1_Valor_RS__c = 590;
        notasFiscais3.TW1_Cliente__c=acc.Id;
        notasFiscais3.TW1_Shopping__c= Shopping.Id;
        notasFiscais3.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais3;
        
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
        CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        CondicoesEspeciais.TW1_Forma_de_Pagamento__c = 'Cartão Caixa';
        Insert CondicoesEspeciais;
        
        TW1_Estoque__c listOrigemestoque = new TW1_Estoque__c();
        listOrigemestoque.Name = '';
        listOrigemestoque.TW1_Quantidade__c = 100;
        listOrigemestoque.TW1_Brinde__c = brinde.Id;
        listOrigemestoque.TW1_Tipo__c='Estoque Stand';
        listOrigemestoque.TW1_Stand__c= stand.Id;
        listOrigemestoque.TW1_Shopping__c= Shopping.Id;
        Insert listOrigemestoque;
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/TrocarCupom';
        
        //request.addParameter('Id', acc.Id);
        request.addParameter('accountId', acc.Id);
        request.addParameter('QuantidadeCupons', '2');
        
        //request.addParameter('IdPromocao', promocao.Id);
        request.addParameter('IdOperador', operador.Id);
        request.addParameter('IdShopping', Shopping.Id);
        
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        System.debug(RestContext.request);
        
        TrocarCuponManager.getTrocarCuponPorId();
        
    }
    
    static testMethod void testdoCuponManagerGet2() {
        
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837398';
        acc.LastName ='Caruzo';
        acc.DDD__c = 21;
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        acc.TW1_Data_Nascimento__c = Date.newInstance(1999, 06,04);
        acc.CEP__c = '12345-678';
        
        Insert acc;
        
        
        
        TW1_Shopping__c shopping = new TW1_Shopping__c();
        shopping.TW1_SGL_Empreendimento__c = 'BPS';
        shopping.Name = 'Barra Shopping';
        
        Insert shopping;
        
        TW1_Operador__c operador  = new TW1_Operador__c();
        operador.Name = 'Leonardo';
        operador.TW1_Email__c = 'leonardo@gmail.com';
        operador.TW1_Empresa__c = 'Triscal';
        operador.TW1_Senha__c = '123456';
        operador.TW1_Nome_do_Usuario__c = 'leo';
        operador.TW1_Shopping__c = shopping.Id; 
        operador.TW1_Tipo__c = 'Coordenador';
        
        Insert operador;
        
        TW1_Parametros_Promocao__c promocao = new TW1_Parametros_Promocao__c();
        promocao.Name = 'Promo Teste Tabajara';
        promocao.TW1_Troca_por__c = 'Brinde';
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        promocao.TW1_Data_Inicio__c = DateTime.now().date();
        promocao.TW1_Valor_Min_NTFS__c = 100;
        promocao.TW1_Max_Brinde_Clientes__c = 23;
        promocao.Max_Cupom__c = 33;
        promocao.Max_Bonus_Cliente__c =23;
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Troca_por__c = 'Ambos';
        promocao.TW1_Condicoes_especiais_cart_credito__c = true;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.Max_Brindes_por_Troca__c = 23;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        promocao.Tw1_CobrarBrinde__c = true;
        
        
        Insert promocao;
        
        
        TW1_Caixa__c vaCaixa = new TW1_Caixa__c();
        vaCaixa.Name = 'Caixa Marcao';
        vaCaixa.TW1_Operador__c = operador.Id;
        vaCaixa.TW1_Data_de_Abertura__c = DateTime.now().date();
        vaCaixa.CreatedDate = DateTime.now().date();
        
        Insert vaCaixa;   
        
        TW1_Brinde__c brinde = new TW1_Brinde__c();
        brinde.Name = 'Caneta';
        brinde.Valor__c = 10;
        brinde.Tipo__c = 'produto';
        Insert brinde;
        
        TW1_Stand__c stand = new TW1_Stand__c();
        stand.Name = 'Stand 1';
        stand.TW1_Shopping__c = shopping.Id; 
        Insert stand;
        
        TW1_Brindes_da_Promocao__c BrindePromocao = new TW1_Brindes_da_Promocao__c();
        BrindePromocao.TW1_Brinde__c = brinde.Id;
        BrindePromocao.TW1_Promocao__c = promocao.Id;
        Insert BrindePromocao;
        
        TW1_Estorno_Brindes__c BrindesEstornados = new TW1_Estorno_Brindes__c();
        BrindesEstornados.TW1_Cliente__c = acc.Id;
        BrindesEstornados.TW1_Parametros_da_Promocao__c = promocao.Id;
        BrindesEstornados.TW1_Operador__c = operador.Id;
        BrindesEstornados.TW1_Brinde_Retirado__c = brinde.Id;
        BrindesEstornados.TW1_Brinde_devolvido__c = brinde.Id;
        BrindesEstornados.TW1_Data_de_Extorno__c = DateTime.now().date();
        
        Insert BrindesEstornados;
        
        
        TW1_Terminal__c Terminal = new TW1_Terminal__c();
        Terminal.TW1_Stand__c = stand.Id;
        Terminal.TW1_Operador__c= operador.Id;
        Insert Terminal;
        
        
        
        TW1_Brindes_Entregues__c BrindesEntregues = new TW1_Brindes_Entregues__c();
        BrindesEntregues.TW1_Brinde__c = brinde.Id;
        BrindesEntregues.TW1_Cliente__c = acc.Id;
        BrindesEntregues.Parametros_da_Promocao__c = promocao.Id;
        BrindesEntregues.Tipo__c = 'Produto';
        Insert BrindesEntregues;
        
        recordtype vaRecordtype = [ SELECT Id, Name FROM recordtype WHERE Name ='Promoção' LIMIT 1 ];
        
        Participante__c participanteNovo = new Participante__c();
        participanteNovo.RecordTypeId = vaRecordtype.id;
        participanteNovo.TW1_Novo__c = true;
        participanteNovo.TW1_Dia_da_participacao__c = DateTime.now().Date();
        participanteNovo.TW1_Cliente__c = acc.ID;
        participanteNovo.TW1_Shopping__c = shopping.ID;
        participanteNovo.TW1_Promocao__c = promocao.ID;
        insert participanteNovo;
        
        
        
        NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Participante__c = participanteNovo.Id;
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 510;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais;
        
        NTFS__c notasFiscais2 = new NTFS__c();
        notasFiscais2.TW1_Forma_de_pagamento__c = 'Dinheiro';
        notasFiscais2.TW1_Participante__c = participanteNovo.Id;
        notasFiscais2.Forma_de_Pagamento_Picklist__c = 'Dinheiro';
        notasFiscais2.TW1_Valor_RS__c = 590;
        notasFiscais2.TW1_Cliente__c=acc.Id;
        notasFiscais2.TW1_Shopping__c= Shopping.Id;
        notasFiscais2.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais2;
        
        NTFS__c notasFiscais3 = new NTFS__c();
        notasFiscais3.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais3.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais3.TW1_Participante__c = participanteNovo.Id;
        notasFiscais3.TW1_Valor_RS__c = 590;
        notasFiscais3.TW1_Cliente__c=acc.Id;
        notasFiscais3.TW1_Shopping__c= Shopping.Id;
        notasFiscais3.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais3;
        
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
        CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        CondicoesEspeciais.TW1_Forma_de_Pagamento__c = 'Cartão Caixa';
        Insert CondicoesEspeciais;
        
        TW1_Estoque__c listOrigemestoque = new TW1_Estoque__c();
        listOrigemestoque.Name = '';
        listOrigemestoque.TW1_Quantidade__c = 100;
        listOrigemestoque.TW1_Brinde__c = brinde.Id;
        listOrigemestoque.TW1_Tipo__c='Estoque Stand';
        listOrigemestoque.TW1_Stand__c= stand.Id;
        listOrigemestoque.TW1_Shopping__c= Shopping.Id;
        Insert listOrigemestoque;
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/TrocarCupom';
        
        //request.addParameter('Id', acc.Id);
        request.addParameter('accountId', acc.Id);
        request.addParameter('QuantidadeCupons', '2');
        
        //request.addParameter('IdPromocao', promocao.Id);
        request.addParameter('IdOperador', operador.Id);
        request.addParameter('IdShopping', Shopping.Id);
        
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        System.debug(RestContext.request);
        
        TrocarCuponManager.getTrocarCuponPorId();
        
    }
    
    
}