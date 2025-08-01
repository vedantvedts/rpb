package com.vts.rpb.utils;

import java.io.File;

import org.springframework.stereotype.Component;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfPage;
import com.itextpdf.kernel.pdf.PdfReader;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.canvas.PdfCanvas;
import com.itextpdf.kernel.pdf.extgstate.PdfExtGState;
import com.itextpdf.layout.Canvas;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.property.TextAlignment;
import com.itextpdf.layout.property.VerticalAlignment;

@Component 
public class IbasFileUtils {

	public void addWatermarktoPdf(String pdffilepath,String newfilepath,String Draft) throws Exception
	{
		File pdffile = new File(pdffilepath);
		File tofile = new File(newfilepath);
		
		try (PdfDocument doc = new PdfDocument(new PdfReader(pdffile), new PdfWriter(tofile))) {
		    PdfFont helvetica = PdfFontFactory.createFont(StandardFonts.TIMES_ROMAN);
		    for (int pageNum = 1; pageNum <= doc.getNumberOfPages(); pageNum++) {
		        PdfPage page = doc.getPage(pageNum);
		        PdfCanvas canvas = new PdfCanvas(page.newContentStreamBefore(), page.getResources(), doc);
	
		        PdfExtGState gstate = new PdfExtGState();
		        gstate.setFillOpacity(.05f);
		        canvas = new PdfCanvas(page);
		        canvas.saveState();
		        canvas.setExtGState(gstate);
		        try (Canvas canvas2 = new Canvas(canvas,  page.getPageSize())) {
		            double rotationDeg = 50d;
		            double rotationRad = Math.toRadians(rotationDeg);
		            Paragraph watermark = new Paragraph(Draft.toUpperCase())
		                    .setFont(helvetica)
		                    .setFontSize(150f)
		                    .setTextAlignment(TextAlignment.CENTER)
		                    .setVerticalAlignment(VerticalAlignment.MIDDLE)
		                    .setRotationAngle(rotationRad)
		                    .setFixedPosition(200, 110, page.getPageSize().getWidth());
		            canvas2.add(watermark);
		        }
		        canvas.restoreState();
		    }
		 }
		
		pdffile.delete();
		tofile.renameTo(pdffile);
		
	}
	
	
	public File addWatermarktoPdf1(String pdffilepath,String newfilepath,String Draft) throws Exception
	{
		File pdffile = new File(pdffilepath);
		File tofile = new File(newfilepath);
		
		try (PdfDocument doc = new PdfDocument(new PdfReader(pdffile), new PdfWriter(tofile))) {
		    PdfFont helvetica = PdfFontFactory.createFont(StandardFonts.TIMES_ROMAN);
		    for (int pageNum = 1; pageNum <= doc.getNumberOfPages(); pageNum++) {
		        PdfPage page = doc.getPage(pageNum);
		        PdfCanvas canvas = new PdfCanvas(page.newContentStreamBefore(), page.getResources(), doc);
	
		        PdfExtGState gstate = new PdfExtGState();
		        gstate.setFillOpacity(.05f);
		        canvas = new PdfCanvas(page);
		        canvas.saveState();
		        canvas.setExtGState(gstate);
		        try (Canvas canvas2 = new Canvas(canvas,  page.getPageSize())) {
		            double rotationDeg = 50d;
		            double rotationRad = Math.toRadians(rotationDeg);
		           
		            Paragraph watermark = new Paragraph(Draft.toUpperCase())
		                    .setFont(helvetica)
		                    .setFontSize(200f)
		                    .setPaddings(200, 200,200, 200)
		                    .setRotationAngle(rotationRad)
		                    .setFixedPosition(90, 90, page.getPageSize().getWidth());
		            
		            		
		            canvas2.add(watermark);
		        }
		     
		        canvas.restoreState();
		    }
		 }
		
		return tofile;
		//pdffile.delete();
		//tofile.renameTo(pdffile);
		
	}
	
	public void addWatermarktoPdf2(String pdffilepath,String newfilepath,String Draft) throws Exception
	{
		File pdffile = new File(pdffilepath);
		File tofile = new File(newfilepath);
		
		try (PdfDocument doc = new PdfDocument(new PdfReader(pdffile), new PdfWriter(tofile))) {
		    PdfFont helvetica = PdfFontFactory.createFont(StandardFonts.TIMES_ROMAN);
		    for (int pageNum = 1; pageNum <= doc.getNumberOfPages(); pageNum++) {
		        PdfPage page = doc.getPage(pageNum);
		        PdfCanvas canvas = new PdfCanvas(page.newContentStreamBefore(), page.getResources(), doc);
	
		        PdfExtGState gstate = new PdfExtGState();
		        gstate.setFillOpacity(.05f);
		        canvas = new PdfCanvas(page);
		        canvas.saveState();
		        canvas.setExtGState(gstate);
		        try (Canvas canvas2 = new Canvas(canvas,  page.getPageSize())) {
		            double rotationDeg = 50d;
		            double rotationRad = Math.toRadians(rotationDeg);
		            Paragraph watermark = new Paragraph(Draft.toUpperCase())
		                    .setFont(helvetica)
		                    .setFontSize(150f)
		                    .setPaddings(100, 20,100, 20)
		                    .setRotationAngle(rotationRad)
		                    .setFixedPosition(400, 110, page.getPageSize().getWidth());
		            canvas2.add(watermark);
		        }
		        canvas.restoreState();
		    }
		 }
		
		pdffile.delete();
		tofile.renameTo(pdffile);
		
	}
	
	
	public File addRepeatedWatermarktoPdf(String pdffilepath,String newfilepath,String WaterMarkText) throws Exception
	{
		File pdffile = new File(pdffilepath);
		File tofile = new File(newfilepath);
		
		String WMText = "";
        for(int i=1;i<=25;i++)
        {
     	   WMText = WMText+WaterMarkText+" ";
     	  
        }

        String WMTextLine=WMText;
        WMTextLine +="\n";
        WMTextLine +="\n";
        WMTextLine += WMText;
        
		try (PdfDocument doc = new PdfDocument(new PdfReader(pdffile), new PdfWriter(tofile))) {
		    PdfFont helvetica = PdfFontFactory.createFont(StandardFonts.TIMES_ROMAN);
		    for (int pageNum = 1; pageNum <= doc.getNumberOfPages(); pageNum++) {
		        PdfPage page = doc.getPage(pageNum);
		        PdfCanvas canvas = new PdfCanvas(page.newContentStreamBefore(), page.getResources(), doc);
	
		        PdfExtGState gstate = new PdfExtGState();
		        gstate.setFillOpacity(.25f);
		        canvas = new PdfCanvas(page);
		        canvas.saveState();
		        canvas.setExtGState(gstate);
		        try (Canvas canvas2 = new Canvas(canvas,  page.getPageSize())) {
			        Paragraph watermark = new Paragraph(WMTextLine)
			                   .setFont(helvetica)
			                   .setFontSize(10)
			                   .setPaddings(10, 10,10, 10);
		            
		      
			        Rectangle pageSize = page.getPageSize();
			        float x=420;
			        float y=297.5f;
			        float rotationRad = (float) Math.toRadians(53);
			        canvas2.showTextAligned(watermark, pageSize.getLeft()+20,20, pageNum, TextAlignment.LEFT, VerticalAlignment.MIDDLE , rotationRad);
			        rotationRad = (float) Math.toRadians(-51);
			        canvas2.showTextAligned(watermark, x, y, pageNum, TextAlignment.CENTER, VerticalAlignment.MIDDLE , rotationRad);

		        }
		     
		        canvas.restoreState();
		    }
		 }catch (Exception e)
		{
			 e.printStackTrace();
		}
		
		return tofile;
		//pdffile.delete();
		//tofile.renameTo(pdffile);
		
	}
	
}
