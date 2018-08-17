public with sharing class TR_Ancar_Promo_Rep {
    
    public List<TW1_Parametros_Promocao__c> ListaPromoShop(String paShopping, Date paDataAtual){
        try{
            List<TW1_Parametros_Promocao__c> promocoes = [
                Select 
                Id,
                Name,
                TW1_Troca_por__c,
                TW1_Formas_de_Pagamento__c,
                TW1_Concurso_Cultural__c,
                TW1_Contabiliza_Bonus__c,
                TW1_Acumula_Saldo__c,
                TW1_CampoVendedor__c,
                TW1_Imprimir_nome_do_lojista__c
                from 
                TW1_Parametros_Promocao__c 
                where 
                TW1_Shopping__c=:paShopping And 
                TW1_Data_Fim__c >=:paDataAtual 
                Order By CreatedDate Desc LIMIT 50
            ]; 
            if( promocoes.size() > 0 ){
                System.debug('02 - Retorna o resultado da consulta:'+promocoes);
                return promocoes; 
            }else{
                System.debug('02 - Não há resultado');
                return promocoes;
            }
        }catch(Exception ex){
            System.debug('Erro: '+ex);
            return null;
        }
    }
}