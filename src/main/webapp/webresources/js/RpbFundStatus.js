
// Fund Status Details

function openApprovalStatusAjax(fundApprovalId) {
    $.ajax({
        url: 'getRPBApprovalHistoryAjax.htm',
        type: 'GET',
        data: { fundApprovalId: fundApprovalId },
        success: function(response) {
            var data = JSON.parse(response);
            if (!Array.isArray(data[0])) {
                data = [data]; // handle single-row case
            }

            var tableHTML = generateTableHTML(data);
            $('#ApprovalStatusModal').modal('show');
            $('#EmployeeModalTable').html(tableHTML);

            previewInformation(fundApprovalId);
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error: ' + status + error);
        }
    });
}

function previewInformation(fundApprovalId) {
    $.ajax({
        url: 'getRPBApprovalStatusAjax.htm',
        type: 'GET',
        data: { fundApprovalId: fundApprovalId },
        success: function(response) {
            var data = JSON.parse(response);

            if (!Array.isArray(data) || data.length === 0) {
                $('#ApprovalStatusDiv').html('<p>No approval status data available.</p>');
                return;
            }

            var row = data[0];
            var html = '<div class="status-card-container">';

            // Always show Initiator
            html += createCard("Initiationclass","Initiated By", row[19], "", "Initiated", true, "Initiated", "fa-solid fa-circle-check", "left", "", "");

			var fundStatus = row[20];
			
			if(fundStatus == null)
			{
				fundStatus = 'NA';
			}
            
            // Split roles, officers, and statuses
            var roles = row[21] ? row[21].split(",") : [];
            var empIds = row[22] ? row[22].split(",") : [];
            var officers = row[24] ? row[24].split("###").map(e => e.trim()) : [];
            var officerRemarks = row[25] ? row[25].split("###").map(e => e.trim()) : [];
            var statuses = row[23] ? row[23].split(",") : [];
            var returnedBy = row[26] || 0;
            var returedDate = row[27] || 0;
            
             if(roles == null || typeof(roles) == 'undefined' || roles.length == 0)
            {
				var statusText = fundStatus == 'E' ? 'Re-Forward Pending' : 'Forward Pending';
				
				html += createCard("forwardPendingclass", "", "", "", "", false, statusText, "fa-solid fa-circle-check", "center", "", "");
				$('#ApprovalStatusDiv').html(html);
				$(".forwardPendingclass").empty();
				$(".forwardPendingclass").css({
				    "display": "grid",
				    "text-align": "center"
				});
				var forwardPending= `<div class="status warning" style="width: 100% !important;">
                        						<i class="fa-solid fa-circle-check"></i> ${statusText}
                   								 </div>`;
				$(".forwardPendingclass").html(forwardPending);
				
				return;
			}

            roles.forEach(function(role, idx) {
                var officer = officers[idx] || "-";
                var empId = empIds[idx] || "-";
                var officerRemark = officerRemarks[idx] || "";
                var status = statuses[idx] || "N";

                var isApproved = status === "Y";
                var pendingText = (role === "CC") ? "Approval Pending" : "Recommendation Pending";

                // Map role codes to readable titles
                var titleMap = {
                    "DH": "Division Head",
                    "CM": "RPB Member",
                    "SE": "Subject Expert",
                    "CS": "RPB Member Secretary",
                    "CC": "RPB Chairman"
                };

                html += createCard(role+'class',
                    titleMap[role] || role,
                    officer,
                    officerRemark,
                    isApproved ? (role === "CC" ? "Approved" : (role === "CS" ? "Reviewed" : "Recommended")) : "Pending",
                    isApproved,
                    pendingText,
                    isApproved ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half",
                    "left",
                     returnedBy == empId && fundStatus=='R' ? 'Returned on ' : '',
                     returedDate
                );
                console.log('fundStatus****',fundStatus);
            });

            html += '</div>';

            // Utility to render a card
            function createCard(classAttribute, title, officer, remark, status, isApproved, pendingText, iconClass, align, returnedTxt, returnedDate) {
                let statusClass = isApproved ? "success" : "warning";
                let statusText = isApproved ? status : pendingText;

                return `
                <div class="status-card ${classAttribute} ${returnedTxt ? `returnBg` : ''}" style="text-align:${align} !important;">
                
                    ${returnedTxt ? `<h6 class="returnedTxt">${returnedTxt} ${returnedDate ? `${returnedDate}` : ''}</h6>` : ''}
                    <h6>${title}</h6>
                    <p><b>${officer}</b></p>
                    <div class="status ${statusClass}">
                        <i class="${iconClass}"></i> ${statusText}
                    </div>
                     ${remark && remark!='NA' ? `<p class="RcRemarks"><span class="RcRemarkTitle">Remarks : </span> ${remark}</p>` : ''}
                </div>`;
            }

            $('#ApprovalStatusDiv').html(html);
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error: ' + status + " " + error);
            $('#ApprovalStatusDiv').html('<div class="alert alert-danger">Error loading approval status</div>');
        }
    });
}


function generateTableHTML(data) {
    if (!data || data.length === 0) {
        return '<p>No Status available.</p>';
    }

    let timeline = '';

    // Officer details table under timeline
    timeline += '<div class="table-responsive"><table class="table table-bordered dataTable" style="width: 95%;margin: auto; border: 1px solid #cfcfcf;">';
    timeline += '<thead><tr><th>Officer</th><th>Action Date</th><th>Remarks</th><th>Status</th></tr></thead><tbody>';

    data.forEach(function(row) {
        timeline += '<tr>';
        timeline += `<td>${row[1] || '-'}, ${row[2] || '-'}</td>`;
        timeline += `<td>${row[5] || '-'}</td>`;
        timeline += `<td>${row[4] || '-'}</td>`;
        timeline += `<td class="status-text">${row[3] || '-'}</td>`;
        timeline += '</tr>';
    });

    timeline += '</tbody></table></div></div>';

    return timeline;
}


//  ******************************************* Fund Details View ************************************************************************
 
 function openFundDetailsModal(fundApprovalId, ec) {

     var estimatedCost = $(ec).closest('tr').find('.tableEstimatedCost').text().trim() || '-';

     // First AJAX call (Details)
     $.ajax({
         url: 'GetAttachmentDetailsAjax.htm',
         method: 'GET',
         data: { fundApprovalId: fundApprovalId },
         success: function(data) {

             var detailsDiv = $(".AttachmentDetails");
             detailsDiv.empty(); // clear previous

             if (data && data.length > 0) {
                 var attach = data[0];
                 var statusColor = '';
                 if (attach.Status === 'Approved') statusColor = 'green';
                 else if (attach.Status === 'Pending') statusColor = '#8c2303';
                 else if (attach.Status === 'Forwarded') statusColor = 'blue';
                 else if (attach.Status === 'Returned') statusColor = 'red';
                 
                 var serialNo="";
                 serialNo = attach.SerialNo != null && attach.SerialNo !=0 ? '(' + attach.SerialNo + ')' : "";

                 var html = '<table class="table table-bordered table-striped">'
                     + '<tbody>'
                     + '<tr>'
                     + '<th style="color:#0080b3; font-size:16px;">Budget Head</th>'
                     + '<td style="font-weight:600; font-size:16px;">' + (attach.BudgetHead || '') + '</td>'
                     + '<th style="color:#0080b3; font-size:16px;">Budget Type</th>'
                     + '<td style="font-weight:600; font-size:16px;">' + (attach.BudgetType || '') + '</td>'
                     + '</tr>'
                     + '<tr>'
                     + '<th style="color:#0080b3; font-size:16px;">Estimate Type</th>'
                     + '<td style="font-weight:600; font-size:16px;">' + (attach.EstimateType || '') + ' (' + (attach.REFBEYear || '') + ')</td>'
                     + '<th style="color:#0080b3; font-size:16px;">Initiating Officer</th>'
                     + '<td style="font-weight:600; font-size:16px;">' + (attach.InitiatingOfficer || '') + ', ' + (attach.Designation || '') + '</td>'
                     + '</tr>'
                     + '<tr>'
                     + '<th style="color:#0080b3; font-size:16px;">Nomenclature</th>'
                     + '<td colspan="3" style="font-weight:600; font-size:16px;">' + (attach.ItemNomenculature || '') + '</td>'
                     + '</tr>'
                     + '<tr>'
                     + '<th style="color:#0080b3; font-size:16px;">Justification</th>'
                     + '<td style="font-weight:600; font-size:16px;">' + (attach.Justification || '') + '</td>'
                     + '<th style="color:#0080b3; font-size:16px;">Estimated Cost</th>'
                     + '<td style="color:#00008B;font-weight:600; font-size:16px;">' + (estimatedCost || '-') + '</td>'
                     + '</tr>'
                     + '<tr>'
                     + '<th style="color:#0080b3; font-size:16px;">Division</th>'
                     + '<td style="font-weight:600; font-size:16px;">' + (attach.Division || '') + ' (' + (attach.DivisionShortName || '') + ')</td>'
                     + '<th style="color:#0080b3; font-size:16px;">Status</th>'
                     + '<td style="font-weight:600; font-size:16px; color:' + statusColor + '">' + (attach.Status || '') + '&nbsp;&nbsp;<span style="color:#00008B;">'+(serialNo || '')+'</span></td>'
                     + '</tr>'
                     + '</tbody>'
                     + '</table>';

                 detailsDiv.append(html);
             } else {
                 detailsDiv.append("<div class='text-danger fw-bold'>No details found</div>");
             }
         },
         error: function() {
             console.error("AJAX call failed");
             $(".AttachmentDetails").html("<div class='text-danger fw-bold'>Failed to load details</div>");
         }
     });

	 $.ajax({
	     url: 'getFundApprovalRevisionDetails.htm',
	     method: 'GET',
	     data: { fundApprovalId: fundApprovalId },
	     success: function(data) {
	         var container = $("#RevisionHistoryContainer");
	         container.empty();

	         if (!data || data.length === 0) {
	              container.html("<div class=' text-center font-weight-bold' style='color: #856404; background-color: #fff3cd;border-color: #ffeeba;padding: 4px;'>No Revision found</div>");
	             return;
	         }

	         $.each(data, function(index, rev) {
	             var revTitle = rev.RevisionCount == 0 ? "ORIGINAL" : "REVISION - " + rev.RevisionCount;

	             // Header background colors only
	             var headerColor = rev.RevisionCount == 0 ? "background-color:#69af4c; color:white;"   
	                                                      : "background-color:#af9f4c; color:white;"; 

	             var tableHtml =
	                 '<div class="mb-3" style="border:1px solid #ccc; border-radius:4px;">' +
	                   '<h6 class="font-weight-bold p-2 m-0" style="text-align: center; ' + headerColor + '">' + revTitle + '</h6>' +
	                   '<table class="table table-bordered table-striped m-0 bg-white">' +
	                     '<tbody>' +

	                       '<tr>' +
	                         '<th style="width:30%;color:#0080b3;">Budget Type</th>' +
	                         '<td style="font-weight:600">' + (rev.BudgetType || '-') + '</td>' +
	                         '<th style="width:30%;color:#0080b3;">Budget Head</th>' +
	                         '<td style="font-weight:600">' + (rev.BudgetHead || '-') + '</td>' +
	                       '</tr>' +

	                       '<tr>' +
	                         '<th style="width:30%;color:#0080b3;">Initiating Officer</th>' +
	                         '<td style="font-weight:600">' + (rev.InitiatingOfficer || '-') + ', ' + (rev.Designation || '-') + '</td>' +
	                         '<th style="width:30%;color:#0080b3;">Estimated Cost</th>' +
	                         '<td style="color:#00008B;font-weight:600">' + rupeeFormat((rev.EstimatedCost).toLocaleString()) + '</td>' +
	                       '</tr>' +

	                       '<tr>' +
	                         '<th style="width:30%;color:#0080b3;">Nomenclature</th>' +
	                         '<td colspan="3" style="font-weight:600">' + (rev.ItemNomenculature || '-') + '</td>' +
	                       '</tr>' +

	                     '</tbody>' +
	                   '</table>' +
	                 '</div>';

	             container.append(tableHtml);
	         });
	     },
	     error: function() {
	         $("#RevisionHistoryContainer").html(
	             "<div class='alert alert-danger text-center font-weight-bold'>Failed to load revisions</div>"
	         );
	     }
	 });



	   
     // Second AJAX call (Attachments list)
     $.ajax({
         url: 'GetFundRequestAttachmentAjax.htm',
         method: 'GET',
         data: { fundApprovalId: fundApprovalId },
         success: function(data) {
             var body = $("#eAttachmentModalBody");
             body.empty();
             var count=1;

             if (data.length === 0) {
                 body.append("<tr><td colspan='3' style='text-align: center; color: red;font-weight:700'>No attachment found</td></tr>");
                 $("#previewSection").hide();
                 $("#filePreviewIframe").attr("src", "");
                 $("#previewFileName").text(""); 
             } else {
                 $.each(data, function(index, attach) {
                     var viewUrl = "PreviewAttachment.htm?attachid=" + attach.fundApprovalAttachId;
                     var downloadUrl = "FundRequestAttachDownload.htm?attachid=" + attach.fundApprovalAttachId;

                     var row = "<tr>" +
                       "<td style='font-weight:700'>" + count++ + ".</td>" +
                         "<td style='text-align: center; font-weight:700'>" + attach.fileName + "</td>" +
                         "<td style='text-align: center;'>" +
                         "<button class='btn fa fa-eye text-primary' title='Preview - " + attach.fileName + " Attachment' onclick=\"previewAttachment('" + viewUrl + "','" + attach.fileName + "')\"></button>" +
                         "</td>" +
                         "</tr>";
                     body.append(row);

                     // Auto-preview first attachment
                     if (index === 0) {
                         previewAttachment(viewUrl, attach.fileName);
                     }
                 });
             }

             $(".AttachmentModal").modal("show");
         },
         error: function() {
             alert("Failed to load attachments.");
         }
     });
 }
 
  // Define previewAttachment globally
 function previewAttachment(url, fileName) {
     $("#filePreviewIframe").attr("src", url);
     $("#previewSection").show();
     $("#previewFileName").text(fileName || "");
 }
 
 
function getAttachementDetailsInline(fundRequestId) {
    $.ajax({
        url: 'GetFundRequestAttachmentAjax.htm',  
        method: 'GET', 
        data: { fundApprovalId: fundRequestId },  
        success: function(data) {
            var contentDiv = $(".attachementLink").empty();
            if (data.length === 0) {
                contentDiv.append("<span style='text-align: center; color: red; font-weight:700'>No attachment found</span>");
            } else {
                var list = $('<ul class="list-group d-flex flex-row" srtyle="list-style-type: disc !important; display: flex !important; gap: 20px !important;"></ul>');

                data.forEach(function(attach) {
                    var icon = '<i class="fa fa-paperclip text-primary"></i>'; // default icon
                    // you can customize icon based on filename if you want:
                    if (attach.fileName.toLowerCase().includes("cost")) {
                        icon = '<i class="fa fa-calculator text-success"></i>';
                    } else if (attach.fileName.toLowerCase().includes("bq")) {
                        icon = '<i class="fa fa-list-alt text-warning"></i>';
                    } else if (attach.fileName.toLowerCase().includes("justification")) {
                        icon = '<i class="fa fa-file-text text-info"></i>';
                    }

                    var item = $('<li class="list-group-item d-flex align-items-center"></li>');
                    item.append(icon);
                    item.append('&nbsp;<a href="PreviewAttachment.htm?attachid='+ attach.fundApprovalAttachId +'" target="_blank" style="font-weight:600; font-size:14px; text-decoration:none; color:#034189;" title="Click to preview/download">'+ attach.fileName +'</a>');
                    
                    list.append(item);
                });

                contentDiv.append(list);
            }
        }
    });
}


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


 
