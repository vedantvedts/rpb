<%@page import="com.vts.rpb.utils.AmountConversion"%>
<%@page import="com.vts.rpb.utils.DateTimeFormatUtil"%>
<%@page import="com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto"%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="java.util.stream.Collectors"%>
    <%@ page import="java.util.*,com.vts.*,java.text.SimpleDateFormat,java.text.DecimalFormat,java.util.List"%>
<%@page import="org.hibernate.internal.build.AllowSysOut"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.math.BigInteger"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

 <spring:url value="/webresources/js/xlsx.full.min.js" var="excelExportjs" /> 
  <script src="${excelExportjs}"></script>  

<script src="./webjars/jquery/3.4.0/jquery.min.js"></script>

<!--BootStrap Bundle JS  -->
<script src="./webjars/bootstrap/4.0.0/js/bootstrap.bundle.min.js"></script>
<title></title>
<%
String labName=(String)request.getAttribute("labName");
String LabLogo=(String)request.getAttribute("LabLogo");
String FinYear=(String)request.getAttribute("FinYear");
String ReOrFbeYear=(String)request.getAttribute("ReOrFbeYear");
String ReOrFbe=(String)request.getAttribute("ReOrFbe");
%>

<%
		List<Object[]> requisitionList=(List<Object[]>)request.getAttribute("attachList"); 
		if(requisitionList!=null){
			requisitionList.stream().forEach(a->System.err.println(Arrays.toString(a)));
		}
		String empId=((Long)session.getAttribute("EmployeeId")).toString();
		String loginType=(String)session.getAttribute("LoginType");
		String currentFinYear=(String)request.getAttribute("CurrentFinYear");
		
		if(requisitionList != null) {
		    System.out.println("In JSP - requisitionList size: " + requisitionList.size()); 
		}
		
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
		
		Object DivName = "", DivCode = "";
		String EstimateTypeFromList = "";
		String financialYear = "";

		if (requisitionList != null && !requisitionList.isEmpty()) {
		    Object[] firstItem = requisitionList.get(0);
		    DivName = firstItem[2] != null ? firstItem[2] : "";
		    DivCode = firstItem[27] != null ? firstItem[27] : "";
		    EstimateTypeFromList = firstItem[3] != null ? String.valueOf(firstItem[3]) : "";
		    financialYear = firstItem[6] != null ? String.valueOf(firstItem[6]) : "";
		    System.err.print("Divname->"+firstItem[2]);
		}
		%>
		
		
<style>

table { page-break-inside:auto }
    tr    { page-break-inside:avoid; page-break-after:auto }
    thead { display:table-row-group !important; }
    tfoot { display:table-footer-group }

#myTable2 {
   
   border-collapse: collapse;
    border: 1px solid #c1c1c1;
    margin-left: auto;
    margin-right: auto;
     width: 100%;
    margin: 0;
}
.DemandCommitmentDetails {
    border-collapse: collapse;
    width: 100%;
    margin: 0 auto;
     padding: 8px;
}

.DemandCommitmentDetails th{
 border: 1px solid #c1c1c1;
    padding: 8px;
    
    text-align: center;
    }
.DemandCommitmentDetails td {
    border: 1px solid #c1c1c1;
    padding: 8px;
    
    text-align: center;
}
.DemandCommitmentThead{
background-color:#054691 ;
color: white;
}
.DemandCommitmentTbody{
background-color: #f2f2f2;
}

.PaymentAndCogDetails{
border-collapse: collapse;
    width: 95%;
    margin: auto;
 }
 
.PaymentAndCogDetails th{
border: 1px solid #c1c1c1;
    padding: 8px;
    text-align: center;
}

.PaymentAndCogDetails td{
	border: 1px solid #c1c1c1;
    padding: 8px;
    text-align: center;
}


.COGListAsPerControlNo{
 border-collapse: collapse;
    width: 95%;
    margin: auto;
}

.COGListAsPerControlNo th{
	border: 1px solid #c1c1c1;
    padding: 8px;
    text-align: center;
    
}

.COGListAsPerControlNo td{
	border: 1px solid #c1c1c1;
    padding: 8px;
    text-align: center;
}

#myTable2 th {
     border: 1px solid #c1c1c1; 
     background-color: #f7e7ba;
}
#myTable2 td{
border: 1px solid #c1c1c1; 
padding : 7px;
 padding-left: 10px;
}
.DemandDirectPaymentDetails{
 border-collapse: collapse;
    border: 1px solid #c1c1c1;
    margin-left: auto;
    margin-right: auto;
     width: 100%;
    margin: 0;
    
}

.DemandDirectPaymentDetailsThead{
    border: 1px solid #c1c1c1;
    background-color: #054691;
    color:white;
    
}
.DemandDirectPaymentDetails td{
    border: 1px solid #c1c1c1;
    padding: 8px;
    text-align: center;
}
.DemandDirectPaymentDetails th{
    border: 1px solid #c1c1c1;
    padding: 8px;
    text-align: center;
}
.demand-status {
  text-align: center;
  background-color: #f6f7d4;
}

.demand-status .noticeMessage {
  font-weight: 700;
  display: inline-block;
}

 #tblDataCCM {
      border-collapse: collapse;
      width: 100%;
    }
 
 #tblDataCCM th, #tblDataCCM td {
      border: 1px solid #c1c1c1; 
      padding:8px;
    }


@page {
    size: A4 landscape;
    margin: 30mm 4mm 12mm 4mm;
    
    
    /* Left Image in the Header */
    @top-left {
        content: "";
    }
    @top-left::before {
        display: block;
        width: 30%;
        height: 30%;
        margin:8px !important;
        background-image: url("data:image/png;base64,<%=LabLogo%>");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
    }

    /* Centered Message in the Header */
    @top-center::before {
        content: "<%=labName %>";
    }
    @top-center::before {
    
         content: "<%=labName %>\A RPB Fund Report";
     white-space: pre-wrap; /* Ensures the line break is applied */
        text-decoration: underline;
        font-weight: 800;
        width: 60%;
        font-size: 17px;
        display: block;
        text-align: center;
}


    /* Right Image in the Header */
    @top-right {
        content: "";
    }
    @top-right::before {
        display: block;
        width: 11%;
        height: 30%;
        margin:8px !important;
        background-image: url("data:image/png;base64,<%=LabLogo%>");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
    }
    /* Position the additional text below the logo */
	@top-right::after {
  content: "(Rs. in Rupees)";
	    font-size: 14px;
	    color: #00008B; /* Ensure the text color matches the requirement */
	    display: block;
	    text-align: left;
	    vertical-align: bottom;
	    font-style: italic;
	}

    /* Footer */
    @bottom-left {
        content: "Printed by VEDTS - IBAS";
        font-size: 10px;
    }
    
    @bottom-right {
        content: 'Page No: ' counter(page) ' | Printed on: <%= new SimpleDateFormat("dd-MM-yyyy, hh:mm a").format(new Date()) %>';
         font-size: 10px;
    }
}


</style>


</head>
<body>

<div class="group2" id="demandDetailsMod">
<form action="#" id="RequistionFormAction" autocomplete="off"> 
				        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				        <!-- <input type="hidden" name="RedirectVal" value="RequisitionList"/> -->
				        <input type="hidden" name="RedirectVal" value="B"/>   <!-- B- Redirect from Budget List -->
						   
						     <div style="flex: 1; text-align: center;background-color: #ffffff;margin-left: 24%; margin-right: 22%;padding: 8px;">
  <span style="font-weight: 600;color:#6a1616;">Division : </span><span style="font-weight: 600;color:#19a2af;">&nbsp;<%= DivName %> <%= !DivCode.toString().isEmpty() ? "(" + DivCode + ")" : "" %></span>
&nbsp;&nbsp;&nbsp;
    &nbsp;&nbsp; <span style="font-weight: 600;color:#6a1616;">
      <% if("R".equalsIgnoreCase(EstimateTypeFromList)) { %>
         RE Year :
      <% } else if("F".equalsIgnoreCase(EstimateTypeFromList)) { %>
         FBE Year :
      <% } else {%>--
      <%} %>
    </span>
    <span style="font-weight: 600;color:#19a2af;"><%=financialYear%> </span>
  </div>
						
						<div class="table-responsive" style="margin-top: 0.5rem;font-weight: 600;">
					        <table class="table table-bordered table-hover table-striped table-condensed" id="tblDataCCM">
					            <thead>
					                <tr style="background-color: #ffd589;">
					                    <th>SN</th>
					                    <th>Budget Head</th>
					                    <th>Initiating Officer</th>
					                    <th>Item Nomenclature</th>
					                    <th class="text-nowrap">Estimated Cost</th>
					                    <th>Justification</th>
					                    <th>Remarks</th>
					                </tr>
					            </thead>
					            <tbody>
					            
					            <% int sn=1; 
					            BigDecimal grandTotal = new BigDecimal(0);
					            BigDecimal subTotal = new BigDecimal(0);
					            
					            if(requisitionList!=null && requisitionList.size()>0 && !requisitionList.isEmpty()){ %>
					            
					            <%for(Object[] data:requisitionList){ 
					            	grandTotal=grandTotal.add(new BigDecimal(data[20].toString()));
					            	String fundStatus=data[25]==null ? "NaN" : data[25].toString();
					            %>
					            
					            	 <tr >
				                   			<td align="center" style="font-weight: 400"><%=sn++ %>.</td>
				                   			<td align="center" id="budgetHead" style="font-weight: 400"><%if(data[9]!=null){ %> <%=data[9] %><%}else{ %> - <%} %></td>
				                   			<td align="left" id="Officer" style="font-weight: 400"><%if(data[22]!=null){ %> <%=data[22] %><%if(data[23]!=null){ %>, <%=data[23] %> <%} %> <%}else{ %> - <%} %></td>
				                   			<td id="Item" style="font-weight: 400"><%if(data[18]!=null){ %> <%=data[18] %><%}else{ %> - <%} %></td>
				                   			<td align="right" style="font-weight: 400;color: #00008B;"><%if(data[20]!=null){ %> <%=AmountConversion.amountConvertion(data[20], "R") %><%}else{ %> - <%} %></td>
				                   			<td style="font-weight: 400"><%if(data[19]!=null){ %> <%=data[19] %><%}else{ %> - <%} %></td>
				                   			<td align="center">-</td>
			                      	 
					           		  </tr>
					            <%} %>
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
							            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(grandTotal, "R") %></td>
							            <td colspan="4"></td>
						   		     </tr>
					            </tfoot> 
					            <%} %>
					        </table>
					    </div>
						
					  </form>
  </div>
</body>
<script>



	$(document).ready(function(){
	  const table = document.querySelector("table");
	  const workbook = XLSX.utils.table_to_book(table, { sheet: "Sheet1" });
	  XLSX.writeFile(workbook, "RPB Fund Report List.xlsx");
	  
	  window.close(); 
	});
	

 
    

 
</script> 
</html>