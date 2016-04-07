$(function() {
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
    $("input[type='password'][id$='NamePassword']").focus(function() {
        $(this).removeAttr('readonly');
    }).blur(function(){
        $(this).attr('readonly','readonly');
    });
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
});