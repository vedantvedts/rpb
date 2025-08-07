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
<title>Carry Forward Fund</title>
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

.dashboard-card {
    min-height: 746px !important;
    max-height: 646px !important;
}


 	
</style>


</head>
<body>
 <%
     List<Object[]> carryForwardList = (List<Object[]>)request.getAttribute("carryForwardList");
     FundApprovalBackButtonDto fundApprovalDto=(FundApprovalBackButtonDto) session.getAttribute("FundApprovalAttributes");
     System.out.println("fundApprovalDto*****"+fundApprovalDto);
 %>
<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-3"><h5>Fund Carry Forward</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="MainDashBoard.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i> Home </a></li>
	    	 <li class="breadcrumb-item"><a href="FundRequest.htm">Requisition List </a></li>
	         <li class="breadcrumb-item active" aria-current="page">Fund Carry Forward</li>
             </ol>
           </div>
         </div>
       </div> 
		
      
				<div class="flex-container" style="background-color:#ffedc6;height: auto;width: 99%;margin: auto;box-shadow: 0px 0px 4px #6b797c;">
			           		<div class="form-inline" style="padding: 10px;">
			           		
			           		<%String BudgetYear=null;
			           		  String BudgetYearType=null;
			           		  String FinYear=null;
			           		if(fundApprovalDto!=null)
			           		{
			           			if(fundApprovalDto.getEstimatedTypeBackBtn()!=null && fundApprovalDto.getEstimatedTypeBackBtn().equalsIgnoreCase("F"))
			           			{
				           			BudgetYear=fundApprovalDto.getFBEYear();
				           			BudgetYearType="FBE Year";
				           		}
			           			else
				           			{
				           				if(fundApprovalDto.getFromYearBackBtn()!=null && fundApprovalDto.getToYearBackBtn()!=null)
				           				{
				           					BudgetYear=fundApprovalDto.getFromYearBackBtn()+"-"+fundApprovalDto.getToYearBackBtn();
				           					BudgetYearType="RE Year";
				           				}
				           				else
				           				{
				           					BudgetYear="-";
				           					BudgetYearType="***";
				           				}
				           			}
			           			
			           			if(fundApprovalDto.getFromYearBackBtn()!=null && fundApprovalDto.getToYearBackBtn()!=null)
		           				{
			           				FinYear=fundApprovalDto.getFromYearBackBtn()+"-"+fundApprovalDto.getToYearBackBtn();
		           				}
		           				else
		           				{
		           					FinYear="-";
		           				}
			           		}%>
			           		
			           		    <input type="hidden" id="HiddenFinYear" value="<%=FinYear%>">
			           			<label style="font-size: 19px;"><b><%=BudgetYearType %> :&nbsp;</b></label><span class="spanClass"><%=BudgetYear %></span>
			           		</div>
			           		<div class="form-inline" style="padding: 10px;">
			           			<label style="font-size: 19px;"><b>Division :&nbsp;</b></label><span class="spanClass"><% if(fundApprovalDto!=null && fundApprovalDto.getDivisionName()!=null){%><%=fundApprovalDto.getDivisionName() %>&nbsp;<%}else{ %>-<%} %><% if(fundApprovalDto!=null && fundApprovalDto.getDivisionCode()!=null){%>(<%=fundApprovalDto.getDivisionCode() %>)<%}%></span>
			           		</div>
			           		<div class="form-inline" style="padding: 10px;">
			           			<label style="font-size: 19px;"><b>Project :&nbsp;</b></label><span class="spanClass">GEN (GENERAL)</span>
			           		</div>
				           	 <div class="form-inline" style="padding: 10px;">
	                            <label style="font-weight: bold;">Budget Head <span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span>&nbsp;&nbsp;</label>
								<select id="selbudgethead" name="budgetHeadId" class="form-control select2 readOnlyClass" required="required" style="width:200px;" data-live-search="true">
	                                <option value="">Select Budget Head</option>
	                      	    </select>                  
	                         </div>
	                         
	                          <div class="form-inline budgetItemDetails" style="padding: 10px;">
                        		<label style="font-weight: bold;">Budget Item <span class="mandatory" style="color: red;font-weight: normal;">&nbsp;*</span>&nbsp;&nbsp;</label>
								<select id="selbudgetitem" name="budgetItemId" class="form-control select2 readOnlyClass" required="required" style="width:400px;" data-live-search="true">
								    <option value="">Select BudgetItem</option>
						 		   </select>              
				             </div>
			           </div>
		
  <div class="page card dashboard-card" style="margin-top: 5px;max-height: 442px !important;min-height: 442px;">
 
	<div class="card-body" style="background-color:white;">		
								
		<form action="CarryForwardDetails.htm" id="CFForm" autocomplete="off">
	        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	         <input type="hidden" name="FbeMainIdItemTrasfer" value="">
	         <input type="hidden" name="ItemEstimateTypeTransfer" value="">
	         <input type="hidden" name="RedirectValTransfer" value="">
	         <div class="table-responsive">
			   		<table class="table table-bordered" style="font-weight: 600;width: 100%;" id="modalTable">
	                   <thead>
	                       <tr style="background-color:#ffda96;color:#000000;">
	                   
		                       <th class="text-nowrap" style="width: 3%;vertical-align: middle;">SN</th>
		                       <th class="text-nowrap" style="width: 6%;vertical-align: middle;">Serial No</th>
		                       <th class="text-nowrap" style="vertical-align: middle;">Item Nomenclature</th>
		                       <th class="text-nowrap" style="vertical-align: middle;">Fund Requested</th>
		                       
		                       <%if(carryForwardList!=null && carryForwardList.size()>0){ %>
		                       <th align="center" style="padding:0px !important;margin:0px !important;background: #edffeb;width: 3%;">
		                        <div class="checkbox-wrapper-12">
								  <div class="cbx">
								    <input class="selectall" type="checkbox" style="height: 16px;width: 16px;"/>
								    <label for="selectall" style="width: 16px;height: 16px;"></label>
								    <svg width="13" height="13" viewbox="0 0 15 14" fill="none">
								      <path d="M2 8.36364L6.23077 12L13 2"></path>
								    </svg>
								  </div>
								</div>

		                       	</th>
		                       <%} %>
		                       
		                       <th class="text-nowrap" style="vertical-align: middle;">Demand No /<br>So No</th>
		                       <th class="text-nowrap" style="vertical-align: middle;">Demand Cost /<br>So Cost</th>
		                       <th class="text-nowrap" style="vertical-align: middle;">DIPL /<br>O/S</th>
		                       <th class="text-nowrap" style="vertical-align: middle;">Pay Amount</th>
		                       <th class="text-nowrap" style="vertical-align: middle;">Pay Date</th>
		                       <th class="text-nowrap" style="width: 10%;vertical-align: middle;">Item Amount</th>
	                       </tr>
	                   </thead>
	                   <tbody>
	                   <%int sn=1;
	                   long currentFundRequestId=0,previousFundRequestId=-1;  // restricting duplicate Fund request Details 
	                   long currentBookingId=0,previousBookingId=-1;  // restricting duplicate Demand Details 
	                   long currentCommitmentId=0,previousCommitmentId=-1;  // restricting duplicate Supply Order Details 
	                   long fundRequestIdCount=0;
	                   
	                   if(carryForwardList!=null && carryForwardList.size()>0)
	                   carryForwardList.forEach(row->System.out.println(Arrays.toString(row)));
	                   
	                   if(carryForwardList!=null && carryForwardList.size()>0){
	                     for(Object[] carryForward:carryForwardList){ %>
	                     
	                     <% if(carryForward[32]!=null){ %>
	                     
	                     <%if(((carryForward[32].toString()).equalsIgnoreCase("D") && (carryForward[20]!=null && !(carryForward[20].toString()).equalsIgnoreCase("0.00"))) 
	                       || ((carryForward[32].toString()).equalsIgnoreCase("I") && (carryForward[12]!=null && !(carryForward[12].toString()).equalsIgnoreCase("0.00")))
	                       || ((carryForward[32].toString()).equalsIgnoreCase("C") && (carryForward[27]!=null && !(carryForward[27].toString()).equalsIgnoreCase("0.00")))){ %>
	                     
	                     <% currentFundRequestId = carryForward[0]!=null ? Long.parseLong(carryForward[0].toString()) : 0;%>
	                     <% currentBookingId = carryForward[16]!=null ? Long.parseLong(carryForward[16].toString()) : 0;%>
	                     
	                     <tr>
	                     
	                     <!-- Fund Request Details -->
	                      <% if(currentFundRequestId!=previousFundRequestId){ %>
	                      
	                      	<% fundRequestIdCount = carryForwardList.stream().filter(item -> item[0]!=null && (carryForward[0]).equals(item[0])).count(); %>
	                      
		                     	<td rowspan="<%=fundRequestIdCount %>" style="vertical-align: middle;" align="center"><%=sn++ %>.</td>
		                     	<td rowspan="<%=fundRequestIdCount %>" style="vertical-align: middle;" align="center"><%if(carryForward[1]!=null){ %> <%=carryForward[1] %> <%}else{ %> - <%} %></td>
		                     	<td rowspan="<%=fundRequestIdCount %>" style="vertical-align: middle;"><%if(carryForward[8]!=null){ %> <%=carryForward[8] %> <%}else{ %> - <%} %></td>
		                     	<td rowspan="<%=fundRequestIdCount %>" style="vertical-align: middle;" align="right"><%if(carryForward[11]!=null){ %> <%=AmountConversion.amountConvertion(carryForward[11], "R") %> <%}else{ %> 0.00 <%} %></td>
	                      
	                       <%} %>
	                       
	                      <% if(carryForward[32]!=null){ %>
	                       <%if(((carryForward[32].toString()).equalsIgnoreCase("D") && currentBookingId!=previousBookingId) || ((carryForward[32].toString()).equalsIgnoreCase("C") && currentCommitmentId!=previousCommitmentId) || (carryForward[32].toString()).equalsIgnoreCase("I")){ %>
	                     	
	                     	<td align="center">
	                    	   <input type="checkbox" class="checkbox" name="" value=""> 
	                     	</td>
	                     	
	                     	<td align="center">
                     	      <% if(carryForward[32]!=null){
              								     if((carryForward[32].toString()).equalsIgnoreCase("D")){ %>
              										<% if(carryForward[17]!=null){ %><%=carryForward[17] %> <%}else{ %> - <%} %>
              									 <%}else if((carryForward[32].toString()).equalsIgnoreCase("C")){ %>
              									    <% if(carryForward[23]!=null){ %><%=carryForward[23] %> <%}else{ %> - <%} %>
              									 <%}else{ %> - <%} %>
              								 <%}else{ %> - <%} %>
	                     	</td>
	                     	<td align="right">
                     	      <% if(carryForward[32]!=null){
              								     if((carryForward[32].toString()).equalsIgnoreCase("D")){ %>
              										<% if(carryForward[17]!=null){ %><%=carryForward[19] %> <%}else{ %> - <%} %>
              									 <%}else if((carryForward[32].toString()).equalsIgnoreCase("C")){ %>
              									    <% if(carryForward[26]!=null){ %><%=carryForward[26] %> <%}else{ %> - <%} %>
              									 <%}else{ %> - <%} %>
              								 <%}else{ %> - <%} %>
	                     	</td>
	                     	<td align="right">
                     	      <% if(carryForward[32]!=null){
              								     if((carryForward[32].toString()).equalsIgnoreCase("D")){ %>
              										<% if(carryForward[20]!=null){ %><%=carryForward[20] %> <%}else{ %> 0.00 <%} %>
              									 <%}else if((carryForward[32].toString()).equalsIgnoreCase("C")){ %>
              									    <% if(carryForward[27]!=null){ %><%=carryForward[27] %> <%}else{ %> - <%} %>
              									 <%}else if((carryForward[32].toString()).equalsIgnoreCase("I")){ %>
              									    <% if(carryForward[12]!=null){ %><%=carryForward[12] %> <%}else{ %> - <%} %>
              									 <%}else{ %> - <%} %>
              								 <%}else{ %> - <%} %>
	                     	</td>
	                     	<td align="right"><%if(carryForward[29]!=null){ %> <%=AmountConversion.amountConvertion(carryForward[29], "R") %> <%}else{ %> - <%} %></td>
	                     	<td align="center"><%if(carryForward[30]!=null){ %> <%=DateTimeFormatUtil.getSqlToRegularDate(carryForward[30].toString()) %> <%}else{ %> - <%} %></td>
	                     	<td align="center"><span >0</span></td>
	                     </tr>
	                     
	                     <%} // Demand Details End  %>  
	                     <%} %>
	                     
                       <%} %>
                      
                      <%} %>
                      
                      <% previousFundRequestId=currentFundRequestId; %>
                      
                     <%} // List for Loop End %>  
	                       
                    <%}else{ %>
                     
                       <tr>
                       	<td colspan="11" align="center" style="font-weight: 600;color:red;">No Record Found</td>
                       </tr>
                       
                    <%} %>
                      
                    </tbody>
                 </table>
                 
               </div>
		    </form>
							   
	     </div>
	   </div>
			
</body>

<script type="text/javascript">

$(document).ready(function(event) {
	
	var projectDetails= '0#GEN#GENERAL';
	var budgetHeadId = $("#budgetHeadIdHidden").val();
	$(".budgetItemDetails").hide();
	
		$.get('GetBudgetHeadList.htm', {
			ProjectDetails : projectDetails
		}, function(result) {
			
			$('#selbudgethead').find('option').remove();
			if(budgetHeadId=='-1')
			{
				$('#selbudgethead').append('<option value="-1" selected="selected"> All </option>');
			}
			else
			{
				$('#selbudgethead').append('<option value="-1"> All </option>');
			}
			
			var result = JSON.parse(result);
			var htmlContent='';
			$.each(result, function(key, value) {
				 if(value.budgetHeadId== budgetHeadId)
				 {
					 htmlContent='<option value="'+value.budgetHeadId+'" selected="selected">'+value.budgetHeaddescription+'</option>';
				 }
				 else
					{
					   htmlContent="<option value="+value.budgetHeadId+">"+  value.budgetHeaddescription+ "</option>";
					}
				 $("#selbudgethead").append(htmlContent);
			});
			
		});
	});

		<!------------------Select Budget Item using Ajax-------------------->
		
		$('#selbudgethead').change( function(event) {
			var budgetHeadId = $("select#selbudgethead").val();
			SetBudgetItem(budgetHeadId); 
		});
		
		function SetBudgetItem(budgetItemId)
		{
			var project= '0#GEN#GENERAL'; 
			var budgetHeadId = $("select#selbudgethead").val();
			$(".budgetItemDetails").show();
			
			$.get('SelectbudgetItem.htm', {
			 projectid : project,
			 budgetHeadId : budgetHeadId
			}, function(responseJson) {
				
				$('#selbudgetitem').find('option').remove();
				if(budgetItemId=='-1')
				{
					$("#selbudgetitem").append("<option selected value='-1'> All </option>");
				}
				else
				{
					$("#selbudgetitem").append("<option selected value='-1'> All </option>");
				}
				
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

</html>