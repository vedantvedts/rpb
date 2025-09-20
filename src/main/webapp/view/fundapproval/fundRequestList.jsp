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
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<jsp:include page="../static/header.jsp"></jsp:include>
<jsp:include page="../fundapproval/fundModal.jsp"></jsp:include>
<title>Fund Requisition List</title>
<style>

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
        
.custom-width-modal {
			  width: 50% !important;
			  max-width: 100%;
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
			 
    </style>
    
    
<style type="text/css">
    
	.div-tooltip-container ul {
	  padding: 5px !important;
	}
	
	.spanClass
	{
		font-size:16px;
		color:red;
		font-weight: 600;
	}

</style>

<style type="text/css">

.dataTable
{
	font-weight:600 !important;
}

#forwardRemark {
  width: 600px;  
  max-width: 100%; 
}


</style>

</head>
<body>
		<% DecimalFormat df=new DecimalFormat("#########################");
		List<Object[]> requisitionList=(List<Object[]>)request.getAttribute("RequisitionList"); 
		List<Object[]> DivisionList=(List<Object[]>)request.getAttribute("DivisionList"); 
		String empId=((Long)session.getAttribute("EmployeeId")).toString();
		String loginType=(String)session.getAttribute("LoginType");
		String MemberType =(String)request.getAttribute("MemberType");
		String currentFinYear =(String)request.getAttribute("currentFinYear");
		System.out.println("MemberType*****"+MemberType);
		
		String fromYear="",toYear="",divisionId="",estimateType="",fbeYear="",reYear="",budgetType=null,proposedProject = null,finYear = null;
		FundApprovalBackButtonDto fundApprovalDto=(FundApprovalBackButtonDto)session.getAttribute("FundApprovalAttributes");
		if(fundApprovalDto!=null)
		{
			fromYear=fundApprovalDto.getFromYearBackBtn();
			toYear=fundApprovalDto.getToYearBackBtn();
			finYear = fromYear + "-" + toYear;
			divisionId=fundApprovalDto.getDivisionId();
			estimateType=fundApprovalDto.getEstimatedTypeBackBtn();
			fbeYear=fundApprovalDto.getFBEYear();
			reYear=fundApprovalDto.getREYear();
		}
		
		if(MemberType == null)
		{
			MemberType = "NA";
		}
		
		if(loginType == null)
		{
			loginType = "NA";
		}
		
		%>
			<%String success=(String)request.getParameter("resultSuccess"); 
              String failure=(String)request.getParameter("resultFailure");%>
              
              <input type="hidden" id="estimateType" value="<%=estimateType%>">
              <input type="hidden" id="budgetTypeHidden" <%if(budgetType!=null){ %> value="<%=budgetType%>" <%} %>>
              <input type="hidden" id="proposedProjectHidden" <%if(proposedProject!=null){ %> value="<%=proposedProject%>" <%} %>>
              <input type="hidden" id="divisionIdHidden" <%if(divisionId!=null){ %> value="<%=divisionId%>" <%} %>>
              <input type="hidden" id="EmpId" name="EmpId" value="<%=empId%>"/>
              <input type="hidden" id="csrfParam" name="${_csrf.parameterName}" value="${_csrf.token}"/>

<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-3"><h5>Requisition List</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="MainDashBoard.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	          <li class="breadcrumb-item active" aria-current="page">Requisition List</li>
             </ol>
           </div>
         </div>
       </div> 
     
  	    
  	    
		
       <div class="page card dashboard-card">
            
				<div class="card-body">		
				
				     <form action="FundRequest.htm" method="POST" id="RequistionForm" autocomplete="off"> 
				        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				        <div class="flex-container" style="border-radius: 3px;height: auto !important;padding: 8px;justify-content: end;border-bottom-right-radius: 0px !important;margin:0px !important;width: 100%;">
						 <div class="form-inline" style="justify-content: end;">
				           <label style="font-weight: bold;">Division :&nbsp;&nbsp;</label>
					            <div class="form-inline">
								 <select class="form-control select2" id="DivisionDetails" name="DivisionDetails" data-container="body" data-live-search="true" onchange="this.form.submit();"  
								  required="required"  style="align-items: center;font-size: 5px;min-width:440px;">
								   <%if(loginType.equalsIgnoreCase("A") || MemberType.equalsIgnoreCase("CC") || MemberType.equalsIgnoreCase("CS")) {%> 
								 	<option value="-1#All#All" <%if(divisionId!=null && (divisionId).equalsIgnoreCase("-1")){%> selected="selected" <%} %> hidden="true">All</option>
								  <%} %> 								 
									<%if(DivisionList!=null && DivisionList.size()>0){
									for(Object[] List: DivisionList){ %>
								    <option value="<%=List[0]%>#<%=List[1]%>#<%=List[3]%>"  <%if(divisionId!=null && (divisionId).equalsIgnoreCase(List[0].toString())){%> selected="selected" <%} %>  ><%=List[1]%>&nbsp;(<%=List[3]%>) </option>
									<!-- DivisionId#DivisionCode#DivisionName -->
									<%}} %>
							    </select>
							  </div>
							   &nbsp;&nbsp;&nbsp;&nbsp;
							   <div class="form-inline" style="">
								 <label id="fromLabel" style="font-weight: bold;">From:&nbsp;&nbsp;&nbsp;</label> 			
								 <input type="text" style="width: 100px; background-color:white;"  class="form-control"  id="FromYear" onchange="this.form.submit()" <%if(fromYear!=null){ %> value="<%=fromYear %>" <%} %> name="FromYear"  required="required" readonly="readonly"> 
								</div>
							   &nbsp;&nbsp;&nbsp;&nbsp;	
							   <div class="form-inline" style="">
							    <label id="toLabel" style="font-weight: bold;">&nbsp;&nbsp;&nbsp;To:&nbsp;&nbsp;&nbsp;</label>
					              <input type="text" style="width: 100px; background-color:white;" class="form-control" id="ToYear"   name="ToYear" <%if(toYear!=null){ %> value="<%=toYear %>" <%} %> required="required"  readonly="readonly" > 							
								</div>
						</div>  
					</div><!-- div class header ends -->
					
					<div class="form-inline" style="width: 99%;margin: auto;">
						<table class="table" style="width:30%;margin: auto;margin-top:4px;">
							<tr>
							<td align="center">
								<div class="form-inline" style="justify-content: center;">
									<input type="radio" id="REstimateType" checked="checked" name="EstimateType" value="R">
								    <label style="font-weight: bold;"> &nbsp;&nbsp;RE&nbsp; <span style="color:red;font-weight: 600;">(<%=reYear %>)</span></label>
									<input type="hidden" name="reYear" value="<%= reYear %>">
								</div>
							</td>
							<td align="center">
								<div class="form-inline" style="justify-content: center;">
									<input type="radio" id="FBEstimateType" name="EstimateType" value="F">
									<label style="font-weight: bold;"> &nbsp;&nbsp;FBE&nbsp; <span style="color:red;font-weight: 600;">(<%=fbeYear %>)</span></label>
									 <input type="hidden" name="fbeYear" value="<%= fbeYear %>">
								</div>
							</td>
							</tr>
						  </table>
					</div>
					
				 </form> 
				 	
					<form action="#" id="RequistionFormAction" autocomplete="off"> 
				        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
						
						<div class="table-responsive" style="margin-top: 0.5rem;font-weight: 600;">
					        <table class="table table-bordered table-hover table-striped table-condensed" id="RequisitionListTable">
					            <thead>
					                <tr>
					                    <th>SN</th>
					                    <th>Budget</th>
					                    <th>Budget Head</th>
					                    <th>Initiating Officer</th>
					                    <th>Nomenclature</th>
					                    <th class="text-nowrap">Estimated Cost</th>
					                    <th>Justification</th>
					                    <th>View</th>
					                    <th>Status</th>
					                    <th class="text-nowrap" style="width: 10%;">Action</th>
					                </tr>
					            </thead>
					            <tbody>
					            
					            <% int sn=1;
					            BigDecimal grandTotal = new BigDecimal(0);
					            BigDecimal subTotal = new BigDecimal(0);
					            
					            if(requisitionList!=null && requisitionList.size()>0){ %>
					            
					            <%for(Object[] data:requisitionList){ 
					            	grandTotal=grandTotal.add(new BigDecimal(data[18].toString()));
					            	String fundStatus=data[24]==null ? "NaN" : data[24].toString();
					            %>
					            
					            	 <tr>
				                   			<td align="center"><%=sn++ %>.</td>
				                   			<td align="center"><%if(data[7]!=null){  if(data[28]!=null && (data[28].toString()).equalsIgnoreCase("B")){%> General <%}else{ %> <%if(data[29]!=null){%><%=data[29] %><%}else{ %> - <%} %> <%} %> <%}else{ %> - <%} %></td>
				                   			<td align="left" id="budgetHead"><%if(data[7]!=null){ %> <%=data[7] %><%}else{ %> - <%} %></td>
				                   			<td align="left" id="Officer"><%if(data[20]!=null){ %> <%=data[20] %><%if(data[21]!=null){ %>, <%=data[21] %> <%} %> <%}else{ %> - <%} %></td>
				                   			<td id="Item"><%if(data[16]!=null){ %> <%=data[16] %><%}else{ %> - <%} %></td>
				                   			<td class='tableEstimatedCost' align="right"><%if(data[18]!=null){ %> <%=AmountConversion.amountConvertion(data[18], "R") %><%}else{ %> - <%} %></td>
				                   			<td><%if(data[17]!=null){ %> <%=data[17] %><%}else{ %> - <%} %></td>
				                   			 <td align="center">
											    <button type="button" 
											            class="btn btn-sm btn-outline-primary tooltip-container" 
											            onclick="openFundDetailsModal('<%=data[0] %>', this)" 
											            data-tooltip="Fund Request Details and Attachment(s)" data-position="top">
											        <i class="fa fa-eye"></i>
											    </button>
											</td>
				                   			<td style="width: 157px;" align="center">
				                   			 
				                   					<button type="button"  class="btn btn-sm w-100 btn-status greek-style tooltip-container" data-tooltip="click to view status" data-position="top" 
												            onclick="openApprovalStatusAjax('<%=data[0]%>')">
												            
												            <% String statusColor="",message="NA";
												            if(fundStatus!=null) { 
												               if("A".equalsIgnoreCase(fundStatus)) {
												            	   statusColor = "green";
												            	   message = "Approved";
												               } else if("N".equalsIgnoreCase(fundStatus)) {
												            	   statusColor = "#8c2303";
												                   message = "Pending";
												               } else if("F".equalsIgnoreCase(fundStatus) &&(data[31]!=null && (data[31].toString()).equalsIgnoreCase("N"))) {
												            	   statusColor = "blue";
												                   message = "Forwarded";
					            							   } else if("R".equalsIgnoreCase(fundStatus)) {
												            	   statusColor = "red";
												                   message = "Returned";
					            							   } else if("E".equalsIgnoreCase(fundStatus)) {
												            	   statusColor = "#007e68";
												                   message = "Revoked";
					            							   } else {
					            								   message = "Reco Pending";
												            	   statusColor = "#8c2303";
												               }
					            							 }
												               %>
												               
												           		<div class="form-inline">
												           		 	<span style="color:<%=statusColor %>;" > <%=message %> </span> &nbsp;&nbsp;&nbsp;
												            		<i class="fa-solid fa-arrow-up-right-from-square" style="float: right;color:<%=statusColor %>;"></i>
												           		</div>
												             
											       </button>
											       
									       </td>
				                   			<td align="center">
				                   			    <% int buttonStatus=0; %>
													      
											    <%if(("N".equalsIgnoreCase(fundStatus) || "R".equalsIgnoreCase(fundStatus)) || "E".equalsIgnoreCase(fundStatus)){ buttonStatus = 1;%>
													
													<button type="submit" data-tooltip="Edit Item Details(s)" data-position="left" class="btn btn-sm edit-icon tooltip-container"
											               name="fundApprovalId" value=<%=data[0]%> style="padding-top: 2px; padding-bottom: 2px;" formaction="EditFundRequest.htm">
											        <i class="fa-solid fa-pen-to-square" style="color:#F66B0E;"></i>									
											        </button>
										        
										        <% String divisionDetails = data[26] != null ? data[26].toString() +" ("+ (data[25]!=null ? data[25].toString() : "NA") +")" : "";%>
												
													<img id="ForwardButton" onclick="openForwardModal('<%=data[0] %>','<%=data[18]!=null ? df.format(data[18]) : 0 %>','<%=data[1] %>','<%=data[4] %>','<%=data[7] %>','<%=data[9]!=null ? (data[9].toString().trim()).replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ") : "" %>','<%=data[12] %>','<%=data[16] %>','<%=data[17]!=null ? (data[17].toString().trim()).replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ") : "" %>','<%=data[20] %>','<%=data[21] %>','<%=divisionDetails %>','<%=fundStatus %>','<%=data[32] %>')" data-tooltip="<%if(fundStatus!=null && (fundStatus.equalsIgnoreCase("E") || fundStatus.equalsIgnoreCase("R"))){ %> RE-<%} %>Forward Item for Approval" data-position="left" data-toggle="tooltip" class="btn-sm tooltip-container" src="view/images/forwardIcon.png" width="45" height="35" style="cursor:pointer; background: transparent; padding: 12px; padding-top: 8px; padding-bottom: 10px;">
					                       		
					                       		<%} else if((data[24]!=null && (data[24].toString()).equalsIgnoreCase("A")) && ("A".equalsIgnoreCase(loginType) ||  "CC".equalsIgnoreCase(MemberType) ||"CS".equalsIgnoreCase(MemberType))) { buttonStatus = 1;%> 
					                       		
						                       		<button type="submit" data-tooltip="Revise Item Details(s)" data-position="left" class="btn btn-sm revise-btn tooltip-container" data-toggle="tooltip"
											        name="fundApprovalId" value=<%=data[0]%> style="padding-top: 2px; padding-bottom: 2px;" formaction="ReviseFundRequest.htm">
											        Revision</button>
					                       		
					                       		<%} else if("F".equalsIgnoreCase(fundStatus) && (data[31]!=null && (data[31].toString()).equalsIgnoreCase("N"))) { buttonStatus = 1;%> 
					                       		
						                       		<button type="button" data-tooltip="Revoke The Request" data-position="left" class="btn btn-sm edit-icon tooltip-container" data-toggle="tooltip"
											        name="fundApprovalIdRevoke" style="padding-top: 2px; padding-bottom: 2px;" onclick="revokeConfirm('<%=data[0]%>')">
											        <i class="fa-solid fa-rotate-right" style="color:#F66B0E;font-size: 19px;"></i>
											        </button>
					                       		
					                       		<%} %>
											  	<img id="ForwardButton" onclick="openChatBox(<%=data[0]%>)" data-tooltip="Click to see Queries" data-position="left" data-toggle="tooltip" class="btn-sm tooltip-container" src="view/images/messageGreen.png" width="45" height="35" style="cursor:pointer; background: transparent; padding: 8px; padding-top: 0px; padding-bottom: 0px;">
													
								    
											    <%if(("N".equalsIgnoreCase(fundStatus) || "R".equalsIgnoreCase(fundStatus) || "E".equalsIgnoreCase(fundStatus)) && ((data[24]!=null && (data[24].toString()).equalsIgnoreCase("A")) || ("A".equalsIgnoreCase(loginType) ||  "CC".equalsIgnoreCase(MemberType) ||"CS".equalsIgnoreCase(MemberType)))){ buttonStatus = 1;%>
						                       		 
						                       		 <button type="button" data-tooltip="Delete The Request" data-position="left"
						                       		 onclick="confirmDelete('<%=data[0]%>')" class="btn btn-sm tooltip-container"><i class="fa-solid fa-trash" style="color:#FF4C4C;"></i></button>
					                       		
					                       		<%} %>
					                       		
					                       		<% if(buttonStatus == 0){ %>
					                       		
					                       			<span style="font-weight: 600;">***</span>
					                       		
					                       		<%} %>
					                       		
					                       	</td>
				                        </tr>	
					            
					            <%} %>
					            
					            
					            <%}else{ %>
					            
					             <tr style="height: 9rem;">
					                        <td colspan="10" style="vertical-align: middle;">
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
							            <td colspan="5" align="right">Grand Total</td>
							            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(grandTotal, "R") %></td>
							            <td colspan="4"></td>
						   		     </tr>
					            </tfoot> 
					            <%} %>
					        </table>
					    </div>
					    
					      <div class="text-center">
					      
					    <%--   <% if(finYear!=null && currentFinYear.equalsIgnoreCase(finYear)){ %> --%>
					      
					      <%if(divisionId!=null && !divisionId.equalsIgnoreCase("-1")){ %>
					      
				               <button type="submit" class="btn btn-sm add-btn tooltip-container" name="AddDataOfSel" name="Action" value="Add" 
					            data-tooltip="Add New Item(s)" data-placement="top" formaction="AddFundRequest.htm"> New Request </button>
					            &nbsp;
					            
				               <button type="submit" class="btn btn-sm revise-btn tooltip-container" name="Action" value="Demand" 
					            data-tooltip="Carry Forward Existing Demand(s)" data-placement="top" formaction="FundRequestCarryForward.htm"> CF Demand </button>
					            &nbsp;
					            
				               <button type="submit" class="btn btn-sm carry-forward-so-btn tooltip-container" name="Action" value="SupplyOrder" 
					            data-tooltip="Carry Forward Existing Supply Order(s)" data-placement="top" formaction="FundRequestCarryForward.htm"> CF Supply Order </button>
					            &nbsp;
					            
				               <button type="submit" class="btn btn-sm carry-forward-request-btn tooltip-container" name="Action" value="Item" 
					            data-tooltip="Carry Forward Previous Year Existing Request" data-placement="top" formaction="FundRequestCarryForward.htm"> Carry Forward Request </button>
					       
					         <%} %>  
					       
					   <%--     <%} %>    --%>
						
						</div>
						
					  </form>
					   
		             
				</div>
			</div>		
			
			
			
			<div class="modal ItemForwardModal" tabindex="-1" role="dialog">
				  <div class="modal-dialog modal-lg" role="document" style="max-width: 57% !important;">
				    <div class="modal-content">
				      <div class="modal-header">
                        <h5 class="modal-title" style="font-family:'Times New Roman';font-weight: 600;">
					            <span style="font-family:'Times New Roman';font-weight: 600;font-size: 18px;" class="MainEstimateType">-</span> Item Details
					    </h5>&nbsp;&nbsp;
					     <span style="color:#00f6ff;font-weight: 600;margin-top:3px;" class="ReFbeYearModal">(Current Financial Year - <%=currentFinYear %>)</span>
					     <button type="button" class="close" data-dismiss="modal" aria-label="Close">
				         <span aria-hidden="true" style="font-size: 19px;color:white;">&#10006;</span>
				        </button>
				      </div>
				      <div class="modal-body">
				      
				      <div class="flex-container" style="background-color:transparent !important;height: auto;width: 70%;margin: auto;margin-bottom:10px;">
			           		<div class="form-inline" style="padding: 10px;">
			           		
			           			<label style="font-size: 19px;"><b>RE :&nbsp;</b></label><span class="spanClass reFbeYearForward"></span>
			           		</div>
			           		<div class="form-inline" style="padding: 10px;">
			           			
			           			<label style="font-size: 19px;"><b>Division :&nbsp;</b></label><span class="spanClass divisionDetailsForward">-</span>
			           		</div>
			           </div>
				      
				      	<div id="itemDetailsCarousel" class="carousel slide" data-ride="carousel" data-interval="false">
							    <div class="carousel-inner">
							
							      <!-- Slide 1: Item Details -->
							      <div class="carousel-item active">
							      <div style="text-align: right;">
							      <button class="btn btn-info mb-3" onclick="openApprovalFlow()">Approval Details &#10097;&#10097;</button>
							      </div>
							        
							
							        <div class="table-responsive">
							          <table class="table table-bordered" style="font-weight: 600;width: 100%;" id="ApprovalDetails">
							            <tr>
							              <td style="color:#034189;">Budget</td>
							              <td class="BudgetDetails">-</td>
							              <td style="color:#034189;">Budget Head</td>
							              <td class="BudgetHeadDetails">-</td>
							            </tr>
							            <tr>
							              <td style="color:#034189;">Budget Item</td>
							              <td class="budgetItemDetails">-</td>
							               <td style="color:#034189;">Estimated Cost</td>
							              <td class="EstimatedCostDetails">-</td>
							            </tr>
							            <tr>
							              <td style="color:#034189;">Item Nomenclature</td>
							              <td colspan="3" class="ItemNomenclatureDetails">-</td>
							            </tr>
							            <tr>
							              <td style="color:#034189;">Justification</td>
							              <td colspan="3" class="JustificationDetails">-</td>
							            </tr>
							          </table>
							          
							          <div style="font-weight: 600;color:black;"> Attachments: 
							          <span class="attachementLink">
				                            
				                      </span>
				                      
				                      <div class="statusHistory">
				                      
				                      </div>
							          
							          </div>
							          
								      <div class="card-body forwardAction">
								       <form action="FundApprovalForward.htm" id="FundForwardForm">
								       
										<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
										<input type="hidden" id="FundRequestAction" name="FundRequestAction">
										<input type="hidden" id="FundRequestIdForward" name="FundRequestIdForward">
										<input type="hidden" id="FundFlowMasterIdForward" name="FundFlowMasterIdForward">
										
				                            <div id="your-parent-element-id" style="gap: 1rem; width: 100%; display: flex; justify-content: center; align-items: center; flex-direction: column;" data-select2-id="your-parent-element-id">
				                              <div class="card ApprovalDetails table-responsive" style="width: 100%;padding:10px;"> 
				                              	<table style="width: 100%;" id="fundApprovalForardTable">
				                              		
				                              		
				                              	</table>
				                              </div>
				                             </div>
				                              
				                             <div class="row" style="width: 90%;margin:auto;margin-left: 0px;margin-top:10px;">
				                             <span style="color:#034189;font-weight: 600;">Remarks :&nbsp;&nbsp;</span>
				                             <textarea placeholder="Enter Remark" id="forwardRemark" maxlength="500" name="forwardRemark" required="required" class="form-control"></textarea>
				                             </div>
								             
				                       </form>
				                       </div>
							        </div>
							      </div>
							
							      <!-- Slide 2: Approval Authority Table -->
							      <div class="carousel-item">
							        <div style="text-align: right;">
							        	<button class="btn btn-secondary mb-3" onclick="openFundDetails()">Back</button>
							        </div>
							
							        <table class="table table-bordered">
							          <thead>
							            <tr>
							              <th>Case</th>
							              <th>Signature Mandated</th>
							              <th>Approval Authority</th>
							            </tr>
							          </thead>
							          <tbody>
							            <tr>
							              <td>Case I<br>Upto Rs. 10 Lakhs</td>
							              <td>GH/GD/TD (User)<br>RPB Member Secretary</td>
							              <td>RPB Standby Chairman / Chairman</td>
							            </tr>
							            <tr>
							              <td>Case II<br>Above Rs. 10 Lakhs & Upto Rs. 50 Lakhs</td>
							              <td>GD/TD (User) <br> one RPB Members<br>One Subject Expert<br>RPB Member Secretary</td>
							              <td>RPB Standby Chairman / Chairman</td>
							            </tr>
							            <tr>
							              <td>Case III<br>Above Rs. 50 Lakhs & Upto Rs. 2 Crore</td>
							              <td>GD/TD (User) <br> Two RPB Members<br>One Subject Expert<br>RPB Member Secretary</td>
							              <td>RPB Standby Chairman / Chairman</td>
							            </tr>
							            <tr>
							              <td>Case IV<br>Above Rs. 2 Crore</td>
							              <td>GD/TD (User) <br> Three RPB Members<br>One Subject Expert<br>RPB Member Secretary</td>
							              <td>RPB Standby Chairman / Chairman</td>
							            </tr>
							          </tbody>
							        </table>
							      </div>
							   </div>
				          </div>
				      </div>
				      
				      <div class="modal-footer" style="justify-content: center;background-color: #f0f5ff;border-radius: 3px;">
				        <button type="button" class="btn btn-sm submit-btn fundForwardButton" onclick="ApprovalFlowForward()"><span class="forwardActionName">Forward</span></button>
				        
				        <button type="button" class="btn btn-sm btn-secondary" data-dismiss="modal" style="background-color: darkred;color:white;">Close</button>
				      </div>
				      
				      
				  </div>
				</div>
				</div> 
<!-- Chat Modal -->
<div class="modal fade" id="chatBoxModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered custom-modal-width">
    <div class="modal-content" style="border-radius:8px; font-size:13px;">
      

      <div class="modal-header" style="background:#034189; color:#fff;">
        <h5 class="modal-title">Queries</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" style="font-size:19px; color:white;">&#10006;</span>
        </button>
      </div>


      <div class="modal-body" style="padding:8px; background:#f9f9f9; height:400px; overflow-y:auto;" id="chatMessages">
      </div>


      <div class="modal-footer" style="border-top:1px solid #ddd;">
        <input type="text" id="chatInput" placeholder="Type a message..."
               style="width:84%; padding:5px; border:1px solid #ccc; border-radius:4px;">
        <button type="button" class="btn btn-success" id="chatSendButton">
          <i class="fas fa-paper-plane"></i> Send
        </button>
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

function revokeConfirm(fundRequestId)
{
	var form = $("#RequistionFormAction");

	if (form) {
	    showConfirm('Are You Sure To Revoke The Fund Request..?',
	        function (confirmResponse) {
	            if (confirmResponse) {
	            	form.attr("action","RevokeFundRequest.htm");
	            	form.append('<input type="hidden" name="fundApprovalIdRevoke" value="'+fundRequestId+'">');
	                form.submit();
	            }
	        }
	    );
	}
}

// Delete Fund Request
function confirmDelete(fundRequestId)
{
	var form = $("#RequistionFormAction");

	if (form) {
	    showConfirm('Are You Sure To Delete The Fund Request..?',
	        function (confirmResponse) {
	            if (confirmResponse) {
	            	form.attr("action","DeleteFundRequest.htm");
	            	form.append('<input type="hidden" name="fundApprovalIdDelete" value="'+fundRequestId+'">');
	                form.submit();
	            }
	        }
	    );
	}
}

</script>

<script type="text/javascript">

function openApprovalFlow()
{
	$('#itemDetailsCarousel').carousel(1);
	$(".fundForwardButton").hide();
}
function openFundDetails()
{
	$('#itemDetailsCarousel').carousel(0);
	$(".fundForwardButton").show();
}

</script>

<script type="text/javascript">


var allEmployeeList = [];
var committeeMemberList = [];
var masterFlowDetails = null;
var chairmanId = null;
var SecretaryId = null;

// Master copies 
var masterEmployeeList = [];
var masterCommitteeList = [];

// Each dropdown will hold its own copy of employee list (value = { memberType, list })
const dropdownEmployeeMap = new Map();   // key = inputId string (with leading '#'), value = { memberType, list }

// Map to store selected values per dropdown
const selectedMap = new Map();  // key=inputId (with '#'), value=empId

// selector string for binding events
var dropdownSelector = '';

// keep current divisionHeadId (set by openForwardModal)
var currentDivisionHeadId = "";

// CSRF tokens (if you use them)
var csrfToken = $('meta[name="_csrf"]').attr('content');
var csrfHeader = $('meta[name="_csrf_header"]').attr('content');

// ---------------- Helper functions ----------------
function detectMemberType(inputId) {
    if (inputId.indexOf("divisionHeadDetails") !== -1) return "DH";
    if (inputId.indexOf("SubjectExpertDetails") !== -1) return "SE";
    if (inputId.indexOf("RPBMemberSecretaryDetails") !== -1) return "CS";
    if (inputId.indexOf("chairmanDetails") !== -1) return "CC";
    if (inputId.indexOf("RPBMemberDetails") !== -1) return "CM";
    return "";
}

function isAllowedFor(memberType, empId) {
    if (!empId) return false;
    if (memberType === "DH") return true;

    var c = masterCommitteeList.find(e => (e[2] + "") === (empId + ""));
    if (!c) return false;
    var listType = (c[1] + "") || "";

    if ((memberType === "CM" || memberType === "SE") && listType === "CM") return true;
    if (memberType === "CC" && (listType === "CC" || listType === "SC")) return true;
    if (memberType === "CS" && listType === "CS") return true;

    return false;
}

function getMasterObjFor(memberType, empId) {
    if (memberType === "DH") return masterEmployeeList.find(e => (e[0] + "") === (empId + ""));
    return masterCommitteeList.find(e => (e[2] + "") === (empId + ""));
}

function getEmpIdFromObj(obj, memberType) {
    if (!obj) return null;
    return (memberType === "DH") ? obj[0] : obj[2];
}

function getMasterIndex(memberType, empId) {
    if (memberType === "DH") {
        return masterEmployeeList.findIndex(e => (e[0] + "") === (empId + ""));
    }
    return masterCommitteeList.findIndex(e => (e[2] + "") === (empId + ""));
}

// ---------------- Fetch Lists ----------------
$.ajax({
    url: 'GetCommitteeMemberDetails.htm',
    method: 'GET',
    beforeSend: function(xhr) { if (csrfHeader && csrfToken) xhr.setRequestHeader(csrfHeader, csrfToken); },
    success: function(response) {
        var data = JSON.parse(response || "[]");
        committeeMemberList = [...data];
        masterCommitteeList = [...data];
        chairmanId = (committeeMemberList.find(item => item[1] === "CC") || [])[2];
        SecretaryId = (committeeMemberList.find(item => item[1] === "CS") || [])[2];
    },
    error: function(xhr, status, err) {
        console.error("GetCommitteeMemberDetails error", status, err);
    }
});

$.ajax({
    url: 'SelectAllemployeeAjax.htm',
    method: 'GET',
    beforeSend: function(xhr) { if (csrfHeader && csrfToken) xhr.setRequestHeader(csrfHeader, csrfToken); },
    success: function(responseJson) {
        var result = JSON.parse(responseJson || "[]");
        allEmployeeList = [...result];
        masterEmployeeList = [...result];
    },
    error: function(xhr, status, err) {
        console.error("SelectAllemployeeAjax error", status, err);
    }
});

// ---------------- Fill single dropdown ----------------
function fillDropdown(inputId, memberType, sourceList, divisionHeadId, selectedVal) {
    var $dropdown = $(inputId);
    if ($dropdown.length === 0) return;

    $dropdown.empty().append('<option value="">Select Employee</option>');

    sourceList.forEach(function(value) {
        var listMemberType = value[1];
        var empId = (memberType === "DH") ? value[0] : value[2];
        var empName = (memberType === "DH") ? value[2] : value[3];
        var empDesig = (memberType === "DH") ? value[3] : value[4];

        // role filter
        if (memberType === "DH") {
            // allow all
        } else if ((memberType === "CM" || memberType === "SE") && listMemberType !== 'CM') {
            return;
        } else if (memberType === "CC" && (listMemberType !== 'CC' && listMemberType !== 'SC')) {
            return;
        } else if (memberType === "CS" && listMemberType !== 'CS') {
            return;
        }

        var selAttr = (selectedVal && (empId + "") === (selectedVal + "")) ? " selected" : "";
        $dropdown.append('<option value="' + empId + '"' + selAttr + '>' + (empName || '') + (empDesig ? ', ' + empDesig : '') + '</option>');
    });

    // If selectedVal not present (maybe it was removed earlier), append it from master so UI shows it
    if (selectedVal) {
        var exists = $dropdown.find('option[value="' + selectedVal + '"]').length > 0;
        if (!exists) {
            if (memberType === "DH") {
                var mObj = masterEmployeeList.find(e => (e[0] + "") === (selectedVal + ""));
                if (mObj) {
                    $dropdown.append('<option value="' + mObj[0] + '" selected>' + (mObj[2] || '') + (mObj[3] ? ', ' + mObj[3] : '') + '</option>');
                }
            } else {
                var cObj = masterCommitteeList.find(e => (e[2] + "") === (selectedVal + ""));
                if (cObj && isAllowedFor(memberType, selectedVal)) {
                    $dropdown.append('<option value="' + cObj[2] + '" selected>' + (cObj[3] || '') + (cObj[4] ? ', ' + cObj[4] : '') + '</option>');
                }
            }
        }
    }

    // refresh select2 UI if present
    if ($dropdown.hasClass('select2')) {
        try { $dropdown.trigger('change.select2'); } catch(e) {}
    }
}

// ---------------- Rebuild all dropdowns ----------------
function rebuildAllDropdownsAfterSync() {
    // build selector string
    dropdownSelector = Array.from(dropdownEmployeeMap.keys()).join(", ");

    // temporarily unbind change handlers while updating
    $(document).off("change", dropdownSelector);

    // build a set of selected IDs to exclude (except each dropdown's own selected)
    let excludeIds = new Set();
    selectedMap.forEach(function(id) { if (id) excludeIds.add(id + ""); });

    // For each dropdown - rebuild its list in master order excluding selected ids (except itself)
    dropdownEmployeeMap.forEach(function(meta, inputId) {
        var memberType = meta.memberType;
        var selectedVal = selectedMap.get(inputId) || "";

        // create ordered list from master, keeping only allowed ones and excluding other selections
        var masterList = (memberType === "DH") ? masterEmployeeList : masterCommitteeList;
        var newList = [];

        masterList.forEach(function(item) {
            var empId = (memberType === "DH") ? item[0] : item[2];
            // if emp is chosen elsewhere and it is not the current dropdown's selected, skip
            if (excludeIds.has(empId + "") && (empId + "") !== (selectedVal + "")) return;
            // ensure allowed for this memberType
            if (isAllowedFor(memberType, empId)) newList.push(item);
        });

        // update map and UI
        meta.list = newList;
        dropdownEmployeeMap.set(inputId, meta);
        fillDropdown(inputId, memberType, newList, currentDivisionHeadId, selectedVal);
        $(inputId).val(selectedVal); // keep value (no change trigger)
        if ($(inputId).hasClass('select2')) {
            try { $(inputId).trigger('change.select2'); } catch(e) {}
        }
    });

    // reattach change handler
    attachDropdownChangeHandler();
}

// ---------------- Change handler ----------------
function attachDropdownChangeHandler() {
    dropdownSelector = Array.from(dropdownEmployeeMap.keys()).join(", ");
    $(document).off("change", dropdownSelector);

    $(document).on("change", dropdownSelector, function (e) {
        var inputId = "#" + $(this).attr("id");
        var newVal = $(this).val() || "";
        var oldVal = selectedMap.get(inputId) || "";

        if ((oldVal + "") === (newVal + "")) return;

        // update selected map immediately
        selectedMap.set(inputId, newVal);

        // Remove newVal from other lists and restore oldVal into other lists at original position
        dropdownEmployeeMap.forEach(function(meta, otherId) {
            if (otherId === inputId) return;

            var memberType = meta.memberType;
            var list = meta.list || [];

            // remove newVal occurrences
            if (newVal) {
                for (var i = list.length - 1; i >= 0; i--) {
                    var candidateId = (memberType === "DH") ? list[i][0] : list[i][2];
                    if ((candidateId + "") === (newVal + "")) list.splice(i, 1);
                }
            }

            // restore oldVal in correct master position (if allowed and not already present)
            if (oldVal && isAllowedFor(memberType, oldVal)) {
                var present = list.some(function(item) {
                    var id = (memberType === "DH") ? item[0] : item[2];
                    return (id + "") === (oldVal + "");
                });

                if (!present) {
                    var orig = getMasterObjFor(memberType, oldVal);
                    var masterIdx = getMasterIndex(memberType, oldVal);
                    if (orig && masterIdx !== -1) {
                        // insert at correct position by comparing master indices
                        var inserted = false;
                        for (var j = 0; j < list.length; j++) {
                            var candidateId = (memberType === "DH") ? list[j][0] : list[j][2];
                            var candIdx = getMasterIndex(memberType, candidateId);
                            if (candIdx > masterIdx) {
                                list.splice(j, 0, orig);
                                inserted = true;
                                break;
                            }
                        }
                        if (!inserted) list.push(orig);
                    }
                }
            }

            dropdownEmployeeMap.set(otherId, { memberType: memberType, list: list });
        });

        // rebuild UI in master order with updated selections
        rebuildAllDropdownsAfterSync();
    });
}

// ================= OPEN FORWARD MODAL (main flow) =================
function openForwardModal(
    fundRequestId, estimatedCost, estimatedType, ReFbeYear, budgetHeadDescription, HeadOfAccounts,
    CodeHead, Itemnomenclature, justification, empName, designation, divisionDetails, fundStatus, divisionHeadId)
{
    // store divisionHeadId globally for fillDropdown when needed
    currentDivisionHeadId = divisionHeadId || "";

    refreshModal('.ItemForwardModal');
    $(".RPBMember1,.RPBMember2,.RPBMember3,.SubjectExpert").hide();
    $(".forwardAction,.statusHistory").hide();
    $(".ItemForwardModal").modal('show');

    $(".BudgetDetails").html("GEN (General)");
    $(".BudgetHeadDetails").html(budgetHeadDescription);
    $(".budgetItemDetails").html(HeadOfAccounts + ' (' + CodeHead + ')');
    $(".EstimatedCostDetails").html(rupeeFormat(estimatedCost));
    $(".ItemNomenclatureDetails").html(Itemnomenclature);
    $(".JustificationDetails").html(justification);
    $(".MainEstimateType").html(estimatedType != null && estimatedType == 'R' ? 'RE' : 'FBE');
    $(".reFbeYearForward").html(ReFbeYear);
    $(".divisionDetailsForward").html(divisionDetails);

    $("#FundRequestIdForward").val(fundRequestId);

    // show/hide actions as before
    if (fundStatus == 'N') {
        $(".forwardAction").show();
        $(".forwardActionName").html("Forward");
        $("#FundRequestAction").val('F');
    } else if (fundStatus == 'E') {
        $(".forwardAction").show();
        $("#FundRequestAction").val('RF');
        $(".forwardActionName").html("Re-Forward");
        $("#ForwardButton").attr("data-tooltip", 'Re-Forward Item for Approval');
    } else if (fundStatus == 'R') {
        $(".statusHistory").show();
        $("#FundRequestAction").val('RF');
        $(".forwardActionName").html("Re-Forward");
        $("#ForwardButton").attr("data-tooltip", 'Re-Forward Item for Approval');

        $.ajax({
            url: 'getRPBApprovalHistoryAjax.htm',
            type: 'GET',
            data: { fundApprovalId: fundRequestId },
            success: function(response) {
                var data = JSON.parse(response || "[]");
                if (!Array.isArray(data[0])) data = [data];
                var tableHTML = generateTableHTML(data);
                $('.statusHistory').html(tableHTML);
            },
            error: function(xhr, status, err) { console.error('getRPBApprovalHistoryAjax error', status, err); }
        });
    }

    getAttachementDetailsInline(fundRequestId);

    // Load master flow details and build dropdowns
    $.ajax({
        url: 'GetMasterFlowDetails.htm',
        method: 'GET',
        data: { fundRequestId: fundRequestId },
        success: function(responseJson) {
            var data = JSON.parse(responseJson || "[]");
            masterFlowDetails = data;

            if (!masterFlowDetails || masterFlowDetails.length === 0) {
                $("#fundApprovalForardTable").append("<span style='font-weight:600;color:red;'>Something Went Wrong ..!</span>");
                return;
            }

            // clear previous UI/maps
            $("#fundApprovalForardTable").empty();
            dropdownEmployeeMap.clear();
            selectedMap.clear();

            // Initiating officer row
            $("#fundApprovalForardTable").append(
                '<tr><td style="padding: 8px; text-align: right; color: #00087a; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">Initiating Officer :</td>' +
                '<td style="padding: 8px;width: 70% !important;" colspan="1"><input type="text" class="form-control" readonly="readonly" id="initiating_officer_display" name="initiating_officer_display" value="' + empName + ', ' + designation + '"></td>' +
                '</tr>'
            );

            var cmCount = 0;

            // build rows and initial maps
            masterFlowDetails.forEach(function(value) {
                $("#FundFlowMasterIdForward").val(value[0]);
                var memberType = value[1];   // DH, CM, CS, CC, SE
                var backendEmpId = value[3]; // empId coming from backend flow (if any)
                var inputId = null;
                var preSelectId = "";

                if (memberType === "CM") {
                    cmCount++;
                    appendFlowRow(memberType, cmCount);
                    inputId = "#RPBMemberDetails" + cmCount;
                    preSelectId = backendEmpId;
                } else {
                    appendFlowRow(memberType, "");
                    if (memberType === "DH") { inputId = "#divisionHeadDetails"; preSelectId = divisionHeadId; }
                    if (memberType === "SE") { inputId = "#SubjectExpertDetails"; preSelectId = backendEmpId; }
                    if (memberType === "CC") { inputId = "#chairmanDetails"; preSelectId = chairmanId; }
                    if (memberType === "CS") { inputId = "#RPBMemberSecretaryDetails"; preSelectId = SecretaryId; }
                }

                if (!inputId) return;

                // per-dropdown working copy (we'll rebuild in master order below)
                var listCopy = (memberType === "DH") ? [...masterEmployeeList] : [...masterCommitteeList];
                dropdownEmployeeMap.set(inputId, { memberType: memberType, list: listCopy });

                // set the preselected value into the selectedMap
                if (preSelectId) selectedMap.set(inputId, preSelectId);
            });

            // Rebuild every dropdown's list in master order excluding already selected
            rebuildAllDropdownsAfterSync();
        },
        error: function(xhr, status, err) {
            console.error('GetMasterFlowDetails Ajax error', status, err);
        }
    });
}

// ---------------- Append Flow Row ----------------
function appendFlowRow(role, index) {
    let config = roleConfig[role];
    if (!config) return;

    let inputId = config.multiple ? config.inputIdPrefix + index : config.inputId;
    let inputName = config.multiple ? config.inputNamePrefix : config.inputId;

    let $tr = $("<tr>").addClass(role + index);

    let $tdLabel = $("<td>").css({ padding: "8px", "text-align": "right", "font-weight": "600", "white-space": "nowrap", display: "flex", "align-items": "center" })
        .html(config.label + (config.required ? '&nbsp;<span class="mandatory" style="color:red;font-weight:normal;"> *</span>' : ''));

    let $tdInput = $("<td>").css({ padding: "8px", width: "63%" });

    let $select = $("<select>").attr({ id: inputId, name: inputName })
        .addClass("form-control select2")
        .css({ width: "100%", "font-size": "10px", "white-space": "nowrap", overflow: "hidden", "text-overflow": "ellipsis" })
        .append('<option value="">Select Employee</option>');

    $tdInput.append($select);
    $tr.append($tdLabel).append($tdInput);

    $("#fundApprovalForardTable").append($tr);

    $(".select2").select2({ width: "100%" });
}

// ---------------- Config and Validation ----------------
const roleConfig = {
    DH: { label: "Division Head", required: true, inputId: "divisionHeadDetails" },
    CM: { label: "RPB Member", required: true, multiple: true, inputIdPrefix: "RPBMemberDetails", inputNamePrefix: "RPBMemberDetails" },
    SE: { label: "Subject Expert", required: true, inputId: "SubjectExpertDetails" },
    CS: { label: "RPB Member Secretary", required: true, inputId: "RPBMemberSecretaryDetails" },
    CC: { label: "RPB Chairman / Stand by Chairman", required: true, inputId: "chairmanDetails" }
};

const labelMap = {
    "#divisionHeadDetails": "Division Head",
    "#SubjectExpertDetails": "Subject Expert",
    "#RPBMemberSecretaryDetails": "RPB Member Secretary",
    "#chairmanDetails": "RPB Chairman / Standby Chairman"
};

/* // ---------------- SUBMIT / VALIDATE ----------------
function ApprovalFlowForward() {
    // 1) Build list of required dropdowns and check selectedMap
    for (let [inputId, meta] of dropdownEmployeeMap.entries()) {
        var memberType = meta.memberType;
        var required = roleConfig[memberType] && roleConfig[memberType].required;
        var val = selectedMap.get(inputId) || "";

        if (required && (!val || val.trim() === "")) {
            // user-friendly label
            var label = labelMap[inputId] || (memberType === "CM" ? "RPB Member" : "Employee");
            if (typeof showAlert === "function") {
                showAlert("Please select an employee for " + label + " ..!");
            } else if (typeof Swal !== "undefined") {
                Swal.fire("Validation", "Please select an employee for " + label + " ..!", "warning");
            } else {
                alert("Please select an employee for " + label + " ..!");
            }
            // focus the dropdown if present
            try { $(inputId).focus(); } catch(e) {}
            return false;
        }
    }

    // 2) Ensure DOM selects reflect selectedMap (important for select2 and form submission)
    dropdownEmployeeMap.forEach(function(meta, inputId) {
        var val = selectedMap.get(inputId) || "";
        try {
            $(inputId).val(val);
            if ($(inputId).hasClass('select2')) $(inputId).trigger('change.select2');
            else $(inputId).trigger('change');
        } catch(e) {}
    });

    // 3) Confirm with user
    function doSubmit() {
        // prefer existing form with id #FundForwardForm
        var form = $("#FundForwardForm");
        if (form.length === 0) form = $("#approvalFlowForwardForm");
        if (form.length === 0) {
            // try to find form that contains the table
            var candidate = $("#fundApprovalForardTable").closest("form");
            if (candidate.length) form = candidate;
        }

        if (form.length) {
            // submit native to keep server-handled selects intact
            try {
                form[0].submit();
            } catch (e) {
                // fallback to AJAX post: gather named fields from selects (best-effort)
                var payload = {};
                selectedMap.forEach(function(empId, selId) {
                    var name = $(selId).attr('name') || selId.replace('#','');
                    payload[name] = empId;
                });
                $.ajax({
                    url: form.attr('action') || 'ForwardFundRequest.htm',
                    type: form.attr('method') || 'POST',
                    data: payload,
                    success: function(resp) { location.reload(); },
                    error: function(xhr, status, err) { console.error("Submit fallback error", status, err); alert("Submit failed."); }
                });
            }
        } else {
            // final fallback (no form found) - send data to ForwardFundRequest.htm
            var payload = {};
            selectedMap.forEach(function(empId, selId) {
                var name = $(selId).attr('name') || selId.replace('#','');
                payload[name] = empId;
            });
            $.ajax({
                url: 'ForwardFundRequest.htm',
                type: 'POST',
                data: payload,
                success: function(resp) { location.reload(); },
                error: function(xhr, status, err) { console.error("Submit fallback error", status, err); alert("Submit failed."); }
            });
        }
    }

    if (typeof Swal !== "undefined") {
        Swal.fire({
            title: "Are You Sure?",
            text: "Are You Sure To Forward The Fund Request..?",
            icon: "question",
            showCancelButton: true,
            confirmButtonText: "Yes, Forward",
            cancelButtonText: "Cancel"
        }).then((result) => {
            if (result.isConfirmed) doSubmit();
        });
    } else {
        if (confirm("Are You Sure To Forward The Fund Request..?")) doSubmit();
    }

    return false;
} */

function ApprovalFlowForward() {
    let isValid = true;

/*     for (let [selector, value] of selectedMap.entries()) {
        if (!value || value.trim() === "") {
            let message = labelMap[selector] 
                          || (selector.startsWith("#RPBMemberDetails") ? "RPB Member" : "Unknown");
            showAlert("Please select an employee for " + message + " ..!");
            $(selector).focus();
            isValid = false;
            break;
        }
    }
 */
    if (isValid) {
        let form = $("#FundForwardForm");
        if (form.length) {
            showConfirm("Are You Sure To Forward The Fund Request..?", function (confirmResponse) {
                if (confirmResponse) {
                    form.submit();
                }
            });
        }
    }
}

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
  
  $(document).ready(function(){
	  
	<% if(requisitionList!=null && requisitionList.size() > 0) %>
	  
	  $("#RequisitionListTable").DataTable({
	 "lengthMenu": [[10, 25, 50, 75, 100,-1],[10, 25, 50, 75, 100,"All"]],
	 "pagingType": "simple",
	 "pageLength": 10,
	 "ordering": true
		});
	});


   
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
  
<script type="text/javascript">

$(document).ready(function(){
	
	var budgetType = $("#budgetTypeHidden").val();
	if(budgetType!=null)
	{
		if(budgetType == 'N')
		{
			$(".proposedProjectClass").show();
			var proposedProject = $("#proposedProjectHidden").val();
			getProposedProjectDetails(proposedProject);
		}
	}
	
});

$("#budgetType").change(function(){
	
	var budgetType = $("#budgetType").val();
	if(budgetType == 'B')
	{
		$("#proposedProject").prop("disabled", true);
		var form=$("#RequistionForm");
		if(form)
		{
			form.submit();
		}
	}else if(budgetType == 'N')
	{
		$(".proposedProjectClass").show();
		$("#proposedProject").prop("disabled", false);
		proposedProjectOnChange();
	}
	
});

// onchange of BudgetType
function proposedProjectOnChange()
{
	var divisionId = $("#divisionIdHidden").val();
	$.get('getProposedProjectDetails.htm', {
		divisionId : divisionId
	}, function(responseJson) {
		$('#proposedProject').find('option').remove();
		$("#proposedProject").append("<option disabled > Select Proposed Project </option>");
			var result = JSON.parse(responseJson);
			$.each(result, function(key, value) {
				
				$("#proposedProject").append("<option value="+value[0]+" >"+ value[3]+"</option>");
				
			});
			
			var form=$("#RequistionForm");
			if(form)
			{
				form.submit();
			}
	});
}

// onchange of Proposed Project Drop down
$("#proposedProject").change(function(){
	
	var form=$("#RequistionForm");
	if(form)
	{
		form.submit();
	}
	
});


function getProposedProjectDetails(proposedProjectId)
{
	var divisionId = $("#divisionIdHidden").val();
	$.get('getProposedProjectDetails.htm', {
		divisionId : divisionId
	}, function(responseJson) {
		$('#proposedProject').find('option').remove();
		$("#proposedProject").append("<option disabled > Select Proposed Project </option>");
			var result = JSON.parse(responseJson);
			$.each(result, function(key, value) {
				if(proposedProjectId!=null && proposedProjectId==value[0])
				{
					$("#proposedProject").append("<option selected value="+value[0]+" >"+ value[3]+"</option>");
				}
				else
				{
					$("#proposedProject").append("<option value="+value[0]+" >"+ value[3]+"</option>");
				}
			});
	});	
}

</script>
  
<script>
 let currentFundApprovalId = null;
 let refreshInterval = null;
 let lastMessageCount = 0;

 function openChatBox(fundApprovalId) {
     currentFundApprovalId = fundApprovalId; // store current row's ID

     // Clear previous chat messages
     var chatMessages = document.getElementById("chatMessages");
     chatMessages.innerHTML = "";

     // Reset message counter
     lastMessageCount = 0;

     // Clear any existing interval to avoid multiple refreshes
     if (refreshInterval) {
         clearInterval(refreshInterval);
         refreshInterval = null;
     }

     // Open modal
     $('#chatBoxModal').modal('show');

     // Load queries for this ID
     loadQueries(fundApprovalId);

     // Start auto-refresh
     startAutoRefresh(fundApprovalId);
 }

 // Explicit close (if called manually)
 function closeChatBox() {
     $('#chatBoxModal').modal('hide');
 }

 // Ensure cleanup when modal is closed (by X, backdrop, or function)
 $('#chatBoxModal').on('hidden.bs.modal', function () {
     // Stop refresh
     if (refreshInterval) {
         clearInterval(refreshInterval);
         refreshInterval = null;
     }
     // Reset all variables
     currentFundApprovalId = null;
     lastMessageCount = 0;
     document.getElementById("chatMessages").innerHTML = "";
     document.getElementById("chatInput").value = "";
 });

 // Load existing queries from DB using AJAX
 function loadQueries(fundApprovalId) {
     var chatMessages = document.getElementById("chatMessages");
     var currentEmpId = document.getElementById("EmpId").value;

     $.ajax({
         url: "getFundApprovalQueries.htm",
         type: "GET",
         data: { fundApprovalId: fundApprovalId },
         success: function(response) {
             try {
                 var data = JSON.parse(response);
                 if (data && data.length > lastMessageCount) {
                     // Append only new messages
                     for (var i = lastMessageCount; i < data.length; i++) {
                         var row = data[i];
                         var empId = row[1];      
                         var empName = row[2];
                         var designation = row[3];
                         var message = row[5];
                         var actionDate = row[6];

                         actionDate = actionDate.replace(/:\d{2}\s/, " ");

                         var wrapper = document.createElement("div");
                         wrapper.style.clear = "both";
                         wrapper.style.marginBottom = "8px";

                         var msgDiv = document.createElement("div");
                         msgDiv.style.padding = "6px 8px";
                         msgDiv.style.borderRadius = "8px";
                         msgDiv.style.display = "inline-block";
                         msgDiv.style.maxWidth = "60%";
                         msgDiv.style.wordWrap = "break-word";

                         if (empId == currentEmpId) {
                             wrapper.style.textAlign = "right"; 
                             msgDiv.style.background = "#034189";
                             msgDiv.style.color = "#fff";
                             msgDiv.innerHTML =
                                 "<div style='text-align: left;'><b>You</b>: " + message + "</div>" +
                                 "<div style='font-size:11px; color:#f0d890; text-align:right; margin-top:2px;'>" + actionDate + "</div>";
                         } else {
                             wrapper.style.textAlign = "left"; 
                             msgDiv.style.background = "#e9ecef";
                             msgDiv.style.color = "#000";
                             msgDiv.innerHTML =
                                 "<div><b>" + empName + ", " + designation + "</b>: " + message + "</div>" +
                                 "<div style='font-size:11px; color:#a78432; text-align:right; margin-top:2px;'>" + actionDate + "</div>";
                         }

                         wrapper.appendChild(msgDiv);
                         chatMessages.appendChild(wrapper);
                     }

                     lastMessageCount = data.length;
                     chatMessages.scrollTop = chatMessages.scrollHeight;
                 }
             } catch (e) {
                 console.error("Invalid JSON:", e);
             }
         },
         error: function(xhr, status, error) {
             console.error("Error loading queries:", error);
         }
     });
 }

 // Auto-refresh every 3 seconds
 function startAutoRefresh(fundApprovalId) {
     if (refreshInterval) clearInterval(refreshInterval);
     refreshInterval = setInterval(function() {
         loadQueries(fundApprovalId);
     }, 3000);
 }

 // Attach send button
 document.getElementById('chatSendButton').addEventListener('click', function() {
     if(currentFundApprovalId){
         sendQuery(currentFundApprovalId);
     }
 });

 // Attach enter key for sending message
 document.addEventListener("DOMContentLoaded", function () {
     var input = document.getElementById("chatInput");
     input.addEventListener("keypress", function (e) {
         if (e.key === "Enter") {
             e.preventDefault(); 
             sendQuery(currentFundApprovalId);
         }
     });
 });

 // Send new message
 function sendQuery(fundApprovalId) {
     var input = document.getElementById("chatInput");
     var msg = input.value.trim();
     if (msg === "") return;

     var csrfParam = document.getElementById("csrfParam").name;
     var csrfToken = document.getElementById("csrfParam").value;

     var requestData = { fundApprovalId: fundApprovalId, Query: msg };
     requestData[csrfParam] = csrfToken;

     $.ajax({
         url: "sendFundApprovalQuery.htm",
         type: "POST",
         data: requestData,
         success: function(response) {
             var chatMessages = document.getElementById("chatMessages");
             var now = new Date();
             var dateTime = now.toLocaleString("en-US", { 
                 month: "short", day: "numeric", year: "numeric", 
                 hour: "numeric", minute: "numeric", hour12: true 
             });

             var wrapper = document.createElement("div");
             wrapper.style.clear = "both";
             wrapper.style.textAlign = "right";
             wrapper.style.marginBottom = "8px";

             var newMsg = document.createElement("div");
             newMsg.style.padding = "6px 10px";
             newMsg.style.background = "#034189";
             newMsg.style.color = "#fff";
             newMsg.style.borderRadius = "8px";
             newMsg.style.display = "inline-block";
             newMsg.style.maxWidth = "70%";
             newMsg.style.wordWrap = "break-word";

             newMsg.innerHTML =
                 "<div style='text-align: left;'><b>You</b>: " + msg + "</div>" +
                 "<div style='font-size:11px; color:#f0d890; text-align:right; margin-top:2px;'>" + dateTime + "</div>";

             wrapper.appendChild(newMsg);
             chatMessages.appendChild(wrapper);

             chatMessages.scrollTop = chatMessages.scrollHeight;
             input.value = "";
             lastMessageCount++;
         },
         error: function(xhr, status, error) {
             console.error("Error sending query:", error);
         }
     });
 }
</script>

 
  
</html>