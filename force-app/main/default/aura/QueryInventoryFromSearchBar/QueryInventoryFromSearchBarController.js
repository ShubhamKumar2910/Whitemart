({
    
    searchKeyChange: function(component, event) {
        debugger;
        var searchKey = component.find("searchKey").get("v.value");
        component.set("v.SearchPrductName",searchKey);
        
        console.log('searchKey:::::'+searchKey);
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey": searchKey
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                
                component.set("v.Inventorylist", response.getReturnValue());
            var tempcompleteInventoryList = component.get("v.Inventorylist");
            
            var FranchieInventorytotalpagesize = (tempcompleteInventoryList[0].franchieInventories.length)/10;
            
            if(Number.isInteger(FranchieInventorytotalpagesize)){
                component.set("v.FranchieListRecordTotalPages",FranchieInventorytotalpagesize);
            }
            else{
               var conIntnumberFranchieInventorytotalpagesize = Math.ceil(FranchieInventorytotalpagesize);
                component.set("v.FranchieListRecordTotalPages",conIntnumberFranchieInventorytotalpagesize);
            }
            
            component.set("v.CompleteFranchieInventoryList", tempcompleteInventoryList[0].franchieInventories);
            
            var tempFranchieinventoryList= [];
            var FranchieInventoryRecordSize = tempcompleteInventoryList[0].franchieInventories.length;
            
            if(FranchieInventoryRecordSize >10){
                for(var i = 0; i<10; i++){
                    tempFranchieinventoryList.push(tempcompleteInventoryList[0].franchieInventories[i]);
                }
            }
                else if(FranchieInventoryRecordSize > 0 && FranchieInventoryRecordSize <10){
                    for(var i = 0; i<FranchieInventoryRecordSize; i++){
                    tempFranchieinventoryList.push(tempcompleteInventoryList[0].franchieInventories[i]);
                }
                }
            
            component.set("v.FranchieListRecordFirstIndex", tempFranchieinventoryList.length-10);
            component.set("v.FranchieListRecordLastIndex", tempFranchieinventoryList.length);
            component.set("v.FranchieListTobeDisplayed", tempFranchieinventoryList);
            
            
            // ############################ warehouse details ###############################
            
            component.set("v.CompleteWarehouseInventoryList", tempcompleteInventoryList[0].warehouseInventories);
            
            var WarehouseInventorytotalpagesize = (tempcompleteInventoryList[0].warehouseInventories.length)/10;
            if(Number.isInteger(WarehouseInventorytotalpagesize)){
                component.set("v.WarehouseListRecordTotalPages",WarehouseInventorytotalpagesize);
            }
            else{
               var conIntnumberWarehouseInventorytotalpagesize = Math.ceil(WarehouseInventorytotalpagesize);
                component.set("v.WarehouseListRecordTotalPages",conIntnumberWarehouseInventorytotalpagesize);
            }
            
            var tempWarehouseinventoryList= [];
            var WarehouseListRecordsize = tempcompleteInventoryList[0].warehouseInventories.length;
            
            if(WarehouseListRecordsize > 0 && WarehouseListRecordsize<10){
                for(var i = 0; i<WarehouseListRecordsize; i++){
                    tempWarehouseinventoryList.push(tempcompleteInventoryList[0].warehouseInventories[i]);
                }
            }
                else if(WarehouseListRecordsize >10){
                    for(var i = 0; i<10; i++){
                    tempWarehouseinventoryList.push(tempcompleteInventoryList[0].warehouseInventories[i]);
                }
                }
            
            component.set("v.WarehouseListRecordFirstIndex", tempWarehouseinventoryList.length-10);
            component.set("v.WarehouseListRecordLastIndex", tempWarehouseinventoryList.length);
            component.set("v.WarehouseListTobeDisplayed", tempWarehouseinventoryList);
            
                
            }
            
        });
        $A.enqueueAction(action);
    } ,
    
    handleNextFranchieInventory: function(component, event, helper) {
        debugger;
        var tempagenumberforPagination = component.get("v.FranchieListRecordPageNumber");
        var tempCompleteFranchieInventoryList = component.get("v.CompleteFranchieInventoryList");
        var temFranchieRecordLastIndex = component.get("v.FranchieListRecordLastIndex");
        var temFranchieRecordFirstIndex = component.get("v.FranchieListRecordFirstIndex");
        var temFranchieInventoryListforPagination = [];
        if(temFranchieRecordLastIndex < tempCompleteFranchieInventoryList.length){
            if((tempCompleteFranchieInventoryList.length - temFranchieRecordLastIndex) > 10){
                for(var i = temFranchieRecordLastIndex; i<temFranchieRecordLastIndex+10; i++){
                    temFranchieInventoryListforPagination.push(tempCompleteFranchieInventoryList[i]);
                }
            }
            else if((tempCompleteFranchieInventoryList.length - temFranchieRecordLastIndex) < 10){
                for(var i = temFranchieRecordLastIndex; i<temFranchieRecordLastIndex+(tempCompleteFranchieInventoryList.length - temFranchieRecordLastIndex); i++){
                    temFranchieInventoryListforPagination.push(tempCompleteFranchieInventoryList[i]);
                }
            }
            component.set("v.FranchieListRecordFirstIndex", temFranchieRecordLastIndex);
            component.set("v.FranchieListRecordLastIndex", temFranchieRecordLastIndex+10);
            component.set("v.FranchieListTobeDisplayed", temFranchieInventoryListforPagination);
            
            tempagenumberforPagination++;
            component.set("v.FranchieListRecordPageNumber", tempagenumberforPagination);
        }
        else{
            
        }
        
        /*var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.searchKeyChange(component, pageNumber, pageSize);*/
    },
    
    handlePrevFranchieInventory: function(component, event, helper) {
        
        debugger;
        var tempagenumberforPagination = component.get("v.FranchieListRecordPageNumber");
        var tempCompleteFranchieInventoryList = component.get("v.CompleteFranchieInventoryList");
        
        var temFranchieRecordLastIndex = component.get("v.FranchieListRecordLastIndex");
        var temFranchieRecordFirstIndex = component.get("v.FranchieListRecordFirstIndex");
        
        var temFranchieInventoryListforPagination = [];
        for(var i = temFranchieRecordFirstIndex-10; i<temFranchieRecordFirstIndex; i++){
            temFranchieInventoryListforPagination.push(tempCompleteFranchieInventoryList[i]);
        }
        component.set("v.FranchieListRecordFirstIndex", temFranchieRecordFirstIndex-10);
        component.set("v.FranchieListRecordLastIndex", temFranchieRecordFirstIndex);
        component.set("v.FranchieListTobeDisplayed", temFranchieInventoryListforPagination);
        
        tempagenumberforPagination--;
        component.set("v.FranchieListRecordPageNumber", tempagenumberforPagination);
        
    },
    
    handleNextWarehouseInventory: function(component, event, helper) {
        debugger;
        var tempagenumberforPagination = component.get("v.WarehouseListRecordPageNumber");
        var tempCompleteWarehouseInventoryList = component.get("v.CompleteWarehouseInventoryList");
        var temWarehouseRecordLastIndex = component.get("v.WarehouseListRecordLastIndex");
        var temWarehouseRecordFirstIndex = component.get("v.WarehouseListRecordFirstIndex");
        var temWarehouseInventoryListforPagination = [];
        if(temWarehouseRecordLastIndex < tempCompleteWarehouseInventoryList.length){
            if((tempCompleteWarehouseInventoryList.length - temWarehouseRecordLastIndex) > 10){
                for(var i = temWarehouseRecordLastIndex; i<temWarehouseRecordLastIndex+10; i++){
                    temWarehouseInventoryListforPagination.push(tempCompleteWarehouseInventoryList[i]);
                }
            }
            else if((tempCompleteWarehouseInventoryList.length - temWarehouseRecordLastIndex) < 10){
                for(var i = temWarehouseRecordLastIndex; i<temWarehouseRecordLastIndex+(tempCompleteWarehouseInventoryList.length - temWarehouseRecordLastIndex); i++){
                    temWarehouseInventoryListforPagination.push(tempCompleteWarehouseInventoryList[i]);
                }
            }
            component.set("v.WarehouseListRecordFirstIndex", temWarehouseRecordLastIndex);
            component.set("v.WarehouseListRecordLastIndex", temWarehouseRecordLastIndex+10);
            component.set("v.WarehouseListTobeDisplayed", temFranchieInventoryListforPagination);
            
            tempagenumberforPagination++;
            component.set("v.WarehouseListRecordPageNumber", tempagenumberforPagination);
        }
        else{
            
        }
    },
    
    handlePrevWarehouseInventory: function(component, event, helper) {
        
        debugger;
        var tempagenumberforPagination = component.get("v.WarehouseListRecordPageNumber");
        var tempCompleteWarehouseInventoryList = component.get("v.CompleteWarehouseInventoryList");
        
        var temWarehouseRecordLastIndex = component.get("v.WarehouseListRecordLastIndex");
        var temRecordWarehouseFirstIndex = component.get("v.WarehouseListRecordFirstIndex");
        
        var temWarehouseInventoryListforPagination = [];
        for(var i = temRecordWarehouseFirstIndex-10; i<temRecordWarehouseFirstIndex; i++){
            temWarehouseInventoryListforPagination.push(tempCompleteFranchieInventoryList[i]);
        }
        component.set("v.WarehouseListRecordFirstIndex", temRecordWarehouseFirstIndex-10);
        component.set("v.WarehouseListRecordLastIndex", temRecordWarehouseFirstIndex);
        component.set("v.WarehouseListTobeDisplayed", temWarehouseInventoryListforPagination);
        
        tempagenumberforPagination--;
        component.set("v.WarehouseListRecordPageNumber", tempagenumberforPagination);
        
    },
    
    ShowPriceBook: function(component, event, helper) {
        debugger;
        var SelectedProductValue = event.getSource().get("v.title");
        //alert(SelectedProductValue);
        var action = component.get("c.QueryPriceBook");
        action.setParams({
            "ProductId": SelectedProductValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var serverResponse = response.getReturnValue();
                if(serverResponse != null){
                    component.set("v.priceBookEntryList", response.getReturnValue());
                    component.set("v.ShowPriceBookModal", true);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Warning',
                        message: 'There are No Price Book Mentioned With this Name.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'sticky'
                    });
        toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.ShowPriceBookModal", false);
   },
    
    RedirectToProductPage : function(component, event, helper){
        debugger;
        var SelectedWarehouseId = event.currentTarget.getAttribute("data-target");
        var tempUrl = 'https://whitemart--partial.lightning.force.com/lightning/r/Franchisee__c/';
        var tempUrl = tempUrl+SelectedWarehouseId+'/view/';
        //var SelectedProductid = event.getSource().get("v.title");
        //alert(SelectedWarehouseId);
        
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url":  tempUrl
        });
        eUrl.fire();
    }
})