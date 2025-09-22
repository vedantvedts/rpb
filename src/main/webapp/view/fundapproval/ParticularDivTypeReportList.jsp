<%@page import="com.vts.rpb.utils.DateTimeFormatUtil"%>
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
<jsp:include page="../fundapproval/fundModal.jsp"></jsp:include>
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

.flex-container
{
	margin: 0px !important;
}

#RequistionFormAction
{
	width: 98% !important;
	margin: 0px;
	margin-left: auto !important;
	margin-right: auto !important;
}

.approvalstatus
{
	border: solid 0.1px;
    padding: 4px 11px;
    border-radius: 6px;
    border-color: darkgray;
    background-color: white;
}

</style>

</head>
<body>
		<%
		List<Object[]> requisitionList=(List<Object[]>)request.getAttribute("attachList"); 
		Object[] divisionDetails=(Object[])request.getAttribute("divisionDetails"); 
		String empId=((Long)session.getAttribute("EmployeeId")).toString();
		String loginType=(String)session.getAttribute("LoginType");
		String currentFinYear=(String)request.getAttribute("CurrentFinYear");
		
		String fromYear=(String)request.getAttribute("FromYear");
		String toYear=(String)request.getAttribute("ToYear");
		String existingbudget=(String)request.getAttribute("Existingbudget");
		String existingProposedProject=(String)request.getAttribute("ExistingProposedProject");
		String ExistingbudgetHeadId=(String)request.getAttribute("ExistingbudgetHeadId");
		String ExistingbudgetItemId=(String)request.getAttribute("ExistingbudgetItemId");
		String ExistingfromCost=(String)request.getAttribute("ExistingfromCost");
		String ExistingtoCost=(String)request.getAttribute("ExistingtoCost");
		String Existingstatus=(String)request.getAttribute("Existingstatus");
		String divisionId=(String)request.getAttribute("divisionId");
		String estimateType=(String)request.getAttribute("estimateType");
		String AmtFormat =(String)request.getAttribute("amountFormat");
		String MemberType =(String)request.getAttribute("MemberType");
		
		System.out.println("fromYear*****"+fromYear);
		System.out.println("toYear*****"+toYear);
		System.out.println("estimateType*****"+estimateType);

		Object DivName = "", DivCode = "";
		String estimateTypeName = "";
		String financialYear = "";
		if(divisionDetails!=null)
		{
			DivCode = divisionDetails[1] != null ? divisionDetails[1] : "";
			DivName = divisionDetails[2] != null ? divisionDetails[2] : "";
		}
		if(estimateType != null){
			if(estimateType.equalsIgnoreCase("R")){
				estimateTypeName = "RE";
				if(fromYear != null && toYear !=null){
					financialYear= fromYear + "-" + toYear;
				}
			}else if(estimateType.equalsIgnoreCase("F"))
			{
				estimateTypeName = "FBE";
				if(fromYear != null && toYear !=null){
					financialYear= (Long.parseLong(fromYear) + 1) + "-" + (Long.parseLong(toYear) + 1);
				}
			}
		}
	
		%>
			

<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-3"><h5> Fund Report</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="MainDashBoard.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	          <li class="breadcrumb-item active" aria-current="page">Report List</li>
             </ol>
           </div>
         </div>
       </div> 
     
  	    
  	    
 <div class="page card dashboard-card">
    
    <div class="flex-container" style="width: 100%;">
    <form action="estimateTypeParticularDivList.htm" method="POST" id="RequistionForm" autocomplete="off">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input id="budgetHeadIdHidden" type="hidden" <%if(ExistingbudgetHeadId != null){ %>value="<%=ExistingbudgetHeadId%>" <%} %>>
        <input id="budgetItemIdHidden" type="hidden" <%if(ExistingbudgetItemId != null ){ %>value="<%=ExistingbudgetItemId%>" <%} %>>
        <input id="proposedProjectHidden" type="hidden" <%if(existingProposedProject != null ){ %>value="<%=existingProposedProject%>" <%} %>>
        <input id="budgetHidden" type="hidden" <%if(existingbudget != null ){ %>value="<%=existingbudget%>" <%} %>>
        <input type="hidden" name="divisionId" value="<%= divisionId %>">
        <input type="hidden" name="estimateType" value="<%= estimateType %>">
        <input type="hidden" name="fromYear" value="<%= fromYear %>">
        <input type="hidden" name="toYear" value="<%= toYear %>">
        
            <!-- First Row: Approved, Budget, Budget Head, Budget Item -->
            <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 8px; width: 100%;">
                <!-- Approved Dropdown -->
                <div style="align-items: center;align-content: space-evenly;">
                    <label for="REstimateType" style="font-weight: bold; margin-left: 5px;">Approved:</label>&nbsp;&nbsp;
                    <span class="approvalstatus">
                        <input type="radio" id="approvalStatus" <% if(Existingstatus == null || "A".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
                            name="approvalStatus" value="A" onchange="this.form.submit();" />
                        &nbsp;<span style="font-weight: 600">Yes</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    
                        <input type="radio" id="approvalStatus" <% if("N".equalsIgnoreCase(Existingstatus) || "F".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
                            name="approvalStatus" value="N" onchange="this.form.submit();" />
                        &nbsp;<span style="font-weight: 600">No</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        
                        <input type="radio" id="approvalStatus" <% if("NA".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
                            name="approvalStatus" value="NA" onchange="this.form.submit();" title="Not Applicable" />
                        &nbsp;<span style="font-weight: 600">Both</span>
                    </span>
                </div>
                
                <!-- Budget -->
                <div style="display: flex; align-items: center;">
                    <label style="font-weight: bold; margin-right: 8px;">Budget:</label>
                    <select class="form-control select2" id="selBudget" name="selBudget" data-live-search="true" required style="font-size: 12px; min-width: 200px;">
                        <option value="B" <%if(existingbudget!=null && existingbudget.equalsIgnoreCase("B")){ %> selected="selected" <%} %>>GEN (General)</option>
						  <option value="N" <%if(existingbudget!=null && existingbudget.equalsIgnoreCase("N")){ %> selected="selected" <%} %>>Proposed Project</option>
                    </select>
                </div>
                
                <!-- Proposed Project -->
	               <div style="display: flex; align-items: center;" class="ProposedProject">
                    <label style="font-weight: bold; margin-right: 8px;">Proposed Project:</label>
                    <select id="selProposedProject" name="selProposedProject" class="form-control select2" data-live-search="true" required style="font-size: 12px; min-width: 200px;">
                        <option  value="" disabled="disabled">Select Proposed Project</option>
                    </select>
                </div>

                <!-- Budget Head -->
                <div style="display: flex; align-items: center;">
                    <label style="font-weight: bold; margin-right: 8px;">Budget Head:</label>
                    <select id="selbudgethead" name="budgetHeadId" class="form-control select2" data-live-search="true" required style="font-size: 12px; min-width: 200px;">
                        <option value="">Select BudgetHead</option>
                    </select>
                </div>

                <%if(ExistingbudgetHeadId != null && Long.valueOf(ExistingbudgetHeadId)!=0 ){ %>
                <!-- Budget Item -->
                <div style="display: flex; align-items: center;">
                    <label style="font-weight: bold; margin-right: 8px;">Budget Item:</label>
                    <select id="selbudgetitem" name="budgetItemId" class="form-control select2" data-live-search="true" required style="font-size: 12px; min-width: 400px;">
                        <option value="">Select BudgetItem</option>
                    </select>
                </div>
                <%} %>
            </div>

            <!-- Second Row: Cost Range and Cost Format -->
            <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 8px; width: 100%; margin-top: 15px;">
                <!-- Cost Range -->
                <div style="display: flex; align-items: center;">
                    <label style="font-weight: bold; margin-right: 8px;">Cost Range:</label>
                    <input type="text" name="FromCost" id="FromCost" value="<%if(ExistingfromCost!=null ){ %><%=ExistingfromCost.trim()%><%} else {%>0<%} %>"  required
                        class="form-control" style="width: 140px; background-color: white;padding-left: 0; padding-right: 0; text-align: center;"
                        onblur="if (validateCost()) document.getElementById('RequistionForm').submit();" oninput="this.value = this.value.replace(/[^0-9]/g, '')" />
                    <span style="margin: 0 10px; font-weight: bold;">-</span>
                    <input type="text" name="ToCost" id="ToCost" value="<%if(ExistingtoCost!=null ){ %><%=ExistingtoCost.trim()%><%} else {%>1000000<%} %>" required
                        class="form-control" style="width: 140px; background-color: white;padding-left: 0; padding-right: 0; text-align: center;"
                        onblur="if (validateCost()) document.getElementById('RequistionForm').submit();" oninput="this.value = this.value.replace(/[^0-9]/g, '')" />
                </div>
                &nbsp;&nbsp;
                <!-- Cost Format (if applicable) -->
                <%if("A".equalsIgnoreCase(loginType) ||  "CC".equalsIgnoreCase(MemberType) ||"CS".equalsIgnoreCase(MemberType)){ %>
                <div style="display: flex; align-items: center;">
                    <label for="CostFormat" style="font-weight: bold; margin-right: 8px;">Cost:</label>
                    <select class="form-control select2" style="width: 120px;" name="AmountFormat" id="CostFormat">
                        <option value="R" <%if(AmtFormat!=null && "R".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Rupees</option>
                        <option value="L" <%if((AmtFormat==null) || "L".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Lakhs</option>
                        <option value="C" <%if("C".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Crores</option>
                    </select>
                </div>
                <%} %>
            </div>
        
    </form>
</div>

				 

<div style="width: 100%; display: flex; align-items: center; justify-content: space-between; margin-top: 10px;">
  
  <!-- Center-aligned span -->
  <div style="flex: 1; text-align: center;background-color: #ffffff;margin-left: 24%; margin-right: 22%;padding: 8px;">
  <span style="font-weight: 600;color:#6a1616;">Division : </span><span style="font-weight: 600;color:#160ab7;">&nbsp;<%= DivName %> <%= !DivCode.toString().isEmpty() ? "(" + DivCode + ")" : "" %></span>
&nbsp;&nbsp;&nbsp;
    &nbsp;&nbsp; <span style="font-weight: 600;color:#6a1616;">
         <%=estimateTypeName %> Year :
    </span>
    <span style="font-weight: 600;color:#160ab7;"><%=financialYear%> </span>
  </div>

  <% if(requisitionList!=null && requisitionList.size() > 0){ %>
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
  <%} %>

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
	                    <th>View</th>
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
                   			<td align="center"><%=sn++ %>.</td>
                   			<td align="center" id="budgetHead"><%if(data[9]!=null){ %> <%=data[9] %><%}else{ %> - <%} %></td>
                   			<td align="left" id="Officer"><%if(data[22]!=null){ %> <%=data[22] %><%if(data[23]!=null){ %>, <%=data[23] %> <%} %> <%}else{ %> - <%} %></td>
                   			<td id="Item"><%if(data[18]!=null){ %> <%=data[18] %><%}else{ %> - <%} %></td>
                   			<td class='tableEstimatedCost' align="right"><%if(data[20]!=null){ %><%= AmountConversion.amountConvertion(data[20], AmtFormat) %><%}else{ %> - <%} %></td>
                   			<td><%if(data[19]!=null){ %> <%=data[19] %><%}else{ %> - <%} %></td>
                  			
							 <td align="center">
							    <button type="button" 
							            class="btn btn-sm btn-outline-primary" 
							            onclick="openFundDetailsModal('<%=data[0] %>', this)" 
							            data-toggle="tooltip" data-placement="top" title="Info and Attachments ">
							        <i class="fa fa-eye"></i>
							    </button>
							</td>
							 <td>
                   			 
                 					<button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="click to view status" 
						            onclick="openApprovalStatusAjax('<%=data[0]%>')">
						            <span  <%if("A".equalsIgnoreCase(fundStatus)) {%> style="color: green;" <%} else if("N".equalsIgnoreCase(fundStatus)){ %> style="color: #8c2303;" <%} else if("F".equalsIgnoreCase(fundStatus)){ %> style="color: blue;"  <%} else if("R".equalsIgnoreCase(fundStatus)){ %>  style="color: red;" <%} %>>
						            <%if("A".equalsIgnoreCase(fundStatus)) {%> Approved <%} else if("N".equalsIgnoreCase(fundStatus)){ %> Pending  <%} else if("F".equalsIgnoreCase(fundStatus)){ %> Forwarded <%} else if("R".equalsIgnoreCase(fundStatus)){ %> Returned <%} %>
						            </span> 
						            <i class="fa-solid fa-arrow-up-right-from-square" <%if("A".equalsIgnoreCase(fundStatus)) {%> style="float: right;color: green;" <%} else if("N".equalsIgnoreCase(fundStatus)){ %> style="float: right;color: #8c2303;" <%} else if("F".equalsIgnoreCase(fundStatus)){ %> style="float: right;color: blue;"  <%} else if("R".equalsIgnoreCase(fundStatus)){ %>  style="float: right;color: red;" <%} %>></i>											
					       </button>
							       
					       </td>
                   			<td align="center"><%if(data[28]!=null && !data[28].toString().isEmpty()){ %> <%=data[28] %><%} else { %>-<%} %></td>
                     	 
	           		  </tr>
	            <%} %>
	            
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
		            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(grandTotal, AmtFormat) %></td>
		            <td colspan="4"></td>
	   		     </tr>
               </tfoot> 
	            <%} %>
	            
	        </table>
	    </div>
		
	  </form>
	</div>
				

</body>
<script src="webresources/js/RpbFundStatus.js"></script>

<script type="text/javascript">

$("#CostFormat,#selbudgetitem").change(function(){
	
	var form=$("#RequistionForm");
	if(form)
	{
		form.submit();
	}
	
});

</script>

<script type="text/javascript">

$('#selBudget,#selProposedProject').change(function(event) {
	 
	var budget = '0#General';
	
	$.get('GetBudgetHeadList.htm', {
		ProjectDetails : budget
	}, function(responseJson) 
	{
		$('#selbudgethead').find('option').remove();
		$("#selbudgethead").append("<option disabled value=''>Select Budget Head </option>"); 
			var result = JSON.parse(responseJson);
			var budgetHeadId = $("#budgetHeadIdHidden").val();
			$.each(result, function(key, value) {
				if(budgetHeadId != null && budgetHeadId == value.budgetHeadId)
				{
					$("#selbudgethead").append("<option selected value="+value.budgetHeadId+">"+ value.budgetHeaddescription + "</option>");
				}
				else if(value.budgetHeadId == '1' || value.budgetHeadId == '2')
				{
					$("#selbudgethead").append("<option value="+value.budgetHeadId+">"+ value.budgetHeaddescription + "</option>");
				}
			});
			
			var budgetItemId = $("#budgetItemIdHidden").val();
			onChangeSetBudgetItem(budgetItemId); 
	});
	
});

$(document).ready(function(event) {
	
	var budgetDetails = $("select#selBudget").val();
	var budget = '0#General';
	
	if(budgetDetails!=null && budgetDetails!="")
	{
		if(budgetDetails == 'B')
		{
			$("#selProposedProject").prop("disabled", false);
			$(".ProposedProject").hide();
		}
		else if(budgetDetails == 'N')
		{
			$(".ProposedProject").show();
			var proposedProjectId=$("#proposedProjectHidden").val();
			getProposedProjectDetails(proposedProjectId);
		}
	}
	
	var budgetHeadId = $("#budgetHeadIdHidden").val();
	
		$.get('GetBudgetHeadList.htm', {
				ProjectDetails : budget
			}, function(result) {
				$('#selbudgethead').find('option').remove();
				var result = JSON.parse(result);
				
				 if(result.length >1){
						$("#selbudgethead").append("<option  value='0'>All</option>");
					}  
				 
				var html1='';
				$.each(result, function(key, value) {
					 if(value.budgetHeadId== budgetHeadId)
					 {
						html1+='<option value="'+value.budgetHeadId+'" selected="selected">'+value.budgetHeaddescription+'</option>';
					 }
					 else if(value.budgetHeadId == '1' || value.budgetHeadId == '2')
					{
						html1+="<option value="+value.budgetHeadId+">"+  value.budgetHeaddescription+ "</option>";
					}
				});
				
				$("#selbudgethead").append(html1);
				
			var budgetItemId = $("#budgetItemIdHidden").val();
			onloadSetBudgetItem(budgetItemId);
			    
		});
		
});

function getProposedProjectDetails(proposedProjectId)
{
	$.get('getProposedProjectDetails.htm', {
		
	}, function(responseJson) {
		$('#selProposedProject').find('option').remove();
		$("#selProposedProject").append("<option disabled value=''>Select Proposed Project </option>");
			var result = JSON.parse(responseJson);
			$.each(result, function(key, value) {
				if(proposedProjectId!=null && proposedProjectId==value[0])
				{
					$("#selProposedProject").append("<option selected value="+value[0]+" >"+ value[3]+"</option>");
				}
				else
				{
					$("#selProposedProject").append("<option value="+value[0]+" >"+ value[3]+"</option>");
				}
				
			});
	});	
}

$('#selbudgethead').change( function(event) {
	onChangeSetBudgetItem('');  
});


function onChangeSetBudgetItem(budgetItemId) {
	    
	    var budget = '0#General';
	    var budgetHeadId = $("select#selbudgethead").val();
	    var HiddenbudgetHeadId = $("#budgetHeadIdHidden").val();
	    
	    //calling controller using ajax for project Drop Down based on projectId
	    $.get('SelectbudgetItem.htm', {
	        projectid: budget,
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
	            if (budgetItemId != null && budgetItemId == value.budgetItemId) 
	            {
	                $("#selbudgetitem").append("<option selected value=" + value.budgetItemId + ">" + value.headOfAccounts + " [" + value.subHead + "]</option>");
	            } else {
	                $("#selbudgetitem").append("<option value=" + value.budgetItemId + ">" + value.headOfAccounts + " [" + value.subHead + "]</option>");
	            }
	        });
	        
	         var form=$("#RequistionForm");
			if(form)
			{
				form.submit();
			} 
	    });
	}
function onloadSetBudgetItem(budgetItemId) {
	    
	    var budget = '0#General';
	    var budgetHeadId = $("select#selbudgethead").val();
	    var HiddenbudgetHeadId = $("#budgetHeadIdHidden").val();
	    
	    //calling controller using ajax for project Drop Down based on projectId
	    $.get('SelectbudgetItem.htm', {
	        projectid: budget,
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
	            if (budgetItemId != null && budgetItemId == value.budgetItemId) 
	            {
	                $("#selbudgetitem").append("<option selected value=" + value.budgetItemId + ">" + value.headOfAccounts + " [" + value.subHead + "]</option>");
	            } else {
	                $("#selbudgetitem").append("<option value=" + value.budgetItemId + ">" + value.headOfAccounts + " [" + value.subHead + "]</option>");
	            }
	        });
	        
	    });
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
  </script>
 <script type="text/javascript">

// Define previewAttachment globally
function previewAttachment(url, fileName) {
    $("#filePreviewIframe").attr("src", url);
    $("#previewSection").show();
    $("#previewFileName").text(fileName || "");
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