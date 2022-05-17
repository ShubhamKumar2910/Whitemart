@IsTest
public class GetObjectNamebyId_Test {
    static testMethod void CheckObjectName() {
        Lead l=new Lead();
        l.lastname='Prabhu';
        l.Phone='9933999333';
        Insert l;
        
        GetObjectNamebyId.Requests req= new GetObjectNamebyId.Requests();
        req.objRecordId = l.Id;
        
        List<GetObjectNamebyId.Requests> reqList= new List<GetObjectNamebyId.Requests>();
        reqList.add(req);
        
        GetObjectNamebyId.GetObjectNamedetailsbyId(reqList);
        
    }

}