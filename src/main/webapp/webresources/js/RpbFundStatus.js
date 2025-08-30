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

            // Cards
            html += createCard("Initiated By", row[19], "Initiated", true, "Initiated", "fa-solid fa-circle-check");
            html += createCard("Division Head", row[51], row[48] === "Y" ? "Recommended" : "Pending", row[48] === "Y", "Recommendation Pending", row[48] === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
            html += createCard("RPB Member Secretary", row[33], row[45] === "Y" ? "Reviewed" : "Pending", row[45] === "Y", "Review Pending", row[45] === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");
            html += createCard("RPB Chairman", row[36], row[46] === "Y" ? "Approved" : "Pending", row[46] === "Y", "Approval Pending", row[46] === "Y" ? "fa-solid fa-circle-check" : "fa-solid fa-hourglass-half");

            html += '</div>';

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

    let timeline = '<div class="timeline-container">';
    timeline += '<div class="timeline-steps">';

    // Steps
    const steps = ["Initiated", "Forwarded", "Recommended", "Reviewed", "Approved"];
    let completedSteps = data.map(row => row[3]); // status field

    steps.forEach(step => {
        let isCompleted = completedSteps.includes(step.toUpperCase());
        let statusClass = isCompleted ? "done" : "pending";
        let iconClass = isCompleted ? "fa-solid fa-circle-check" : "fa-regular fa-circle";

        timeline += `
            <div class="timeline-step ${statusClass}">
                <i class="${iconClass}"></i>
                <div>${step}</div>
            </div>
        `;
    });

    timeline += '</div><hr>';

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
