
/*===========Print js===========*/


function OpenPrintView() {
    var printButton = $('#PrintButton');
    var printCard = $('.PrintCard');
    var printCardBody = $('.PrintCardBody');

    if (printButton) {
        printButton.css('display', 'none');
    }

    if (printCard) {
        printCard.css({'border-color': 'white','width': '100%','height': '935px'});
    }
    
    if (printCardBody) {
    	printCardBody.css({
		    'margin': '10px',
		    'padding': '0px',
		    'border-color': 'white',
		    'height': '935px'
		});
    }

    window.print();
   
} 

window.onafterprint = function() {
	    var printButton = $('#PrintButton');
        var printCard = $('.PrintCard');
        var printCardBody = $('.PrintCardBody');
    
    if (printButton) {
         printButton.css('display', 'block');
    }

    if (printCard) {
      printCard.css({
		    'border-color': 'grey',
		    'width': '794px',
		    'height': '1123px'
		});
    }

    if (printCardBody) {
    	printCardBody.css({
		    'margin': '25px',
		    'padding': '10px',
		    'border-color': 'black',
		    'height': '1050px'
		});
    }
};

document.addEventListener('keydown', function handleKeyPress(event) {
    
    if (event.ctrlKey && event.key === 'p') {
    	OpenPrintView()
        event.preventDefault();
    }
});