/******************************************************************************************************
Author  : Wellington N Rodrigues
Date    : 28/06/2018
Purpose : Api Rest para buscar promoções de um Shopping - Melhoria
*******************************************************************************************************/
@RestResource(urlMapping='/PromoShop/*')
global with sharing class TR_Ancar_Promo_PromoShop_Serv {
	
    @HttpGet
    global static list<TR_Ancar_Promo_PromoShop_Serv.PromoShopDto> getPromoShop(){
        RestRequest req = RestContext.request;
        String idShooping = req.params.get('Idshopping');
        Date dataAtual = DateTime.now().date();
        System.debug('00 - Entra em listaPromoShop');
        return new TR_Ancar_Promo_PromoShop_App().listaPromoShop(idShooping,dataAtual);
    }
        
    global class PromoShopDto{
        public String id;
        public String trocaPor;
        public String formaDePagamento;
        public String concursoCultural;
        public Boolean contabilizaBonus;
        public Boolean acumulaSaldo;
        public String Name;
        public Boolean campoVendedor;
        public Boolean ImprimirNomeDoLojista;
    }    
}