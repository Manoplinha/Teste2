@isTest
private class TW1_Ancar_CordenadorManager_tst {

    static testMethod void testdoCoordenadorShopping() {
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
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Cordenador';
        
        //request.addParameter('Id', acc.Id);
        //request.addParameter('IdPromocao', promocao.Id);
        
        request.addParameter('IdShopping', shopping.Id);
        //request.addParameter('IdOperador', operador.Id);
        //request.addParameter('SenhaOperaodor', operador.TW1_Senha__c);

        request.httpMethod = 'GET';
		
        RestContext.request = request;
         System.debug(RestContext.request);
        
        CordenadorManager.getCordenadorPorShopping();

    }
    
    static testMethod void testdoCoordenadorId() {
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
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Cordenador';
        
        //request.addParameter('Id', acc.Id);
        //request.addParameter('IdPromocao', promocao.Id);
        
        //request.addParameter('IdShopping', shopping.Id);
        request.addParameter('IdOperador', operador.Id);
        request.addParameter('SenhaOperaodor', operador.TW1_Senha__c);

        request.httpMethod = 'GET';
		
        RestContext.request = request;
         System.debug(RestContext.request);
        
         CordenadorManager.getCordenadorPorShopping();

    }
}