@RestResource(urlMapping='/TrocarBrinde/*')
global with sharing class TrocarBrindeManager {
    
    @HttpGet
    global static ResponseWrapper getInfBrindes(){
        
        RestRequest req = RestContext.request;
        
        String IdCliente = req.params.get('IdCliente');
        String IdPromocao = req.params.get('IdPromocao');
        
        List<TW1_Brindes_da_Promocao__c> brindesPromocao = [Select Id,TW1_Brinde__c From TW1_Brindes_da_Promocao__c Where TW1_Promocao__c=:IdPromocao ];
        List<TW1_Brindes_Entregues__c> brindesEntregues = [Select Id,Quantidade__c,TW1_Brinde__c,Data_Entrega__c,Tipo__c,Valor__c from TW1_Brindes_Entregues__c Where Parametros_da_Promocao__c=:IdPromocao And TW1_Cliente__c=:IdCliente];        
        
        Set<string> brindesIds = new Set<string>();
        
        for(TW1_Brindes_da_Promocao__c item :brindesPromocao){
            brindesIds.add(item.TW1_Brinde__c);
        }
        
        List<TW1_Brinde__c> listabrindes = [Select Id,Name,TW1_Foto__c,Tipo__c,Valor__c From TW1_Brinde__c Where Id In:brindesIds];
        Map<Id,TW1_Brinde__c> brindes = new Map<Id,TW1_Brinde__c>(listabrindes);
        
        ResponseWrapper responseWrapper = new ResponseWrapper();
        responseWrapper.listbrinde = new List<Brinde>();
        responseWrapper.listBrindesTrocados = new List<BrindeTrocados>();
        
        for(TW1_Brindes_da_Promocao__c item :brindesPromocao)
        {
            TW1_Brinde__c brindeSalesfoce = brindes.get(item.TW1_Brinde__c);
            
            Brinde brinde = new Brinde();
            brinde.IdBrinde = brindeSalesfoce.Id;
            brinde.TW1_BrindeName = brindeSalesfoce.Name;
            brinde.TW1_BrindeFoto = GetBase64(brindeSalesfoce.TW1_Foto__c);
            brinde.Tipo = brindeSalesfoce.Tipo__c;
            brinde.Valor = brindeSalesfoce.Valor__c;
            brinde.Quantidade = 0;
            
            responseWrapper.listbrinde.add(brinde);
        }
        
        for(TW1_Brindes_Entregues__c item :brindesEntregues)
        {
            TW1_Brinde__c brindeSalesfoce = brindes.get(item.TW1_Brinde__c);
            
            BrindeTrocados brindeTrocados = new BrindeTrocados();
            
            brindeTrocados.TW1_BrindeName = brindeSalesfoce.Name;
            brindeTrocados.TW1_BrindeFoto = GetBase64(brindeSalesfoce.TW1_Foto__c);
            brindeTrocados.Valor = item.Valor__c;
            brindeTrocados.Quantidade = item.Quantidade__c.intValue();
            brindeTrocados.Data_Entrega = item.Data_Entrega__c;
            
            responseWrapper.listBrindesTrocados.add(brindeTrocados);
        }
        
        return responseWrapper;
        
    }
    
    @HttpPost
    global static string TrocaBrinde(RequestWrapper requestWrapper){
        Savepoint sp = Database.setSavepoint();
        
        try{
            
            TW1_Terminal__c Terminal = [Select Id,TW1_Stand__r.Id From TW1_Terminal__c where TW1_Operador__c=:requestWrapper.IdOperador Limit 1];
            List<TW1_Estoque__c> listOrigemestoque = [Select Id,Name,TW1_Quantidade__c,TW1_Brinde__c From TW1_Estoque__c Where TW1_Tipo__c='Estoque Stand' And TW1_Stand__c=:Terminal.TW1_Stand__r.Id And TW1_Shopping__c=:requestWrapper.IdShopping];
            TW1_Parametros_Promocao__c paramentrosPromocao = [Select Id,Tw1_CobrarBrinde__c From TW1_Parametros_Promocao__c where Id=:requestWrapper.IdPromocao Limit 1];
            List<TW1_Brindes_Entregues__c> brindes = MapBrinde(requestWrapper.listbrinde,requestWrapper.IdPromocao,requestWrapper.IdShopping);

            TW1_Caixa__c caixa = [Select Id From TW1_Caixa__c Where TW1_Operador__c=:requestWrapper.IdOperador Order By TW1_Data_de_Abertura__c Desc Limit 1];
            
            List<TW1_Extrato__c> listExtrato = new List<TW1_Extrato__c>();
            
            For(TW1_Brindes_Entregues__c brinde :brindes)
            {
                Boolean BrindeEstoque = False;
                
                For(TW1_Estoque__c itemEstoque :listOrigemestoque)
                {
                    If(itemEstoque.TW1_Brinde__c == brinde.TW1_Brinde__c){
                        If(itemEstoque.TW1_Quantidade__c >= brinde.Quantidade__c){
                            
                            listOrigemestoque.get(listOrigemestoque.indexOf(itemEstoque)).TW1_Quantidade__c = listOrigemestoque.get(listOrigemestoque.indexOf(itemEstoque)).TW1_Quantidade__c - brinde.Quantidade__c;
                            
                            If(paramentrosPromocao.Tw1_CobrarBrinde__c == True && brinde.Tipo__c != 'Voucher'){
                                
                                TW1_Extrato__c extrato = new TW1_Extrato__c();
                                extrato.TW1_Caixa__c = caixa.Id;
                                extrato.TW1_Data__c = DateTime.now();
                                extrato.TW1_Tipo__c = 'ValorBrinde';
                                extrato.TW1_Valor__c = brinde.Quantidade__c * brinde.Valor__c;
                                listExtrato.add(extrato);
                            }
                        }
                        else{
                            return 'O estoque de brindes neste stand não é suficiente para efetuar essa troca';
                        }
                        BrindeEstoque = True;
                    }
                }
                
                If(BrindeEstoque == False)
                    return 'Não existe estoque para este brinde';
            }

            
			update listOrigemestoque;
            system.debug(brindes);
            insert brindes;
            If(listExtrato.size() >=1)
                insert listExtrato;
            
        }catch (Exception ce) {
            Database.rollback(sp);
            
            return 'Erro na operacao ' + ce.getMessage() + ' - ' + ce.getLineNumber();
            //+ ce.getMessage() + ce.getLineNumber()
        }  
        
        return 'Troca feita com sucesso';
    }
    
    global class ResponseWrapper
    {
        public List<Brinde> listbrinde;
        Public List<BrindeTrocados> listBrindesTrocados;
    }  
    
    global class RequestWrapper
    {
        public List<Brinde> listbrinde;
        Public String IdPromocao;
        Public String IdShopping;
        Public String IdOperador;
    } 
    
    
    global class BrindeTrocados 
    {
        public Integer Quantidade;
        public string TW1_BrindeName;
        public string TW1_BrindeFoto;
        public Date Data_Entrega;
        public Decimal Valor;
    }
    
    global class Brinde 
    {
        Public String IdBrinde;
        Public String IdCliente;
        Public String IdPromocao;
        public string TW1_BrindeName;
        public string TW1_BrindeFoto;
        public string Tipo;
        public Integer Quantidade;
        public Decimal Valor;
    }
    
    Private static string GetBase64(string foto){
        
        String strBase64 = '';
        if(foto != null){
            String bookimg = foto.substringBetween('<img', 'img>');
            String imgsrc = bookimg.substringBetween('src="', '"');
            imgsrc = imgsrc.replace('amp;', '');
            PageReference page = new PageReference(imgsrc);
            Blob imgblob = page.getContent();
            strBase64  = 'data:image/jpeg;base64,' + EncodingUtil.base64Encode(imgblob);
        }
        
        return strBase64;
        
    }
    
    Private static List<TW1_Brindes_Entregues__c> MapBrinde(List<Brinde> listBrindes,String IdPromocao, string IdShopping){
        
        List<TW1_Brindes_Entregues__c> listBrindeSalesforce = new List<TW1_Brindes_Entregues__c>();
        date vaData = DateTime.now().date();
        
        List<TW1_Brindes_Entregues__c> brindesEntregues = [Select Id,TW1_Cliente__c,Quantidade__c,TW1_Participante__c,TW1_Brinde__c,Data_Entrega__c,Tipo__c,Valor__c,TW1_Formas_de_Pagamento__c,TW1_Comum_Chekbox__c,TW1_Bonus_Chekbox__c from TW1_Brindes_Entregues__c Where Parametros_da_Promocao__c=:IdPromocao And TW1_Cliente__c=:listBrindes[0].IdCliente];
        TW1_Parametros_Promocao__c Promocao = [Select Id,TW1_Data_Inicio__c,TW1_Data_Fim__c,TW1_Valor_Min_NTFS__c,TW1_Max_Brinde_Clientes__c,Max_Cupom__c,Max_Bonus_Cliente__c,TW1_Acumula_Saldo__c,TW1_Troca_por__c,TW1_Condicoes_especiais_cart_credito__c,TW1_Contabiliza_Bonus__c,Max_Brindes_por_Troca__c From TW1_Parametros_Promocao__c Where TW1_Shopping__c=:IdShopping And TW1_Data_Fim__c >=:vaData Limit 1];
        List<TW1_Condicoes_Especiais__c> CondicoesEspeciais = [Select Id,TW1_Prioridade_da_condicao__c,TW1_Bonus_Mult_Brinde__c,TW1_Forma_de_Pagamento__c,TW1_Bonus_Mult_Cupom__c,TW1_Cartao__c,TW1_Promocao__c From TW1_Condicoes_Especiais__c where TW1_Promocao__c=:Promocao.Id];
        //(public string Saldo) CHEGANDO A SOMA Do Saldo(R$) e Numero de Cupon de direito
        List<NTFS__c> notasFiscais = [select Id,Forma_de_Pagamento_Picklist__c,TW1_Participante__c,TW1_Valor_RS__c From NTFS__c Where TW1_Cliente__c=:listBrindes[0].IdCliente And TW1_Shopping__c=:IdShopping And TW1_Data_da_Nota__c >=:promocao.TW1_Data_Inicio__c And TW1_Data_da_Nota__c <=:promocao.TW1_Data_Fim__c];           
        
        
        Decimal SobraBonus = 0;
        Decimal Sobra = 0;
        Decimal ValorTotalBonus = 0;
        Integer Quantidadebonus = 0;
        Decimal ValorTotal = 0;
        Set<string> SetIdsNotasEspeciais = new Set<string>();
        Map<String,Integer> formaPrioridade = new Map<String,Integer>(); 
        List<TW1_Brindes_Entregues__c> Listcupinsert = new List<TW1_Brindes_Entregues__c>();
        
        Integer vahistoricoNtrocados = 0;
        //FAZER COM O RELACIONAMENTO QUE O MANOEL VAI CRIAR
        for(TW1_Brindes_Entregues__c brindes : BrindesEntregues){
            vahistoricoNtrocados = vahistoricoNtrocados + Integer.valueOf(brindes.Quantidade__c);
        }
        
        //Calculando a quantidade de Cupom bonus
        If(CondicoesEspeciais.size() >= 1 && Promocao.TW1_Contabiliza_Bonus__c)
        {
            for(TW1_Condicoes_Especiais__c condicoes : CondicoesEspeciais)
            {
                Decimal valortemporariototalnotas = 0;
                
                for(NTFS__c nota : notasFiscais)
                {
                    If(nota.Forma_de_Pagamento_Picklist__c == condicoes.TW1_Forma_de_Pagamento__c){
                        System.debug('NOta '+ nota.Forma_de_Pagamento_Picklist__c + ' Valor '+ nota.TW1_Valor_RS__c);
                        valortemporariototalnotas = valortemporariototalnotas + nota.TW1_Valor_RS__c;
                        ValorTotalBonus = ValorTotalBonus + nota.TW1_Valor_RS__c;
                        SetIdsNotasEspeciais.add(nota.Id);
                    }
                    
                }
                
                Decimal Quanti =  valortemporariototalnotas / promocao.TW1_Valor_Min_NTFS__c;
                
                Integer QuantidadeCorrente = Quanti.intValue();
                //Quantidadebonus = QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Brinde__c.intValue();
                Quantidadebonus = Quantidadebonus + (QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Brinde__c.intValue());
                Integer QuantidadeCorrenteBonus = QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Brinde__c.intValue();
                
                for(Integer i = 1; i <= QuantidadeCorrenteBonus; i++)
                {
                    TW1_Brindes_Entregues__c cuponItem = new TW1_Brindes_Entregues__c();
                    cuponItem.TW1_Formas_de_Pagamento__c = condicoes.TW1_Forma_de_Pagamento__c;
                    
                    if(i <= QuantidadeCorrente)
                        cuponItem.TW1_Comum_Chekbox__c = true;
                    else
                        cuponItem.TW1_Bonus_Chekbox__c = true;
                    
                    Listcupinsert.add(cuponItem);
                }
                
                If(promocao.TW1_Acumula_Saldo__c){
                    SobraBonus += valortemporariototalnotas - (QuantidadeCorrente * promocao.TW1_Valor_Min_NTFS__c);
                    If((valortemporariototalnotas - (QuantidadeCorrente * promocao.TW1_Valor_Min_NTFS__c)) > 0)
                        formaPrioridade.put(condicoes.TW1_Forma_de_Pagamento__c,Integer.valueOf(condicoes.TW1_Prioridade_da_condicao__c));
                }
            }
            
            If(promocao.TW1_Acumula_Saldo__c){
                
                if(SobraBonus >= promocao.TW1_Valor_Min_NTFS__c) {
                    Decimal Totalsobra = SobraBonus / promocao.TW1_Valor_Min_NTFS__c;
                    
                    Integer IntotalSobra = Totalsobra.intValue();
                    
                    Set<string> setFormaspagamento = (Set<string>) formaPrioridade.keySet();
                    string formaPagamentoCorrente = '';
                    
                    if(IntotalSobra >= 1){
                        
                        Integer contador = 100;
                        
                        for(string item : setFormaspagamento)
                        {
                            Integer itemValor = formaPrioridade.get(item);
                            if(itemValor < contador){
                                formaPagamentoCorrente = item;
                                contador = itemValor;
                            }
                        }
                        
                        for(Integer i = 1; i <= IntotalSobra; i++)
                        {
                            TW1_Brindes_Entregues__c cuponItem = new TW1_Brindes_Entregues__c();
                            
                            cuponItem.TW1_Formas_de_Pagamento__c = formaPagamentoCorrente;
                            
                            cuponItem.TW1_Comum_Chekbox__c = true;
                            
                            Listcupinsert.add(cuponItem);
                        }
                        
                    }
                    
                    
                    Quantidadebonus = Quantidadebonus + IntotalSobra;
                    
                    SobraBonus = SobraBonus - (IntotalSobra*promocao.TW1_Valor_Min_NTFS__c);
                    
                }
            }
            
            If(Promocao.Max_Brindes_por_Troca__c != 0 && Quantidadebonus > Promocao.Max_Brindes_por_Troca__c)
                Quantidadebonus = Promocao.Max_Brindes_por_Troca__c.intValue();
        }
        
        System.debug('Quantidadebonus ---- Quantidadebonus --- '+Quantidadebonus);
        System.debug('Listcupinsert.size ---- Quantidadebonus --- '+Listcupinsert.size());
        
        //Calculando a quantidade de cupom
        for(NTFS__c nota : notasFiscais)
        {
            If(!SetIdsNotasEspeciais.contains(nota.Id)){
                ValorTotal = ValorTotal + nota.TW1_Valor_RS__c;
            }
        }
        
        Decimal Numero = ValorTotal / promocao.TW1_Valor_Min_NTFS__c;
        Integer NumeroDireitoNormal = Numero.intValue();
        
         System.debug('NumeroDireitoNormal ---- NumeroDireitoNormal --- '+NumeroDireitoNormal);
         
        
        for(Integer i = 1; i <= NumeroDireitoNormal; i++)
        {
            TW1_Brindes_Entregues__c cuponItem = new TW1_Brindes_Entregues__c();
            
            cuponItem.TW1_Formas_de_Pagamento__c = 'Comum';
            
            cuponItem.TW1_Comum_Chekbox__c = true;
            
            Listcupinsert.add(cuponItem);
        }
        
        System.debug('Listcupinsert.size ---- NumeroDireitoNormal --- '+Listcupinsert.size());
        
        Integer NumeroDireitoTotal = Quantidadebonus + NumeroDireitoNormal;
        
	System.debug('NumeroDireitoTotal ---- NumeroDireitoTotal --- '+ NumeroDireitoTotal);        
        
        If(promocao.TW1_Acumula_Saldo__c){
            Sobra = Sobra + (ValorTotal - (NumeroDireitoNormal * promocao.TW1_Valor_Min_NTFS__c));
            
            Decimal Totalsobra = (SobraBonus + Sobra) / promocao.TW1_Valor_Min_NTFS__c;
            Integer IntotalSobra = Totalsobra.intValue();
            NumeroDireitoTotal = NumeroDireitoTotal + IntotalSobra;
            
            System.debug('IntotalSobra ---- IntotalSobra --- '+ IntotalSobra);
             System.debug('NumeroDireitoTotal ---- NumeroDireitoTotal --- '+ NumeroDireitoTotal);
            
            if(IntotalSobra >= 1){
                
                for(Integer i = 1; i <= IntotalSobra; i++)
                {
                    TW1_Brindes_Entregues__c cuponItem = new TW1_Brindes_Entregues__c();
                    
                    cuponItem.TW1_Formas_de_Pagamento__c = 'Comum';
                    
                    cuponItem.TW1_Comum_Chekbox__c = true;
                    
                    Listcupinsert.add(cuponItem);
                    System.debug('Listcupinsert.add(cuponItem); ---- SOBRA --- '+ Listcupinsert.size());      
                }
            } 
        }
        
        //Codigo com a logica de preencher as formas de pagamento
        //List<TW1_Brindes_Entregues__c> listcopia = Listcupinsert.clone();
        List<TW1_Brindes_Entregues__c> Listcup = new List<TW1_Brindes_Entregues__c>();
        List<TW1_Brindes_Entregues__c> ListBrindeExcluir = new List<TW1_Brindes_Entregues__c>();
        
        if(brindesEntregues.size() > 0)
        {
            for(Integer j = 0; j < brindesEntregues.size(); j++)
            {
                if(brindesEntregues.get(j).Quantidade__c > 1){
                    
                    ListBrindeExcluir.add(brindesEntregues.get(j));
                    
                    for(Integer i = 1; i <= brindesEntregues.get(j).Quantidade__c; i++)
                    {
                        TW1_Brindes_Entregues__c brinde = new TW1_Brindes_Entregues__c();
                        
                        brinde.TW1_Participante__c = notasFiscais[0].TW1_Participante__c;
                        brinde.TW1_Brinde__c = brindesEntregues.get(j).TW1_Brinde__c;
                        brinde.Quantidade__c = 1.0;
                        brinde.Data_Entrega__c = DateTime.now().date();
                        brinde.Tipo__c = brindesEntregues.get(j).Tipo__c;
                        brinde.Valor__c = brindesEntregues.get(j).Valor__c;
                        brinde.Parametros_da_Promocao__c = IdPromocao;
                        brinde.TW1_Cliente__c = brindesEntregues.get(j).TW1_Cliente__c;
                        brinde.TW1_Shopping_Lookup__c = IdShopping;
                        brinde.TW1_Formas_de_Pagamento__c = Listcupinsert.get(0).TW1_Formas_de_Pagamento__c;
                        brinde.TW1_Comum_Chekbox__c = Listcupinsert.get(0).TW1_Comum_Chekbox__c;
                        brinde.TW1_Bonus_Chekbox__c = Listcupinsert.get(0).TW1_Bonus_Chekbox__c;
                        System.debug('antes '+brinde);
                        Listcupinsert.remove(0);
                        
                        Listcup.add(brinde);
                        System.debug(brinde);
                    }
                }
                else{
                    brindesEntregues.get(j).TW1_Formas_de_Pagamento__c = Listcupinsert.get(0).TW1_Formas_de_Pagamento__c;
                    brindesEntregues.get(j).TW1_Comum_Chekbox__c = Listcupinsert.get(0).TW1_Comum_Chekbox__c;
                    brindesEntregues.get(j).TW1_Bonus_Chekbox__c = Listcupinsert.get(0).TW1_Bonus_Chekbox__c;
                    brindesEntregues.get(j).TW1_Participante__c = notasFiscais[0].TW1_Participante__c;
                    Listcupinsert.remove(0);
                }
            }
            if(brindesEntregues.size() > 0)
            update brindesEntregues;
            if(ListBrindeExcluir.size() > 0)
            delete ListBrindeExcluir;
            //////////////////////////////////////////////////////////////////////
            for(Integer i = 0; i < listBrindes.size(); i++)
            {
                for(Integer j = 1; j <= listBrindes.get(i).Quantidade; j++)
                {
                    
                    TW1_Brindes_Entregues__c cuponcorrente = Listcupinsert.get(0);
                    
                    TW1_Brindes_Entregues__c brinde = new TW1_Brindes_Entregues__c();
                    
                    brinde.TW1_Participante__c = notasFiscais[0].TW1_Participante__c;
                    brinde.TW1_Brinde__c = listBrindes.get(i).IdBrinde;
                    brinde.Quantidade__c = 1.0;
                    brinde.Data_Entrega__c = DateTime.now().date();
                    brinde.Tipo__c = listBrindes.get(i).Tipo;
                    brinde.Valor__c = listBrindes.get(i).Valor;
                    brinde.Parametros_da_Promocao__c = IdPromocao;
                    brinde.TW1_Cliente__c = listBrindes.get(i).IdCliente;
                    brinde.TW1_Shopping_Lookup__c = IdShopping;
                    brinde.TW1_Formas_de_Pagamento__c = cuponcorrente.TW1_Formas_de_Pagamento__c;
                    brinde.TW1_Comum_Chekbox__c = cuponcorrente.TW1_Comum_Chekbox__c;
                    brinde.TW1_Bonus_Chekbox__c = cuponcorrente.TW1_Bonus_Chekbox__c;
                    Listcupinsert.remove(0);
                    
                    Listcup.add(brinde);
                }
            }
            
        }else{
            
            for(Integer i = 0; i < listBrindes.size(); i++)
            {
                for(Integer j = 1; j <= listBrindes.get(i).Quantidade; j++)
                {
                    
                    TW1_Brindes_Entregues__c cuponcorrente = Listcupinsert.get(0);
                    
                    TW1_Brindes_Entregues__c brinde = new TW1_Brindes_Entregues__c();
                    
                    brinde.TW1_Participante__c = notasFiscais[0].TW1_Participante__c;
                    brinde.TW1_Brinde__c = listBrindes.get(i).IdBrinde;
                    brinde.Quantidade__c = 1.0;
                    brinde.Data_Entrega__c = DateTime.now().date();
                    brinde.Tipo__c = listBrindes.get(i).Tipo;
                    brinde.Valor__c = listBrindes.get(i).Valor;
                    brinde.Parametros_da_Promocao__c = IdPromocao;
                    brinde.TW1_Cliente__c = listBrindes.get(i).IdCliente;
                    brinde.TW1_Shopping_Lookup__c = IdShopping;
                    brinde.TW1_Formas_de_Pagamento__c = cuponcorrente.TW1_Formas_de_Pagamento__c;
                    brinde.TW1_Comum_Chekbox__c = cuponcorrente.TW1_Comum_Chekbox__c;
                    brinde.TW1_Bonus_Chekbox__c = cuponcorrente.TW1_Bonus_Chekbox__c;
                    Listcupinsert.remove(0);
                    
                    Listcup.add(brinde);
                }
            }
            
        }

        return Listcup;
    }
    
}