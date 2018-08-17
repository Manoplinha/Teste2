({
    setUsers: function(component , uData){
        try{
        jQuery("#TC_searchText",":visible").autocomplete({  
          minLength: 1,
          delay: 500,
          source: JSON.parse( uData ),
          select: function(event, ui) {  
            event.preventDefault();
            var ctx = component.getElement();
            jQuery("#TC_searchText",":visible").blur();
            var selectionEvent = $A.get("e.mvc:SelectUserEvent");
            selectionEvent.setParams({
              "searchKey": ui.item 
            });
            selectionEvent.fire();
            jQuery("#TC_searchText",":visible").val("");
          }
      });

        }catch (e) {console.log(" Please reload try this page.")}

    }

})