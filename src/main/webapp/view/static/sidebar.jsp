<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.time.LocalDate"%>	


<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<spring:url value="/webresources/css/master.css" var="MasterCss" />     
<link href="${MasterCss}" rel="stylesheet" />

	
<style type="text/css">

.sidebar{
	background-color: #fff;
	box-shadow: none;
}
.sidebar .sidebar-nav.navbar-collapse {
  padding-left: 0;
  padding-right: 0;
}
.sidebar .sidebar-search {
  padding: 15px;
}
/* .sidebar ul li {
  border-bottom: 1px solid #e7e7e7;
} */
.sidebar ul li a.active {
  background-color: #fff;
}
.sidebar .arrow {
  float: right;
}
.sidebar .fa.arrow:before {
  content: "\f104";
}
.sidebar .active > a > .fa.arrow:before {
  content: "\f107";
}

.sidebar .nav-second-level li form input{
	background: transparent;
    border: 0px solid transparent;
    border-radius: 0px;
    color: #2980b9;
    width: 100%;
    padding: 10px 15px;
    text-align: left;
    padding-left: 37px;
}
.sidebar .nav-second-level li form input:HOVER{
	background-color: #ddd;
	color: #2980b9;	
}
.sidebar .nav-second-level li,
.sidebar .nav-third-level li {
  border-bottom: none !important;
}
.sidebar .nav-second-level li a {
  padding-left: 37px;
}
.sidebar .nav-third-level li a {
  padding-left: 52px;
}


/* ---------------------------------------------------
    SIDEBAR STYLE
----------------------------------------------------- */

.wrapper {
    display: flex;
    width: 100%;
    align-items: stretch;
}

#sidebar {
    min-width: 235px;
    max-width: 250px;
    color: #fff;
    transition: all 0.3s;
    margin:6px;
    z-index: 100 !important;
}

#sidebar.active {
    /* toggle-collapse handle margin-left: -250px; */
}


/* ---------------------------------------------------
    CONTENT STYLE
----------------------------------------------------- */

#content {
    width: 100%;
    /* padding: 20px; */
    min-height: 90vh;
    transition: all 0.3s;
}

/* ---------------------------------------------------
    MEDIAQUERIES
----------------------------------------------------- */

/* @media (max-width: 768px) {
    #sidebar {
        margin-left: -250px;
    }
    #sidebar.active {
        margin-left: 0;
    }
    #sidebarCollapse span {
        display: none;
    }
} */

/* ---------------------------------------------------
   NEW SIDEBAR
----------------------------------------------------- */

.nav-pills-custom .nav-link {
    color: black;
    background: transparent;
    position: relative;
        width: 14.2 rem !important;
}

.nav-pills-custom .nav-link.active {
    color: white;
    background: #143F6B;
    /* border:2px solid #45b649; */
}

.nav-pills{
	    background-color: transparent;
    /* height: 600px; */
    padding: 11px;
    border-radius: 6px;
    margin-left: -0.2rem;
}

/* Add indicator arrow for the active tab */
@media (min-width: 992px) {
    .nav-pills-custom .nav-link::before {
        content: '';
        display: block;
        border-top: 8px solid transparent;
        border-left: 10px solid #fff;
        border-bottom: 8px solid transparent;
        position: absolute;
        top: 50%;
        right: -10px;
        transform: translateY(-50%);
        opacity: 0;
        border-color: transparent transparent transparent #143F6B;
        
    }
}

.nav-pills-custom .nav-link.active::before {
    opacity: 1;
}

.nav-link{
	font-family: 'Muli',sans-serif !important;
}

.custom_width{
	padding: 0.5rem 0.5rem !important;
}

.sidebar-container{

	overflow-y:auto !important; 
	/* min-height: 566px !important; */
	max-height: 555px !important; */
}

#sidebarmodule .nav-link span{
	font-size: 14px !important;
}

.hovercolor:hover{

	background-color: #09dcff !important;
	color: black;
	cursor:pointer;
}

.hovercolorsub:hover{

	background-color: #ffd392 !important;
	/* color: white; */
	width: auto !important;
}


  /* Hide all sub-module lists by default */
  .subModuleList {
    display: none;
  }
  
  /* Show the sub-module list when its parent main module item is clicked */
  .show {
    display: block;
  }

/* #v-pills-tab::-webkit-scrollbar {
  display: none;
}
 */

hr {
    border-top: 1px solid white;
    width: 100%;
    margin: initial;
}

.dropdown-toggle::after {
    -ms-transform: rotate(90deg); /* IE 9 */
    -webkit-transform: rotate(90deg); /* Chrome, Safari, Opera */
    transform: rotate(90deg);
    position: absolute;
    right: 2px;
    bottom: 45%;
}

#Clickable{
  cursor: pointer;
}

.sidebar-content {
  width:100%;
 /*  background-color: white;  */
 /* background-color: transparent; */
  padding: 7px;
  margin-bottom: 0.3rem;
  margin-top:-0.5rem;
  border-radius: 3px;
  margin-left: 0.2rem;
  background-color: #e0edf3;
}

 .vertical-line {
      position: absolute;
      height: 100%;
      width: 1px;
      background-color: #000; /* Change color as needed */
      border-left: 6px solid black;
      transform: translateX(-50%);
    }
    
    .vl {
   border-left: 3px solid #bbbbbb;
   height: 100vh;
   width: 1px !important;
    box-shadow: 0px 0px 2px #bbbbbb; 
}
</style>
</head>
<body>

	<%
	  String formmoduleid =(String)session.getAttribute("formmoduleid"); 
	  String activeid =(String)session.getAttribute("SidebarActive");
	  String mainModuleId =(String)session.getAttribute("MainModuleId");
	  List<Object[]> MainModuleList = (List<Object[]>)session.getAttribute("MainModuleList");
	  List<Object[]> SubModuleList =(List<Object[]>)session.getAttribute("SubModuleList");
	  int SizeSubModule=SubModuleList.size();
	  String applicationType = "F";
	  int temp=-1;
	%>

 <div class="wrapper">
  
          <!-- Sidebar  -->
   
<div id="sidebar"><!-- style="display: none;" -->
<div class="nav flex-column nav-pills nav-pills-custom sidebar-container" id="v-pills-tab" role="tablist" aria-orientation="vertical" style="margin-top: -0.3rem;width: 15.5rem;border-radius: 6px;background-color: rgb(246 250 255);box-shadow: 5px 5px 5px #cecece;">
  <div id="sidebarmodule">
  <ol id="mainModuleList" style="margin-left: -3rem;">
  
    <!-- Populate main module list with items -->
    <% for (Object[] mainModule : MainModuleList) { %>
    <% if(applicationType!=null && applicationType.equalsIgnoreCase("F") && mainModule[1]!=null && (mainModule[1].toString()).equalsIgnoreCase("Fund Approval")){%>
    
      <li id="MainModuleId" value="<%= mainModule[0] %>" class='nav-link mb-2 shadow custom_width hovercolor dropdown-toggle' onclick="toggleSubmoduleList('<%= mainModule[0] %>')"><span class="<%=mainModule[2]%>">&nbsp;&nbsp;</span><%= mainModule[1]%></li>
      <ul class="list-unstyled menu-elements" id="submodule-list-<%= mainModule[0]%>">
        <!-- Populate submodule list with items for the current main module -->
        <div class="sidebar-content">
        <% for (Object[] subModule : SubModuleList) {
               if (subModule[0].equals(mainModule[0])) {%>
          <li class="" style="margin-left:-0.3rem"><a class="dropdown-item hovercolorsub" style='width: 105%;margin-bottom: 7px !important;border-radius: 3px;margin-top:0.1rem;padding:3px;margin:4px' role='button' aria-controls='otherSections' class="text-nowrap bi-list" href='<%=subModule[1]%>'><i id="my-icon" class='fas fa-arrow-right' style="font-size: 11px;font-weight:800"></i>&nbsp;&nbsp;<span style="font-weight:700;color:#0303b9;font-size: 15px;"><%=subModule[2] %></span></a></li>
        <%    } temp=Integer.parseInt(subModule[0].toString());
             } %>
             </div>
      </ul>
      <hr>
      
      <%}else if(applicationType!=null && applicationType.equalsIgnoreCase("I")){ %>
      
       <li id="MainModuleId" value="<%= mainModule[0] %>" class='nav-link mb-2 shadow custom_width hovercolor dropdown-toggle' onclick="toggleSubmoduleList('<%= mainModule[0] %>')"><span class="<%=mainModule[2]%>">&nbsp;&nbsp;</span><%= mainModule[1]%></li>
      <ul class="list-unstyled menu-elements" id="submodule-list-<%= mainModule[0]%>">
        <!-- Populate submodule list with items for the current main module -->
        <div class="sidebar-content">
        <% for (Object[] subModule : SubModuleList) {
               if (subModule[0].equals(mainModule[0])) {%>
          <li class="" style="margin-left:-0.3rem"><a class="dropdown-item hovercolorsub" style='width: 105%;margin-bottom: 7px !important;border-radius: 3px;margin-top:0.1rem;padding:3px;margin:4px' role='button' aria-controls='otherSections' class="text-nowrap bi-list" href='<%=subModule[1]%>'><i id="my-icon" class='fas fa-arrow-right' style="font-size: 11px;font-weight:800"></i>&nbsp;&nbsp;<span style="font-weight:700;color:#0303b9;font-size: 15px;"><%=subModule[2] %></span></a></li>
        <%    } temp=Integer.parseInt(subModule[0].toString());
             } %>
             </div>
      </ul>
      <hr>
      
      
      
    <% }} %>
  </ol>
  </div>
  </div>
</div>
          <!-- Page Content  -->
         <div id="content"> 
   

<script>
  window.addEventListener('load', function() {
    var uls = document.querySelectorAll('ul.list-unstyled.menu-elements');
    uls.forEach(function(ul) {
      ul.style.display = 'none';
      var li = document.querySelector('#MainModuleId[value="' + ul.id.slice(-1) + '"]');
      if (li) {
    	  li.setAttribute('aria-expanded', 'false');
    	}
    });
    var mainModuleId="<%= mainModuleId%>";
    if(mainModuleId !=null && mainModuleId!=0){
    	toggleSubmoduleList(mainModuleId);
        }
  });
</script>

<script>
function toggleSubmoduleList(mainModuleValue) {
	$.ajax({
		
		type:"GET",
		url:"getModuleId.htm",
		data : {
			
			mainModuleValue : mainModuleValue
			
		},
		datatype : 'json',
		success : function(result) {
			
		}
	});
	
	  var submoduleList = document.querySelector('#submodule-list-' + mainModuleValue);
	  if(submoduleList !=null){
	  if (submoduleList.style.display === 'none') {
		  
		  var uls = document.querySelectorAll('ul.list-unstyled.menu-elements');
		    uls.forEach(function(ul) {
		      ul.style.display = 'none';
		      var li = document.querySelector('#MainModuleId[value="' + ul.id.slice(-1) + '"]');
		      if (li) {
		    	  li.setAttribute('aria-expanded', 'false');
		    	}
		    });
		  
	    submoduleList.style.display = 'contents';
	  } else if(submoduleList.style.display === 'contents') {
	    submoduleList.style.display = 'none';
	  }
	}
  }
</script>

</body>
</html>