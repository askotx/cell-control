<div class="container" id="layout">
    <div class="row">
        <div class="col-xs-2">
            Compa&ntilde;&iacute;a: 
            <input id="txCompany" type="text" class="ui-autocomplete-input" autocomplete="off"/>
            <input id="idCompany" type="hidden" />
        </div>
        <div class="col-xs-2">
            Marca: 
            <input id="txModel" type="text" class="ui-autocomplete-input" autocomplete="off"/>
            <input id="idModel" type="hidden" />
        </div>
        <div class="col-xs-2">
            Codigo: <input id="txBarcode" type="text" class="ui-input" autocomplete="off"/>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-2">
            Color: 
            <input id="txColor" type="text" class="ui-autocomplete-input" autocomplete="off"/>
            <input id="idColor" type="hidden" />
        </div>
        <div class="col-xs-3">
            Existencia: 
            <select id="cbExistence" class="form-control">
                <option value="-1" >Todos</option>
                <option value="1" >Disponibles</option>
                <option value="2">Vendidos</option>
                <option value="3">Desaparecidos</option>
            </select>
        </div>
        <div class="col-xs-3">
            <br />
            <button id="btnSearch" class="ui-button-primary">Filtrar</button>
            <button id="btnAdd" class="ui-button-success">Agregar Reporte</button>
        </div>
    </div>
    <br />
    <div class="row-fluid">
        <table id="demoGrid"></table>
        <div id="gridPager"></div>
    </div>
</div>
<!--static dialog-->
<div id="modal-message" title="Reporte Detallado" style="overflow-x: hidden;display: none;">
    <form autocomplete="nope">
    <fieldset>
      <div class="form-group row">
        <label for="txPreventerName" class="col-sm-2 form-control-label">Prevención</label>
        <div class="col-sm-4">
          <input type="text" class="form-control" id="txPreventerName" placeholder="" autocomplete="nope"/>
          <input type="hidden" id="hdPreventerId" />
          <input type="password" class="form-control" id="txPreventerNamePassword" autocomplete="false" readonly onfocus="this.removeAttribute('readonly');" onblur="this.setAttribute('readonly','readonly');"/>
        </div>
      </div>
      <div class="form-group row">
        <label for="txAssociatedName" class="col-sm-2 form-control-label">Electrónica</label>
        <div class="col-sm-4">
          <input type="text" class="form-control" id="txAssociatedName" placeholder="" />
          <input type="password" class="form-control" id="txAssociatedNamePassword" placeholder="" autocomplete="false" readonly onfocus="this.removeAttribute('readonly');" onblur="this.setAttribute('readonly','readonly');"/>
        </div>
      </div>
      <div class="form-group row">
        <label for="txExternalSeller" class="col-sm-2 form-control-label">Telefonía</label>
        <div class="col-sm-4">
          <input type="text" class="form-control" id="txExternalSeller" placeholder=""/>
        </div>
      </div>
    </fieldset>      
      <div class="form-group row" style="margin-left: 10px;">
        <table id="detailedReportGrid"></table>
        <div id="detailedReportGridPager"></div>
      </div>
    </form>
    <input type="hidden" id="hdReportId"  value="0"/>
</div>
<!--end static dialog-->