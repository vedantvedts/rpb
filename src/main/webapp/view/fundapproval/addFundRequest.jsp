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
<%@ page import="jakarta.servlet.http.HttpSession"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<jsp:include page="../static/header.jsp"></jsp:include>
<title>Requisition Add</title>
<style>

 	.submit{
 	text-align-last: center;
 	}
 
 
 #selProject,#selbudgethead,#selbudgetitem
	{
	flex:auto !important;
	}
	
	label
	{
		color:#090957;
	}
	
	.select2-container--default.select2-container--disabled .select2-selection--single ,.form-control:disabled, .form-control[readonly]
	{
	    background-color: #fff8e2;
	    cursor: default;
    }
    
     #TableDemand th, #TableDemand td {
      border: 1px solid #dfdfdf36;
      padding:12px !important;
    }
    
  .custom-tooltip {
    position: absolute;
    background-color: #23608c;  /* Tooltip background */
    color: white;               /* Text color */
    font-weight: 600;
    padding: 7px 14px;
    font-size: 14px;
    border-radius: 5px;
    display: none;
    pointer-events: none;
    z-index: 9999;

    /* Responsive adjustments */
    max-width: 90vw;  /* Limit tooltip width to 90% of the viewport */
    white-space: normal; 
    word-wrap: break-word; 
    overflow-wrap: break-word;
}

/* Responsive Font and Padding Adjustments */
@media screen and (max-width: 768px) {
    .custom-tooltip {
        font-size: 12px; 
        padding: 5px 10px; 
    }
}

@media screen and (max-width: 480px) {
    .custom-tooltip {
        font-size: 10px;
        padding: 4px 8px;
        max-width: 80vw; 
    }
}

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
    margin-left: 3%;
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
  
  .selectall:checked
  {
 	 box-shadow: 0px 0px 7px green;
  }
  
  .selectall:not(:checked) 
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

/* .dashboard-card {
    min-height: 746px !important;
    max-height: 646px !important;
}

     */
</style>


</head>
<body>
 <%
 String action=(String)request.getAttribute("ActionType"); 
      String logintype= (String)session.getAttribute("LoginType");
      String InitiationDate= (String)session.getAttribute("InitiationDate");
      FundApprovalBackButtonDto dto = (FundApprovalBackButtonDto) session.getAttribute("FundApprovalAttributes");
      
     Object[] FundRequestObj = (Object[])request.getAttribute("FundRequestObj");
     String filesize=  (String)request.getAttribute("filesize");
     List<Object[]> AttachList = (List<Object[]>)request.getAttribute("attachList");

      	String FinYear=(String)(dto.getFromYearBackBtn()+"-"+dto.getToYearBackBtn());
 %>
  	    <%String success=(String)request.getParameter("resultSuccess"); 
              String failure=(String)request.getParameter("resultFailure");%>
              
              <%String BudgetYear=null;
			           		  String BudgetYearType=null;
			           		if(dto!=null)
			           		{
			           			if(dto.getEstimatedTypeBackBtn()!=null && dto.getEstimatedTypeBackBtn().equalsIgnoreCase("F"))
			           			{
				           			BudgetYear=dto.getFBEYear();
				           			BudgetYearType="FBE Year";
				           		}
			           			else
				           			{
				           				if(dto.getFromYearBackBtn()!=null && dto.getToYearBackBtn()!=null)
				           				{
				           					BudgetYear=dto.getFromYearBackBtn()+"-"+dto.getToYearBackBtn();
				           					BudgetYearType="RE Year";
				           				}
				           				else
				           				{
				           					BudgetYear="-";
				           					BudgetYearType="***";
				           				}
				           			}
			           			
			           			if(dto.getFromYearBackBtn()!=null && dto.getToYearBackBtn()!=null)
		           				{
			           				FinYear=dto.getFromYearBackBtn()+"-"+dto.getToYearBackBtn();
		           				}
		           				else
		           				{
		           					FinYear="-";
		           				}
			           		}%>
<div class="card-header page-top">
	 	<div class="row">
	 	 <%if(action!=null && action.equalsIgnoreCase("Edit")) {%>
	 	  <div class="col-md-3"><h5>Requisition Edit</h5></div>
	 	  <%} else{ %><div class="col-md-3"><h5>Requisition Add</h5> </div><%} %>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="FundRequest.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i>Requisition List </a></li>
	         <%if(action!=null && action.equalsIgnoreCase("Edit")) {%> <li class="breadcrumb-item active" aria-current="page">Requisition Edit</li>
	         <%}else{ %><li class="breadcrumb-item active" aria-current="page">Requisition Add</li><%} %>
             </ol>
           </div>
         </div>
       </div> 
     
     
    
  	    
		
      <div class="page card dashboard-card">
            <div class="flex-container" style="background-color:#ffedc6;height: auto;width: 99%;margin: auto;box-shadow: 0px 0px 4px #6b797c;">
			           		<div class="form-inline" style="padding: 10px;">
			           		
			           		    <input type="hidden" id="HiddenFinYear" value="<%=FinYear%>">
			           			<label style="font-size: 19px;"><b><%=BudgetYearType %> :&nbsp;</b></label><span class="spanClass"><%=BudgetYear %></span>
			           		</div>
			           		<div class="form-inline" style="padding: 10px;">
			           			
			           			<%if(action!=null && action.equalsIgnoreCase("Add")){ %>
			           			<label style="font-size: 19px;"><b>Division :&nbsp;</b></label><span class="spanClass"><% if(dto!=null && dto.getDivisionName()!=null){%><%=dto.getDivisionName() %>&nbsp;<%}else{ %>-<%} %><% if(dto!=null && dto.getDivisionCode()!=null){%>(<%=dto.getDivisionCode() %>)<%}%></span>
			           		<%} else { %>
			           			<label style="font-size: 19px;"><b>Division :&nbsp;</b></label><span class="spanClass"><%if(FundRequestObj!=null) {%><%=FundRequestObj[29] %> (<%=FundRequestObj[28] %>)<%} else{ %>-<%} %></span>
			           			<%} %>
			           		</div>
			           </div>
				<div class="card-body">		
				<form  action="AddFundRequestSubmit.htm" method="post" id="AddFundRequestForm" enctype="multipart/form-data" onsubmit="return validateFormFields();">
 					<%if(action!=null && action.equalsIgnoreCase("Edit")) {%>
 					<input type="hidden" name="Action" value="Update">
 					<%}else{ %>
 					<input type="hidden" name="Action" value="Add">
 					<%} %>
 					
 				<%if(FundRequestObj!=null ){ %>	<input type="hidden" name="fundApprovalId" value="<%=FundRequestObj[0] %>" ><%} %>
 					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
 					<input type="hidden" name="finYear"<%if(FinYear!=null && !FinYear.isEmpty()){ %> value="<%=FinYear %>" <%} %>>
 					<input type="hidden" name="estimatedType"<%if(dto.getEstimatedTypeBackBtn()!=null && !dto.getEstimatedTypeBackBtn().isEmpty()){ %> value="<%=dto.getEstimatedTypeBackBtn() %>" <%} %>>
                   <input type="hidden"  id ="IOId" name="IOId" value="<%= (FundRequestObj != null && FundRequestObj[25] != null) ? FundRequestObj[25].toString() : "0" %>">
                    <input id="divisionCode" type="hidden" name="divisionDetails" value="<%= (FundRequestObj != null && FundRequestObj[28] != null) ? FundRequestObj[2].toString()+"#"+FundRequestObj[28].toString(): "0" %>">
              		  
              		  <input type="hidden" id="divisionId" name="divisionId" <%if(FundRequestObj!=null && FundRequestObj[2]!=null){ %> value="<%=FundRequestObj[2].toString() %>" <%}else{ %> <%if(dto!=null && dto.getDivisionId()!=null){ %>value="<%=dto.getDivisionId() %>" <%} %> <%} %>>
              		  <input id="budgetHeadIdHidden" type="hidden" <%if(FundRequestObj != null && FundRequestObj[6] != null){ %>value="<%=FundRequestObj[6].toString()%>" <%} %>>
              		  <input id="budgetItemIdHidden" type="hidden" <%if(FundRequestObj != null && FundRequestObj[8] != null){ %>value="<%=FundRequestObj[8].toString()%>" <%} %>>
              		  <input id="projectIdHidden" type="hidden" <%if(FundRequestObj != null && FundRequestObj[5] != null){ %>value="<%=FundRequestObj[5].toString()%>" <%} %>>
             		   <input type="hidden" name="reYear" value="<%= dto.getREYear()  %>">
             		    <input type="hidden" name="fbeYear" value="<%= dto.getFBEYear() %>">
               
               
                <div class="flex-container" style="height:auto;background-color: transparent;margin-top:0.5rem;" data-select2-id="84">	
                   
              <div class="form-inline" data-select2-id="98">
                         <label style="font-weight: bold;">Budget <span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span>&nbsp;&nbsp;</label>
                            <select id="selProject" name="projectSel" class="form-control select2" style="width:100%;">
							    <option  value="" >Select Budget</option>
							  <option value="0"  <%if(FundRequestObj!=null){ %>  selected="selected" <%} %>	 >GEN (General)</option>
					     </select>
              </div>
                    
                   <div class="form-inline" data-select2-id="27">
                        <label style="font-weight: bold;">Budget Head <span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span>&nbsp;&nbsp;</label>
							<select id="selbudgethead" name="budgetHeadId" class="form-control select2 readOnlyClass" required="required" style="width:100%;" data-live-search="true">
                               
                                <option value="">Select BudgetHead</option>
                               <%-- <%if(FundRequestObj!=null){ %>  <option value="0" selected="selected" ><%=FundRequestObj[7] %><option><%} %> --%>
                      	  </select>                  
                    </div>
                   
                   
                   <div class="form-inline">
                        <label style="font-weight: bold;">Budget Item <span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span>&nbsp;&nbsp;</label>
							<select id="selbudgetitem" name="budgetItemId" class="form-control select2 readOnlyClass" required="required" style="width:100%;" data-live-search="true">
							 <%if(FundRequestObj!=null){ %>  <option value="0" selected="selected" ><%=FundRequestObj[9] %><option><%} %>
							     <option value="">Select BudgetItem</option>
					 		   </select>              
			         </div>
			          <div class="form-inline" style="display: flex; flex-direction: column;">
					    <label style="font-weight: bold;padding-right: 50%;">Initiation Date<span class="text-danger">*</span></label>
					    <input style="background-color:white;width: 100%" type="text" readonly id="InitiationDate" name="InitiationDate" required class="form-control" <%if(FundRequestObj!=null && FundRequestObj[30]!=null){ %>value="<%=DateTimeFormatUtil.getSqlToRegularDate(FundRequestObj[30].toString()) %>"<%} %>>       
					</div>
			         
                  </div>
               
		          
		            
       <div class="form-group" style="background: white;margin-top: 0.5%;background-color:transparent !important">
          <div class="table-responsive" style="margin-top: 0.7rem;">
	           <table class="table table-bordered" style="width: 90%; margin-left: auto;margin-right: auto;background-color:white !important;box-shadow: 0px 0px 3px 1px #ffddb4;margin-top: 7px;" id="TableDemand">
                  <tbody>
                       <tr class="InsertRow-1">
										
							 <th style="width: 15%;"><label class="col-sm-4 control-label text-nowrap" for="textinput">Initiating Officer<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></label></th>
										   
						    <td style="padding:7px;">
						    
						    <div class="form-inline">
						    
					           <input type="checkbox" class="tooltip-container" id="AllOfficers" name="AllOfficers" data-tooltip="check the box to get all employee(s)" data-position="top">&nbsp;
                       <select name="OfficerCode" id="OfficerCode" class="form-control officerCode select2"
                             data-container="body" data-live-search="true"  style="align-items: center; font-size: 5px;width: 95%">
                         <%--   <%if(FundRequestObj!=null){ %>  <option value="0" selected="selected" ><%=FundRequestObj[26] %>, <%=FundRequestObj[27] %><option> <%} %> --%>
                              <option value="">Select Officer</option>
                             </select>
                             <input type="hidden" id="fbeItemEmployee"  value="<%= (FundRequestObj != null && FundRequestObj[25] != null) ? FundRequestObj[25].toString() : "0" %>">
						    </div>
						     
						    </td> 
						    
						     <th style="width: 15%;"><label class="col-sm-4 control-label text-nowrap" for="textinput">Item Nomenclature<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></label></th>
                     <td><input type="text" placeholder="Enter Item Detail" maxlength="4000" id="ItemFor" name="ItemFor" class="form-control" <%if(FundRequestObj!=null && FundRequestObj[10]!=null){ %> value="<%=FundRequestObj[10] %>" <%} %>></td>
						    
						</tr>
						
						 <tr>
	                    <th style="width: 15%;"><label class="col-sm-4 control-label text-nowrap" for="textinput">Justification<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></label></th>
                        <td><textarea placeholder="Enter Justification" id="fileNo" maxlength="500" name="fileno" required="required" class="form-control"><%if(FundRequestObj!=null && FundRequestObj[11]!=null){ %> <%=FundRequestObj[11] %> <%} %></textarea></td>
	                  <th style="width: 15%;"><label class="col-sm-4 control-label text-nowrap" for="textinput">Estimated Cost<span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span></label></th>
					<td style="padding:7px;"><input class="form-control input-sm FBEAmountAdd" style="width:100%;font-weight: 600;" id="FBEamountAdd-1" name="FBEamount" type="text" <%if(FundRequestObj!=null && FundRequestObj[24]!=null){ %> value="<%=FundRequestObj[24] %>" <%} %> onkeydown="preventInvalidInput(event)" readonly="readonly"/></td> 
                     </tr>
										
										<tr class="InsertRow-1">
										    <td style="padding:7px;" colspan="4">
										    <div class="form-inline" style="justify-content:center;width: 100%;background-color: #ffefe3;border-radius: 5px;">
								             <div class="inputBox"><input required type="number" id="AprilMonthAdd-1" name="AprilMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','AprilMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[12]!=null && new BigDecimal(FundRequestObj[12].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[12] %>" <%} %>><span>April</span></div>
								             <div class="inputBox"><input required type="number" id="MayMonthAdd-1" name="MayMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','MayMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[13]!=null && new BigDecimal(FundRequestObj[13].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[13] %>" <%} %>><span>May</span></div>
								             <div class="inputBox"><input required type="number" id="JuneMonthAdd-1" name="JuneMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','JuneMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[14]!=null && new BigDecimal(FundRequestObj[14].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[14] %>" <%} %>><span>June</span></div>
								             <div class="inputBox"><input required type="number" id="JulyMonthAdd-1" name="JulyMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','JulyMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[15]!=null && new BigDecimal(FundRequestObj[15].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[15] %>" <%} %>><span>July</span></div>
								             <div class="inputBox"><input required type="number" id="AugustMonthAdd-1" name="AugustMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','AugustMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[16]!=null && new BigDecimal(FundRequestObj[16].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[16] %>" <%} %>><span >August</span></div>
								             <div class="inputBox"><input required type="number" id="SeptemberMonthAdd-1" name="SeptemberMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','SeptemberMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[17]!=null && new BigDecimal(FundRequestObj[17].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[17] %>" <%} %>><span>September</span></div>
								             <div class="inputBox"><input required type="number" id="OctoberMonthAdd-1" name="OctoberMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','OctoberMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[18]!=null && new BigDecimal(FundRequestObj[18].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[18] %>" <%} %>><span>October</span></div>
								             <div class="inputBox"><input required type="number" id="NovemberMonthAdd-1" name="NovemberMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','NovemberMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[19]!=null && new BigDecimal(FundRequestObj[19].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[19] %>" <%} %>><span>November</span></div>
								             <div class="inputBox"><input required type="number" id="DecemberMonthAdd-1" name="DecemberMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','DecemberMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[20]!=null && new BigDecimal(FundRequestObj[20].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[20] %>" <%} %>><span>December</span></div>
								             <div class="inputBox"><input required type="number" id="JanuaryMonthAdd-1" name="JanuaryMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','JanuaryMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[21]!=null && new BigDecimal(FundRequestObj[21].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[21] %>" <%} %>><span>January</span></div>
								             <div class="inputBox"><input required type="number" id="FebruaryMonthAdd-1" name="FebruaryMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','FebruaryMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[22]!=null && new BigDecimal(FundRequestObj[22].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[22] %>" <%} %>><span>February</span></div>
								             <div class="inputBox"><input required type="number" id="MarchMonthAdd-1" name="MarchMonth" class="form-control custom-placeholder FBEamountAdd-1" onkeydown="preventInvalidInput(event)" onkeyup="calculateFBEAmountAdd('1','MarchMonthAdd')" oninput="limitDigits(this, 15)" <%if(FundRequestObj!=null && FundRequestObj[23]!=null && new BigDecimal(FundRequestObj[23].toString()).compareTo(java.math.BigDecimal.ZERO) != 0){ %> value="<%=FundRequestObj[23] %>" <%} %>><span>March</span></div>
								             </div></td> 
										</tr>
                     
                     	
                     
                     <tr>
                        <td colspan="4" align="center"><span style="font-size: 19px;color:#034189;font-weight: 600;background-color: #ffae4e6b;padding: 10px;padding-top:7px;padding-bottom:7px; border-radius: 5px;font-family: math;">Enclosures</span></td>
                     </tr>
                     
                   
                     
                
                 <tr>
                 <td colspan="4" style="padding-top:25px !important;padding-bottom: 25px !important;">
                 
					<table style="width: 60%; text-align: center;margin:auto;box-shadow: 6px 6px 8px #d1d1d1;" id="attachmentTable">
    <thead>
    <% if (AttachList != null && !AttachList.isEmpty()) { %>
        <tr>
            <th style="font-weight: 600;">File Name</th>
            <th style="font-weight: 600;">
                <% if ("Add".equalsIgnoreCase(action)) { %>Attachment<% } else { %>Replace Attachment<% } %>
            </th>
            <th style="font-weight: 600;">Actions</th>
           
            
        </tr>
        <%}else { %>
        <tr>
            <th style="font-weight: 600;">File Name</th>
            <th style="font-weight: 600;">
                <% if ("Add".equalsIgnoreCase(action)) { %>Attachment<% } else { %>Replace Attachment<% } %>
            </th>
            
        </tr>
        <%} %>
    </thead>
    <tbody id="attachmentBody">
        <!-- Existing Attachments -->
     <%--    <% if (AttachList != null && !AttachList.isEmpty()) {
            for (Object[] attach : AttachList) { %>
                <tr>
             <td>
                <input type="text" class="form-control" name="filename" maxlength="255"	 value="<%=attach[1]%>" readonly="readonly">
            </td>
            <td>
                <input type="file" class="form-control" name="attachment" onchange="Filevalidation(this);">
            </td>
             <td>
                        <button type="button" class="btn" onclick="downloadFile('<%=attach[0]%>')" title="<%=attach[2]%>">
                            <i class="fa fa-download" style="color: green;"></i>
                        </button>
                        
                         <button type="button" class="btn" onclick="deleteFile('<%=attach[0]%>')" title="Delete File">
                            <i class="fa fa-trash" style="color: red; font-size: 18px;"></i>
                        </button>
                    </td>
                </tr>
        <%  }
        } %> --%>	<!-- var $project= $("#projectIDHiden").val -->

<%!public Object[] findAttachmentByName(List attachList, String name) {
        if (attachList == null || name == null) return null;
        for (int i = 0; i < attachList.size(); i++) {
            Object[] obj = (Object[]) attachList.get(i);
            if (obj[1] != null && obj[1].toString().equalsIgnoreCase(name)) {
                return obj;
            }
        }
        return null;
    }%>
        <!-- First blank input row -->
        <tr class="file-row1">
    <td>
        <input type="text" class="form-control" id="file1" name="filename" readonly="readonly" maxlength="255" value="BQs">
    </td>
    <td>
        <input type="file" class="form-control" id="attachment1" name="attachment" onchange="Filevalidation(this);">
    </td>
    <%
        Object[] bqsAttach = AttachList != null ? findAttachmentByName(AttachList, "BQs") : null;
        if (bqsAttach != null) {
    %>
    <td>
        <button type="button" class="btn" onclick="downloadFile('<%= bqsAttach[0] %>')" title="<%= bqsAttach[2] %>">
            <i class="fa fa-download" style="color: green;"></i>
        </button>
        <button type="button" class="btn" onclick="deleteFile('<%= bqsAttach[0] %>')" title="Delete File">
            <i class="fa fa-trash" style="color: red; font-size: 18px;"></i>
        </button>
    </td>
    <% } %>
</tr>

<tr class="file-row2">
    <td>
        <input type="text" class="form-control" id="file2" name="filename" readonly="readonly" maxlength="255" value="Cost Of Estimate">
    </td>
    <td>
        <input type="file" class="form-control" id="attachment2" name="attachment" onchange="Filevalidation(this);">
    </td>
    <%
        Object[] costAttach = AttachList != null ? findAttachmentByName(AttachList, "Cost Of Estimate") : null;
        if (costAttach != null) {
    %>
    <td>
        <button type="button" class="btn" onclick="downloadFile('<%= costAttach[0] %>')" title="<%= costAttach[2] %>">
            <i class="fa fa-download" style="color: green;"></i>
        </button>
        <button type="button" class="btn" onclick="deleteFile('<%= costAttach[0] %>')" title="Delete File">
            <i class="fa fa-trash" style="color: red; font-size: 18px;"></i>
        </button>
    </td>
    <% } %>
</tr>

<tr class="file-row3">
    <td>
        <input type="text" class="form-control" id="file3" name="filename" readonly="readonly" maxlength="255" value="Justification">
    </td>
    <td>
        <input type="file" class="form-control" id="attachment3" name="attachment" onchange="Filevalidation(this);">
    </td>
    <%
        Object[] justAttach = AttachList != null ? findAttachmentByName(AttachList, "Justification") : null;
        if (justAttach != null) {
    %>
    <td>
        <button type="button" class="btn" onclick="downloadFile('<%= justAttach[0] %>')" title="<%= justAttach[2] %>">
            <i class="fa fa-download" style="color: green;"></i>
        </button>
        <button type="button" class="btn" onclick="deleteFile('<%= justAttach[0] %>')" title="Delete File">
            <i class="fa fa-trash" style="color: red; font-size: 18px;"></i>
        </button>
    </td>
    <% } %>
</tr>

<!-- Always show the fourth row for dynamic attachments -->
<tr class="file-row4">
  <%
        // Check for any non-standard attachments
        List<String> staticNames = java.util.Arrays.asList("BQs", "Cost Of Estimate", "Justification");
        Object[] dynamicAttach = null;
        
        if (AttachList != null) {
            for (Object[] attach : AttachList) {
                String attachName = (attach[1] != null) ? attach[1].toString() : "";
                if (!staticNames.contains(attachName)) {
                    dynamicAttach = attach;
                    break;
                }
            }
        }
        
        if (dynamicAttach != null) {
    %>
    <td>
        <input type="text" class="form-control" id="file4" name="filename" maxlength="255" value="<%= dynamicAttach[1] %>">
    </td>
    <td>
        <input type="file" class="form-control" id="attachment4" name="attachment" onchange="Filevalidation(this);">
    </td>
  
    <td>
        <button type="button" class="btn" onclick="downloadFile('<%= dynamicAttach[0] %>')" title="<%= dynamicAttach[2] %>">
            <i class="fa fa-download" style="color: green;"></i>
        </button>
        <button type="button" class="btn" onclick="deleteFile('<%= dynamicAttach[0] %>')" title="Delete File">
            <i class="fa fa-trash" style="color: red; font-size: 18px;"></i>
        </button>
    </td>
    <% } %>
</tr>


    <tr class="file-row-dynamic">
        <td>
            <input type="text" class="form-control" name="filename"  value="">
        </td>
        <td>
            <input type="file" class="form-control" name="attachment" onchange="Filevalidation(this);">
        </td>
        <td>
        <%
    // Additional rows for any extra dynamic attachments beyond the first one
    if (AttachList != null) {
        int dynamicCount = 0;
        for (Object[] attach : AttachList) {
            String attachName = (attach[1] != null) ? attach[1].toString() : "";
            if (!staticNames.contains(attachName)) {
                dynamicCount++;
                if (dynamicCount > 1) { // We already handled the first one in the static row4
%>
            <button type="button" class="btn" onclick="downloadFile('<%= attach[0] %>')" title="<%= attach[2] %>">
                <i class="fa fa-download" style="color: green;"></i>
            </button>
            <button type="button" class="btn" onclick="deleteFile('<%= attach[0] %>')" title="Delete File">
                <i class="fa fa-trash" style="color: red; font-size: 18px;"></i>
            </button>
        </td>
    </tr>
<%
                }
            }
        }
    }
%>


    </tbody>
</table>

                 </td>
		       </tr>
		       
		        <tr>
	          		 <td colspan="4" class="submit">
	          		 <%if(action!=null && action.equalsIgnoreCase("Edit")) {%>
							<input class="btn btn-sm submit-btn" type="button" id="submiting" value="Update" onclick="validateFormFieldsEdit()">
							<%} else{ %>
							<input class="btn btn-sm submit-btn" type="button" id="submiting" value="Submit" onclick="validateFormFields()">
							<%} %>
					</td>
		       </tr>
		
	</tbody></table>	
	   </div>
	   <br><br><br>
	   </div>
	   </form>
				</div>
				
			</div>
			<!-- Hidden form for file download -->
<form id="downloadForm" target="_blank" action="FundRequestAttachDownload.htm" method="get" style="display:none;">
    <input type="hidden" name="attachid" id="downloadFileName">
     <input type="hidden" name="fundRequestId" <%if(FundRequestObj!=null){ %> value="<%=FundRequestObj[0]%>" <%} %>>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>

<!-- Hidden form for file delete -->
<form id="deleteForm" action="FundRequestAttachDelete.htm" method="post" style="display:none;">
    <input type="hidden" name="attachid" id="deleteFileName">
    <input type="hidden" name="fundRequestId"  <%if(FundRequestObj!=null) {%>value="<%=FundRequestObj[0]%>"<%} %> >
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>
			
</body>
<script type="text/javascript">

<%if(success!=null){%>

	showSuccessFlyMessage('<%=success %>');

<%}else if(failure!=null){%>

	showFailureFlyMessage('<%=failure %>');

<%}%>
</script>
  <script type="text/javascript">
  
  $(document).ready(function() {
	  
	  var divisionId=$("#divisionId").val();
	  var selectedEmpId=$("#fbeItemEmployee").val();
	  var Action='<%=action%>';
  	  const initiatingSelect = $("#OfficerCode");
		 $.ajax({
	          url: 'GetUserNameListByDivisionId.htm',
	          method: 'GET',
	          data: { DivisionId: divisionId },
	          dataType: 'json',
	          success: function(newList) {
	        	  
	        	  var matchedStatus='N';
	              initiatingSelect.empty(); // Clear existing options
	              initiatingSelect.append('<option value="" disabled>Select Employee</option>'); // Add default option
	              
	          	if(newList!=null && newList.length>0)
         		{
	                // Add new options based on the response
		              $.each(newList, function(index, obj) {
		                  const option = $('<option></option>').val(obj[0]).text(obj[6]).addClass('option-class');

		                  if (Action === "Edit") {   
		                      if (selectedEmpId == obj[0]) {
		                     	 matchedStatus='Y';
		                          option.prop('selected', true); // Set as selected for "Edit"
		                      }
		                  }

		                  initiatingSelect.append(option);
		              });
         		}
	         	else
         		{
	         		initiatingSelect.append('<option value="-1">No Employee Found</option>');
         		}
	              
	              initiatingSelect.select2();
	              
	              // A - call All Employee List
	              // B - End the List
	              matchedStatus=='N' ? initiatingSelect.data("Employee-Matched", 'A') : initiatingSelect.data("Employee-Matched", 'B');
	              
	              const status = initiatingSelect.data("Employee-Matched");
	              
	 			if(matchedStatus=='N' && Action=='Edit' && status=='A')
	 			{
	 				initiatingSelect.data("Employee-Matched", 'B');
	 				$("#AllOfficers").click();
	 			}
	 			
	          },
	          error: function(xhr, status, error) {
	              console.error('There was a problem with the AJAX request for initiating officers:', error);
	          }
	      });
	  
  });

$("#AllOfficers").click(function(){

	$('.officerCode').find('option').remove();
	var fbeItemEmployee=$("#fbeItemEmployee").val();
	var Checkbox=$('input[name="AllOfficers"]:checked');
	if(Checkbox!=null && Checkbox.length>0)
		{
			$.get('SelectAllemployeeAjax.htm', {
			}, function(responseJson) {
	
					var result = JSON.parse(responseJson);
					if(result.length>0){
						$(".officerCode").append('<option value="" disabled>Select Employee</option>'); // Add default option
						$.each(result, function(key, value) {
							if(fbeItemEmployee!=null && fbeItemEmployee==value[0])
							{
								$(".officerCode").append('<option selected value="'+value[0]+'">'+ value[2] + ', '+ value[3] +'</option>');
							}
							else
								{
									$(".officerCode").append('<option value="'+value[0]+'">'+ value[2] + ', '+ value[3] +'</option>');
								}
						});
					}else{
						$(".officerCode").append("<option value=''>No Officer </option>");
					}
			});
        }
	else
		{
				//var DivisionDetails= $("select#divisionCode").val();
				var DivisionDetails=$("#divisionCode").val();
				if(DivisionDetails!=null && DivisionDetails!=0){
				var arr=DivisionDetails.split("#");
				var divisionId=arr[0];
				$.get('SelectEmployee.htm', {
					DivisionId : divisionId
				}, function(responseJson) {
					
					var result = JSON.parse(responseJson);
					if(result.length>0){
						$.each(result, function(key, value) {
						
							if(fbeItemEmployee!=null && fbeItemEmployee==value.empId)
							{
								$(".officerCode").append('<option selected value="'+value.officerCode+'">'+ value.officerName + ', '+ value.officerDesig +'</option>');
							}
							else
								{
									$(".officerCode").append('<option value="'+value.officerCode+'">'+ value.officerName + ', '+ value.officerDesig +'</option>');
								}
						});
					}else{
						$(".officerCode").append("<option value=''>No Officer </option>");
					}
				 });
		        }
				else
				{
					$(".officerCode").append("<option value=''>Select Officer </option>");
		        }
		}
	});
</script>


<!--**************************Select Budget Head using Ajax**********************************************-->

<script>

 $('#selProject').change(function(event) {
	 
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
									var result = JSON.parse(responseJson);
									$.each(result, function(key, value) {
										$("#selbudgethead").append("<option value="+value.budgetHeadId+">"+ value.budgetHeaddescription + "</option>");
									});
									SetBudgetItem(''); 
							});
                       }
						
					});
					
					$(document).ready(function(event) {
						
								var $project= $("#projectIdHidden").val();
								//projectIDHiden
								
								var $budgetHeadId = $("#budgetHeadIdHidden").val();
								<!------------------Project Id not Equal to Zero [Project]-------------------->
								//alert($budgetHeadId)
								if($project!=null && $project!='')
									{
										var $projectId=$project!=null && $project.split("#")!=null && $project.split("#").length>0 ? $project.split("#")[0] : '0';
										$.get('GetBudgetHeadList.htm', {
											ProjectDetails : $project
										}, function(result) {
											$('#selbudgethead').find('option').remove();
											var result = JSON.parse(result);
											var html1='';
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

		function SetBudgetItem(budgetItemId)
		{
			// Set BudgetItem
			var project= $("select#selProject").val(); 
			var budgetHeadId = $("select#selbudgethead").val();
			//calling controller using ajax for project Drop Down based on projectId
			$.get('SelectbudgetItem.htm', {
				projectid : project,
				budgetHeadId : budgetHeadId
			}, function(responseJson) {
				$('#selbudgetitem').find('option').remove();
				$("#selbudgetitem").append("<option disabled value=''>Select Budget Item </option>");// "disabled" and "selected" attributes to make the option unselectable
					var result = JSON.parse(responseJson);
					$.each(result, function(key, value) {
						if(budgetItemId!=null && budgetItemId==value.budgetItemId)
						{
							$("#selbudgetitem").append("<option selected value="+value.budgetItemId+" >"+ value.headOfAccounts+"  ["+value.subHead+"]</option>");
						}
						else
							{
								$("#selbudgetitem").append("<option value="+value.budgetItemId+" >"+ value.headOfAccounts+"  ["+value.subHead+"]</option>");
							}
						
					});
			});
		}
		
		
</script>
<!------------------Select Officer Using Ajax-------------------->

<script type="text/javascript">
        
        function resetBudgetDetails()
        {
        	 $("#selProject").prop("disabled", false);
        	 $('#selProject').find('option').remove();
			 $("#selProject").append("<option value=''>Select Project</option>");
			 $(".officerCode").find('option').remove();
			 $(".officerCode").append("<option value=''>Select Officer </option>");
        	 var serialNo = $("select#ItemSerialNo").val();
         	 if(serialNo!=null && serialNo!="" && serialNo=='-1')
         	 {
         		projectDetails();
         		employeeDetails('');
         	 }
        	 $("#selbudgethead").prop("disabled", false);
        	 $('#selbudgethead').find('option').remove();
			 $("#selbudgethead").append("<option value=''>Select Budget Head </option>");
			 $("#selbudgetitem").prop("disabled", false);
			 $("#selbudgetitem").find('option').remove();
			 $("#selbudgetitem").append("<option value=''>Select Budget Item </option>");
			 $(".ReFeSpan").html('<span style="font-weight:600;">RE / FE</span>');
        }
        
    /*     function projectDetails()
        {
			$.get('GetProjectList.htm', {}, 
				function(responseJson) {
				var result = JSON.parse(responseJson);
				if(result.length>0){
					$('select#selProject').find('option').remove();
					$("select#selProject").append("<option value=''>Select Project</option>"); 
				    
					$.each(result, function(key, value) 
					{
						if(value[0]!=="-1")
						{
							$("select#selProject").append('<option value="'+ value[0] +'#'+ value[1] +'">'+ value[1] +' ('+ value[12] +')</option>');
						}
					});
				}
			});
        } */
        
        function budgetDetails(projectId,budgetHeadId,budgetItemId,serialNoType)
        {
        	$.get('GetProjectDetailsAjax.htm', {
				
			}, function(responseJson) {
				
				var result = JSON.parse(responseJson);
				if(result.length>0){
					$('select#selProject').find('option').remove();
					$("select#selProject").append("<option disabled value=''>Select Project</option>"); 
					
					 if(projectId!=null && projectId=='0')
					{
						$("select#selProject").append("<option selected value='0'>GEN (General)</option>"); 
					} 
					else
						{
							$("select#selProject").append("<option value='0'>GEN (General)</option>"); 
						} 
					
					/* $.each(result, function(key, value) {
						
						if(projectId!=null && projectId==value[0])
						{
							$("select#selProject").append('<option selected="selected" value="'+ value[0] +'#'+ value[1] +'">'+ value[1] +'('+ value[1] +')</option>');
						}
						else
							{
								$("select#selProject").append('<option value="'+ value[0] +'#'+ value[1] +'">'+ value[1] +'('+ value[1] +')</option>');
							}
					}); */
					
					if(serialNoType=='F')
					{
						$("#selProject").prop("disabled", true);
					}
					
					var project= $("select#selProject").val();  
					
					<!------------------Project Id not Equal to Zero [Project]-------------------->
					
					if(project!=null  && project!='Select Project')
					{
						$.get('GetBudgetHeadList.htm', {
							ProjectDetails : project
						}, function(responseJson) {
							
							$('#selbudgethead').find('option').remove();
							$("#selbudgethead").append("<option disabled value=''>Select Budget Head </option>"); 
								var result = JSON.parse(responseJson);
								$.each(result, function(key, value) {
									if(budgetHeadId!=null && budgetHeadId==value.budgetHeadId)
									{
										$("#selbudgethead").append("<option selected value="+value.budgetHeadId+">"+ value.budgetHeaddescription + "</option>");
									}
									else
										{
											$("#selbudgethead").append("<option value="+value.budgetHeadId+">"+ value.budgetHeaddescription + "</option>");
										}
								});
								
								if(serialNoType=='F')
								{
									$("#selbudgethead").prop("disabled", true);
								}
								
								SetBudgetItem(budgetItemId,serialNoType);
						});
					}
				}
			});
        }
		
</script>


<!------------------Selecting RE and FE While clicking Budget Item in UI(User Interface)------------------->

<script type="text/javascript">
function calculateFBEAmountAdd(rowId, monthPrefix) {
    var total = 0;

    // Loop through all monthly fields inside the row
    var months = [
        "AprilMonthAdd", "MayMonthAdd", "JuneMonthAdd", "JulyMonthAdd",
        "AugustMonthAdd", "SeptemberMonthAdd", "OctoberMonthAdd", "NovemberMonthAdd",
        "DecemberMonthAdd", "JanuaryMonthAdd", "FebruaryMonthAdd", "MarchMonthAdd"
    ];

    months.forEach(function(month) {
        var fieldId = month + "-" + rowId;
        var val = parseFloat(document.getElementById(fieldId)?.value || 0);
        total += isNaN(val) ? 0 : val;
    });

    // Update total to Estimated Cost field
    document.getElementById("FBEamountAdd-" + rowId).value = total.toFixed(2);
}
</script>
<script type="text/javascript">
function preventInvalidInput(event) {
    const key = event.key;
    if (
        !/[0-9]/.test(key) &&
        key !== 'Backspace' &&
        key !== 'Delete' &&
        key !== 'ArrowLeft' &&
        key !== 'ArrowRight' &&
        key !== 'Tab'
    ) {
        event.preventDefault();
    }
}

function validateFormFields() {
    // First validate all required fields
    const budget = document.getElementById("selProject");
    if (!budget || budget.value.trim() === "") {
        alert('Please select a Budget');
        return false;
    }

    const budgetHead = document.getElementById("selbudgethead");
    if (!budgetHead || budgetHead.value.trim() === "") {
        alert('Please select a Budget Head');
        return false;
    }

    const budgetItem = document.getElementById("selbudgetitem");
    if (!budgetItem || budgetItem.value.trim() === "") {
        alert('Please select a Budget Item');
        return false;
    }

    const officerSelect = document.getElementById("OfficerCodeVal");
    const allOfficersCheckbox = document.getElementById("AllOfficers");
    if (officerSelect && (!officerSelect || !officerSelect.checked)) {
        if (officerSelect.value.trim() === "") {
            alert('Please select an Initiating Officer');
            return false;
        }
    }

    const itemFor = document.getElementById("ItemFor");
    if (!itemFor || itemFor.value.trim() === "") {
        alert('Please enter Item Nomenclature');
        return false;
    }

    const justification = document.getElementById("fileNo");
    if (!justification || justification.value.trim() === "") {
        alert('Please enter a Justification');
        return false;
    }

    // Check if at least one month has value
    const monthInputs = document.querySelectorAll('.FBEamountAdd-1');
    let atLeastOneFilled = false;
    monthInputs.forEach(input => {
        if (input.value.trim() !== "") {
            atLeastOneFilled = true;
        }
    });
    
    if (!atLeastOneFilled) {
        alert('Please enter amount for at least one month');
        return false;
    }

    if (confirm('Do you want to Submit?')) {
        document.getElementById("AddFundRequestForm").submit();
        return true;
    }
    
    return false;
}

document.getElementById("AddFundRequestForm").addEventListener("submit", function(e) {
    if (!validateFormFields()) {
        e.preventDefault(); 
    }
});

function validateFormFieldsEdit() {
    // First validate all required fields
    const budget = document.getElementById("selProject");
    if (!budget || budget.value.trim() === "") {
        alert('Please select a Budget');
        return false;
    }

    const budgetHead = document.getElementById("selbudgethead");
    if (!budgetHead || budgetHead.value.trim() === "") {
        alert('Please select a Budget Head');
        return false;
    }

    const budgetItem = document.getElementById("selbudgetitem");
    if (!budgetItem || budgetItem.value.trim() === "") {
        alert('Please select a Budget Item');
        return false;
    }

    const officerSelect = document.getElementById("OfficerCodeVal");
    const allOfficersCheckbox = document.getElementById("AllOfficers");
    if (officerSelect && (!officerSelect || !officerSelect.checked)) {
        if (officerSelect.value.trim() === "") {
            alert('Please select an Initiating Officer');
            return false;
        }
    }

    const itemFor = document.getElementById("ItemFor");
    if (!itemFor || itemFor.value.trim() === "") {
        alert('Please enter Item Nomenclature');
        return false;
    }

    const justification = document.getElementById("fileNo");
    if (!justification || justification.value.trim() === "") {
        alert('Please enter a Justification');
        return false;
    }

    // Check if at least one month has value
    const monthInputs = document.querySelectorAll('.FBEamountAdd-1');
    let atLeastOneFilled = false;
    monthInputs.forEach(input => {
        if (input.value.trim() !== "") {
            atLeastOneFilled = true;
        }
    });
    
    if (!atLeastOneFilled) {
        alert('Please enter amount for at least one month');
        return false;
    }

    if (confirm('Do you want to Update?')) {
        document.getElementById("AddFundRequestForm").submit();
        return true;
    }
    
    return false;
}
</script>
 <script type="text/javascript">
						
    function Filevalidation (fileid) 
    {
        const fi = $('#'+fileid )[0].files[0].size;							 	
        const file = Math.round((fi/1024/1024));
        if (file >= <%=filesize%> ) 
        {
        	alert("File too Big, please select a file less than <%=filesize%> mb");
        } 
    }
</script>  
<script type="text/javascript">
function downloadFile(fileId) {
	$('#downloadFileName').val(fileId);
    document.getElementById("downloadForm").submit();
}

function deleteFile(fileId) {
    if (confirm("This will be Deleted Permanently. Do you want to Delete?")) {
    	
    	$('#deleteFileName').val(fileId);
        document.getElementById("deleteForm").submit();
    }
}

$(document).ready(function() {
    // Add new file row
    $(".btn_add").click(function() {
        var newRow = `
            <tr class="file-row">
                <td><input type="text" class="form-control" name="filename" maxlength="255"></td>
                <td><input type="file" class="form-control" name="attachment" onchange="Filevalidation(this);"></td>
                <td><button type="button" class="btn btn_rem"><i class="fa fa-minus" style="color: red;"></i></button></td>
            </tr>
        `;
        $("#attachmentBody").append(newRow);
    });

    // Remove only non-first file-row
    $(document).on("click", ".btn_rem", function() {
        // Check if it's not the first .file-row
        if (!$(this).closest("tr").is($("#attachmentBody .file-row").first())) {
            $(this).closest("tr").remove();
        }
    });
});


</script>

<script type="text/javascript">
$(document).ready(function() {
    var count = 0;
    
    // Add row handler
    $(document).on('click', '.btn_add', function() {
        var $tr = $(this).closest('table').find('tbody tr.tr_clone').last();
        var $clone = $tr.clone();
        
        // Clear input values
        $clone.find('input').val('');
        
        // Update file input ID and onchange handler
        count++;
        var newId = 'file' + count;
        $clone.find('input[type="file"]').attr('id', newId).attr('onchange', 'Filevalidation("' + newId + '")');
        
        // Remove any existing file/download cells if they exist
        $clone.find('td').slice(3).remove();
        
        // Insert the new row
        $tr.after($clone);
    });

    // Remove row handler
    $(document).on('click', '.btn_rem', function() {
        if ($(this).closest('tbody').find('tr.tr_clone').length > 1) {
            $(this).closest('tr').remove();
        }
    });
});
</script>
    <script type="text/javascript">
    $(document).ready(function() {
        $("#InitiationDate").daterangepicker({
            autoclose: true,
            singleDatePicker: true,
            linkedCalendars: false,
            showCustomRangeLabel: true,
            showDropdowns: true,
            locale: {
                format: 'DD-MM-YYYY'
            }
        });
    });</script>
</html>