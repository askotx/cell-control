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
        require APP . 'libs/fpdf/fpdf.php';
        if (!isset($_GET['report_id']) || !is_numeric($_GET['report_id'])){
            echo "Reporte no definido.";
            return;
        }
         
        $reportId = $_GET['report_id'];
        $output = new stdClass();
        
        $header = $this->report->getReport($reportId); 
        $details = $this->report->getReportsOfCellphones($reportId);
        //return $this->createPDF($output);
        $pdf = new FPDF();
        $pdf->AddPage();
        $pdf->SetTitle('REPORTE DEL GRID');
        
        //Set font and colors
        $pdf->SetFont('Arial','B',12);
        $pdf->SetFillColor(8,114,186);
        $pdf->SetTextColor(255);
        $pdf->SetDrawColor(0,0,80);
        $pdf->SetLineWidth(.3);
        $pdf->SetTextColor(255);
        
        $pdf->Image('./assets/img/logo.png',null,null,33);
        $pdf->Cell(180,5,'',0,1,'C',0);
        $pdf->Cell(30,10,'Prevención: ',1,0,'L',1); $pdf->Cell(60,10,$header->PreventerName,1,1,'L',1);
        $pdf->Cell(30,10,'Electrónica: ',1,0,'L',1); $pdf->Cell(60,10,$header->ElectronicAssociateName,1,1,'L',1);
        $pdf->Cell(30,10,'Telefonía: ',1,0,'L',1); $pdf->Cell(60,10,$header->ExternalSellerName,1,1,'L',1);
        
        //Table header
        $pdf->Cell(180,5,'',0,1,'C',0);
        $pdf->SetTextColor(0);
        $pdf->Cell(190,10,'REPORTE GENERAL',0,2,'C',0);	
        $pdf->SetTextColor(255);
        //$pdf->Cell(180,5,'',0,1,'C',0);	
        $pdf->Cell(25,10,'Id',1,0,'L',1);
        $pdf->Cell(35,10,'Compañía',1,0,'L',1);
        $pdf->Cell(35,10,'Marca',1,0,'L',1);
        $pdf->Cell(35,10,'Color',1,0,'L',1);
        $pdf->Cell(35,10,'Descripción',1,0,'L',1);
        $pdf->Cell(25,10,'Código',1,1,'L',1);
        
        //Restore font and colors
        $pdf->SetFont('Arial','',10);
        $pdf->SetFillColor(224,235,255);
        $pdf->SetTextColor(0);

        //Build table
        $fill=false;
        $i=0;
        
        foreach($details as $row){
            $pdf->Cell(25,10,$row->CellPhoneId,1,0,'C',$fill);  
            $pdf->Cell(35,10,$row->CompanyName,1,0,'L',$fill);
        	$pdf->Cell(35,10,$row->BrandName,1,0,'L',$fill);
        	$pdf->Cell(35,10,$row->ColorName,1,0,'L',$fill);
        	$pdf->Cell(35,10,$row->Description,1,0,'L',$fill);
            $pdf->Cell(25,10,$row->BarCode,1,1,'L',$fill);
            $fill=!$fill;
        }
       
        return $pdf->Output();
    }
}