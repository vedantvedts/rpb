<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.stream.IntStream"%>
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
<jsp:include page="../fundapproval/fundModal.jsp"></jsp:include>
<title>Fund Approval Preview</title>

<style>

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}
b
{
	font-weight: 600;
}
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
   width: 85% !important;
   transition:transform 0.5s ease;
   transform: scale(1); 
}

.spanClass
{
	font-size:16px;
	color:red;
	font-weight: 600;
}

tr:first-of-type th:first-of-type {
  border-top-left-radius: 4px;
}

tr:first-of-type th:last-of-type {
  border-top-right-radius: 4px;
}

tr:last-of-type th:first-of-type {
  border-bottom-left-radius: 4px;
}

tr:last-of-type th:last-of-type {
  border-bottom-right-radius: 4px;
}

.box-shadow-effect {
    box-shadow: rgb(239, 7, 7) 0px 0px 1px 1px;
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
  
  /* Month input feild */ 
.inputBox {
  position: relative;
  width: 16%;
  margin: 3px;
  margin-top: 5px !important;
}

.inputBox input {
  padding: 5px 20px;
  outline: none;
  color: #fff;
  font-size: 1em;
}

.inputBox span {
  position: absolute;
  left: 0;
  color:#6c757d;
  padding: 5px 20px;
  pointer-events: none;
  transition: 0.4s cubic-bezier(0.05, 0.81, 0, 0.93);
  font-weight: 600;
  margin-top: 5px;
}

.inputBox input:focus
{
	text-align: left;
	transform: scale(1.02);
}

.inputBox input:focus ~ span,
.inputBox input:valid ~ span {
  transform: translateX(14px) translateY(-7.5px);
  padding: 0 20px;
  border-radius: 2px;
  background-color: #fffbc0;
  border: 1px solid #9d2f00;
  color:#007eef;
  font-size: 11px;
  margin-top: 1px;
}

.displayPurpose:hover
{
	pointer-events: none;
} 

 
</style>
<style>
    .big-box {
        border: 2px solid #ddd; /* Border around the whole division */
        border-radius: 12px; /* Rounded corners */
        background-color: #f7f7f7; /* Light background */
        padding: 20px; /* Space inside the box */
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
        margin-top: 20px; /* Space from top elements */
    }

    .inner-box {
        margin: 10px; /* Space around the inner boxes */
    }

    .recommendation-item {
        display: flex;
        align-items: center;
        margin-bottom: 15px;
    }

    .recommendation-item > span:first-child {
        font-weight: bold;
        margin-right: 10px;
    }

    .recommendation-value {
        color: #007bff; /* Blue color for the values */
        font-weight: bold;
    }

    .no-details {
        margin-top: 20px;
        color: red;
    }
    
    .highlight-box {
    background-color: #fff7d1; 
    border: 2px solid #1890ff; /* Blue border */
    padding: 10px;
    border-radius: 5px;
}

.container {
    width: 100%;
    padding-right: 0px !important;
    padding-left: 0px !important;
    margin-right: auto;
    margin-left: auto;
}

 table.recommendation-table td {
        border: 1px solid white;
    }
    
    .remarksDetails
    {
    	color: #b502a5;
    	font-size: 12px;
    	font-weight: 600;
    	font-family: "Times New Roman", Times, serif;
    }
    
    .editRCDetails
    {
    	padding: 8px; 
    	text-align: right; 
    	font-weight: 600; white-space: nowrap; 
    	display: flex; 
    	align-items: center;
    	width: 30% !important;
    }
    
    .editRCDropDown
    {
    	padding: 8px; 
    	width: 55%;
    }
    
    .editRcDropDownSelect
    {
    	font-size: 10px; 
    	white-space: nowrap; 
    	overflow: hidden; 
    	text-overflow: ellipsis;
    }
    
    .ApprovalDetails
    {
    	padding: 11px;
    	width: 100%;
    	height:100%;
    }
    
    .rowProperties
    {
     	height:4rem;
    }
    
</style>
</head>
<body>
<%
Object[] fundDetails=(Object[])request.getAttribute("fundDetails");
List<Object[]> masterFlowDetails=(List<Object[]>)request.getAttribute("MasterFlowDetails");
List<Object[]> committeeMasterList=(List<Object[]>)request.getAttribute("AllCommitteeMasterDetails");
masterFlowDetails.forEach(row-> System.out.println(Arrays.toString(row)));
System.out.println("--------------------------");
committeeMasterList.forEach(row-> System.out.println(Arrays.toString(row)));
long empId = (Long) session.getAttribute("EmployeeId");
String currentEmpStatus=(String)request.getAttribute("employeeCurrentStatus");
FundApprovalBackButtonDto dto = (FundApprovalBackButtonDto) session.getAttribute("FundApprovalAttributes");
if(currentEmpStatus == null){
	currentEmpStatus = "NA";
}

String fundApprovalId=null;
String estimateType=null;
String finYear=null;
String initiatingOfficerId=null;
String initiatingOfficer=null;
String memberStatus=null,flowDetailsId = null;
String budgetHead=null,budgetItem=null,codeHead=null,estimatedCost=null,itemNomenclature=null,justification=null;
String rolesStr = null;
String approvalsStr = null;

if(fundDetails!=null && fundDetails.length > 0)
{
	fundApprovalId=fundDetails[0]!=null  ? fundDetails[0].toString() : "0";
	estimateType=fundDetails[1]!=null  ? fundDetails[1].toString() : null;
	finYear=fundDetails[2]!=null  ? fundDetails[2].toString() : null;
	
	initiatingOfficerId=fundDetails[18]!=null  ? fundDetails[18].toString() : "0";
	initiatingOfficer=fundDetails[19]!=null  ? fundDetails[19].toString() : null;
	
	budgetHead=fundDetails[8]!=null  ? fundDetails[8].toString() : null;
	budgetItem=fundDetails[9]!=null  ? fundDetails[9].toString() : null;
	codeHead=fundDetails[10]!=null  ? fundDetails[10].toString() : null;
	estimatedCost=fundDetails[17]!=null  ? fundDetails[17].toString() : null;
	itemNomenclature=fundDetails[14]!=null  ? fundDetails[14].toString() : null;
	justification=fundDetails[15]!=null  ? fundDetails[15].toString() : null;
	rolesStr = fundDetails[21]!=null ? fundDetails[21].toString() : null;
	approvalsStr = fundDetails[23]!=null ? fundDetails[23].toString() : null;
	
} %>


	<% String budgetYear = null,budgetYearType = null;
	if(dto.getEstimatedTypeBackBtn()!=null)
	{
		if(dto.getEstimatedTypeBackBtn().equalsIgnoreCase("F"))
		{
			budgetYear=dto.getFBEYear();
			budgetYearType="FBE Year";
		}
		else if(dto.getFromYearBackBtn()!=null && dto.getToYearBackBtn()!=null)
		{
			budgetYear=dto.getFromYearBackBtn()+"-"+dto.getToYearBackBtn();
			budgetYearType="RE Year";
		}
		
	}
	else
	{
		budgetYear="-";
		budgetYearType="***";
	}%>
	
<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-5"><h5><%if(estimateType!=null && estimateType.equalsIgnoreCase("F")){ %>Forecast Budget Estimate<%}else if(estimateType!=null && estimateType.equalsIgnoreCase("R")){ %>Revised Estimate<%} %> Preview&nbsp;<span style="color:#057480;"><%if(finYear!=null){ %> (<%=finYear %>) <%} %></span></h5></div>
	      <div class="col-md-7">
	    	 <ol class="breadcrumb" style="justify-content: right !important;">
	    	 <li class="breadcrumb-item"><a href="FundRequest.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i>Requisition List </a></li>
	    	 <li class="breadcrumb-item">
	         	<a	href="FundApprovalList.htm"> <% if(currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CM") || currentEmpStatus.equalsIgnoreCase("DH")){ %> Recommend
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%}else{ %> NA <%} %> List</a>
	         </li>
	         <li class="breadcrumb-item active" aria-current="page"><%if(estimateType!=null && estimateType.equalsIgnoreCase("F")){ %> FBE <%}else if(estimateType!=null && estimateType.equalsIgnoreCase("R")){ %> RE <%} %> Item</li>
             </ol>
           </div>
         </div>
       </div> 

  <%String success=(String)request.getParameter("resultSuccess"); 
   String failure=(String)request.getParameter("resultFailure");%>  
			
<div class="page card dashboard-card" style="background-color:white;padding-top: 0px;padding-left: 0px;padding-right: 0px;width: 98%;margin: auto;margin-top: 8px;">		

<div class="container">
    <div class="row" style="margin-left:0px !important;margin-right:0px !important;">
        <div class="col-md-12">
        	  <div class="flex-container" style="margin-top:7px !important;background-color:#ffedc6;height: auto;width: 99%;margin: auto;box-shadow: 0px 0px 4px #6b797c;">
	           		<div class="form-inline" style="padding: 10px;">
	           		
	           			<label style="font-size: 19px;"><b> <%=budgetYearType %> :&nbsp;</b></label><span class="spanClass"> <%=budgetYear %> </span>
	           		</div>
	           		<div class="form-inline" style="padding: 10px;">
	           			
	           			<label style="font-size: 19px;"><b>Division :&nbsp;</b></label><span class="spanClass"><% if(dto!=null && dto.getDivisionName()!=null){%><%=dto.getDivisionName() %>&nbsp;<%}else{ %>-<%} %><% if(dto!=null && dto.getDivisionCode()!=null){%>(<%=dto.getDivisionCode() %>)<%}%></span>
	           		
	           		</div>
	           </div>
        
            <!-- Big Division -->
            <div class="big-box">
            	<div class="row">
            		<div class="table-responsive">
		          <table class="table table-bordered" style="font-weight: 600;width: 91.5% !important;margin:auto !important;" id="ApprovalDetailsTable">
		            <tr>
		              <td style="color:#034189;">Budget</td>
		              <td class="BudgetDetails">GEN (General)</td>
		              <td style="color:#034189;">Budget Head</td>
		              <td class="BudgetHeadDetails"><%if(budgetHead!=null){ %> <%=budgetHead %> <%}else{ %> - <%} %></td>
		            </tr>
		            <tr>
		              <td style="color:#034189;">Budget Item</td>
		              <td class="budgetItemDetails"><%if(budgetItem!=null){ %> <%=budgetItem %> <%}else{ %> - <%} %></td>
		               <td style="color:#034189;">Estimated Cost</td>
		              <td class="EstimatedCostDetails"><%if(estimatedCost!=null){ %> <%=AmountConversion.amountConvertion(estimatedCost, "R") %> <%}else{ %> - <%} %></td>
		            </tr>
		            <tr>
		              <td style="color:#034189;">Item Nomenclature</td>
		              <td colspan="3" class="ItemNomenclatureDetails"><%if(itemNomenclature!=null){ %> <%=itemNomenclature %> <%}else{ %> - <%} %></td>
		            </tr>
		            <tr>
		              <td style="color:#034189;">Justification</td>
		              <td colspan="3" class="JustificationDetails"><%if(justification!=null){ %> <%=justification %> <%}else{ %> - <%} %></td>
		            </tr>
		          </table>
	          </div>
            	</div>
            	
            	  <div style="font-weight: 600;color:black;margin:10px;"> Attachments: 
		          	<span class="attachementLink">
                           
                     </span>
		          </div>
            	
            	
                <div class="row">
                    <!-- Left Division -->
                    <div class="col-md-6">
                        <table class="table recommendation-table" border="1" style="width:100%; border-collapse: collapse;margin-bottom:0px !important;">
					    <% if (initiatingOfficer != null) { %>
					        <tr>
					            <td style="width:40%;"><b>Initiated By</b></td>
					            <td style="width:60%;" class="recommendation-value">
					                <%= initiatingOfficer %>
					            </td>
					        </tr>
					    <% } %>
					    
					    <%if(masterFlowDetails != null){ %>
					    
						    <% for(Object[] masterList : masterFlowDetails){ 
						    
						    boolean isCurrentEmp = masterList[3] != null && empId == (Long.parseLong(masterList[3].toString()));
						    boolean isApproved = masterList[4] != null && (masterList[4].toString().equalsIgnoreCase("Y"));
						    %>
						    
						    	<tr <%if(isCurrentEmp){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b><%=masterList[2] %></b>
					            <% if(masterList[8] != null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(isCurrentEmp){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%=masterList[6]!=null ? masterList[6] : "-" %><%= masterList[7] != null ? ", "+masterList[7] : "" %>
					                <%if(isCurrentEmp){ %>
					                    <%if(!isApproved){ %><span class="badge badge-info"><%=masterList[9] != null ? masterList[9] : "" %></span><%} %>
					                <%} %>
					                <%if(masterList[4]!=null && (masterList[4].toString()).equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>
					                
					                <% if(masterList[8] != null){ %> <br> <span class="remarksDetails">&nbsp;<%=masterList[8] %></span> <%} %>
					                
					            </td>
					        </tr>
						    
						    <%} %>
					    
					    <%} %>
					
					</table>
                        
                    </div>
                    
                    <!-- Right Division -->
                    <div class="col-md-6">
                    
                     <% String memberType = null;
                       String dhDetails = null,csDetails = null,ccDetails = null;
                       boolean dhStatus=false,csStatus=false,ccStatus = false,rcStatus =false;
                       if(rolesStr != null && approvalsStr != null)
                       {
                       	dhDetails = Arrays.stream(rolesStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("DH")).findFirst().orElse("NA");
                       	csDetails = Arrays.stream(rolesStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("CS")).findFirst().orElse("NA");
                       	ccDetails = Arrays.stream(rolesStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("CC")).findFirst().orElse("NA");
                       	
                            String input = "RC"; 
                            Set<String> rcFilter = Set.of("CM", "SE");

                            String[] roles = rolesStr.split(",");
                            String[] approvals = approvalsStr.split(",");

                            List<String[]> filtered = IntStream.range(0, roles.length)
                                    .filter(i -> input.equals("RC") && rcFilter.contains(roles[i]))
                                    .mapToObj(i -> new String[]{roles[i], approvals[i]})
                                    .collect(Collectors.toList());

                            String rcApprovalDetails = filtered.stream().map(a -> a[1]).collect(Collectors.joining(","));
                            
                            dhStatus = dhDetails.equalsIgnoreCase("Y");
                            csStatus = csDetails.equalsIgnoreCase("Y");
                            ccStatus = ccDetails.equalsIgnoreCase("Y");
                            rcStatus = rcApprovalDetails.contains("N");
                       }
                       %>
						  
						<%String tooltip = "";
						boolean showPending = false;
						
						switch(currentEmpStatus.toUpperCase()) {
						    case "CS":
						        showPending = !(dhStatus && rcStatus);
						        tooltip = "Preview & Note";
						        break;
						    case "CC":
						        showPending = !(dhStatus && rcStatus && ccStatus);
						        tooltip = "Preview & Approve";
						        break;
						}
						%>
									
						<%if(!showPending){ %>
                    
                        <div class="inner-box">
                            <div align="center">
                                <form id="fbeForm" action="CommitteeMemberAction.htm">
								    <input type="hidden" id="EmpId" name="EmpId" value="<%=empId%>"/>
									<input type="hidden" id="csrfParam" name="${_csrf.parameterName}" value="${_csrf.token}"/>
								    
								    <input type="hidden" name="memberStatus" value="<%=memberStatus %>">
								    <input type="hidden" name="flowDetailsId" value="<%=flowDetailsId %>">
								    
								    <div class="row" style="margin-bottom: 35px; margin-top: 20px;">
								        <b>Remarks :</b><br>
								        <textarea rows="3" cols="65" maxlength="1000" class="form-control" name="remarks" id="remarksarea"></textarea>
								    </div>
								    
								    <input type="hidden" name="fundApprovalId" value="<%=fundApprovalId%>">
								    <input type="hidden" name="initiating_officer" <%if(initiatingOfficerId != null){ %> value="<%=initiatingOfficerId%>" <%} %>>
								
										<% // A - Approver, RE - Recommender, DA - Division Head Approver %>
								    
								        <button type="button" class="btn btn-primary btn-sm submit" <% if (currentEmpStatus.equalsIgnoreCase("CC")) { %> onclick="confirmAction('Approve','A')" <%}else if(currentEmpStatus.equalsIgnoreCase("DH")) { %> onclick="confirmAction('Recommend','DA')" <%}else { %> onclick="confirmAction('Recommend','RE')" <%} %>>
									         <% if(currentEmpStatus.equalsIgnoreCase("CC")){ %> Approve 
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CM")  || currentEmpStatus.equalsIgnoreCase("DH")){ %> Recommend
									         <%}else if(currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%}else{ %> Recommend<%} %>
								        </button>
								        
								    <button type="button" class="btn btn-sm btn-danger" onclick="confirmAction('Return','R')">
									        Return
									</button>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<%-- <button type="button" class="btn btn-sm" style="background-color: #ffb256;" onclick="openChatBox(<%=fundApprovalId%>)">
									        Query
									</button> --%>
								    <img id="ForwardButton" onclick="openChatBox(<%=fundApprovalId%>)" data-tooltip="Send / Receive Queries" data-position="left" data-toggle="tooltip" class="btn-sm tooltip-container" src="view/images/messageGreen.png" width="45" height="35" style="cursor:pointer; background: transparent; padding: 8px; padding-top: 0px; padding-bottom: 0px;">
								</form>

                            </div>
                        </div>
                        
                       <% }else { %>
                       
                       <div class="RCPendingDiv" style="text-align: center; height: 100%; display: grid;place-items: center;box-shadow: 0px 0px 4px #cbcbcb;border-radius: 3px;">
                       <span style="color:#4a036c; border-radius:10px; padding:10px 9px; background:#eadcff; font-size:13px; font-weight:800;"> Recommendation Pending </span>
                        <% // Edit the Recommending Officer %>
                        <div >
	                         <span style="font-weight:600;color:#000048;">Click Edit Button To Change Recommending Officer(s)</span><br>
	                         <button type="button" data-tooltip="Change Recommending Officer(s)" data-position="top" class="btn btn-sm icon-btn tooltip-container" style="padding:6px;border: 1px solid #895912;background: #ffe0c4;margin: 10px;" onclick="EditRecommendingDetailsAction('O')"> Edit &nbsp;&#10097;&#10097; </button>
                        </div>
                       </div>
                       
                        <div class="EditRCDetails" style="text-align: center; height: 100%;box-shadow: 0px 0px 4px #cbcbcb;border-radius: 3px;display:none;">
                        	<div class="card ApprovalDetails table-responsive"> 
                              	<table style="width: 100%;" id="fundApprovalForardTable">
                              		
                              		  <%if(masterFlowDetails != null){ %>
					    
									    <% for(Object[] masterFlowList : masterFlowDetails){ 
									    
									    boolean isCurrentEmp = masterFlowList[3] != null && empId == (Long.parseLong(masterFlowList[3].toString()));
									    boolean isApproved = masterFlowList[4] != null && (masterFlowList[4].toString().equalsIgnoreCase("Y"));
									    
									    %>
									    
									    	<tr>
									    	<td class="editRCDetails"><%=masterFlowList[2] %></td>
								            <td class="recommendation-value editRCDropDown">
									              
									            <% if(!isApproved){ %>
		                              			<select id="<%=masterFlowList[10]!=null ? masterFlowList[10] : ""  %>" name="divisionHeadDetails" class="form-control select2 editRcDropDownSelect" style="width: 100%;">
		                              			<option value="">Select Employee</option>
		                              			<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
		                              				<%for(Object[] masterList: committeeMasterList){ %>
		                              					<%if(masterList[3]!=null){ %>
		                              						<option value="<%=masterList[2] %>" <%if(isCurrentEmp){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
		                              					<%} %>
		                              				<%} %>
		                              			<%} %>
		                              			</select>
		                              			<%}else{ %>
		                              			
		                              				<input type="text" class="form-control" readonly="readonly" value="<%=masterFlowList[6]!=null ? masterFlowList[6] : "-" %><%= masterFlowList[7] != null ? ", "+masterFlowList[7] : "" %>">
		                              			
		                              			<%} %>
								                
								            </td>
								        </tr>
									    
									    <%} %>
									    
									   <tr>
                              			<td colspan="2" class="rowProperties">
                              				<input class="btn btn-sm submit-btn" type="button" id="submiting" value="Update" onclick="validateFormFieldsEdit()"> &nbsp;
                              				<input type="button" class="btn btn-sm back-btn" value="Back" onclick="EditRecommendingDetailsAction('C')">
                              			</td>
                              			
                              		</tr>
								    
								    <%} %>
                              		
                              	</table>
                              	
                              </div>
                              
	                        </div>
	                       
	                       <%} %>
	                          
	                    </div>
	                </div>
	            </div>


	        </div>
	    </div>
	</div>

				
</div>			
</body>

<script type="text/javascript">

function EditRecommendingDetailsAction(actionType)
{
	if(actionType == 'O')
	{
		$(".EditRCDetails").show();
		$(".RCPendingDiv").hide();
	}
	else if(actionType == 'C')
	{
		$(".EditRCDetails").hide();
		$(".RCPendingDiv").show();
	}
}

</script>

<script type="text/javascript">

<%if(success!=null){%>

	showSuccessFlyMessage('<%=success %>');

<%}else if(failure!=null){%>

	showFailureFlyMessage('<%=failure %>');

<%}%>
</script>

<script>

function confirmAction(action,value) {
    const remarksarea = $('#remarksarea').val().trim();
    
    if (value === 'R' && remarksarea === '') {
        alert('Please enter the remarks...!');
        $('#remarksarea').focus();
        return false;
    } else if (confirm("Are you sure to "+action+"...?")) {
        const form = $('#fbeForm');
        const actionInput = $('<input>', {
            type: 'hidden',
            name: 'Action',
            value: value
        });
        form.append(actionInput);
        form.submit();
    }
}
</script>

<script type="text/javascript">

$(document).ready(function(){
	
	getAttachementDetailsInline('<%=fundApprovalId %>');
});

</script>

<script>
var refreshInterval = null;
var lastMessageCount = 0;

function openChatBox(fundApprovalId) {
    var box = document.getElementById("chatBoxContainer");
    box.style.display = "flex";

    // small delay for animation
    setTimeout(() => {
        box.style.opacity = "1";
        box.style.transform = "translateY(0) scale(1)";
    }, 10);

    loadQueries(fundApprovalId);
    startAutoRefresh(fundApprovalId);
}

function closeChatBox() {
    var box = document.getElementById("chatBoxContainer");
    box.style.opacity = "0";
    box.style.transform = "translateY(30px) scale(0.95)";

    // hide after animation
    setTimeout(() => {
        box.style.display = "none";
    }, 300);

    if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = null;
    }
}

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
                    for (var i = lastMessageCount; i < data.length; i++) {
                        var row = data[i];
                        var empId = row[1];      
                        var empName = row[2];
                        var designation = row[3];
                        var message = row[5];
                        var actionDate = row[6];

                        // remove seconds
                        actionDate = actionDate.replace(/:\d{2}\s/, " ");

                        var wrapper = document.createElement("div");
                        wrapper.style.clear = "both";
                        wrapper.style.marginBottom = "8px";

                        if (empId == currentEmpId) {
                            wrapper.style.textAlign = "right"; 

                            var msgDiv = document.createElement("div");
                            msgDiv.style.padding = "6px 8px";
                            msgDiv.style.background = "#034189";
                            msgDiv.style.color = "#fff";
                            msgDiv.style.borderRadius = "8px";
                            msgDiv.style.display = "inline-block";
                            msgDiv.style.maxWidth = "60%";
                            msgDiv.style.wordWrap = "break-word";

                            msgDiv.innerHTML =
                                "<div style='text-align: left;'><b></b> " + message + "</div>" +
                                "<div style='font-size:11px; color:#f0d890; text-align:right; margin-top:2px;'>" + actionDate + "</div>";

                            wrapper.appendChild(msgDiv);

                        } else {
                            wrapper.style.textAlign = "left"; 

                            var msgDiv = document.createElement("div");
                            msgDiv.style.padding = "6px 8px";
                            msgDiv.style.background = "#e9ecef";
                            msgDiv.style.color = "#000";
                            msgDiv.style.borderRadius = "8px";
                            msgDiv.style.display = "inline-block";
                            msgDiv.style.maxWidth = "60%";
                            msgDiv.style.wordWrap = "break-word";

                            msgDiv.innerHTML =
                                "<div><b>" + empName + ", " + designation + "</b>: " + message + "</div>" +
                                "<div style='font-size:11px; color:#a78432; text-align:right; margin-top:2px;'>" + actionDate + "</div>";

                            wrapper.appendChild(msgDiv);
                        }

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

function startAutoRefresh(fundApprovalId) {
    refreshInterval = setInterval(function() {
        loadQueries(fundApprovalId);
    }, 3000); 
}

document.addEventListener("DOMContentLoaded", function () {
    var input = document.getElementById("chatInput");
    input.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            e.preventDefault(); 
            sendQuery(<%=fundApprovalId%>);
        }
    });
});

function sendQuery(fundApprovalId) {
    var input = document.getElementById("chatInput");
    var msg = input.value.trim();
    if (msg !== "") {
        var csrfParam = document.getElementById("csrfParam").name;
        var csrfToken = document.getElementById("csrfParam").value;

        var requestData = {
            fundApprovalId: fundApprovalId,
            Query: msg
        };
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
                    "<div style='text-align: left;'><b></b> " + msg + "</div>" +
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
}


</script>

</html>

