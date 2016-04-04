$(function() {
    var grid = $("#demoGrid");
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
    
    getColumnIndexByName = function(grid,columnName) {
        var cm = grid.jqGrid('getGridParam','colModel'),l=cm.length;
        for (i=0; i<l; i++) {
            if (cm[i].name===columnName) {
                return i; // return the index
            }
        }
        return -1;
    };
    
    $("#modal-message").dialog({
        autoOpen: false,
        modal: true,
        width: 825,
        buttons: {
            Cerrar: function () {
                $(this).dialog("close");
            }
        }
    });
    var detailed =  $("#detailedReportGrid");
    var settings = {
      output:"css",
      bgColor: "#FFFFFF",
      color: "#000000",
      barWidth: 1,
      barHeight: 20,
      //optional settings?
      moduleSize: 5,
      posX: 10,
      posY: 20,
      addQuietZone: 1
    };
    detailedReportLoadComplete = function () {
        if (detailed.jqGrid('getGridParam','datatype') === "json"){
            detailed.jqGrid('getRowData');
            
            $("div.ui-jqgrid-bdiv").css("overflow-x","hidden");
            $('#modal-message').dialog('open');
        }
        var rowIDs = detailed.jqGrid('getDataIDs');
        var barcodeArray = [];
        var i = 0;
        for (i = 0; i < rowIDs.length ; i++){
            var rowID = rowIDs[i];
            var row = detailed.jqGrid ('getRowData', rowID);
            barcodeArray.push(row.BarCode);
        }
        i=0;
        var iCol = getColumnIndexByName(detailed,'opts2');
        detailed
            .children("tbody")
            .children("tr.jqgrow")
            .children("td:nth-child("+(iCol+1)+")")
            .each(function() {
                $("<div>",{})
                .barcode(barcodeArray[i], "ean13", settings)
                .appendTo($(this).children("div"));
                i++;
            });
    };
    $("#detailedReportGrid").jqGrid({
        url : url + "reports/getReportsOfCellphones",
        datatype : "local",
        mtype: "GET",
        jsonReader: { 
            id:"CellPhoneId",
            repeatitems: false,
            root: function (obj) { return obj; } 
        },
        rowNum: 10,
        rowList: [10,20,30],
        caption: "Celulares en Reporte",
        colNames:['Cel.','Marca','Color','Descripción','Codigo','MovementId','Codigo'],
        colModel:[
            {name:'CellPhoneId',index:'CellPhoneId', align:"center"},
            {name:'BrandName',index:'BrandName',align:"left"},
            {name:'ColorName',index:'ColorName',align:"left" },
            {name:'Description',index:'Description',align:"left"},
            {name:'BarCode',index:'BarCode',align:"center", hidden:true/*, formatter:barcodeFormatter*/},
            {name:'MovementId',index:'MovementId', sortable:false, hidden:true},
            {name:'opts2', index: 'opts2', align: 'center', sortable: false, formatter: 'actions',
             formatoptions: { delbutton: false, editbutton: false} }
        ],
        pager: "#detailedReportGridPager",
        viewrecords: true,
        gridview: true,
        hidegrid:true,
        altRows: true,
        shrinkToFit:true,
        autowidth: false,
        multiselect:true,
        height: '100px',
        loadComplete: detailedReportLoadComplete
    });
    
    detailed.jqGrid('navGrid','#detailedReportGridPager',{edit:false,del:false,search:false,refresh:false,add:false});
    detailed.jqGrid('navButtonAdd', '#detailedReportGridPager',{ 
        caption: "PDF",
        buttonicon: "ui-icon-bookmark",
        onClickButton: generatePDF, position: "last"
    });
    detailed.jqGrid("setLabel","BrandName","",{"text-align":"left"});
    detailed.jqGrid("setLabel","ColorName","",{"text-align":"left"});
    detailed.jqGrid("setLabel","Description","",{"text-align":"left"});
    detailed.jqGrid("setLabel","BarCode","",{"text-align":"left"});
    
    function generatePDF(){
        window.open(url+'reports/printFile?report_id=' + $("#hdReportId").val(), '_blank');
    }

    function barcodeFormatter(cellvalue, options, rowObject){
        //alert(options.rowId+""+options.colModel.name);
        return $(rowObject.BarCode).barcode(cellvalue, "ean13", settings);
    }

        
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