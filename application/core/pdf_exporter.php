<?php
require APP . 'libs/fpdf/fpdf.php';

class PDFExporter extends FPDF{
    
    public function __construct($header, $details){
        
    }

    function Header(){
        $this->Image('./img/logo.png',10,8,33);
        $this->SetFont('Arial','B',15);
        $this->Cell(80);
        $this->Cell(30,10,'Title',1,0,'C');
        $this->Ln(20);
    }

    function Footer(){
        $this->SetY(-15);
        $this->SetFont('Arial','I',8);
        $this->Cell(0,10,'Página '.$this->PageNo().'/{nb}',0,0,'C');
    }
    
    public function createFile(){
        $pdf = new FPDF();
        $pdf->AddPage();
        $pdf->SetTitle('REPORTE DEL GRID');
        
        //Set font and colors
        $pdf->SetFont('Arial','B',12);
        $pdf->SetFillColor(255,0,0);
        $pdf->SetTextColor(255);
        $pdf->SetDrawColor(128,0,0);
        $pdf->SetLineWidth(.3);
        $pdf->SetTextColor(255);
        
        //$pdf->Cell(50,10,'Prevención:'.$header->PreventerName,1,0,'L',1);
        //$pdf->Cell(50,10,'Electrónica:'.$header->ElectronicAssociateName,1,0,'L',1);
        //$pdf->Cell(50,10,'Telefonía:'.$header->ExternalSellerName,1,0,'L',1);
        
        //Table header
        $pdf->Cell(200,5,'REPORTE GENERAL',0,1,'C',0);	
        $pdf->SetTextColor(255);
        $pdf->Cell(180,5,'',0,1,'C',0);	
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
            $pdf->Cell(25,10,$row->CellPhoneId,1,0,'R',$fill);  
            $pdf->Cell(35,10,$row->CompanyName,1,0,'L',$fill);
        	$pdf->Cell(35,10,$row->BrandName,1,0,'L',$fill);
        	$pdf->Cell(35,10,$row->ColorName,1,0,'L',$fill);
        	$pdf->Cell(35,10,$row->Description,1,0,'L',$fill);
            $pdf->Cell(25,10,$row->BarCode,1,1,'L',$fill);
            $fill=!$fill;
        }

        $pdf->SetFillColor(224,235);
        $pdf->SetFont('Arial','B',8);
        $pdf->SetXY(5,12);
       
        return $pdf->Output();
    }
        
}