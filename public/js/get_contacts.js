$(function() {
    var list = [ 
        { uType:5, hiddenHandler:"hdPreventerId" },
        { uType:2, hiddenHandler:"hdAssociatedId" }
    ];
    var i = 0;
    $(".has-autocomplete").each(function(){
        var uType = list[i].uType;
        var hdHandler = $("#"+list[i].hiddenHandler);
        $(this).autocomplete({
            cache: false,
            source: function(request, response) {
                $.getJSON(url + "reports/getContactsByTerm", { term:request.term, userType: uType }, function(data){
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
                hdHandler.val(ui.item.value);
            },
            focus: function(event, ui) {
                event.preventDefault();
                this.value = ui.item.label;
                hdHandler.val(ui.item.value);
            }
        }); 
        i++;
    }); 
});
