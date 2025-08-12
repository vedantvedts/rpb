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

function generateTableHTML(data) {

	if (!data || data.length === 0) {
		return '<p>No Status available.</p>';
	}

	var table = '<table class="table table-bordered" style="width: 100%;font-weight: 600;">';
	table += '<thead><tr style="background-color: #edab33;color:#034189;"><th>Officer Name</th><th>Action Date</th><th>Remarks</th><th>Status</th></tr></thead>';
	table += '<tbody>';

	data.forEach(function(row) {
		table += '<tr>';
		table += '<td>' + (row[1] || '--') + ', ' + (row[2] || '--') + '</td>';
		table += '<td align="center">' + (row[5] || '--') + '</td>';
		table += '<td>' + (row[4] || '--') + '</td>';
		table += '<td style="color: #00008B;">' + (row[3] || '--') + '</td>';
		table += '</tr>';
	});

	table += '</tbody></table>';
	return table;
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
			var html = '';

			// Create table structure
			html += '<div class="table-responsive" style="">';
			html += '<table class="table table-bordered" style="box-shadow: 5px 0px 5px rgba(0, 0, 5, 5);">';
			html += '<thead style="background-color: #f7f4e9;">';
			html += '<tr>';
			html += '<th style="width: 30%;">Flow</th>';
			html += '<th style="width: 40%;">Officer</th>';
			html += '<th style="width: 30%;">Status</th>';
			html += '</tr>';
			html += '</thead>';
			html += '<tbody>';


			html += '<tr>';
			html += '<td><b>Initiated By</b></td>';
			html += '<td style="color: #370088;"><b>' + row[19] + '</b></td>';
			html += '<td style="font-weight:600;">Initiated</td>';
			html += '</tr>';

			var rcStatusCodeNext = row[40];
			var rc1Status = row[41];
			var rc2Status = row[42];
			var rc3Status = row[43];
			var rc4Status = row[44];
			var rc5Status = row[45];
			var apprOffStatus = row[46];

			var labels = [
				{ title: 'RPB Member', field: row[21], role: row[22], batch: row[41] },
				{ title: 'RPB Member', field: row[24], role: row[25], batch: row[42] },
				{ title: 'RPB Member', field: row[27], role: row[28], batch: row[43] },
				{ title: 'Subject Expert', field: row[30], role: row[31], batch: row[44] }
			];


			for (var i = 0; i < labels.length; i++) {
				var item = labels[i];
				if (item.field != null && String(item.field).trim() !== '') {
					html += '<tr>';
					html += '<td><b>' + item.title + '</b></td>';
					html += '<td>';

					if (item.role) {
						html += '<span style="color:#034cb9"><b>' + item.role + '</b></span><br>';
					}
					html += '<span style="color: #370088"><b>' + item.field + '</b></span>';
					html += '</td>';
					html += '<td>';

					if (item.batch === 'Y') {
						html += '<span style="color: green;font-weight:600;">Recommended</span>';
						html += ' <img src="view/images/verifiedIcon.png" width="16" height="16">';
					} else {
						html += '<span style="color: #bd0707;font-weight:600;">Recommendation Pending</span>';
					}

					html += '</td>';
					html += '</tr>';
				}
			}

			// RPB Member Secretary
			if (row[33] != null && String(row[33]).trim() !== '') {
				html += '<tr>';
				html += '<td><b>RPB Member Secretary</b></td>';
				html += '<td>';

				if (row[34]) {
					html += '<span style="color:#034cb9"><b>' + row[34] + '</b></span><br>';
				}
				html += '<span style="color: #370088"><b>' + row[33] + '</b></span>';
				html += '</td>';
				html += '<td>';

				if (row[45] === 'Y') {
					html += '<span style="color: green;font-weight:600;">Reviewed</span>';
					html += ' <img src="view/images/verifiedIcon.png" width="16" height="16">';
				} else {
					html += '<span style="color: #bd0707;font-weight:600;">Review Pending</span>';
				}

				html += '</td>';
				html += '</tr>';
			}

			// RPB Chairman
			if (row[36] != null && String(row[36]).trim() !== '') {
				html += '<tr>';
				html += '<td><b>RPB Chairman</b></td>';
				html += '<td>';

				if (row[37]) {
					html += '<span style="color:#034cb9"><b>' + row[37] + '</b></span><br>';
				}
				html += '<span style="color: #370088"><b>' + row[36] + '</b></span>';
				html += '</td>';
				html += '<td>';

				if (row[46] === 'Y') {
					html += '<span style="color: green;font-weight:600;">Approved</span>';
					html += ' <img src="view/images/verifiedIcon.png" width="16" height="16">';
				} else {
					html += '<span style="color: #bd0707;font-weight:600;">Approval Pending</span>';
				}

				html += '</td>';
				html += '</tr>';
			}

			html += '</tbody>';
			html += '</table>';
			html += '</div>';

			$('#ApprovalStatusDiv').html(html);
		},
		error: function(xhr, status, error) {
			console.error('AJAX Error: ' + status + " " + error);
			$('#ApprovalStatusDiv').html('<div class="alert alert-danger">Error loading approval status</div>');
		}
	});
}