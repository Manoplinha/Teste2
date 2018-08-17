/*
Data de criação: 14/06/2018   
Criado por: Wellington N. Rodrigues 
Descrição: Handler para atualizar 3000 registros no Salesforce
*/
global with sharing class Tw1_Ancar_RoboFormaPagamento_Handler_cls {
    
    @future
    public static void sendWithFuture(){
        executeJob();
    } 
    
    @testVisible
    private static void executeJob(){
        recordtype vaRecordtype = [ SELECT Id, Name FROM recordtype WHERE Name ='Promoção' LIMIT 1 ];
        list<Participante__c> ListParticipantes = [ SELECT Id, Name,TW1_Cliente__c,TW1_Shopping__c,TW1_Promocao__c FROM Participante__c where Atualizar__c=true and recordtypeId =: vaRecordtype.id LIMIT 15 ];
        
        for(Participante__c ListParticipante : ListParticipantes){
            
            TW1_Parametros_Promocao__c Promocao = [Select Id,Name,TW1_Data_Inicio__c,TW1_Data_Fim__c,TW1_Valor_Min_NTFS__c,TW1_Max_Brinde_Clientes__c,Max_Cupom__c,Max_Bonus_Cliente__c,TW1_Acumula_Saldo__c,TW1_Troca_por__c,TW1_Condicoes_especiais_cart_credito__c,TW1_Contabiliza_Bonus__c,Max_Brindes_por_Troca__c,TW1_Cert_de_Aut__c,TW1_Pergunta__c,TW1_Shopping__c From TW1_Parametros_Promocao__c Where id=:ListParticipante.TW1_Promocao__c ];
            TW1_Shopping__c shoppingCorrente = [Select Id,Name From TW1_Shopping__c Where Id=:Promocao.TW1_Shopping__c Limit 1];
            List<TW1_Condicoes_Especiais__c> CondicoesEspeciais = [Select Id,TW1_Prioridade_da_condicao__c,TW1_Bonus_Mult_Brinde__c,TW1_Forma_de_Pagamento__c,TW1_Bonus_Mult_Cupom__c,TW1_Cartao__c,TW1_Promocao__c From TW1_Condicoes_Especiais__c where TW1_Promocao__c=:Promocao.Id];
            List<TW1_Cupom__c> Cupons = [Select Id,Name,TW1_Formas_de_Pagamento__c,Participante__c,TW1_Comum_Chekbox__c,TW1_Bonus_Chekbox__c From TW1_Cupom__c Where TW1_Nome_do_Cliente__c=:ListParticipante.TW1_Cliente__c And TW1_Parametro_Promocao__c=:Promocao.Id];	
            List<NTFS__c> notasFiscais = [select Id,Forma_de_Pagamento_Picklist__c,TW1_Participante__c,TW1_Valor_RS__c From NTFS__c Where TW1_Cliente__c=:ListParticipante.TW1_Cliente__c And TW1_Shopping__c=:ListParticipante.TW1_Shopping__c And TW1_Promocao__c=:ListParticipante.TW1_Promocao__c];    
            List<TW1_Brindes_Entregues__c> brindesEntregues = [Select Id,TW1_Cliente__c,Quantidade__c,TW1_Participante__c,TW1_Brinde__c,Data_Entrega__c,Tipo__c,Valor__c,TW1_Formas_de_Pagamento__c,TW1_Comum_Chekbox__c,TW1_Bonus_Chekbox__c from TW1_Brindes_Entregues__c Where Parametros_da_Promocao__c=:ListParticipante.TW1_Promocao__c And TW1_Cliente__c=:ListParticipante.TW1_Cliente__c];
            try{
                AtualizaBrinde(Promocao,CondicoesEspeciais,brindesEntregues,notasFiscais,ListParticipante.Id);
                AtualizaCupom(Promocao,CondicoesEspeciais,Cupons,notasFiscais,ListParticipante.Id);
                ListParticipante.Atualizar__c = false;     
            }catch(Exception ex){ 
                System.debug(ex.getCause() + ' - Message: ' + ex.getMessage() + ' - linha:  ' + ex.getLineNumber());
            }
        }
        
        if(ListParticipantes.size() > 0){
            update ListParticipantes;
            if(!Test.isRunningTest())
                scheaduleJobAgain();
        }
        
    }
    
    public static void AtualizaBrinde(TW1_Parametros_Promocao__c Promocao,List<TW1_Condicoes_Especiais__c> CondicoesEspeciais,List<TW1_Brindes_Entregues__c> brindesEntregues,List<NTFS__c> notasFiscais,String IdParticipante){
        
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
                        System.debug('NOta');
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
                    System.debug('entrou');
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
                            System.debug('entrou');
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
            System.debug('entrou');
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
                        
                        brinde.TW1_Participante__c = IdParticipante;
                        brinde.TW1_Brinde__c = brindesEntregues.get(j).TW1_Brinde__c;
                        brinde.Quantidade__c = 1.0;
                        brinde.Data_Entrega__c = brindesEntregues.get(j).Data_Entrega__c;
                        brinde.Tipo__c = brindesEntregues.get(j).Tipo__c;
                        brinde.Valor__c = brindesEntregues.get(j).Valor__c;
                        brinde.Parametros_da_Promocao__c = Promocao.Id;
                        brinde.TW1_Cliente__c = brindesEntregues.get(j).TW1_Cliente__c;
                        brinde.TW1_Shopping_Lookup__c = Promocao.TW1_Shopping__c;
                        
                        if(Listcupinsert.size() > 0){
                            brinde.TW1_Formas_de_Pagamento__c = Listcupinsert.get(0).TW1_Formas_de_Pagamento__c;
                            brinde.TW1_Comum_Chekbox__c = Listcupinsert.get(0).TW1_Comum_Chekbox__c;
                            brinde.TW1_Bonus_Chekbox__c = Listcupinsert.get(0).TW1_Bonus_Chekbox__c;
                            System.debug('antes '+brinde);
                            Listcupinsert.remove(0);
                        }
                        else
                        {
                            brinde.TW1_Formas_de_Pagamento__c = brindesEntregues.get(0).TW1_Formas_de_Pagamento__c;
                            brinde.TW1_Comum_Chekbox__c = brindesEntregues.get(0).TW1_Comum_Chekbox__c;
                            brinde.TW1_Bonus_Chekbox__c = brindesEntregues.get(0).TW1_Bonus_Chekbox__c;
                            
                        }
                        
                        
                        Listcup.add(brinde);
                        System.debug(brinde);
                    }
                }
                else{
                    
                    if(Listcupinsert.size() <= 0){
                        
                        brindesEntregues.get(j).TW1_Formas_de_Pagamento__c = brindesEntregues.get(0).TW1_Formas_de_Pagamento__c;
                        brindesEntregues.get(j).TW1_Comum_Chekbox__c = brindesEntregues.get(0).TW1_Comum_Chekbox__c;
                        brindesEntregues.get(j).TW1_Bonus_Chekbox__c = brindesEntregues.get(0).TW1_Bonus_Chekbox__c;
                        brindesEntregues.get(j).TW1_Participante__c = notasFiscais[0].TW1_Participante__c;         
                    }else{
                        
                        brindesEntregues.get(j).TW1_Formas_de_Pagamento__c = Listcupinsert.get(0).TW1_Formas_de_Pagamento__c;
                        brindesEntregues.get(j).TW1_Comum_Chekbox__c = Listcupinsert.get(0).TW1_Comum_Chekbox__c;
                        brindesEntregues.get(j).TW1_Bonus_Chekbox__c = Listcupinsert.get(0).TW1_Bonus_Chekbox__c;
                        brindesEntregues.get(j).TW1_Participante__c = notasFiscais[0].TW1_Participante__c;
                        Listcupinsert.remove(0);
                        
                    }
                    
                    
                }
            }
            if(Listcup.size() > 0)
                insert Listcup;
            if(brindesEntregues.size() > 0)
                update brindesEntregues;
            if(ListBrindeExcluir.size() > 0)
                delete ListBrindeExcluir;
            //////////////////////////////////////////////////////////////////////
            
        }
    }
    
    
    
    public static void AtualizaCupom(TW1_Parametros_Promocao__c Promocao,List<TW1_Condicoes_Especiais__c> CondicoesEspeciais,List<TW1_Cupom__c> Cupons,List<NTFS__c> notasFiscais,string IdParticipante){
        
        HistoricoCupom historicoCupom = new HistoricoCupom();
        
        Integer Quantidade = 0;
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
        
        
        Integer NumeroDireitoTotal = Quantidadebonus + NumeroDireitoNormal;
        
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
            
            
        }
        
        //List<TW1_Cupom__c> listcopia = Cupons.clone();
        List<TW1_Cupom__c> Listcup = new List<TW1_Cupom__c>();
        
        if(Cupons.size() > 0)
        {
            for(Integer i = 0; i < Cupons.size(); i++)
            {
                
                if(Listcupinsert.size() <= 0){
                    
                    Cupons.get(i).TW1_Formas_de_Pagamento__c = Cupons.get(0).TW1_Formas_de_Pagamento__c;
                    Cupons.get(i).TW1_Comum_Chekbox__c = Cupons.get(0).TW1_Comum_Chekbox__c;
                    Cupons.get(i).TW1_Bonus_Chekbox__c = Cupons.get(0).TW1_Bonus_Chekbox__c;
                    Cupons.get(i).Participante__c = IdParticipante;
                    
                }else{
                    Cupons.get(i).TW1_Formas_de_Pagamento__c = Listcupinsert.get(0).TW1_Formas_de_Pagamento__c;
                    Cupons.get(i).TW1_Comum_Chekbox__c = Listcupinsert.get(0).TW1_Comum_Chekbox__c;
                    Cupons.get(i).TW1_Bonus_Chekbox__c = Listcupinsert.get(0).TW1_Bonus_Chekbox__c;
                    Cupons.get(i).Participante__c = IdParticipante;
                    Listcupinsert.remove(0);
                }
                
                
            }
            
            update Cupons;
            
        }     
    }
    
    global class HistoricoCupom 
    {
        public decimal Saldo;
        public decimal SaldoExtra;
        public Integer NTrocados;
        public Integer NDireito;
        public Integer FormaPagamento;
    }
    
    private static void scheaduleJobAgain(){
        //Produção
        Anc_ScheaduleUtils_cls.scheadule('Tw1_Ancar_Robo_forma_pagamento_sch', DateTime.now().addMinutes(5));
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