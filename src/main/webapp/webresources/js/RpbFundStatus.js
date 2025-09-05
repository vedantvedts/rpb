
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

			html += createCard("Initiated By", row[19], "Initiated", true, "Initiated", "fa-solid fa-circle-check");
			html += createCard("Division Head", row[51], row[48] === "Y" ? "Recommended" : "Pending", row[48] === "Y", "Recommendation Pending", row[48] === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
			
			// RC1 
            if(parseInt(row[20]!= null ? row[20] : 0) > 0 && row[22]!=null && row[22] == 'CM')
            {
				var rc1Status=row[41];
				html += createCard("RPB Member", row[21], rc1Status === "Y" ? "Recommended" : "Pending", rc1Status === "Y", "Recommendation Pending", rc1Status === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
			}
            
			// RC2 
            if(parseInt(row[23]!= null ? row[23] : 0) > 0 && row[25]!=null && row[25] == 'CM')
            {
				var rc1Status=row[42];
				html += createCard("RPB Member", row[24], rc1Status === "Y" ? "Recommended" : "Pending", rc1Status === "Y", "Recommendation Pending", rc1Status === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
			}
            
			// RC3 
            if(parseInt(row[26]!= null ? row[26] : 0) > 0 && row[28]!=null && row[28] == 'CM')
            {
				var rc1Status=row[43];
				html += createCard("RPB Member", row[27], rc1Status === "Y" ? "Recommended" : "Pending", rc1Status === "Y", "Recommendation Pending", rc1Status === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
			}
			
			// RC4
            if(parseInt(row[29]!= null ? row[29] : 0) > 0 && row[31]!=null && row[31] == 'CM')
            {
				var rc1Status=row[44];
				html += createCard("RPB Member", row[30], rc1Status === "Y" ? "Recommended" : "Pending", rc1Status === "Y", "Recommendation Pending", rc1Status === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
			}
            
			// RC5
            if(parseInt(row[32]!= null ? row[32] : 0) > 0 && row[34]!=null && row[34] == 'CM')
            {
				var rc1Status=row[45];
				html += createCard("RPB Member", row[33], rc1Status === "Y" ? "Recommended" : "Pending", rc1Status === "Y", "Recommendation Pending", rc1Status === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
			}
            
            html += createCard("RPB Member Secretary", row[33], row[45] === "Y" ? "Reviewed" : "Pending", row[45] === "Y", "Review Pending", row[45] === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
            html += createCard("RPB Chairman", row[36], row[46] === "Y" ? "Approved" : "Pending", row[46] === "Y", "Approval Pending", row[46] === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");

            html += '</div>';
            
              // Utility to render a card
            function createCard(title, officer, status, isApproved, pendingText, iconClass) {
                let statusClass = isApproved ? "success" : "warning";
                let statusText = isApproved ? status : pendingText;

                return `
                <div class="status-card">
                    <h6>${title}</h6>
                    <p><b>${officer || "--"}</b></p>
                    <div class="status ${statusClass}">
                        <i class="${iconClass}"></i> ${statusText}
                    </div>
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
    timeline += '<div class="table-responsive"><table class="table table-sm">';
    timeline += '<thead><tr><th>Officer</th><th>Action Date</th><th>Status</th></tr></thead><tbody>';

    data.forEach(function(row) {
        timeline += '<tr>';
        timeline += `<td><b>${row[1] || '--'}</b>, ${row[2] || '--'}</td>`;
        timeline += `<td>${row[5] || '--'}</td>`;
        timeline += `<td class="status-text">${row[3] || '--'}</td>`;
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
