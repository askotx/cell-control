<?php
require APP . 'libs/fpdf/ean13.php';

class CellReporterPDF{
    
    protected $header;
    protected $details;
    
    public function __construct($header, $details){
        $this->header = $header;       
        $this->details = $details;
    }
    
    public function CreateReportPDF(){
  
        $pdf = new PDF_EAN13();
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
        $pdf->Cell(30,10,'Prevención: ',1,0,'L',1); $pdf->Cell(60,10,$this->header->PreventerName,1,1,'L',1);
        $pdf->Cell(30,10,'Electrónica: ',1,0,'L',1); $pdf->Cell(60,10,$this->header->ElectronicAssociateName,1,1,'L',1);
        $pdf->Cell(30,10,'Telefonía: ',1,0,'L',1); $pdf->Cell(60,10,$this->header->ExternalSellerName,1,1,'L',1);
        
        //Table header
        $pdf->Cell(180,5,'',0,1,'C',0);
        $pdf->SetTextColor(0);
        $pdf->Cell(190,10,'REPORTE GENERAL',0,2,'C',0);	
        $pdf->SetTextColor(255);
        //$pdf->Cell(180,5,'',0,1,'C',0);	
        $pdf->Cell(25,12,'Id',1,0,'L',1);
        $pdf->Cell(35,12,'Compañía',1,0,'L',1);
        $pdf->Cell(35,12,'Marca',1,0,'L',1);
        $pdf->Cell(35,12,'Color',1,0,'L',1);
        $pdf->Cell(35,12,'Descripción',1,0,'L',1);
        $pdf->Cell(30,12,'Código',1,1,'L',1);
        
        //Restore font and colors
        $pdf->SetFont('Arial','',10);
        $pdf->SetFillColor(224,235,255);
        $pdf->SetTextColor(0);

        //Build table
        $fill=false;
        
        $pdf->textSize = 7;
        $y=82;
        foreach($this->details as $row){
            $pdf->Cell(25,12,$row->CellPhoneId,1,0,'C',$fill);  
            $pdf->Cell(35,12,$row->CompanyName,1,0,'L',$fill);
        	$pdf->Cell(35,12,$row->BrandName,1,0,'L',$fill);
        	$pdf->Cell(35,12,$row->ColorName,1,0,'L',$fill);
        	$pdf->Cell(35,12,$row->Description,1,0,'L',$fill);
            $pdf->Cell(30,12,"",1,1,'L',$fill);
            $pdf->SetFillColor(0);
            $pdf->EAN13(178,$y,$row->BarCode,5,'.25');            
            $y+=12;
            $pdf->SetFont('Arial','',10);
            $pdf->SetFillColor(224,235,255);
            $fill=!$fill;
        }
        return $pdf->Output();
    }
}