public class QueryInventoryFromSearchBar {
    
    /*@AuraEnabled
    public static List <Inventory__c> getInventory() {
        return [SELECT Id, name, Available_Quantity__c, Franchisee__c, Warehouse__c FROM Inventory__c ORDER BY createdDate ASC];
    }*/

    
    @AuraEnabled
    public static inventorywrapper findByName(String searchKey) {
        inventorywrapper InventWrap = new inventorywrapper();
        try{
            
        String name = '%' + searchKey + '%';
        List<Inventory__c> inventoryList = new  List<Inventory__c>();
        inventoryList = [SELECT id, name, Available_Quantity__c, Product__r.Name, Product__r.Product_Id__c, Product__r.Warranty__c,  Franchisee__c,  Franchisee__r.Name, Franchisee__r.Location__c, Warehouse__c, Warehouse__r.Name, Warehouse__r.Location__c 
                         FROM Inventory__c 
                         WHERE Product__r.Name LIKE : name  OR Product__r.Name =:searchKey];
        system.debug('inventoryList :: ' + inventoryList);
        
        
        List<Inventory__c> franchieInventorylist = new List<Inventory__c>();
        List<Inventory__c> WarehouseInventorylist = new List<Inventory__c>();
        for(Inventory__c invs : inventoryList){
            
            if(invs.Franchisee__c != Null){
                franchieInventorylist.add(invs);
            }else if(invs.Warehouse__c != NUll){
                WarehouseInventorylist.add(invs);
            }
        }
        
        InventWrap.franchieInventories = franchieInventorylist;
        InventWrap.warehouseInventories = WarehouseInventorylist;
        
        }
        catch(Exception e) {
            system.debug('Line Number :: ' + e.getLineNumber() + 'Messege :: ' + e.getMessage());
        }
        
        return InventWrap;
    }
    
    @AuraEnabled
    public static List<PricebookEntry> QueryPriceBook(String ProductId){
        
        List<PricebookEntry> PBElist = [SELECT id, name, Pricebook2.Name, UnitPrice, IsActive FROM PricebookEntry WHERE Product2Id =: ProductId]; 
        return PBElist;
        
    }
    
    public class inventorywrapper{
        @AuraEnabled public List<Inventory__c> warehouseInventories{get; set;}
        @AuraEnabled public List<Inventory__c> franchieInventories{get; set;}
    }

}