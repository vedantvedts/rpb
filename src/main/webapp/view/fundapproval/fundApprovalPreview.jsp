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
}
System.out.println("rcStatusCodeNext****"+rcStatusCodeNext);
 %>
<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-5"><h5><%if(estimateType!=null && estimateType.equalsIgnoreCase("F")){ %>Forecast Budget Estimate<%}else if(estimateType!=null && estimateType.equalsIgnoreCase("R")){ %>Revised Estimate<%} %> Preview&nbsp;<span style="color:#057480;"><%if(finYear!=null){ %> (<%=finYear %>) <%} %></span></h5></div>
	      <div class="col-md-7">
	    	 <ol class="breadcrumb ">
	    	 <li class="breadcrumb-item ml-auto"><a	href="MainDashBoard.htm"><i class="fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	    	 <li class="breadcrumb-item">
	         	<a	href="FundApprovalList.htm">Approval List</a>
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

<div class="container">
    <div class="row" style="margin-left:0px !important;margin-right:0px !important;">
        <div class="col-md-12">
            <!-- Big Division -->
            <div class="big-box">
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
                                            <img src="view/images/verifiedIcon.png" width="20" height="20" style="background: transparent;padding: 1px;margin-top: -5px;">
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
								
								    <% if (rcStatusCodeNext != null && (rcStatusCodeNext).equalsIgnoreCase("CHAIRMAN APPROVED")) { %>
								        <button type="button" class="btn btn-primary btn-sm submit" onclick="confirmAction('Approve','A')">
								            Approve
								        </button>
								    <% } else { %>
								        <button type="button" class="btn btn-primary btn-sm submit" onclick="confirmAction('Recommend','RE')">
								            Recommend
								        </button> 								                                              
								    <% } %>
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
/* function confirmAction(action, value) {
    const remarksarea = $('#remarksarea').val().trim();
    
    if (remarksarea === '') {
        alert('Please enter the remarks.');
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
} */

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

<script>
function preventInvalidInput(event) {
    const invalidChars = ['e', 'E', '+', '-', '.'];
    if (invalidChars.includes(event.key)) {
        event.preventDefault();
    }
}
</script>

<script type="text/javascript">

function calculateFBEAmountEdit(count,MonthId,originalMonthFbeAmount)
{
	var ErrorStatus=0;
	 var FBEamount = new Array();
   
		$('input.FBEamountEdit-'+count).each(function() {
			FBEamount.push($(this).val());
		});
		
		var TotalFBEAmount=0;
		if(FBEamount!=null && FBEamount.length !== 0)
		{
			for(var i=0;i<FBEamount.length;i++)
		    {
				if(FBEamount[i]!='')
				{
					TotalFBEAmount=parseFloat(TotalFBEAmount)+parseFloat(FBEamount[i]);
				}
			}
		}
		
		var hiddenProjectId=$("#HiddenProjectId").val();
		var SanctionBalance=$(".SanctionbalanceEdit-"+count).text();
		if(SanctionBalance)
		{
			SanctionBalance=parseFloat(SanctionBalance);
		}
		
		var Sanction=$(".sanctionEdit-"+count).text();
		if(Sanction)
		{
			Sanction=parseFloat(Sanction);
		}
		
		if(Sanction < (parseFloat(TotalFBEAmount)) && hiddenProjectId!='0')
		{
			alert("Total FBE Amount Should Not Be More Than Sanction Cost..!");
			$("#"+MonthId+"-"+count).val(originalMonthFbeAmount);
			ErrorStatus=1;
		}
		else
			{
				$("#FBEamountEdit-"+count).val(TotalFBEAmount);
			}
		
		if(ErrorStatus==1)
		  {
		    $("#"+MonthId+"-"+count).focus();
			$('head').append($('<style> '+"#"+MonthId+"-"+count+':focus { box-shadow: 0 0 4px red !important;border-color: #bf1002 !important; }</style>').attr('class', 'TextBoxBorderRed'));
	 	  }
		  else
			{
				 $(".TextBoxBorderRed,.TextBoxBorderBlue").remove();
				 $('head').append($('<style> '+"#"+MonthId+"-"+count+':focus { box-shadow: 0 0 0 .2rem rgba(0, 123, 255, .25);border-color: #80bdff; }</style>').attr('class', 'TextBoxBorderBlue'));
			}
	}


$(document).ready(function(){
	var FbeMainId=$("#HiddenFbeMainId").val();
	GetBudgetItemEditList(FbeMainId);
});

function GetBudgetItemEditList(FbeMainId)
{
	var count=0;
	$(".EditRow").remove();
	$.get('GetFBEItemEditList.htm', {
		FbeMainId : FbeMainId
	}, function(responseJson) {
		var result = JSON.parse(responseJson);
		var table = document.getElementById("EditFBEBudgetItem");
		
		if(result.length>0)
			{
				$(".EditPage").fadeIn();
				$.each(result, function(key, value) {
					count++;
					var tbody = table.querySelector('tbody');
					var rows = tbody.rows.length;
					var row = tbody.insertRow(rows);
					row.style.backgroundColor = "white";
					var cell1 = row.insertCell(0);
					var cell2 = row.insertCell(1);
					var cell3 = row.insertCell(2);
					var cell4 = row.insertCell(3);
					var cell5 = row.insertCell(4);
					var cell6 = row.insertCell(5);
					var cell7 = row.insertCell(6);
					var cell8 = row.insertCell(7);
					row.className = "EditRow-"+count;
					cell7.className="cellEdit-"+count;
					cell2.width="20%";
					
					cell1.innerHTML ='<div class="ViewDetails-'+count+'"><i onclick="ViewDetails(\'plus\','+count+')" id="Plus-'+value[0]+'" class="fa fa-plus ViewDetailsplus-'+count+'" aria-hidden="true" style="color:blue;cursor: pointer;"></i></div><input type="hidden" id="ItemForcasted-'+count+'" value="'+value[20]+'">';
					cell2.innerHTML = '<div class="form-inline" style="width:100%;"><input type="checkbox" class="tooltip-container" data-tooltip="Check the box to get all employee(s)" data-position="right" id="employeeCheckBoxEdit-'+count+'" onchange="setAllEmployeeList(\'#Employee\','+count+',\'Edit\','+value[19]+')" style="margin-right: 6px; height: 16px;width: 16px;"><select name="EmployeeEdit" id="EmployeeEdit-' + count + '" class="form-control" required data-container="body" data-live-search="true" style="width:90%;"><option value="" disabled="disabled">Select Employee</option></select></div>';
					cell3.innerHTML ='<select name="BudgetItemEdit" onchange="changeBudgetItemDetails(\'#BudgetItemEdit-'+count+'\','+count+','+"'Edit'"+')" id="BudgetItemEdit-'+count+'" class="form-control" required data-container="body" data-live-search="true" style="width:100%;"><option value="" disabled="disabled">Select BudgetItem</option></select>';
					cell4.innerHTML ='<input class="form-control input-sm ItemNomenclatureEdit"  name="ItemNomenclatureEdit" id="ItemNomenclatureEdit-'+count+'" style="width:100%;font-weight: bold;" type="text" placeholder="&#128073;Enter Item Nomenclature" value="'+value[5]+'">';
					cell5.innerHTML ='<input class="form-control input-sm" style="width:100% !important;font-weight: bold;text-align:right;" id="FBEBalanceEdit-'+count+'" name="FBEBalanceEdit" type="number" value="'+value[21]+'" readonly="readonly" onkeydown="preventInvalidInput(event)"/>';
					cell6.innerHTML ='<input class="form-control input-sm FBEamountEdit" style="width:100%;font-weight: bold;text-align:right;" id="FBEamountEdit-'+count+'" name="FBEamountEdit" type="number" value="'+value[6]+'" oninput="limitDigits(this, 15)" readonly="readonly" onkeydown="preventInvalidInput(event)"/>';
					cell7.innerHTML ='<button type="button" onclick="SubmitEditFBEItemDetails('+count+','+value[0]+','+value[6]+')" class="btn btn-sm edit-icon editButton-'+count+'"><i class="fa-solid fa-pen-to-square" style="color:#F66B0E;"></i></button>';
					cell8.innerHTML = '<button type="button" onclick="confirmDelete('+count+','+value[0]+')" class="btn btn-sm delete-icon"><i class="fa-solid fa-trash" style="color:#FF4C4C;"></i></button>';
					cell7.style.verticalAlign = "middle";
					cell7.style.textAlign = "center";
					cell8.style.textAlign = "center";
					cell1.style.textAlign = "center";
					cell1.style.padding = "10px";
					cell1.style.fontWeight = "bold"; 
					cell1.style.color = "#090957"; 
					cell1.style.padding = "10px";
					cell1.style.padding = "10px";
					cell2.style.padding = "10px";
					cell3.style.padding = "10px";
					cell4.style.padding = "10px";
					cell5.style.padding = "10px";
					cell6.style.padding = "10px";
					cell7.style.padding = "10px";
					cell8.style.padding = "10px";
					
					rows = table.rows.length;
					row = table.insertRow(rows);
					cell1 = row.insertCell(0);
					cell2 = row.insertCell(1);
					row.className = "EditRowDetails EditRowDetails-"+count;
					
					var divisionId=$("#divisionIdHidden").val();
					GetEmployeeList(false,'#Employee',divisionId,count,'Edit',value[19]);   //GetEmployeeList(isChecked,empIdAttrb,DivisionId,serialNo,Action,selectedEmpId)
					
					var aprMonth='',mayMonth='',juneMonth='',julyMonth='',augustMonth='',
					sepMonth='',octMonth='',novMonth='';decMonth='',janMonth='',febMonth='',
					marMonth='';
					if(value[7]!=null)
						{
							aprMonth=value[7];
						}
					if(value[8]!=null)
						{
							mayMonth=value[8];
						}
					if(value[9]!=null)
						{
							juneMonth=value[9];
						}
					if(value[10]!=null)
						{
							julyMonth=value[10];
						}
					if(value[11]!=null)
						{
							augustMonth=value[11];
						}
					if(value[12]!=null)
						{
							sepMonth=value[12];
						}
					if(value[13]!=null)
						{
							octMonth=value[13];
						}
					if(value[14]!=null)
						{
							novMonth=value[14];
						}
					if(value[15]!=null)
						{
							decMonth=value[15];
						}
					if(value[16]!=null)
						{
							janMonth=value[16];
						}
					if(value[17]!=null)
						{
							febMonth=value[17];
						}
					if(value[18]!=null)
						{
							marMonth=value[18];
						}
					
					var finalDiv='';
					var hiddenProjectId=$("#HiddenProjectId").val();
					var sanctionDivContent='';
					
					if(hiddenProjectId!=null && hiddenProjectId!='' && hiddenProjectId!='0')
						{
						    sanctionDivContent='<div class="flex-container SanctionBalance-'+count+'"  style="width: 90%;margin:auto;background-color: #ffefe3 !important;height:auto;">'+
					        '<div class="form-inline" style="justify-content:center;">'+
						    '<div class="form-inline">'+
						    '<b style="color:#090957;">Sanction Cost&nbsp; :&nbsp; </b>'+
						    '<h2 style="color:red;margin-bottom: 0.7rem;" class="sanctionEdit-'+count+'"></h2>'+
						    '</div>'+
						    
						    '&nbsp;&nbsp;&nbsp;&nbsp;'+
						    
						    '<div class="form-inline">'+
						    '<b style="color:#090957;">Expenditure&nbsp; :&nbsp; </b>'+
						    '<h2 style="color:red;margin-bottom: 0.7rem;" class="expenditureEdit-'+count+'"></h2>'+
						    '</div>'+
						    
    						'&nbsp;&nbsp;&nbsp;&nbsp;'+
						    
						    '<div class="form-inline">'+
						    '<b style="color:#090957;">Balance&nbsp; :&nbsp; </b>'+
						    '<h2 style="color:red;margin-bottom: 0.7rem;" class="SanctionbalanceEdit-'+count+'"></h2>'+
						    '</div>'+
						    
						    
						    '&nbsp;&nbsp;&nbsp;&nbsp;'+
						    
						    '<div class="form-inline">'+
						    '<b style="color:#090957;">O/S Cost&nbsp; :&nbsp; </b>'+
						    '<h2 style="color:red;margin-bottom: 0.7rem;" class="OutCommitmentEdit-'+count+'"></h2>'+
						    '</div>'+
						    
						    '&nbsp;&nbsp;&nbsp;&nbsp;'+
						    
						    '<div class="form-inline">'+
						    '<b style="color:#090957;">DIPL&nbsp; :&nbsp; </b>'+
						    '<h2 style="color:red;margin-bottom: 0.7rem;" class="DiplEdit-'+count+'"></h2>'+
						    '</div>'+
						    
						    '&nbsp;&nbsp;&nbsp;&nbsp;'+
						    
						    '<div class="form-inline">'+
						    '<b style="color:#090957;">New Proposal&nbsp; :&nbsp; </b>'+
						    '<h2 style="color:red;margin-bottom: 0.7rem;" class="SanctionNewProposalEdit-'+count+'"></h2>'+
						    '</div>'+
						    
						    '&nbsp;&nbsp;&nbsp;&nbsp;'+
						    
						    '<div class="form-inline">'+
						    '<b style="color:#090957;">Notional Balance&nbsp; :&nbsp; </b>'+
						    '<h2 style="color:red;margin-bottom: 0.7rem;" class="NotionalBalanceEdit-'+count+'"></h2>'+
						    '</div>'+
						   '</div>'+
							'</div>';
						}
								
					    finalDiv +='<div class="form-inline" style="margin:auto;justify-content:center;width: 85%;background-color: #ffefe3;border-radius: 5px;">'+
					                    sanctionDivContent+
					                     '<div class="inputBox"><input type="number" required value="'+aprMonth+'" id="AprilMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'AprilMonthEdit\','+aprMonth+')"><span>April</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+mayMonth+'" id="MayMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'MayMonthEdit\','+mayMonth+')"><span>May</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+juneMonth+'" id="JuneMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'JuneMonthEdit\','+juneMonth+')"><span>June</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+julyMonth+'" id="JulyMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'JulyMonthEdit\','+julyMonth+')"><span>July</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+augustMonth+'" id="AugustMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'AugustMonthEdit\','+augustMonth+')"><span>August</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+sepMonth+'" id="SeptemberMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'SeptemberMonthEdit\','+sepMonth+')"><span>September</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+octMonth+'" id="OctoberMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'OctoberMonthEdit\','+octMonth+')"><span>October</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+novMonth+'" id="NovemberMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'NovemberMonthEdit\','+novMonth+')"><span>November</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+decMonth+'" id="DecemberMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'DecemberMonthEdit\','+decMonth+')"><span>December</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+janMonth+'" id="JanuaryMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onkeydown="preventInvalidInput(event)" onblur="calculateFBEAmountEdit(' + count + ',\'JanuaryMonthEdit\','+janMonth+')"><span>January</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+febMonth+'" id="FebruaryMonthEdit-'+count+'" name="AprilMonth" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onblur="preventInvalidInput(event)" onkeyup="calculateFBEAmountEdit(' + count + ',\'FebruaryMonthEdit\','+febMonth+')"><span>February</span></div>'+
							             '<div class="inputBox"><input type="number" required value="'+marMonth+'" id="MarchMonthEdit-'+count+'" class="form-control custom-placeholder FBEamountEdit-'+count+'" oninput="limitDigits(this, 15)" onblur="preventInvalidInput(event)" onkeyup="calculateFBEAmountEdit(' + count + ',\'MarchMonthEdit\','+marMonth+')"><span>March</span></div>'+
							         '</div>';
							         
							         
							         cell1.innerHTML=finalDiv;
							         cell1.colSpan=6;
							         cell2.colSpan=2;
							 		 cell1.style.padding = "4px";
							 		 cell1.style.background = "#dadada";
							 		 cell2.style.background = "white";
							 		 cell2.style.verticalAlign = "middle";
							 		 cell2.style.textAlign = "center";
						 			 cell2.innerHTML ='<button type="button" onclick="SubmitEditFBEItemDetails('+count+','+value[0]+','+value[6]+')" class="btn btn-sm submit-btn">Update</button>';
							 		 $(".EditRowDetails-"+count).hide();
					
					GetBudgetItemList("#BudgetItemEdit-"+count,value[2],count,'Edit');
					var serialNo=$("#HiddenRowSerialNo").val();
					if(serialNo)
					{
						if(serialNo==count)
						{
							ViewDetails('plus',count);
						}
					}
				});
			}
		else
			{
				$(".EditPage"). fadeOut(100);
			}
	});
}


var PreviousViewDetailsCount=0;

function ViewDetails(Type,count) 
{
	// to close previous FBE details
	if(PreviousViewDetailsCount!=0)
		{
			$(".ViewDetailsminus-"+PreviousViewDetailsCount+",.ViewDetailsplus-"+PreviousViewDetailsCount).remove();
			$(".ViewDetails-"+PreviousViewDetailsCount).append('<span class="fa fa-plus ViewDetailsplus-'+PreviousViewDetailsCount+'" onclick="ViewDetails(\'plus\','+PreviousViewDetailsCount+')" style="color:blue;cursor: pointer;"></span>');
			$(".removeEdit").remove();
	    	$(".editButton-"+PreviousViewDetailsCount).fadeIn();
		}
	
	PreviousViewDetailsCount=count;
	$(".ViewDetailsminus-"+count+",.ViewDetailsplus-"+count).remove();
	$(".EditRowDetails"). fadeOut(100);
	if(Type=='plus')
		{
			$("#RowSerialNo").val(count);
		    $(".EditRowDetails-"+count).fadeIn();
			$(".ViewDetails-"+count).append('<i onclick="ViewDetails(\'minus\','+count+')" class="fa fa-minus ViewDetailsminus-'+count+'" aria-hidden="true" style="color:red;cursor: pointer;"></i>');
			$(".editButton-"+count).hide();
			$(".cellEdit-"+count).append("<span class='removeEdit' style='font-weight:800;'>***</span>");
		}
	else if(Type=='minus')
		{
			$("#RowSerialNo").val('0');
	        $(".EditRowDetails-"+count). fadeOut(100);
	    	$(".ViewDetails-"+count).append('<span class="fa fa-plus ViewDetailsplus-'+count+'" onclick="ViewDetails(\'plus\','+count+')" style="color:blue;cursor: pointer;"></span>');
	    	$(".removeEdit").remove();
	    	$(".editButton-"+count).fadeIn();
		}
	
}


function GetBudgetItemList(DropDownId,BudgetItemId,count,type)
{
	var project= $("#HiddenProjectDetails").val(); 
	var budgetHeadId = $("#HiddenBudgetHeadDetails").val();
	
	$.get('SelectbudgetItem.htm', {
		projectid : project,
		budgetHeadId : budgetHeadId
	}, function(responseJson) {
		var result = JSON.parse(responseJson);
		$.each(result, function(key, value) {
			if(BudgetItemId!=null && BudgetItemId!='' && BudgetItemId==value.budgetItemId)
				{
					$(DropDownId).append("<option value="+value.budgetItemId+" Selected='Selected'>"+ value.headOfAccounts+"  ["+value.subHead+"]</option>");
				}
			else
				{
					$(DropDownId).append("<option value="+value.budgetItemId+" >"+ value.headOfAccounts+"  ["+value.subHead+"]</option>");
				}
		});
		$(DropDownId).select2();
		if(project!=null && project!='' && typeof(project)!='undefined' && project!='0')
			{
				SetSanctionDetails(project.split("#")[0],$(DropDownId).val(),count,type,budgetHeadId);
			}
		
	});
	}
	
function setAllEmployeeList(empIdAttrb,serialNo,Action,selectedEmpId)
{
	 var divisionId=$("#divisionIdHidden").val();
	 var employeeCheck=Action=='Add'? "#employeeCheckBoxAdd-" : "#employeeCheckBoxEdit-"
	 var isChecked = $(employeeCheck + serialNo).is(":checked");
	 GetEmployeeList(isChecked,empIdAttrb,divisionId,serialNo,Action,selectedEmpId);
}


function GetEmployeeList(isChecked,empIdAttrb,DivisionId,serialNo,Action,selectedEmpId) {
    const targetUrl = isChecked ? 'GetUserNameList.htm' : 'GetUserNameListByDivisionId.htm';
    const requestData = isChecked ? {} : { DivisionId: DivisionId };
    const initiatingSelect = $(empIdAttrb+Action+'-'+serialNo);

    $.ajax({
        url: targetUrl,
        method: 'GET',
        data: requestData,
        dataType: 'json',
        success: function(newList) {
        	
            initiatingSelect.empty(); // Clear existing options
            initiatingSelect.append('<option value="" disabled>Select Employee</option>'); // Add default option

            // Add new options based on the response
            $.each(newList, function(index, obj) {
                const option = $('<option></option>').val(obj[0]).text(obj[6]).addClass('option-class');

                if (Action === "Edit") {   
                    if (selectedEmpId == obj[0]) {
                        option.prop('selected', true); // Set as selected for "Edit"
                    }
                }

                initiatingSelect.append(option);
            });

            initiatingSelect.select2();
        },
        error: function(xhr, status, error) {
            console.error('There was a problem with the AJAX request for initiating officers:', error);
        }
    });
}
	
function changeBudgetItemDetails(AttributeId,count,type)
{
		 var ProjectId= $("#HiddenProjectDetails").val(); 
		 var BudgetHeadId= $("#HiddenBudgetHeadDetails").val(); 
		 var BudgetItemId=$(AttributeId).val();
		 if(ProjectId!=null && ProjectId!='0')
		 {
			 SetSanctionDetails(ProjectId.split("#")[0],BudgetItemId,count,type,BudgetHeadId);
		 }
		 
}
	
function SetSanctionDetails(ProjectId,BudgetItemId,count,type,BudgetHeadId)
{
	var finYear=$("#HiddenFinYear").val();
	$.get('FetchSanctionDetailsForFBE.htm', {
		projectid : ProjectId,
		budgetitemId : BudgetItemId,
		FinancialYear : finYear,
		BudgetHeadId:BudgetHeadId
		
	}, function(responseJson) {
		
		$('.SanctionBalance-'+count).fadeIn();
		
		var result = JSON.parse(responseJson);
		
		if(result!=null)
			{
				$(".sanction"+type+"-"+count).html("<b>"+result.Sanction+"</b>");
				$(".expenditure"+type+"-"+count).html("<b>"+result.Expenditure+"</b>");
				$(".OutCommitment"+type+"-"+count).html("<b>"+result.OutCommitment+"</b>");
				$(".Dipl"+type+"-"+count).html("<b>"+result.Dipl+"</b>");
				$(".SanctionNewProposal"+type+"-"+count).html("<b>"+(result.NewProposal)+"</b>");
				$(".NotionalBalance"+type+"-"+count).html("<b>"+result.NotionalBalance+"</b>");
				$(".Sanctionbalance"+type+"-"+count).html("<b>"+result.Balance+"</b>");
			}
		else{
				$(".sanction"+type+"-"+count).html("<b>0</b>");
				$(".expenditure"+type+"-"+count).html("<b>0</b>");
				$(".OutCommitment"+type+"-"+count).html("<b>0</b>");
				$(".Dipl"+type+"-"+count).html("<b>0</b>");
				$(".SanctionNewProposal"+type+"-"+count).html("<b>0</b>");
				$(".NotionalBalance"+type+"-"+count).html("<b>0</b>");
				$(".Sanctionbalance"+type+"-"+count).html("<b>0</b>");
		}
	});
	
	}
	
function SubmitEditFBEItemDetails(count,FbeSubId,originalFBEAmount)
{
	var status=1;
	var BudgetItem=$("#BudgetItemEdit-"+count).val();
	var Item=$("#ItemNomenclatureEdit-"+count).val();
	var FBEAmount=$("#FBEamountEdit-"+count).val();
	
	$("#BudgetItemEditAction").val(BudgetItem);
	$("#ItemNomenclatureEditAction").val(Item);
	$("#FBEamountEditAction").val(FBEAmount);
	$("#FbeSubId").val(FbeSubId);
	$("#Action").val("E");
	
	var Apr=$("#AprilMonthEdit-"+count).val();
	if(Apr!=null && Apr!='' && typeof(Apr)!='undefined')
		{
			$("#AprilMonthEdit").val(Apr);
		}
	
	var May=$("#MayMonthEdit-"+count).val();
	if(May!=null && May!='' && typeof(May)!='undefined')
	{
		$("#MayMonthEdit").val(May);
	}
	
	var Jun=$("#JuneMonthEdit-"+count).val();
	if(Jun!=null && Jun!='' && typeof(Jun)!='undefined')
	{
		$("#JuneMonthEdit").val(Jun);
	}
	
	var Jul=$("#JulyMonthEdit-"+count).val();
	if(Jul!=null && Jul!='' && typeof(Jul)!='undefined')
	{
		$("#JulyMonthEdit").val(Jul);
	}
	
	var Aug=$("#AugustMonthEdit-"+count).val();
	if(Aug!=null && Aug!='' && typeof(Aug)!='undefined')
	{
		$("#AugustMonthEdit").val(Aug);
	}
	
	var Sep=$("#SeptemberMonthEdit-"+count).val();
	if(Sep!=null && Sep!='' && typeof(Sep)!='undefined')
	{
		$("#SeptemberMonthEdit").val(Sep);
	}
	
	var Oct=$("#OctoberMonthEdit-"+count).val();
	if(Oct!=null && Oct!='' && typeof(Oct)!='undefined')
	{
		$("#OctoberMonthEdit").val(Oct);
	}
	
	var Nov=$("#NovemberMonthEdit-"+count).val();
	if(Nov!=null && Nov!='' && typeof(Nov)!='undefined')
	{
		$("#NovemberMonthEdit").val(Nov);
	}
	
	var Dec=$("#DecemberMonthEdit-"+count).val();
	if(Dec!=null && Dec!='' && typeof(Dec)!='undefined')
	{
		$("#DecemberMonthEdit").val(Dec);
	}
	
	var Jan=$("#JanuaryMonthEdit-"+count).val();
	if(Jan!=null && Jan!='' && typeof(Jan)!='undefined')
	{
		$("#JanuaryMonthEdit").val(Jan);
	}
	
	var Feb=$("#FebruaryMonthEdit-"+count).val();
	if(Feb!=null && Feb!='' && typeof(Feb)!='undefined')
	{
		$("#FebruaryMonthEdit").val(Feb);
	}
	
	var Mar=$("#MarchMonthEdit-"+count).val();
	if(Mar!=null && Mar!='' && typeof(Mar)!='undefined')
	{
		$("#MarchMonthEdit").val(Mar);
	}
	
	var Sanction=$(".sanctionEdit-"+count).text();
	var SanctionBalance=$(".SanctionbalanceEdit-"+count).text();
	
	if(Item==null || Item=='' || typeof(Item)=='undefined')
		{
			alert("Enter Item Nomenclature For Selected BudgetCode..!");
			status=0;
		}
	else if(FBEAmount==null || FBEAmount=='' || typeof(FBEAmount)=='undefined')
		{
			alert("FBE Amount Should Not Be 0 or Empty..!");
			status=0;
		}
	else if(parseFloat(Sanction) < parseFloat(FBEAmount))
		{
			alert("Total FBE Amount Should Not Be More Than Sanction Cost..!");
			status=0;
		}
		
		if(status==1)
			{
				var form=$("#FbeItemFormEdit");
				if(form)
					{
					var ConfirmMessage=confirm("Are You Sure To Edit Items For Selected Budget Code: " + $("#ItemBudgetHeadCode").val());
					if(ConfirmMessage)
						{
							form.submit();
						}
					}
			}
}

/* else if(parseFloat(originalFBEAmount)==parseFloat(FBEAmount))
{
	alert("FBE Amount Remain The Same..!");
	status=0;
} */

</script>
<script type="text/javascript">
function confirmDelete(count, FbeSubId) {
	 console.log("Delete button clicked for count:", count, "FbeSubId:", FbeSubId);
    $("#FbeSubId").val(FbeSubId);
    $("#Action").val("D");
    var form = $("#FbeItemFormEdit");
    if (form) {
        var ConfirmMessage = confirm("Are You Sure To Delete Items?");
        if (ConfirmMessage) {
            form.submit();
        }
    }
}

</script>
</html>