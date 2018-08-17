({
    afterScriptsLoaded: function(component, event, helper) {
		var $ = jQuery = jQuery.noConflict().extend(true, $);

        var action = component.get("c.getUser");
        action.setCallback(this, function(a) {
            var response = a.getReturnValue();
            if (response == null || response == "" || response == "[]" || response == "{}"){
                return ;
            }
            component.set("v.usersJson", response);
            helper.setUsers(component , response);
        });
        $A.enqueueAction(action); 

        var actionUser = component.get("c.getUserId");
        actionUser.setCallback(this, function(a) {
            var response = a.getReturnValue();
            if (response == null || response == "" || response == "[]" || response == "{}"){
              return ;
            }
            component.set("v.userid", response);
        });
        $A.enqueueAction(actionUser); 
    },
    own: function(component, event, helper) {
        jQuery("#TC_searchText",":visible").val("");
        var selectEvent = $A.get("e.mvc:SelectUserEvent");
        //var selectEvent = component.getEvent("SelectUserEvent");
        var actionGetUserName = component.get("c.getUserName");
        actionGetUserName.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                selectEvent.setParams({ "searchKey": { label: response.getReturnValue(), id: component.get("v.userid"), value: response.getReturnValue() } });
            }
            selectEvent.fire();
        });
        $A.enqueueAction(actionGetUserName);
    }
})