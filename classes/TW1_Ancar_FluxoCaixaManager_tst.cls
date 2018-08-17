@isTest
private class  TW1_Ancar_FluxoCaixaManager_tst {
    
    	static testMethod void testdoFluxoCaixa() {
         // setup test data  
       	
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837329';
        acc.LastName ='Caruzo';
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        
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
    
    Insert promocao;
    
           
       TW1_Caixa__c vaCaixa = new TW1_Caixa__c();
        vaCaixa.Name = 'Caixa Marcao';
    	vaCaixa.TW1_Operador__c = operador.Id;
        vaCaixa.CreatedDate = DateTime.now().date();

       Insert vaCaixa;   
            
       TW1_Brinde__c brinde = new TW1_Brinde__c();
            brinde.Name = 'Caneta';
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
            
            
            
                
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/FluxoCaixa';
        
        //request.addParameter('Id', acc.Id);
        
        request.addParameter('IdTerminal', Terminal.Id);
        request.addParameter('Valor', '200');
        request.addParameter('TipoOperacao', 'Fechamento');
        
        //request.addParameter('IdShopping', shopping.Id);
        request.addParameter('IdOperador', operador.Id);
        //request.addParameter('SenhaOperaodor', operador.TW1_Senha__c);

        request.httpMethod = 'GET';
		
        RestContext.request = request;
         System.debug(RestContext.request);
        
        FluxoCaixaManager.getAberturaCaixaPorId();

    }
    

    static testMethod void testdoFluxoCaixatest() {
         // setup test data  
       	
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837329';
        acc.LastName ='Caruzo';
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        
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
    
    Insert promocao;
    
           
       TW1_Caixa__c vaCaixa = new TW1_Caixa__c();
        vaCaixa.Name = 'Caixa Marcao';
    	vaCaixa.TW1_Operador__c = operador.Id;
        vaCaixa.CreatedDate = DateTime.now().date();

       Insert vaCaixa;   
            
       TW1_Brinde__c brinde = new TW1_Brinde__c();
            brinde.Name = 'Caneta';
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
            
            
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/FluxoCaixa';
        
        //request.addParameter('Id', acc.Id);
        request.addParameter('TipoOperacao', null);
        request.addParameter('IdTerminal', Terminal.Id);
        request.addParameter('Valor', '200');
        
        //request.addParameter('IdShopping', shopping.Id);
        request.addParameter('IdOperador', operador.Id);
        //request.addParameter('SenhaOperaodor', operador.TW1_Senha__c);

        request.httpMethod = 'GET';
		
        RestContext.request = request;
         System.debug(RestContext.request);
        
        FluxoCaixaManager.getAberturaCaixaPorId();

    }
    
}