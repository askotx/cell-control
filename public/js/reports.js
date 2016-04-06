$(function() {
    var grid = $("#demoGrid");
    
    getColumnIndexByName = function(grid,columnName) {
        var cm = grid.jqGrid('getGridParam','colModel'),l=cm.length;
        for (i=0; i<l; i++) {
            if (cm[i].name===columnName) {
                return i; // return the index
            }
        }
        return -1;
    };
    
    reportLoadComplete = function () {
        var iCol = getColumnIndexByName(grid,'opts');
        grid.children("tbody")
            .children("tr.jqgrow")
            .children("td:nth-child("+(iCol+1)+")")
            .each(function() {
                $("<div>",
                {
                    //style: "vertical-align: middle; align: center",
                    //class: "ui-pg-div ui-inline-custom",
                    title: "Custom",
                    mouseover: function() {
                        $(this).addClass('ui-state-hover');
                    },
                    mouseout: function() {
                        $(this).removeClass('ui-state-hover');
                    },
                    click: function(e) {
                        var reportId = $(e.target).closest("tr.jqgrow").attr("id");
                        $("#hdReportId").val(reportId);

                        $("#txPreventerName").val(grid.jqGrid('getCell', reportId, 'PreventerName'));
                        $("#txAssociatedName").val(grid.jqGrid('getCell', reportId, 'ElectronicAssociateName'));
                        $("#txExternalSeller").val(grid.jqGrid ('getCell', reportId, 'ExternalSellerName'));
                        
                        $("#detailedReportGrid").jqGrid('setGridParam',{ loadonce: false, datatype:'json', postData: {
                            report_id: function() { return reportId; }
                        }}).trigger('reloadGrid');
                    }
                }
              ).css({"margin-left": "5px", "display": "inline-block"})
               .addClass("ui-pg-div ui-inline-custom")
               .append('<span class="ui-icon ui-icon-document"></span>')
               .appendTo($(this).children("div"));
            });
        };
    $("#demoGrid").jqGrid({
        url : url + "reports/getAllReports",
        datatype: "json",
        mtype: "GET",
        jsonReader: { 
            id:"ReportId",
            repeatitems: false//,
            //root: function (obj) { return obj; } 
        },
        //postData: {
        //    query_id: function() { return jQuery("#queryId").val(); }
        //},
        rowNum: 10,
        rowList: [10,20,30],
        caption: "Reporte de Telefon&iacute;a",
        colNames:['Reporte','Prevención','Electrónica', 
                  'Telefonía','Tipo','ReportTypeId',
                  'PreventerId','ExternalSellerId', 'AssociatedId','Opciones'],
        colModel:[
            {name:'ReportId',index:'ReportId', width:80, align:"center", sorttype:"int",search:true},
            {name:'PreventerName',index:'PreventerName', width:90, align:"left"/*, sorttype:"date", formatter:"date"*/},
            {name:'ElectronicAssociateName',index:'ElectronicAssociateName', width:90, align:"left"},
            {name:'ExternalSellerName',index:'ExternalSellerName', width:90, align:"left"/*, align:"right",sorttype:"float", formatter:"number"*/},
            {name:'ReporType',index:'ReportTypeId', width:80, align:"left"/*, align:"right",sorttype:"float"*/},        
            {name:'ReportTypeId',index:'ReportTypeId', width:80, hidden:true/*,align:"right",sorttype:"float"*/},        
            {name:'PreventerId',index:'PreventerId', width:80, sortable:false, hidden:true},
            {name:'ExternalSellerId',index:'ExternalSellerId', width:80, sortable:false, hidden:true},
            {name:'AssociatedId',index:'AssociatedId', width:80, sortable:false, hidden:true},
            {name:'opts', index: 'opts', width: 75, align: 'center', sortable: false, formatter: 'actions',
             formatoptions: { delbutton: false, editbutton: false} }
        ],
        pager: "#gridPager",
        viewrecords: true,
        gridview: true,
        hidegrid:true,
        altRows: true,
        shrinkToFit:true,
        autowidth: true,
        height: '300px',
        //height: 'auto'
        loadComplete: reportLoadComplete
    });
    //$("#demoGrid").jqGrid('navGrid','#gridPager',{edit:false,del:false});
    //$("#demoGrid").jqGrid('filterToolbar',{defaultSearch:true,stringResult:true});
    $("#demoGrid").jqGrid("setLabel","PreventerName","",{"text-align":"left"});
    $("#demoGrid").jqGrid("setLabel","ElectronicAssociateName","",{"text-align":"left"});
    $("#demoGrid").jqGrid("setLabel","ExternalSellerName","",{"text-align":"left"});
    $("#demoGrid").jqGrid("setLabel","ReporType","",{"text-align":"left"});
          
    //test responsiveness
    /*$(window).on('resize', function(event, ui) {
        // Get width of parent container
        var parWidth = $("#gbox_demoGrid").parent().width();
        var curWidth = $("#gbox_demoGrid").width();
        //console.log("span width " + parWidth + " gridWidth " + gWidth);
        var w = parWidth - 1; // Fudge factor to prevent horizontal scrollbars
        if (Math.abs(w - curWidth) > 2)
        {
            //alert("resize to " + width);
            console.log("span width " + parWidth + " gridWidth " + curWidth);    
            $("#demoGrid").setGridWidth(w);
            console.log("new width " + w);
        }

    }).trigger('resize');*/
});