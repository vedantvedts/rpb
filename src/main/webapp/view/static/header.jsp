<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.time.LocalDate"%>
<%@ page import="com.vts.rpb.utils.*"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="ISO-8859-1">

<title>RPB</title>
<link rel="shortcut icon" type="image/png" href="view/images/drdologo.png">

<jsp:include page="dependancy.jsp"></jsp:include>

<spring:url value="/webresources/css/Header.css" var="Header" />
<link href="${Header}" rel="stylesheet" />
<spring:url value="/webresources/css/master.css" var="MasterCss" />     
<link href="${MasterCss}" rel="stylesheet" />

<style type="text/css">

.NoRecord
{
	font-weight: 600;
	color:red;
}

.table-responsive
{
	margin-top:8px;
	margin-bottom:8px;
}

.dropdown-menu
{
 min-width: 16rem;
}

.dataTables_empty
{
	color:red;
	font-weight: 600;
}

.dashboard-card::-webkit-scrollbar-track,
#v-pills-tab::-webkit-scrollbar-track,
.table-responsive::-webkit-scrollbar-track,
.modal::-webkit-scrollbar-track
{
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
	border-radius: 10px;
	background-color: #F5F5F5;
}

.dashboard-card::-webkit-scrollbar,
#v-pills-tab::-webkit-scrollbar,
.table-responsive::-webkit-scrollbar,
.modal::-webkit-scrollbar,
#DemandNoSearchDiv::-webkit-scrollbar
{
	width: 8px;
	height: 8px;
	background-color: #F5F5F5;
}

.dashboard-card::-webkit-scrollbar-thumb,
#v-pills-tab::-webkit-scrollbar-thumb,
.table-responsive::-webkit-scrollbar-thumb,
.modal::-webkit-scrollbar-thumb,
#DemandNoSearchDiv::-webkit-scrollbar-thumb
{
	border-radius: 10px !important;
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3) !important;
	background-color: #034189 !important;
}

.badge-counter {
    position: absolute;
    transform: scale(.8);
    transform-origin: top right;
   	margin-left: -1.0rem;
    margin-top: -.25rem;
    background: red;
   	font-family:'Lato', sans-serif;  
   	
}

.custom-button:hover{
	color: white !important;
	
}

.custom-button{
	color: white !important;
	
}

.bg-transparent{
	    margin: 7px;
    background-color: transparent;
    text-transform: capitalize;
    color: white;
    font-weight: 100;
    padding: 4px 7px;
}

.onclickbell{
	    margin: 0px 0px 0px 15px;
}

.logoutdivider{
	margin: 0px !important
}

.logout a{
	font-size: 14px !important;
	font-weight: 800 !important;
}

li.col-sm-3 {
  float: left;
  margin-right: 0px;
}

.report-dropdown{
background-image: url("view/images/ReportImageBg1.jpg");
background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
  background-attachment: fixed;
 opacity: 1.0;
 color: white;
}
.notification .badge {
  position: relative;
  top: -10px;
  padding: 5px 10px;
  border-radius: 50%;
  background: red;
  color: white;
}
#notifications {
   /* Background pattern from Toptal Subtle Patterns */
   background-image: url("view/images/not.jpg");
   background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
  width:500px;
 opacity: 2.0;
}

#NotificationCount {
  background-color: #fa3e3e;
  padding: 1px 1px;
  font-size: 13px;
  position: relative; /* Position the badge within the relatively positioned button */
  top: -10px;
  right: 0;
  width:25px;
  border-radius: 0.8em; /* or 50%, explained below. */
  /* number size and position */
  justify-content: center;
  align-items: center;
  color: white;

}

/* Footer Button Styles*/
a.link:hover {font-size:108%;transform: scale(1.5);FONT-WEIGHT: 500; color: blue !important;}
    
    .bob-tags {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
}

.bob-tags li a{
    border-radius: 18px;
    padding: 4px 18px;
    background-color:#ffa92e;
    font-size: 1rem;
    font-family: Arial;
    transition: 0.25s linear;
    color: black;
    box-shadow: 0px 1px 4px 1px black;
    text-shadow: 2px 2px 5px white;
}

body
{
position:fixed;width: 100%;
}

#NumberSpacing
{
letter-spacing: 1px;
}

/*PRELOADING------------ */
#overlayer {
  width:100%;
  height:100%;  
  position:absolute;
  z-index:999;
  background:#e9f3ff;
  text-align: center;
}

.lds-roller {
  display: inline-block;
  position: relative;
  width: 80px;
  height: 80px;
   top: 30%;
}
.lds-roller div {
  animation: lds-roller 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
  transform-origin: 40px 40px;
}
.lds-roller div:after {
  content: " ";
  display: block;
  position: absolute;
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: black;
  margin: -4px 0 0 -4px;
}
.lds-roller div:nth-child(1) {
  animation-delay: -0.036s;
}
.lds-roller div:nth-child(1):after {
  top: 63px;
  left: 63px;
}
.lds-roller div:nth-child(2) {
  animation-delay: -0.072s;
}
.lds-roller div:nth-child(2):after {
  top: 68px;
  left: 56px;
}
.lds-roller div:nth-child(3) {
  animation-delay: -0.108s;
}
.lds-roller div:nth-child(3):after {
  top: 71px;
  left: 48px;
}
.lds-roller div:nth-child(4) {
  animation-delay: -0.144s;
}
.lds-roller div:nth-child(4):after {
  top: 72px;
  left: 40px;
}
.lds-roller div:nth-child(5) {
  animation-delay: -0.18s;
}
.lds-roller div:nth-child(5):after {
  top: 71px;
  left: 32px;
}
.lds-roller div:nth-child(6) {
  animation-delay: -0.216s;
}
.lds-roller div:nth-child(6):after {
  top: 68px;
  left: 24px;
}
.lds-roller div:nth-child(7) {
  animation-delay: -0.252s;
}
.lds-roller div:nth-child(7):after {
  top: 63px;
  left: 17px;
}
.lds-roller div:nth-child(8) {
  animation-delay: -0.288s;
}
.lds-roller div:nth-child(8):after {
  top: 56px;
  left: 12px;
}
@keyframes lds-roller {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
#Span
	{
		font-size: 17px;
		font-weight: 900;
		font-family: "Times New Roman";
	}
	
	.card-header
	{
	background-color: rgb(246 250 255) !important;
	height: 3rem !important;
	box-shadow: 0px 1px 7px #9b9b9b;
	}
	
	.NavHeaderBackgroundColorChange
		{
		background-color: black;
     	 border-radius: 2px ;
     	 box-shadow: 0px 0px 13px white;	
		}
	
	
	
	/* Modal Animation */
	.modal-open .modal {
      transform: scale(0);
      transition: transform 0.3s ease-out;
    }
    .modal-open .modal.show {
      transform: scale(1);
    }

label
	{
		color:#090957;
	}

/* Mouse Right click style */
 .custom-menu {
            display: none;
            position: absolute;
            background-color: #fff;
            border: 1px solid #ccc;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            padding: 10px;
        }
        
        /* right click custom style */
        .custom-menu a {
            text-decoration: none;
            color: #333;
            display: block;
            padding: 5px 10px;
        }
        .custom-menu a:hover {
            background-color: #f0f0f0;
        }
        
/* Custom Tooltip */        
.tooltip-content {
    position: absolute;
    /* background-color: #ffd9b3; */
    box-shadow: 0px 0px 7px black;
    font-weight: 600;
    padding: 10px;
    border-radius: 5px;
    font-size: 14px;
    white-space: nowrap;
    display: none;
    z-index: 1000;
    
    /* Black */
	/* background: rgba(0, 0, 0, 0.85) !important;
	color: #fff !important;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3) !important; */
	
	/* white */
	/* background: #ffffff !important;
	color: #333 !important;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15) !important; */
	
	/* Yellow */
	background: #fff8dc !important;
	color: #333 !important;
	border: 1px solid #f0e68c !important;
	
	/* blue */
	/* background: #e8f0fe !important;
	color: #1a1a1a !important;
	border: 1px solid #bcd4fc !important;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1) !important; */
	    
}

/* style for All pie chart */
tspan
{
	font-weight:600 !important;
}

.modal-title
{
	font-weight: 600;
}

/* Allotment Check Box */
.button-cover,
.knobs,
.layer {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}

.button {
  position: relative;
  top: 50%;
  width: 74px;
  height: 36px;
  margin: -20px auto 0 auto;
  overflow: hidden;
}

.button.r,
.button.r .layer {
  border-radius: 100px;
}

.button.b2 {
  border-radius: 2px;
}

.checkbox {
  position: relative;
  width: 100%;
  height: 100%;
  padding: 0;
  margin: 0;
  opacity:1;
  cursor: pointer;
  z-index: 3;
}

.knobs {
  z-index: 2;
}

.layer {
  width: 100%;
  background-color:#fcebeb ;
   /* red */
  transition: 0.3s ease all;
  z-index: 1;
}

#button-1 .checkbox:checked ~ .layer {
  background-color:#D0F0C0 ;
   /* tea green */
}


/* Button 1 */
#button-1 .knobs:before {
  content: "NO";
  position: absolute;
  top: 4px;
  left: 4px;
  width: 30px;
  height: 30px;
  color: #fff;
  font-size: 10px;
  font-weight: bold;
  text-align: center;
  line-height: 1;
  padding: 9px 4px;
  background-color: #f44336;
    /* light red */
  border-radius: 50%;
  transition: 0.3s cubic-bezier(0.18, 0.89, 0.35, 1.15) all;
}

#button-1 .checkbox:checked + .knobs:before {
  content: "YES";
  left: 42px;
  background-color:#138808 ;
}

#button-1 .knobs,
#button-1 .knobs:before,
#button-1 .layer {
  transition: 0.3s ease all;
}

</style>

</head>	
<script type="text/javascript">
$(window).on('load', function() {
	  $(".lds-roller").delay(100).fadeOut("slow");
	  $("#overlayer").delay(100).fadeOut("slow"); 
	  $("#overlayer,.overlayer").hide();  
	  $(".lds-roller").hide();
	  /* $('#IbasReport').css('z-index', 1000); */
	  
	});
	
$(window).on('beforeunload', function() {
	  /* $('#IbasReport').css('z-index', 1005); */
	  $("#overlayer").show();  
	  $(".lds-roller").show();
	  $('#IbasReport').click();
});


$(document).ready(function() {
    $('.modal').addClass('fade');
    $('.sidenav').removeClass('fade');
  });
  
</script>

<script>
$(document).ready(function () {
    function initializeTooltips() {
        $('.tooltip-container').on('mouseenter', function (e) {
            const tooltipText = $(this).data('tooltip');
            const position = $(this).data('position') || 'top';

            //  Remove existing tooltip before creating a new one
            $('.tooltip-content').remove();

            const tooltipElement = $('<div class="tooltip-content" style="font-family:\'Cambria Math\'; position: absolute; display: none; z-index: 9999; background: #333; color: #fff; padding: 5px 10px; border-radius: 5px; font-size: 12px;"></div>')
                .html(tooltipText)
                .appendTo('body');

            positionTooltip(tooltipElement, e, position);
            tooltipElement.fadeIn(200);
        });

        $('.tooltip-container').on('mousemove', function (e) {
            const tooltipElement = $('.tooltip-content');
            const position = $(this).data('position') || 'top';
            positionTooltip(tooltipElement, e, position);
        });

        $('.tooltip-container').on('mouseleave', function () {
            $('.tooltip-content').fadeOut(200, function () {
                $(this).remove();
            });
        });
    }

    function positionTooltip(tooltipElement, event, position) {
        const tooltipWidth = tooltipElement.outerWidth();
        const tooltipHeight = tooltipElement.outerHeight();

        let top = 0;
        let left = 0;

        switch (position) {
            case 'top':
                top = event.pageY - tooltipHeight - 20;
                left = event.pageX - tooltipWidth / 2;
                break;
            case 'right':
                top = event.pageY - tooltipHeight / 2;
                left = event.pageX + 20;
                break;
            case 'bottom':
                top = event.pageY + 10;
                left = event.pageX - tooltipWidth / 2;
                break;
            case 'left':
                top = event.pageY - tooltipHeight / 2;
                left = event.pageX - tooltipWidth - 20;
                break;
            default:
                top = event.pageY - tooltipHeight - 20;
                left = event.pageX - tooltipWidth / 2;
        }

        tooltipElement.css({
            top: top + 'px',
            left: left + 'px'
        });
    }

    initializeTooltips();
});

</script>

<style>
/* Chrome, Safari, Edge, Opera */
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
}


/* Inner backdrop (prevents clicks outside the alert/confirm box) */
.inner-backdrop {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgb(0 0 0 / 73%);
    z-index: 1051; /* Higher than modal but lower than alert */
}

/* Custom alert & confirm box */
.custom-box {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    padding: 20px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
    border-radius: 8px;
    text-align: center;
    z-index: 1100; /* Ensures it's above the modal */
}

.custom-box p {
    margin: 10px 0;
}

.custom-box button {
    padding: 8px 15px;
    margin: 5px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

#customAlert button {
    background: #007bff;
    color: white;
}

/* Loading Spinner */
.spinner-wrapper {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100px;
      width: 100%;
    }

    .spinner {
      border: 8px solid #f3f3f3;
      border-top: 8px solid #3498db;
      border-radius: 50%;
      width: 50px;
      height: 50px;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      0%   { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    

/* Success Message */

 .fly-message {
    position: fixed;
    top: 109px;
    right: 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    color: white;
    padding: 16px 24px;
    border-radius: 5px;
    font-size: 16px;
    font-weight: 500;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
    z-index: 9999;
    opacity: 0;
    transform: translateX(100%);
    transition: all 0.5s ease;
    min-width: 280px;
    font-weight: 600;
  }
  
  .fly-message-success
  {
  	background: linear-gradient(2deg, #0ca49d, #325232);
  }
  .fly-message-failure
  {
	background: linear-gradient(2deg, #483a08, #851b1b);
  }

  .fly-message.show {
    opacity: 1;
    transform: translateX(0);
  }

  .fly-message .icon {
    font-size: 20px;
    background: white;
    color: #00c853;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
   
   #alertMessage,#confirmMessage
   {
   		font-weight: 600;
   } 
   
   .closeFlyMessage:hover
   {
		color:#ff6868 !important;
   }
   
 .subModule :hover {
		
		color:black !important;
	}
	
	.hovercolorsub:hover{

	background-color: #ffd392 !important;
	color: black !important; 
	width: auto !important;
}
	

</style>
<script>
/* Function to show custom alert */
function showAlert(message) {
    document.getElementById("alertMessage").innerText = message;
    $("#customAlert").fadeIn();
    $("#innerBackdrop").fadeIn();
}

/* Function to close custom alert */
function closeAlert() {
    $("#customAlert").fadeOut();
    $("#innerBackdrop").fadeOut();
}

/* Function to show custom confirm box */
function showConfirm(message, callback) {
    document.getElementById("confirmMessage").innerText = message;
    $("#customConfirm").fadeIn();
    $("#innerBackdrop").fadeIn();

    // Store callback function
    window.confirmCallback = callback;
}

/* Function to handle confirm action */
function confirmAction(choice) {
    $("#customConfirm").fadeOut();
    $("#innerBackdrop").fadeOut();
    
    // Execute callback function if available
    if (typeof window.confirmCallback === "function") {
        window.confirmCallback(choice);
    }
}

</script>

<script>

// loading Spinner for particular Place

function showLoadingSpinner(containerName)
{
	 $(containerName).hide();
	 const spinnerWrapper = document.createElement('div');
	  spinnerWrapper.className = 'spinner-wrapper';

	  const spinner = document.createElement('div');
	  spinner.className = 'spinner';
	  spinnerWrapper.appendChild(spinner);
	  
	  const spinnerContainer = document.createElement('div');
	  spinnerContainer.className = 'ContentLoader';
	  spinnerContainer.appendChild(spinnerWrapper);
	  
	  $(containerName).after(spinnerContainer);
}

function hideLoadingSpinner()
{
	$(".ContentLoader").remove();
}

</script>

<script type="text/javascript">

function closeFlyMessage()
{
	$('.fly-message-success,.fly-message-failure').remove();
}

// showing success Message

function showSuccessFlyMessage(message) {
	  
	  $('.fly-message-success').remove();

	  const $msg = $('<div class="fly-message fly-message-success"></div>').html(message+'<span class="closeFlyMessage" style="font-size:17px;cursor:pointer;" onclick="closeFlyMessage()">&nbsp;&nbsp;&nbsp;&#10006;</span>');

	  $('body').append($msg);
	  setTimeout(() => $msg.addClass('show'), 10);

	  setTimeout(() => {
	    $msg.removeClass('show');
	    setTimeout(() => $msg.remove(), 400);
	  }, 5000);
	}
	
function showFailureFlyMessage(message) {
	  
	  $('.fly-message-failure').remove();

	  const $msg = $('<div class="fly-message fly-message-failure"></div>').html(message +'<span class="closeFlyMessage" style="font-size:17px;cursor:pointer;" onclick="closeFlyMessage()">&nbsp;&nbsp;&nbsp;&#10006;</span>');

	  $('body').append($msg);
	  setTimeout(() => $msg.addClass('show'), 10);

	  setTimeout(() => {
	    $msg.removeClass('show');
	    setTimeout(() => $msg.remove(), 400);
	  }, 5000);
	}

</script>

<body>


<!-- Custom Inner Backdrop (inside modal) -->
<div id="innerBackdrop" class="inner-backdrop" style="display: none;"></div>

<!-- Custom Alert Box -->
<div id="customAlert" class="custom-box">
    <p id="alertMessage">This is an alert message.</p>
    <button style="background-color: blue;color:white;font-weight: 600;" onclick="closeAlert()">OK</button>
</div>

<!-- Custom Confirm Box -->
<div id="customConfirm" class="custom-box">
    <p id="confirmMessage">Are you sure?</p>
    <button style="font-weight: 600;background: #dc3545;color: white;" onclick="confirmAction(false)">Cancel</button>
    <button style="background-color:blue;color:white;font-weight: 600;" onclick="confirmAction(true)">OK</button>
</div>
         
	<% String Username = (String)session.getAttribute("Username");
       String logintype = (String)session.getAttribute("LoginType"); 
       String EmpName = (String)session.getAttribute("EmployeeName");
       String EmployeeDesign = (String)session.getAttribute("EmployeeDesign");
       long FormRole = (long)session.getAttribute("FormRole");
       String developerToolsStatus = (String)session.getAttribute("DeveloperToolsStatus");
       String labCode = (String)session.getAttribute("client_name");
       String LoginTypeName = (String)session.getAttribute("LoginTypeName");
       
       List<Object[]> MainModuleList = (List<Object[]>)session.getAttribute("MainModuleList");
 	  List<Object[]> SubModuleList =(List<Object[]>)session.getAttribute("SubModuleList");
 	 int temp=-1;
 	String applicationType = "F";
    %>
    <input type="hidden" id="hiddendeveloperToolsStatus" value="<%=developerToolsStatus%>">
      <div id="custom-menu" class="custom-menu" style="z-index: 10000;">
							    
								    <a class="dropdown-item" href="#"><i class="fa-solid fa-user"></i> &nbsp;&nbsp;Hi <%=Username%>!! </a>
								    <div class="dropdown-divider logoutdivider"></div>
								
							
									<input type="hidden" value="<%=logintype %>" name="logintype" id="logintype">
								            
								    	<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
									        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
								                <button class="dropdown-item " href="#" data-target="#logoutModal" style="font-weight: 700">
								                   &nbsp; <i class="fa fa-sign-out fa-1.5x" aria-hidden="true" style="color: #B20600"></i>
								                    &nbsp;&nbsp;Logout
								                </button>
								        </form>
      </div>
    
     <input type="hidden" id="FormRole" value="<%=FormRole%>">
     <input type="hidden" id="LoginType" value="<%=logintype%>">
        	<nav class="navbar navbar-expand-lg navbar-light" style="padding: 0.0rem 0rem !important;">              
            	<div class="container-fluid" style="padding: 0.2px;">
            	<div class="collapse navbar-collapse" id="navbarSupportedContent">
		
		  
		  <!-- RPB Home -->
		  <div class="btn-group Home NavHeaderBackgroundColorChange" style="padding: 3px;">	
		 <a class=" btn bg-transparent" href="MainDashBoard.htm" type="button" aria-haspopup="true" aria-expanded="false" style="background-color: transparent;padding: 0px;margin-left: 5px;margin-right: 0.1px;"><i class="fa fa-home" aria-hidden="true" style="color:orange;"></i></a> 	
		 <a class="navbar-brand" href="MainDashBoard.htm" id="brandname" style="font-family: Montserrat, sans-serif; color: white;text-align: initial;margin-top: 0.4rem;font-weight: 900;padding: 0px;margin-right: 10px;">RPB </a>
		 </div>
		
		<!-- Date -->					
		<div style="margin-left: 12px;">
		<span id="p1" style="font-family:Lato, sans-serif;font-size: 17px;font-weight: 700; color: #a7ffff;"></span>
		<span style="font-family: Lato, sans-serif;font-size: 16px;padding: 0px 16px 0px 10px;text-transform: capitalize !important;color: white;margin-left: -0.3rem;font-weight: 600;"><%=LocalDate.now().getMonth() %> &nbsp;<%=LocalDate.now().getYear() %> </span></div>
			
								
								 <% for (Object[] mainModule : MainModuleList) { %>
    <% if(applicationType!=null && applicationType.equalsIgnoreCase("F") && mainModule[1]!=null && (mainModule[1].toString()).equalsIgnoreCase("Fund Approval")){%>
		<!-- Emp Name -->					
		<div style="margin-left: -0.9rem;">&nbsp;
		<span id="p1" style="font-family:Lato, sans-serif;font-size: 19px;font-weight: 700; color: #9dffef;"></span>
		<span style="font-family: Lato, sans-serif;font-size: 15px;padding: 0px 16px 0px 10px;text-transform: capitalize !important;color: #70f7ff;margin-left: -0.3rem;font-weight: 600;"> &nbsp; <%if(EmpName!=null){%><%=EmpName %><%} %> <%if(EmployeeDesign!=null){%>,&nbsp;&nbsp;<%= EmployeeDesign %><%} %><%if(LoginTypeName!=null){ %>&nbsp;(<%=LoginTypeName %>)<%} %></span></div>				
	

    <ul class="navbar-nav ml-auto " style="margin-left: 20px;"> <!-- adds extra space from left -->
    <% for (Object[] subModule : SubModuleList) {
    if (subModule[0].equals(mainModule[0])) { %>
    <span style="font-size: 22px;color: darkgray;">| </span>
        <li class="nav-item active " style=" margin: 2px 4px;"> <!-- hovercolorsub -->
            <a class="dropdown-item subModule  hovercolorsub" 
               style="width: 105%;
                      margin: 2px 4px; /* top-bottom: 2px, left-right: 4px */
                      border-radius: 3px;
                      margin-top: 0.1rem;
                      padding: 3px;"
               role="button"
               aria-controls="otherSections"
               class="text-nowrap bi-list"
               href="<%=subModule[1]%>">
              <i class="fas fa-caret-right" style="font-size: 12px; font-weight: 800; color:#ed7979;"></i>
                &nbsp;
                <span style="font-weight: 700; color: white; font-size: 15px;">
                    <%=subModule[2] %>
                </span>
            </a>
        </li>
        
        <% } 
    temp = Integer.parseInt(subModule[0].toString());
} %>
    </ul>
<span style="font-size: 20px;color: darkgray;">| </span>

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
       <% }} %>
			<%if(!logintype.equalsIgnoreCase("P")){ %>
						 <div  class="btn-group HeaderNotifications">
	                        <a class="nav-link  onclickbell" href="" id="alertsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					            <img alt="logo" src="view/images/notification.png" style="width: 28px; height: 28px;" >
						           <!--  <span id="NotificationCount" class="badge" style="font-weight: 700;color: white;">Notifications</span> -->
						            <span id="NotificationCount" class="badge"></span><!-- <span>Notifications</span> -->
						            <i class="fa fa-caret-down " aria-hidden="true" style="padding-left:5px;color: #ffffff"></i>
					        </a>
					        <div id="notifications" class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in custombell" aria-labelledby="alertsDropdown" style="width:200px;padding: 0px;margin-top: 6px;box-shadow: 0px 0px 5px #353535;">
								<span class="dropdown-header" style="background-color: #faa51e;font-size: 16px;color: #145374; margin-top: -1px;border-top-left-radius: 3px;border-top-right-radius: 3px;font-weight: 700"><i class="fa-solid fa-bell"></i>&nbsp;&nbsp;&nbsp;&nbsp;All Notifications</span>
						        <a class="dropdown-item text-center small text-gray-500 showall notification" href="DemandApprove.htm" style="height: 30px;font-size: 13px;color: black; text-align: left;" ><span style="font-weight: 600;">No Notifications</span><span id="badge" class="badge"></span></a>						        
						        </div>
						    </div>
						    <%} %>
						    
						    <div class="btn-group HeaderUserAction">
						        <button type="button" class="btn btn-link btn-responsive UserActionButton" style="text-decoration: none !important" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							    	<img alt="logo" src="view/images/userlogo.png" style="width: 30px; height: 30px;">
							            <span style="font-weight: 700;color: white;">&nbsp;<%=Username %></span>
							            <i class="fa fa-caret-down " aria-hidden="true" style="padding-left:5px;color: #ffffff"></i>
							  	</button>
							
							    <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in logout" aria-labelledby="userDropdown" style="box-shadow: 0px 0px 5px #353535;">
							    	
								    <a class="dropdown-item" href="#"><i class="fa-solid fa-user"></i> &nbsp;&nbsp;Hi <%=Username%>!! </a>
								    <div class="dropdown-divider logoutdivider"></div>
								    
									 <div style="font-weight: 800;padding: .25rem 1.5rem;">&nbsp;<i class="fa fa-cog" aria-hidden="true" style="color: green"></i>&nbsp;<input type="checkbox" id="devTools" <%if(developerToolsStatus!=null && developerToolsStatus.equalsIgnoreCase("0")){ %> checked="checked" value="<%=developerToolsStatus%>" <%} %>>&nbsp;Enable dev tools</div>
								  	<div class="dropdown-divider logoutdivider"></div> 
									
									<input type="hidden" value="<%=logintype %>" name="logintype" id="logintype">
								            
								    	<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
									        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
								                <button class="dropdown-item " data-target="#logoutModal" style="font-weight: 700;cursor: pointer;">
								                   &nbsp; <i class="fa fa-sign-out fa-1.5x" aria-hidden="true" style="color: #B20600"></i>
								                    &nbsp;&nbsp;Logout
								                </button>
								        </form>
							        
							    </div>
							</div>
						</div>
					</div>
			 </nav>
			 
			 
	<script type="text/javascript">
	
	$(document).ready(function() {
		
		var dtstatus=$("#hiddendeveloperToolsStatus");
		if(dtstatus)
			{
			    dtstatus=dtstatus.val();
			    if(dtstatus)
			    	{
			    	 	DevelopersToolsSettings(dtstatus);
			    	}
				
			}
		
	    $('#devTools').on('click',function(){
	    	var status = $(this).prop('checked') ? '0' : '1';
	        DevelopersToolsSettings(status);
	    });
	});
	
	function DevelopersToolsSettings(status) {
		
		 $.get('UpdateDeveloperToolsStatus.htm', {
            	status : status
			}, function(responseJson) {
				if(responseJson!=null && responseJson=='1')
					{
						$(document).on("contextmenu.customMenu", function(e) {
		                    e.preventDefault(); // Disable the default right-click menu
		                    $('#custom-menu').css({
		                        display: "block",
		                        left: e.pageX,
		                        top: e.pageY
		                    });
		                });

		                // Hide custom menu when clicking elsewhere
		                $(document).on("click.customMenu", function() {
		                    $('#custom-menu').hide();
		                });
					}
				else
					{
					    $(document).off("contextmenu.customMenu"); 
		                $(document).off("click.customMenu"); 
		                $('#custom-menu').hide();
					}
				
			});
       }

	function RegularDateFormat(DateValue)
	{ 
		   /* Date Formation */
		    var d = new Date(DateValue),
	        month = '' + (d.getMonth() + 1),
	        day = '' + d.getDate(),
	        year = d.getFullYear();
	    if (month.length < 2) 
	        month = '0' + month;
	    if (day.length < 2) 
	        day = '0' + day;
	    var expectedDate=[day,month,year].join('-');
		return expectedDate;
	}
	
         </script> 
           
           
<script>
	  
	
	//Notification
	 $(".HeaderNotifications,.onclickbell").click(function(e) {
		        $('.search-dropdown').hide();
				$(".HeaderNotifications").addClass("NavHeaderBackgroundColorChange");
				 $(".Home").removeClass("NavHeaderBackgroundColorChange"); 
				 $(".HeaderSearch").removeClass("NavHeaderBackgroundColorChange"); 
				 $(".HeaderReports").removeClass("NavHeaderBackgroundColorChange"); 
				 $(".HeaderUserAction").removeClass("NavHeaderBackgroundColorChange"); 
	     });
	  
	  $(document).on("click", function(e) {
	        if (!$(e.target).closest('.HeaderNotifications').length) {
	            $(".HeaderNotifications").removeClass("NavHeaderBackgroundColorChange");
	            $(".Home").addClass("NavHeaderBackgroundColorChange"); 
	        }
	    });
	  
	//UserAction
		 $(".HeaderUserAction,.UserActionButton").click(function(e) {
			        $('.search-dropdown').hide();
					$(".HeaderUserAction").addClass("NavHeaderBackgroundColorChange");
					 $(".Home").removeClass("NavHeaderBackgroundColorChange"); 
					 $(".HeaderSearch").removeClass("NavHeaderBackgroundColorChange"); 
					 $(".HeaderReports").removeClass("NavHeaderBackgroundColorChange"); 
					 $(".HeaderNotifications").removeClass("NavHeaderBackgroundColorChange"); 
		     });
		  
		  $(document).on("click", function(e) {
		        if (!$(e.target).closest('.HeaderUserAction').length) {
		            $(".HeaderUserAction").removeClass("NavHeaderBackgroundColorChange");
		            $(".Home").addClass("NavHeaderBackgroundColorChange"); 
		        }
		    });
		  
</script>
			 
 <!-- PreLoader Attaching in all Pages -->
 <script type="text/javascript">
 $("body").append('<div id="overlayer" class="overlayer"> <div class="lds-roller"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div></div>');
 
 </script>

    
        </body>

        </html>