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
    @top-center {
        content: "";
    }
    @top-center::before {
    <%if("R".equalsIgnoreCase(ReOrFbe)){%>
        content: "<%=labName %> \A Revised Estimates (RE) for <%=ReOrFbeYear %>  (Build Up / MA)";
        <%} else if("F".equalsIgnoreCase(ReOrFbe)){%>
        content: "<%=labName %> \A Forecast BudgetEstimates (FBE) for <%=ReOrFbeYear %> (Build Up / MA)";
        <%}%>
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
<%
		List<Object[]> requisitionList=(List<Object[]>)request.getAttribute("RequisitionList"); 
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
		%>
<div class="group2" id="demandDetailsMod">
<%if(ExistingbudgetHeadId!=null && Long.valueOf(ExistingbudgetHeadId)==0){ %>
  <table class="table table-bordered table-hover table-striped table-condensed" id="tblDataCCM">
    <thead style="background-color: #d1d1d1; text-align: center;">
        <tr style="background-color: #ffd589;">
            <th>SN</th>
            <th>Budget Head</th>
            <th>Initiating Officer</th>
            <th>Item Nomenculature</th>
             <th>Probable Date of Demand</th>
            <th>Estimated Cost</th>
            <th>Justification</th>
            <th>Remarks by Member RPB</th>
        </tr>
    </thead>
    <tbody>
        <%
            int sn = 1;
            BigDecimal grandTotal = new BigDecimal(0);

            if (requisitionList != null && !requisitionList.isEmpty()) {
                Map<String, Map<String, List<Object[]>>> groupedData = new LinkedHashMap<>();

                // Grouping requisitionList by Budget Head → Budget Item
                for (Object[] data : requisitionList) {
                    String budgetHead = (data[7] != null) ? data[7].toString() : "Uncategorized";
                    String budgetItem = (data[20] != null) ? data[20].toString() : "Unspecified Item";

                    groupedData.putIfAbsent(budgetHead, new LinkedHashMap<>());
                    groupedData.get(budgetHead).putIfAbsent(budgetItem, new ArrayList<>());
                    groupedData.get(budgetHead).get(budgetItem).add(data);
                }

                for (Map.Entry<String, Map<String, List<Object[]>>> headEntry : groupedData.entrySet()) {
                    String budgetHead = headEntry.getKey();
                    Map<String, List<Object[]>> itemsByBudgetItem = headEntry.getValue();

                    int totalRowspan = itemsByBudgetItem.values().stream().mapToInt(List::size).sum() + 1;
                    BigDecimal subTotal = new BigDecimal(0);
                    boolean budgetHeadShown = false;

                    for (Map.Entry<String, List<Object[]>> itemEntry : itemsByBudgetItem.entrySet()) {
                        String budgetItem = itemEntry.getKey();
                        List<Object[]> items = itemEntry.getValue();

                        for (int i = 0; i < items.size(); i++) {
                            Object[] data = items.get(i);
                            BigDecimal estimatedCost = (data[18] != null) ? new BigDecimal(data[18].toString()) : new BigDecimal(0);
                            subTotal = subTotal.add(estimatedCost);
                            grandTotal =grandTotal.add(estimatedCost);
        %>
        <tr>
            <% if (!budgetHeadShown) { %>
                <td align="center" rowspan="<%= totalRowspan %>"><%= sn++ %></td>
                <td rowspan="<%= totalRowspan %>"><%= budgetHead %></td>
                <% budgetHeadShown = true; %>
            <% } %>
            
            <td><%= budgetItem %><%= (data[21] != null) ? ", " + data[21] : "" %></td>
            <td><%= (data[16] != null) ? data[16] : "-" %></td>
            <td align="center"><%= (data[24] != null) ? DateTimeFormatUtil.getSqlToRegularDate(data[24].toString()) : "-" %></td>
            <td align="right" style="color: #00008B;">
                <%= (data[18] != null) ? AmountConversion.amountConvertion(data[18], "R") : "-" %>
            </td>
            <td><%= (data[17] != null) ? data[17] : "-" %></td>
            <td align="center">-</td>
        </tr>
        <% 
                        } // end of one budget item entries
                    } // end of budget item loop
        %>
        <tr style="font-weight:bold; background-color: #f0f0f0;">
            <td colspan="3" align="right">Subtotal for <%= budgetHead %></td>
            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(subTotal, "R") %></td>
            <td colspan="2"></td>
        </tr>
        <% 
                } // End budget head loop
        %>
        <tr style="font-weight:bold; background-color: #ffd589;">
            <td colspan="5" align="right">Grand Total</td>
            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(grandTotal, "R") %></td>
            <td colspan="2"></td>
        </tr>
        <%
            } else {
        %>
        <tr style="height: 9rem;">
            <td colspan="9" style="color:red;font-weight: 600" align="center">
                
                    No Requisition Found
                
            </td>
        </tr>
        <%
            }
        %>
    </tbody>
  </table>
  
  <%}else{ %>
  
  <table class="table table-bordered table-hover table-striped table-condensed" id="tblDataCCM">
    <thead style="background-color: #d1d1d1; text-align: center;">
        <tr style="background-color: #ffd589;">
            <th>SN</th>
            <th>Budget Head</th>
            <th>Initiating Officer</th>
            <th>Item Nomenculature</th>
             <th>Probable Date of Demand</th>
            <th>Estimated Cost</th>
            <th>Justification</th>
            <th>Remarks by Member RPB</th>
        </tr>
    </thead>
    <tbody>
       
					   <% int sn=1;
   BigDecimal grandTotal = new BigDecimal(0);
   BigDecimal subTotal = new BigDecimal(0);
   int count = 0;

   if (requisitionList != null && requisitionList.size() > 0) {
       for (Object[] data : requisitionList) {
           count++;
       }
       System.err.print(count + "-count");
%>

<% for (Object[] data : requisitionList) {
       System.err.print("amt->" + new BigDecimal(data[18].toString()));
       grandTotal = grandTotal.add(new BigDecimal(data[18].toString()));
%>

    <tr>
        <td align="center"><%= sn %></td>

        <% if (sn == 1) { %>
            <td align="center" id="budgetHead" rowspan="<%= count %>">
                <% if (data[7] != null) { %> <%= data[7] %> <% } else { %> - <% } %>
            </td>
        <% } %>

        <td align="left" id="Officer">
            <% if (data[20] != null) { %>
                <%= data[20] %><% if (data[21] != null) { %>, <%= data[21] %> <% } %>
            <% } else { %> - <% } %>
        </td>

        <td id="Item">
            <% if (data[16] != null) { %> <%= data[16] %> <% } else { %> - <% } %>
        </td>

        <td align="center">
            <%= (data[24] != null) ? DateTimeFormatUtil.getSqlToRegularDate(data[24].toString()) : "-" %>
        </td>

        <td align="right" style="color: #00008B;">
            <% if (data[18] != null) { %>
                <%= AmountConversion.amountConvertion(data[18], "R") %>
            <% } else { %> - <% } %>
        </td>

        <td align="left">
            <% if (data[17] != null) { %> <%= data[17] %> <% } else { %> - <% } %>
        </td>

        <td align="center">-</td>
    </tr>

<% sn++; } %>

<% } else { %>
    <tr style="height: 9rem;">
        <td colspan="9" style="vertical-align: middle;">
            <div class="text-danger" style="text-align:center">
                <h6 style="font-weight: 600;">No Requisition Found</h6>
            </div>
        </td>
    </tr>
<% } %>

				                  
					            </tbody>
					            <%if(requisitionList!=null && requisitionList.size()!=0){ %>
					               <tfoot>
					            	
			                        <tr style="font-weight:bold; background-color: #ffd589;">
							            <td colspan="5" align="right">Grand Total</td>
							            <td align="right" style="color: #00008B;"><%= AmountConversion.amountConvertion(grandTotal, "R") %></td>
							            <td colspan="3"></td>
						   		     </tr>
					            </tfoot> 
					            <%} %>
  </table>
  <%} %>
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