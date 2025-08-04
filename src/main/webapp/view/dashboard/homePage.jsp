<%@page import="java.util.Arrays"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<jsp:include page="../static/header.jsp"></jsp:include>

<title>Home Page</title>

<style type="text/css">

    
</style>
</head>

<body id="HomeBody">

                <div style="font-weight: 600;color:#ff8f00;text-align: center;margin-top: 40px;font-size: 20px;">Welcome To Dashboard 
                <form action="FundRequest.htm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-sm">&nbsp;&nbsp;Go&nbsp;&nbsp;</button>
                </form>  </div>
                                                     
	
</body>

</html>