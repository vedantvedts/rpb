<%@page import="com.vts.rpb.utils.DateTimeFormatUtil"%>
<%@page import="java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta charset="ISO-8859-1">
<jsp:include page="../static/header.jsp"></jsp:include>
<title>Committee Master List</title>
<%
List<Object[]>CommitteMaster=(List<Object[]>)request.getAttribute("CommitteMaster");
%>
<style type="text/css">
#addBtn, #editBtn {
    display: none;
}


</style>

</head>
<body>
<div class="card-header page-top"> 
	<div class="row">
	 	<div class="col-md-3"><h5>Committee  List</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="MainDashBoard.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	              <li class="breadcrumb-item active" aria-current="page">
	            Committee List</li>
             </ol>
          </div>
    </div>
</div><!-- Breadecrumb End -->

    <%
    String Status=(String)request.getParameter("resultSuccess"); 
    String result1=(String)request.getParameter("resultFailure"); 
	   if(Status!=null){
	%>
	      <div align="center">
		     <div  class="text-center alert alert-success col-md-8 col-md-offset-2" style="margin-top: 1rem" role="alert">
        	        <%=Status %>
             </div>
   	     </div>
	<%
	   }else if(result1!=null){
	%>
	     <div align="center">
	         <div class="text-center alert alert-danger col-md-8 col-md-offset-2" style="margin-top: 1rem;" role="alert" >
					<%=result1 %>
			 </div>
		</div>
	<%} %>

				     <div class="page card dashboard-card">	
 <div class="table-responsive" style="width: 70%;margin:auto;margin-top: 2%;">					
					   			<table class="table table-bordered table-hover table-striped table-condensed" id="TableCommitteMaster">
				                   <thead>
				                       <tr>
				                       <th>SN</th>
				                       
				                       <th class="text-nowrap">MemberType</th>
				                       <th class="text-nowrap">Employee Details</th>
				                       <th class="text-nowrap">Valid From</th>
				                       <th >Valid To</th>
				                       <th >Action</th>
				                       </tr>
				                   </thead>
				               
			                    <tbody>
			                        <%
			                        int a=1;
			                        if(CommitteMaster!=null && CommitteMaster.size()>0){
				                	   for(Object[]obj:CommitteMaster){
				                	   %>
				                  <tr>
				                  
				                  <td class="no-wrap" style="text-align: center;"><%=a++ %>.</td>
				                  <td class="no-wrap" style="text-align: center;"><%if(obj[0]!=null){ 
				                	  
				                  if(obj[0].toString().equalsIgnoreCase("CC")){%>
				                  Chair Person
				                  <%}else if(obj[0].toString().equalsIgnoreCase("CS")){%>
				                  Secretary  
				                  <%}else if(obj[0].toString().equalsIgnoreCase("CM")){ %>
				                  Member
				                  <%}else if(obj[0].toString().equalsIgnoreCase("SC")){ %>
				                  Standby Chair Person
				                  <%} %>
				                 
				                 <%}else{ %>--<%} %></td>
				                  <td class="no-wrap" style="text-align: center;"><%=obj[4] %><%=','%> <%=obj[5] %></td>
				                  <td class="no-wrap"style="text-align: center;"><%if(obj[2]!=null){ %><%=DateTimeFormatUtil.getSqlToRegularDate(obj[2].toString()) %><%}else{ %>--<%} %></td>
				                  <td class="no-wrap" style="text-align: center;"><%if(obj[3]!=null){ %><%=DateTimeFormatUtil.getSqlToRegularDate(obj[3].toString()) %><%}else{ %>--<%} %></td>
				                  <td align="center">
				                 <button type="button" class="btn btn-sm edit-icon"  title="Edit" onclick="committeeMAsterModal('Edit','<%=obj[0]%>','<%=obj[1]%>','<%=obj[2] != null ? DateTimeFormatUtil.getSqlToRegularDate(obj[2].toString()) : "" %>','<%=obj[3] != null ? DateTimeFormatUtil.getSqlToRegularDate(obj[3].toString()) : "" %>','<%=obj[6]%>')"><i class="fa-solid fa-pen-to-square"></i></button>

				                  
				                  </td>
				                  
				                  
				                  
				                  
				                  <%}}else{ %>
				                  <tr><td colspan="6" align="center" style="font-weight: 600;color:red;">No Record Found</td></tr>
				                  <%} %>
		                       </tbody> 
		                       
		                      </table>
		                    
		                      <div align="center" style="height: 3rem;"> 
                                  <button type="button" class="btn btn-sm add-btn" onClick="committeeMAsterModal('Add')" >Add</button>
                              </div>
                            
                              
		                 </div>  
</div>

    <!-- modal for sanction -->   
        
 	<div class="modal comitteeMasterModal" tabindex="-1" role="dialog">
				  <div class="modal-dialog" role="document" style="min-width: 40% !important;min-height: 90% !important;">
				    <div class="modal-content">
				      <div class="modal-header">
				        <h4 class="modal-title" style="font-family:'Times New Roman';font-weight: 600;font-size: 18px !important;"><span class="committeMasterHeading" style="font-size: 18px !important;"></span>&nbsp;</h4>
				        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true" style="font-size: 25px;color:white;">&times;</span>
				        </button>
				      </div>
				      <div class="modal-body">
				       <form action="#" id="committeMasterform" >
				      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				    
				       <input type="hidden" id="CommiteeMemberId" name="CommiteeMemberId" class="CommiteeMemberId">
				       <div class="table-responsive">
				       <table style="width: 100%;">
				       
				        <tr>  
			            <td style="width: 30%;padding: 10px;"><label style="font-weight: 600;">Member Type <span class="mandatory" style="color: red;font-weight: normal;">*</span>&nbsp;</label></td>
			            <td style="padding: 10px;">
			     
			            <select id="MemberType" name="MemberType" class="form-control select2" style="width:100% !important" required="required">
			             <option value="CM" >Member</option>
			             <option value="CS" >Secretary</option>
			             <option value="CC" >Chair Person</option>
			             <option value="SC" >Standby Chair Person</option>
			            
			           </select>
			           
			            </td></tr>
				       
				       
				       
				       
				       
			           <tr>  
			            <td style="width: 30%;padding: 10px;"><label style="font-weight: 600;">Employee <span class="mandatory" style="color: red;font-weight: normal;">*</span>&nbsp;</label></td>
			            <td style="padding: 10px;">
			     
			            <select id="AllOfficersList" name="Employee" class="form-control select2" style="width:100% !important" required="required">
			            
			           <%--  <%
			        if(ScheduleList!=null && ScheduleList.size() > 0 ){
			            for(Object[] obj: ScheduleList){%>
			            <option value="<%= obj[0] %>" ><%=obj[1] %> </option>
			            <%}} %> --%>  
			           </select>
			           
			            </td></tr>
			           
			          
			               
                      <tr>  
			            <td style="width: 30%;padding: 10px;"><label style="font-weight: 600;">From Date <span class="mandatory" style="color: red;font-weight: normal;">*</span>&nbsp;</label></td>
			            <td style="padding: 10px;">
			            <input type="text" name="FromDate" id="FromDate" class="Date form-control"  required="required" readonly="readonly"/> 
                     <input type="hidden" id="hiddenSanctionDate" >
                       <tr>  
			            <td style="width: 30%;padding: 10px;"><label style="font-weight: 600;">Valid Date <span class="mandatory" style="color: red;font-weight: normal;">*</span>&nbsp;</label></td>
			            <td style="padding: 10px;">
			            <input type="text" name="ValidDate" id="ValidDate" class="ValidDate form-control" required="required" readonly="readonly"/> 
			          
			            </td></tr>
			            
			           </table>
				       </div>
				   
                      
				     <!--  <div class="modal-footer" style="justify-content: center;background-color: #f0f5ff;border-radius: 3px;">
				        <button type="submit" class="btn btn-sm btn-secondary"  style="background-color: rgb(30 163 23);color:white;" onclick="CommitteeMasterValidation('Add')" >Submit</button>
				      </div> -->
				      
				      <div class="modal-footer">
    <button type="button" class="btn btn-success" id="addBtn"
            onclick="CommitteeMasterValidation('Add')">Add Committee</button>

    <button type="button" class="btn btn-warning" id="editBtn"
            onclick="CommitteeMasterValidation('Edit')">Update Committee</button>
</div>
				      
				   
				       </form>
				      </div>
				    </div>
				  </div>
				</div>
       
      





</body>
<script type="text/javascript">
function committeeMAsterModal(Action,MemberType,EmployeeID,FromDate,ToDate,CommitteMasterId) {
	$(".comitteeMasterModal").modal('show'); 
	$(".committeMasterHeading").empty();
	$(".CommiteeMemberId").empty();
	
	
	 // Hide both buttons first
    $("#addBtn").hide();
    $("#editBtn").hide()
	
	
	
	if(Action=='Add')
	{   
		$(".committeMasterHeading").append("Committee Add");
		
		EmployeeList('');
		
		 $("#addBtn").show();   // Show Add button only
		 
		// Set FromDate to today
		    let today = new Date();
		    let dd = String(today.getDate()).padStart(2, '0');
		    let mm = String(today.getMonth() + 1).padStart(2, '0'); // Months are 0-based
		    let yyyy = today.getFullYear();
		    let fromDateStr = dd + '-' + mm + '-' + yyyy;
		 
		 
		 
		 $("#FromDate").val('');
	        $("#FromDate").data('daterangepicker').setStartDate(new Date());
	        $("#FromDate").data('daterangepicker').setEndDate(new Date());


	        // Set ValidDate to one month after FromDate
	        let nextMonth = new Date(today);
	        nextMonth.setMonth(today.getMonth() + 1);
	        let dd2 = String(nextMonth.getDate()).padStart(2, '0');
	        let mm2 = String(nextMonth.getMonth() + 1).padStart(2, '0');
	        let yyyy2 = nextMonth.getFullYear();
	        let validDateStr = dd2 + '-' + mm2 + '-' + yyyy2;

	        $("#ValidDate").val(validDateStr);
	        $("#ValidDate").data('daterangepicker').setStartDate(validDateStr);
	        $("#ValidDate").data('daterangepicker').setEndDate(validDateStr)
						
	}
	
	if(Action=='Edit'){
	
		$(".committeMasterHeading").append("Committee Edit");
		  $("#editBtn").show();  // Show Edit button only
	    // Set MemberType and refresh Select2
	    $("#MemberType").val(MemberType).trigger("change");

	    $(".CommiteeMemberId").val(CommitteMasterId);
		
		//id--CommitteMasterId
		$(".CommiteeMemberId").val(CommitteMasterId);

        // Populate employee dropdown & select the current employee
        EmployeeList(EmployeeID);

        // Set dates in input + datepicker
        $("#FromDate").val(FromDate);
        $("#FromDate").data('daterangepicker').setStartDate(FromDate);
        $("#FromDate").data('daterangepicker').setEndDate(FromDate);

        $("#ValidDate").val(ToDate);
        $("#ValidDate").data('daterangepicker').setStartDate(ToDate);
        $("#ValidDate").data('daterangepicker').setEndDate(ToDate);
		
	}
	$("#Action").val(Action);
}













function EmployeeList(OfficerId)
{
	$.get('EmployeeListAjax.htm', 
			 function(responseJson) {
				$('#AllOfficersList').find('option').remove();		
			
				var result = JSON.parse(responseJson);
			
				$.each(result, function(key, value) {
					var html1='';
					if(value[0]== OfficerId){
						
						html1=	'<option value="'+value[0]+'" selected="selected">'+ value[2] + ", " + value[3] +'</option>'
						}else{
							
							html1 = "<option value='" + value[0] + "'>"  + value[2] + ", " + value[3] + "</option>";
						}
					    $("#AllOfficersList").append(html1);
					
				});
				
			});
	}


 function CommitteeMasterValidation(Action) {
    // Prevent form submission if called from the button click
    event.preventDefault(); 
   
    
   
    var Form = $("#committeMasterform");

    var url = '';
    if (Action === 'Add') {
        url = 'committeMasterAdd.htm';
    } else if (Action === 'Edit') {
        url = 'committeMasterEdit.htm';
    }

  

      if (Form) {
          Form.attr('action', url);
          if (confirm("Are you sure you want to submit?")) {
              Form.submit();
          }
      }
  }

























//Date --picker validations
$(document).ready(function() {
    // Initialize the Date picker
    var SanctionDate=$("#hiddenSanctionDate").val();
    if(SanctionDate==null)
    	{
    	 SanctionDate=new Date();
    	}
    $("#FromDate").daterangepicker({
        autoclose: true,
        singleDatePicker: true,
        linkedCalendars: false,
        showCustomRangeLabel: true,
        showDropdowns: true,
        locale: {
            format: 'DD-MM-YYYY'
        },
        maxDate:SanctionDate
    });

    // Get the initial date from the Date input
    var initialDate = $('#FromDate').data('daterangepicker').startDate;
    var FromDate=$("#FromDate").val();

    // Initialize the ValidDate picker with the minimum date set to the initial Date
    $('#ValidDate').daterangepicker({
        autoclose: true,
        singleDatePicker: true,
        linkedCalendars: false,
        showCustomRangeLabel: true,
        showDropdowns: true,
        locale: {
            format: 'DD-MM-YYYY'
        },
        minDate: SanctionDate 
    });
}); 

$("#FromDate").change(function() {
	 var SanctionDate=$("#FromDate").val();
	 $('#ValidDate').daterangepicker({
	        autoclose: true,
	        singleDatePicker: true,
	        linkedCalendars: false,
	        showCustomRangeLabel: true,
	        showDropdowns: true,
	        locale: {
	            format: 'DD-MM-YYYY'
	        },
	        minDate: SanctionDate,
	        startDate: SanctionDate 
	    });
	
});








/* function committeeMAsterModal(Action) {
	$(".comitteeMasterModal").modal('show'); 
	if(Action=='Add')
	{   
		$(".committeMasterHeading").append("Committee Add");
		
		EmployeeList();
						
	}
	else if(Action=='Revise')
		{
		$(".Sanction").append("Sanction Revise");	
		
		    $("#scheduleIdRevise").show();
			$('#scheduleId').next('.select2-container').hide();
			$('#scheduleIdRevise').val(ScheduleNo);
			$('#SanctionCost').val(SancCost);
			$('#SanctionDate,#hiddenSanctionDate').val(Date);
			$('#ValidDate,#hiddenValidDate').val(ValidDate);
			$('#ScheduleSanctionId').val(SanctionId);
			$('#SanctionNo').val(SanctionNo);
			$('#hiddenPrjDetails').val(projectDetails)
			if(Remarks!=='null'){
			$("#Remarks").val(Remarks);
			}else{
				$("#Remarks").val('');
			}
			$("#Remarks").show();
			$("#Remark").show();
			
			if(projectDetails.split("#")[1])
			{
				
				$("#displayPrjCode").html(projectDetails.split("#")[1]);
			}
			
		}
	if(Action=='Edit'){
		ScheduleList(DelegationId);
		
		
		
		$(".Sanction").append("Sanction Edit");
		$('#scheduleId').next('.select2-container').show();
		$("#scheduleIdRevise").hide();
		$('#SanctionCost').val(SancCost);
		$('#SanctionDate,#hiddenSanctionDate').val(Date);
		$('#ValidDate,#hiddenValidDate').val(ValidDate);
		$('#ScheduleSanctionId').val(SanctionId);
		$('#SanctionNo').val(SanctionNo);
		$('#hiddenPrjDetails').val(projectDetails)
		if(Remarks!=='null'){
			$("#Remarks").val(Remarks);
			}else{
				$("#Remarks").val('');
			}
		$("#Remarks").show();
		$("#Remark").show();
		
		if(projectDetails.split("#")[1])
		{
			
			$("#displayPrjCode").html(projectDetails.split("#")[1]);
		}
		
		
	}
	$("#Action").val(Action);
}

 */























$(document).ready(function () {
    $('#TableCommitteMaster').DataTable({
    	"lengthMenu": [[5, 10, 25, 50, 75, 100,'-1'],[5, 10, 25, 50, 75, 100,"All"]],
        paging: true,
        "searching": true,
   	    "ordering": true,
	    "responsive": true
    });
});



</script>
</html>