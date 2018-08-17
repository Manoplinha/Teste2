@isTest
private class TW1_Ancar_LoginManager_tst {

    static testMethod void testdoLogin() {
         // setup test data  
         // 
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
    	operador.TW1_Tipo__c = 'Operador';
    
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
    
        string login = 'leonardo@gmail.com';
        string senha = '123456';

        List<string> listreturn = LoginManager.doLogin(login,senha,shopping.Id);
        
        System.assertEquals(18,listreturn.size());
    }
    
    static testMethod void testdoLoginNull() {
    
        string login = '';
        string senha = '';
		string shopping = '';
        List<string> listreturn = LoginManager.doLogin(login,senha,shopping);
        
        System.assertEquals(1,listreturn.size());
    }
}