@istest
private class Tw1_Ancar_NotaFiscalManager_tst {

     static testMethod void testdoNotaFiscalPost() {
         // setup test data  
       	
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
        promocao.TW1_Data_Inicio__c = DateTime.now().date();
    
    Insert promocao;
         
           TW1_Brinde__c brinde = new TW1_Brinde__c();
            brinde.Name = 'Caneta';
       Insert brinde;
    
           
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
        
         NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 500;
         notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;

        
        Insert notasFiscais;
        
          NotaFiscalManager.requestWrapper Rw = new NotaFiscalManager.requestWrapper();
          Rw.notaFiscal = new NotaFiscalManager.NotaFiscal();
         
        Rw.notaFiscal.NumeroNota = notasFiscais.Name;
        Rw.notaFiscal.IdCliente = notasFiscais.TW1_Cliente__c;
        Rw.notaFiscal.DataNota = notasFiscais.TW1_Data_da_Nota__c;
        Rw.notaFiscal.IdShopping = notasFiscais.TW1_Shopping__c;
        Rw.notaFiscal.FormaPagamento = notasFiscais.Forma_de_Pagamento_Picklist__c;
        Rw.notaFiscal.IdLoja = notasFiscais.TW1_Loja__c;
        Rw.notaFiscal.Valor = string.valueOf(notasFiscais.TW1_Valor_RS__c);
        Rw.notaFiscal.IdPromocao = notasFiscais.TW1_Promocao__c;
         
        
         
         String JsonMsg = JSON.serialize(Rw);
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/NotaFiscal';
		request.requestBody = blob.valueOf(JsonMsg);
        request.httpMethod = 'POST';
		
        RestContext.request = request;
		
     	NotaFiscalManager.UpsertNotaFiscal(Rw);

    }
    
     static testMethod void testdoNotaFiscalId() {
         // setup test data  
       	
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837329';
        acc.LastName ='Caruzo';
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        acc.CEP__c = '12345-678';
        
        Insert acc;
             
       recordtype rtAcc = [Select Id,Name From recordtype where Name='Loja' Limit 1];
             
        Account accLoja = new Account();
             accLoja.Name = 'Loja Americanas';
             accLoja.RecordTypeId = rtAcc.Id;
             accLoja.TW1_LUC__c = '123';   
             accLoja.TW1_CNPJ__c = '44938235000102';   
             accLoja.TW1_Nome_fantasia__c = 'Americanas';   
             accLoja.TW1_Razao_Social__c = 'xpto';   
         	 accLoja.CEP__c = '12345-678';
             
        Insert accLoja;

            
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
        
        NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 500;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais;
        
        NTFS__c notasFiscais2 = new NTFS__c();
        notasFiscais2.Forma_de_Pagamento_Picklist__c = 'Dinheiro';
        notasFiscais2.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais2.TW1_Valor_RS__c = 500;
        notasFiscais2.TW1_Cliente__c=acc.Id;
        notasFiscais2.TW1_Shopping__c= Shopping.Id;
        notasFiscais2.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais2;
        
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
         CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        Insert CondicoesEspeciais;
        
                
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/NotaFiscalManager';
        
        request.addParameter('Id', notasFiscais.Id);
        request.addParameter('NumeroNTFS', notasFiscais.Name);
        request.addParameter('IdPromocao', promocao.Id);
        
        //request.addParameter('Nome', 'Americanas');
        //request.addParameter('Razao', 'xpto');
        request.addParameter('IdCliente', acc.Id);

        request.httpMethod = 'GET';
		
        RestContext.request = request;
         System.debug(RestContext.request);
        
        NotaFiscalManager.getNotaFiscalPorId();

    }
    
     static testMethod void testdoNotaFiscals() {
         // setup test data  
       	
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837329';
        acc.LastName ='Caruzo';
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        acc.CEP__c = '12345-678';
        
        Insert acc;
             
       recordtype rtAcc = [Select Id,Name From recordtype where Name='Loja' Limit 1];
             
        Account accLoja = new Account();
             accLoja.Name = 'Loja Americanas';
             accLoja.RecordTypeId = rtAcc.Id;
             accLoja.TW1_LUC__c = '123';   
             accLoja.TW1_CNPJ__c = '44938235000102';   
             accLoja.TW1_Nome_fantasia__c = 'Americanas';   
             accLoja.TW1_Razao_Social__c = 'xpto';   
         	 accLoja.CEP__c = '12345-678';
             
        Insert accLoja;

            
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
        
        NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.Name = '12345qwer';
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 500;
        notasFiscais.TW1_Cliente__c=acc.Id;
         notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais;
        
        NTFS__c notasFiscais2 = new NTFS__c();
        notasFiscais.Name = '12345qwel';
        notasFiscais2.Forma_de_Pagamento_Picklist__c = 'Dinheiro';
          notasFiscais2.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais2.TW1_Valor_RS__c = 500;
        notasFiscais2.TW1_Cliente__c=acc.Id;
        notasFiscais2.TW1_Shopping__c= Shopping.Id;
        notasFiscais2.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais2;
        
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
         CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        Insert CondicoesEspeciais;
        
                
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/NotaFiscalManager';
        
        request.addParameter('Id', null);
        request.addParameter('NumeroNTFS', notasFiscais.Name);
        request.addParameter('IdPromocao', promocao.Id);
        
        //request.addParameter('Nome', 'Americanas');
        //request.addParameter('Razao', 'xpto');
        request.addParameter('IdCliente', acc.Id);

        request.httpMethod = 'GET';
		
        RestContext.request = request;
         System.debug(RestContext.request);
        
        NotaFiscalManager.getNotaFiscalPorId();

    }
    
     static testMethod void testdoNotaFiscal() {
         // setup test data  
       	
        Account acc = new Account();
        acc.TW1_Sexo__c ='Masculino';
        acc.Phone ='998837329';
        acc.LastName ='Caruzo';
        acc.PersonEmail = 'jjxxxaaa@gmaisl.com';
        acc.CEP__c = '12345-678';
        
        Insert acc;
             
       recordtype rtAcc = [Select Id,Name From recordtype where Name='Loja' Limit 1];
             
        Account accLoja = new Account();
             accLoja.Name = 'Loja Americanas';
             accLoja.RecordTypeId = rtAcc.Id;
             accLoja.TW1_LUC__c = '123';   
             accLoja.TW1_CNPJ__c = '44938235000102';   
             accLoja.TW1_Nome_fantasia__c = 'Americanas';   
             accLoja.TW1_Razao_Social__c = 'xpto';   
         	 accLoja.CEP__c = '12345-678';
             
        Insert accLoja;

            
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
        
        NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 500;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais;
        
        NTFS__c notasFiscais2 = new NTFS__c();
        notasFiscais2.Forma_de_Pagamento_Picklist__c = 'Dinheiro';
        notasFiscais2.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais2.TW1_Valor_RS__c = 500;
        notasFiscais2.TW1_Cliente__c=acc.Id;
        notasFiscais2.TW1_Shopping__c= Shopping.Id;
        notasFiscais2.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        
        Insert notasFiscais2;
        
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
         CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        Insert CondicoesEspeciais;
        
                
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/NotaFiscalManager';
        
        //request.addParameter('Id', notasFiscais.Id);
        request.addParameter('NumeroNTFS', notasFiscais.Name);
        request.addParameter('IdPromocao', promocao.Id);
        
        //request.addParameter('Nome', 'Americanas');
        //request.addParameter('Razao', 'xpto');
        request.addParameter('IdCliente', acc.Id);

        request.httpMethod = 'GET';
		
        RestContext.request = request;
         System.debug(RestContext.request);
        
        NotaFiscalManager.getNotaFiscalPorId();

    }
    
     static testMethod void testdoNotaFiscalPut() {
         // setup test data  
       	
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
        promocao.TW1_Valor_Min_NTFS__c = 100;
    	promocao.TW1_Troca_por__c = 'Ambos';
    	promocao.TW1_Acumula_Saldo__c = true;
    	promocao.TW1_Contabiliza_Bonus__c = true;
    	promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
    	promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        promocao.TW1_Data_Inicio__c = DateTime.now().date();
    
    Insert promocao;
         
           TW1_Brinde__c brinde = new TW1_Brinde__c();
            brinde.Name = 'Caneta';
       Insert brinde;
    
           
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
        
         NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 500;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
         notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Promocao__c = promocao.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        Insert notasFiscais;
         
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
         CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        Insert CondicoesEspeciais;
        
        
         
         
         String json = '{"IdNotaFiscal":"'+notasFiscais.Id+'",'+
             			'"IdPromocao":"'+promocao.Id+'",'+
             			'"NumeroCupom":"'+'5'+'",'+
             			'"NumeroBrinde":"'+'5'+'"}';
         
        
         
         //String JsonMsg = JSON.serialize(json);
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/NotaFiscal';
		request.requestBody = blob.valueOf(json);
        request.httpMethod = 'PUT';
		
        RestContext.request = request;

     	NotaFiscalManager.deleteNTFS(acc.Id,notasFiscais.Id,promocao.Id,'6','5');

    }
    
    static testMethod void testdoNotaFiscalPutCupom() {
         // setup test data  
       	
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
        promocao.TW1_Valor_Min_NTFS__c = 100;
    	promocao.TW1_Troca_por__c = 'Cupom';
    	promocao.TW1_Acumula_Saldo__c = true;
    	promocao.TW1_Contabiliza_Bonus__c = true;
    	promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
    	promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        promocao.TW1_Data_Inicio__c = DateTime.now().date();
    
    Insert promocao;
         
           TW1_Brinde__c brinde = new TW1_Brinde__c();
            brinde.Name = 'Caneta';
       Insert brinde;
    
           
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
        
         NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 500;
        notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Promocao__c = promocao.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        Insert notasFiscais;
         
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
        CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        Insert CondicoesEspeciais;
        
        
         
         
         String json = '{"IdNotaFiscal":"'+notasFiscais.Id+'",'+
             			'"IdPromocao":"'+promocao.Id+'",'+
             			'"NumeroCupom":"'+'5'+'",'+
             			'"NumeroBrinde":"'+'5'+'"}';
         
        
         
         //String JsonMsg = JSON.serialize(json);
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/NotaFiscal';
		request.requestBody = blob.valueOf(json);
        request.httpMethod = 'PUT';
		
        RestContext.request = request;

     	NotaFiscalManager.deleteNTFS(acc.Id,notasFiscais.Id,promocao.Id,'6','5');

    }
    
    static testMethod void testdoNotaFiscalPutSembonus() {
         // setup test data  
       	
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
        promocao.TW1_Valor_Min_NTFS__c = 100;
    	promocao.TW1_Troca_por__c = 'Cupom';
    	promocao.TW1_Acumula_Saldo__c = true;
    	promocao.TW1_Contabiliza_Bonus__c = false;
    	promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
    	promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        promocao.TW1_Data_Inicio__c = DateTime.now().date();
    
    Insert promocao;
         
           TW1_Brinde__c brinde = new TW1_Brinde__c();
            brinde.Name = 'Caneta';
       Insert brinde;
    
           
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
        
         NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 500;
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Promocao__c = promocao.Id;
        notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        Insert notasFiscais;
         
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
        CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        Insert CondicoesEspeciais;
        
        
         
         
         String json = '{"IdNotaFiscal":"'+notasFiscais.Id+'",'+
             			'"IdPromocao":"'+promocao.Id+'",'+
             			'"NumeroCupom":"'+'5'+'",'+
             			'"NumeroBrinde":"'+'5'+'"}';
         
        
         
         //String JsonMsg = JSON.serialize(json);
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/NotaFiscal';
		request.requestBody = blob.valueOf(json);
        request.httpMethod = 'PUT';
		
        RestContext.request = request;

     	NotaFiscalManager.deleteNTFS(acc.Id,notasFiscais.Id,promocao.Id,'6','5');

    }
    
    static testMethod void testdoNotaFiscalPutSembonusAmbos() {
         // setup test data  
       	
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
        promocao.TW1_Valor_Min_NTFS__c = 100;
    	promocao.TW1_Troca_por__c = 'Ambos';
    	promocao.TW1_Acumula_Saldo__c = true;
    	promocao.TW1_Contabiliza_Bonus__c = false;
    	promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
    	promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = shopping.Id;
        promocao.TW1_Data_Fim__c = DateTime.now().date();
        promocao.TW1_Data_Inicio__c = DateTime.now().date();
    
    Insert promocao;
         
           TW1_Brinde__c brinde = new TW1_Brinde__c();
            brinde.Name = 'Caneta';
       Insert brinde;
    
           
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
        
         NTFS__c notasFiscais = new NTFS__c();
        notasFiscais.Forma_de_Pagamento_Picklist__c = 'Cartão Caixa';
        notasFiscais.TW1_Valor_RS__c = 500;
        notasFiscais.TW1_Forma_de_pagamento__c = 'Cartão Caixa';
        notasFiscais.TW1_Cliente__c=acc.Id;
        notasFiscais.TW1_Shopping__c= Shopping.Id;
        notasFiscais.TW1_Promocao__c = promocao.Id;
        notasFiscais.TW1_Data_da_Nota__c = promocao.TW1_Data_Inicio__c;
        Insert notasFiscais;
         
        TW1_Condicoes_Especiais__c CondicoesEspeciais = new TW1_Condicoes_Especiais__c();
        CondicoesEspeciais.TW1_Bonus_Mult_Brinde__c = 2;
        CondicoesEspeciais.TW1_Bonus_Mult_Cupom__c = 2;
        CondicoesEspeciais.TW1_Cartao__c = 'Cartão Caixa';
        CondicoesEspeciais.TW1_Promocao__c = promocao.Id;
        CondicoesEspeciais.TW1_Prioridade_da_condicao__c = '1';
        Insert CondicoesEspeciais;
        
        
         
         
         String json = '{"IdNotaFiscal":"'+notasFiscais.Id+'",'+
             			'"IdPromocao":"'+promocao.Id+'",'+
             			'"NumeroCupom":"'+'5'+'",'+
             			'"NumeroBrinde":"'+'5'+'"}';
         
        
         
         //String JsonMsg = JSON.serialize(json);
        
        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/NotaFiscal';
		request.requestBody = blob.valueOf(json);
        request.httpMethod = 'PUT';
		
        RestContext.request = request;

     	NotaFiscalManager.deleteNTFS(acc.Id,notasFiscais.Id,promocao.Id,'6','5');

    }

}