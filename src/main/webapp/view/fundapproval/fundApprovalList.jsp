<%@page import="com.vts.rpb.utils.AmountConversion"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,com.vts.*,java.text.SimpleDateFormat"%>
<%@page import="com.vts.rpb.utils.DateTimeFormatUtil" %>

<%@page import="java.text.DecimalFormat"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<jsp:include page="../static/header.jsp"></jsp:include>
<jsp:include page="../static/sidebar.jsp"></jsp:include>
<title>FUND APPROVAL</title>

<style type="text/css">

.badge-counter
{
    margin-left: 0rem;
}

#fbePendingtab.nav-link.active {
    background-color: #cd8858 /* #cb7335 */ /* #cf4754 */ /* #813b3b */;
    font-weight: 600;
}
#fbeApprovedtab.nav-link.active {
    background-color: #066006;
    font-weight: 600; 
}

</style>
<style>

.greek-style {
            font-family: 'Times New Roman', Times, serif;
            font-weight: bold;
            font-style: italic;
            color: blue;
        }
        .recommendation-item {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .recommendation-item span {
            display: inline-block;
            margin-right: 10px;
        }

        .recommendation-value {
            font-weight: 600;
             color: #0303b9;
        }

        .recommendation-container {
            border: 0px solid #ccc;
            padding: 20px;
            border-radius: 5px;
        }

        .recommendation-item b {
            min-width: 150px;
            display: inline-block;
        }
    </style>
    
    <!-- Tab Styles -->
    <style>
    
    .tabs-container {
      max-width: 99% !important;
      margin: 0 auto;
    }
    /* hide native radio buttons */
    .tabs-container > input[type="radio"] {
      position: absolute;
      left: -100vw;
    }
    /* labels styled as tabs */
    .tabs-container > label {
      display: inline-block;
      padding: 12px 24px;
      border: 1px solid #ccc;
      border-bottom: none;
      cursor: pointer;
      background: #f9f9f9;
      margin-right: -5px;
      font-weight: 600;
      position: relative;
    }
    .tabs-container > label:hover {
      background: #eaeaea;
    }
    /* underline indicator */
    .tabs-container > label::after {
      content: '';
      position: absolute;
      bottom: -1px;
      left: 0;
      width: 100%;
      height: 3px;
      background: transparent;
      transition: background 0.2s;
    }
    /* checked tab styling */
    .tabs-container > input:checked + label {
      background: #fff2ad;
      border-bottom: 1px solid white;
    }
    .tabs-container > input:checked + label::after {
      background: #007bff;
    }
    /* content panel area */
    .tab-content {
      border: 1px solid #ccc;
      padding: 1rem;
      background-color: white !important;
      width: 100% !important;
    }
    .tab-panel {
      display: none;
    }
    /* show panel when corresponding radio is checked */
    #tab-pending:checked ~ .tab-content #panel-pending,
    #tab-approved:checked ~ .tab-content #panel-approved {
      display: block;
    }
    
    .badge {
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 0.85rem;
    }
    .badge-pending {
      background: #fef3c7;
      color: #b45309;
    }
    .badge-approved {
      background: #d1fae5;
      color: #065f46;
    }
  </style>
</head>
<body>
<%
List<Object[]> approvalPendingList=(List<Object[]>)request.getAttribute("ApprovalPendingList");
List<Object[]> approvedList=(List<Object[]>)request.getAttribute("ApprovalList");
String fromYear=(String)request.getAttribute("FromYear");
String toYear=(String)request.getAttribute("ToYear");
String DivisionDetails=(String)request.getAttribute("DivisionDetails");
String redirectedvalue=(String)request.getAttribute("redirectedvalueForward");
String currentEmpStatus=(String)request.getAttribute("employeeCurrentStatus");
%>

<%String success=(String)request.getParameter("resultSuccess"); 
String failure=(String)request.getParameter("resultFailure");%>


<div class="card-header page-top"> 
	<div class="row">
	 	<div class="col-md-3"><h5><% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommending
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%} %> List</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb ">
	    	     <li class="breadcrumb-item ml-auto"><a href="FundRequest.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Requisition List </a></li>
	              <li class="breadcrumb-item active" aria-current="page">
	              <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommending
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%} %> List</li>
             </ol>
          </div>
    </div>
</div><!-- Breadecrumb End -->



<div class="page card dashboard-card"> <!-- Page Start -->

    <%
    String Status=(String)request.getParameter("Status"); 
    String result1=(String)request.getParameter("Failure"); 
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
	
	
	<div class="card-body"><!-- Body Part Start -->
	
				
		<form action="FundApprovalList.htm" method="POST" autocomplete="off"> 
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				  <div class="flex-container" style="border-radius: 3px;height: auto !important;padding: 8px;justify-content: flex-end;border-bottom-right-radius: 0px !important;">
					<div class="form-inline" style="justify-content: end;">
				           

							   &nbsp;&nbsp;&nbsp;&nbsp;
						<div class="form-inline" style="">
							 <label id="fromLabel" style="font-weight: bold;">From:&nbsp;&nbsp;&nbsp;</label> 			
								 <input type="text" style="width: 100px; background-color:white;"  class="form-control"  id="FromYear" onchange="this.form.submit()" <%if(fromYear!=null){%> value="<%=fromYear%>" <%}%> name="FromYear"  required="required" readonly="readonly"> 
					    </div>
							   &nbsp;&nbsp;&nbsp;&nbsp;	
						<div class="form-inline" style="">
							 <label id="toLabel" style="font-weight: bold;">&nbsp;&nbsp;&nbsp;To:&nbsp;&nbsp;&nbsp;</label>
					              <input type="text" style="width: 100px; background-color:white;" class="form-control" id="ToYear"   <%if(toYear!=null){%>value="<%=toYear%>" <%}%>   name="ToYear"  required="required"  readonly="readonly" > 							
						</div>
					</div>  
				</div>
		</form> 
		
		<div class="tabs-container" style="margin-top:7px;">
		    <input type="radio" name="tabs" id="tab-pending" checked>
		    <label for="tab-pending" style="margin-bottom:0px !important;">Fund <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommending
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Review
									         <%} %> Pending</label>
		    <input type="radio" name="tabs" id="tab-approved">
		    <label for="tab-approved" style="margin-bottom:0px !important;">Fund <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approved 
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommended
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noted
									         <%} %></label>
		<span style="font-weight: 600;color: #843daf;">&nbsp;&nbsp;&nbsp;  RE - Revised Estimate / FBE - Forecast Budget Estimate</span>
		
		    <div class="tab-content card">
		      <section id="panel-pending" class="tab-panel">
		      	<div class="table-responsive" style="margin-top: 0.5rem;font-weight: 600;"> 
					<table class="table table-bordered" id="pending">  <!--Pending List Table Start -->
						 <thead>
			                <tr>
			                    <th>SN</th>
			                    <th style="width: 12%;" class="text-nowrap">Estimate Type</th> 
			                    <th>Division</th>
			                    <th class="text-nowrap">Budget Head</th>
			                    <th class="text-nowrap">Item Nomenclature</th>
			                    <th class="text-nowrap">Item Cost</th>
			                    <th>Status</th>
			                    <th style="width: 10%;" class="text-nowrap">Action</th>
			                </tr>
						 </thead>
						 <tbody>
							<%
							  int sn=1; 
							approvalPendingList.forEach(row->System.out.println(Arrays.toString(row)));
							  if (approvalPendingList != null && approvalPendingList.size() != 0) { 
								      for (Object[] obj : approvalPendingList) { 
						    %>
			                 <tr>
			                     <td align="center"><%=sn++ %>.</td>
			                     <% if(obj[1]!=null && obj[1].toString().equalsIgnoreCase("R")){%>
			                     <td align="center" style="width: 12%;">RE</td>
			                     <%}else{ %>
			                     <td align="center" style="width: 12%;">FBE</td>
			                     <% }%>
			                     <td align="left"><% if(obj[13]!=null){%> <%=obj[13] %> <%if(obj[12]!=null){ %> (<%=obj[12] %>) <%} %> <%}else{ %> - <%} %></td>
			                     <td align="left"><% if(obj[8]!=null){%> <%=obj[8] %> <%}else{ %> - <%} %></td>
			                     <td align="left"><% if(obj[14]!=null){%> <%=obj[14] %> <%}else{ %> - <%} %></td>
			                     <td align="right"><%=AmountConversion.amountConvertion(obj[17], "R") %></td>
			                     <td align="center"><span class="badge badge-pending">Pending</span></td>
			                     <td align="center">
			                     
			                            <form action="#" method="POST" name="myfrm" style="display: inline">  <!-- preview Start -->
			                               <button type="submit" data-tooltip="Preview & <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approve
													         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommend
													         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Note
													         <%} %>" data-position="top" class="btn btn-sm icon-btn tooltip-container" style="padding: 6px;border: 1px solid #05814d;background: #d3ffe5;" formaction="FundApprovalPreview.htm">
			                                                <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval
													         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommending
													         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
													         <%} %> &nbsp;&#10097;&#10097;
			                               </button>
			                             <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			                             <input type="hidden" name="FundApprovalIdSubmit" value="<%= obj[0] %>">
			                           
			                           </form>
			                     </td>  
			                 </tr>
						    <% 
							  }} else { 
							%>
			                <tr>
			                    <td colspan="8">
			                        <div class="text-danger" style="text-align:center">
			                            <h6 style="font-weight: 600;">No Pending Found</h6>
			                        </div>
			                    </td>
			                </tr>
						  <% } %>		                
						</tbody>
				  </table><!--Pending List Table End -->
				</div>
		      
		      </section>
		
		      <section id="panel-approved" class="tab-panel">
		      <div class="table-responsive" style="margin-top: 0.5rem;font-weight: 600;"> 
					<table class="table table-bordered" id="Approval">  <!--Pending List Table Start -->
						 <thead>
			                <tr>
			                    <th>SN</th>
			                    <th style="width: 12%;" class="text-nowrap">Estimate Type</th> 
			                    <th>Division</th>
			                    <th class="text-nowrap">Budget Head</th>
			                    <th class="text-nowrap">Item Nomenclature</th>
			                    <th class="text-nowrap">Item Cost</th>
			                    <th>Status</th>
			                </tr>
						 </thead>
						 <tbody>
							<%
							  int sN=1; 
							  if (approvedList != null && approvedList.size() != 0) { 
								      for (Object[] obj : approvedList) { 
						    %>
			                 <tr>
			                     <td align="center"><%=sN++ %>.</td>
			                     <% if(obj[1]!=null && obj[1].toString().equalsIgnoreCase("R")){%>
			                     <td align="center" style="width: 12%;">RE</td>
			                     <%}else{ %>
			                     <td align="center" style="width: 12%;">FBE</td>
			                     <% }%>
			                     <td align="left"><% if(obj[13]!=null){%> <%=obj[13] %> <%if(obj[12]!=null){ %> (<%=obj[12] %>) <%} %> <%}else{ %> - <%} %></td>
			                     <td align="left"><% if(obj[8]!=null){%> <%=obj[8] %> <%}else{ %> - <%} %></td>
			                     <td align="left"><% if(obj[14]!=null){%> <%=obj[14] %> <%}else{ %> - <%} %></td>
			                     <td align="right"><%=AmountConversion.amountConvertion(obj[17], "R") %></td>
			                     <td align="center"><span class="badge badge-approved">Approved</span></td>
			                    
			                 </tr>
						    <% 
							  }} else { 
							%>
			                <tr>
			                    <td colspan="8">
			                        <div class="text-danger" style="text-align:center">
			                            <h6 style="font-weight: 600;">No Record Found</h6>
			                        </div>
			                    </td>
			                </tr>
						  <% } %>		                
						</tbody>
				  </table><!--Pending List Table End -->
				</div>
		       
		      </section>
		    </div>
		  </div>
	
	
 </div><!-- Body Part End --> 
			
</div> <!-- Page End -->


<!-- Modal Start -->
<div class="modal fade" id="AllBudgetItem" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel"style="font-family:'Times New Roman';font-weight: 600;">Budget Item Details</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" style="font-size: 25px;color:white;">&times;</span>
        </button>
      </div>
      <div class="modal-body" >
        
        <div class="table-responsive">
          <table class="table table-bordered" style="font-weight: 600;width: 100%;" id="AllBudgetItemDetails">
                 <thead>
                     <tr style="background-color:#edab33;color:#034189;">					                       
                      <th class="text-nowrap">SN</th>
                      <th class="text-nowrap">FBE Serial No</th>
                      <th class="text-nowrap">Budget Item</th>
                      <th class="text-nowrap">Item Nomenclature</th>
                      <th class="text-nowrap">Item Amount</th>
                     
                     </tr>
                 </thead>
                 <tbody>
                 
                    </tbody>
                    <tfoot>
                    </tfoot>
                </table> 
             </div>
       
      </div>
    </div>
  </div>
</div><!-- Modal End -->

<!-- Modal -->
<div class="modal fade" id="EmployeeApprovalModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" style="min-width: 65% !important;" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="font-family:'Times New Roman';font-weight: 600;">Budget Status</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" style="font-size: 25px;color:white;">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- Employee Modal Table -->
        <div id="EmployeeModalTable"></div>

        <!-- Employee Status Center Aligned -->
        <div class="recommendation-item" id="Employeehide" style="width:77%; margin: auto;justify-content: center;">
          <b><span style="color: #2c8f78;" id="EmployeeStatus" class="recommendation-value"></span></b>
        </div>
        
        <!-- Flex Container for Note and Table -->
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
          <!-- Note Section (Left) -->
          <div style="flex: 1; text-align: left;">
            <span style="color: red; font-weight: bold;">Note:</span>
            <div style="color: green; margin-left: 10px; font-weight: 600;" class="Rc1hide">
              &nbsp;&nbsp;RC - Recommending Officer
            </div>
            <div style="color: green; margin-left: 10px; font-weight: 600;">
              &nbsp;&nbsp;AO - Approving Officer
            </div>
          </div>

          <!-- Table Section (Right) -->
         <div style="flex: 1; text-align: right;">
           <div class="action-section" style="box-shadow: 0px 4px 7px rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 20px; background-color: #fff; border: none;">
            <table class="table" style="width: 100%; font-weight: 600; border-top: none; border-bottom: none; border: none;">
              <tbody>
                <tr class="Initiatinghide">
                  <td align="right" style="border: none;">Initiated By <i class="fa fa-long-arrow-right" aria-hidden="true"></i></td>
                  <td align="left" style="border: none;">
                    <span class="recommendation-value" id="InitiatingOfficer"></span>
                  </td>
                </tr>
                <tr class="Rc1hide">
                  <td align="right" style="border: none;">RC1  <i class="fa fa-long-arrow-right" aria-hidden="true"></i></td>
                  <td align="left" style="border: none;">
                    <span class="recommendation-value" id="RC1"></span>&nbsp;<span class="recommendation-value" id="Rc1Role"></span>
                  </td>
                </tr>
                <tr class="Rc2hide">
                  <td align="right" style="border: none;">RC2  <i class="fa fa-long-arrow-right" aria-hidden="true"></i></td>
                  <td align="left" style="border: none;">
                    <span class="recommendation-value" id="RC2"></span>&nbsp;<span class="recommendation-value" id="RC2Role"></span>
                  </td>
                </tr>
                <tr class="Rc3hide">
                  <td align="right" style="border: none;">RC3  <i class="fa fa-long-arrow-right" aria-hidden="true"></i></td>
                  <td align="left" style="border: none;">
                    <span class="recommendation-value" id="RC3"></span>&nbsp;<span class="recommendation-value" id="RC3Role"></span>
                  </td>
                </tr>
                <tr class="Approvinghide">
                  <td align="right" style="border: none;">AO  <i class="fa fa-long-arrow-right" aria-hidden="true"></i></td>
                  <td align="left" style="border: none;">
                    <span class="recommendation-value" id="ApprovingOfficer"></span>&nbsp;<span class="recommendation-value" id="ApprovingOfficerRole"></span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>


</body>

<script type="text/javascript">

<%if(success!=null){%>

showSuccessFlyMessage('<%=success %>');

<%}else if(failure!=null){%>

showFailureFlyMessage('<%=failure %>');

<%}%>

</script>

<script type="text/javascript">
 $(document).ready(function(){
 	  $("#pending").DataTable({
 	 "lengthMenu": [[5, 10, 25, 50, 75, 100,'-1'],[5, 10, 25, 50, 75, 100,"All"]],
 	 "pagingType": "simple",
 	 "pageLength": 5,
 	 "ordering": true
 });
 });
 
 
 $(document).ready(function(){
	  $("#Approval").DataTable({
	 "lengthMenu": [[5, 10, 25, 50, 75, 100,'-1'],[5, 10, 25, 50, 75, 100,"All"]],
	 "pagingType": "simple",
	 "pageLength": 5,
	 "ordering": true
});
});
 </script>

<script>
    var csrfParameterName = '${_csrf.parameterName}';
    var csrfToken = '${_csrf.token}';

    function submitPrintForm(FbeMainId,DivisionCode,DivisionId,FinancialYear,Action,EstimateType) {
        var url = 'FBEprint.htm?' + csrfParameterName + '=' + csrfToken + '&FbeMainId=' + FbeMainId + '&DivisionCode=' + DivisionCode + '&DivisionId=' + DivisionId + '&FinancialYear=' + FinancialYear + '&Action=' + Action + '&EstimateType=' + EstimateType;
        window.open(url, '_blank');
    }
</script>
<script type="text/javascript">
function showAllEmployee(RC1, Rc1Role, RC2, RC2Role, RC3, RC3Role, ApprovingOfficer, ApprovingOfficerRole, InitiatingOfficer, Status, RCStausCodeNext, BudgetCode, FbeMainId) {
    // Show the modal
    $('#EmployeeApprovalModal').modal('show');
    $('#Employeehide,.Rc1hide,.Rc2hide,.Rc3hide,.Approvinghide').show();
    if(Status=="F") {
        
        if(RCStausCodeNext=="RC1") {
       	 $('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Pending With <span style="color:red;font-weight:600;">' + RC1 + '</span>(RC1)');
		  } else if(RCStausCodeNext=="RC2") { 
			  $('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Pending With <span style="color:red;font-weight:600;">' + RC2 + '</span>(RC2)');
		  } else if(RCStausCodeNext=="RC3") { 
			  $('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Pending With <span style="color:red;font-weight:600;">' + RC3 + '</span>(RC3)');
		  }else if(RCStausCodeNext=="APR") { 
			  $('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Pending With <span style="color:red;font-weight:600;">' + ApprovingOfficer + '</span>(AO)');
		  }
		}
		else if(Status=="A")
		{
		$('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Approved By <span style="color:red;font-weight:600;">' + ApprovingOfficer + '</span>(AO)');
		
		}
		else if(Status=="R")
		{
			      if(RCStausCodeNext=="RC1") {
		       	      $('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Return By <span style="color:red;font-weight:600;">' + RC1 + '</span>(RC1)');
				  } else if(RCStausCodeNext=="RC2") { 
					  $('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Return By <span style="color:red;font-weight:600;">' + RC2 + '</span>(RC2)');
				  } else if(RCStausCodeNext=="RC3") { 
					  $('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Return By <span style="color:red;font-weight:600;">' + RC3 + '</span>(RC3)');
				  } else if(RCStausCodeNext=="APR") { 
					  $('#EmployeeStatus').html('<span style="color:#d70c0c;font-weight:600;">'+BudgetCode+' (Budget)</span>Return By <span style="color:red;font-weight:600;">' + ApprovingOfficer + '</span>(AO)');
				  } 

        }
		else
		{
		 $('#Employeehide').hide();		
		}
    
    
    
    if(RC1=='null' || Rc1Role =='null' )
    {
    	 $('.Rc1hide').hide();
    }
    else
   	{
	   	$('#RC1').text(RC1);
	   	$('#Rc1Role').text(" ("+Rc1Role+")");
	   	
   	}
    
    if(RC2=='null' || RC2Role =='null' )
    {
    	 $('.Rc2hide').hide();
    }
    else
   	{
        $('#RC2').text(RC2);
        $('#RC2Role').text(" ("+RC2Role+")");
   	}
    
    if(RC3=='null' || RC3Role =='null' )
    {
    	 $('.Rc3hide').hide();
    }
    else
   	{
    	$('#RC3').text(RC3);
    	$('#RC3Role').text(" ("+RC3Role+")");
   	}
    
    if(ApprovingOfficer=='null' || ApprovingOfficerRole =='null' )
    {
    	 $('.Approvinghide').hide();
    }
    else
   	{
        $('#ApprovingOfficer').text(ApprovingOfficer);
        $('#ApprovingOfficerRole').text(" ("+ApprovingOfficerRole+")");
   	}
    if(InitiatingOfficer =='null' )
    {
    	 $('.Initiatinghide').hide();
    }
    else
   	{
    	$('#InitiatingOfficer').text(InitiatingOfficer);
   	}

    // Perform AJAX call to fetch data
    $.ajax({
        url: 'FbeStatusTrack.htm',
        type: 'GET',
        data: {
            FbeMainId: FbeMainId
        },
        success: function(response) {
            // Parse the JSON response
            var data = JSON.parse(response);
            
            // Generate HTML table from the data
            var tableHTML = generateTableHTML(data);
            
            // Update the modal body with the generated table
            $('#EmployeeModalTable').html(tableHTML);
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error: ' + status + error);
            // Handle errors here
        }
    });
}

// Function to generate HTML table from the data
function generateTableHTML(data) {
    if (!data || data.length === 0) {
        return '<p>No Status available.</p>';
    }

    var table = '<table class="table table-bordered" style="width: 100%;font-weight: 600;">';
    table += '<thead><tr style="background-color: #edab33;color:#034189;"><th>Employee Name</th><th>Action Date</th><th>Remarks</th><th>Status</th></tr></thead>';
    table += '<tbody>';

    data.forEach(function(row) {
        table += '<tr>';
        table += '<td >' + (row[8] || '--') + '</td>';
        table += '<td >' + (row[4] || '--') + '</td>';
        table += '<td >' + (row[5] || '--') + '</td>';
        table += '<td >' + (row[6] || '--') + '</td>';
        table += '</tr>';
    });

    table += '</tbody></table>';
    return table;
}

</script>
<script type="text/javascript">
function getAllBudgetItem(fbeMainId) {
    var totalAmount = 0;

    $("#AllBudgetItem").modal("show");
    $.get('GetBudgetCodeItemList.htm', 
        {
            fbeMainId: fbeMainId
        },
        function(responseJson) {
            var result = JSON.parse(responseJson);
            var table = document.getElementById("AllBudgetItemDetails");
            $(".BudgetCodeApproval").remove();
            var tbody = table.querySelector('tbody');
            var tfoot = table.querySelector('tfoot');
            
            // Remove existing rows in tfoot if any
            $(tfoot).empty();
            var sn=1;
            if (result.length > 0) {
                $.each(result, function(key, value) {
                    // Add to total amount
                    totalAmount += parseFloat(value[4]);
                    var rows = tbody.rows.length;
                    var row = tbody.insertRow(rows);
                    row.style.backgroundColor = "white";
                    row.className = "BudgetCodeApproval";

                    // Create cells
                    var cell1 = row.insertCell(0);
                    var cell2 = row.insertCell(1);
                    var cell3 = row.insertCell(2);
                    var cell4 = row.insertCell(3);
                    var cell5 = row.insertCell(4);

                    // Set cell contents
                    cell1.innerHTML = (sn++)+'.';
                    cell2.innerHTML = value[5];
                    cell3.innerHTML = value[2];
                    cell4.innerHTML = value[3];
                    cell5.innerHTML = value[4];
                    cell1.style.textAlign = "center";
                    cell2.style.textAlign = "center";
                    cell5.style.textAlign = "right";

                    // Add hidden input for FbeSubId
                    var hiddenInput = $('<input>', {
                        type: 'hidden',
                        class: 'checkboxApproval',
                        name: 'FbeSubId',
                        value: value[0]
                    });
                    $(row).append(hiddenInput);

                    // Style the cells
                    cell1.style.padding = "10px";
                    cell2.style.padding = "10px";
                    cell3.style.padding = "10px";
                    cell4.style.padding = "10px";
                    cell5.style.padding = "10px";
                });

                // Add tfoot row for total amount
                var tfootRow = tfoot.insertRow(0);
                var footcell1 = tfootRow.insertCell(0);
                var footcell2 = tfootRow.insertCell(1);
                

                // Set cell contents for total amount
                footcell1.colSpan = 4;
                footcell1.innerHTML = "Total Amount :";
                footcell2.innerHTML = totalAmount.toLocaleString('en-IN', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
 

                // Style the cells
                footcell1.style.textAlign = "right";
                footcell1.style.padding = "10px";
                footcell1.style.fontWeight = "bold";
                footcell1.style.color = "blue";

                footcell2.style.padding = "10px";
                footcell2.style.fontWeight = "bold";
                footcell2.style.color = "blue";
                footcell2.style.textAlign = "right";
                

            } else {
                var row = tbody.insertRow(0);
                row.style.backgroundColor = "white";
                row.className = "BudgetCodeApproval";
                
                // Create a single cell that spans all columns
                var cell = row.insertCell(0);
                cell.colSpan = 5;
                cell.innerHTML = "No data available";
                
                // Style the cell
                cell.style.textAlign = "center";
                cell.style.padding = "10px";
                cell.style.fontWeight = "600"; 
                cell.style.color = "red";
            }
        }
    );
}

</script>

<script>
  // Get references to the elements
  // Add click event handlers to the tab links
  $("#fbePendingtab").click(function() {
	$("#redirectedvalue").val('');
    $("#redirectedvalue").val('fbePending');
  });

  $("#fbeApprovedtab").click(function() {
    $("#redirectedvalue").val('');
    $("#redirectedvalue").val('fbeApproved');
  });
 /*  $("#fbeReturnedtab").click(function() {
    $("#redirectedvalue").val('');
    $("#redirectedvalue").val('fbeReturned');
  }); */
  
</script>

<script>
  var countForMsgMarkerRedirect = '<%= redirectedvalue %>';
  
  if (countForMsgMarkerRedirect != 'null' && countForMsgMarkerRedirect==='fbePending') {
         var button = document.querySelector('[id="fbePendingtab"]');
		     if (button) {
		      // Programmatically trigger a click event on the button
		      button.click();      
               }
  }else if(countForMsgMarkerRedirect != 'null' && countForMsgMarkerRedirect==='fbeApproved'){
	    var button = document.querySelector('[id="fbeApprovedtab"]');
	       if (button) {
               // Programmatically trigger a click event on the button
               button.click();    
               }
  }else if(countForMsgMarkerRedirect != 'null' && countForMsgMarkerRedirect==='fbeReturned'){
	    var button = document.querySelector('[id="fbeReturnedtab"]');
	       if (button) {
            // Programmatically trigger a click event on the button
            button.click();    
            }
}
  
</script> 



<script>
   $("#FromYear").datepicker({
	   format: "yyyy",
	     viewMode: "years", 
	     minViewMode: "years",
	     autoclose:true,
         updateViewDate: true,
	     changeYear: true,
	     endDate: new Date().getFullYear().toString()
	});
  </script>
			  
  <script>
      $("#FromYear").change(function(){
         var FromYear=$("#FromYear").val();
         var value=parseInt(FromYear)+1;
         $("#ToYear").val(value);
      });
  </script>
</html>