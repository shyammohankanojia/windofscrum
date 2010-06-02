/**
 * ///////////////////////////////////////////////////
 * AJAX
 * ///////////////////////////////////////////////////
 */
/**
 * Shows an alert to the user with relevant information about the ajax error for
 * the user.
 * 
 * @param transport
 * @return
 */
function showTransportError(transport) {
	alert("status " + transport.status + ":" + transport.responseText)
}