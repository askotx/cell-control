<?php

class Reports extends Controller{
    
    public function index(){
        require APP . 'view/_templates/header.php';
        require APP . 'view/reports/index.php';
        require APP . 'view/_templates/footer.php';
    }
    
    public function getAllReports(){
        header('Content-Type: application/json');
        echo json_encode($this->report->getReports($_GET['page'], $_GET['rows'], $_GET['sidx'], $_GET['sord']), JSON_PRETTY_PRINT);        
    }
    
    public function getReportsOfCellphones(){
        header('Content-Type: application/json');
        echo json_encode($this->report->getReportsOfCellphones($_GET['report_id']), JSON_PRETTY_PRINT);        
    }
    public function getContactsByTerm(){
        header('Content-Type: application/json');
        echo json_encode($this->report->getContactsByTerm($_GET['term'], $_GET['userType']),JSON_PRETTY_PRINT);
    }
    public function printFile(){        
        
        require APP . 'view/_templates/report_pdf.php';
        
        if (!isset($_GET['report_id']) || !is_numeric($_GET['report_id'])){
            echo "Reporte no definido.";
            return;
        }
         
        $reportId = $_GET['report_id'];
        
        $header = $this->report->getReport($reportId); 
        $details = $this->report->getReportsOfCellphones($reportId);
        
        $pdfDocument = new CellReporterPDF($header,$details);
        
        return $pdfDocument->CreateReportPDF();
    }
}