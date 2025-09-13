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
    margin-top: 8px;
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
    
</style>
</head>
<body>
<%
Object[] fundDetails=(Object[])request.getAttribute("fundDetails");
List<Object[]> masterFlowDetails=(List<Object[]>)request.getAttribute("MasterFlowDetails");
List<Object[]> committeeMasterList=(List<Object[]>)request.getAttribute("AllCommitteeMasterDetails");
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
String rc1Details=null;
String rc2Details=null;
String rc3Details=null;
String rc4Details=null;
String rc5Details=null;
String rc6Details=null;
String approvingOfficerDetails=null;
String approvingOfficerRole=null;
String memberStatus=null,flowDetailsId = null;
String rcStatusCodeNext=null,budgetHead=null,budgetItem=null,codeHead=null,estimatedCost=null,itemNomenclature=null,justification=null;
String rc1Status=null,rc2Status=null,rc3Status=null,rc4Status=null,rc5Status=null,apprOffStatus=null,rc6Status=null;
String rc1Remarks=null,rc2Remarks=null,rc3Remarks=null,rc4Remarks=null,rc5Remarks=null,apprOffRemarks=null,rc6Remarks=null;
long rc1EmpId=0,rc2EmpId=0,rc3EmpId=0,rc4EmpId=0,rc5EmpId=0,appOffEmpId=0,rc6EmpId=0;

if(fundDetails!=null && fundDetails.length > 0)
{
	fundApprovalId=fundDetails[0]!=null  ? fundDetails[0].toString() : "0";
	estimateType=fundDetails[1]!=null  ? fundDetails[1].toString() : null;
	finYear=fundDetails[2]!=null  ? fundDetails[2].toString() : null;
	
	initiatingOfficerId=fundDetails[18]!=null  ? fundDetails[18].toString() : "0";
	initiatingOfficer=fundDetails[19]!=null  ? fundDetails[19].toString() : null;
	
	rc1EmpId=fundDetails[20]!=null  ? Long.parseLong(fundDetails[20].toString()) : 0;
	rc1Details=fundDetails[21]!=null  ? fundDetails[21].toString() : null;
	
	rc2EmpId=fundDetails[23]!=null  ? Long.parseLong(fundDetails[23].toString()) : 0;
	rc2Details=fundDetails[24]!=null  ? fundDetails[24].toString() : null;
	
	rc3EmpId=fundDetails[26]!=null  ? Long.parseLong(fundDetails[26].toString()) : 0;
	rc3Details=fundDetails[27]!=null  ? fundDetails[27].toString() : null;
	
	rc4EmpId=fundDetails[29]!=null  ? Long.parseLong(fundDetails[29].toString()) : 0;
	rc4Details=fundDetails[30]!=null  ? fundDetails[30].toString() : null;
	
	rc5EmpId=fundDetails[32]!=null  ? Long.parseLong(fundDetails[32].toString()) : 0;
	rc5Details=fundDetails[33]!=null  ? fundDetails[33].toString() : null;
	
	rc6EmpId=fundDetails[50]!=null  ? Long.parseLong(fundDetails[50].toString()) : 0;
	rc6Details=fundDetails[51]!=null  ? fundDetails[51].toString() : null;
	
	appOffEmpId=fundDetails[35]!=null  ? Long.parseLong(fundDetails[35].toString()) : 0;
	approvingOfficerDetails=fundDetails[36]!=null  ? fundDetails[36].toString() : null;
	approvingOfficerRole=fundDetails[37]!=null  ? fundDetails[37].toString() : null;
	
	rcStatusCodeNext=fundDetails[40]!=null  ? fundDetails[40].toString() : null;
	
	budgetHead=fundDetails[8]!=null  ? fundDetails[8].toString() : null;
	budgetItem=fundDetails[9]!=null  ? fundDetails[9].toString() : null;
	codeHead=fundDetails[10]!=null  ? fundDetails[10].toString() : null;
	estimatedCost=fundDetails[17]!=null  ? fundDetails[17].toString() : null;
	itemNomenclature=fundDetails[14]!=null  ? fundDetails[14].toString() : null;
	justification=fundDetails[15]!=null  ? fundDetails[15].toString() : null;
	
	rc1Status=fundDetails[41]!=null  ? fundDetails[41].toString() : null;
	rc2Status=fundDetails[42]!=null  ? fundDetails[42].toString() : null;
	rc3Status=fundDetails[43]!=null  ? fundDetails[43].toString() : null;
	rc4Status=fundDetails[44]!=null  ? fundDetails[44].toString() : null;
	rc5Status=fundDetails[45]!=null  ? fundDetails[45].toString() : null;
	rc6Status=fundDetails[48]!=null  ? fundDetails[48].toString() : null;
	apprOffStatus=fundDetails[46]!=null ? fundDetails[46].toString() : null;
	
	if(masterFlowDetails!=null && masterFlowDetails.size() > 0)
	{
		for(Object[] row : masterFlowDetails)
		{
			if(row!=null && row.length > 0)
			{
				if(row[3]!=null && (row[3].toString()).equalsIgnoreCase("A"))
				{
					if(row[2]!=null)
					{
						if((row[2].toString()).equalsIgnoreCase("RC1") && row[4] != null && rc1EmpId == Long.parseLong(row[4].toString()))
						{
							rc1Remarks = row[7] != null ? row[7].toString() : null;
							if(rc1EmpId == empId)
							{
								memberStatus = row[2].toString();
								flowDetailsId =row[0]!=null ? row[0].toString() : "0";
							}
						}
						else if((row[2].toString()).equalsIgnoreCase("RC2") && row[4] != null && rc2EmpId == Long.parseLong(row[4].toString()))
						{
							rc2Remarks = row[7] != null ? row[7].toString() : null;
							if(rc2EmpId == empId)
							{
								memberStatus = row[2].toString();
								flowDetailsId =row[0]!=null ? row[0].toString() : "0";
							}
						}
						else if((row[2].toString()).equalsIgnoreCase("RC3") && row[4] != null && rc3EmpId == Long.parseLong(row[4].toString()))
						{
							rc3Remarks = row[7] != null ? row[7].toString() : null;
							if(rc3EmpId == empId)
							{
								memberStatus = row[2].toString();
								flowDetailsId =row[0]!=null ? row[0].toString() : "0";
							}
						}
						else if((row[2].toString()).equalsIgnoreCase("RC4") && row[4] != null && rc4EmpId == Long.parseLong(row[4].toString()))
						{
							rc4Remarks = row[7] != null ? row[7].toString() : null;
							if(rc4EmpId == empId)
							{
								memberStatus = row[2].toString();
								flowDetailsId =row[0]!=null ? row[0].toString() : "0";
							}
						}
						else if((row[2].toString()).equalsIgnoreCase("RC5") && row[4] != null && rc5EmpId == Long.parseLong(row[4].toString()))
						{
							rc5Remarks = row[7] != null ? row[7].toString() : null;
							if(rc5EmpId == empId)
							{
								memberStatus = row[2].toString();
								flowDetailsId =row[0]!=null ? row[0].toString() : "0";
							}
						}
						else if((row[2].toString()).equalsIgnoreCase("RC6") && row[4] != null && rc6EmpId == Long.parseLong(row[4].toString()))
						{
							rc6Remarks = row[7] != null ? row[7].toString() : null;
							if(rc6EmpId == empId)
							{
								memberStatus = row[2].toString();
								flowDetailsId =row[0]!=null ? row[0].toString() : "0";
							}
						}
						else if((row[2].toString()).equalsIgnoreCase("APR") && row[4] != null && appOffEmpId == Long.parseLong(row[4].toString()))
						{
							apprOffRemarks = row[7] != null ? row[7].toString() : null;
							if(appOffEmpId == empId)
							{
								memberStatus = row[2].toString();
								flowDetailsId =row[0]!=null ? row[0].toString() : "0";
							}
						}
					}
				}
			}
		};
	}
	
	
	
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
		          <table class="table table-bordered" style="font-weight: 600;width: 91.5% !important;margin:auto !important;" id="ApprovalDetails">
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
					
					    <% if(rc6EmpId > 0){ %>
					        <tr <%if(empId == rc6EmpId){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b>Division Head</b>
					            <% if(rc6Remarks!=null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(empId == rc6EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%= rc6Details != null ? rc6Details : "-" %>
					                <%if(empId == rc6EmpId){ %>
					                    <span class="badge badge-info">For Recommendation</span>
					                <%} %>
					                <%if(rc6Status!=null && rc6Status.equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>
					                
					                <% if(rc6Remarks!=null){ %> <br> <span class="remarksDetails">&nbsp;<%=rc6Remarks %></span> <%} %>
					                
					            </td>
					        </tr>
					    <%} %>
					
					    <% if(rc1EmpId > 0){ %>
					        <tr <%if(empId == rc1EmpId){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b>RPB Member</b>
					            <% if(rc1Remarks!=null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(empId == rc1EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%= rc1Details != null ? rc1Details : "-" %>
					                <%if(empId == rc1EmpId){ %>
					                    <span class="badge badge-info">For Recommendation</span>
					                <%} %>
					                <%if(rc1Status!=null && rc1Status.equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>
					                
					                <% if(rc1Remarks!=null){ %> <br> <span class="remarksDetails">&nbsp;<%=rc1Remarks %></span> <%} %>
					            </td>
					        </tr>
					    <%} %>
					
					    <% if(rc2EmpId > 0){ %>
					        <tr <%if(empId == rc2EmpId){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b>RPB Member</b>
					            <% if(rc2Remarks!=null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(empId == rc2EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%= rc2Details != null ? rc2Details : "-" %>
					                <%if(empId == rc2EmpId){ %>
					                    <span class="badge badge-info">For Recommendation</span>
					                <%} %>
					                <%if(rc2Status!=null && rc2Status.equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>
					                
					                <% if(rc2Remarks!=null){ %> <br> <span class="remarksDetails">&nbsp;<%=rc2Remarks %></span> <%} %>
					            </td>
					        </tr>
					    <%} %>
					
					    <% if(rc3EmpId > 0){ %>
					        <tr <%if(empId == rc3EmpId){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b>RPB Member</b>
					            <% if(rc3Remarks!=null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(empId == rc3EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%= rc3Details != null ? rc3Details : "-" %>
					                <%if(empId == rc3EmpId){ %>
					                    <span class="badge badge-info">For Recommendation</span>
					                <%} %>
					                <%if(rc3Status!=null && rc3Status.equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>
					                <% if(rc3Remarks!=null){ %> <br> <span class="remarksDetails">&nbsp;<%=rc3Remarks %></span> <%} %>
					            </td>
					        </tr>
					    <%} %>
					
					    <% if(rc4EmpId > 0){ %>
					        <tr <%if(empId == rc4EmpId){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b>Subject Expert</b>
					            <% if(rc4Remarks!=null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(empId == rc4EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%= rc4Details != null ? rc4Details : "-" %>
					                <%if(empId == rc4EmpId){ %>
					                    <span class="badge badge-info">For Recommendation</span>
					                <%} %>
					                <%if(rc4Status!=null && rc4Status.equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>
					                <% if(rc4Remarks!=null){ %> <br> <span class="remarksDetails">&nbsp;<%=rc4Remarks %></span> <%} %>
					            </td>
					        </tr>
					    <%} %>
					
					    <% if(rc5EmpId > 0){ %>
					        <tr <%if(empId == rc5EmpId){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b>RPB Member Secretary</b>
					            <% if(rc5Remarks!=null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(empId == rc5EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%= rc5Details != null ? rc5Details : "-" %>
					                <%if(empId == rc5EmpId){ %>
					                    <span class="badge badge-info">For Noting</span>
					                <%} %>
					                <%if(rc5Status!=null && rc5Status.equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>
					                <% if(rc5Remarks!=null){ %> <br> <span class="remarksDetails">&nbsp;<%=rc5Remarks %></span> <%} %>
					            </td>
					        </tr>
					    <%} %>
					
					    <% if(appOffEmpId > 0){ %>
					        <tr <%if(empId == appOffEmpId){ %> class="highlight-box" <%} %>>
					            <td style="width:40%;"><b>RPB Chairman</b>
					            <% if(apprOffRemarks!=null){ %> <br> <span class="remarksDetails">Remarks</span> <%} %>
					            </td>
					            <td style="width:60%;" class="recommendation-value">
					                <span <%if(empId == appOffEmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>>
					                </span>
					                <%= approvingOfficerDetails != null ? approvingOfficerDetails : "-" %>
					                <%if(empId == appOffEmpId){ %>
					                    <span class="badge badge-info">For Approval</span>
					                <%} %>
					                <%if(apprOffStatus!=null && apprOffStatus.equalsIgnoreCase("Y")){ %>
					                    <img src="view/images/verifiedIcon.png" width="20" height="20" 
					                         style="background: transparent;padding: 1px;margin-top: -5px;">
					                <%} %>
					                <% if(apprOffRemarks!=null){ %> <br> <span class="remarksDetails">&nbsp;<%=apprOffRemarks %></span> <%} %>
					            </td>
					        </tr>
					    <%} %>
					</table>
                        
                    </div>
                    
                    <!-- Right Division -->
                    <div class="col-md-6">
                    
						<% boolean allNA = rc1Status.equals("NA") && rc2Status.equals("NA") && rc3Status.equals("NA") && rc4Status.equals("NA");
						  boolean hasN = rc1Status.equalsIgnoreCase("N") || rc2Status.equalsIgnoreCase("N") || rc3Status.equalsIgnoreCase("N") || rc4Status.equalsIgnoreCase("N");
						  
						  boolean isDHApproved = rc6Status.equalsIgnoreCase("Y");
						  boolean isCSApproved = rc5Status.equalsIgnoreCase("Y");
						  boolean isCCApproved = apprOffStatus.equalsIgnoreCase("Y");
						  
						  System.out.println("rc1Status****"+rc1Status);
						  System.out.println("rc2Status****"+rc2Status);
						  System.out.println("rc3Status****"+rc3Status);
						  System.out.println("rc4Status****"+rc4Status);
						  System.out.println("allNA****"+allNA);
						  System.out.println("hasN****"+hasN);
						  System.out.println("isDHApproved****"+isDHApproved);
						  System.out.println("isCSApproved****"+isCSApproved);
						  System.out.println("isCCApproved****"+isCCApproved);
						  
						   %>
						  
						<%String tooltip = "";
						boolean showPending = false;
						
						switch(currentEmpStatus.toUpperCase()) {
						    case "CS":
						        showPending = !(isDHApproved && !hasN);
						        tooltip = "Preview & Note";
						        break;
						    case "CC":
						        showPending = !(isDHApproved && isCSApproved);
						        tooltip = "Preview & Approve";
						        break;
						}
						%>
									
						<%if(!showPending){ %>
                    
                        <div class="inner-box">
                            <div align="center">
                                <form id="fbeForm" action="CommitteeMemberAction.htm">
								    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
								    
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
								    
								</form>

                            </div>
                        </div>
                        
                       <% }else { %>
                       
                       <div class="RCPendingDiv" style="text-align: center; height: 100%; display: grid;place-items: center;box-shadow: 0px 0px 4px #cbcbcb;border-radius: 3px;">
                       <span style="color:#4a036c; border-radius:10px; padding:10px 9px; background:#ffe8cc; font-size:13px; font-weight:800;"> Recommendation Pending </span>
                        <% // Edit the Recommending Officer %>
                        <div >
	                         <span style="font-weight:600;color:#000048;">Click Edit Button To Change Recommending Officer(s)</span><br>
	                         <button type="button" data-tooltip="Change Recommending Officer(s)" data-position="top" class="btn btn-sm icon-btn tooltip-container" style="padding:6px;border: 1px solid #895912;background: #ffe0c4;margin: 10px;" onclick="EditRecommendingDetailsAction('O')"> Edit &nbsp;&#10097;&#10097; </button>
                        </div>
                       </div>
                       
                        <div class="EditRCDetails" style="text-align: center; height: 100%;box-shadow: 0px 0px 4px #cbcbcb;border-radius: 3px;display:none;">
                        	<div class="card ApprovalDetails table-responsive" style="width: 100%;height:100%;"> 
                              	<table style="width: 100%;" id="fundApprovalForardTable">
                              		
                              		<%if(rc6Status!=null){ %>
                              		 <%if(!rc6Status.equalsIgnoreCase("NA")){ %>
	                              		<tr class="DivisionHead">
	                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">Division Head</td>
	                              			<td style="padding: 8px; width: 55%;">
	                              			<% if(rc6Status.equalsIgnoreCase("N")){ %>
	                              			<select id="divisionHeadDetails" name="divisionHeadDetails" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
	                              			<option value="">Select Employee</option>
	                              			<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
	                              				<%for(Object[] masterList: committeeMasterList){ %>
	                              					<%if(masterList[3]!=null){ %>
	                              						<option value="<%=masterList[2] %>" <%if(masterList[2]!=null && (Long.parseLong(masterList[2].toString()) == rc6EmpId)){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
	                              					<%} %>
	                              				<%} %>
	                              			<%} %>
	                              			</select>
	                              			<%}else{ %>
	                              			
	                              				<input type="text" class="form-control" readonly="readonly" value="<%= rc6Details != null ? rc6Details : "-" %>">
	                              			
	                              			<%} %>
	                              			</td>
	                              		</tr>
                              		 <%} %>
                              		<%} %>
                              		
                              		<%if(rc1Status!=null){ %>
                              		<%if(!rc1Status.equalsIgnoreCase("NA")){ %>
	                              		<tr class="RPBMember1">
	                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Member</td>
	                              			<td style="padding: 8px; width: 55%;">
	                              			<% if(rc1Status.equalsIgnoreCase("N")){ %>
	                              			<select id="RPBMemberDetails1" name="RPBMemberDetails1" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
	                              			<option value="">Select Employee</option>
	                              			<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
		                              				<%for(Object[] masterList: committeeMasterList){ %>
		                              					<%if(masterList[3]!=null){ %>
		                              						<option value="<%=masterList[2] %>" <%if(masterList[2]!=null && (Long.parseLong(masterList[2].toString()) == rc1EmpId)){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
		                              					<%} %>
		                              				<%} %>
		                              			<%} %>
	                              			</select>
	                              			<%}else{ %>
	                              			
	                              				<input type="text" class="form-control" readonly="readonly" value="<%= rc1Details != null ? rc1Details : "-" %>">
	                              			
	                              			<%} %>
	                              			</td>
	                              		</tr>
	                              	   <%} %>
                              		  <%} %>
                              		
                              		<%if(rc2Status!=null){ %>
                              		<%if(!rc2Status.equalsIgnoreCase("NA")){ %>
                              		<tr class="RPBMember2">
                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Member</td>
                              			<td style="padding: 8px; width: 55%;">
                              			<% if(rc2Status.equalsIgnoreCase("N")){ %>
                              			<select id="RPBMemberDetails2" name="RPBMemberDetails2" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                              			<option value="">Select Employee</option>
                              			<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
	                              				<%for(Object[] masterList: committeeMasterList){ %>
	                              					<%if(masterList[3]!=null){ %>
	                              						<option value="<%=masterList[2] %>" <%if(masterList[2]!=null && (Long.parseLong(masterList[2].toString()) == rc2EmpId)){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
	                              					<%} %>
	                              				<%} %>
	                              			<%} %>
                              			</select>
                              			<%}else{ %>
	                              			
	                              				<input type="text" class="form-control" readonly="readonly" value="<%= rc2Details != null ? rc2Details : "-" %>">
	                              			
	                              			<%} %>
                              			</td>
                              		  </tr>
	                              	 <%} %>
	                              	<%} %>
                              		
                              		<%if(rc3Status!=null){ %>
                              		<%if(!rc3Status.equalsIgnoreCase("NA")){ %>
                              		<tr class="RPBMember3">
                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Member</td>
                              			<td style="padding: 8px; width: 55%;">
                              			<% if(rc3Status.equalsIgnoreCase("N")){ %>
                              			<select id="RPBMemberDetails3" name="RPBMemberDetails3" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                              			<option value="">Select Employee</option>
                              			<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
	                              				<%for(Object[] masterList: committeeMasterList){ %>
	                              					<%if(masterList[3]!=null){ %>
	                              						<option value="<%=masterList[2] %>" <%if(masterList[2]!=null && (Long.parseLong(masterList[2].toString()) == rc3EmpId)){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
	                              					<%} %>
	                              				<%} %>
	                              			<%} %>
                              			</select>
                              			<%}else{ %>
	                              			
	                              				<input type="text" class="form-control" readonly="readonly" value="<%= rc3Details != null ? rc3Details : "-" %>">
	                              			
	                              			<%} %>
                              			</td>
                              		</tr>
                              		 <%} %>
	                              	<%} %>
                              		
                              		<tr class="SubjectExpert">
                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">Subject Expert</td>
                              			<td style="padding: 8px; width: 55%;">
                              			<select id="SubjectExpertDetails" name="SubjectExpertDetails" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                              			<option value="">Select Employee</option>
                              			<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
	                              				<%for(Object[] masterList: committeeMasterList){ %>
	                              					<%if(masterList[3]!=null){ %>
	                              						<option value="<%=masterList[2] %>" <%if(masterList[2]!=null && (Long.parseLong(masterList[2].toString()) == rc4EmpId)){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
	                              					<%} %>
	                              				<%} %>
	                              			<%} %>
                              			</select></td>
                              		</tr>
                              		
                              		<tr class="RPBMemberSecretary">
                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Member Secretary</td>
                              			<td style="padding: 8px; width: 55%;">
                              			<input type="text" class="form-control" readonly="readonly" value="<%= rc5Details != null ? rc5Details : "-" %>"></td>
                              		</tr>
                              		
                              		<tr class="chairman">
                              			<td style="padding: 8px; text-align: right; font-weight: 600; white-space: nowrap; display: flex; align-items: center;width: 30% !important;">RPB Chairman / Stand by Chairman</td>
                              			<td style="padding: 8px; width: 55%;">
                              			<select id="chairmanDetails" name="chairmanDetails" class="form-control select2" style="width: 100%; font-size: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                              			<option value="">Select Employee</option>
                              			<%if(committeeMasterList!=null && committeeMasterList.size()>0){ %>
	                              				<%for(Object[] masterList: committeeMasterList){ %>
	                              					<%if(masterList[3]!=null){ %>
	                              						<option value="<%=masterList[2] %>" <%if(masterList[2]!=null && (Long.parseLong(masterList[2].toString()) == appOffEmpId)){ %> selected="selected" <%} %>><%=masterList[3] %><%if(masterList[4]!=null){ %>, <%=masterList[4] %><%} %></option>
	                              					<%} %>
	                              				<%} %>
	                              			<%} %>
                              			</select></td>
                              		</tr>
                              		
                              		<tr>
                              			<td colspan="2">
                              				<input class="btn btn-sm submit-btn" type="button" id="submiting" value="Update" onclick="validateFormFieldsEdit()"> &nbsp;
                              				<input type="button" class="btn btn-sm back-btn" value="Back" onclick="EditRecommendingDetailsAction('C')">
                              			</td>
                              		</tr>
                              		
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

</html>