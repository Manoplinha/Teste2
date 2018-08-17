/******************************************************************************************************
Author  : Wellington N Rodrigues
Date    : 28/06/2018
Purpose : Classe de Test de TR_Ancar_Promo_PromoShop para buscar promoções de um Shopping - Melhoria
*******************************************************************************************************/
@istest
public with sharing class TR_Ancar_Promo_PromoShop_Tst {

    static testMethod void getPromocoesPorShoppingTst() {

        TW1_Shopping__c paShopping = TR_Ancar_Promo_PromoShop_Mock.criaShopping();
        TW1_Parametros_Promocao__c paPromocao = TR_Ancar_Promo_PromoShop_Mock.criaPromocao(paShopping.id);
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PromoShop';
        
        request.addParameter('Idshopping', paShopping.Id);
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        System.debug(RestContext.request);
        
        TR_Ancar_Promo_PromoShop_Serv.getPromoShop();
        
    }
    
    static testMethod void getPromocoesPorShopping_ShoppingEmBranco_Tst() {

        TW1_Shopping__c paShopping = TR_Ancar_Promo_PromoShop_Mock.criaShopping();
        TW1_Parametros_Promocao__c paPromocao = TR_Ancar_Promo_PromoShop_Mock.criaPromocao(paShopping.id);
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PromoShop';
        
        request.addParameter('Idshopping', '');
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        System.debug(RestContext.request);
        
        TR_Ancar_Promo_PromoShop_Serv.getPromoShop();
        
    }
    
    static testMethod void getPromocoesPorShopping_ShoppingErrado_Tst() {

        TW1_Shopping__c paShopping = TR_Ancar_Promo_PromoShop_Mock.criaShopping();
        TW1_Parametros_Promocao__c paPromocao = TR_Ancar_Promo_PromoShop_Mock.criaPromocao(paShopping.id);
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/PromoShop';
        
        request.addParameter('Idshopping', 'a010R000000n9VT');
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        System.debug(RestContext.request);
        
        TR_Ancar_Promo_PromoShop_Serv.getPromoShop();
        
    }

}