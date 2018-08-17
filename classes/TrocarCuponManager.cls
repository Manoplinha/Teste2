@RestResource(urlMapping='/TrocarCupom/*')
global with sharing class TrocarCuponManager {
    
    @HttpGet
    global static requestWrapper getTrocarCuponPorId(){
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            String accountId = req.params.get('accountId');
            Integer Quantidade = Integer.valueOf(req.params.get('QuantidadeCupons'));
            String Shopping = req.params.get('IdShopping');
            String IdOperador = req.params.get('IdOperador');
            String NomeLojista = req.params.get('NomeLojista') == null? '':req.params.get('NomeLojista');
            String NomeLoja = req.params.get('NomeLoja') == null ? '':req.params.get('NomeLoja');
            
            Boolean EspacoNomeLojista = NomeLojista.contains('-');
            
            If(EspacoNomeLojista)
                NomeLojista = NomeLojista.replace('-', ' ');
            
            Boolean EspacoNomeLoja = NomeLoja.contains('-');
            
            If(EspacoNomeLoja)
                NomeLoja = NomeLoja.replace('-', ' ');
            
            
            requestWrapper acc = new requestWrapper();
            acc.cupom = new List<Cupom>();
            
            date vaData = DateTime.now().date();
            
            TW1_Parametros_Promocao__c Promocao = [Select Id,Name,TW1_Data_Inicio__c,TW1_Data_Fim__c,TW1_Valor_Min_NTFS__c,TW1_Max_Brinde_Clientes__c,Max_Cupom__c,Max_Bonus_Cliente__c,TW1_Acumula_Saldo__c,TW1_Troca_por__c,TW1_Condicoes_especiais_cart_credito__c,TW1_Contabiliza_Bonus__c,Max_Brindes_por_Troca__c,TW1_Cert_de_Aut__c,TW1_Pergunta__c From TW1_Parametros_Promocao__c Where TW1_Shopping__c=:Shopping And TW1_Data_Fim__c >=:vaData Limit 1];
            TW1_Shopping__c shoppingCorrente = [Select Id,Name From TW1_Shopping__c Where Id=:Shopping Limit 1];
            List<TW1_Condicoes_Especiais__c> CondicoesEspeciais = [Select Id,TW1_Prioridade_da_condicao__c,TW1_Bonus_Mult_Brinde__c,TW1_Forma_de_Pagamento__c,TW1_Bonus_Mult_Cupom__c,TW1_Cartao__c,TW1_Promocao__c From TW1_Condicoes_Especiais__c where TW1_Promocao__c=:Promocao.Id];
            List<TW1_Cupom__c> Cupons = [Select Id,Name,TW1_Formas_de_Pagamento__c,Participante__c,TW1_Comum_Chekbox__c,TW1_Bonus_Chekbox__c From TW1_Cupom__c Where TW1_Nome_do_Cliente__c=:accountId And TW1_Parametro_Promocao__c=:Promocao.Id];	
            List<NTFS__c> notasFiscais = [select Id,Forma_de_Pagamento_Picklist__c,TW1_Participante__c,TW1_Valor_RS__c From NTFS__c Where TW1_Cliente__c=:accountId And TW1_Shopping__c=:Shopping And TW1_Data_da_Nota__c >=:promocao.TW1_Data_Inicio__c And TW1_Data_da_Nota__c <=:promocao.TW1_Data_Fim__c];    
            
            Account account = [Select  Id,
                               FirstName,
                               LastName,
                               Name,
                               TW1_Av_Rua__c,
                               TW1_Numero__c,
                               TW1_Bairro__c,
                               CEP__c,
                               TW1_Complemento__c,
                               TW1_Estado_civil__c,
                               TW1_Sexo__c,
                               TW1_Cidade__c,
                               TW1_UF_de_emissao__c,
                               TW1_CPF__c,
                               TW1_Identidade__c,
                               PersonEmail,
                               TW1_Permite_SMS__c,
                               TW1_Data_Nascimento__c,
                               DDD__c,
                               TW1_DDI__c,
                               Phone,
                               TW1_EmailCB__c,
                               TW1_TelefoneCB__c,
                               TW1_Correspondencia__c
                               FROM Account Where Id=:accountId Limit 1];
            
            
            List<TW1_Cupom__c> Listcup = getHistoricoPorIdCliente(Promocao,CondicoesEspeciais,Cupons,notasFiscais,account,Quantidade,NomeLojista,NomeLoja,accountId,IdOperador,shoppingCorrente);
            
            Map<Id,TW1_Cupom__c> MapCup = new Map<Id,TW1_Cupom__c>(Listcup);
            
            List<Tw1_Cupom__c> listaCupom = [Select Id,Name,TW1_Operador__r.Name From TW1_Cupom__c Where Id In:MapCup.keySet()];
            
            Map<Id,TW1_Cupom__c> litsMapCup = new Map<Id,TW1_Cupom__c>(listaCupom);
            
            acc.cupom = MapCupom(litsMapCup,Listcup,Promocao,account,shoppingCorrente,NomeLojista,NomeLoja);
            
            return acc;
            
        }
        catch (Exception ex) {
            System.debug(ex.getLineNumber() + ' ' + ex.getMessage());
            return new requestWrapper();
        }  
    }
    
    Private static List<Cupom> MapCupom(Map<Id,TW1_Cupom__c> litsMapCup,List<TW1_Cupom__c> Listcup,TW1_Parametros_Promocao__c Promocao,Account account,TW1_Shopping__c shoppingCorrente, string NomeLojista,string NomeLoja)
    {
        List<Cupom> listcupomSalesforce = new List<Cupom>();
        
        for(TW1_Cupom__c Cup : Listcup){
            
            Cupom cupom = new Cupom();
            
            DateTime dataCup = Cup.TW1_Data__c;
            
            cupom.Nome_Lojista = NomeLojista;
            cupom.Nome_da_Loja = NomeLoja;
            cupom.TW1_DataCupom = dataCup.format('dd/MM/yyyy HH:mm:ss');
            cupom.Numero_Cupom = litsMapCup.get(Cup.Id).Name;
            cupom.TW1_Nome_do_Cliente = account.Name;
            cupom.TW1_Bairro =  account.TW1_Bairro__c;
            cupom.TW1_Celular =  String.valueOf(account.DDD__c) + String.valueOf(account.Phone);
            cupom.TW1_CEP =  String.valueOf(account.CEP__c);
            cupom.TW1_Cidade =  account.TW1_Cidade__c;
            cupom.TW1_Complemento =  account.TW1_Complemento__c;
            cupom.TW1_CPF =  account.TW1_CPF__c;
            cupom.TW1_Data_de_Nascimento = account.TW1_Data_Nascimento__c.day() + '/' + account.TW1_Data_Nascimento__c.month() + '/' + account.TW1_Data_Nascimento__c.year();
            System.debug(cupom.TW1_Data_de_Nascimento);
            cupom.TW1_Email =  account.PersonEmail;
            cupom.Numero =  String.valueOf(account.TW1_Numero__c);
            cupom.TW1_RG =  account.TW1_Identidade__c;
            cupom.TW1_Rua =  account.TW1_Av_Rua__c;
            cupom.Sexo =  account.TW1_Sexo__c;
            cupom.TW1_UF =  account.TW1_UF_de_emissao__c;
            cupom.TW1_Certificado_Autenticao_Promocao = Promocao.TW1_Cert_de_Aut__c;
            cupom.TW1_Pergunta = Promocao.TW1_Pergunta__c;
            cupom.TW1_Operador = litsMapCup.get(Cup.Id).TW1_Operador__r.Name;
            cupom.Nome_Parametro_Promocao = Promocao.Name;
            cupom.Nome_Shopping = shoppingCorrente.Name; 
            
            listcupomSalesforce.add(cupom);
        }
        
        return listcupomSalesforce;       
    }
    
    
    public static List<TW1_Cupom__c> getHistoricoPorIdCliente(TW1_Parametros_Promocao__c Promocao,List<TW1_Condicoes_Especiais__c> CondicoesEspeciais,List<TW1_Cupom__c> Cupons,List<NTFS__c> notasFiscais,Account account,Integer Quantidade,string NomeLojista,string NomeLoja, string accountId,string IdOperador,TW1_Shopping__c shoppingCorrente){
        
        HistoricoCupom historicoCupom = new HistoricoCupom();
        
        Decimal SobraBonus = 0;
        Decimal Sobra = 0;
        Decimal ValorTotalBonus = 0;
        Integer Quantidadebonus = 0;
        Decimal ValorTotal = 0;
        Set<string> SetIdsNotasEspeciais = new Set<string>();
        Map<String,Integer> formaPrioridade = new Map<String,Integer>(); 
        List<TW1_Cupom__c> Listcupinsert = new List<TW1_Cupom__c>();
        
        historicoCupom.NTrocados = Cupons.size();
        
        //Calculando a quantidade de Cupom bonus
        If(CondicoesEspeciais.size() >= 1 && Promocao.TW1_Contabiliza_Bonus__c)
        {
            for(TW1_Condicoes_Especiais__c condicoes : CondicoesEspeciais)
            {
                Decimal valortemporariototalnotas = 0;
                
                for(NTFS__c nota : notasFiscais)
                {
                    If(nota.Forma_de_Pagamento_Picklist__c == condicoes.TW1_Forma_de_Pagamento__c){
                        valortemporariototalnotas = valortemporariototalnotas + nota.TW1_Valor_RS__c;
                        ValorTotalBonus = ValorTotalBonus + nota.TW1_Valor_RS__c;
                        SetIdsNotasEspeciais.add(nota.Id);
                    }
                }
                
                Decimal Quanti =  valortemporariototalnotas / promocao.TW1_Valor_Min_NTFS__c;
                
                Integer QuantidadeCorrente = Quanti.intValue();
                //Quantidadebonus = QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Cupom__c.intValue();
                Quantidadebonus = Quantidadebonus + (QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Cupom__c.intValue());
				Integer QuantidadeCorrenteBonus = QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Cupom__c.intValue();

                System.debug('QuantidadeCorrenteBonus: '+QuantidadeCorrenteBonus);
                
                for(Integer i = 1; i <= QuantidadeCorrenteBonus; i++)
                                {
                    TW1_Cupom__c cuponItem = new TW1_Cupom__c();
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
             System.debug('Quantidadebonus: '+Quantidadebonus);
             System.debug('Listcupinsert.size(): '+ Listcupinsert.size());
            
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
                            TW1_Cupom__c cuponItem = new TW1_Cupom__c();
                            
                            cuponItem.TW1_Formas_de_Pagamento__c = formaPagamentoCorrente;

                            cuponItem.TW1_Comum_Chekbox__c = true;
                            
                            Listcupinsert.add(cuponItem);
                        }
                        
                    }
                    
                    Quantidadebonus = Quantidadebonus + IntotalSobra;
                    
                    SobraBonus = SobraBonus - (IntotalSobra*promocao.TW1_Valor_Min_NTFS__c);
                    
                }
            }
            
            If(Promocao.Max_Bonus_Cliente__c != 0 && Quantidadebonus > Promocao.Max_Bonus_Cliente__c)
                Quantidadebonus = Promocao.Max_Bonus_Cliente__c.intValue();
        }
        
         System.debug('Quantidadebonus: '+Quantidadebonus);
         System.debug('Listcupinsert.size(): '+ Listcupinsert.size());
        
        //Calculando a quantidade de cupom
        for(NTFS__c nota : notasFiscais)
        {
            If(!SetIdsNotasEspeciais.contains(nota.Id)){
                ValorTotal = ValorTotal + nota.TW1_Valor_RS__c;
            }
        }
        
        Decimal Numero = ValorTotal / promocao.TW1_Valor_Min_NTFS__c;
        Integer NumeroDireitoNormal = Numero.intValue();
        
        for(Integer i = 1; i <= NumeroDireitoNormal; i++)
        {
            TW1_Cupom__c cuponItem = new TW1_Cupom__c();
            
            cuponItem.TW1_Formas_de_Pagamento__c = 'Comum';
            
            cuponItem.TW1_Comum_Chekbox__c = true;
            
            Listcupinsert.add(cuponItem);
        }
        System.debug('NumeroDireitoNormal: '+ NumeroDireitoNormal);
         System.debug('Listcupinsert.size(): '+ Listcupinsert.size());
        Integer NumeroDireitoTotal = Quantidadebonus + NumeroDireitoNormal;
        
		System.debug('Quantidadebonus = NumeroDireitoNormal: '+ Quantidadebonus + ' - ' +NumeroDireitoNormal);    
        
        If(promocao.TW1_Acumula_Saldo__c){
            Sobra = Sobra + (ValorTotal - (NumeroDireitoNormal * promocao.TW1_Valor_Min_NTFS__c));
            
            Decimal Totalsobra = (SobraBonus + Sobra) / promocao.TW1_Valor_Min_NTFS__c;
            Integer IntotalSobra = Totalsobra.intValue();
            NumeroDireitoTotal = NumeroDireitoTotal + IntotalSobra;
            historicoCupom.Saldo = IntotalSobra < 1 ? (SobraBonus + Sobra) :(SobraBonus + Sobra) - (IntotalSobra*promocao.TW1_Valor_Min_NTFS__c);  
            historicoCupom.Saldo = historicoCupom.Saldo.setscale(2);
            
            if(IntotalSobra >= 1){
                
                for(Integer i = 1; i <= IntotalSobra; i++)
                {
                    TW1_Cupom__c cuponItem = new TW1_Cupom__c();
                    
                    cuponItem.TW1_Formas_de_Pagamento__c = 'Comum';
                    
                    cuponItem.TW1_Comum_Chekbox__c = true;
                    
                    Listcupinsert.add(cuponItem);
                }
            }
             System.debug('Listcupinsert.size(): '+ Listcupinsert.size());
            
        }
                
//
        
       //List<TW1_Cupom__c> listcopia = Cupons.clone();
	   List<TW1_Cupom__c> Listcup = new List<TW1_Cupom__c>();
        
        if(Cupons.size() > 0)
        {
            for(Integer i = 0; i < Cupons.size(); i++)
            {
               Cupons.get(i).TW1_Formas_de_Pagamento__c = Listcupinsert.get(0).TW1_Formas_de_Pagamento__c;
               Cupons.get(i).TW1_Comum_Chekbox__c = Listcupinsert.get(0).TW1_Comum_Chekbox__c;
               Cupons.get(i).TW1_Bonus_Chekbox__c = Listcupinsert.get(0).TW1_Bonus_Chekbox__c;
               Cupons.get(i).Participante__c = notasFiscais[0].TW1_Participante__c;
               Listcupinsert.remove(0);
            }
            
            update Cupons;
            
            for(Integer i = 1; i <= Quantidade; i++)
            {
                TW1_Cupom__c cuponcorrente = Listcupinsert.get(0);
                
                TW1_Cupom__c cup = new TW1_Cupom__c();
                
                cup.Participante__c = notasFiscais[0].TW1_Participante__c;
                cup.TW1_Nome_Lojista__c = NomeLojista;
                cup.TW1_Nome_da_Loja__c = NomeLoja;
                cup.TW1_Data__c = DateTime.now();
                cup.TW1_Nome_do_Cliente__c = accountId;
                cup.TW1_Bairro__c =  account.TW1_Bairro__c;
                cup.TW1_Celular__c =  String.valueOf(account.DDD__c) + String.valueOf(account.Phone);
                cup.TW1_CEP__c =  String.valueOf(account.CEP__c);
                cup.TW1_Cidade__c =  account.TW1_Cidade__c;
                cup.TW1_Complemento__c =  account.TW1_Complemento__c;
                cup.TW1_CPF__c =  account.TW1_CPF__c;
                cup.TW1_Data_de_Nascimento__c =  account.TW1_Data_Nascimento__c;
                cup.TW1_Email__c =  account.PersonEmail;
                cup.Numero__c =  account.TW1_Numero__c;
                cup.TW1_RG__c =  account.TW1_Identidade__c;
                cup.TW1_Rua__c =  account.TW1_Av_Rua__c;
                cup.Sexo__c =  account.TW1_Sexo__c;
                cup.TW1_UF__c =  account.TW1_UF_de_emissao__c;
                cup.TW1_Certificado_Autenticao_Promocao__c = 	Promocao.TW1_Cert_de_Aut__c;
                cup.TW1_Pergunta__c = Promocao.TW1_Pergunta__c;
                cup.TW1_Operador__c = IdOperador;
                cup.TW1_Shopping_Lookup__c = shoppingCorrente.Id;
                cup.TW1_Comum_Chekbox__c = cuponcorrente.TW1_Comum_Chekbox__c;
                cup.TW1_Bonus_Chekbox__c = cuponcorrente.TW1_Bonus_Chekbox__c;
                cup.TW1_Formas_de_Pagamento__c = cuponcorrente.TW1_Formas_de_Pagamento__c;
                cup.TW1_Parametro_Promocao__c = Promocao.Id;
                Listcupinsert.remove(0);
                Listcup.add(cup);             
                
            }
            
        }else{
            
            for(Integer i = 1; i <= Quantidade; i++)
            {
                TW1_Cupom__c cuponcorrente = Listcupinsert.get(0);
                
                TW1_Cupom__c cup = new TW1_Cupom__c();
                
                cup.Participante__c = notasFiscais[0].TW1_Participante__c;
                cup.TW1_Nome_Lojista__c = NomeLojista;
                cup.TW1_Nome_da_Loja__c = NomeLoja;
                cup.TW1_Data__c = DateTime.now();
                cup.TW1_Nome_do_Cliente__c = accountId;
                cup.TW1_Bairro__c =  account.TW1_Bairro__c;
                cup.TW1_Celular__c =  String.valueOf(account.DDD__c) + String.valueOf(account.Phone);
                cup.TW1_CEP__c =  String.valueOf(account.CEP__c);
                cup.TW1_Cidade__c =  account.TW1_Cidade__c;
                cup.TW1_Complemento__c =  account.TW1_Complemento__c;
                cup.TW1_CPF__c =  account.TW1_CPF__c;
                cup.TW1_Data_de_Nascimento__c =  account.TW1_Data_Nascimento__c;
                cup.TW1_Email__c =  account.PersonEmail;
                cup.Numero__c =  account.TW1_Numero__c;
                cup.TW1_RG__c =  account.TW1_Identidade__c;
                cup.TW1_Rua__c =  account.TW1_Av_Rua__c;
                cup.Sexo__c =  account.TW1_Sexo__c;
                cup.TW1_UF__c =  account.TW1_UF_de_emissao__c;
                cup.TW1_Certificado_Autenticao_Promocao__c = 	Promocao.TW1_Cert_de_Aut__c;
                cup.TW1_Pergunta__c = Promocao.TW1_Pergunta__c;
                cup.TW1_Operador__c = IdOperador;
                cup.TW1_Shopping_Lookup__c = shoppingCorrente.Id;
                cup.TW1_Comum_Chekbox__c = cuponcorrente.TW1_Comum_Chekbox__c;
                cup.TW1_Bonus_Chekbox__c = cuponcorrente.TW1_Bonus_Chekbox__c;
                cup.TW1_Formas_de_Pagamento__c = cuponcorrente.TW1_Formas_de_Pagamento__c;
                cup.TW1_Parametro_Promocao__c = Promocao.Id;
                Listcupinsert.remove(0);
                Listcup.add(cup);             
                
            }
            
        }
        
        insert Listcup;
        
        
        return Listcup;
        
    }
    
    global class HistoricoCupom 
    {
        public decimal Saldo;
        public decimal SaldoExtra;
        public Integer NTrocados;
        public Integer NDireito;
        public Integer FormaPagamento;
    }
    
    global class requestWrapper 
    {
        public List<Cupom> cupom;
    }
    
    global class Cupom 
    {
        public String Numero_Cupom;
        public String TW1_DataCupom;
        public String TW1_Nome_do_Cliente;
        public String TW1_Bairro; 
        public String TW1_Celular;
        public String TW1_CEP; 
        public String TW1_Cidade; 
        public String TW1_Complemento;
        public String TW1_CPF;
        public String TW1_Data_de_Nascimento; 
        public String TW1_Email;
        public String Numero; 
        public String TW1_RG; 
        public String TW1_Rua; 
        public String Sexo;
        public String TW1_UF; 
        public String TW1_Certificado_Autenticao_Promocao; 
        public String TW1_Pergunta;
        public String TW1_Operador; 
        public String Nome_Parametro_Promocao;
        Public String Nome_Shopping; 
        Public String Nome_da_Loja;
        Public String Nome_Lojista;
    }
}