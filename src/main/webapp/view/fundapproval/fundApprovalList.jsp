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
    .custom-width-modal {
			  width: 70% !important;
			  max-width: 100%;
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
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommend
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%}else{ %> Recommend<%} %> List</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="MainDashBoard.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	              <li class="breadcrumb-item active" aria-current="page">
	              <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommend
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%}else{ %> Recommend<%} %> List</li>
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
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommend
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Review
									         <%}else{ %> Recommend<%} %> Pending</label>
		    <input type="radio" name="tabs" id="tab-approved">
		    <label for="tab-approved" style="margin-bottom:0px !important;">Fund <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approved 
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommended
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noted
									         <%}else{ %> Recommended<%} %></label>
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
			                     <td align="center"><!-- <span class="badge badge-pending">Pending</span> -->
			                    <%System.err.print("st->"+obj[31]); %>
			                     <%if(obj[31]!=null && "A".equalsIgnoreCase(obj[31].toString())) {%>
				                   					<button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="click to view status" 
												            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
												            <span style="color: #2b8c03;">Approved</span> 
												            <i class="fa-solid fa-arrow-up-right-from-square" style="float: right;color: #2b8c03;" ></i>											
											       </button>
											       <%} else if(obj[31]!=null && "N".equalsIgnoreCase(obj[31].toString())){ %>	
											       	<button type="button" class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="click to view status" 
												            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
												             <span style="color: #8c2303;">Pending</span>
												             <i class="fa-solid fa-arrow-up-right-from-square" style="float: right; color: #8c2303;"></i>
											
											       </button>
											        <%} else if(obj[31]!=null && "F".equalsIgnoreCase(obj[31].toString())){ %>	
											       	<button type="button" class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="click to view status" 
												            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
												             <span style="color: blue;">Forwarded</span>
												             <i class="fa-solid fa-arrow-up-right-from-square" style="float: right; color: blue;"></i>
											
											       </button>
											       <%} %>
			                     
			                     </td>
			                     <td align="center">
			                     
			                           
			                           <% String rc1Status = obj[34] != null ? obj[34].toString().toUpperCase() : "NA";
			                           String rc2Status = obj[35] != null ? obj[35].toString().toUpperCase() : "NA";
			                           String rc3Status = obj[36] != null ? obj[36].toString().toUpperCase() : "NA";
			                           String rc4Status = obj[37] != null ? obj[37].toString().toUpperCase() : "NA";
			                           
			                           boolean allNA = rc1Status.equals("NA") && rc2Status.equals("NA") && rc3Status.equals("NA") && rc4Status.equals("NA");
			                           boolean hasN = rc1Status.equals("N") || rc2Status.equals("N") || rc3Status.equals("N") || rc4Status.equals("N");
			                           
			                           if((currentEmpStatus.equalsIgnoreCase("CS") || currentEmpStatus.equalsIgnoreCase("CC")) && !allNA && hasN){ %>
			                           
			                           <span style="color: #783d00; border-radius: 10px; padding: 2px 9px; background: #ffe8cc; font-size: 11px;font-weight: 800;">Recommendation Pending</span>
			                           
			                           <%}else{%>
			                           
			                            <form action="#" method="POST" name="myfrm" style="display: inline">  <!-- preview Start -->
			                               <button type="submit" data-tooltip="Preview & <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approve
													         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommend
													         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Note
													         <%} %>" data-position="top" class="btn btn-sm icon-btn tooltip-container" style="padding: 6px;border: 1px solid #05814d;background: #d3ffe5;" formaction="FundApprovalPreview.htm">
			                                                <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval
													         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommend
													         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
													         <%}else{ %> Recommend<%} %> &nbsp;&#10097;&#10097;
			                               </button>
			                             <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			                             <input type="hidden" name="FundApprovalIdSubmit" value="<%= obj[0] %>">
			                           
			                           </form>
			                           
			                           <%} %>
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
			                     <td align="center"> <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> 

									<button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="" 
									            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
									            <span style="color: #2b8c03;padding: 2%;">Approved</span> 
									            <i class="fa-solid fa-arrow-up-right-from-square" style="color: #2b8c03;padding-left: 1%" ></i>											
								       </button>
											        
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> 

									<button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="" 
									            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
									            <span style="color: #2b8c03;padding: 2%;">Recommended</span> 
									            <i class="fa-solid fa-arrow-up-right-from-square" style="color: #2b8c03;" ></i>											
								       </button>
								       
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %>
									         
									         <button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="" 
									            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
									            <span style="color: #2b8c03;padding: 2%;">Reviewed</span> 
									            <i class="fa-solid fa-arrow-up-right-from-square" style="color: #2b8c03;" ></i>											
								       </button>
									         <%}else{ %> Recommended<%} %></td>
			                    
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
<div class="modal fade" id="ApprovalStatusModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
 <div class="modal-dialog modal-lg custom-width-modal" role="document" style="">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="font-family:'Times New Roman';font-weight: 600;">Approval Status</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" style="font-size: 25px;color:white;">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- Employee Modal Table -->
        <div style="text-decoration: underline;font-weight: 600;color: #245997;">STATUS HISTORY:</div>
        <div id="EmployeeModalTable" class="mt-2"></div>
        <div style="text-decoration: underline;font-weight: 600;color: #245997;">CURRENT STATUS:</div>
         <div id="ApprovalStatusDiv" ></div>
        
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
  <script type="text/javascript">
	function openApprovalStatusAjax(fundApprovalId) {
		  $.ajax({
		    url: 'getRPBApprovalHistoryAjax.htm',
		    type: 'GET',
		    data: { fundApprovalId: fundApprovalId },
		    success: function(response) {
		      var data = JSON.parse(response);
		      if (!Array.isArray(data[0])) {
		        data = [data]; // handle single-row case
		      }

		      var tableHTML = generateTableHTML(data);
		      $('#ApprovalStatusModal').modal('show');
		      $('#EmployeeModalTable').html(tableHTML);
		      
		      previewInformation(fundApprovalId);
		    },
		    error: function(xhr, status, error) {
		      console.error('AJAX Error: ' + status + error);
		    }
		  });
		}

  function generateTableHTML(data) {
	  
    if (!data || data.length === 0) {
      return '<p>No Status available.</p>';
    }

    var table = '<table class="table table-bordered" style="width: 100%;font-weight: 600;">';
    table += '<thead><tr style="background-color: #edab33;color:#034189;"><th>Officer Name</th><th>Action Date</th><th>Remarks</th><th>Status</th></tr></thead>';
    table += '<tbody>';

    data.forEach(function(row) {
      table += '<tr>';
      table += '<td>' + (row[1] || '--') + ', ' + (row[2] || '--') + '</td>';
      table += '<td align="center">' + (row[5] || '--') + '</td>';
      table += '<td>' + (row[4] || '--') + '</td>';
      table += '<td style="color: #00008B;">' + (row[3] || '--') + '</td>';
      table += '</tr>';
    });

    table += '</tbody></table>';
    return table;
  }
  
  function previewInformation(fundApprovalId) {
	    $.ajax({
	        url: 'getRPBApprovalStatusAjax.htm',
	        type: 'GET',
	        data: { fundApprovalId: fundApprovalId },
	        success: function(response) {
	            var data = JSON.parse(response);
	            
	            if (!Array.isArray(data) || data.length === 0) {
	                $('#ApprovalStatusDiv').html('<p>No approval status data available.</p>');
	                return;
	            }
	            
	            var row = data[0]; 
	            var html = '';
	            
	            // Create table structure
	            html += '<div class="table-responsive" style="">';
	            html += '<table class="table table-bordered" style="box-shadow: 0px 0px 15px rgba(0, 0, 5, 5);">';
	            html += '<thead style="background-color: #f7f4e9;">';
	            html += '<tr>';
	            html += '<th style="width: 30%;">Role</th>';
	            html += '<th style="width: 40%;">Officer</th>';
	            html += '<th style="width: 30%;">Status</th>';
	            html += '</tr>';
	            html += '</thead>';
	            html += '<tbody>';
	            
	            
	            html += '<tr>';
	            html += '<td><b>Initiated By</b></td>';
	            html += '<td style="color: #370088;"><b>' + row[19] + '</b></td>';
	            html += '<td style="font-weight:600;">Initiated</td>';
	            html += '</tr>';
	            
	            var rcStatusCodeNext = row[40];
	            var rc1Status = row[41];
	            var rc2Status = row[42];
	            var rc3Status = row[43];
	            var rc4Status = row[44];
	            var rc5Status = row[45];
	            var apprOffStatus = row[46];
	            
	            var labels = [
	                { title: 'RPB Member', field: row[21], role: row[22], batch: row[41] },
	                { title: 'RPB Member', field: row[24], role: row[25], batch: row[42] },
	                { title: 'RPB Member', field: row[27], role: row[28], batch: row[43] },
	                { title: 'Subject Expert', field: row[30], role: row[31], batch: row[44] }
	            ];
	            
	          
	            for (var i = 0; i < labels.length; i++) {
	                var item = labels[i];
	                if (item.field != null && String(item.field).trim() !== '') {
	                    html += '<tr>';
	                    html += '<td><b>' + item.title + '</b></td>';
	                    html += '<td>';
	                    
	                    if (item.role) {
	                        html += '<span style="color:#034cb9"><b>' + item.role + '</b></span><br>';
	                    }
	                    html += '<span style="color: #370088"><b>' + item.field + '</b></span>';
	                    html += '</td>';
	                    html += '<td>';
	                    
	                    if (item.batch === 'Y') {
	                        html += '<span style="color: green;font-weight:600;">Recommended</span>';
	                        html += ' <img src="view/images/verifiedIcon.png" width="16" height="16">';
	                    } else {
	                        html += '<span style="color: #bd0707;font-weight:600;">Recommendation Pending</span>';
	                    }
	                    
	                    html += '</td>';
	                    html += '</tr>';
	                }
	            }
	            
	            // RPB Member Secretary
	            if (row[33] != null && String(row[33]).trim() !== '') {
	                html += '<tr>';
	                html += '<td><b>RPB Member Secretary</b></td>';
	                html += '<td>';
	                
	                if (row[34]) {
	                    html += '<span style="color:#034cb9"><b>' + row[34] + '</b></span><br>';
	                }
	                html += '<span style="color: #370088"><b>' + row[33] + '</b></span>';
	                html += '</td>';
	                html += '<td>';
	                
	                if (row[45] === 'Y') {
	                    html += '<span style="color: green;font-weight:600;">Reviewed</span>';
	                    html += ' <img src="view/images/verifiedIcon.png" width="16" height="16">';
	                } else {
	                    html += '<span style="color: #bd0707;font-weight:600;">Review Pending</span>';
	                }
	                
	                html += '</td>';
	                html += '</tr>';
	            }
	            
	            // RPB Chairman
	            if (row[36] != null && String(row[36]).trim() !== '') {
	                html += '<tr>';
	                html += '<td><b>RPB Chairman</b></td>';
	                html += '<td>';
	                
	                if (row[37]) {
	                    html += '<span style="color:#034cb9"><b>' + row[37] + '</b></span><br>';
	                }
	                html += '<span style="color: #370088"><b>' + row[36] + '</b></span>';
	                html += '</td>';
	                html += '<td>';
	                
	                if (row[46] === 'Y') {
	                    html += '<span style="color: green;font-weight:600;">Approved</span>';
	                    html += ' <img src="view/images/verifiedIcon.png" width="16" height="16">';
	                } else {
	                    html += '<span style="color: #bd0707;font-weight:600;">Approval Pending</span>';
	                }
	                
	                html += '</td>';
	                html += '</tr>';
	            }
	            
	            html += '</tbody>';
	            html += '</table>';
	            html += '</div>';
	            
	            $('#ApprovalStatusDiv').html(html);
	        },
	        error: function(xhr, status, error) {
	            console.error('AJAX Error: ' + status + " " + error);
	            $('#ApprovalStatusDiv').html('<div class="alert alert-danger">Error loading approval status</div>');
	        }
	    });
	}




</script>
</html>