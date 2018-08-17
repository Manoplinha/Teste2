@istest
private class Tw1_Ancar_UtilFluxoCaixaManager_tst {
    
    static testMethod void testdoCuponManagerGet() {
        
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837398';
        acc.LastName ='Caruzo';
        acc.DDD__c = 21;
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
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
        promocao.TW1_Max_Brinde_Clientes__c = 2;
        promocao.Max_Cupom__c = 2;
        promocao.Max_Bonus_Cliente__c =2;
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Troca_por__c = 'Ambos';
        promocao.TW1_Condicoes_especiais_cart_credito__c = false;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.Max_Brindes_por_Troca__c = 2;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        
        
        Insert promocao;
        
        
        TW1_Caixa__c vaCaixa = new TW1_Caixa__c();
        vaCaixa.Name = 'Caixa Marcao';
        vaCaixa.TW1_Operador__c = operador.Id;
        vaCaixa.CreatedDate = DateTime.now().date();
        
        Insert vaCaixa;
        
        TW1_Stand__c stand = new TW1_Stand__c();
        stand.Name = 'Stand 1';
        stand.TW1_Shopping__c = shopping.Id; 
        Insert stand;
        
        TW1_Terminal__c Terminal = new TW1_Terminal__c();
        Terminal.TW1_Stand__c = stand.Id;
        Terminal.TW1_Operador__c= operador.Id;
        Insert Terminal;
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/UtilFluxoCaixa';
        
        //request.addParameter('Id', acc.Id);
        //request.addParameter('accountId', acc.Id);
        //request.addParameter('QuantidadeCupons', '2');
        
        //request.addParameter('IdPromocao', promocao.Id);
        request.addParameter('IdStand', stand.Id);
        request.addParameter('IdShopping', Shopping.Id);
        
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        System.debug(RestContext.request);
        
        UtilFluxoCaixaManager.getStandTerminalPorId();
        
    }
}