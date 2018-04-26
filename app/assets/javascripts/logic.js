/* Place all the behaviors and hooks related to the matching controller here.
    All this logic will automatically be available in application.js. */
function accordionActions() {
    
    var acc = document.getElementsByClassName("accordion-header");
    
    if(acc) {
        for (var i = 0; i < acc.length; i++) {
            acc[i].addEventListener("click", function() {
        
                /* Toggle between hiding and showing the active panel */
                var body = this.nextElementSibling;
                if (body.style.display === "block") {
                    body.style.display = "none";
                } else {
                    body.style.display = "block";
                }
            });
        }
    }
    /* Accordion Dropdown JS taken from W3: https://www.w3schools.com/howto/howto_js_accordion.asp */
};
