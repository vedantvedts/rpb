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
    
</style>
</head>
<body>
<%Object[] fundDetails=(Object[])request.getAttribute("fundDetails");
long empId = (Long) session.getAttribute("EmployeeId");
System.out.println("****fundDetails****"+Arrays.toString(fundDetails));

String fundApprovalId=null;
String estimateType=null;
String finYear=null;
String initiatingOfficerId=null;
String initiatingOfficer=null;
String rc1Details=null;
String rc1Role=null;
String rc2Details=null;
String rc2Role=null;
String rc3Details=null;
String rc3Role=null;
String rc4Details=null;
String rc4Role=null;
String rc5Details=null;
String rc5Role=null;
String approvingOfficerDetails=null;
String approvingOfficerRole=null;
String rcStatusCodeNext=null,budgetHead=null,budgetItem=null,codeHead=null,estimatedCost=null,itemNomenclature=null,justification=null;
String rc1Status=null,rc2Status=null,rc3Status=null,rc4Status=null,rc5Status=null,apprOffStatus=null,currentEmpStatus=null;
long rc1EmpId=0,rc2EmpId=0,rc3EmpId=0,rc4EmpId=0,rc5EmpId=0,appOffEmpId=0;
if(fundDetails!=null && fundDetails.length > 0)
{
	fundApprovalId=fundDetails[0]!=null  ? fundDetails[0].toString() : "0";
	estimateType=fundDetails[1]!=null  ? fundDetails[1].toString() : null;
	finYear=fundDetails[2]!=null  ? fundDetails[2].toString() : null;
	
	initiatingOfficerId=fundDetails[18]!=null  ? fundDetails[18].toString() : "0";
	initiatingOfficer=fundDetails[19]!=null  ? fundDetails[19].toString() : null;
	
	rc1EmpId=fundDetails[20]!=null  ? Long.parseLong(fundDetails[20].toString()) : 0;
	rc1Details=fundDetails[21]!=null  ? fundDetails[21].toString() : null;
	rc1Role=fundDetails[22]!=null  ? fundDetails[22].toString() : null;
	
	rc2EmpId=fundDetails[23]!=null  ? Long.parseLong(fundDetails[23].toString()) : 0;
	rc2Details=fundDetails[24]!=null  ? fundDetails[24].toString() : null;
	rc2Role=fundDetails[25]!=null  ? fundDetails[25].toString() : null;
	
	rc3EmpId=fundDetails[26]!=null  ? Long.parseLong(fundDetails[26].toString()) : 0;
	rc3Details=fundDetails[27]!=null  ? fundDetails[27].toString() : null;
	rc3Role=fundDetails[28]!=null  ? fundDetails[28].toString() : null;
	
	rc4EmpId=fundDetails[29]!=null  ? Long.parseLong(fundDetails[29].toString()) : 0;
	rc4Details=fundDetails[30]!=null  ? fundDetails[30].toString() : null;
	rc4Role=fundDetails[31]!=null  ? fundDetails[31].toString() : null;
	
	rc5EmpId=fundDetails[32]!=null  ? Long.parseLong(fundDetails[32].toString()) : 0;
	rc5Details=fundDetails[33]!=null  ? fundDetails[33].toString() : null;
	rc5Role=fundDetails[34]!=null  ? fundDetails[34].toString() : null;
	
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
	apprOffStatus=fundDetails[46]!=null  ? fundDetails[46].toString() : null;
	currentEmpStatus=fundDetails[47]!=null  ? fundDetails[47].toString() : null;
}
System.out.println("rcStatusCodeNext****"+rcStatusCodeNext);
 %>
<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-5"><h5><%if(estimateType!=null && estimateType.equalsIgnoreCase("F")){ %>Forecast Budget Estimate<%}else if(estimateType!=null && estimateType.equalsIgnoreCase("R")){ %>Revised Estimate<%} %> Preview&nbsp;<span style="color:#057480;"><%if(finYear!=null){ %> (<%=finYear %>) <%} %></span></h5></div>
	      <div class="col-md-7">
	    	 <ol class="breadcrumb" style="justify-content: right !important;">
	    	 <li class="breadcrumb-item"><a href="FundRequest.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i>Requisition List </a></li>
	    	 <li class="breadcrumb-item">
	         	<a	href="FundApprovalList.htm"> <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approval 
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommending
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%} %> List</a>
	         </li>
	         <li class="breadcrumb-item active" aria-current="page"><%if(estimateType!=null && estimateType.equalsIgnoreCase("F")){ %>FBE<%}else if(estimateType!=null && estimateType.equalsIgnoreCase("R")){ %>RE<%} %> Item</li>
             </ol>
           </div>
         </div>
       </div> 
       
		 
		

   <% 
     String success=(String)request.getParameter("Status");
     String fail=(String)request.getParameter("Failure");	
     %>   
	           <% if(success!=null){%>
	                <div align="center">
		            <div  class="text-center alert alert-success col-md-8 col-md-offset-2" style="margin-top: 1rem" role="alert">
        	        <%=success %>
                    </div>
   	                </div>
	         <%}else if(fail!=null){%>
	                <div align="center">
	                <div class="text-center alert alert-danger col-md-8 col-md-offset-2" style="margin-top: 1rem;" role="alert" >
					<%=fail %>
			        </div>
			</div><%} %>
			
<div class="page card dashboard-card" style="background-color:white;padding-top: 0px;padding-left: 0px;padding-right: 0px;width: 98%;margin: auto;margin-top: 8px;">		

<div class="container">
    <div class="row" style="margin-left:0px !important;margin-right:0px !important;">
        <div class="col-md-12">
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
                <div class="row">
                    <!-- Left Division -->
                    <div class="col-md-6">
                        <div class="inner-box">
                                <% if (initiatingOfficer != null) { %>
                                    <div class="recommendation-item">
                                        <span><b>Initiated By &nbsp;: &nbsp;</b></span>
                                        <span class="recommendation-value">
                                            <%= initiatingOfficer %>
                                        </span>
                                    </div>
                                <% } %>

								<% if(rc1EmpId > 0){ %>
									<div <%if(empId == rc1EmpId){ %> class="recommendation-item highlight-box" <%}else{ %> class="recommendation-item" <%} %>>
                                        <span><b>RPB Member &nbsp;: &nbsp;</b></span>
                                        <span class="recommendation-value">
                                            <span <%if(empId == rc1EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>><%= rc1Role != null ? rc1Role + " &nbsp;&nbsp; " : "-" %></span>
                                            <%= rc1Details != null ? rc1Details : "-" %>
                                             <%if(empId == rc1EmpId){ %>
                                            <span class="badge badge-info">For Recommend</span>
                                            <%} %>
                                            <%if(rc1Status!=null && rc1Status.equalsIgnoreCase("Y")){ %>
                                           	 <img src="view/images/verifiedIcon.png" width="20" height="20" style="background: transparent;padding: 1px;margin-top: -5px;">
                                       		<%} %>
                                        </span>
                                    </div>
                                   <%} %>
                                
                                <% if(rc2EmpId > 0){ %>
                                    <div <%if(empId == rc2EmpId){ %> class="recommendation-item highlight-box" <%}else{ %> class="recommendation-item" <%} %>>
                                        <span><b>RPB Member &nbsp;: &nbsp;</b></span>
                                        <span class="recommendation-value">
                                            <span <%if(empId == rc2EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>><%= rc2Role != null ? rc2Role + " &nbsp;&nbsp; " : "" %></span>
                                            <%= rc2Details != null ? rc2Details : "-" %>
                                            <%if(empId == rc2EmpId){ %>
                                            <span class="badge badge-info">For Recommend</span>
                                            <%} %>
                                            <%if(rc2Status!=null && rc2Status.equalsIgnoreCase("Y")){ %>
                                           	 <img src="view/images/verifiedIcon.png" width="20" height="20" style="background: transparent;padding: 1px;margin-top: -5px;">
                                       		<%} %>
                                        </span>
                                    </div>
                                  <%} %>
                                
                                <% if(rc3EmpId > 0){ %>
                                    <div <%if(empId == rc3EmpId){ %> class="recommendation-item highlight-box" <%}else{ %> class="recommendation-item" <%} %>>
                                        <span><b>RPB Member &nbsp;: &nbsp;</b></span>
                                        <span class="recommendation-value">
                                            <span <%if(empId == rc3EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>><%= rc3Role != null ? rc3Role + " &nbsp;&nbsp; " : "" %></span>
                                            <%= rc3Details != null ? rc3Details : "-" %>
                                            <%if(empId == rc3EmpId){ %>
                                            <span class="badge badge-info">For Recommend</span>
                                            <%} %>
                                            <%if(rc3Status!=null && rc3Status.equalsIgnoreCase("Y")){ %>
                                           	 <img src="view/images/verifiedIcon.png" width="20" height="20" style="background: transparent;padding: 1px;margin-top: -5px;">
                                       		<%} %>
                                        </span>
                                    </div>
                                   <%} %>
                                
                                <% if(rc4EmpId > 0){ %>
                                    <div <%if(empId == rc4EmpId){ %> class="recommendation-item highlight-box" <%}else{ %> class="recommendation-item" <%} %>>
                                        <span><b>Subject Expert &nbsp;: &nbsp;</b></span>
                                        <span class="recommendation-value">
                                            <span <%if(empId == rc4EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>><%= rc4Role != null ? rc4Role + " &nbsp;&nbsp; " : "" %></span>
                                            <%= rc4Details != null ? rc4Details : "-" %>
                                            <%if(empId == rc4EmpId){ %>
                                            <span class="badge badge-info">For Recommend</span>
                                            <%} %>
                                            <%if(rc4Status!=null && rc4Status.equalsIgnoreCase("Y")){ %>
                                           	 <img src="view/images/verifiedIcon.png" width="20" height="20" style="background: transparent;padding: 1px;margin-top: -5px;">
                                       		<%} %>
                                        </span>
                                    </div>
                                   <%} %>
                                
                                <% if(rc5EmpId > 0){ %>
                                    <div <%if(empId == rc5EmpId){ %> class="recommendation-item highlight-box" <%}else{ %> class="recommendation-item" <%} %>>
                                        <span><b>RPB Member Secretary &nbsp;: &nbsp;</b></span>
                                        <span class="recommendation-value">
                                            <span <%if(empId == rc5EmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>><%= rc5Role != null ? rc5Role + " &nbsp;&nbsp; " : "" %></span>
                                            <%= rc5Details != null ? rc5Details : "-" %>
                                            <%if(empId == rc5EmpId){ %>
                                            <span class="badge badge-info">For Noting</span>
                                            <%} %>
                                            <%if(rc5Status!=null && rc5Status.equalsIgnoreCase("Y")){ %>
                                           	 <img src="view/images/verifiedIcon.png" width="20" height="20" style="background: transparent;padding: 1px;margin-top: -5px;">
                                       		<%} %>
                                        </span>
                                    </div>
                                   <%} %>
                                
                                <% if(appOffEmpId > 0){ %>
                                    <div <%if(empId == appOffEmpId){ %> class="recommendation-item highlight-box" <%}else{ %> class="recommendation-item" <%} %>>
                                        <span><b>RPB Chairman &nbsp;: &nbsp;</b></span>
                                        <span class="recommendation-value">
                                            <span <%if(empId == appOffEmpId){ %> style="color:#dd5e01;" <%}else{ %> style="color:#420e68;" <%} %>><%= approvingOfficerRole != null ? approvingOfficerRole + " &nbsp;&nbsp; " : "" %></span>
                                            <%= approvingOfficerDetails != null ? approvingOfficerDetails : "-" %>
                                             <%if(empId == appOffEmpId){ %>
                                            <span class="badge badge-info">For Approval</span>
                                            <%} %>
                                            <%if(apprOffStatus!=null && apprOffStatus.equalsIgnoreCase("Y")){ %>
                                           	 <img src="view/images/verifiedIcon.png" width="20" height="20" style="background: transparent;padding: 1px;margin-top: -5px;">
                                       		<%} %>
                                        </span>
                                    </div>
                                   <%} %>
                                    
                        </div>
                    </div>
                    
                    <!-- Right Division -->
                    <div class="col-md-6">
                        <div class="inner-box">
                            <div align="center">
                                <form id="fbeForm" action="FundApprovalSubmit.htm">
								    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
								    <div class="row" style="margin-bottom: 35px; margin-top: 20px;">
								        <b>Remarks :</b><br>
								        <textarea rows="3" cols="65" maxlength="1000" class="form-control" name="remarks" id="remarksarea"></textarea>
								    </div>
								    
								    <input type="hidden" name="fundApprovalId" value="<%=fundApprovalId%>">
								    <input type="hidden" name="initiating_officer" <%if(initiatingOfficerId != null){ %> value="<%=initiatingOfficerId%>" <%} %>>
								
								    
								        <button type="button" class="btn btn-primary btn-sm submit" <% if (currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")) { %> onclick="confirmAction('Approve','A')" <%}else{ %> onclick="confirmAction('Recommend','RE')" <%} %>>
									         <% if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CC")){ %> Approve 
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CM")){ %> Recommend
									         <%}else if(currentEmpStatus!=null && currentEmpStatus.equalsIgnoreCase("CS")){ %> Noting
									         <%} %>
								        </button>
								        
								    <button type="button" class="btn btn-sm btn-danger" onclick="confirmAction('Return','R')">
									        Return
									</button>
								    
								</form>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

				
</div>			

</body>

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

</html>