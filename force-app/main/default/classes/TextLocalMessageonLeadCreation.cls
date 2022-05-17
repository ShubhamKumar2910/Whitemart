public class TextLocalMessageonLeadCreation {
    Public Static List<lead> LeadsTobeUpdated = new List<lead>();
    public static void LeadAssignmentMethod(List<Lead> newLeads){
        
        List<Execution_Criteria__c> AvailableCriterias = [SELECT Enabled__c,Evaluation_Expression_For_Execution__c,Id,Name ,(SELECT Execution_Criteria__c,Field_Name__c,Field_Type__c,Matching_Type__c,Matching_Value__c,Related_Object__c,Scorecard_Execution_Criteria_Name__c,Scorecard__c,Sequence__c FROM Execution_Criteria_Entry__r WHERE Execution_Criteria__c != null)FROM Execution_Criteria__c where Enabled__c = true];
        map<string,map<string,String>> expectedValuebyCriteria = new map<string,map<string,String>>();
        map<string,Decimal> allotedMarksbySequence = new Map<String,Decimal>();
        map<string,String> criteriaNameById = new Map<String,String>();
        
        for(Execution_Criteria__c scr:AvailableCriterias){
            map<string,string> fieldNameByMatching = new Map<String,string>();
            for(Execution_Criteria_Entry__c exe:scr.Execution_Criteria_Entry__R){
                fieldNameByMatching.put(exe.Field_Name__c,exe.Matching_Value__c);
            }
            expectedValuebyCriteria.put(scr.Name,fieldNameByMatching);
            criteriaNameById.put(scr.Name,scr.Id);
        }
        for(Lead ld:newLeads){
            for(String criteriaName : expectedValuebyCriteria.keyset()){
                integer matchedValues = 0;
                for(String field:expectedValuebyCriteria.get(criteriaName).Keyset())  {
                    if(expectedValuebyCriteria.get(criteriaName).get(field).contains(',')){
                        List<String> commaSeparatedValues = expectedValuebyCriteria.get(criteriaName).get(field).split(',');
                        for(String Str:commaSeparatedValues){
                            if(Str == String.valueOf(ld.get(field))){
                                matchedValues++;
                            } 
                        }
                    }else{
                        if(expectedValuebyCriteria.get(criteriaName).get(field) == String.valueOf(ld.get(field))){
                            matchedValues++;
                        }   
                    }
                    
                }
                allotedMarksbySequence.put(criteriaName,matchedValues);
            }
            system.debug('allotedMarksbySequence'+allotedMarksbySequence);
            getSuitableCriteriaAndAssignLead(allotedMarksbySequence,ld.Id,criteriaNameById);
        }
        system.debug('LeadsTobeUpdated'+LeadsTobeUpdated);
        if(LeadsTobeUpdated.size() > 0){
            database.update(LeadsTobeUpdated);
        }
    }
    
    public Static String getSuitableCriteriaAndAssignLead(map<string,Decimal> allotedMarksbySequence,String LeadId, map<string,String> criteriaNameById){
        List<Decimal> i_values = allotedMarksbySequence.values();
        i_values.sort();
        
        //get the max value of the count
        Decimal i_max_value = i_values[(i_values.size()-1)];
        String ExecutionCriteriaName = '';
        for(String s : allotedMarksbySequence.keySet()){
            Decimal oppty_map_value = allotedMarksbySequence.get(s);
            
            if(oppty_map_value == i_max_value){
                ExecutionCriteriaName =  s;//System.debug(' Id is ' + s + ' value is ' + oppty_map_value);
            }
        }
        system.debug('Selected ExecutionCriteriaName'+ExecutionCriteriaName);
        String LeadAssId = criteriaNameById.get(ExecutionCriteriaName);
        List<Assignment_Group__c> AssGroupList = [SELECT Id,Name,Max_Lead_Per_Day__c FROM Assignment_Group__c where Lead_Assigning_Criteria__c =:LeadAssId ORDER BY Max_Lead_Per_Day__c DESC NULLS LAST ];
        
        //system.debug('AssGroupList[0].Id '+AssGroupList[0].Id );
        if(AssGroupList.size() > 0){
            List<Assignment_Group_Member__c> groupMembers = [SELECT Group_Member__c,Id,Max_Lead_Per_Day__c,Name FROM Assignment_Group_Member__c where Active__c = true and Assignment_Group__c = :AssGroupList[0].Id ORDER BY Max_Lead_Per_Day__c DESC NULLS LAST];
            Lead ld = new lead(Id = LeadId,Owner__c  = groupMembers[0].Group_Member__c);
            LeadsTobeUpdated.add(ld);
            //update ld;
            return AssGroupList[0].Name; 
        }else{
            return AssGroupList[0].Name;    
        }
    }
    
    // @InvocableMethod(label='Text Local Message up on Lead Creation' )
    //  public static void leadInsert(List<string> newLeads){
    public  void leadInsert(List<Lead> newLeads){
        system.debug(newLeads[0]);
        List<string> Leadids = new List<string>();
        Leadids.add(newLeads[0].id);
        // Leadids.add(newLeads[0]);
        afterinsert(Leadids);
    }
    @Future(callout=true)
    public static void afterinsert(List<string> newLead){
        List<Lead> lstLead = [SELECT id, Phone from Lead where id=: newLead];
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        
        apiDetails =[SELECT id, Api_Key__c, Message__c, Sender__c from Text_Local_API_Details__c];
        if(lstLead[0].phone != null){
            String plPhoneNumber = lstLead[0].phone.right(10);
            if(plPhoneNumber.isNumeric() == false ){
                
                
                /* Execption__c e = new Execption__c();
e.Class_Name__c = 'TextMessageProcess';
e.Method_Name__c = 'sendSMS';
e.Ececption_Message__c = 'Invalid Number';
INSERT e; */
            }
            string apikey = apiDetails.Api_Key__c;
            string messages = apiDetails.Message__c;
            string sender = apiDetails.Sender__c;
            string numberse = plPhoneNumber;
            
            
            HttpRequest req = new HttpRequest(); 
            req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberse,'UTF-8')+'');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            Http http = new Http();
            
            HTTPResponse res = http.send(req);
            string response = res.getBody();
            system.debug('response'+response);
            ResponseStructure resBody  = (ResponseStructure) JSON.deserialize(response,ResponseStructure.class);
            if(resBody.status == 'failure') {
                Execption__c e = new Execption__c();
                e.Class_Name__c = 'TextMessageProcess';
                e.Method_Name__c = 'sendSMS';
                e.Ececption_Message__c = response;
                INSERT e;
            }
            
        }
    }
    
    public  void assignLead(List<Lead> leadList){
        List<Lead> updateList = new List<Lead>();
        for(Lead newLead:leadList){      
            System.debug('NEWLEAD'+newLead);
            if (newLead.Owner__c!=null) {
                Lead nLead = new Lead(Id=newLead.Id,OwnerId = newLead.Owner__c); 
                updateList.add(nLead);     
            } 
        }    
        update updateList;
        //System.debug('UpdateLead'+updateList[0]);
    }
    
    public class ResponseStructure {
        public String status;
    }   
    public  void updateCompanyBeforeInsert(List<Lead> newLeads){
        system.debug(newLeads[0]);
        List<string> Leadids = new List<string>();
        for(Lead ld:newLeads){
            if(ld.LeadSource == 'Facebook'){
                ld.Company = ld.LastName;
            }
        }
    }
}