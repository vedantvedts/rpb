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
<jsp:include page="../static/sidebar.jsp"></jsp:include>
<title>Carry Forward Fund</title>
<style>

 	
</style>


</head>
<body>
 <%
     List<Object[]> carryForwardList = (List<Object[]>)request.getAttribute("carryForwardList");
     carryForwardList.forEach(row->System.out.println("***"+Arrays.toString(row)));
 %>
<div class="card-header page-top">
	 	<div class="row">
	 	  <div class="col-md-3"><h5>Fund Carry Forward</h5></div>
	      <div class="col-md-9">
	    	 <ol class="breadcrumb" style="justify-content: right;">
	    	 <li class="breadcrumb-item"><a href="FundRequest.htm"><i class=" fa-solid fa-house-chimney fa-sm"></i>Requisition List </a></li>
	         <li class="breadcrumb-item active" aria-current="page">Fund Carry Forward</li>
             </ol>
           </div>
         </div>
       </div> 
		
      <div class="page card dashboard-card">
           </div>
			
</body>

</html>