<%@page import="com.vts.rpb.utils.CommonActivity"%>
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

</style>

</head>
<body>
		<%
		List<Object[]> requisitionList=(List<Object[]>)request.getAttribute("RequisitionList"); 
		System.err.print("requisitionList JSP-"+requisitionList.size());
		List<Object[]> DivisionList=(List<Object[]>)request.getAttribute("DivisionList"); 
		String empId=((Long)session.getAttribute("EmployeeId")).toString();
		String loginType=(String)session.getAttribute("LoginType");
		String currentFinYear=(String)request.getAttribute("CurrentFinYear");
		
		String fromYear="",toYear="",divisionId="",estimateType="",fbeYear="",reYear="";
		FundApprovalBackButtonDto fundApprovalDto=(FundApprovalBackButtonDto)session.getAttribute("FundApprovalAttributes");
		if(fundApprovalDto!=null)
		{
			fromYear=fundApprovalDto.getFromYearBackBtn();
			toYear=fundApprovalDto.getToYearBackBtn();
			divisionId=fundApprovalDto.getDivisionId();
			estimateType=fundApprovalDto.getEstimatedTypeBackBtn();
			fbeYear=fundApprovalDto.getFBEYear();
			reYear=fundApprovalDto.getREYear();
		}
		String ExistingbudgetHeadId=(String)request.getAttribute("ExistingbudgetHeadId");
		String ExistingbudgetItemId=(String)request.getAttribute("ExistingbudgetItemId");
		String ExistingfromCost=(String)request.getAttribute("ExistingfromCost");
		String ExistingtoCost=(String)request.getAttribute("ExistingtoCost");
		String Existingstatus=(String)request.getAttribute("Existingstatus");
		String AmtFormat =(String)request.getAttribute("amountFormat");
		String MemberType =(String)request.getAttribute("MemberType");
		String existingbudget =(String)request.getAttribute("ExistingBudget");
		String existingProposedProject=(String)request.getAttribute("ExistingProposedProject");
		
		String committeeMember=null;
		if(!"A".equalsIgnoreCase(loginType)){
		 committeeMember=(String)request.getAttribute("committeeMember");
		}
		%>
			<%String success=(String)request.getParameter("resultSuccess"); 
              String failure=(String)request.getParameter("resultFailure");%>
              
              <input type="hidden" id="estimateType" value="<%=estimateType%>">

<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-3"><h5>Fund Report List</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="MainDashBoard.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	          <li class="breadcrumb-item active" aria-current="page">Report List</li>
             </ol>
           </div>
         </div>
       </div> 
     
  	    
  	    
		
      <div class="page card dashboard-card">
        <div class="" style="width: 100%;background-color: #fff8ed;padding: 5px">
    <form action="FundReport.htm" method="POST" id="RequistionForm" autocomplete="off">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input id="budgetHeadIdHidden" type="hidden" <%if(ExistingbudgetHeadId != null){ %>value="<%=ExistingbudgetHeadId%>" <%} %>>
        <input id="budgetItemIdHidden" type="hidden" <%if(ExistingbudgetItemId != null ){ %>value="<%=ExistingbudgetItemId%>" <%} %>>
        <input id="proposedProjectHidden" type="hidden" <%if(existingProposedProject != null ){ %>value="<%=existingProposedProject%>" <%} %>>

        <!-- Division + From/To Year Row -->
        <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 8px; width: 100%;">
            <!-- Division -->
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">Division:</label>
                <select class="form-control select2" id="DivisionDetails" name="DivisionDetails"
                    data-live-search="true" onchange="formSubmit(this)" required
                    style="font-size: 12px; min-width: 340px;">
                    <% if ( committeeMember!=null && committeeMember.equalsIgnoreCase("CS") || committeeMember!=null && committeeMember.equalsIgnoreCase("CC") || loginType.equalsIgnoreCase("A")) { %>
                        <option value="-1#All#All" <% if (divisionId != null && divisionId.equalsIgnoreCase("-1")) { %> selected <% } %> hidden>All</option>
                    <% } %>
                    <% if (DivisionList != null && DivisionList.size() > 0) {
                        for (Object[] List : DivisionList) { %>
                            <option value="<%=List[0]%>#<%=List[1]%>#<%=List[3]%>"
                                <% if (divisionId != null && divisionId.equalsIgnoreCase(List[0].toString())) { %> selected <% } %>>
                                <%=List[1]%> (<%=List[3]%>)
                            </option>
                    <% }} %>
                </select>
            </div>

            <!-- From Year -->
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">From:</label>
                <input type="text" class="form-control" name="FromYear" id="FromYear"
                    value="<%= fromYear != null ? fromYear : "" %>" readonly onchange="this.form.submit()"
                    style="width: 100px; background-color: white;" required />
            </div>

            <!-- To Year -->
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">To:</label>
                <input type="text" class="form-control" name="ToYear" id="ToYear"
                    value="<%= toYear != null ? toYear : "" %>" readonly onchange="this.form.submit()"
                    style="width: 100px; background-color: white;" required />
            </div>
        </div>

        <!-- Estimate Type and Approval -->
        <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 40px; margin-top: 10px;">
            <!-- RE Radio -->
            <div style="align-items: center;">
                <input type="radio" id="REstimateType" checked name="EstimateType" value="R" />
                <label for="REstimateType" style="font-weight: bold; margin-left: 5px;">
                    RE <span style="color: red; font-weight: 600;">(<%= reYear %>)</span>
                </label>
                <input type="hidden" name="reYear" value="<%= reYear %>">
            </div>

            <!-- FBE Radio -->
            <div style="align-items: center;">
                <input type="radio" id="FBEstimateType" name="EstimateType" value="F" />
                <label for="FBEstimateType" style="font-weight: bold; margin-left: 5px;">
                    FBE <span style="color: red; font-weight: 600;">(<%= fbeYear %>)</span>
                </label>
                 <input type="hidden" name="fbeYear" value="<%= fbeYear %>">
            </div>

            <!-- Approved Dropdown -->
           <div style="align-items: center;">
			    <label for="REstimateType" style="font-weight: bold; margin-left: 5px;">Approved:</label>&nbsp;&nbsp;&nbsp;&nbsp;
			
			<span style="border: solid 0.1px;padding: 5px 9px;border-radius: 6px;border-color: darkgray;background-color: white;">
			    <input type="radio" id="approvalStatus"
			        <% if(Existingstatus == null || "A".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
			        name="approvalStatus" value="A" onchange="formSubmit()" />
			    &nbsp;<span style="font-weight: 600">Yes</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			
			    <input type="radio" id="approvalStatus"
			        <% if("N".equalsIgnoreCase(Existingstatus) || "F".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
			        name="approvalStatus" value="F" onchange="formSubmit()" />
			    &nbsp;<span style="font-weight: 600">No</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    
			    <input type="radio" id="approvalStatus"
			        <% if("NA".equalsIgnoreCase(Existingstatus)) { %> checked <% } %>
			        name="approvalStatus" value="NA" onchange="formSubmit()" title="Not Applicable" />
			    &nbsp;<span style="font-weight: 600">Both</span>
			    </span>
			</div>

        </div>

        <!-- Budget Details -->
        <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; margin-top: 20px;">
            <!-- Budget -->
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">Budget:</label>
                <select class="form-control select2" id="selBudget" name="selBudget"
                    data-live-search="true" onchange="formSubmit()" required
                    style="font-size: 12px; min-width: 200px;">
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
                <select id="selbudgethead" name="budgetHeadId" class="form-control select2"
                    data-live-search="true" onchange="formSubmit()" required style="font-size: 12px; min-width: 200px;">
                    <option value="">Select BudgetHead</option>
                </select>
            </div>

 <%if(ExistingbudgetHeadId != null && Long.valueOf(ExistingbudgetHeadId)!=0 ){ %>
            <!-- Budget Item -->
            <div style="display: flex; align-items: center;">
                <label style="font-weight: bold; margin-right: 8px;">Budget Item:</label>
                <select id="selbudgetitem" name="budgetItemId" class="form-control select2"
                    data-live-search="true" onchange="formSubmit()" required
                    style="font-size: 12px; min-width: 200px;">
                    <option value="">Select BudgetItem</option>
                </select>
            </div>
            <%} %>

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
            <%if("A".equalsIgnoreCase(loginType) ||  "CC".equalsIgnoreCase(MemberType) ||"CS".equalsIgnoreCase(MemberType)){ %>
              <div class="d-flex align-items-center">
                    <label for="CostFormat" class="fw-bold me-2"><b>Cost:</b>&nbsp;&nbsp;&nbsp;</label>
                    <select class="form-control select2" style="width: 120px;" name="AmountFormat" id="CostFormat" onchange="this.form.submit()">
                        <option value="R" <%if(AmtFormat!=null && "R".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Rupees</option>
                        <option value="L" <%if((AmtFormat==null) || "L".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Lakhs</option>
                        <option value="C" <%if("C".equalsIgnoreCase(AmtFormat)){ %> selected <%} %>>Crores</option>
                    </select>
                </div>
                <%} %>
        </div>

        <input type="hidden" id="projectIdHidden" value="0#GEN#General" />
    </form>
</div> <!-- Flex-container ends -->

				 

<div style="width: 100%; display: flex; justify-content: flex-end; margin-top: 10px;">
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
        <i class="fas fa-file-excel" Style="color: green; font-size: 1.73em;" aria-hidden="true" id="Excel"></i>
    </button>
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
					            
					            if(requisitionList!=null && requisitionList.size()>0){ %>
					            
					            <%for(Object[] data:requisitionList){ 
					            	grandTotal=grandTotal.add(new BigDecimal(data[18].toString()));
					            	String fundStatus=data[23]==null ? "NaN" : data[23].toString();
					            	if(fundStatus!=null){
					            		System.err.println("fnudstatus="+fundStatus);
					            	}
					            %>
					            
					            	 <tr>
				                   			<td align="center"><%=sn++ %></td>
				                   			<td align="center" id="budgetHead"><%if(data[7]!=null){ %> <%=data[7] %><%}else{ %> - <%} %></td>
				                   			<td align="left" id="Officer"><%if(data[20]!=null){ %> <%=data[20] %><%if(data[21]!=null){ %>, <%=data[21] %> <%} %> <%}else{ %> - <%} %></td>
				                   			<td id="Item"><%if(data[16]!=null){ %> <%=data[16] %><%}else{ %> - <%} %></td>
				                   			<td class='tableEstimatedCost' align="right" ><%if(data[18]!=null){ %> <%=AmountConversion.amountConvertion(data[18], AmtFormat) %><%}else{ %> - <%} %></td>
				                   			<td><%if(data[17]!=null){ %> <%=data[17] %><%}else{ %> - <%} %></td>
				                   			 <td align="center">
 												   <button type="button" 
											            class="btn btn-sm btn-outline-primary tooltip-container" 
											            onclick="openFundDetailsModal('<%=data[0] %>', this)" 
											            data-tooltip="Fund Details and Attachment(s)" data-position="top">
											        <i class="fa fa-eye"></i>
											  	  </button>
											</td>
											
											 <% String[] fundStatusDetails = CommonActivity.getFundNextStatus(fundStatus, data[32], data[33]);
											 
											 String message = "", statusColor = "";
											 if(fundStatusDetails!=null && fundStatusDetails.length > 0)
											 {
												 message = fundStatusDetails[4];
												 statusColor = fundStatusDetails[5];
											 }
						                        %>
											
				                   		<td style="width: 215px;" align="center">
				                   			 
				                   					<button type="button"  class="btn btn-sm w-100 btn-status greek-style tooltip-container" data-tooltip="click to view status" data-position="top" 
												            onclick="openApprovalStatusAjax('<%=data[0]%>')">
												            
												           		<div class="form-inline">
												           		 	<span style="color:<%=statusColor %>;" > <%=message %> </span> &nbsp;&nbsp;&nbsp;
												            		<i class="fa-solid fa-arrow-up-right-from-square" style="float: right;color:<%=statusColor %>;"></i>
												           		</div>
												             
											       </button>
											       
									       </td>
				                   			<td align="center" ><%if(data[26]!=null && !data[26].toString().isEmpty()){ %> <%=data[26] %><%} else { %>-<%} %></td>
			                      	 
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
							            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(grandTotal, AmtFormat) %></td>
							            <td colspan="4"></td>
						   		     </tr>
					            </tfoot> 
					            <%} %>
					        </table>
					    </div>
						
					  </form>

				

</body>
<script type="text/javascript">

<%if(success!=null){%>

	showSuccessFlyMessage('<%=success %>');

<%}else if(failure!=null){%>

	showFailureFlyMessage('<%=failure %>');

<%}%>
</script>
<script src="webresources/js/RpbFundStatus.js"></script>
<script>
					
					function formSubmit(){
						this.form.submit();
					}
					
					function formSubmit(el){
					    el.form.submit();
					}

				/* 	$(document).ready(function(event) {
						
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
            var project = $("select#selBudget").val(); 
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
        } */
        
        $('#selBudget,#selProposedProject').change(function(event) {
       	 
        	var budget = '0#General';
        	var budgetType = $("select#selBudget").val();
        	
        	if(budgetType && budgetType == '-1')
        	{
        		$("#selbudgethead").append("<option value='0'>All</option>"); 
        		$("#selbudgetitem").append("<option value='0'>All</option>");
        		var form=$("#RequistionForm");
        		if(form)
        		{
        			form.submit();
        		} 
        	}
        	
        	$.get('GetBudgetHeadList.htm', {
        		ProjectDetails : budget
        	}, function(responseJson) 
        	{
        		$('#selbudgethead').find('option').remove();
        		$("#selbudgethead").append("<option disabled value=''>Select Budget Head </option>"); 
        		$("#selbudgethead").append("<option selected value='0'>All</option>"); 
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
        		else if(budgetDetails == '-1')
        		{
        			$(".ProposedProject").hide();
        			$(".BudgetHeadDetails").hide();
        			$(".BudgetItemDetails").hide();
        		}
        	}
        	
        	var budgetHeadId = $("#budgetHeadIdHidden").val();
        	
        		if(budgetHeadId == 0)
        		{
        			$(".BudgetItemDetails").hide();
        		}
        	
        		$.get('GetBudgetHeadList.htm', {
        				ProjectDetails : budget
        			}, function(result) {
        				$('#selbudgethead').find('option').remove();
        				var result = JSON.parse(result);
        				
        				 if(result.length >1){
        					 if(budgetHeadId == 0){
        						 $("#selbudgethead").append("<option selected value='0'>All</option>");
        					 }
        					 else
        						 {
        						 	$("#selbudgethead").append("<option value='0'>All</option>");
        						 }
        						
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
  </script>
 <script type="text/javascript">
// Define function in global scope
function openAttachmentModal(fundApprovalId, ec) {
    console.log('Opening attachment modal for ID: ' + fundApprovalId);

    var estimatedCost = $(ec).closest('tr').find('.tableEstimatedCost').text().trim() || '-';

    getRevisionDetails(fundApprovalId);
    // First AJAX call (Details)
    $.ajax({
        url: 'GetAttachmentDetailsAjax.htm',
        method: 'GET',
        data: { fundApprovalId: fundApprovalId },
        success: function(data) {
            console.log('AJAX success', data);

            var detailsDiv = $(".AttachmentDetails");
            detailsDiv.empty(); // clear previous

            if (data && data.length > 0) {
                var attach = data[0];
                var statusColor = '';
                if (attach.Status === 'Approved') statusColor = 'green';
                else if (attach.Status === 'Pending') statusColor = '#8c2303';
                else if (attach.Status === 'Forwarded') statusColor = 'blue';
                else if (attach.Status === 'Returned') statusColor = 'red';

                var html = '<table class="table table-bordered table-striped">'
                    + '<tbody>'
                    + '<tr>'
                    + '<th style="color:#0080b3; font-size:16px;">Budget Head</th>'
                    + '<td style="font-weight:600; font-size:16px;">' + (attach.BudgetHead || '') + '</td>'
                    + '<th style="color:#0080b3; font-size:16px;">Budget Type</th>'
                    + '<td style="font-weight:600; font-size:16px;">' + (attach.BudgetType || '') + '</td>'
                    + '</tr>'
                    + '<tr>'
                    + '<th style="color:#0080b3; font-size:16px;">Estimate Type</th>'
                    + '<td style="font-weight:600; font-size:16px;">' + (attach.EstimateType || '') + ' (' + (attach.REFBEYear || '') + ')</td>'
                    + '<th style="color:#0080b3; font-size:16px;">Initiating Officer</th>'
                    + '<td style="font-weight:600; font-size:16px;">' + (attach.InitiatingOfficer || '') + ', ' + (attach.Designation || '') + '</td>'
                    + '</tr>'
                    + '<tr>'
                    + '<th style="color:#0080b3; font-size:16px;">Item Nomenclature</th>'
                    + '<td colspan="3" style="font-weight:600; font-size:16px;">' + (attach.ItemNomenculature || '') + '</td>'
                    + '</tr>'
                    + '<tr>'
                    + '<th style="color:#0080b3; font-size:16px;">Justification</th>'
                    + '<td style="font-weight:600; font-size:16px;">' + (attach.Justification || '') + '</td>'
                    + '<th style="color:#0080b3; font-size:16px;">Estimated Cost</th>'
                    + '<td style="color:#00008B;font-weight:600; font-size:16px;">' + (estimatedCost || '-') + '</td>'
                    + '</tr>'
                    + '<tr>'
                    + '<th style="color:#0080b3; font-size:16px;">Division</th>'
                    + '<td style="font-weight:600; font-size:16px;">' + (attach.Division || '') + ' (' + (attach.DivisionShortName || '') + ')</td>'
                    + '<th style="color:#0080b3; font-size:16px;">Status</th>'
                    + '<td style="font-weight:600; font-size:16px; color:' + statusColor + '">' + (attach.Status || '') + '</td>'
                    + '</tr>'
                    + '</tbody>'
                    + '</table>';

                detailsDiv.append(html);
            } else {
                detailsDiv.append("<div class='text-danger fw-bold'>No details found</div>");
            }
        },
        error: function() {
            console.error("AJAX call failed");
            $(".AttachmentDetails").html("<div class='text-danger fw-bold'>Failed to load details</div>");
        }
    });

    function getRevisionDetails(fundApprovalId){
    	 $.ajax({
    	     url: 'getFundApprovalRevisionDetails.htm',
    	     method: 'GET',
    	     data: { fundApprovalId: fundApprovalId },
    	     success: function(data) {
    	         var container = $("#RevisionHistoryContainer");
    	         container.empty();

    	         if (!data || data.length === 0) {
    	              container.html("<div class=' text-center font-weight-bold' style='color: #856404; background-color: #fff3cd;border-color: #ffeeba;padding: 4px;'>No Revision found</div>");
    	             return;
    	         }

    	         $.each(data, function(index, rev) {
    	             var revTitle = rev.RevisionCount == 0 ? "ORIGINAL" : "REVISION - " + rev.RevisionCount;

    	             // Header background colors only
    	             var headerColor = rev.RevisionCount == 0 ? "background-color:#69af4c; color:white;"   
    	                                                      : "background-color:#af9f4c; color:white;"; 

    	             var tableHtml =
    	                 '<div class="mb-3" style="border:1px solid #ccc; border-radius:4px;">' +
    	                   '<h6 class="font-weight-bold p-2 m-0" style="text-align: center; ' + headerColor + '">' + revTitle + '</h6>' +
    	                   '<table class="table table-bordered table-striped m-0 bg-white">' +
    	                     '<tbody>' +

    	                       '<tr>' +
    	                         '<th style="width:30%;color:#0080b3;">Budget Type</th>' +
    	                         '<td style="font-weight:600">' + (rev.BudgetType || '-') + '</td>' +
    	                         '<th style="width:30%;color:#0080b3;">Budget Head</th>' +
    	                         '<td style="font-weight:600">' + (rev.BudgetHead || '-') + '</td>' +
    	                       '</tr>' +

    	                       '<tr>' +
    	                         '<th style="width:30%;color:#0080b3;">Initiating Officer</th>' +
    	                         '<td style="font-weight:600">' + (rev.InitiatingOfficer || '-') + ', ' + (rev.Designation || '-') + '</td>' +
    	                         '<th style="width:30%;color:#0080b3;">Estimated Cost</th>' +
    	                         '<td style="color:#00008B;font-weight:600">' + rupeeFormat((rev.EstimatedCost).toLocaleString()) + '</td>' +
    	                       '</tr>' +

    	                       '<tr>' +
    	                         '<th style="width:30%;color:#0080b3;">Nomenclature</th>' +
    	                         '<td colspan="3" style="font-weight:600">' + (rev.ItemNomenculature || '-') + '</td>' +
    	                       '</tr>' +

    	                     '</tbody>' +
    	                   '</table>' +
    	                 '</div>';

    	             container.append(tableHtml);
    	         });
    	     },
    	     error: function() {
    	         $("#RevisionHistoryContainer").html(
    	             "<div class='alert alert-danger text-center font-weight-bold'>Failed to load revisions</div>"
    	         );
    	     }
    	 });
    }
    // Second AJAX call (Attachments list)
    $.ajax({
        url: 'GetFundRequestAttachmentAjax.htm',
        method: 'GET',
        data: { fundApprovalId: fundApprovalId },
        success: function(data) {
            var body = $("#eAttachmentModalBody");
            body.empty();
            var count=1;

            if (data.length === 0) {
                body.append("<tr><td colspan='3' style='text-align: center; color: red;font-weight:700'>No attachment found</td></tr>");
                $("#previewSection").hide();
                $("#filePreviewIframe").attr("src", "");
                $("#previewFileName").text(""); 
            } else {
                $.each(data, function(index, attach) {
                    var viewUrl = "PreviewAttachment.htm?attachid=" + attach.fundApprovalAttachId;
                    var downloadUrl = "FundRequestAttachDownload.htm?attachid=" + attach.fundApprovalAttachId;

                    var row = "<tr>" +
                      "<td style='font-weight:700'>" + count++ + ".</td>" +
                        "<td style='text-align: center; font-weight:700'>" + attach.fileName + "</td>" +
                        "<td style='text-align: center;'>" +
                        "<button class='btn fa fa-eye text-primary' title='Preview - " + attach.fileName + " Attachment' onclick=\"previewAttachment('" + viewUrl + "','" + attach.fileName + "')\"></button>" +
                        "</td>" +
                        "</tr>";
                    body.append(row);

                    // Auto-preview first attachment
                    if (index === 0) {
                        previewAttachment(viewUrl, attach.fileName);
                    }
                });
            }

            $(".AttachmentModal").modal("show");
        },
        error: function() {
            alert("Failed to load attachments.");
        }
    });
}

// Define previewAttachment globally
function previewAttachment(url, fileName) {
    $("#filePreviewIframe").attr("src", url);
    $("#previewSection").show();
    $("#previewFileName").text(fileName || "");
}

// Document ready logic
$(document).ready(function() {
    var estimateType = $("#estimateType").val();
    if (estimateType === 'F') {
        $("#FBEstimateType").prop("checked", true);
    } else if (estimateType === 'R') {
        $("#REstimateType").prop("checked", true);
    }
});
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
    form.action = 'FundReportPrint.htm';
    form.target = '_blank';
    
    // Submit the form
    form.submit();
    
    // Reset form attributes after submission
    setTimeout(() => {
        form.removeChild(actionInput);
        form.action = 'FundReport.htm';
        form.target = '_self';
    }, 100);
}
</script>
  
</html>