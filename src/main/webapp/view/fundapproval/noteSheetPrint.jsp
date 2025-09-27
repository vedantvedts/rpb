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
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<spring:url value="/webresources/js/xlsx.full.min.js" var="excelExportjs" />
 <script src="${excelExportjs}"></script> 
  <!-- Pdfmake  -->
	<spring:url value="/resources/pdfmake/pdfmake.min.js" var="pdfmake" />
	<script src="${pdfmake}"></script>
	<spring:url value="/resources/pdfmake/vfs_fonts.js" var="pdfmakefont" />
	<script src="${pdfmakefont}"></script>
	<spring:url value="/resources/pdfmake/htmltopdf.js" var="htmltopdf" />
	<script src="${htmltopdf}"></script>
<script src="./webjars/jquery/3.4.0/jquery.min.js"></script>
<!--BootStrap Bundle JS  -->
<script src="./webjars/bootstrap/4.0.0/js/bootstrap.bundle.min.js"></script>
<title>Note Sheet Print</title>
<%
String labName=(String)request.getAttribute("labName");
String LabLogo=(String)request.getAttribute("LabLogo");
%>
<%
		List<Object[]> NoteSheetFundDetails=(List<Object[]>)request.getAttribute("noteSheetFundDetails");
		List<Object[]> NoteSheetMemberDetails=(List<Object[]>)request.getAttribute("noteSheetMemberDetails");
		String todayDate=(String)request.getAttribute("todayDate");
		 String FinYear="",REFBEYear="";
		 NoteSheetFundDetails.stream().forEach(a->System.err.println(Arrays.toString(a)));
			NoteSheetMemberDetails.stream().forEach(a->System.err.println(Arrays.toString(a)));
			
		if (NoteSheetFundDetails != null && !NoteSheetFundDetails.isEmpty()) {
		    Object[] firstItem = NoteSheetFundDetails.get(0);
		    FinYear = firstItem[3] != null ? firstItem[3].toString() : "";
		    REFBEYear = firstItem[4] != null ? firstItem[4].toString() : "";
		}
		System.err.println("FinYear->"+FinYear);

		String AmountFormat=null;String memberStyle="";
	
		
		String AmtFormat =(String)request.getAttribute("amountFormat");
		if(AmtFormat!=null){
			if("R".equalsIgnoreCase(AmtFormat)){
				AmountFormat="Rupees";
			}
			else if("L".equalsIgnoreCase(AmtFormat)){
				AmountFormat="Lakhs";
			}
			else if("C".equalsIgnoreCase(AmtFormat)){
				AmountFormat="Crores";
			}
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

#myTable2 th {
    border: 1px solid #c1c1c1;
    background-color: #f7e7ba;
}
#myTable2 td{
border: 1px solid #c1c1c1;
padding : 7px;
padding-left: 10px;
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
   size: A4 portrait;
   margin: 10mm 10mm 10mm 10mm;
   border: 2px solid black;  
       padding: 4px; /* Optional: keeps border away from image */
       box-sizing: border-box;
       
  
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
  
   }
  @top-center::before {
  
    content: "";
    white-space: pre-wrap; /* Ensures the line break is applied */
    text-decoration: underline;
       font-weight: 800;
   width: 60%;
       font-size: 17px;
    display: block;
    text-align: center;
}


}
</style>
</head>
<body>
<div class="group2" style="font-weight: 600;font-size: 17px;width: 100%;display: block;text-align: center;text-decoration: underline;margin-top: 20px">NOTE SHEET </div>

<div style="width:100%;">
  <table style="width:100%; border-collapse:collapse;font-weight: 600;margin-top: 10px;padding-top: 40px;">
    <tr>
      <td style="text-align:left;padding-left: 20px">RPB/<%=FinYear %></td>
      <td style="text-align:right;padding-right: 20px;">Date:&nbsp;<%=todayDate %></td>
    </tr>
  </table>
</div>
<%
if (NoteSheetFundDetails != null && !NoteSheetFundDetails.isEmpty()) { 

    for (Object[] obj : NoteSheetFundDetails) {
%>
<div style="padding-top: 30px;margin: 10px;">
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    The approved fund of 
    <b>Rs. <%=(obj[13] != null ? AmountConversion.amountConvertion(obj[13].toString(), "R")  : "") %></b> 
    under 
    <b><%=(obj[19] != null ? obj[19].toString() : "") %>&nbsp;(<%=(obj[20] != null ? obj[20].toString() : "") %>)</b>  
    for 
    <b><%=(obj[1] != null ? obj[1].toString() : "") %>&nbsp;<%=(obj[4] != null ? obj[4].toString() : "") %></b> 
    in the budget <b><%=(obj[5] != null ? obj[5].toString() : "") %> &nbsp;-&nbsp;<%=(obj[6] != null ? obj[6].toString() : "") %></b>&nbsp;
    with the item nomenclature 
    <b><%=(obj[11] != null ? obj[11].toString()  : "") %></b>.
</div>

<%}} %>
<div style="width:100%;">
<table style="width:100%; border-collapse:collapse; font-weight:600; margin-top:10px;">
<%
if (NoteSheetMemberDetails != null && !NoteSheetMemberDetails.isEmpty()) { 

    for (Object[] obj : NoteSheetMemberDetails) {
        if (obj[1] != null && "CS".equalsIgnoreCase(obj[1].toString())) {
            memberStyle = "text-align:right; padding-right:20px;padding-top:50px;";
%>
        <tr>
            <td style="<%=memberStyle%>">
                <%= (obj[6] != null ? obj[6].toString() + ", " : "") %>
                <%= (obj[7] != null ? obj[7].toString() : "") %><br>
                <%= (obj[2] != null ? obj[2].toString() : "") %><br>
                <%= (obj[15] != null ? obj[15].toString() : "") %>
            </td>
        </tr>
<%
        }
    }

    for (Object[] obj : NoteSheetMemberDetails) {
        if (obj[1] != null  && !"CS".equalsIgnoreCase(obj[1].toString()) && !"CC".equalsIgnoreCase(obj[1].toString())) {
            memberStyle = "text-align:left; padding-left:20px;padding-top:50px;";
%>
        <tr>
            <td style="<%=memberStyle%>">
                <%= (obj[6] != null ? obj[6].toString() + ", " : "") %>
                <%= (obj[7] != null ? obj[7].toString() + " - " : "") %>
                <%= (obj[2] != null ? obj[2].toString() : "") %><br>
                <%= (obj[15] != null ? obj[15].toString() : "") %>
            </td>
        </tr>
  <%
        }
    }

    for (Object[] obj : NoteSheetMemberDetails) {
        if (obj[1] != null && "CC".equalsIgnoreCase(obj[1].toString())) {
            memberStyle = "text-align:center; padding-left:20px;padding-top:50px;color:green";
%>
        <tr>
            <td style="<%=memberStyle%>">
         	   <span>APPROVED</span><br>
                <%= (obj[6] != null ? obj[6].toString() + ", " : "") %>
                <%= (obj[7] != null ? obj[7].toString() + " - " : "") %>
                <%= (obj[2] != null ? obj[2].toString() : "") %><br>
                <%= (obj[15] != null ? obj[15].toString() : "") %>
            </td>
        </tr>
        
<%
        }
    }
}
%>
</table>


</div>
</body>
<script>
	$(document).ready(function(){
	  const table = document.querySelector("table");
	  const workbook = XLSX.utils.table_to_book(table, { sheet: "Sheet1" });
	  XLSX.writeFile(workbook, "RPB Fund Report List.xlsx");
	 
	  window.close();
	});
	
	function downloadFile(fileId) {
	    $('#downloadFileName').val(fileId);
	    document.getElementById("downloadForm").submit();
	}
  
	function openInNewTab(url) {
	    window.open(url, '_blank');
	    return false; // prevents default navigation
	}
</script>
</html>
