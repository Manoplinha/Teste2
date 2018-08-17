/*
	Data de criação: 14/06/2018   
	Criado por: Wellington N. Rodrigues 
	Descrição: Schedulable / Robo para atualizar 3000 registros no Salesforce
*/
global without sharing class Tw1_Ancar_Robo_forma_pagamento_sch implements Schedulable	{

    global void execute(SchedulableContext paSchedulableContext){
        Anc_ScheaduleUtils_cls.abortScheadule(paSchedulableContext);
        Tw1_Ancar_RoboFormaPagamento_Handler_cls.sendWithFuture();
    }
    
}