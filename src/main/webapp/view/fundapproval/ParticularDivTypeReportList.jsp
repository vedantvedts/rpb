<%@page import="com.vts.rpb.utils.AmountConversion"%>
<%@page import="com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,com.vts.*,java.text.SimpleDateFormat"%>
   
<%@page import="java.text.DecimalFormat"%>
<%@ page import="java.util.List"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<jsp:include page="../static/header.jsp"></jsp:include>
<title>Fund Requisition List</title>
<style>

/* .modal-lg {
    max-width: 50% !important;
} */

.select2-selection
{
  text-align: left;
}

.select2-results__option,.select2-selection__rendered
{
	font-weight: 600 !important;
}

.HeadingSpan
{
	font-weight: 600;
	color:rgb(9, 9, 87);
	font-size: 21px;
	font-family: math;
	text-shadow: 0px 0px 2px #2dffc8;
	text-decoration: underline;
}

input[name="ItemNomenclature"]::placeholder {
  color: rgb(9, 9, 87) !important;
  font-weight: 600 !important;
}

.custom-placeholder
{
   font-weight: 600;
   text-align: right;
   margin:5px;
   color:blue !important;
}

    .checkbox-wrapper-12 {
    position: relative;
    margin-top: -26px;
    margin-right: 13px
  }

  .checkbox-wrapper-12 > svg {
    position: absolute;
    top: -130%;
    left: -170%;
    width: 110px;
    pointer-events: none;
  }

  .checkbox-wrapper-12 * {
    box-sizing: border-box;
  }

  .checkbox-wrapper-12 input[type="checkbox"] {
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    -webkit-tap-highlight-color: transparent;
    cursor: pointer;
    margin: 0;
  }

  .checkbox-wrapper-12 input[type="checkbox"]:focus {
    outline: 0;
  }

  .checkbox-wrapper-12 .cbx {
    top: calc(50vh - 12px);
    left: calc(50vw - 12px);
  }

  .checkbox-wrapper-12 .cbx input {
    position: absolute;
    width: 24px;
    height: 24px;
    border: 2px solid #bfbfc0;
    /* border-radius: 50%; */
  }

  .checkbox-wrapper-12 .cbx label {
    width: 24px;
    height: 24px;
    background: none;
    position: absolute;
    transform: translate3d(0, 0, 0);
    pointer-events: none;
  }

  .checkbox-wrapper-12 .cbx svg {
    position: absolute;
    top: 1px;
    /* left: 19px; */
    margin-left: 8%;
    z-index: 1;
    pointer-events: none;
  }

  .checkbox-wrapper-12 .cbx svg path {
    stroke: #fff;
    stroke-width: 3;
    stroke-linecap: round;
    stroke-linejoin: round;
    stroke-dasharray: 19;
    stroke-dashoffset: 19;
    transition: stroke-dashoffset 0.3s ease;
    transition-delay: 0.2s;
  }

  .checkbox-wrapper-12 .cbx input:checked + label {
    animation: splash-12 0.6s ease forwards;
  }

  .checkbox-wrapper-12 .cbx input:checked + label + svg path {
    stroke-dashoffset: 0;
  }

  .checkbox-wrapper-12 .cbx input:not(:checked) + label {
    animation: unsplash-12 0.6s ease forwards;
  }

  .checkbox-wrapper-12 .cbx input:not(:checked) + label + svg path {
    stroke-dashoffset: 19;
  }
  
  #selectall:checked
  {
 	 box-shadow: 0px 0px 7px green;
  }
  
  #selectall:not(:checked) 
  {
  	box-shadow: 0px 0px 5px red; 
  }
  
  .selectallApproval:checked
  {
 	 box-shadow: 0px 0px 7px green;
  }
  
  .selectallApproval:not(:checked) 
  {
  	box-shadow: 0px 0px 5px red; 
  }
  
  @keyframes splash-12 {
    40% {
      border-radius: 50%;
      background: green;
      box-shadow: 0 -18px 0 -8px green, 16px -8px 0 -8px green, 16px 8px 0 -8px green, 0 18px 0 -8px green, -16px 8px 0 -8px green, -16px -8px 0 -8px green;
    }

    100% {
      border-radius: 0;
      background: green;
      box-shadow: 0 -36px 0 -10px transparent, 32px -16px 0 -10px transparent, 32px 16px 0 -10px transparent, 0 36px 0 -10px transparent, -32px 16px 0 -10px transparent, -32px -16px 0 -10px transparent;
    }
  }

  @keyframes unsplash-12 {
    40% {
      border-radius: 50%;
      background: red;
      box-shadow: 0 -18px 0 -8px red, 16px -8px 0 -8px red, 16px 8px 0 -8px red, 0 18px 0 -8px red, -16px 8px 0 -8px red, -16px -8px 0 -8px red;
    }

    100% {
      border-radius: 0;
      background: none;
      box-shadow: 0 -36px 0 -10px transparent, 32px -16px 0 -10px transparent, 32px 16px 0 -10px transparent, 0 36px 0 -10px transparent, -32px 16px 0 -10px transparent, -32px -16px 0 -10px transparent;
    }
  }
  
  .table thead tr td, .table tbody tr td {
    padding-top: 4px !important;
    padding-bottom: 4px !important;
}

.greek-style {
            font-family: 'Times New Roman', Times, serif;
            font-weight: bold;
            font-style: italic;
            color: blue;
            cursor: pointer;
        }
        


</style>
 <style>
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
        
        .modal-lg {
			   		 max-width: 90% !important;
			 }
			 
	 		 .custom-width-modal {
			  width: 70% !important;
			  max-width: 100%;
			}
			
			  .highlight-box {
					    background-color: #fff7d1; 
					    border: 2px solid #1890ff; /* Blue border */
					    padding: 10px;
					    border-radius: 5px;
					    margin-top: 8px;
					}
    </style>
    
    
    <style type="text/css">
    
    
   .div-tooltip-container ul {
  padding: 5px !important;
}

</style>

</head>
<body>
		<%
		List<Object[]> requisitionList=(List<Object[]>)request.getAttribute("attachList"); 
		if(requisitionList!=null){
			requisitionList.stream().forEach(a->System.err.println(Arrays.toString(a)));
			System.err.print("size-"+requisitionList.size());
		}
		System.err.print("requisitionList JSP-"+requisitionList.size());
		String empId=((Long)session.getAttribute("EmployeeId")).toString();
		String loginType=(String)session.getAttribute("LoginType");
		String currentFinYear=(String)request.getAttribute("CurrentFinYear");
		
		String fromYear=(String)request.getAttribute("FromYear");
		String toYear=(String)request.getAttribute("ToYear");
		String ExistingbudgetHeadId=(String)request.getAttribute("ExistingbudgetHeadId");
		String ExistingbudgetItemId=(String)request.getAttribute("ExistingbudgetItemId");
		String ExistingfromCost=(String)request.getAttribute("ExistingfromCost");
		String ExistingtoCost=(String)request.getAttribute("ExistingtoCost");
		String Existingstatus=(String)request.getAttribute("Existingstatus");
		Long divisionId=(Long)request.getAttribute("divisionId");
		String estimateType=(String)request.getAttribute("estimateType");

		Object DivName = "", DivCode = "";
		String EstimateTypeFromList = "";
		String financialYear = "";

		if (requisitionList != null && !requisitionList.isEmpty()) {
		    Object[] firstItem = requisitionList.get(0);
		    DivName = firstItem[2] != null ? firstItem[2] : "";
		    DivCode = firstItem[27] != null ? firstItem[27] : "";
		    EstimateTypeFromList = firstItem[3] != null ? String.valueOf(firstItem[3]) : "";
		    financialYear = firstItem[6] != null ? String.valueOf(firstItem[6]) : "";
		}
		%>
			

<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-5"><h5> Fund Report</h5></div>
	      <!-- <div class="col-md-9">
	    	 <ol class="breadcrumb ">
	    	 <li class="breadcrumb-item ml-auto"><a	href="MainDashBoard.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	          <li class="breadcrumb-item active " aria-current="page">Fund Report</li>
             </ol>
           </div> -->
         </div>
       </div> 
     
  	    
  	    
		
       <div class="page card dashboard-card">
            
    <form action="estimateTypeParticularDivList.htm" method="POST" id="RequistionForm" autocomplete="off">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input id="budgetHeadIdHidden" type="hidden" <%if(ExistingbudgetHeadId != null){ %>value="<%=ExistingbudgetHeadId%>" <%} %>>
        <input id="budgetItemIdHidden" type="hidden" <%if(ExistingbudgetItemId != null ){ %>value="<%=ExistingbudgetItemId%>" <%} %>>
 		<input type="hidden" name="divisionId" value="<%= divisionId %>">
 		<input type="hidden" name="estimateType" value="<%= estimateType %>">
 		<input type="hidden" name="fromYear" value="<%= fromYear %>">
 		<input type="hidden" name="toYear" value="<%= toYear %>">
 <div class="flex-container" style="width: 100%;">
        <!-- Division + From/To Year Row -->
        <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 8px; width: 100%;">
            <!-- Division -->
            <div style="display: flex; align-items: center;">

            <!-- Approved Dropdown -->

        </div>

        <!-- Budget Details -->
        <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; margin-top: 20px;">
            <!-- Budget -->
           <div style="align-items: center;align-content: space-evenly;">
			    <label for="REstimateType" style="font-weight: bold; margin-left: 5px;">Approved:</label>&nbsp;&nbsp;
					<span style="border: solid 0.1px;padding: 2px 4px;border-radius: 6px;border-color: darkgray;background-color: white;">
					
			    <input type="radio" id="approvalStatus"
			        <% if(Existingstatus == null || "A".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
			        name="approvalStatus" value="A" onchange="this.form.submit();" />
			    &nbsp;<span style="font-weight: 600">Yes</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			
			    <input type="radio" id="approvalStatus"
			        <% if("N".equalsIgnoreCase(Existingstatus) || "F".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
			        name="approvalStatus" value="N" onchange="this.form.submit();" />
			    &nbsp;<span style="font-weight: 600">No</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    
			    <input type="radio" id="approvalStatus"
			        <% if("NA".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
			        name="approvalStatus" value="NA" onchange="this.form.submit();" title="Not Applicable" />
			    &nbsp;<span style="font-weight: 600">Both</span>
			    
			    </span>
			</div>
            &nbsp;
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">Budget:</label>
                <select class="form-control select2" id="selProject" name="selProject"
                    data-live-search="true" onchange="this.form.submit();" required
                    style="font-size: 12px; min-width: 200px;">
                    <option value="0#GEN#General" hidden>GEN (General)</option>
                </select>
            </div>

            <!-- Budget Head -->
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">Budget Head:</label>
                <select id="selbudgethead" name="budgetHeadId" class="form-control select2"
                    data-live-search="true" onchange="this.form.submit();" required style="font-size: 12px; min-width: 200px;">
                    <option value="">Select BudgetHead</option>
                </select>
            </div>

 <%if(ExistingbudgetHeadId != null && Long.valueOf(ExistingbudgetHeadId)!=0 ){ %>
            <!-- Budget Item -->
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">Budget Item:</label>
                <select id="selbudgetitem" name="budgetItemId" class="form-control select2"
                    data-live-search="true" onchange="this.form.submit();" required
                    style="font-size: 12px; min-width: 200px;">
                    <option value="">Select BudgetItem</option>
                </select>
            </div>
            <%} %>

            <!-- Cost Range -->
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">Cost Range:</label>
                <input type="text" name="FromCost" id="FromCost" value="<%if(ExistingfromCost!=null ){ %> <%=ExistingfromCost.trim() %> <%} else {%>0<%} %>"  required
                    class="form-control" style="width: 100px; background-color: white;padding-left: 0; padding-right: 0; text-align: center;"
                    onblur="if (validateCost()) document.getElementById('RequistionForm').submit();" oninput="this.value = this.value.replace(/[^0-9]/g, '')" />
                <span style="margin: 0 10px; font-weight: bold;">--</span>
                <input type="text" name="ToCost" id="ToCost" value="<%if(ExistingtoCost!=null ){ %> <%=ExistingtoCost.trim() %> <%} else {%>1000000<%} %>" required
                    class="form-control" style="width: 100px; background-color: white;padding-left: 0; padding-right: 0; text-align: center;"
                    onblur="if (validateCost()) document.getElementById('RequistionForm').submit();" oninput="this.value = this.value.replace(/[^0-9]/g, '')" />
            </div>
        </div>
</div>
        <input type="hidden" id="projectIdHidden" value="0#GEN#General" />
    </form>
</div> <!-- Flex-container ends -->


				 

<div style="width: 100%; display: flex; align-items: center; justify-content: space-between; margin-top: 10px;">
  
  <!-- Center-aligned span -->
  <div style="flex: 1; text-align: center;background-color: #ffffff;margin-left: 24%; margin-right: 22%;padding: 8px;">
  <span style="font-weight: 600;color:#6a1616;">Division : </span><span style="font-weight: 600;color:#160ab7;">&nbsp;<%= DivName %> <%= !DivCode.toString().isEmpty() ? "(" + DivCode + ")" : "" %></span>
&nbsp;&nbsp;&nbsp;
    &nbsp;&nbsp; <span style="font-weight: 600;color:#6a1616;">
      <% if("R".equalsIgnoreCase(EstimateTypeFromList)) { %>
         RE Year :
      <% } else if("F".equalsIgnoreCase(EstimateTypeFromList)) { %>
         FBE Year :
      <% } else {%>--
      <%} %>
    </span>
    <span style="font-weight: 600;color:#160ab7;"><%=financialYear%> </span>
  </div>

  <!-- Right-aligned buttons -->
  <div style="flex-shrink: 0;">
    <button class="bg-transparent" type="button"
        style="border: none; background-color: #f9f7f7; padding: 0; margin: 0; padding-right: 9px !important;"
        onclick="submitPrintAction('pdf')"
        data-toggle="tooltip" data-placement="top" title="PDF Download">
        <i class="fas fa-file-pdf" style="color: red; font-size: 1.73em;" aria-hidden="true" id="pdf"></i>
    </button>
    &nbsp;&nbsp;
    <button class="bg-transparent" type="button"
        style="border: none; background-color: white; margin-left: 10px;"
        onclick="submitPrintAction('Excel')"
        data-toggle="tooltip" data-placement="top" title="Excel Download">
        <i class="fas fa-file-excel" style="color: green; font-size: 1.73em;" aria-hidden="true" id="Excel"></i>
    </button>
  </div>

</div>


				 	
					<form action="#" id="RequistionFormAction" autocomplete="off"> 
				        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				        <!-- <input type="hidden" name="RedirectVal" value="RequisitionList"/> -->
				        <input type="hidden" name="RedirectVal" value="B"/>   <!-- B- Redirect from Budget List -->
						   
						
						<div class="table-responsive" style="margin-top: 0.5rem;font-weight: 600;">
					        <table class="table table-bordered table-hover table-striped table-condensed" id="RequisitionList">
					            <thead>
					                <tr>
					                    <th>SN</th>
					                    <th>Budget Head</th>
					                    <th>Initiating Officer</th>
					                    <th>Item Nomenclature</th>
					                    <th class="text-nowrap">Estimated Cost</th>
					                    <th>Justification</th>
					                    <th>Enclosures</th>
					                    <th>Status</th>
					                    <th>Remarks</th>
					                </tr>
					            </thead>
					            <tbody>
					            
					            <% int sn=1; 
					            BigDecimal grandTotal = new BigDecimal(0);
					            BigDecimal subTotal = new BigDecimal(0);
					            
					            if(requisitionList!=null && requisitionList.size()>0 && !requisitionList.isEmpty()){ %>
					            
					            <%for(Object[] data:requisitionList){ 
					            	grandTotal=grandTotal.add(new BigDecimal(data[20].toString()));
					            	String fundStatus=data[25]==null ? "NaN" : data[25].toString();
					            %>
					            
					            	 <tr>
				                   			<td align="center"><%=sn++ %></td>
				                   			<td align="center" id="budgetHead"><%if(data[9]!=null){ %> <%=data[9] %><%}else{ %> - <%} %></td>
				                   			<td align="left" id="Officer"><%if(data[22]!=null){ %> <%=data[22] %><%if(data[23]!=null){ %>, <%=data[23] %> <%} %> <%}else{ %> - <%} %></td>
				                   			<td id="Item"><%if(data[18]!=null){ %> <%=data[18] %><%}else{ %> - <%} %></td>
				                   			<td align="right"><%if(data[20]!=null){ %> <%=AmountConversion.amountConvertion(data[20], "R") %><%}else{ %> - <%} %></td>
				                   			<td><%if(data[19]!=null){ %> <%=data[19] %><%}else{ %> - <%} %></td>
				                   			<td align="center"><img onclick="openAttachmentModal('<%=data[0] %>')" data-tooltip="Attachment" data-position="top" data-toggle="tooltip" class="btn-sm tooltip-container" src="view/images/attached-file.png" width="45" height="43" style="cursor:pointer; background: transparent;padding: 1px;"></td>
				                   			<td>
				                   			
				                   			 
				                   					<button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="click to view status" 
												            onclick="openApprovalStatusAjax('<%=data[0]%>')">
												            <span  <%if("A".equalsIgnoreCase(fundStatus)) {%> style="color: green;" <%} else if("N".equalsIgnoreCase(fundStatus)){ %> style="color: #8c2303;" <%} else if("F".equalsIgnoreCase(fundStatus)){ %> style="color: blue;"  <%} else if("R".equalsIgnoreCase(fundStatus)){ %>  style="color: red;" <%} %>>
												            <%if("A".equalsIgnoreCase(fundStatus)) {%> Approved <%} else if("N".equalsIgnoreCase(fundStatus)){ %> Pending  <%} else if("F".equalsIgnoreCase(fundStatus)){ %> Forwarded <%} else if("R".equalsIgnoreCase(fundStatus)){ %> Returned <%} %>
												            </span> 
												            <i class="fa-solid fa-arrow-up-right-from-square" <%if("A".equalsIgnoreCase(fundStatus)) {%> style="float: right;color: green;" <%} else if("N".equalsIgnoreCase(fundStatus)){ %> style="float: right;color: #8c2303;" <%} else if("F".equalsIgnoreCase(fundStatus)){ %> style="float: right;color: blue;"  <%} else if("R".equalsIgnoreCase(fundStatus)){ %>  style="float: right;color: red;" <%} %>></i>											
											       </button>
											       
									       </td>
				                   			<td align="center">-</td>
			                      	 
					           		  </tr>
					            <%} %>
					            
					            <%-- <tr style="font-weight:bold; background-color: #ffd589;">
							            <td colspan="6" align="right">Grand Total</td>
							            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(grandTotal, "R") %></td>
							            <td colspan="2"></td>
						   		     </tr> --%>
					            <%}else{ %>
					            
					             <tr style="height: 9rem;">
					                        <td colspan="9" style="vertical-align: middle;">
					                            <div class="text-danger" style="text-align:center">
					                                <h6 style="font-weight: 600;">No Requisition Found</h6>
					                            </div>
					                        </td>
					                    </tr>
					            
					            <%} %>
				                  
					            </tbody>
					           <%if(requisitionList!=null && requisitionList.size()!=0){ %>
					               <tfoot>
					            	
			                        <tr style="font-weight:bold; background-color: #ffd589;">
							            <td colspan="4" align="right">Grand Total</td>
							            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(grandTotal, "R") %></td>
							            <td colspan="4"></td>
						   		     </tr>
					            </tfoot> 
					            <%} %>
					        </table>
					    </div>
						
					  </form>

				
				<!-- Attachment Modal -->
<!-- Fullscreen Attachment Modal -->
<div class="modal fade AttachmentModal" tabindex="-1" role="dialog" style="padding: 0;">
  <div class="modal-dialog modal-lg Exp" role="document">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header bg-dark text-white">
        <h4 class="modal-title" style="font-family:'Times New Roman'; font-weight: 600;">Attachment Details</h4>
        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" style="font-size: 25px;">&times;</span>
        </button>
      </div>

      <!-- Modal Body -->
<div class="modal-body">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
  <input type="hidden" name="TaDaIdAjax" id="TaDaIdAjax" value="">

  <div class="row">
    <!-- Left: Attachments Table -->
    <div class="col-md-6">
      <h5 class="text-secondary" style="font-weight: 600;">Attachments</h5>
      <table class="table table-bordered table-striped mt-2" id="AttachmentModalTable">
        <thead class="thead-dark">
          <tr>
            <th style="width: 60%;">Attachment Name</th>
            <th style="width: 40%; text-align: center;">Actions</th>
          </tr>
        </thead>
        <tbody id="eAttachmentModalBody" style="font-weight: 400;"></tbody>
      </table>
    </div>

    <!-- Right: File Preview Section -->
    <div class="col-md-6" id="previewSection" style="display: none;">
      <h5 class="text-primary" style="font-weight: 600;">Preview:</h5>
      <iframe id="filePreviewIframe" style="width: 100%; height: 600px; border: 1px solid #ccc;"></iframe>
    </div>
  </div>
</div>


    </div>
  </div>
</div>

<div class="modal fade" id="ApprovalStatusModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
 <div class="modal-dialog modal-lg custom-width-modal" role="document">
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
<script src="webresources/js/RpbFundStatus.js"></script>
<script>

/*  $('#selProject').change(function(event) {
	 
						var project= $("select#selProject").val();  
						
						$(".SanctionDetails,.GeneralDetails,#SanctionandFBEDetails").hide();
						<!------------------Project Id not Equal to Zero [Project]-------------------->
						
						if(project!=null  && project!='Select Project')
						{
							$.get('GetBudgetHeadList.htm', {
								ProjectDetails : project
							}, function(responseJson) 
							{
								$('#selbudgethead').find('option').remove();
								$("#selbudgethead").append("<option disabled value=''>Select Budget Head </option>"); 
									$("#selbudgethead").append("<option  value='0'>All</option>");
									var result = JSON.parse(responseJson);
									
									$.each(result, function(key, value) {
										$("#selbudgethead").append("<option value="+value.budgetHeadId+">"+ value.budgetHeaddescription + "</option>");
									});
									SetBudgetItem(''); 
							});
                       }
						
					}); */
					
					$(document).ready(function(event) {
						
								var $project= $("#projectIdHidden").val();
								//projectIDHiden
								
								var $budgetHeadId = $("#budgetHeadIdHidden").val();
								<!------------------Project Id not Equal to Zero [Project]-------------------->
								//alert($budgetHeadId)
								if($project!=null)
									{
										var $projectId=$project!=null && $project.split("#")!=null && $project.split("#").length>0 ? $project.split("#")[0] : '0';
										$.get('GetBudgetHeadList.htm', {
											ProjectDetails : $project
										}, function(result) {
											$('#selbudgethead').find('option').remove();
											var result = JSON.parse(result);
											var html1='';
											 if(result.length >1){
												$("#selbudgethead").append("<option  value='0'>All</option>");
											}  	
											$.each(result, function(key, value) {
												
												 if(value.budgetHeadId== $budgetHeadId)
												 {
													html1='<option value="'+value.budgetHeadId+'" selected="selected">'+value.budgetHeaddescription+'</option>';
												 }
												 else
													{
														html1="<option value="+value.budgetHeadId+">"+  value.budgetHeaddescription+ "</option>";
													}
												 $("#selbudgethead").append(html1);
											});
											var budgetItemId = $("#budgetItemIdHidden").val();
										    SetBudgetItem(budgetItemId);
										    
										    if($projectId!=0)
										    {
												$("#SanctionBalance").show();
											}
										    else if($projectId==0)
											{
												$("#SanctionBalance").hide();
											}
										});
									}
									});
				
<!------------------Select Budget Item using Ajax-------------------->

        $('#selbudgethead').change( function(event) {
			SetBudgetItem('');  //1st Parameter BudgetItemId(FBE), N - No FBE serila No Type
		});

        function SetBudgetItem(budgetItemId) {
            // Set BudgetItem
            var project = $("select#selProject").val(); 
            var budgetHeadId = $("select#selbudgethead").val();
            var HiddenbudgetHeadId = $("#budgetHeadIdHidden").val();
            
            //calling controller using ajax for project Drop Down based on projectId
            $.get('SelectbudgetItem.htm', {
                projectid: project,
                budgetHeadId: budgetHeadId
            }, function(responseJson) {
                $('#selbudgetitem').find('option').remove();
                $("#selbudgetitem").append("<option disabled value=''>Select Budget Item</option>");
                
                var result = JSON.parse(responseJson);
                
                // Add "All" option if HiddenbudgetHeadId is 0 or if there are multiple items
                if (HiddenbudgetHeadId == 0 || result.length > 1) {
                    $("#selbudgetitem").append("<option value='0'>All</option>");
                }
                
                $.each(result, function(key, value) {
                    if (budgetItemId != null && budgetItemId == value.budgetItemId) {
                        $("#selbudgetitem").append("<option selected value=" + value.budgetItemId + ">" + 
                            value.headOfAccounts + " [" + value.subHead + "]</option>");
                    } else {
                        $("#selbudgetitem").append("<option value=" + value.budgetItemId + ">" + 
                            value.headOfAccounts + " [" + value.subHead + "]</option>");
                    }
                });
            });
        }
		
		
</script>
<script type="text/javascript">

function masterFlowDetails(StatusCode)
{
	var idAttribute="";
	if(StatusCode!=null)
		{
			if(StatusCode=='RO1 RECOMMENDED')
	   		{
	    		$(".RPBMember1").show();
	    		idAttribute='#RPBMemberDetails1';
	   		}
			if(StatusCode=='RO2 RECOMMENDED')
	   		{
	    		$(".RPBMember2").show();
	    		idAttribute='#RPBMemberDetails2';
	   		}
			if(StatusCode=='RO3 RECOMMENDED')
	   		{
	    		$(".RPBMember3").show();
	    		idAttribute='#RPBMemberDetails3';
	   		}
			if(StatusCode=='SE RECOMMENDED')
	   		{
	    		$(".SubjectExpert").show();
	    		idAttribute='#SubjectExpertDetails';
	   		}
			if(StatusCode=='RPB MEMBER SECRETARY APPROVED')
	   		{
	    		$(".RPBMemberSecretary").show();
	    		idAttribute='#RPBMemberSecretaryDetails';
	   		}
			if(StatusCode=='CHAIRMAN APPROVED')
	   		{
	    		$(".chairman").show();
	    		idAttribute='#chairmanDetails';
	   		}
		}
	return idAttribute;
}

function ApprovalFlowForward()
{
	var estimatedCost=$(".EstimatedCostDetails").text();
	$.ajax({
        url: 'GetMasterFlowDetails.htm',  
        method: 'GET', 
        data: { estimatedCost: estimatedCost },  
        success: function(response) {
            var data = JSON.parse(response);
            $.each(data, function(key, value) 
			{
            	 var idAttribute=masterFlowDetails(value[2]);
            	
            	 $(idAttribute).empty().append('<option value="0">Select Employee</option>');
            	 $.each(allEmployeeList, function(key, value) 
   				 {
            		 $(idAttribute).append('<option value="'+value[0]+'">'+ value[3] + ', '+ value[5] +'</option>');
   				 });
            	
			});
            
        }
    }); 
	
	var form=$("#FundForwardForm");
	if(form)
	{
		form.submit();
	}
}

</script>



<script type="text/javascript">

	var allEmployeeList = null;
	$.ajax({
	    url: 'GetEmployeeDetails.htm',  
	    method: 'GET', 
	    success: function(response) {
	        var data = JSON.parse(response);
	        allEmployeeList = data;
	    }
	});

function openForwardModal(fundRequestId,estimatedCost,estimatedType,ReFbeYear,budgetHeadDescription,HeadOfAccounts,
		CodeHead,Itemnomenclature,justification,empName,designation)
{
	refreshModal('.ItemForwardModal');
	$(".RPBMember1,.RPBMember2,.RPBMember3,.SubjectExpert").hide();
	$(".ItemForwardModal").modal('show');
	
	$(".BudgetDetails").html("GEN (General)");
	$(".BudgetHeadDetails").html(budgetHeadDescription);
	$(".budgetItemDetails").html(HeadOfAccounts+' ('+ CodeHead +')');
	$(".EstimatedCostDetails").html(estimatedCost);
	$(".ItemNomenclatureDetails").html(Itemnomenclature);
	$(".JustificationDetails").html(justification);
	$(".MainEstimateType").html(estimatedType!=null && estimatedType=='R' ? 'RE' : 'FBE');
	$(".ReFbeYearModal").html('(' +ReFbeYear+ ')');
	
	$("#initiating_officer_display").val(empName +', '+designation);
	$("#FundRequestIdForward").val(fundRequestId);
	$("#EstimatedCostForward").val(estimatedCost);
	
	$.ajax({
        url: 'GetMasterFlowDetails.htm',  
        method: 'GET', 
        data: { estimatedCost: estimatedCost },  
        success: function(response) {
            var data = JSON.parse(response);
            console.log('data****'+data);
            $.each(data, function(key, value) 
			{
            	var idAttribute='';
            	if(value[2]!=null)
           		{
            		if(value[2]=='RO1 RECOMMENDED')
               		{
                		$(".RPBMember1").show();
                		idAttribute='#RPBMemberDetails1';
               		}
            		if(value[2]=='RO2 RECOMMENDED')
               		{
                		$(".RPBMember2").show();
                		idAttribute='#RPBMemberDetails2';
               		}
            		if(value[2]=='RO3 RECOMMENDED')
               		{
                		$(".RPBMember3").show();
                		idAttribute='#RPBMemberDetails3';
               		}
            		if(value[2]=='SE RECOMMENDED')
               		{
                		$(".SubjectExpert").show();
                		idAttribute='#SubjectExpertDetails';
               		}
            		if(value[2]=='RPB MEMBER SECRETARY APPROVED')
               		{
                		$(".RPBMemberSecretary").show();
                		idAttribute='#RPBMemberSecretaryDetails';
               		}
            		if(value[2]=='CHAIRMAN APPROVED')
               		{
                		$(".chairman").show();
                		idAttribute='#chairmanDetails';
               		}
           		}
            	
            	 $(idAttribute).empty().append('<option value="">Select Employee</option>');
            	 $.each(allEmployeeList, function(key, value) 
   				 {
            		 $(idAttribute).append('<option value="'+value[0]+'">'+ value[3] + ', '+ value[5] +'</option>');
   				 });
            	 $("#FlowMasterIdForward").val(value[0]);
            	
			});
            
        }
    }); 
	
}

const dropdownSelector = "#RPBMemberDetails1, #RPBMemberDetails2, #RPBMemberDetails3, #SubjectExpertDetails, #RPBMemberSecretaryDetails, #chairmanDetails";

$(document).on("change", dropdownSelector, function () {
    
	const selectedValues = [];
    $(dropdownSelector).each(function () {
        const val = $(this).val();
        if (val) {
            selectedValues.push(val);
        }
    });

    $(dropdownSelector).each(function () {
        const currentDropdown = $(this);
        const currentVal = currentDropdown.val();

        currentDropdown.find('option').each(function () {
            const option = $(this);
            const optionVal = option.val();

            if (optionVal === currentVal || optionVal === "") {
                option.prop("disabled", false).show();
            } else if (selectedValues.includes(optionVal)) {
                option.prop("disabled", true).hide();  // hide selected values in other dropdowns
            } else {
                option.prop("disabled", false).show();
            }
        });
    });
});


</script>

<script type="text/javascript">
function refreshModal(modalId) {
    const $modal = $(modalId);

    // Reset form(s) inside the modal
    $modal.find('form').each(function () {
        this.reset();
    });

    // Reset Bootstrap carousel if present
    $modal.find('.carousel').each(function () {
        $(this).carousel(0);
    });

    // Reset Select2 dropdowns if used
    $modal.find('.select2').val('').trigger('change');
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
  
  <script type="text/javascript">
  
  <% if(requisitionList!=null && requisitionList.size()>0){ %>
  $("#RequisitionList").DataTable({
		"lengthMenu": [[10, 25, 50, 75, 100,'-1'],[10, 25, 50, 75, 100,"All"]],
	 	 "pagingType": "simple",
	 	 "pageLength": 10,
	 	 "ordering": true
	});
  <%}%>
  
  $('#FBEstimateType,#REstimateType').change(function(event) {
		var form=$("#RequistionForm");
			if(form)
			{
				form.submit();
			}
		});
  
  </script>
  
  <script type="text/javascript">
  
  $(document).ready(function(){
	  var estimateType=$("#estimateType").val();
	  if(estimateType=='F')
	  	{
	  		$("#FBEstimateType").prop("checked", true);
	  	}
	  else if(estimateType=='R')
	  	{
	  		$("#REstimateType").prop("checked", true);
	  	}
  });
  
  function openAttachmentModal(fundApprovalId) {
	  $.ajax({
	    url: 'GetFundRequestAttachmentAjax.htm',
	    method: 'GET',
	    data: { fundApprovalId: fundApprovalId },
	    success: function(data) {
	      var body = $("#eAttachmentModalBody");
	      body.empty();

	      if (data.length === 0) {
	        body.append("<tr><td colspan='2' style='text-align: center; color: red;font-weight:700'>No attachment found</td></tr>");
	      } else {
	        $.each(data, function(index, attach) {
	          var viewUrl = "PreviewAttachment.htm?attachid=" + attach.fundApprovalAttachId;
	          var downloadUrl = "FundRequestAttachDownload.htm?attachid=" + attach.fundApprovalAttachId;

	          var row = "<tr>" +
	            "<td style='text-align: center;font-weight:700'>" + attach.fileName + "</td>" +
	            "<td style='text-align: center;'>" +
	            "<button class='btn fa fa-eye text-primary' title='preview - "+attach.fileName+" Attachment' onclick=\"previewAttachment('" + viewUrl + "')\"></button>" +
	            "</td>" +
	            "</tr>";
	          body.append(row);
	        });
	      }

	      // Hide preview on modal open
	      $("#previewSection").hide();
	      $("#filePreviewIframe").attr("src", "");

	      $(".AttachmentModal").modal("show");
	    },
	    error: function() {
	      alert("Failed to load attachments.");
	    }
	  });
	}

	function previewAttachment(url) {
	  $("#filePreviewIframe").attr("src", url);
	  $("#previewSection").show();
	}



  </script>
  <script>
  function validateCost() {
	    var FromCost = parseInt($("#FromCost").val(), 10);
	    var ToCost = parseInt($("#ToCost").val(), 10);

	    if (isNaN(FromCost) || isNaN(ToCost)) {
	        alert("Please enter valid numeric values.");
	        $("#FromCost").val(0);
	        $("#ToCost").val(1000000);
	        return false;
	    }

	    if (FromCost > ToCost) {
	        alert("Minimum Cost should not be greater than "+ToCost);
	        $("#FromCost").val(0);
	        return false;
	    }

	    return true; 
	}

function submitPrintAction(printAction) {
    // Get the main form
    const form = document.getElementById('RequistionForm');
    
    // Create a hidden input for the print action
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'PrintAction';
    actionInput.value = printAction;
    form.appendChild(actionInput);
    
    // Set the form action and target
    form.action = 'estimateTypeParticularDivPrint.htm';
    form.target = '_blank';
    
    // Submit the form
    form.submit();
    
    // Reset form attributes after submission
    setTimeout(() => {
        form.removeChild(actionInput);
        form.action = 'estimateTypeParticularDivPrint.htm';
        form.target = '_self';
    }, 100);
}
</script>
  
</html>