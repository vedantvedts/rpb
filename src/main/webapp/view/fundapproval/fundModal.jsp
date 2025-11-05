
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
    
 .actionDate
    {
     font-weight: 600;
     color:#e17400 !important;
     margin:5px !important;
     font-size: 13px;
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
    
    #RevisionHistoryContainer
    {
    	text-align: -webkit-center;
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
				        <h4 class="modal-title" style="font-family:'Times New Roman'; font-weight: 600;">Fund Details</h4>
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
				      <div id="RevisionHistoryContainer"></div>
				    </div>
				
				
				    <!-- Right: File Preview Section -->
				    <div class="col-md-6" id="previewSection" style="display: none;">
				      <h5 class="text-primary" style="font-weight: 600;">Preview:&nbsp;&nbsp;<span  style="color:black;">(</span><span id="previewFileName" style="color:black;"></span><span  style="color:black;">)</span></h5>
				      <iframe id="filePreviewIframe" style="width: 100%; height: 440px; border: 1px solid #ccc;"></iframe>
				    </div>
				    
				    <div class="col-md-6">
			
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
		
<div id="chatBoxContainer" style="
    position: fixed;
    bottom: 7px;
    right: 7px;
    width: 535px;
    height: 616px;
    border: 1px solid #ccc;
    border-radius: 8px;
    background: #fff;
    box-shadow: 0px 4px 12px rgba(0,0,0,0.2);
    font-size: 13px;
    z-index: 9999;
    opacity: 0;
    transform: translateY(50px) scale(0.9);
    pointer-events: none;
    transition: opacity 0.3s ease, transform 0.3s ease;
    
">
  
  <!-- Header -->
  <div style="background:#222a1a; color:#fff; padding:8px 10px; border-radius:8px 8px 0 0; display:flex; justify-content:space-between; align-items:center;">
    <span><b>Queries</b></span>
    <button onclick="closeChatBox()" style="background:none; border:none; color:white; font-size:18px; cursor:pointer;">&#10006;</button>
  </div>

  <!-- Messages -->
  <div id="chatMessages" style="flex:1; padding:8px; background:#f9f9f9; overflow-y:auto; height:calc(100% - 90px);background-image: url('view/images/ChatBg5.jpeg');background-position: center center;
    background-repeat: no-repeat;background-size: cover;  ">
  </div>

  <!-- Footer -->
  <div style="border-top:1px solid #ddd; padding:6px; display:flex; gap:5px;">
    <input type="text" id="chatInput" placeholder="Type a message..."
           style="flex:1; padding:5px; border:1px solid #ccc; border-radius:4px;">
    <button type="button" class="btn btn-success" id="chatSendButton" style="padding:5px 10px; border-radius:4px; background:#067a1a; border:none; color:#fff; cursor:pointer;">
      <i class="fas fa-paper-plane"></i> Send
    </button>
  </div>
</div>


<script src="webresources/js/RpbFundStatus.js"></script>
			
</body>
<script type="text/javascript">

function rupeeFormat(amount) {
    let result = "", minus = "", decimal = "";

    if (amount !== null && amount !== "-") {
        if (amount.indexOf('.') !== -1) { // Remove Decimal Value
            let amountarray = amount.split(".");
            if (amountarray !== null && amountarray.length > 0) {
                let number = amountarray[0];
                let paisa = amountarray[1];
                decimal = "." + paisa;
                amount = number;
            }
        }

        amount = amount.replace(/,/g, ""); // if value has Comma(,) this function will remove
        if (amount !== null && Number(amount) < 0) {
            amount = amount.split("-")[1];
            minus = "-";
        }

        let len = amount.length;

        if (len === 1 || len === 2 || len === 3) {
            result = amount;
        } else {
            let a = 0;
            for (let i = len - 1; i >= 0; i--) {
                a++;
                if (a === 1 || a === 2 || a === 3 || a % 2 === 1) {
                    result = result + amount.charAt(i);
                } else if (a % 2 === 0) {
                    result = result + "," + amount.charAt(i);
                }
            }
            let reverse = result.split("").reverse().join("");
            result = reverse; // reversing the Result
        }
    } else {
        result = "0";
    }

    return minus + result + decimal;
}

</script>

<script>
let currentFundApprovalId = null;
let refreshInterval = null;
let lastMessageCount = 0;
let currentButtonId = null; 

// Open Chat with bounce animation
function openChatBox(fundApprovalId, buttonId) {
    currentFundApprovalId = fundApprovalId;
    currentButtonId = buttonId;

    document.getElementById("chatMessages").innerHTML = "";
    document.getElementById("chatInput").value = "";
    lastMessageCount = 0;

    if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = null;
    }
    

 
    const chatBox = document.getElementById("chatBoxContainer");
    chatBox.style.opacity = "1";
    chatBox.style.transform = "translateY(0) scale(1)";
    chatBox.style.pointerEvents = "auto";

  chatBox.animate(
    [
        { transform: "scale(0.95)", opacity: 0 },
        { transform: "scale(1)", opacity: 1 }
    ],
    { duration: 200, easing: "ease-in-out" }
);

  // Hide Forward Button when chat opens
   const btn = document.getElementById(buttonId);
    if (btn) btn.style.display = "none";
  
	// Show header once at the top
	loadFundHeader(fundApprovalId); 
  
    
}

// Close Chat with fade-out
function closeChatBox() {
    const chatBox = document.getElementById("chatBoxContainer");

    chatBox.animate([
        { transform: "translateY(0) scale(1)", opacity: 1 },
        { transform: "translateY(30px) scale(0.95)", opacity: 0 }
    ], { duration: 300, easing: "ease-in" });

    setTimeout(() => {
        chatBox.style.opacity = "0";
        chatBox.style.transform = "translateY(50px) scale(0.9)";
        chatBox.style.pointerEvents = "none";
        
        if (currentButtonId) {
            const btn = document.getElementById(currentButtonId);
            if (btn) btn.style.display = "inline-block";
        }
    }, 280);

    if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = null;
    }

    
    lastMessageCount = 0;
    document.getElementById("chatMessages").innerHTML = "";
    document.getElementById("chatInput").value = "";
}




// Auto refresh queries
function loadQueries(fundApprovalId) {
    var chatMessages = document.getElementById("chatMessages");
    var currentEmpId = document.getElementById("EmpId") ? document.getElementById("EmpId").value : "";

    
    $.ajax({
        url: "getFundApprovalQueries.htm",
        type: "GET",
        data: { fundApprovalId: fundApprovalId },
        success: function(response) {
            try {
                var data = JSON.parse(response);

                if (data && data.length > 0) {
                    // Show only new messages
                    if (data.length > lastMessageCount) {
                        for (var i = lastMessageCount; i < data.length; i++) {
                            var row = data[i];
                            var empId = row[1];      
                            var empName = row[2];
                            var designation = row[3];
                            var message = row[5];
                            var actionDate = row[6];
                            actionDate = actionDate.replace(/:\d{2}\s/, " ");

                            var wrapper = document.createElement("div");
                            wrapper.style.clear = "both";
                            wrapper.style.marginBottom = "8px";

                            var msgDiv = document.createElement("div");
                            msgDiv.style.padding = "6px 8px";
                            msgDiv.style.borderRadius = "8px";
                            msgDiv.style.display = "inline-block";
                            msgDiv.style.maxWidth = "60%";
                            msgDiv.style.wordWrap = "break-word";

                            if (empId == currentEmpId) {
                                wrapper.style.textAlign = "right"; 
                                msgDiv.style.background = "rgb(6 122 26)";
                                msgDiv.style.color = "#fff";
                                msgDiv.style.fontWeight="600";
                                msgDiv.style.fontSize="14px";
                                msgDiv.innerHTML =
                                    "<div style='text-align: left;'>" + message + "</div>" +
                                    "<div style='font-size:11px; color:#f0d890; text-align:right; margin-top:2px;'>" + actionDate + "</div>";
                            } else {
                                wrapper.style.textAlign = "left"; 
                                msgDiv.style.background = "rgb(255 255 255)";
                                msgDiv.style.color = "#000";
                                msgDiv.innerHTML =
                                    "<div><b style='color: #a43939;'>" + empName + ", " + designation + "</b><br></div><div style='font-weight: 600;font-size: 14px;'> " + message + "</div>" +
                                    "<div style='font-size:11px; color:#ad821b; text-align:right; margin-top:2px;'>" + actionDate + "</div>";
                            }

                            wrapper.appendChild(msgDiv);
                            chatMessages.appendChild(wrapper);
                        }

                        lastMessageCount = data.length;
                        chatMessages.scrollTop = chatMessages.scrollHeight;
                    }
                }
            } catch (e) {
                console.error("Invalid JSON:", e);
            }
        },
        error: function(xhr, status, error) {
            console.error("Error loading queries:", error);
        }
    });
}

function loadFundHeader(fundApprovalId) {
    $.ajax({
        url: "getParticularFundQueryHeader.htm",
        type: "GET",
        data: { fundApprovalId: fundApprovalId },
        success: function (response) {
            try {
                var data = JSON.parse(response);

                if (data && data.length > 0) {
                    var details = {
                        BudgetType: data[0][0],
                        ProjectShortName: data[0][1],
                        BudgetHeadDescription: data[0][2],
                        Initiator_name: data[0][3],
                        InitiatorDesignation: data[0][4],
                        ItemNomenclature: data[0][5],
                        ItemCost: data[0][6],
                        DivisionCode: data[0][7],
                        Status : data[0][8]
                    };

                    renderChatHeader(details);
                }
            } catch (err) {
                console.error("Error parsing header response:", err);
            }
            loadQueries(fundApprovalId);
            startAutoRefresh(fundApprovalId);
        },
        error: function (xhr, status, error) {
            console.error("Error loading header:", status, error);
        }
    });
}


function renderChatHeader(details) {
    var chatMessages = document.getElementById("chatMessages");

    // Clear old header if any
    var oldHeader = document.getElementById("chatHeaderMessage");
    if (oldHeader) oldHeader.remove();

    var header = document.createElement("div");
    header.id = "chatHeaderMessage";
    header.style.textAlign = "left";
    header.style.margin = "10px auto";
    header.style.maxWidth = "90%";
    header.style.background = "rgb(255 252 220)"; //#f1f1f1
    header.style.padding = "10px";
    header.style.borderRadius = "8px";
    header.style.fontSize = "14px";
    header.style.color = "#333";
    header.style.lineHeight = "1.7";
    header.style.boxShadow = "-1px 2px 17px darkgrey";
    header.style.fontWeight = "600";
    	
    var BudgetType = null;
    if(details.BudgetType =='General'){
    	BudgetType="General";
    }
    else if(details.BudgetType =='Proposed Project') {
    	BudgetType="Proposed Project - "+ details.ProjectShortName;
    }
    header.innerHTML =
        "<div style=''><span style='color: #034189;'>Division: </span>" + details.DivisionCode + "<br>"+
    "<span style='color: #034189;'>Nomenclature:</span> " + details.ItemNomenclature + "<br>" +

        "<span style='color: #034189;'>Initiating Officer:</span> " + details.Initiator_name + ", " + details.InitiatorDesignation + "<br>" +
        
        "<span style='color: #034189;'>Estimated Cost:</span> " + rupeeFormat((details.ItemCost).toLocaleString())+"</div>";

    chatMessages.appendChild(header);
    
    if(details.Status == 'A')
    {
    	$('#chatInput').prop('disabled', true);
    	$('#chatSendButton').prop('disabled', true);
    }
    else
   	{
    	$('#chatInput').prop('disabled', false);
    	$('#chatSendButton').prop('disabled', false);
   	}
}

function startAutoRefresh(fundApprovalId) {
    if (refreshInterval) clearInterval(refreshInterval);
    refreshInterval = setInterval(function() {
        loadQueries(fundApprovalId);
    }, 3000);
}

document.getElementById('chatSendButton').addEventListener('click', function() {
    if(currentFundApprovalId){
        sendQuery(currentFundApprovalId);
    }
});

document.addEventListener("DOMContentLoaded", function () {
    var input = document.getElementById("chatInput");
    input.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            e.preventDefault(); 
            sendQuery(currentFundApprovalId);
        }
    });
});

function sendQuery(fundApprovalId) {
    var input = document.getElementById("chatInput");
    var msg = input.value.trim();
    if (msg === "") return;

    var csrfParamEl = document.getElementById("csrfParam");
    var csrfParam = csrfParamEl ? csrfParamEl.name : "_csrf";
    var csrfToken = csrfParamEl ? csrfParamEl.value : "";

    var requestData = { fundApprovalId: fundApprovalId, Query: msg };
    requestData[csrfParam] = csrfToken;

    $.ajax({
        url: "sendFundApprovalQuery.htm",
        type: "POST",
        data: requestData,
        success: function(response) {
            var chatMessages = document.getElementById("chatMessages");
            var now = new Date();
            var dateTime = now.toLocaleString("en-US", { 
                month: "short", day: "numeric", year: "numeric", 
                hour: "numeric", minute: "numeric", hour12: true 
            });

            var wrapper = document.createElement("div");
            wrapper.style.clear = "both";
            wrapper.style.textAlign = "right";
            wrapper.style.marginBottom = "8px";

            var newMsg = document.createElement("div");
            newMsg.style.padding = "6px 10px";
            newMsg.style.background = "rgb(6 122 26)";
            newMsg.style.color = "#fff";
            newMsg.style.borderRadius = "8px";
            newMsg.style.display = "inline-block";
            newMsg.style.maxWidth = "70%";
            newMsg.style.wordWrap = "break-word";
            newMsg.style.fontSize="14px";

            newMsg.innerHTML =
                "<div style='text-align: left;font-weight: 600;'>" + msg + "</div>" +
                "<div style='font-size:11px; color:#f0d890; text-align:right; margin-top:2px;font-weight: 600;'>" + dateTime + "</div>";

            wrapper.appendChild(newMsg);
            chatMessages.appendChild(wrapper);

            chatMessages.scrollTop = chatMessages.scrollHeight;
            input.value = "";
            lastMessageCount++;
        },
        error: function(xhr, status, error) {
            console.error("Error sending query:", error);
        }
    });
}
</script>

  

</html>

