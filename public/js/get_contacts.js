$(function() {
    $("#txPreventerName").autocomplete({
        cache: false,
        source: function(request, response) {
            $.getJSON(url + "reports/getContactsByTerm", { term:request.term, userType: 5}, function(data){
                response($.map(data, function(item) {
                    return {
                        label: item.ContactName,
                        value: item.ContactId
                    }
                }))
            });
        },
        minLength: 1,
        select: function( event, ui ) {
            event.preventDefault();
            this.value = ui.item.label;
            $("#hdPreventerId").val(ui.item.value);
        },
        focus: function(event, ui) {
            event.preventDefault();
            this.value = ui.item.label;
            $("#hdPreventerId").val(ui.item.value);
        }
    });    
});
