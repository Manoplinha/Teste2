public class TR_Ancar_Promo_PromoShop_Mock {
	
    public static TW1_Shopping__c criaShopping(){
        TW1_Shopping__c shopping = new TW1_Shopping__c();
        shopping.TW1_SGL_Empreendimento__c = 'BPS';
        shopping.Name = 'Barra Shopping';
        Insert shopping;
        return shopping;
    }
    
    public static TW1_Parametros_Promocao__c criaPromocao(id paIdShopping){
        TW1_Parametros_Promocao__c promocao = new TW1_Parametros_Promocao__c();
        promocao.Name = 'Promo Teste 1';
        promocao.TW1_Troca_por__c = 'Brinde';
        promocao.TW1_Acumula_Saldo__c = true;
        promocao.TW1_Contabiliza_Bonus__c = true;
        promocao.TW1_Formas_de_Pagamento__c = 'Dinheiro';
        promocao.TW1_Concurso_Cultural__c = 'Sim';
        promocao.TW1_Shopping__c = paIdShopping;
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
        return promocao;
    }
}