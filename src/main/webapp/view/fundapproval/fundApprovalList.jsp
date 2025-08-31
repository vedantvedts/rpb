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
<title>FUND APPROVAL LIST</title>

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
if(currentEmpStatus == null)
{
	currentEmpStatus = "NA";
}
%>

<%String success=(String)request.getParameter("resultSuccess"); 
String failure=(String)request.getParameter("resultFailure");%>


<div class="card-header page-top"> 
	<div class="row">
	 	<div class="col-md-3"><h5><% if(currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CM") || currentEmpStatus.equalsIgnoreCase("DH") || currentEmpStatus.equalsIgnoreCase("SE")){ %> Recommend
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%}else{ %> Recommend<%} %> List</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="MainDashBoard.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	              <li class="breadcrumb-item active" aria-current="page">
	              <% if(currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CM") || currentEmpStatus.equalsIgnoreCase("DH") || currentEmpStatus.equalsIgnoreCase("SE")){ %> Recommend
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
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
		    <label for="tab-pending" style="margin-bottom:0px !important;">Fund <% if(currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CM") || currentEmpStatus.equalsIgnoreCase("DH") || currentEmpStatus.equalsIgnoreCase("SE")){ %> Recommend
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CS")){ %> Review
									         <%}else{ %> NA <%} %> Pending</label>
		    <input type="radio" name="tabs" id="tab-approved">
		    <label for="tab-approved" style="margin-bottom:0px !important;">Fund <% if(currentEmpStatus.equalsIgnoreCase("CC")){ %> Approved 
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CM") || currentEmpStatus.equalsIgnoreCase("DH") || currentEmpStatus.equalsIgnoreCase("SE")){ %> Recommended
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CS")){ %> Noted
									         <%}else{ %> NA <%} %></label>
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
			                     <td align="center">
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
			                           String rc5Status = obj[38] != null ? obj[38].toString().toUpperCase() : "NA";
			                           String rc6Status = obj[40] != null ? obj[40].toString().toUpperCase() : "NA";
			                           String apprStatus = obj[39] != null ? obj[39].toString().toUpperCase() : "NA";
			                           
			                           boolean allNA = rc1Status.equals("NA") && rc2Status.equals("NA") && rc3Status.equals("NA") && rc4Status.equals("NA");
			                           boolean hasN = rc1Status.equalsIgnoreCase("N") || rc2Status.equalsIgnoreCase("N") || rc3Status.equalsIgnoreCase("N") || rc4Status.equalsIgnoreCase("N");
			                           
			                           boolean isDHApproved = rc6Status.equalsIgnoreCase("Y");
			                           boolean isCSApproved = rc5Status.equalsIgnoreCase("Y");
			                           boolean isCCApproved = apprStatus.equalsIgnoreCase("Y");
			                           
			                           System.out.println("allNA****"+allNA);
			                           System.out.println("hasN****"+hasN);
			                           System.out.println("isDHApproved****"+isDHApproved);
			                           System.out.println("isCSApproved****"+isCSApproved);
			                           System.out.println("isCCApproved****"+isCCApproved);
			                           
			                            %>
			                           
			                 		<%
									   String action = "";
									   String tooltip = "";
									   boolean showPending = false;
									   
									   switch(currentEmpStatus.toUpperCase()) {
									       case "DH":
									    	   showPending = isDHApproved;
									           action = "Recommend";
									           tooltip = "Preview & Recommend";
									           break;
									       case "CM":
									       case "SE":
									           showPending = !isDHApproved;
									           action = "Recommend";
									           tooltip = "Preview & Recommend";
									           break;
									       case "CS":
									           showPending = !(isDHApproved && !hasN);
									           action = "Noting";
									           tooltip = "Preview & Note";
									           break;
									       case "CC":
									           showPending = !(isDHApproved && isCSApproved);
									           action = "Approval";
									           tooltip = "Preview & Approve";
									           break;
									   }
									%>
									
									<%System.out.println("showPending****"+showPending); %>
									<%System.out.println("currentEmpStatus****"+currentEmpStatus); %>
									
									<% if(showPending) { %>
									   <span style="color:#783d00; border-radius:10px; padding:2px 9px; background:#ffe8cc; font-size:11px; font-weight:800;">
									       Recommendation Pending
									   </span>
									<% } else if(!action.isEmpty()) { %>
									   <form action="#" method="POST" style="display:inline">
									       <button type="submit"
									               data-tooltip="<%= tooltip %>"
									               data-position="top"
									               class="btn btn-sm icon-btn tooltip-container"
									               style="padding:6px;border:1px solid #05814d;background:#d3ffe5;"
									               formaction="FundApprovalPreview.htm">
									           <%= action %> &nbsp;&#10097;&#10097;
									       </button>
									       <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
									       <input type="hidden" name="FundApprovalIdSubmit" value="<%= obj[0] %>">
									   </form>
									<% } %>
												                 		
			                          
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
			                     <td align="center"> 
			                     
			                         <% if(currentEmpStatus.equalsIgnoreCase("DH")){ %> 

									   <button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="" 
								            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
								            <span style="color: #2b8c03;padding: 2%;">Approved</span> 
								            <i class="fa-solid fa-arrow-up-right-from-square" style="color: #2b8c03;padding-left: 1%" ></i>											
								       </button>
								       
								       <% } else if(currentEmpStatus.equalsIgnoreCase("CC")){ %> 

									    <button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="" 
								            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
								            <span style="color: #2b8c03;padding: 2%;">Approved</span> 
								            <i class="fa-solid fa-arrow-up-right-from-square" style="color: #2b8c03;padding-left: 1%" ></i>											
								       </button>
											        
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CM")){ %> 

										<button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="" 
								            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
								            <span style="color: #2b8c03;padding: 2%;">Recommended</span> 
								            <i class="fa-solid fa-arrow-up-right-from-square" style="color: #2b8c03;" ></i>											
								       </button>
								       
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CS")){ %>
									         
									         <button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="" 
									            onclick="openApprovalStatusAjax('<%=obj[0]%>')">
									            <span style="color: #2b8c03;padding: 2%;">Reviewed</span> 
									            <i class="fa-solid fa-arrow-up-right-from-square" style="color: #2b8c03;" ></i>											
								       </button>
									         <%}else{ %> Recommended <%} %></td>
			                    
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
  <script src="webresources/js/RpbFundStatus.js"></script>
</html>