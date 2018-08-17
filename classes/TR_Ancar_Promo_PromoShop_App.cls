public with sharing class TR_Ancar_Promo_PromoShop_App {
    
    TR_Ancar_Promo_Rep repositorio = new TR_Ancar_Promo_Rep();
    
    public list<TR_Ancar_Promo_PromoShop_Serv.PromoShopDto> listaPromoShop(String paShopping, Date paDataAtual){
        System.debug('Pega o id do Shopping:'+paShopping+' e a data atual '+paDataAtual);
        if(paShopping==''){
            return null;
        }else{
            list<TW1_Parametros_Promocao__c> retornoPromoShop = repositorio.ListaPromoShop(paShopping, paDataAtual);

            list<TR_Ancar_Promo_PromoShop_Serv.PromoShopDto> retorno = new list<TR_Ancar_Promo_PromoShop_Serv.PromoShopDto>();

            for( TW1_Parametros_Promocao__c promocao : retornoPromoShop ){
                
                TR_Ancar_Promo_PromoShop_Serv.PromoShopDto listaPromo = new TR_Ancar_Promo_PromoShop_Serv.PromoShopDto();
                
                listaPromo.id = promocao.id;
                listaPromo.trocaPor = promocao.TW1_Troca_por__c;
                listaPromo.formaDePagamento = promocao.TW1_Formas_de_Pagamento__c;
                listaPromo.concursoCultural = promocao.TW1_Concurso_Cultural__c;
                listaPromo.contabilizaBonus = promocao.TW1_Contabiliza_Bonus__c;
                listaPromo.acumulaSaldo = promocao.TW1_Acumula_Saldo__c;
                listaPromo.Name = promocao.Name;
                listaPromo.campoVendedor = promocao.TW1_CampoVendedor__c;
                listaPromo.ImprimirNomeDoLojista = promocao.TW1_Imprimir_nome_do_lojista__c;
                
                retorno.add(listaPromo);
            }

            System.debug('03 - preenche o DTO :'+retorno);
            
            return retorno;
        }
    }  

}