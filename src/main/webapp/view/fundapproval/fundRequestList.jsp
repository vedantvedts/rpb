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

</head>
<body>
		<% DecimalFormat df=new DecimalFormat("#########################");
		List<Object[]> requisitionList=(List<Object[]>)request.getAttribute("RequisitionList"); 
		List<Object[]> DivisionList=(List<Object[]>)request.getAttribute("DivisionList"); 
		String empId=((Long)session.getAttribute("EmployeeId")).toString();
		String loginType=(String)session.getAttribute("LoginType");
		String currentFinYear=(String)request.getAttribute("CurrentFinYear");
		String MemberType =(String)request.getAttribute("MemberType");
		
		String fromYear="",toYear="",divisionId="",estimateType="",fbeYear="",reYear="",budgetType=null,proposedProject = null;
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
		
		%>
			<%String success=(String)request.getParameter("resultSuccess"); 
              String failure=(String)request.getParameter("resultFailure");%>
              
              <input type="hidden" id="estimateType" value="<%=estimateType%>">
              <input type="hidden" id="budgetTypeHidden" <%if(budgetType!=null){ %> value="<%=budgetType%>" <%} %>>
              <input type="hidden" id="proposedProjectHidden" <%if(proposedProject!=null){ %> value="<%=proposedProject%>" <%} %>>
              <input type="hidden" id="divisionIdHidden" <%if(divisionId!=null){ %> value="<%=divisionId%>" <%} %>>

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
								   <%if(loginType.equalsIgnoreCase("A")) {%> 
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
					
				<%-- 	<div class="flex-container" style="border-radius: 3px;height: auto !important;padding: 8px;justify-content: end;border-bottom-right-radius: 0px !important;margin:0px !important;width: 100%;background-color: transparent !important;">
						 <div class="form-inline" style="justify-content: end;">
				           <label style="font-weight: bold;">Budget :&nbsp;&nbsp;</label>
					            <div class="form-inline">
								 <select class="form-control select2" id="budgetType" name="budgetTypeSel" style="align-items: center;font-size: 5px;min-width:200px;">
								 	<option value="B" <%if(budgetType!=null && budgetType.equalsIgnoreCase("B")){ %> selected="selected" <%} %>>GEN (General)</option>
								 	<option value="N" <%if(budgetType!=null && budgetType.equalsIgnoreCase("N")){ %> selected="selected" <%} %>>Proposed Project</option>
							    </select>
							  </div>
						</div> 
						
						
						
						 <div class="form-inline proposedProjectClass" style="justify-content: end;display: none;">&nbsp;&nbsp;
				           <label style="font-weight: bold;">Proposed Project :&nbsp;&nbsp;</label>
					            <div class="form-inline">
								 <select class="form-control select2" id="proposedProject" name="proposedProjectSel" style="align-items: center;font-size: 5px;min-width:200px;width: 300px;">
							    
							    </select>
							  </div>
						</div> 
						 
					</div> --%>
					
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
					                    <th>Item Nomenclature</th>
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
				                   			<td align="center"><%if(data[7]!=null){  if((data[28].toString()).equalsIgnoreCase("B")){%> General <%}else{ %> <%if(data[29]!=null){%><%=data[29] %><%}else{ %> - <%} %> <%} %> <%}else{ %> - <%} %></td>
				                   			<td align="left" id="budgetHead"><%if(data[7]!=null){ %> <%=data[7] %><%}else{ %> - <%} %></td>
				                   			<td align="left" id="Officer"><%if(data[20]!=null){ %> <%=data[20] %><%if(data[21]!=null){ %>, <%=data[21] %> <%} %> <%}else{ %> - <%} %></td>
				                   			<td id="Item"><%if(data[16]!=null){ %> <%=data[16] %><%}else{ %> - <%} %></td>
				                   			<td class='tableEstimatedCost' align="right"><%if(data[18]!=null){ %> <%=AmountConversion.amountConvertion(data[18], "R") %><%}else{ %> - <%} %></td>
				                   			<td><%if(data[17]!=null){ %> <%=data[17] %><%}else{ %> - <%} %></td>
				                   			 <td align="center">
											    <button type="button" 
											            class="btn btn-sm btn-outline-primary" 
											            onclick="openAttachmentModal('<%=data[0] %>', this)" 
											            data-toggle="tooltip" data-placement="top" title="Info and Attachments ">
											        <i class="fa fa-eye"></i>
											    </button>
											</td>
				                   			<td style="width: 120px;">
				                   			
				                   			 
				                   					<button type="button"  class="btn btn-sm btn-link w-100 btn-status greek-style" data-toggle="tooltip" data-placement="top" title="click to view status" 
												            onclick="openApprovalStatusAjax('<%=data[0]%>')">
												            <span  <%if("A".equalsIgnoreCase(fundStatus)) {%> style="color: green;" <%} else if("N".equalsIgnoreCase(fundStatus)){ %> style="color: #8c2303;" <%} else if("F".equalsIgnoreCase(fundStatus)){ %> style="color: blue;"  <%} else if("R".equalsIgnoreCase(fundStatus)){ %>  style="color: red;" <%} %>>
												            <%if("A".equalsIgnoreCase(fundStatus)) {%> Approved <%} else if("N".equalsIgnoreCase(fundStatus)){ %> Pending  <%} else if("F".equalsIgnoreCase(fundStatus)){ %> Forwarded <%} else if("R".equalsIgnoreCase(fundStatus)){ %> Returned <%} %>
												            </span> 
												            <i class="fa-solid fa-arrow-up-right-from-square" <%if("A".equalsIgnoreCase(fundStatus)) {%> style="float: right;color: green;" <%} else if("N".equalsIgnoreCase(fundStatus)){ %> style="float: right;color: #8c2303;" <%} else if("F".equalsIgnoreCase(fundStatus)){ %> style="float: right;color: blue;"  <%} else if("R".equalsIgnoreCase(fundStatus)){ %>  style="float: right;color: red;" <%} %>></i>											
											       </button>
											       
									       </td>
				                   			<td align="center">
													      
											    <%if(("N".equalsIgnoreCase(fundStatus) || "R".equalsIgnoreCase(fundStatus))){ %>
												<button type="submit" data-tooltip="Edit Item Details(s)" data-position="left" class="btn btn-sm edit-icon tooltip-container" data-toggle="tooltip"
										               name="fundApprovalId" value=<%=data[0]%> style="padding-top: 2px; padding-bottom: 2px;" formaction="EditFundRequest.htm">
										        <i class="fa-solid fa-pen-to-square" style="color:#F66B0E;"></i>									
										        </button>
										        
										        <% String divisionDetails = data[26] != null ? data[26].toString() +" ("+ (data[25]!=null ? data[25].toString() : "NA") +")" : "";
										        %>
												
												<img onclick="openForwardModal('<%=data[0] %>','<%=data[18]!=null ? df.format(data[18]) : 0 %>','<%=data[1] %>','<%=data[4] %>','<%=data[7] %>','<%=data[9] %>','<%=data[12] %>','<%=data[16] %>','<%=data[17]!=null ? data[17].toString().trim() : "" %>','<%=data[20] %>','<%=data[21] %>','<%=divisionDetails %>')" data-tooltip="<%if(data[24]!=null && (data[24].toString()).equalsIgnoreCase("N")){ %>Forward<%}else if(data[24]!=null && (data[24].toString()).equalsIgnoreCase("R")){ %>Re-Forward<%} %> Item for Approval" data-position="left" data-toggle="tooltip" class="btn-sm tooltip-container" src="view/images/forwardIcon.png" width="45" height="35" style="cursor:pointer; background: transparent; padding: 12px; padding-top: 8px; padding-bottom: 10px;">
					                       		<%} else if("A".equalsIgnoreCase(loginType) ||  "CC".equalsIgnoreCase(MemberType) ||"CS".equalsIgnoreCase(MemberType)) { %> 
					                       		<button type="submit" data-tooltip="Revise Item Details(s)" data-position="left" class="btn btn-sm edit-icon tooltip-container" data-toggle="tooltip"
										               name="fundApprovalId" value=<%=data[0]%> style="padding-top: 2px; padding-bottom: 2px;" formaction="ReviseFundRequest.htm">
										        <i class="fa-solid fa-rotate-right" style="color:#F66B0E;"></i>
									
										        </button>
					                       		<%}else{ %>
					                       		<span style="font-weight: 800;">***</span>
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
							            <td colspan="5"></td>
						   		     </tr>
					            </tfoot> 
					            <%} %>
					        </table>
					    </div>
					    
					      <div class="text-center">
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
						
						</div>
						
					  </form>
					   
		             
				</div>
			</div>		
			
			
			
			<div class="modal ItemForwardModal" tabindex="-1" role="dialog">
				  <div class="modal-dialog modal-lg" role="document" style="max-width: 65% !important;">
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
							          
							          	                <br>
				      
								      <div class="card-body">
								       <form action="FundApprovalForward.htm" id="FundForwardForm">
								       
										<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
										<input type="hidden" id="FundRequestIdForward" name="FundRequestIdForward">
										<input type="hidden" id="FlowMasterIdForward" name="FlowMasterIdForward">
										<input type="hidden" id="EstimatedCostForward" name="EstimatedCostForward">
										
										
				                            <div id="your-parent-element-id" style="gap: 1rem; width: 100%; display: flex; justify-content: center; align-items: center; flex-direction: column;" data-select2-id="your-parent-element-id">
				                              <div class="card ApprovalDetails table-responsive" style="width: 100%;padding:10px;"> 
				                              	<table style="width: 100%;" id="fundApprovalForardTable">
				                              		<tr>
				                              			<td style="padding: 8px; text-align: right; color: blue; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">Initiating Officer :</td>
				                              			<td style="padding: 8px;width: 70% !important;" colspan="2"><input type="text" class="form-control" readonly="readonly" id="initiating_officer_display" name="initiating_officer_display" value="-"></td>
				                              		</tr>
				                              		
				                              		<tr class="DivisionHead">
				                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">Division Head<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></td>
				                              			<td style="padding: 8px; width: 15%;"><input type="text" class="form-control role-input" id="DivisionHeadRole" name="DivisionHeadRole" placeholder="Enter Role" style="width: 10rem;" maxlength="15"></td>
				                              			<td style="padding: 8px; width: 55%;">
				                              			<input type="hidden" id="divisionHeadDetails" name="divisionHeadDetails">
				                              			<input type="text" class="form-control" readonly="readonly" id="divisionHeadName" name="divisionHeadName" value="-"></td>
				                              		</tr>
				                              		
				                              		<tr class="RPBMember1">
				                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Member<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></td>
				                              			<td style="padding: 8px; width: 15%;"><input type="text" class="form-control role-input" id="RPBMemberRole1" name="RPBMemberRole1" placeholder="Enter Role" style="width: 10rem;" maxlength="15"></td>
				                              			<td style="padding: 8px; width: 55%;">
				                              			<select id="RPBMemberDetails1" name="RPBMemberDetails1" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
				                              			<option value="">Select Employee</option>
				                              			</select></td>
				                              		</tr>
				                              		
				                              		<tr class="RPBMember2">
				                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Member<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></td>
				                              			<td style="padding: 8px; width: 15%;"><input type="text" class="form-control role-input" id="RPBMemberRole2" name="RPBMemberRole2" placeholder="Enter Role" style="width: 10rem;" maxlength="15"></td>
				                              			<td style="padding: 8px; width: 55%;">
				                              			<select id="RPBMemberDetails2" name="RPBMemberDetails2" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
				                              			<option value="">Select Employee</option>
				                              			</select></td>
				                              		</tr>
				                              		
				                              		<tr class="RPBMember3">
				                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Member<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></td>
				                              			<td style="padding: 8px; width: 15%;"><input type="text" class="form-control role-input" id="RPBMemberRole3" name="RPBMemberRole3" placeholder="Enter Role" style="width: 10rem;" maxlength="15"></td>
				                              			<td style="padding: 8px; width: 55%;">
				                              			<select id="RPBMemberDetails3" name="RPBMemberDetails3" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
				                              			<option value="">Select Employee</option>
				                              			</select></td>
				                              		</tr>
				                              		
				                              		<tr class="SubjectExpert">
				                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">Subject Expert<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></td>
				                              			<td style="padding: 8px; width: 13%;"><input type="text" class="form-control role-input" id="SubjectExpertRole" name="SubjectExpertRole" placeholder="Enter Role" style="width: 10rem;" maxlength="15"></td>
				                              			<td style="padding: 8px; width: 55%;">
				                              			<select id="SubjectExpertDetails" name="SubjectExpertDetails" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
				                              			<option value="">Select Employee</option>
				                              			</select></td>
				                              		</tr>
				                              		
				                              		<tr class="RPBMemberSecretary">
				                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Member Secretary<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></td>
				                              			<td style="padding: 8px; width: 15%;"><input type="text" class="form-control role-input" id="RPBMemberSecretaryRole" name="RPBMemberSecretaryRole" placeholder="Enter Role" style="width: 10rem;" maxlength="15"></td>
				                              			<td style="padding: 8px; width: 55%;">
				                              			<select id="RPBMemberSecretaryDetails" name="RPBMemberSecretaryDetails" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
				                              			<option value="">Select Employee</option>
				                              			</select></td>
				                              		</tr>
				                              		
				                              		<tr class="chairman">
				                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Chairman / Stand by Chairman<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></td>
				                              			<td style="padding: 8px; width: 15%;"><input type="text" class="form-control role-input" id="chairmanRole" name="chairmanRole" placeholder="Enter Role" style="width: 10rem;" maxlength="15"></td>
				                              			<td style="padding: 8px; width: 55%;">
				                              			<select id="chairmanDetails" name="chairmanDetails" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
				                              			<option value="">Select Employee</option>
				                              			</select></td>
				                              		</tr>
				                              		
				                              	</table>
				                              </div>
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
				        <button type="button" class="btn btn-sm submit-btn fundForwardButton" onclick="ApprovalFlowForward()">Forward</button>
				        
				        <button type="button" class="btn btn-sm btn-secondary" data-dismiss="modal" style="background-color: darkred;color:white;">Close</button>
				      </div>
				      
				      
				  </div>
				</div>
				</div>
				
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
<div class="AttachmentDetails"></div>
  <div class="row">
    <!-- Left: Attachments Table -->
    <div class="col-md-6">
      <h5 class="text-secondary" style="font-weight: 600;">Attachments</h5>
      <table class="table table-bordered table-striped mt-2" id="AttachmentModalTable">
        <thead class="thead-dark">
          <tr>
         	<th>SN</th>
            <th style="width: 60%;">Attachment Name</th>
            <th style="width: 40%; text-align: center;">Actions</th>
          </tr>
        </thead>
        <tbody id="eAttachmentModalBody" style="font-weight: 400;"></tbody>
      </table>
    </div>

    <!-- Right: File Preview Section -->
    <div class="col-md-6" id="previewSection" style="display: none;">
      <h5 class="text-primary" style="font-weight: 600;">Preview:&nbsp;&nbsp;<span  style="color:black;">(</span><span id="previewFileName" style="color:black;"></span><span  style="color:black;">)</span></h5>
      <iframe id="filePreviewIframe" style="width: 100%; height: 440px; border: 1px solid #ccc;"></iframe>
    </div>
  </div>
</div>


    </div>
  </div>
</div>


<div class="modal fade" id="ApprovalStatusModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
 <div class="modal-dialog  custom-width-modal" role="document">
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

<script src="webresources/js/RpbFundStatus.js"></script>
			
</body>
<script type="text/javascript">

<%if(success!=null){%>

	showSuccessFlyMessage('<%=success %>');

<%}else if(failure!=null){%>

	showFailureFlyMessage('<%=failure %>');

<%}%>
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

	var allEmployeeList = null;
	var committeeMemberList=null;
	var masterFlowDetails=null;
	var csrfToken = $('meta[name="_csrf"]').attr('content');
	var csrfHeader = $('meta[name="_csrf_header"]').attr('content');
	
	$.ajax({
	    url: 'GetCommitteeMemberDetails.htm',  
	    method: 'GET', 
	    beforeSend: function(xhr) {
	        xhr.setRequestHeader(csrfHeader, csrfToken);
	    },
	    success: function(response) {
	        var data = JSON.parse(response);
	        committeeMemberList = data;
	    }
	});
	
	$.ajax({
	    url: 'SelectAllemployeeAjax.htm',
	    method: 'GET',
	    beforeSend: function(xhr) {
	        xhr.setRequestHeader(csrfHeader, csrfToken);
	    },
	    success: function(responseJson) {
	        var result = JSON.parse(responseJson);
	        allEmployeeList = result;
	    }
	});
	
	const getEmployeeDetailsById = (list, id) => {
	    if (!Array.isArray(list)) return "";
	    const emp = list.find(emp => emp[0] === id);
	    return emp ? emp[2] + ", " + emp[3] : "";
	};

	
function openForwardModal(fundRequestId,estimatedCost,estimatedType,ReFbeYear,budgetHeadDescription,HeadOfAccounts,
		CodeHead,Itemnomenclature,justification,empName,designation,divisionDetails)
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
	$(".reFbeYearForward").html(ReFbeYear);
	$(".divisionDetailsForward").html(divisionDetails);
	
	$("#initiating_officer_display").val(empName +', '+designation);
	$("#FundRequestIdForward").val(fundRequestId);
	$("#EstimatedCostForward").val(estimatedCost);
	
	$.ajax({
        url: 'GetMasterFlowDetails.htm',  
        method: 'GET', 
        data: { estimatedCost : estimatedCost , fundRequestId : fundRequestId },  
        success: function(response) {
           var data = JSON.parse(response);
           masterFlowDetails=data;
           if(masterFlowDetails!=null)
	       	{
	       		$.each(masterFlowDetails, function(key, value) 
				{
			    	var idAttribute='';
			    	if(value[2]!=null)
			   		{
			    		if(value[2]=='DIVISION HEAD APPROVED')
		    			{
			    			const empDetails = getEmployeeDetailsById(allEmployeeList, value[4]);
			    			$("#divisionHeadName").val(empDetails);
			    			$("#divisionHeadDetails").val(value[4]);
		    			}
			    		else if(value[2]=='RO1 RECOMMENDED')
			       		{
			        		$(".RPBMember1").show();
			        		idAttribute='#RPBMemberDetails1';
			       		}
			    		else if(value[2]=='RO2 RECOMMENDED')
			       		{
			        		$(".RPBMember2").show();
			        		idAttribute='#RPBMemberDetails2';
			       		}
			    		else if(value[2]=='RO3 RECOMMENDED')
			       		{
			        		$(".RPBMember3").show();
			        		idAttribute='#RPBMemberDetails3';
			       		}
			    		else if(value[2]=='SE RECOMMENDED')
			       		{
			        		$(".SubjectExpert").show();
			        		idAttribute='#SubjectExpertDetails';
			       		}
			    		else if(value[2]=='RPB MEMBER SECRETARY APPROVED')
			       		{
			        		$(".RPBMemberSecretary").show();
			        		idAttribute='#RPBMemberSecretaryDetails';
			       		}
			    		else if(value[2]=='CHAIRMAN APPROVED')
			       		{
			        		$(".chairman").show();
			        		idAttribute='#chairmanDetails';
			       		}
			   		}
			    	
			    	var flowEmpId=value[4];
			    	var flowEmpRole=value[5];
			    	
			    	//Employee Role
			    	if(value[2] == 'DIVISION HEAD APPROVED')
			    	 {
			    		$("#DivisionHeadRole").val(flowEmpRole!=null && flowEmpRole!="" ? flowEmpRole : "");
			    	 }
			    	if(value[2] == 'RO1 RECOMMENDED')
			    	 {
			    		$("#RPBMemberRole1").val(flowEmpRole!=null && flowEmpRole!="" ? flowEmpRole : "");
			    	 }
			    	else if(value[2] == 'RO2 RECOMMENDED')
			    	 {
			    		$("#RPBMemberRole2").val(flowEmpRole!=null && flowEmpRole!="" ? flowEmpRole : "");
			    	 }
			    	else if(value[2] == 'RO3 RECOMMENDED')
			    	 {
			    		$("#RPBMemberRole3").val(flowEmpRole!=null && flowEmpRole!="" ? flowEmpRole : "");
			    	 }
			    	else if(value[2] == 'SE RECOMMENDED')
			    	 {
			    		$("#SubjectExpertRole").val(flowEmpRole!=null && flowEmpRole!="" ? flowEmpRole : "");
			    	 }
			    	else if(value[2] == 'RPB MEMBER SECRETARY APPROVED')
			    	 {
			    		$("#RPBMemberSecretaryRole").val(flowEmpRole!=null && flowEmpRole!="" ? flowEmpRole : "");
			    	 }
			    	else if(value[2] == 'CHAIRMAN APPROVED')
			    	 {
			    		$("#chairmanRole").val(flowEmpRole!=null && flowEmpRole!="" ? flowEmpRole : "");
			    	 }
			    	
			    	// employee details
			    	 $(idAttribute).empty().append('<option value="">Select Employee</option>');
			    	 
			    	 if(value[2] == 'RO1 RECOMMENDED' || value[2] == 'RO2 RECOMMENDED' || value[2] == 'RO3 RECOMMENDED' || value[2] == 'SE RECOMMENDED')
			    	 {
			    		 $.each(committeeMemberList, function(key, value) 
						 {
			    			 if(value[1]!=null && (value[1] == 'CM' || value[1] == 'SE'))   // CM-Committee Member
			   				 {
			    				 if(flowEmpId!=null && flowEmpId == value[2])
		    					 {
			    					 $(idAttribute).append('<option value="'+value[2]+'" selected="selected">'+ value[3] + ', '+ value[4] +'</option>');
		    					 }
			    				 else
		    					 {
		    					 	$(idAttribute).append('<option value="'+value[2]+'">'+ value[3] + ', '+ value[4] +'</option>');
		    					 }
			   				 }
						 });
			    	 }
			    	 
			    	 if(value[2] == 'RPB MEMBER SECRETARY APPROVED')
			    	 {
			    		 $.each(committeeMemberList, function(key, value) 
						 {
			    			 if(value[1]!=null && value[1] == 'CS')   // CM-Committee Secretary
			   				 {
			    				 if(flowEmpId!=null && flowEmpId == value[2])
		    					 {
			    					 $(idAttribute).append('<option  value="'+value[2]+'" selected="selected">'+ value[3] + ', '+ value[4] +'</option>');
		    					 }
			    				 else
		    					 {
			    					 $(idAttribute).append('<option  value="'+value[2]+'">'+ value[3] + ', '+ value[4] +'</option>');
		    					 }
			   				 }
						 });
			    	 }
			    	 
			    	 if(value[2] == 'CHAIRMAN APPROVED')
			    	 {
			    		 $.each(committeeMemberList, function(key, value) 
						 {
			    			 if(value[1]!=null && (value[1] == 'CC' || value[1] == 'SC'))   // CM-Committee Chairman  SC-Committee Standby Chairman
			   				 {
			    				 if(flowEmpId!=null && flowEmpId == value[2])
		    					 {
			    					 $(idAttribute).append('<option  value="'+value[2]+'" selected="selected">'+ value[3] + ', '+ value[4] +'</option>');
		    					 }
			    				 else
		    					 {
			    					 $(idAttribute).append('<option  value="'+value[2]+'">'+ value[3] + ', '+ value[4] +'</option>');
		    					 }
			   				 }
						 });
			    	 }
			    	
			    	 $("#FlowMasterIdForward").val(value[0]);
			          	
				});
	       	}
	       	else
	       		{
	       			$("#fundApprovalForardTable").append("<span style='font-weight:600;color:red;'>Something Went Wrong ..!</span>");
	       		}
        }
    });
}

const dropdownSelector = "#RPBMemberDetails1, #RPBMemberDetails2, #RPBMemberDetails3, #SubjectExpertDetails";

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


function ApprovalFlowForward() {
    let isValid = true;

    if (masterFlowDetails != null) {
        $.each(masterFlowDetails, function (key, value) {
            var idAttribute = '';
            var roleId = '';
            var message = '';

            if (value[2] != null) {
                switch (value[2]) {
                    case 'DIVISION HEAD APPROVED':
                        roleId = '#DivisionHeadRole';
                        message="Division Head";
                        break;
                    case 'RO1 RECOMMENDED':
                        idAttribute = '#RPBMemberDetails1';
                        roleId = '#RPBMemberRole1';
                        message="RPB Member";
                        break;
                    case 'RO2 RECOMMENDED':
                        idAttribute = '#RPBMemberDetails2';
                        roleId = '#RPBMemberRole2';
                        message="RPB Member";
                        break;
                    case 'RO3 RECOMMENDED':
                        idAttribute = '#RPBMemberDetails3';
                        roleId = '#RPBMemberRole3';
                        message="RPB Member";
                        break;
                    case 'SE RECOMMENDED':
                        idAttribute = '#SubjectExpertDetails';
                        roleId = '#SubjectExpertRole';
                        message="Subject Expert";
                        break;
                    case 'RPB MEMBER SECRETARY APPROVED':
                        idAttribute = '#RPBMemberSecretaryDetails';
                        roleId = '#RPBMemberSecretaryRole';
                        message="RPB Member Secretary";
                        break;
                    case 'CHAIRMAN APPROVED':
                        idAttribute = '#chairmanDetails';
                        roleId = '#chairmanRole';
                        message="RPB Chairman / Standby Chairman";
                        break;
                }
                
                // Validate role input
                if ($(roleId).length && $(roleId).val().trim() === '') {
                	showAlert('Please enter role for ' + message + '..!');
                    $(roleId).focus();
                    isValid = false;
                    return false; 
                }

                // Validate dropdown
                if ($(idAttribute).length && $(idAttribute).val().trim() === '') {
                	showAlert('Please select an employee for ' + message + '..!');
                    $(idAttribute).focus();
                    isValid = false;
                    return false; 
                }
            }
        });
    }

    if (isValid) {
    	
    	var form = $("#FundForwardForm");

		if (form) {
		    showConfirm('Are You Sure To Forward The Fund Request..?',
		        function (confirmResponse) {
		            if (confirmResponse) {
		                form.submit();
		            }
		        }
		    );
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
  $(document).ready(function () {
	    $('#RequisitionListTable').DataTable({
	        paging: true,
	        searching: true,
	        info: true,
	        lengthChange: true,
	        pageLength: 10,
	        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        order: [],
	        scrollX: true
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
 // Define function in global scope
 function openAttachmentModal(fundApprovalId, ec) {
     console.log('Opening attachment modal for ID: ' + fundApprovalId);

     var estimatedCost = $(ec).closest('tr').find('.tableEstimatedCost').text().trim() || '-';

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
  
 
  
</html>