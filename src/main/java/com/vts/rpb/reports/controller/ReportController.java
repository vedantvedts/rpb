package com.vts.rpb.reports.controller;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itextpdf.html2pdf.HtmlConverter;
import com.vts.rpb.fundapproval.service.FundApprovalService;
import com.vts.rpb.master.service.MasterService;
import com.vts.rpb.reports.service.ReportService;
import com.vts.rpb.utils.CharArrayWriterResponse;
import com.vts.rpb.utils.DateTimeFormatUtil;
import com.vts.rpb.utils.LabLogo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class ReportController 
{
	private static final Logger logger = LogManager.getLogger(ReportController.class);
	
	@Autowired
	MasterService masterService;
	
	@Autowired
	ReportService reportService;
	
	@Autowired
	FundApprovalService fundApprovalService;
	
	@Autowired
	LabLogo labLogo;
	
	@RequestMapping(value="estimateTypeParticularDivList.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String estimateTypeParticularDivList(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		String loginType= (String)ses.getAttribute("LoginType");
		String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
		logger.info(new Date() + "Inside EditFundRequest.htm " + UserName);
		try
		{
			String divisionId=req.getParameter("divisionId");
			String estimateType=req.getParameter("estimateType");
			String FromYear=req.getParameter("FromYear");
			String ToYear=req.getParameter("ToYear");
			String status=req.getParameter("approvalStatus");
			String budget=req.getParameter("selBudget");
			String proposedProject=req.getParameter("selProposedProject");
			String budgetHeadId=req.getParameter("budgetHeadId");
			String budgetItemId=req.getParameter("budgetItemId");
			String fromCost=req.getParameter("FromCost");
			String toCost=req.getParameter("ToCost");
			String amountFormat = req.getParameter("AmountFormat");
			int RupeeValue=0;
			
			if(divisionId == null) {
				return "redirect:/MainDashBoard.htm";
			}
			
			Object[] divisionDetails = masterService.getDivisionDetails(divisionId);
			if(divisionDetails != null)
			{
				req.setAttribute("divisionDetails",divisionDetails);
			}
			
			String memberType=fundApprovalService.getCommitteeMemberType(Long.valueOf(empId));
			
			String FinYear=null;
			if(FromYear==null || ToYear==null) 
			{
				FinYear=DateTimeFormatUtil.getCurrentFinancialYear();
				FromYear=FinYear.split("-")[0];
				ToYear=FinYear.split("-")[1];
			}
			else
			{
				FinYear=FromYear+"-"+ToYear;
			}
			
			if(budget == null) {
				budget = "-1";  // B - General, N - Proposed Project
			}
			
			if(budgetHeadId==null) {
				budgetHeadId="0";
			}
			
			if(budgetItemId==null) {
				budgetItemId="0";
			}
			
			if(fromCost==null) {
				fromCost="0";
			}
			
			if(toCost==null) {
				toCost="100000000";
			}
			
			if(status==null) {
				status="NA";
			}
			
			if(Long.valueOf(budgetHeadId)==0) {
				budgetItemId="0";
			}
			 
			if (amountFormat == null || amountFormat.isEmpty()) {
			    if ("A".equalsIgnoreCase(loginType) 
			        || "CS".equalsIgnoreCase(memberType) 
			        || "CC".equalsIgnoreCase(memberType)) {
			        amountFormat = "L"; // Lakhs
			    } else {
			        amountFormat = "R"; // Rupees (default for normal users)
			    }
			}
		    
		    if(amountFormat.equalsIgnoreCase("L")) {
		    	 RupeeValue = 100000;
		    }
		    else if (amountFormat.equalsIgnoreCase("R")) {
		    	RupeeValue = 1;
			}
		    else if (amountFormat.equalsIgnoreCase("C")) {
		    	RupeeValue = 10000000;
			}
		    
		    
		    
			List<Object[]> estimateTypeParticularDivList=reportService.estimateTypeParticularDivList(divisionId, estimateType,FinYear,loginType,empId, budget, proposedProject, budgetHeadId,budgetItemId,fromCost,toCost,status,memberType,RupeeValue);
			
			req.setAttribute("attachList",estimateTypeParticularDivList);
			req.setAttribute("Existingbudget", budget);
			req.setAttribute("ExistingProposedProject", proposedProject);
			req.setAttribute("ExistingbudgetHeadId", budgetHeadId);
			req.setAttribute("ExistingbudgetItemId", budgetItemId);
			req.setAttribute("ExistingfromCost", fromCost);
			req.setAttribute("ExistingtoCost", toCost);
			req.setAttribute("Existingstatus", status);
			req.setAttribute("divisionId", divisionId);
			req.setAttribute("estimateType", estimateType);
			req.setAttribute("FinYear", FinYear);
			req.setAttribute("FromYear", FromYear);
			req.setAttribute("ToYear", ToYear);
			req.setAttribute("amountFormat", amountFormat);
			req.setAttribute("MemberType", memberType);
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside estimateTypeParticularDivList.htm " + UserName, e);
			return "static/error";
		}
		return "fundapproval/ParticularDivTypeReportList";
		
	}
	
	
	@RequestMapping(value="estimateTypeParticularDivPrint.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String estimateTypeParticularDivPrint(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside FundReportPrint.htm " + UserName);
		String labCode = (ses.getAttribute("client_name")).toString();
		String loginType= (String)ses.getAttribute("LoginType");
		String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
		try
		{	
			String PrintAction= req.getParameter("PrintAction");
			String divisionId=req.getParameter("divisionId");
			String estimateType=req.getParameter("estimateType");
			String FromYear=req.getParameter("FromYear");
			String ToYear=req.getParameter("ToYear");
			String status=req.getParameter("approvalStatus");
			String budget=req.getParameter("selBudget");
			String proposedProject=req.getParameter("selProposedProject");
			String budgetHeadId=req.getParameter("budgetHeadId");
			String budgetItemId=req.getParameter("budgetItemId");
			String fromCost=req.getParameter("FromCost");
			String toCost=req.getParameter("ToCost");
			String amountFormat = req.getParameter("AmountFormat");
			int RupeeValue=0;
			
			String memberType=fundApprovalService.getCommitteeMemberType(Long.valueOf(empId));
			
			String FinYear=null;
			if(FromYear==null || ToYear==null) 
			{
				FinYear=DateTimeFormatUtil.getCurrentFinancialYear();
				FromYear=FinYear.split("-")[0];
				ToYear=FinYear.split("-")[1];
			}
			else
			{
				FinYear=FromYear+"-"+ToYear;
			}
			
			if(budgetHeadId==null) {
				budgetHeadId="0";
			}
			
			if(budgetItemId==null) {
				budgetItemId="0";
			}
			
			if(fromCost==null) {
				fromCost="0";
			}
			
			if(toCost==null) {
				toCost="100000000";
			}
			
			if(status==null) {
				status="N";
			}
			
			if(Long.valueOf(budgetHeadId)==0) {
				budgetItemId="0";
			}
			
			List<Object[]> labInfoList=masterService.GetLabInfo(labCode);
		    String labName = null;
		    
		    for(Object[] obj : labInfoList) {
			     labName = String.valueOf(obj[1].toString());
		    }   
		    
		    if (amountFormat == null || amountFormat.isEmpty()) {
			    if ("A".equalsIgnoreCase(loginType) 
			        || "CC".equalsIgnoreCase(memberType) 
			        || "CS".equalsIgnoreCase(memberType)) {
			        amountFormat = "L"; // Lakhs
			    } else {
			        amountFormat = "R"; // Rupees (default for normal users)
			    }
			}
		    
		    if(amountFormat.equalsIgnoreCase("L")) {
		    	 RupeeValue = 100000;
		    }
		    else if (amountFormat.equalsIgnoreCase("R")) {
		    	RupeeValue = 1;
			}
		    else if (amountFormat.equalsIgnoreCase("C")) {
		    	RupeeValue = 10000000;
			}
			
			List<Object[]> estimateTypeParticularDivList=fundApprovalService.estimateTypeParticularDivList(Long.valueOf(divisionId), estimateType,FinYear,loginType,empId, budget, proposedProject, budgetHeadId,budgetItemId,fromCost,toCost,status,memberType,RupeeValue);
			
			req.setAttribute("attachList",estimateTypeParticularDivList);
			req.setAttribute("ExistingbudgetHeadId", budgetHeadId);
			req.setAttribute("ExistingbudgetItemId", budgetItemId);
			req.setAttribute("ExistingfromCost", fromCost);
			req.setAttribute("ExistingtoCost", toCost);
			req.setAttribute("Existingstatus", status);
			req.setAttribute("divisionId", divisionId);
			req.setAttribute("estimateType", estimateType);
			req.setAttribute("FinYear", FinYear);
			req.setAttribute("FromYear", FromYear);
			req.setAttribute("ToYear", ToYear);
			req.setAttribute("labName", labName);
		    req.setAttribute("LabLogo", labLogo.getLabLogoAsBase64());
		    req.setAttribute("amountFormat", amountFormat);
			req.setAttribute("MemberType", memberType);
			
			if("pdf".equalsIgnoreCase(PrintAction)) {
				
				
				String filename="RPB Fund Report";
				String path=req.getServletContext().getRealPath("/view/temp");
		       
		        CharArrayWriterResponse customResponse = new CharArrayWriterResponse(resp);
				req.getRequestDispatcher("/view/fundapproval/ParticularDivTypeReportListPrint.jsp").forward(req, customResponse);
				String html = customResponse.getOutput();        
				
		        HtmlConverter.convertToPdf(html,new FileOutputStream(path+File.separator+filename+".pdf")) ; 
		        resp.setContentType("application/pdf");
		        resp.setHeader("Content-disposition","inline;filename="+filename+".pdf");
		      
		        File f=new File(path +File.separator+ filename+".pdf");
		        FileInputStream fis = new FileInputStream(f);
		        DataOutputStream os = new DataOutputStream(resp.getOutputStream());
		        resp.setHeader("Content-Length",String.valueOf(f.length()));
		        byte[] buffer = new byte[1024];
		        int len = 0;
		        while ((len = fis.read(buffer)) >= 0) {
		            os.write(buffer, 0, len);
		        } 
		        os.close(); 
		        fis.close();
		        Path pathOfFile= Paths.get( path+File.separator+filename+".pdf"); 
		        Files.delete(pathOfFile);
			}
			else if("Excel".equalsIgnoreCase(PrintAction))
			{
				return "fundapproval/ParticularDivTypeReportListPrint";
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside estimateTypeParticularDivPrint.htm " + UserName, e);
			return "static/error";
		}
		return "fundapproval/fundReportListPrint";
		
	}
	
	
}
