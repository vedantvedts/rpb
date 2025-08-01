<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<!-- ----------  jquery  ---------- -->
<script src="./webjars/jquery/3.4.0/jquery.min.js"></script>

<!--BootStrap Bundle JS  -->
<script src="./webjars/bootstrap/4.0.0/js/bootstrap.bundle.min.js"></script>

<!--BootStrap CSS  -->
<link rel="stylesheet" href="./webjars/bootstrap/4.0.0/css/bootstrap.min.css" />


<!-- ----------  daterangepicker  ---------- -->


<spring:url value="/webresources/addons/daterangepicker/moment.min.js" var="momentjs" />  
<script src="${momentjs}"></script> 

<spring:url value="/webresources/addons/daterangepicker/daterangepicker.min.js" var="daterangepickerjs" />  
<script src="${daterangepickerjs}"></script>

<spring:url value="/webresources/addons/daterangepicker/daterangepicker.min.css" var="daterangepickerCss" />     
<link href="${daterangepickerCss}" rel="stylesheet" />


 <spring:url value="/webresources/css/bootstrap-datepicker.min.css" var="DatepickerCss" />
 <link href="${DatepickerCss}" rel="stylesheet" />

 <spring:url value="/webresources/js/bootstrap-datepicker.min.js" var="Datepickerjs" />
 <script src="${Datepickerjs}"></script>  


 <!-- ----------  select2   ---------- -->
<spring:url value="/webresources/addons/select2/select2.min.js" var="select2js" />  
<script src="${select2js}"></script> 

<spring:url value="/webresources/addons/select2/select2.min.css" var="select2css" />     
<link href="${select2css}" rel="stylesheet" />


 <!-- ----------  selectpicker  ---------- -->
<spring:url value="/webresources/addons/selectpicker/bootstrap-select.min.js" var="selectpickerjs" />  
<script src="${selectpickerjs}"></script> 

<spring:url value="/webresources/addons/selectpicker/bootstrap-select.min.css" var="selectpickercss" />     
<link href="${selectpickercss}" rel="stylesheet" />


<!-- ----------  Data tables  ---------- -->
<spring:url value="/webresources/addons/DataTable/dataTables.bootstrap4.min.css" var="DataTableCss" />
<link href="${DataTableCss}" rel="stylesheet" />

<spring:url value="/webresources/addons/DataTable/jquery.dataTables.min.js" var="DataTableJjs" />    
<script src="${DataTableJjs}"></script>

<spring:url value="/webresources/addons/DataTable/dataTables.bootstrap4.min.js" var="DataTablejs" /> 
<script src="${DataTablejs}"></script>


<!-- ----------  fontawesome  ---------- -->
<spring:url value="/webresources/fontawesome/css/all.css" var="fontawesome" />     
<link href="${fontawesome}" rel="stylesheet" />

<!-- ----------  Master.css  ---------- -->
<spring:url value="/webresources/css/master.css" var="MasterCss" />     
<link href="${MasterCss}" rel="stylesheet" />

<!-- ----------  Master.js  ---------- -->
<spring:url value="/webresources/js/master.js" var="MasterJs" /> 
<script src="${MasterJs}"></script>

<spring:url value="/webresources/js/dc-demand.js" var="DcDemandJs" /> 
<script src="${DcDemandJs}"></script>

<!-- ----------  Master.css  ---------- -->
<spring:url value="/webresources/css/buttons.css" var="ButtonsCss" />     
<link href="${ButtonsCss}" rel="stylesheet" />

 <!-- ----------  Toggle  ---------- -->
 <spring:url value="/webresources/css/bootstrap-toggle.min.css" var="ToggleCss" />
 <link href="${ToggleCss}" rel="stylesheet" />
 
 <spring:url value="/webresources/js/bootstrap-toggle.min.js" var="Togglejs" />
 <script src="${Togglejs}"></script> 
 
 <!-- ----------  Draggable Modal  ---------- -->
 <spring:url value="/webresources/css/bootstrap-toggle.min.css" var="ToggleCss" />
 <link href="${ToggleCss}" rel="stylesheet" />
 
 <spring:url value="/webresources/js/jquery-3.3.1.min.js" var="jquery331js" />
 <script src="${Togglejs}"></script> 
 <spring:url value="/webresources/js/bootstrap.min.js" var="boostrapjs" />
 <script src="${Togglejs}"></script> 
 <spring:url value="/webresources/js/jquery-ui.min.js" var="jqueryuijs" />
 <script src="${Togglejs}"></script> 
  
   <!-- ---------- Any Charts  ---------- -->
  
  <spring:url value="/webresources/js/anyChart/anychart-base.min.js" var="AnyChartBaseJs" /> 
<script src="${AnyChartBaseJs}"></script>

<spring:url value="/webresources/js/anyChart/anychart-exports.min.js" var="AnyChartExportJs" /> 
<script src="${AnyChartExportJs}"></script>

<spring:url value="/webresources/js/anyChart/anychart-ui.min.js" var="AnyChartUIJs" /> 
<script src="${AnyChartUIJs}"></script>

 <spring:url value="/webresources/css/anychartcss/anychart-font.min.css" var="AnyChartFontCss" />
 <link href="${AnyChartFontCss}" rel="stylesheet" />
 
  <spring:url value="/webresources/css/anychartcss/anychart-ui.min.css" var="AnyChartUICss" />
 <link href="${AnyChartUICss}" rel="stylesheet" />
  
   <!-- ---------- Excel Download through Javascript  ---------- -->
  <spring:url value="/webresources/js/excelDownload/excelDownload.js" var="excelDownloadjs" /> 
  <script src="${excelDownloadjs}"></script>  
  
   <!-- ---------- Dc File  ---------- -->
  <spring:url value="/webresources/js/dc-demand.js" var="dcFilejs" /> 
  <script src="${dcFilejs}"></script>  
  
  
   <!-- ----------  highcharts  ---------- -->
   <spring:url value="/webresources/js/jquery.canvasjs.min.js" var="fbegraph" />
   <script src="${fbegraph}"></script>
   
   <spring:url value="/webresources/js/highcharts-gantt.js" var="highchartsganttjs" />
   <script src="${highchartsganttjs}"></script>
   
   <spring:url value="/webresources/js/no-data-to-display.js" var="NoDatajs" />  
   <script src="${NoDatajs}"></script>
   
   <spring:url value="/webresources/js/exporting.js" var="exportingJs" />
   <script src="${exportingJs}"></script>
   
   <spring:url value="/webresources/js/export-data.js" var="exportdataJs" />
   <script src="${exportdataJs}"></script>
   
   <spring:url value="/webresources/js/accessibility.js" var="Accessbilityjs" />  
   <script src="${Accessbilityjs}"></script>
 
   <spring:url value="/webresources/js/accessibility.src.js" var="Accessbilitysrcjs" />  
   <script src="${Accessbilitysrcjs}"></script>
   
   <spring:url value="/webresources/js/highcharts-3d.js" var="highcharts3djs" />
   <script src="${highcharts3djs}"></script>
   
   <spring:url value="/webresources/js/highcharts-3d.src.js" var="highcharts3dsrcjs" />
   <script src="${highcharts3dsrcjs}"></script>
   
   <spring:url value="/webresources/js/variable-pie.js" var="VariablePieJs" />  
   <script src="${VariablePieJs}"></script>
 
 





</head>
</html>