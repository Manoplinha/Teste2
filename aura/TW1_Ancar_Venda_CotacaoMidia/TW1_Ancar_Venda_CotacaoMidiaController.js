({
    doInit : function(component, event, helper) {
        console.log("Iniciando componente de Cotação de mídia");
        component.set('v.RequestPesquisarPropriedadeDto', {});
        component.set('v.PropriedadesSeleciondas', []);
        component.set('v.CotacaoRequestDto', {});
        //this.CarregaListaSubTipo(component, event, helper);
        console.log('Inicianco chamada de busca de subtipo de propriedade');
        
        if(component.get('v.TipoChamada') == 'Clone')
        {
            component.set('v.PrimeiraEtapaAtiva', false);
            component.set('v.SegundaEtapaAtiva', true);
            component.set('v.BtnHideVoltar', false);
            
            helper.getCotacaoClone(component);
        }
        else
        {	
            component.set('v.BtnHideVoltar', true);
            helper.getSubTipoDePropriedade(component);
            helper.getDataAtual(component);
        }
    },
    myAction : function(component, event, helper) {
        
    },
    MontarCotacao:function(component, event, helper)    {
        
        var CotacaoRequestDto = component.get('v.CotacaoRequestDto');
        console.log('Valor no DTO');
        console.log(CotacaoRequestDto);
        
        component.set("v.txtAtividade", CotacaoRequestDto.Atividade);
        component.set("v.txtObservacao", CotacaoRequestDto.Observacao);
        
        console.log('Resgatando lista anterior');
        var listaCorrente = component.get('v.PropriedadesSeleciondas');
        console.log('listaCorrente');
        
        CotacaoRequestDto.ListaDePropriedade = [];
        
        for(var ponteiroListaCorrente = 0; ponteiroListaCorrente < listaCorrente.length; ponteiroListaCorrente++)
        {
            var propriedade = {};
            propriedade.IdPropriedade = listaCorrente[ponteiroListaCorrente].IdPropriedade;
            propriedade.Nome = listaCorrente[ponteiroListaCorrente].Name;
            propriedade.ValorAluguel = listaCorrente[ponteiroListaCorrente].ValorAluguel;
            propriedade.DataInicio = listaCorrente[ponteiroListaCorrente].DataInicio;
            propriedade.DataFim = listaCorrente[ponteiroListaCorrente].DataFim;
            propriedade.Localizacao = listaCorrente[ponteiroListaCorrente].Localizacao;
            propriedade.AreaUtilizada = listaCorrente[ponteiroListaCorrente].AreaUtilizada;
            propriedade.Largura = listaCorrente[ponteiroListaCorrente].Largura;
            propriedade.Altura = listaCorrente[ponteiroListaCorrente].Altura;
			
            CotacaoRequestDto.ListaDePropriedade.push(propriedade);
        }
        
        component.set('v.CotacaoRequestDto', CotacaoRequestDto );
        
        console.log('Valor após resumo no DTO');
        console.log(CotacaoRequestDto);
        
        component.set('v.PrimeiraEtapaAtiva', false);
        component.set('v.SegundaEtapaAtiva', true);
    },
    AdcionarPropriedadeLista :function(component, event, helper)
    {
        console.log('Adcionando propriedade a lista')
        var ctarget = event.currentTarget;
        console.log(ctarget);

        var listaPesquisaResultado = component.get('v.ResultadoFiltroPropriedades');
        var listaCorrente = component.get('v.PropriedadesSeleciondas');
        var requestPesquisa = component.get('v.RequestPesquisarPropriedadeDto');
        
        console.log(listaPesquisaResultado);
		
        for(var i = 0;i < listaCorrente.length; i++)
        {
            if(listaCorrente[i].IdPropriedade == ctarget.id && listaCorrente[i].DataInicio < requestPesquisa.DataInicio && listaCorrente[i].DataFim > requestPesquisa.DataFim )
            {
                console.log('entrou no primeiro');
                return; 
            }
                
            if(listaCorrente[i].IdPropriedade == ctarget.id && listaCorrente[i].DataInicio == requestPesquisa.DataInicio && listaCorrente[i].DataFim == requestPesquisa.DataFim ){
            	console.log('entrou no segundo');
                return;
            }
        }
        
        for(var i = 0;i < listaPesquisaResultado.length; i++)
        {
            console.log('Id corrente: ' + listaPesquisaResultado[i].Id);
  
            if(listaPesquisaResultado[i].Id == ctarget.id)
            {
                document.getElementById(ctarget.id).disabled = true;             
                console.log('Encontrou propriedade na lista');
                var propriedade = {};
                propriedade.IdPropriedade = listaPesquisaResultado[i].Id;
                propriedade.Name = listaPesquisaResultado[i].Name;
                propriedade.DataInicio = requestPesquisa.DataInicio;
                propriedade.DataFim = requestPesquisa.DataFim;
                propriedade.Localizacao = listaPesquisaResultado[i].Localizacao;
                propriedade.ValorAluguel = listaPesquisaResultado[i].Valor_de_tabela;
                propriedade.AreaUtilizada = listaPesquisaResultado[i].AreaUtilizada;
                propriedade.Largura = listaPesquisaResultado[i].Largura;
                propriedade.Altura = listaPesquisaResultado[i].Altura;
                console.log('Propriedade montada');
                console.log(propriedade);
                listaCorrente.push(propriedade);
            }
        }
        
        console.log('Definindo nova lista atual: ' + listaCorrente);
        component.set('v.PropriedadesSeleciondas', listaCorrente);
        console.log('Lista definida');
        
        /// Caso o valor seja maior que zero, então tem item na lista e deve ser mostrada
        if(listaCorrente.length > 0)
            component.set('v.ExistePropriedadeSelecionada', true);
        else
            component.set('v.ExistePropriedadeSelecionada', false);        
    },
    RemoverPropriedadeLista:function(component, event, helper)
    {
        console.log('Removendo propriedade a lista');
        var ctarget = event.currentTarget;
        console.log(ctarget);
        
        var listaCorrente = component.get('v.PropriedadesSeleciondas');

        console.log(listaCorrente);
        
        for(var i = 0;i < listaCorrente.length; i++)
        {
            console.log('Id corrente: ' + listaCorrente[i].IdPropriedade + listaCorrente[i].DataInicio +  listaCorrente[i].DataFim );
            var idComposto = listaCorrente[i].IdPropriedade + listaCorrente[i].DataInicio +  listaCorrente[i].DataFim;
            console.log('Criando ID Composto: ' + idComposto);
            console.log('ctarget.id: ' + ctarget.id);
            

            if(idComposto == ctarget.id)
            {
                console.log('Encontrou propriedade na lista');
                
                if(document.getElementById(listaCorrente[i].IdPropriedade)){
                    if(document.getElementById(listaCorrente[i].IdPropriedade).disabled == true)
                    {
                        document.getElementById(listaCorrente[i].IdPropriedade).disabled = false;
                    }
                }
                
                listaCorrente.splice(i,1);
            }

        }
        
        console.log('Definindo nova lista atual: ' + listaCorrente);
        component.set('v.PropriedadesSeleciondas', listaCorrente);
        console.log('Lista definida');
        
        /// Caso o valor seja maior que zero, então tem item na lista e deve ser mostrada
        if(listaCorrente.length > 0)
            component.set('v.ExistePropriedadeSelecionada', true);
        else
            component.set('v.ExistePropriedadeSelecionada', false);      
    },
    VoltarPrimeiraEtapa:function(component, event, helper){
        
        var CotacaoRequestDto = component.get('v.CotacaoRequestDto');
        
        CotacaoRequestDto.Atividade = component.find("txtAtividade").get("v.value");
        CotacaoRequestDto.Observacao = component.find("txtObservacao").get("v.value");
        
        component.set('v.CotacaoRequestDto', CotacaoRequestDto);

        component.set('v.PrimeiraEtapaAtiva', true);
        component.set('v.SegundaEtapaAtiva', false);
        
        var listaCorrente = component.get('v.PropriedadesSeleciondas');
        
        for(var i = 0;i < listaCorrente.length; i++)
        {
            if(document.getElementById(listaCorrente[i].IdPropriedade)){
                var idComposto = listaCorrente[i].IdPropriedade + listaCorrente[i].DataInicio +  listaCorrente[i].DataFim;
                document.getElementById(listaCorrente[i].IdPropriedade).disabled = true;
            }
        }
 
    },
    PesquisarPropriedade:function(component, event, helper){
        
        /// Montando lista de parâmetros
        var opportunityId = component.get("v.recordId");
        var request = component.get('v.RequestPesquisarPropriedadeDto');
        var dataAtual = component.get('v.DataAtual');
        
        if(request.DataInicio == undefined || request.DataFim == undefined)
        {
            alert('A data de inicio e a data fim da vigência são obrigatórias');
            return;
        }
        
        if(request.DataInicio <  dataAtual || request.DataFim <  dataAtual)
        {
            alert('A data de inicio ou a data fim está menor que a data atual');
            return;
        }
        
        if(request.DataInicio > request.DataFim )
        {
            alert('A data de inicio deve ser maior que data fim');
            return;
        }
        
        component.set('v.ExisteResultadoParaFiltro', false);
        
        console.log('Realizando consutla de propriedade');
        
        component.set('v.NaoPermitirPesquisar', true);
        component.set('v.LabelBtnPesquisar', 'Pesquisando....');
        
        helper.PesquisaPropriedade(component);
    },
    MudancaNoFiltro:function(component, event, helper)
    {
        component.set('v.ExisteResultadoParaFiltro', false);
        component.set('v.ResultadoFiltroPropriedades', []);
    },
    SalvarCotacao:function(component, event, helper)
    {
        /// TODO: Realizar validações de valores
        /// Liberando botão para consulta
        var request = component.get('v.CotacaoRequestDto');
        var dataAtual =  component.get('v.DataAtual');
        
        console.log('Valor de data de pagamento: ' + request.DataPagamento);
        console.log('Valor de data de atual: ' + dataAtual);
        
        /*
        if(request.DataPagamento == undefined || request.DataPagamento <= dataAtual)
        {
            //helper.toastThis('Data de pagamento não pode ser menor que a data atual.', 'Erro...');
            //component.set('v.OcorreuErroEmSalvar',true);
            //component.set('v.MsgErroSalvarCotacao', 'Data de pagamento não pode ser menor que a data atual.');
            alert('Data de pagamento não pode ser menor que a data atual.');
            return;
        }*/
         if(request.ValorDesconto == '')
             request.ValorDesconto = undefined;
             
        for(var iPropriedade = 0; iPropriedade < request.ListaDePropriedade.length; iPropriedade++)
        {
            var propriedade = request.ListaDePropriedade[iPropriedade];
            if(propriedade.DataInicio == undefined || propriedade.DataFim == undefined)
            {
                //component.set('v.OcorreuErroEmSalvar',true);
                //component.set('v.MsgErroSalvarCotacao', 'A data início ou a data de fim da propriedade '+ propriedade.Nome +' devem ser definidas.');
                alert('A data início ou a data de fim da propriedade '+ propriedade.Nome +' devem ser definidas.');
                return;
            }
            
            if(propriedade.DataInicio > propriedade.DataFim)
            {
                //component.set('v.OcorreuErroEmSalvar',true);
                //component.set('v.MsgErroSalvarCotacao', 'A data início da propriedade '+ propriedade.Nome +' não pode ser maior que a data de fim.');
                alert('A data início da propriedade '+ propriedade.Nome +' não pode ser maior que a data de fim.');
                return;
            }

            if(propriedade.ValorAluguel < 1)
            {
                alert('O valor de aluguel da propriedade '+ propriedade.Nome +' deve ser preenchido.');
                return;
            }
            
            if(propriedade.AreaUtilizada == '')
                propriedade.AreaUtilizada = undefined;
            	//alert(propriedade.AreaUtilizada);
            
            if(propriedade.Largura == '' )
                propriedade.Largura = undefined;
            
            if(propriedade.Altura == '' )
                propriedade.Altura = undefined;

            if(propriedade.AreaUtilizada == undefined || propriedade.AreaUtilizada == '0'){
                if(propriedade.Largura == undefined || propriedade.Altura == undefined){
                    alert('Campos de largura e altura devem ser preenchidos.');
                    return;
                }
            }else{
                if((propriedade.Largura != undefined && propriedade.Largura !='0') || (propriedade.Altura != undefined && propriedade.Altura !='0' )){
                    alert('Campo de Área utilizada não pode estar preenchido quando for informado a largura e altura.');
                    return;
                }
            }

        }
        
        component.set('v.MsgErroSalvarCotacao','');
        component.set('v.OcorreuErroEmSalvar',false);
        component.set('v.NaoPermitirAcoes', true);
        component.set('v.LabelBtnSalvar', 'Salvando....');
        
        helper.SalvarCotacao(component);
    },
    acionaBotaoDevoltar : function(component, event, helper){
        
        var device = $A.get("$Browser.formFactor");
        var vaRecordId = component.get('v.recordId');
        var urlAtual   = component.get('v.urlAtual');
        
        if(device=='PHONE' || device=='TABLET'){
            if(urlAtual != '' || urlAtual != null){ 
                //sforce.one.back(true);
                //sforce.one.navigateToSObject(vaRecordId);
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": vaRecordId,
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
        }else{
            if(urlAtual.match(/portaldevendas/)){
                window.location.href="/portaldevendas/"+vaRecordId;
            }else{
                window.location.href="/"+vaRecordId;
            }
        }
        
    },
    AbrirRelatorioOcupacoes: function(component, event, helper){
        var ctarget = event.currentTarget;
        console.log('Ctarget');
        console.log(ctarget);
        var listaPesquisaResultado = component.get('v.ResultadoFiltroPropriedades');
        var requestPesquisa = component.get('v.RequestPesquisarPropriedadeDto');
        for(var i = 0;i < listaPesquisaResultado.length; i++)
        {
            console.log('Id corrente: ' + listaPesquisaResultado[i].Id);
            if(listaPesquisaResultado[i].Id == ctarget.name)
            {
                console.log('Encontrou propriedade na lista');
                var propriedade = {};
                propriedade.IdPropriedade = listaPesquisaResultado[i].Id;
                propriedade.Name = listaPesquisaResultado[i].Name;
                propriedade.DataInicio = requestPesquisa.DataInicio;
                propriedade.DataFim = requestPesquisa.DataFim;
                propriedade.Localizacao = listaPesquisaResultado[i].Localizacao;
                propriedade.ValorAluguel = listaPesquisaResultado[i].Valor_de_tabela;
                propriedade.AreaUtilizada = listaPesquisaResultado[i].AreaUtilizada;
                propriedade.Largura = listaPesquisaResultado[i].Largura;
                propriedade.Altura = listaPesquisaResultado[i].Altura;
                console.log('Propriedade montada');
                console.log(propriedade);
                component.set('v.PropriedadeRelatorio', propriedade);
            }
        }
        
        component.set('v.RelatorioDisponibilidade', true);
        component.set('v.PrimeiraEtapaAtiva', false);
        component.set('v.SegundaEtapaAtiva', false);
        
        console.log('Iniciando relatório');
        var childCmp = component.find('child');
        console.log(childCmp);
        // call the aura:method in the child component
        console.log('Chamando método no relatório');
        childCmp.RefinarRelatorioOcupacao(propriedade);
        console.log('Método executado');
        console.log('Liberando tela');
        
    },
    VoltarPrimeiraEtapaPosRelatorio:function(component, event, helper){
        component.set('v.RelatorioDisponibilidade', false);
        component.set('v.PrimeiraEtapaAtiva', true);
        component.set('v.SegundaEtapaAtiva', false);
    }
})