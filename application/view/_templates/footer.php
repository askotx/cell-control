    <!-- jQuery, loaded in the recommended protocol-less way -->
    <!-- more http://www.paulirish.com/2010/the-protocol-relative-url/ -->
        
    <!-- Placed at the end of the document so the pages load faster -->
    <!--
    <script src="<?php echo URL; ?>assets/js/vendor/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<?php echo URL; ?>assets/js/vendor/jquery-1.11.1.min.js" type="text/javascript"></script>
    -->
    <script src="<?php echo URL; ?>assets/js/vendor/jquery-2.2.2.min.js" type="text/javascript"></script>
    <script src="<?php echo URL; ?>assets/js/vendor/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>
    <script src="<?php echo URL; ?>assets/js/vendor/bootstrap.js" type="text/javascript"></script>
    <script src="<?php echo URL; ?>assets/js/vendor/holder.js" type="text/javascript"></script>
    <script src="<?php echo URL; ?>assets/js/vendor/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
    
    <script src="<?php echo URL; ?>assets/jqGrid/js/i18n/grid.locale-es.js"></script>
    <script type="text/javascript">
        $.jgrid.no_legacy_api = true;
        $.jgrid.useJSON = true;
    </script>
    <script src="<?php echo URL; ?>assets/jqGrid/js/jquery.jqGrid-4.7.0.min.js"></script>

    <script src="<?php echo URL; ?>assets/js/vendor/jquery-barcode-2.0.3.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("button,.button,#sampleButton").button();
        });
   </script>
    <!-- define the project's URL (to make AJAX calls possible, even when using this in sub-folders etc) -->
    <script>
        var url = "<?php echo URL; ?>";
    </script>

    <!-- our JavaScript -->
    <script src="<?php echo URL; ?>js/application.js"></script>
    <script src="<?php echo URL; ?>js/reports.js"></script>
    <script src="<?php echo URL; ?>js/reports/report_cell_detailed.js"></script>
    <script src="<?php echo URL; ?>js/get_contacts.js"></script>
</body>
</html>
