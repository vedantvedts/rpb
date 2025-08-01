Console.log("********************************Inside File***********************************");
$('#selProject').change(
					function(event) {
						var $project= $("select#selProject").val();
						
						/*------------------Project Id not Equal to Zero [Project]--------------------*/
						
						$.get('GetBudgetHeadList.htm', {
							ProjectDetails : $project
						}, function(responseJson) {
							var $select = $('#selbudgethead1');
							$select.find('option').remove();
							$("#selbudgethead1").append("<option value=''>Select Budget Head </option>");
							var result = JSON.parse(responseJson);
							$.each(result, function(key, value) {
								$("#selbudgethead1").append("<option value="+value.budgetHeadId+">"+ value.budgetHeaddescription + "</option>");
							});
						});
					});
					
				
/*------------------Select Budget Item using Ajax--------------------*/

$('#selbudgethead1').change(
		function(event) {
			var $project= $("select#selProject").val();
			var arr=$project.split("=");
			var $projectId=arr[0];
			var $budgetHeadId = $("select#selbudgethead1").val();
			//calling controller using ajax for project Drop Down based on projectId
			$.get('SelectbudgetItem.htm', {
				projectid : $projectId,
				budgetHeadId : $budgetHeadId
			}, function(responseJson) {
				var $select = $('#selbudgetitem12');
				$select.find('option').remove();
				var result = JSON.parse(responseJson);
				console.log("After Controller :"+result);
				$.each(result, function(key, value) {
					$("#selbudgetitem12").append("<option value="+value.budgetItemId+" >"+ value.headOfAccounts+"  ["+value.subHead+"]</option>");
				});
			});
		});
