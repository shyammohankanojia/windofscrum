
/**
 * Synchronous call.
 * @return nothing.
 */
function unassign(link) {
  var url= link.href

  new Ajax.Request(url, {
    method: 'delete',
    asynchronous: false,
    onSuccess: function(transport) {
//      $(link).up('tr').remove();
    },
    onFailure: function(transport) {
      alert('Failed to unassign story. Caused by: ' + transport.responseText)
    }
  });
}
