
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>Fund Request Details</title>

<style type="text/css">

/* Card container */
.status-card-container {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
}

/* Each card */
.status-card {
  flex: 1 1 22%;
  background: #fff;
  border-radius: 12px;
  padding: 15px;
 box-shadow: 0px 2px 8px rgb(215 170 123);
  min-width: 300px;
  max-width: 300px;
}

.status-card h6 {
  font-size: 14px;
  font-weight: bold;
  margin-bottom: 5px;
}

.status-card p {
  font-size: 13px;
  color: #370088;
  margin: 0 0 8px 0;
}

/* Status label */
.status {
  display: inline-flex;
  align-items: center;
  font-weight: 600;
  font-size: 13px;
  padding: 5px 10px;
  border-radius: 8px;
}

.status.success {
  color: #0a7d28;
  background: #e6f9ec;
}

.status.warning {
  color: #bd0707;
  background: #ffeaea;
}

.status i {
  margin-right: 6px;
  font-size: 14px;
}

/* Timeline */
.timeline-container {
  padding: 10px;
}

.timeline-steps {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.timeline-step {
  text-align: center;
  flex: 1;
  font-size: 14px;
  color: #888;
}

.timeline-step.done {
  color: #28a745;
}

.timeline-step i {
  font-size: 18px;
  margin-bottom: 4px;
}

.status-text {
  color: #034189;
  font-weight: 600;
}

.modal-lg {
    max-width: 90% !important;
}

.list-group-item:first-child {
    border-top-left-radius: .25rem !important;
    border-bottom-left-radius: .25rem !important;
    border-top-right-radius: 0rem !important;
    border-bottom-right-radius: 0rem !important;
}

.list-group-item:last-child {
    border-top-right-radius: .25rem !important;
    border-bottom-right-radius: .25rem !important;
    border-top-left-radius: 0rem !important;
    border-bottom-left-radius: 0rem !important;
}

 .RcRemarks
    {
     font-weight: 600;
     color:#e17400 !important;
     font-size: 14px;
    }
    
    .statusHeader
    {
    	text-decoration: underline;
    	font-weight: 600;
    	color: #054691;
    	margin:10px;
    	font-family: math;
    }
    
    .RcRemarkTitle
    {
    	color: #002e85;
    	font-size: 13px;
    }
    
    .returnedTxt
    {
    	text-align: center;
    	color:#0015b9;
    }
    
    .returnBg
    {
        box-shadow: 0px 1px 15px rgb(157 7 7) !important;
        background: #fff2f2 !important;
    }

</style>

</head>
<body>

				<!-- Attachment Modal -->

				<div class="modal fade AttachmentModal" tabindex="-1" role="dialog" style="padding: 0;">
				  <div class="modal-dialog modal-lg Exp" role="document">
				    <div class="modal-content">
				
				      <!-- Modal Header -->
				      <div class="modal-header bg-darktext-white ">
				        <h4 class="modal-title" style="font-family:'Times New Roman'; font-weight: 600;">Attachment Details</h4>
				        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true" style="font-size: 25px;">&times;</span>
				        </button>
				      </div>
				
				      <!-- Modal Body -->
				<div class="modal-body">
				  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				  <input type="hidden" name="TaDaIdAjax" id="TaDaIdAjax" value="">
				<div class="AttachmentDetails"></div>
				  <div class="row">
				    <!-- Left: Attachments Table -->
				    <div class="col-md-6">
				      <h5 class="text-secondary" style="font-weight: 600;">Attachments</h5>
				      <table class="table table-bordered table-striped mt-2" id="AttachmentModalTable">
				        <thead class="thead-dark">
				          <tr>
				         	<th>SN</th>
				            <th style="width: 60%;">Attachment Name</th>
				            <th style="width: 40%; text-align: center;">Actions</th>
				          </tr>
				        </thead>
				        <tbody id="eAttachmentModalBody" style="font-weight: 400;"></tbody>
				      </table>
				    </div>
				
				    <!-- Right: File Preview Section -->
				    <div class="col-md-6" id="previewSection" style="display: none;">
				      <h5 class="text-primary" style="font-weight: 600;">Preview:&nbsp;&nbsp;<span  style="color:black;">(</span><span id="previewFileName" style="color:black;"></span><span  style="color:black;">)</span></h5>
				      <iframe id="filePreviewIframe" style="width: 100%; height: 440px; border: 1px solid #ccc;"></iframe>
				    </div>
				  </div>
				</div>
		    </div>
		  </div>
		</div>
		
		<!-- Status Modal -->
			<div class="modal fade" onselectstart="return false;" id="ApprovalStatusModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
			 <div class="modal-dialog  custom-width-modal" role="document">
			    <div class="modal-content">
			      <div class="modal-header" style="background-color: white !important;color:black;">
			        <h5 class="modal-title" id="exampleModalLabel" style="font-family:'Times New Roman';font-weight: 600;">Approval Status</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true" style="font-size: 25px;color:#000000;">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body">
			        <!-- Employee Modal Table -->
			        <div class="statusHeader">CURRENT STATUS:</div>
			        <div id="ApprovalStatusDiv" class="mt-2" style="width: 95% !important;margin:auto;"></div>
			        <div class="statusHeader">STATUS HISTORY:</div>
			        <div id="EmployeeModalTable" class="mt-2" style="width: 95% !important;margin:auto;"></div>
			        
			      </div>
			      
			    </div>
			  </div>
			</div>
		


<script src="webresources/js/RpbFundStatus.js"></script>
			
</body>

  

</html>

