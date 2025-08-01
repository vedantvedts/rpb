$(document).ready(function() {
    $("#myTable").DataTable({
        "lengthMenu": [ 50, 75, 100],
        "pagingType": "simple",
        "language": {
		      "emptyTable": "No Record Found"
		    }

    });

   $('[data-toggle="tooltip"]').tooltip({
		 trigger : 'hover',
	});
	$('[data-toggle="tooltip"]').on('click', function () {
		$(this).tooltip('hide');
	});


    $('.select2').select2();

    window.setTimeout(function() {
        $(".alert").fadeTo(500, 0).slideUp(500, function() {
            $(this).remove();
        });
    }, 4000);

	

	var windowheight= $(window).height(); 
	$('.dashboard-card').css('min-height',(windowheight - 130) +'px'  );
	$('.dashboard-card').css('max-height',(windowheight - 130) +'px'  );
	$('.sidebar-container').css('max-height',(windowheight - 75) +'px'  );
	$('.sidebar-container').css('min-height',(windowheight - 75) +'px'  );
	$('.dashboard-margin .table-responsive').css('max-height',(windowheight - 465) +'px'  );


});