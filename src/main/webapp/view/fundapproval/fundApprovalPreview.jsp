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
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
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
    .rcSkipped-box {
    background-color: #dddddd; 
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
    	width: 70%;
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
    
    .secRcEditButton
    {
    	margin-top : 10px;
    }
    
    .RcRemarks
    {
     font-weight: 600;
     color:red;
    }
    
    @media (min-width: 1200px) {
	    .container {
	        max-width: 1500px;
	    }
	}
	
	@media (min-width: 768px) {
	    .container {
	        max-width: 1500px;
	    }
	}
	
	.rcEditinlineDropDown
	{
		width: auto;
		min-width: 95% !important;
		margin-left: 7px;
	}
	.rcEditinlineDropDownDefault
	{
		width: auto;
		min-width: 100% !important;
	}
	
	.rcEditReasonDropDown
	{
		width: auto;
		min-width: 26% !important;
		margin-left: 7px;
	}
	
	.rcEditinlineDropDownLoad
	{
		width: auto;
		min-width:68% !important;
		margin-left:4px;
	}
	
	.rcEditinlineinput
	{
		width: auto;
		min-width: 100% !important;
	}
	
	#remarksarea
	{
		margin-left: 10px;
	}
	
	  .note {
      background: #fff8c4;
      border-left: 8px solid #ffcc00;
      padding: 10px 15px;
      border-radius: 4px;
      font-size: 14px;
      color: #333;
      max-width: 100%;
      text-align: left;
      font-weight: 600;
    }
    
    .note_content
    {
     color : red;
    }
    
</style>

<style>
  .checkbox-wrapper-26 * {
    -webkit-tap-highlight-color: transparent;
    outline: none;
  }

  .checkbox-wrapper-26 input[type="checkbox"] {
    display: none;
  }

  .checkbox-wrapper-26 label {
    --size: 20px;
    --shadow: calc(var(--size) * .07) calc(var(--size) * .1);

    position: relative;
    display: block;
    width: var(--size);
    height: var(--size);
    margin: 0 auto;
    background-color: #95006e;
    border-radius: 50%;
    box-shadow: 0 var(--shadow) #ffbeb8;
    cursor: pointer;
    transition: 0.2s ease transform, 0.2s ease background-color,
      0.2s ease box-shadow;
    overflow: hidden;
    z-index: 1;
  }

  .checkbox-wrapper-26 label:before {
    content: "";
    position: absolute;
    top: 50%;
    right: 0;
    left: 0;
    width: calc(var(--size) * .7);
    height: calc(var(--size) * .7);
    margin: 0 auto;
    background-color: #fff;
    transform: translateY(-50%);
    border-radius: 50%;
    box-shadow: inset 0 var(--shadow) #ffbeb8;
    transition: 0.2s ease width, 0.2s ease height;
  }

  .checkbox-wrapper-26 label:hover:before {
    width: calc(var(--size) * .55);
    height: calc(var(--size) * .55);
    box-shadow: inset 0 var(--shadow) #ff9d96;
  }

  .checkbox-wrapper-26 label:active {
    transform: scale(0.9);
  }

  .checkbox-wrapper-26 .tick_mark {
    position: absolute;
    top: 0px;
    right: 0;
    left: calc(var(--size) * -.05);
    width: calc(var(--size) * .6);
    height: calc(var(--size) * .6);
    margin: 0 auto;
    margin-left: calc(var(--size) * .14);
    transform: rotateZ(-40deg);
  }

  .checkbox-wrapper-26 .tick_mark:before,
  .checkbox-wrapper-26 .tick_mark:after {
    content: "";
    position: absolute;
    background-color: #fff;
    border-radius: 2px;
    opacity: 0;
    transition: 0.2s ease transform, 0.2s ease opacity;
  }

  .checkbox-wrapper-26 .tick_mark:before {
    left: 0;
    bottom: 0;
    width: calc(var(--size) * .1);
    height: calc(var(--size) * .3);
    box-shadow: -2px 0 5px rgba(0, 0, 0, 0.23);
    transform: translateY(calc(var(--size) * -.68));
  }

  .checkbox-wrapper-26 .tick_mark:after {
    left: 0;
    bottom: 0;
    width: 100%;
    height: calc(var(--size) * .1);
    box-shadow: 0 3px 5px rgba(0, 0, 0, 0.23);
    transform: translateX(calc(var(--size) * .78));
  }

  .checkbox-wrapper-26 input[type="checkbox"]:checked + label {
    background-color: #07d410;
    box-shadow: 0 var(--shadow) #92ff97;
  }

  .checkbox-wrapper-26 input[type="checkbox"]:checked + label:before {
    width: 0;
    height: 0;
  }

  .checkbox-wrapper-26 input[type="checkbox"]:checked + label .tick_mark:before,
  .checkbox-wrapper-26 input[type="checkbox"]:checked + label .tick_mark:after {
    transform: translate(0);
    opacity: 1;
  }
</style>
</head>
<body>
<%
Object[] fundDetails=(Object[])request.getAttribute("fundDetails");
List<Object[]> masterFlowDetails=(List<Object[]>)request.getAttribute("MasterFlowDetails");
List<Object[]> committeeMasterList=(List<Object[]>)request.getAttribute("AllCommitteeMasterDetails");
List<Object[]> employeeList=(List<Object[]>)request.getAttribute("AllEmployeeDetails");


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
String memberStatus=null;
String budgetHead=null,budgetItem=null,codeHead=null,estimatedCost=null,itemNomenclature=null,justification=null;
String rolesStr = null;
String approvalsStr = null;
String skipsStr = null;
String linkedMemberIdsStr = null;
String empIdsStr = null;

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
	skipsStr = fundDetails[28]!=null ? fundDetails[28].toString() : null;
	linkedMemberIdsStr = fundDetails[29]!=null ? fundDetails[29].toString() : null;
	empIdsStr = fundDetails[22]!=null ? fundDetails[22].toString() : null;
	
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
                    <div class="col-md-5">
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
						    String isSkippedStatus = masterList[12]!=null ? masterList[12].toString() : "N";
						    %>

						    	<tr <%if(isCurrentEmp){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b><%=masterList[2] %>&nbsp;<%if(isSkippedStatus.equalsIgnoreCase("Y")){ %><span>Skipped</span> <%} %></b>
					            <% if(masterList[8] != null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(isCurrentEmp){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%=masterList[6]!=null ? masterList[6] : "-" %><%= masterList[7] != null ? ", "+masterList[7] : "" %>
					                <%if(isCurrentEmp){ %>
					                    <%if(!isApproved){ %><span class="badge badge-info"><%=masterList[9] != null ? masterList[9] : "" %></span><%} %>
					                <%} %>
					                
					                <%if(isSkippedStatus.equalsIgnoreCase("N")){ %>
					                
					                <%if(masterList[4]!=null && (masterList[4].toString()).equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>

					                <% if(masterList[8] != null){ %> <br> <span class="remarksDetails">&nbsp;<%=masterList[8] %></span> <%} %>
					                
					                <%}else{ %>
					                
					                 <% if(masterList[14] != null){ %><span class="remarksDetails">(Reason : <%=masterList[14] %>)</span> <%} %>
					                
					                <%} %>

					            </td>
					        </tr>

						    <%} %>

					    <%} %>

					</table>

                    </div>

                    <!-- Right Division -->
                    <div class="col-md-7">
                    
                    <%String[] linkedMembers = linkedMemberIdsStr.split(",");
                    String[] empIds = empIdsStr.split(",");
                    
                    System.out.println("linkedMembers---"+Arrays.toString(linkedMembers));
                    System.out.println("empIds---"+Arrays.toString(empIds));
                    System.out.println("empId---"+empId);
                    
                    String linkedMemberId = IntStream.range(0, linkedMembers.length)
                    	    .filter(i -> empIds[i]!=null && Long.parseLong((empIds[i].toString())) == (empId)).mapToObj(i -> linkedMembers[i]).findFirst().orElse(null);
                    
                    %>

                     <% String memberType = null, rcApprovalDetails = null, rcSkippedDetails = null;
                       String dhDetails = null,csDetails = null,ccDetails = null;
                       boolean dhStatus=false,csStatus=false,ccStatus = false,rcStatus =false;
                       if(rolesStr != null && approvalsStr != null)
                       {
                       	dhDetails = Arrays.stream(approvalsStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("DH")).findFirst().orElse("NA");
                       	csDetails = Arrays.stream(approvalsStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("CS")).findFirst().orElse("NA");
                       	ccDetails = Arrays.stream(approvalsStr.split(",")).skip(Arrays.asList(rolesStr.split(",")).indexOf("CC")).findFirst().orElse("NA");
                       	
                            Set<String> rcFilter = Set.of("CM", "SE");

                            String[] roles = rolesStr.split(",");
                            String[] approvals = approvalsStr.split(",");
                            String[] skips = skipsStr.split(",");
                            
                            List<String[]> filtered = IntStream.range(0, roles.length)
                                    .filter(i -> rcFilter.contains(roles[i]))
                                    .mapToObj(i -> new String[]{roles[i],(skips[i]!=null && skips[i].equalsIgnoreCase("Y") ? "Y" : approvals[i])})
                                    .collect(Collectors.toList());

                            rcApprovalDetails = filtered.stream() .map(a -> a[1]).collect(Collectors.collectingAndThen( Collectors.joining(","), s -> s.isEmpty() ? "NA" : s));
                            
                            System.out.println("rcApprovalDetails---BEFORE---"+rcApprovalDetails);
                            
                            dhStatus = dhDetails.equalsIgnoreCase("N");
                            csStatus = csDetails.equalsIgnoreCase("N");
                            rcStatus = rcApprovalDetails!=null && rcApprovalDetails.equalsIgnoreCase("NA") ? true : rcApprovalDetails.contains("N");
                            
                            System.out.println("-----------itemNomenclature----------"+itemNomenclature);
                            System.out.println("dhDetails------"+dhDetails);
                            System.out.println("rcApprovalDetails---After---"+rcApprovalDetails);
                            System.out.println("approvalsStr------"+approvalsStr);
                            System.out.println("rolesStr------"+rolesStr);
                            System.out.println("dhStatus------"+dhStatus);
                            System.out.println("csStatus------"+csStatus);
                            System.out.println("rcStatus------"+rcStatus);
                       }
                       %>

						<%boolean showPending = false;

						
						switch(currentEmpStatus.toUpperCase()) {
						    case "CS":
						        showPending = (dhStatus || (rcApprovalDetails.equalsIgnoreCase("NA") ? false : rcStatus));

						        break;
						    case "CC":
						        showPending = (dhStatus || (rcApprovalDetails.equalsIgnoreCase("NA") ? false : rcStatus) || csStatus);

						        break;
						}
						%>
						
						<%System.out.println("showPending------"+showPending); %>

						<%if(!showPending){ %>

                        <div class="inner-box">
                            <div align="center">

                               <div class="reccReturnDiv">
	                               <form id="fbeForm" action="CommitteeMemberAction.htm">
	                               
									    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
									    
									    <div class="form-inline" style="margin-bottom: 35px; margin-top: 20px;">
									        <b>Remarks :</b><br>
									        <textarea rows="3" cols="65" maxlength="1000" class="form-control" name="remarks" id="remarksarea"></textarea>
									    </div>
				    			    <input type="hidden" id="EmpId" name="EmpId" value="<%=empId%>"/>
									<input type="hidden" id="csrfParam" name="${_csrf.parameterName}" value="${_csrf.token}"/>
									    <input type="hidden" name="fundApprovalId" value="<%=fundApprovalId%>">
									    <input type="hidden" name="MemberLinkedId" value="<%=linkedMemberId%>">
									    <input type="hidden" name="initiating_officer" <%if(initiatingOfficerId != null){ %> value="<%=initiatingOfficerId%>" <%} %>>
									
											<% // A - Approver, RE - Recommender, DA - Division Head Approver %>
											
											<% if(currentEmpStatus.equalsIgnoreCase("DH") || currentEmpStatus.equalsIgnoreCase("CS")){ %>
									    		<button type="button" data-tooltip="Change Recommending Officer(s)" data-position="top"  class="btn btn-sm revise-btn tooltip-container" onclick="EditRecommendingDetailsAction('O')">Committee Members Edit</button>
									    	&nbsp;<%} %>
									    	
									    	 <% String actionName = "", action= "A";
									        if (currentEmpStatus.equalsIgnoreCase("CC")) 
									        {
									        	actionName = "Approve";
									        }
									        else if(currentEmpStatus.equalsIgnoreCase("CM") || currentEmpStatus.equalsIgnoreCase("DH"))
									        {
									        	actionName = "Recommend";
									        }
									        else if(currentEmpStatus.equalsIgnoreCase("CS"))
									        {
									        	actionName = "Noting";
									        }
									        else
									        {
									        	actionName = "Recommend";
									        }
									        %>
									    
									        <button type="button" class="btn btn-primary btn-sm submit" onclick="confirmActionFromMember('<%=actionName %>','<%=currentEmpStatus %>','<%=action %>')">
									        <%=actionName %>
									        </button> &nbsp;
									    
									    <% if(currentEmpStatus.equalsIgnoreCase("CS") || currentEmpStatus.equalsIgnoreCase("CC") || currentEmpStatus.equalsIgnoreCase("SC")){ %>
										    <button type="button" class="btn btn-sm btn-danger" onclick="confirmActionFromMember('Return','<%=currentEmpStatus %>','R')">
											        Return
											</button>  &nbsp;
										<%} %>
										
											  	<img id="ForwardButton_<%=fundApprovalId%>" onclick="openChatBox(<%=fundApprovalId%>, 'ForwardButton_<%=fundApprovalId%>')" data-tooltip="Click to see Queries" data-position="left" data-toggle="tooltip" class="btn-sm tooltip-container" src="view/images/messageGreen.png" width="45" height="35" style="cursor:pointer; background: transparent; padding: 8px; padding-top: 0px; padding-bottom: 0px;">
									    
									</form>
                               </div>


							<div class="EditRCDetailsDH" style="text-align: center; height: 100%;box-shadow: 0px 0px 4px #cbcbcb;border-radius: 3px;display:none;">
                        	<div class="card ApprovalDetails table-responsive"> 
                              	
                              	<form id="editRcDetailsForm" action="#">
	                               
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
								<input type="hidden" name="fundApprovalIdEdit" value="<%=fundApprovalId %>"/>
                              	
                              	<table style="width: 100%;" id="fundApprovalForardTable">
                              	
                              		<%long isCMorSEApproved = masterFlowDetails.stream()
                              		    .filter(row -> ((row[1]!=null && ("CM".equalsIgnoreCase(row[1].toString()) || "SE".equalsIgnoreCase(row[1].toString()))) 
                              		    		&& (row[4] != null && "N".equalsIgnoreCase(row[4].toString()))))
                              		    .count(); %>
                              		    
                              		<%long isDHApproved = masterFlowDetails.stream()
                              		    .filter(row -> row[1]!=null && "DH".equalsIgnoreCase(row[1].toString()) 
                              		    		&& row[4] != null && "Y".equalsIgnoreCase(row[4].toString()))
                              		    .count(); %>
                              	
	                              	<%if(isCMorSEApproved > 0 && isDHApproved > 0){ %>
	                              		<tr>
	                              		<td colspan="2">
	                              		 <div class="note">Notes : <span class="note_content">Select the radio button to either skip or include the Recommending Officer.</span></div>
	                              		</td>
	                              		</tr>
	                              		
	                              		<%} %>
                              		
                              		
                              		  <%if(masterFlowDetails != null){ %>
					    
									    <% for(Object[] masterFlowList : masterFlowDetails){ 
									    
									    boolean isCurrentEmp = masterFlowList[3] != null && empId == (Long.parseLong(masterFlowList[3].toString()));
									    boolean isApproved = masterFlowList[4] != null && (masterFlowList[4].toString().equalsIgnoreCase("Y"));
									    String masterMemberType = masterFlowList[2]!=null ? masterFlowList[1].toString() : "NA";
									    boolean mainAuthority = (masterMemberType.equalsIgnoreCase("CS") || (masterMemberType.equalsIgnoreCase("CC") && !currentEmpStatus.equalsIgnoreCase("CS") ));
									    String rcEmpId = masterFlowList[3] != null ? masterFlowList[3].toString() : "0";
									    boolean isMemberTypeCMorSE = masterMemberType.equalsIgnoreCase("CM") || masterMemberType.equalsIgnoreCase("SE");
									    String isSkippedStatus = masterFlowList[12]!=null ? masterFlowList[12].toString() : "N";
									    String reasonType = masterFlowList[13]!=null ? masterFlowList[13].toString() : "N";
									    boolean committeeAction = true;
									    %>
									    
									    	<tr>
									    	<td class="editRCDetails"><%=masterFlowList[2] %>
									    	<input type="hidden" name="MemberLinkedIdEdit" value="<%=masterFlowList[5] %>"/>
									    	</td>
								            <td class="recommendation-value editRCDropDown">
								            
								            <div class="form-inline">
								            
								            <% 
								            System.out.println("isMemberTypeCMorSE-----"+isMemberTypeCMorSE);
								            System.out.println("isCMorSEApproved-----"+isCMorSEApproved);
								            System.out.println("isDHApproved-----"+isDHApproved);
								            System.out.println("isApproved--#######################---"+isDHApproved);
								            %>
								            
								            <%if(isMemberTypeCMorSE && isCMorSEApproved > 0 && isDHApproved > 0){ %>
								            
								            <%if(!isApproved){ %>
								              <div class="checkbox-wrapper-26">
												  <input type="hidden" id="CheckBoxHidden-<%=masterFlowList[5] %>" name="SkipReccEmpStatus" value="<%=isSkippedStatus %>">
												  <input type="checkbox" id="CheckBox-<%=masterFlowList[5] %>" class="form-control" onclick="displayReasonDropDown('<%=masterFlowList[5] %>','<%=masterFlowList[10]!=null ? masterFlowList[10] : ""  %>')" <%if(isSkippedStatus.equalsIgnoreCase("Y")){ %> checked="checked" <%} %>>
												  <label for="CheckBox-<%=masterFlowList[5] %>" class="tooltip-container" data-tooltip="Click the button to Skip the Recommending Officer" data-position="top">
												    <div class="tick_mark"></div>
												  </label>
												</div>

									            <div class="rcEditReasonDropDown rcEditReasonDropDown-<%=masterFlowList[5] %>" <% if(isSkippedStatus.equalsIgnoreCase("N")){ %> style="display: none;" <%} %>>
										            <select id="Reason-<%=masterFlowList[5] %>" name="ReasonType" class="form-control select2 editRcDropDownSelect" style="width: 100%;">
											            <option <%if(reasonType.equalsIgnoreCase("N")){ %> selected="selected" <%} %> value="-1">Select Reason</option>
											            <option <%if(reasonType.equalsIgnoreCase("T")){ %> selected="selected" <%} %> value="T">TD</option>
											            <option <%if(reasonType.equalsIgnoreCase("L")){ %> selected="selected" <%} %> value="L">Leave</option>
										            </select>
									            </div>
									            <%} %>
									            <%} else{ %>
									            
									            	<input type="hidden" name="SkipReccEmpStatus" value="N">
									            	<input type="hidden" name="ReasonType" value="N">
									            
									            <%} %>
									            
									            <div class="<%if(isMemberTypeCMorSE && isCMorSEApproved > 0 && isDHApproved > 0){ %> 
									            
									            	<% if(!isApproved){ %>
									            				<%if(isSkippedStatus.equalsIgnoreCase("Y")){ %>
									            				rcEditinlineDropDownLoad
									            				<%}else{ %>
									            				rcEditinlineDropDown 
									            				<%} %>
									            				
									            		<%}else{ %>
									            		
									            		rcEditinlineDropDownDefault
									            		
									            		<%} %>
									            				
									            			<%}else{ %> 
									            				rcEditinlineDropDownDefault 
									            			<%} %> 
									            			
									            			rcEditinlineDropDown-<%=masterFlowList[5] %>">
									              
									            <% if(!isApproved && !isCurrentEmp && !mainAuthority){ %>
									            
										            <select id="<%=masterFlowList[10]!=null ? masterFlowList[10] : ""  %>" <%if(isSkippedStatus.equalsIgnoreCase("Y")){ %> name="EditReccEmpIdDisabled" <%}else{ %> name="EditReccEmpId" <%} %> class="form-control select2 editRcDropDownSelect" style="width: 100%;" <%if(isSkippedStatus.equalsIgnoreCase("Y")){ %> disabled="disabled" <%} %>>
			                              			
			                              			 <option value="">Select Employee</option>
			                              			
				                              			<%if(masterMemberType.equalsIgnoreCase("DH")){ %>
				                              			
					                              			<%if(employeeList!=null && employeeList.size()>0){ %>
						                              				<%for(Object[] empDetails: employeeList){ %>
						                              					<%if(empDetails[3]!=null){ %>
						                              						<option value="<%=empDetails[0] %>" <%if(empDetails[0]!=null && rcEmpId.equalsIgnoreCase(empDetails[0].toString())){ %> selected="selected" <%} %>><%=empDetails[2] %><%if(empDetails[3]!=null){ %>, <%=empDetails[3] %><%} %></option>
						                              					<%} %>
						                              				<%} %>
					                              			    <%} %>
				                              			
				                              			<%}else{ %>
				                              			
				                              				<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
					                              				<%for(Object[] masterList: committeeMasterList){ %>
					                              				
					                              				<%if(masterList[1]!=null && masterList[3]!=null){ %>
					                              					<% committeeAction = ((masterMemberType.equalsIgnoreCase("CM") || masterMemberType.equalsIgnoreCase("SE")) && (masterList[1].toString()).equalsIgnoreCase("CM")) || ((masterMemberType.equalsIgnoreCase("CC") || masterMemberType.equalsIgnoreCase("SC")) && ((masterList[1].toString()).equalsIgnoreCase("CC") || (masterList[1].toString()).equalsIgnoreCase("SC"))); // CM - Committee Member %>
					                              				
					                              					<%if(committeeAction){ %>
					                              						<option value="<%=masterList[2] %>" <%if(masterList[2]!=null && rcEmpId.equalsIgnoreCase(masterList[2].toString())){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
					                              					<%} %>
					                              				<%} %>
					                              				<%} %>
				                              			    <%} %>
				                              			
				                              			<%} %>
				                              			
				                              			</select>
				                              			
				                              			<%if(isSkippedStatus.equalsIgnoreCase("Y")){ %>
				                              			<input type="hidden" id="TempEditReccEmpId" name="EditReccEmpId" value="<%=rcEmpId %>">
				                              			<%} %>
				                              			
				                              			</div>
									            
		                              			<%}else{ %>
		                              			
		                              			<%if(isMemberTypeCMorSE){%>
		                              			<input type="hidden" name="SkipReccEmpStatus" value="N">
									            <input type="hidden" name="ReasonType" value="N">
		                              			<%} %>
		                              			
		                              				<input type="hidden" id="<%=masterFlowList[10]!=null ? masterFlowList[10] : ""  %>" name="EditReccEmpId" value="<%=masterFlowList[3] %>">
		                              				<input type="text" class="form-control rcEditinlineinput" readonly="readonly" value="<%=masterFlowList[6]!=null ? masterFlowList[6] : "-" %><%= masterFlowList[7] != null ? ", "+masterFlowList[7] : "" %>">
		                              			
		                              			<%} %>
		                              			
		                              			</div>
								                
								            </td>
								        </tr>
									    
									    <%} %>
									    
									   <tr>
                              			<td colspan="2" class="rowProperties">
                              				<input class="btn btn-sm submit-btn" type="button" id="submiting" value="Update" onclick="updateReccDetailsFunction()"> &nbsp;
                              				<input type="button" class="btn btn-sm back-btn" value="Back" onclick="EditRecommendingDetailsAction('C')">
                              			</td>
                              			
                              		</tr>
								    
								    <%} %>
                              		
                              	</table>
                              	
                              	</form>
                              	
                              </div>
                              
	                        </div>


                           </div>
                       </div>

                       <% }else { %>

                       <div class="RCPendingDiv" style="text-align: center; height: 100%; display: grid;place-items: center;box-shadow: 0px 0px 4px #cbcbcb;border-radius: 3px;">
                       <span style="color:#4a036c; border-radius:10px; padding:10px 9px; background:#eadcff; font-size:13px; font-weight:800;"> Recommendation Pending </span>
                        <% // Edit the Recommending Officer %>
                        <div >
	                         <span style="font-weight:600;color:#000048;">Click Edit Button To Change or Skip Recommending Officer(s)</span><br>
	                         <button type="button" data-tooltip="Change or Skip Recommending Officer(s)" data-position="top"  class="btn btn-sm revise-btn tooltip-container secRcEditButton" onclick="EditRecommendingDetailsAction('O')">Edit&nbsp;&#10097;&#10097;</button>
                        </div>
                       </div>
                       
                        <div class="EditRCDetails" style="text-align: center; height: 100%;box-shadow: 0px 0px 4px #cbcbcb;border-radius: 3px;display:none;">
                        <div class="card ApprovalDetails table-responsive"> 
                              	
                              	<form id="editRcDetailsForm" action="#">
	                               
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
								<input type="hidden" name="fundApprovalIdEdit" value="<%=fundApprovalId %>"/>
                              	
                              	<table style="width: 100%;" id="fundApprovalForardTable">
                              	
                              	<%long isCMorSEApproved = masterFlowDetails.stream()
                              		    .filter(row -> ((row[1]!=null && ("CM".equalsIgnoreCase(row[1].toString()) || "SE".equalsIgnoreCase(row[1].toString()))) 
                              		    		&& (row[4] != null && "N".equalsIgnoreCase(row[4].toString()))))
                              		    .count(); %>
                              		    
                              	<%long isDHApproved = masterFlowDetails.stream()
                              		    .filter(row -> row[1]!=null && "DH".equalsIgnoreCase(row[1].toString()) 
                              		    		&& row[4] != null && "Y".equalsIgnoreCase(row[4].toString()))
                              		    .count(); %>
                              	
                              	<%if(isCMorSEApproved > 0 && isDHApproved > 0){ %>
                              		<tr>
                              		<td colspan="2">
                              		 <div class="note">Notes : <span class="note_content">Select the radio button to either skip or include the Recommending Officer.</span></div>
                              		</td>
                              		</tr>
                              		
                              		<%} %>
                              		
                              		  <%if(masterFlowDetails != null){ %>

									    <% for(Object[] masterFlowList : masterFlowDetails){ 
									    
									    boolean isCurrentEmp = masterFlowList[3] != null && empId == (Long.parseLong(masterFlowList[3].toString()));
									    boolean isApproved = masterFlowList[4] != null && (masterFlowList[4].toString().equalsIgnoreCase("Y"));
									    String masterMemberType = masterFlowList[2]!=null ? masterFlowList[1].toString() : "NA";
									    boolean mainAuthority = (masterMemberType.equalsIgnoreCase("CS") || (masterMemberType.equalsIgnoreCase("CC") && !currentEmpStatus.equalsIgnoreCase("CS") ));
									    String rcEmpId = masterFlowList[3] != null ? masterFlowList[3].toString() : "0";
									    boolean isMemberTypeCMorSE = masterMemberType.equalsIgnoreCase("CM") || masterMemberType.equalsIgnoreCase("SE");
									    String isSkippedStatus = masterFlowList[12]!=null ? masterFlowList[12].toString() : "N";
									    String reasonType = masterFlowList[13]!=null ? masterFlowList[13].toString() : "N";
									    boolean committeeAction = true;
									    %>
									    
									    <%
									    System.out.println("reasonType****"+reasonType);
									    System.out.println("isApproved--#######################---"+isApproved);
									    %>

									    	<tr>
									    	<td class="editRCDetails"><%=masterFlowList[2] %>
									    	<input type="hidden" name="MemberLinkedIdEdit" value="<%=masterFlowList[5] %>"/>
									    	</td>
								            <td class="recommendation-value editRCDropDown">
								            
								            <div class="form-inline">
								            
								            <%if(isMemberTypeCMorSE && isCMorSEApproved > 0 && isDHApproved > 0){ %>
								            
								            <%if(!isApproved){ %>
								              <div class="checkbox-wrapper-26">
												  <input type="hidden" id="CheckBoxHidden-<%=masterFlowList[5] %>" name="SkipReccEmpStatus" value="<%=isSkippedStatus %>">
												  <input type="checkbox" id="CheckBox-<%=masterFlowList[5] %>" class="form-control" onclick="displayReasonDropDown('<%=masterFlowList[5] %>','<%=masterFlowList[10]!=null ? masterFlowList[10] : ""  %>')" <%if(isSkippedStatus.equalsIgnoreCase("Y")){ %> checked="checked" <%} %>>
												  <label for="CheckBox-<%=masterFlowList[5] %>" class="tooltip-container" data-tooltip="Click the button to Skip the Recommending Officer" data-position="top">
												    <div class="tick_mark"></div>
												  </label>
												</div>
											

									            <div class="rcEditReasonDropDown rcEditReasonDropDown-<%=masterFlowList[5] %>" <% if(isSkippedStatus.equalsIgnoreCase("N")){ %> style="display: none;" <%} %>>
										            <select id="Reason-<%=masterFlowList[5] %>" name="ReasonType" class="form-control select2 editRcDropDownSelect" style="width: 100%;" <% if(isSkippedStatus.equalsIgnoreCase("N")){ %> disabled="disabled" <%} %>>
											            <option <%if(reasonType.equalsIgnoreCase("N")){ %> selected="selected" <%} %> value="-1">Select Reason</option>
											            <option <%if(reasonType.equalsIgnoreCase("T")){ %> selected="selected" <%} %> value="T">TD</option>
											            <option <%if(reasonType.equalsIgnoreCase("L")){ %> selected="selected" <%} %> value="L">Leave</option>
										            </select>
									            </div>
									            
									            <%} %>
									            <%} else{ %>
									            
									            	<input type="hidden" name="SkipReccEmpStatus" value="N">
									            	<input type="hidden" name="ReasonType" value="N">
									            
									            <%} %>
									            
									            <div class="<%if(isMemberTypeCMorSE && isCMorSEApproved > 0 && isDHApproved > 0){ %> 
									            
									            				<%if(!isApproved){ %>
									            				<%if(isSkippedStatus.equalsIgnoreCase("Y")){ %>
									            				rcEditinlineDropDownLoad
									            				<%}else{ %>
									            				rcEditinlineDropDown 
									            				<%} %>
									            				<%}else{ %>
									            			    rcEditinlineDropDownDefault
									            				<%} %>
									            				
									            			<%}else{ %> 
									            				rcEditinlineDropDownDefault 
									            			<%} %> 
									            			
									            			rcEditinlineDropDown-<%=masterFlowList[5] %>">

									            <% if(!isApproved && !isCurrentEmp && !mainAuthority){ %>
		                              			<select id="<%=masterFlowList[10]!=null ? masterFlowList[10] : ""  %>" <%if(isSkippedStatus.equalsIgnoreCase("Y")){ %> name="EditReccEmpIdDisabled" <%}else{ %> name="EditReccEmpId" <%} %> class="form-control select2 editRcDropDownSelect" style="width: 100%;" <%if(isSkippedStatus.equalsIgnoreCase("Y")){ %> disabled="disabled" <%} %>>		                              			
		                              			
		                              			<option value="">Select Employee</option>
		                              			
		                              			<%if(masterMemberType.equalsIgnoreCase("DH")){ %>
		                              			
			                              			<%if(employeeList!=null && employeeList.size()>0){ %>
				                              				<%for(Object[] empDetails: employeeList){ %>
				                              					<%if(empDetails[3]!=null){ %>
				                              						<option value="<%=empDetails[0] %>" <%if(empDetails[0]!=null && rcEmpId.equalsIgnoreCase(empDetails[0].toString())){ %> selected="selected" <%} %>><%=empDetails[2] %><%if(empDetails[3]!=null){ %>, <%=empDetails[3] %><%} %></option>
				                              					<%} %>
				                              				<%} %>
			                              			    <%} %>
		                              			
		                              			<%}else{ %>
		                              			
		                              				<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
			                              				<%for(Object[] masterList: committeeMasterList){ %>
			                              				
			                              				<%if(masterList[1]!=null && masterList[3]!=null){ %>
			                              					<% committeeAction = ((masterMemberType.equalsIgnoreCase("CM") || masterMemberType.equalsIgnoreCase("SE")) && (masterList[1].toString()).equalsIgnoreCase("CM")) || ((masterMemberType.equalsIgnoreCase("CC") || masterMemberType.equalsIgnoreCase("SC")) && ((masterList[1].toString()).equalsIgnoreCase("CC") || (masterList[1].toString()).equalsIgnoreCase("SC"))); // CM - Committee Member %>
			                              				
			                              					<%if(committeeAction){ %>
			                              						<option value="<%=masterList[2] %>" <%if(masterList[2]!=null && rcEmpId.equalsIgnoreCase(masterList[2].toString())){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
			                              					<%} %>
			                              				<%} %>
			                              				<%} %>
		                              			    <%} %>
		                              			
		                              			<%} %>
		                              			
		                              			</select>
		                              			
		                              			<%if(isSkippedStatus.equalsIgnoreCase("Y")){ %>
		                              			<input type="hidden" id="TempEditReccEmpId" name="EditReccEmpId" value="<%=rcEmpId %>">
		                              			<%} %>
		                              			
		                              			</div>
		                              			
		                              			<%}else{ %>
		                              			
			                              			<%if(isMemberTypeCMorSE){%>
			                              			<input type="hidden" name="SkipReccEmpStatus" value="N">
										            <input type="hidden" name="ReasonType" value="N">
			                              			<%} %>
			                              			
		                              				<input type="hidden" id="<%=masterFlowList[10]!=null ? masterFlowList[10] : ""  %>" name="EditReccEmpId" value="<%=masterFlowList[3] %>">
		                              				<input type="text" class="form-control rcEditinlineinput" readonly="readonly" value="<%=masterFlowList[6]!=null ? masterFlowList[6] : "-" %><%= masterFlowList[7] != null ? ", "+masterFlowList[7] : "" %>">

		                              			<%} %>
		                              			
		                              			</div>

								            </td>
								        </tr>

									    <%} %>

									   <tr>
                              			<td colspan="2" class="rowProperties">
                              				<input class="btn btn-sm submit-btn" type="button" id="submiting" value="Update" onclick="updateReccDetailsFunction()"> &nbsp;
                              				<input type="button" class="btn btn-sm back-btn" value="Back" onclick="EditRecommendingDetailsAction('C')">
                              			</td>

                              		</tr>

								    <%} %>

                              	</table>

                              	</form>
                              	
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

function displayReasonDropDown(memberLinkedId, dropDownIdAttribute)
{
	var checkbox = $("#CheckBox-"+memberLinkedId);
	var member = $('#' + dropDownIdAttribute).val() || 0;
	if(checkbox.is(":checked"))
	{
		$(".rcEditReasonDropDown-" + memberLinkedId).show();
		$(".rcEditinlineDropDown-" + memberLinkedId).attr("style", "width:auto; min-width:68% !important;margin-left:4px;");
		$("#CheckBoxHidden-" + memberLinkedId).val('Y');
		
		$('#' + dropDownIdAttribute).append('<input type="hidden" id="TempEditReccEmpId" name="EditReccEmpId" value="'+ member +'">');
		$('#' + dropDownIdAttribute).prop("disabled", true);
		$('#' + dropDownIdAttribute).attr("name", "EditReccEmpIdDisabled");

		$('#Reason-' + memberLinkedId).prop("disabled", false);
	}
	else
	{
		$(".rcEditinlineDropDown-" + memberLinkedId).attr("style", "width:auto; min-width:95% !important;");
		$(".rcEditReasonDropDown-" + memberLinkedId).hide();
		$("#CheckBoxHidden-" + memberLinkedId).val('N');
		
		$("#TempEditReccEmpId").remove();
		$('#' + dropDownIdAttribute).prop("disabled", false);
		$('#' + dropDownIdAttribute).attr("name", "EditReccEmpId");
		
		$('#Reason-' + memberLinkedId).prop("disabled", true);
	}
	
	
}

</script>

<script type="text/javascript">

function updateReccDetailsFunction()
{
	var rcMembers = $("select[name='EditReccEmpId'], input[name='EditReccEmpId']").map(function() {
	        return $(this).val();  
	    }).get(); 
	
	var reasonTypes = $("select[name='ReasonType']:not(:disabled), input[name='ReasonType']").map(function() {
	        return $(this).val();  
	    }).get(); 
	
	var isSkipped = $("select[name='SkipReccEmpStatus'], input[name='SkipReccEmpStatus']").map(function() {
	        return $(this).val();  
	    }).get(); 
	

	if (new Set(rcMembers).size !== rcMembers.length) 
	{
		showAlert("The same Recommending Officer cannot be selected more than once. Please review your selection.");
	} 
	else if (reasonTypes.includes('-1')) 
	{
		showAlert("When skipping the Recommending Officer, please select a reason.");
	} 
	else 
	{
		var form = $("#editRcDetailsForm");
		if (form) {
		    showConfirm('Are You Sure To Update The Recommending Officer(s)..?',
		        function (confirmResponse) {
		            if (confirmResponse) {
		            	$("select[name='ReasonType']:disabled").prop("disabled", false);
		            	form.attr("action","EditCommitteeMemberDetails.htm");
		                form.submit();
		            }
		        }
		    );
		}
	}
}

function EditRecommendingDetailsAction(actionType)
{
	if(actionType == 'O')
	{
		$(".EditRCDetails,.EditRCDetailsDH").show();
		$(".RCPendingDiv,.reccReturnDiv").hide();
	}
	else if(actionType == 'C')
	{
		$(".EditRCDetails,.EditRCDetailsDH").hide();
		$(".RCPendingDiv,.reccReturnDiv").show();
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

function confirmActionFromMember(actionName, memberType, action) {  // A - Approver,Noting,Recommend
    const remarksarea = $('#remarksarea').val().trim();
    
    if (action === 'R' && remarksarea === '') {
    	showAlert('Please enter the remarks...!');
        $('#remarksarea').focus();
        return false;
    }
    else
   	{
    	var form = $("#fbeForm");

    	if (form) {
    	    showConfirm("Are you sure to "+actionName+"...?",
    	        function (confirmResponse) {
    	            if (confirmResponse) {
    	            	form.append('<input type="hidden" name="Action" value="'+action+'">');
    	            	form.append('<input type="hidden" name="memberStatus" value="'+memberType+'">');
    	                form.submit();
    	            }
    	        }
    	    );
    	}
   	}
    
  /*    if (confirm("Are you sure to "+action+"...?")) {
        const form = $('#fbeForm');
        const actionInput = $('<input>', {
            type: 'hidden',
            name: 'Action',
            value: value
        });
        form.append(actionInput);
        form.submit();
    } */
}
</script>

<script type="text/javascript">

$(document).ready(function(){
	
	getAttachementDetailsInline('<%=fundApprovalId %>');
});

window.onload = function () {
    if (!sessionStorage.getItem("msgShown")) {
        showSuccessFlyMessage("Recommending Officer(s) Updated Successfully..&#128077;");
        sessionStorage.setItem("msgShown", "true");
    }
};

</script>
</html>