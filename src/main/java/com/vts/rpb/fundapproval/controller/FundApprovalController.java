package com.vts.rpb.fundapproval.controller;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.itextpdf.html2pdf.HtmlConverter;
import com.vts.rpb.fundapproval.dto.BudgetDetails;
import com.vts.rpb.fundapproval.dto.FundApprovalAttachDto;
import com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto;
import com.vts.rpb.fundapproval.dto.FundApprovalDto;
import com.vts.rpb.fundapproval.dto.FundRequestCOGDetails;
import com.vts.rpb.fundapproval.service.FundApprovalService;
import com.vts.rpb.master.service.MasterService;
import com.vts.rpb.utils.CharArrayWriterResponse;
import com.vts.rpb.utils.DateTimeFormatUtil;
import com.vts.rpb.utils.LabLogo;
import com.vts.rpb.fundapproval.modal.FundApproval;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class FundApprovalController 
{
	private static final Logger logger = LogManager.getLogger(FundApprovalController.class);
	
	@Autowired
	FundApprovalService fundApprovalService;
    
    @Autowired
	MasterService masterService;
    
    @Value("${Attach_File_Size}")
	String attach_file_size;
    
    @Value("${ApplicationFilesDrive}")
	String uploadpath;
    
    @Autowired
	LabLogo labLogo;
	
	// Fund Approval Module
	@RequestMapping(value="FundRequest.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String FundApproval(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + " Inside FundApproval.htm " + UserName);
		String labCode = (ses.getAttribute("client_name")).toString();
		String loginType= (String)ses.getAttribute("LoginType");
		String empDivisionCode= (String)ses.getAttribute("EmployeeDivisionCode");
		String empDivisionName= (String)ses.getAttribute("EmployeeDivisionName");
		String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
		String divisionId = ((Long) ses.getAttribute("Division")).toString();
		try
		{
			String FromYear=req.getParameter("FromYear");
			String ToYear=req.getParameter("ToYear");
			String DivisionDetails=req.getParameter("DivisionDetails");
			String estimateType=req.getParameter("EstimateType");
			
			if(estimateType==null)
			{
				estimateType="R";
			}
			
			String DivisionId=null;
			if(DivisionDetails!=null)
			{
				DivisionId=DivisionDetails.split("#")[0];
			}
			else
			{
				if(loginType!=null && !loginType.equalsIgnoreCase("A"))
				{
					DivisionId=divisionId;
					DivisionDetails=divisionId+"#"+empDivisionCode+"#"+empDivisionName;
				}
				else
				{
					DivisionId="-1";
					DivisionDetails="-1#All#All";
				}
			}
			
			String projectId="0";
			
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
				
			List<Object[]> RequisitionList=fundApprovalService.getFundApprovalList(FinYear,DivisionId,estimateType,loginType,empId,projectId);
			List<Object[]> DivisionList=masterService.getDivisionList(labCode,empId,loginType);
			
			req.setAttribute("RequisitionList", RequisitionList);
			req.setAttribute("DivisionList", DivisionList);
			req.setAttribute("CurrentFinYear", DateTimeFormatUtil.getCurrentFinancialYear());
			
			//user selected different year Estimate type reset to RE
			 FundApprovalBackButtonDto backDto=new FundApprovalBackButtonDto();
			   backDto.setDivisionBackBtn(DivisionDetails);
			   backDto.setDivisionName(DivisionDetails.split("#")[2]);
			   backDto.setDivisionCode(DivisionDetails.split("#")[1]);
			   backDto.setFromYearBackBtn(FinYear.split("-")[0]);
			   backDto.setToYearBackBtn( FinYear.split("-")[1]);
			   backDto.setEstimatedTypeBackBtn(estimateType);
			   backDto.setDivisionId(DivisionId);
			   backDto.setREYear(FromYear+"-"+ToYear);
			   backDto.setFBEYear((Long.parseLong(FromYear)+1)+"-"+(Long.parseLong(ToYear)+1));
			   
			   ses.setAttribute("FundApprovalAttributes", backDto);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside RequisitionList.htm " + UserName, e);
			return "static/error";
		}
		return "fundapproval/fundRequestList";
		
	}
	
	@RequestMapping(value="FundApprovalList.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String fundApprovalList(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside FundApprovalList.htm " + UserName);
		String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
		String loginType= (String)ses.getAttribute("LoginType");
		long formRole= (long)ses.getAttribute("FormRole");
		try
		{
			String fromYear=req.getParameter("FromYear");
			String toYear=req.getParameter("ToYear");
			
				String finYear=null;
				if(fromYear==null || toYear==null) 
				{
					finYear=DateTimeFormatUtil.getCurrentFinancialYear();
					fromYear=finYear.split("-")[0];
					toYear=finYear.split("-")[1];
				}
				else
				{
					finYear=fromYear+"-"+toYear;
				}
				
			List<Object[]> approvalPendingList=fundApprovalService.getFundPendingList(empId,finYear,loginType,formRole);
			approvalPendingList.stream().forEach(a->System.err.println("approvalPendingList->"+Arrays.toString(a)));
			List<Object[]> approvedList= fundApprovalService.getFundApprovedList(empId,finYear,loginType);
			
			req.setAttribute("ApprovalPendingList",approvalPendingList);
			req.setAttribute("ApprovalList",approvedList);
			req.setAttribute("employeeCurrentStatus",fundApprovalService.getCommitteeMemberCurrentStatus(empId));
			req.setAttribute("FromYear",fromYear);
			req.setAttribute("ToYear",toYear);
			
		}catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date() + " Inside FundApprovalList.htm " + UserName, e);
			return "static/error";
		}
			
			return "fundapproval/fundApprovalList";
	}
	
	@RequestMapping(value = "FundApprovalPreview.htm" , method = {RequestMethod.GET,RequestMethod.POST})
	public String fundApprovalPreview(HttpServletRequest req, HttpServletResponse resp, HttpSession ses, RedirectAttributes redir)
	{
		String UserName = (String) ses.getAttribute("Username");
		long empId = (Long) ses.getAttribute("EmployeeId");
		logger.info(new Date() + "Inside FundApprovalPreview.htm " + UserName);
		try {
			
			String fundApprovalId=req.getParameter("FundApprovalIdSubmit");
			
			if(fundApprovalId!=null)
			{ 
				List<Object[]> fundDetails = fundApprovalService.getParticularFundApprovalDetails(fundApprovalId,empId);
						
				if(fundDetails!=null && fundDetails.size()>0)
				{
					req.setAttribute("fundDetails",fundDetails.get(0));
				}
			}
			
			return "fundapproval/fundApprovalPreview";
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date()+"Inside fundapprovaldApprovalPreview.htm"+ UserName, e);
			return "static/error";
			
		}
	}
	
	@RequestMapping(value="FundApprovalSubmit.htm", method = {RequestMethod.GET,RequestMethod.POST})
	public String fundApprovalSubmit(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		long empId = (Long) ses.getAttribute("EmployeeId");
		logger.info(new Date() + "Inside FundApprovalSubmit.htm " + UserName);
		String url=null;
		try
		{
			String fundApprovalId=req.getParameter("fundApprovalId");
			String action=req.getParameter("Action");
			String remarks=req.getParameter("remarks");
			if(fundApprovalId==null || action==null)
			{
				redir.addAttribute("resultFailure", "Something Went Wrong..!");
				return "redirect:/FundApprovalPreview.htm";
			}
			
			String actionMssg=action!=null && action.equalsIgnoreCase("A") ? "Approved" : "Recommended";
			
			FundApprovalDto fundDto=new FundApprovalDto();
			fundDto.setFundApprovalId(fundApprovalId!=null ? Long.parseLong(fundApprovalId) : 0);
			fundDto.setRemarks(remarks);
			fundDto.setAction(action);
			fundDto.setCreatedBy(UserName);
			
			long status=fundApprovalService.updateRecommendAndApprovalDetails(fundDto,empId); 
			
			if(status > 0) {
				redir.addAttribute("resultSuccess", "Fund Request "+actionMssg+" Successfully..!");
			}else {
				redir.addAttribute("resultFailure", "Fund Request Recommended Unsuccessful or Something Went Wrong..!");
			}
			
			url="redirect:/FundApprovalList.htm";
					
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside BudgetApprovalForward.htm " + UserName, e);
			return "static/error";
		}
		return url;
		
	}
	
	@RequestMapping(value="FundRequestCarryForward.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String fundRequestCarryForward(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		String labCode = (ses.getAttribute("client_name")).toString();
		logger.info(new Date() + "Inside fundRequestCarryForward.htm " + UserName);
		try
		{	
			FundApprovalBackButtonDto fundApprovalDto=(FundApprovalBackButtonDto) ses.getAttribute("FundApprovalAttributes");
			if(fundApprovalDto==null)
			{
				return "redirect:/FundRequest.htm";
			}
			
			String budgetHeadId=req.getParameter("budgetHeadId");
			String budgetItemId=req.getParameter("budgetItemId");
			
			if(budgetHeadId==null)
			{
				budgetHeadId="-1";
			}
			
			if(budgetItemId==null)
			{
				budgetItemId="-1";
			}
			
			fundApprovalDto.setBudgetHeadId(budgetHeadId!=null ? Long.parseLong(budgetHeadId) : 0);			
			fundApprovalDto.setBudgetItemId(budgetItemId!=null ? Long.parseLong(budgetItemId) : 0);			
			if(fundApprovalDto!=null)
			{
				List<Object[]> carryForwardList=fundApprovalService.getFundRequestCarryForwardDetails(fundApprovalDto,labCode);
				if(carryForwardList!=null && carryForwardList.size()>0)
				{
					req.setAttribute("carryForwardList", carryForwardList);
				}
			}
			
			req.setAttribute("budgetHeadId", budgetHeadId);
			req.setAttribute("budgetItemId", budgetItemId);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside fundRequestCarryForward.htm " + UserName, e);
			return "static/error";
		}
		return "fundapproval/fundCarryForward";
		
	}
	
	@RequestMapping(value="CarryForwardDetails.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String CarryForwardDetails(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside CarryForwardDetails.htm " + UserName);
		try
		{
			String[] demandItemOrderDetails=req.getParameterValues("DemandItemOrderDetails");
			FundApprovalBackButtonDto fundApprovalDto=(FundApprovalBackButtonDto) ses.getAttribute("FundApprovalAttributes");
			int stringLength=1;
			if(demandItemOrderDetails!=null) 
			{
				stringLength=demandItemOrderDetails.length;
			}
			String[] commitmentPayId = new String[stringLength],demandId=new String[stringLength],cfFundRequestId=new String[stringLength],itemNomenclature=new String[stringLength]
					,selectedFundRequestId=new String[stringLength],ItemAmount=new String[stringLength],aprilMonth=new String[stringLength],
					mayMonth=new String[stringLength],juneMonth=new String[stringLength],julyMonth=new String[stringLength],
					augustMonth=new String[stringLength],septemberMonth=new String[stringLength],octoberMonth=new String[stringLength],
					novemberMonth=new String[stringLength],decemberMonth=new String[stringLength],januaryMonth=new String[stringLength],
					februaryMonth=new String[stringLength],marchMonth=new String[stringLength],fundRequestSerialNo=new String[stringLength];
			
			FundRequestCOGDetails cogMonth=new FundRequestCOGDetails();
			if(demandItemOrderDetails.length>0)
			{
				for (int i=0;i<demandItemOrderDetails.length;i++)
				{
					if(demandItemOrderDetails[i]!=null)
					{
						String serialNo=demandItemOrderDetails[i];
						
						String[] commitPayIds=req.getParameterValues("CommitmentPayId-"+serialNo);
						if(commitPayIds!=null && commitPayIds.length>0)
						{
							String commitmentPayIdDetails = Arrays.stream(commitPayIds).map(id -> id.split("#")[0]).collect(Collectors.joining(","));
							commitmentPayId[i]=commitmentPayIdDetails;
						}
						
						String[] demandIds=req.getParameterValues("BookingId-"+serialNo);
						if(demandIds!=null && demandIds.length>0)
						{
							String demandDetails = Arrays.stream(demandIds).map(id -> id.split("#")[0]).collect(Collectors.joining(","));
							demandId[i]=demandDetails;
						}
						
						String[] fundApprovalIds=req.getParameterValues("FundRequestId-"+serialNo);
						if(fundApprovalIds!=null && fundApprovalIds.length>0)
						{
							String fundRequestDetails = Arrays.stream(fundApprovalIds).map(id -> id.split("#")[0]).collect(Collectors.joining(","));
							cfFundRequestId[i]=fundRequestDetails;
						}
						
						
						fundRequestSerialNo[i]=serialNo;
						selectedFundRequestId[i]=req.getParameter("CFFundRequestId-"+serialNo);
						itemNomenclature[i]=req.getParameter("CFItemNomenclature-"+serialNo);
						ItemAmount[i]=req.getParameter("CFItemAmount-"+serialNo);
						aprilMonth[i]=req.getParameter("CFAprilMonth-"+serialNo);
						mayMonth[i]=req.getParameter("CFMayMonth-"+serialNo);
						juneMonth[i]=req.getParameter("CFJuneMonth-"+serialNo);
						julyMonth[i]=req.getParameter("CFJulyMonth-"+serialNo);
						augustMonth[i]=req.getParameter("CFAugustMonth-"+serialNo);
						septemberMonth[i]=req.getParameter("CFSeptemberMonth-"+serialNo);
						octoberMonth[i]=req.getParameter("CFOctoberMonth-"+serialNo);
						novemberMonth[i]=req.getParameter("CFNovemberMonth-"+serialNo);
						decemberMonth[i]=req.getParameter("CFDecemberMonth-"+serialNo);
						januaryMonth[i]=req.getParameter("CFJanuaryMonth-"+serialNo);
						februaryMonth[i]=req.getParameter("CFFebruaryMonth-"+serialNo);
						marchMonth[i]=req.getParameter("CFMarchMonth-"+serialNo);
					}
				}
			}
			
			if(fundRequestSerialNo!=null)
			{
				cogMonth.setSelectedFundRequestId(selectedFundRequestId);
			}
			
			if(fundRequestSerialNo!=null)
			{
				cogMonth.setCarryForwardSerialNo(selectedFundRequestId);
			}
			
			if(cfFundRequestId!=null) 
			{
				cogMonth.setFundRequestId(cfFundRequestId);
			}
			
			if(demandId!=null) 
			{
				cogMonth.setDemandId(demandId);
			}
			
			if(commitmentPayId!=null) 
			{
				cogMonth.setCommitmentPayId(commitmentPayId);
			}
			
			if(itemNomenclature!=null)
			{
				cogMonth.setItemNomenclature(itemNomenclature);
			}
			if(ItemAmount!=null)
			{
				cogMonth.setFbeAmount(ItemAmount);
			}
			if(aprilMonth!=null)
			{
				cogMonth.setAprAmount(aprilMonth);;
			}
			if(mayMonth!=null)
			{
				cogMonth.setMayAmount(mayMonth);
			}
			if(juneMonth!=null)
			{
				cogMonth.setJunAmount(juneMonth);
			}
			if(julyMonth!=null)
			{
				cogMonth.setJulAmount(julyMonth);
			}
			if(augustMonth!=null)
			{
				cogMonth.setAugAmount(augustMonth);
			}
			if(septemberMonth!=null)
			{
				cogMonth.setSepAmount(septemberMonth);
			}
			if(octoberMonth!=null)
			{
				cogMonth.setOctAmount(octoberMonth);
			}
			if(novemberMonth!=null)
			{
				cogMonth.setNovAmount(novemberMonth);
			}
			if(decemberMonth!=null)
			{
				cogMonth.setDecAmount(decemberMonth);
			}
			if(januaryMonth!=null)
			{
				cogMonth.setJanAmount(januaryMonth);
			}
			if(februaryMonth!=null)
			{
				cogMonth.setFebAmount(februaryMonth);
			}
			if(marchMonth!=null)
			{
				cogMonth.setMarAmount(marchMonth);
			}
			
			long status=fundApprovalService.insertCarryForwardItemDetails(cogMonth,fundApprovalDto,UserName);
			
			String estimateTypeName="";
			if(fundApprovalDto!=null && (fundApprovalDto.getEstimatedTypeBackBtn()).equalsIgnoreCase("F"))
			{
				estimateTypeName="Forecast Budget Estimate Item(s)";
			}
			else if(fundApprovalDto!=null && (fundApprovalDto.getEstimatedTypeBackBtn()).equalsIgnoreCase("R"))
			{
				estimateTypeName="Revised Estimate Item(s)";
			}
			
			if(status>0)
			{
				redir.addAttribute("Status", estimateTypeName+" Transfered Successfully ..&#128077;");
			}
			else
			{
				redir.addAttribute("Failure", "Something Went Wrong..&#128078;");
			}
			
			if(fundApprovalDto!=null)
			{
				redir.addAttribute("FromYear", fundApprovalDto.getFromYearBackBtn());
				redir.addAttribute("ToYear", fundApprovalDto.getToYearBackBtn());
				redir.addAttribute("DivisionDetails", fundApprovalDto.getDivisionBackBtn());
				redir.addAttribute("EstimateType", fundApprovalDto.getEstimatedTypeBackBtn());
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside CarryForwardDetails.htm " + UserName, e);
			return "static/error";
		}
		return "redirect:/FundRequest.htm";
		
	}
	
	
	
	@RequestMapping(value="AddFundRequest.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String AddFundRequest(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside AddFundRequest.htm " + UserName);
		try
		{	
			req.setAttribute("ActionType", "add");	
			req.setAttribute("filesize", attach_file_size);
			req.setAttribute("officerList", masterService.getOfficersList());
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside AddFundRequest.htm " + UserName, e);
			return "static/error";
		}
		return "fundapproval/addFundRequest";
		
	}
	
	@RequestMapping(value="AddFundRequestSubmit.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String AddFundRequestSubmit(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir,@RequestPart("attachment") MultipartFile[] FileAttach) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside AddFundRequestSubmit.htm " + UserName);
		try
		{
			String action=req.getParameter("Action");
			String fundApprovalId=req.getParameter("fundApprovalId");
			String finYear=req.getParameter("finYear");
			String estimatedType=req.getParameter("estimatedType");
			String divisionId=req.getParameter("divisionId");
			String budget=req.getParameter("projectSel");
			String budgetHeadId=req.getParameter("budgetHeadId");
			String budgetItemId=req.getParameter("budgetItemId");
			String empId=req.getParameter("OfficerCode");
			String InitiationDate=req.getParameter("InitiationDate");
			String fbeYear=req.getParameter("fbeYear");
			String reYear=req.getParameter("reYear");
			
			String itemNomenclature=req.getParameter("ItemFor");
			String justification=req.getParameter("fileno");
			String fundRequestAmount=req.getParameter("TotalFundReguestAmount");
			String apr=req.getParameter("AprilMonth");
			String may=req.getParameter("MayMonth");
			String jun=req.getParameter("JuneMonth");
			String jul=req.getParameter("JulyMonth");
			String aug=req.getParameter("AugustMonth");
			String sep=req.getParameter("SeptemberMonth");
			String oct=req.getParameter("OctoberMonth");
			String nov=req.getParameter("NovemberMonth");
			String dec=req.getParameter("DecemberMonth");
			String jan=req.getParameter("JanuaryMonth");
			String feb=req.getParameter("FebruaryMonth");
			String mar=req.getParameter("MarchMonth");
			String filenames[] = req.getParameterValues("filename");
		    String[] existingAttachmentIds = req.getParameterValues("existingAttachmentId");
			
			System.err.println("Exisattach ID->"+Arrays.toString(existingAttachmentIds));
			if(action.equalsIgnoreCase("Add")) {
			FundApproval fundApproval=new FundApproval();
			
			fundApproval.setFinYear(finYear);
			fundApproval.setEstimateType(estimatedType);
			fundApproval.setDivisionId(Long.valueOf(divisionId));
			fundApproval.setInitiatingOfficer(Long.valueOf(empId));
			 if("R".equalsIgnoreCase(estimatedType)) {
				 fundApproval.setReFbeYear(reYear);
			    }
			    else if ("F".equalsIgnoreCase(estimatedType)) {
			     fundApproval.setReFbeYear(fbeYear);
				}
			fundApproval.setProjectId(Long.valueOf(budget));
			fundApproval.setBudgetHeadId(Long.valueOf(budgetHeadId));
			fundApproval.setBudgetItemId(Long.valueOf(budgetItemId));
			fundApproval.setItemNomenclature(itemNomenclature);
			fundApproval.setJustification(justification);
			fundApproval.setRequisitionDate(DateTimeFormatUtil.getRegularToSqlDate(InitiationDate));
			fundApproval.setFundRequestAmount(fundRequestAmount != null && !fundRequestAmount.trim().isEmpty() ? new BigDecimal(fundRequestAmount.trim()) : BigDecimal.ZERO);
			fundApproval.setApril(apr != null && !apr.trim().isEmpty() ? new BigDecimal(apr.trim()) : BigDecimal.ZERO);
			fundApproval.setMay(may != null && !may.trim().isEmpty() ? new BigDecimal(may.trim()) : BigDecimal.ZERO);
			fundApproval.setJune(jun != null && !jun.trim().isEmpty() ? new BigDecimal(jun.trim()) : BigDecimal.ZERO);
			fundApproval.setJuly(jul != null && !jul.trim().isEmpty() ? new BigDecimal(jul.trim()) : BigDecimal.ZERO);
			fundApproval.setAugust(aug != null && !aug.trim().isEmpty() ? new BigDecimal(aug.trim()) : BigDecimal.ZERO);
			fundApproval.setSeptember(sep != null && !sep.trim().isEmpty() ? new BigDecimal(sep.trim()) : BigDecimal.ZERO);
			fundApproval.setOctober(oct != null && !oct.trim().isEmpty() ? new BigDecimal(oct.trim()) : BigDecimal.ZERO);
			fundApproval.setNovember(nov != null && !nov.trim().isEmpty() ? new BigDecimal(nov.trim()) : BigDecimal.ZERO);
			fundApproval.setDecember(dec != null && !dec.trim().isEmpty() ? new BigDecimal(dec.trim()) : BigDecimal.ZERO);
			fundApproval.setJanuary(jan != null && !jan.trim().isEmpty() ? new BigDecimal(jan.trim()) : BigDecimal.ZERO);
			fundApproval.setFebruary(feb != null && !feb.trim().isEmpty() ? new BigDecimal(feb.trim()) : BigDecimal.ZERO);
			fundApproval.setMarch(mar != null && !mar.trim().isEmpty() ? new BigDecimal(mar.trim()) : BigDecimal.ZERO);
			fundApproval.setCreatedBy(UserName);
			fundApproval.setCreatedDate(LocalDateTime.now());
			fundApproval.setRcStatusCode("INITIATION");
			fundApproval.setRcStatusCodeNext("FORWARDED");
			fundApproval.setStatus("N");
			fundApproval.setSerialNo("0");			
			FundApprovalAttachDto attachDto=new FundApprovalAttachDto();
			attachDto.setFileName(filenames);
			attachDto.setFiles(FileAttach);
			attachDto.setCreatedBy(UserName);
			attachDto.setCreatedDate(LocalDateTime.now());
			
			 long status = fundApprovalService.AddFundRequestSubmit(fundApproval,attachDto); 
			
			 
			if(status > 0) {
				redir.addAttribute("resultSuccess", "Fund Request Submitted Successfully");
			}else {
				redir.addAttribute("resultFailure", "Fund Request submit Unsuccessful");
			}
		}else if(action.equalsIgnoreCase("Update")) {
				FundApproval fundApproval=new FundApproval();
				
				fundApproval.setFundApprovalId(Long.valueOf(fundApprovalId));
				fundApproval.setFinYear(finYear);
				fundApproval.setEstimateType(estimatedType);
				fundApproval.setDivisionId(Long.valueOf(divisionId));
				fundApproval.setInitiatingOfficer(Long.valueOf(empId));
				fundApproval.setProjectId(Long.valueOf(budget));
				fundApproval.setBudgetHeadId(Long.valueOf(budgetHeadId));
				fundApproval.setBudgetItemId(Long.valueOf(budgetItemId));
				fundApproval.setItemNomenclature(itemNomenclature);
				fundApproval.setJustification(justification);
				fundApproval.setRequisitionDate(DateTimeFormatUtil.getRegularToSqlDate(InitiationDate));
				fundApproval.setFundRequestAmount(fundRequestAmount != null && !fundRequestAmount.trim().isEmpty() ? new BigDecimal(fundRequestAmount.trim()) : BigDecimal.ZERO);
				fundApproval.setApril(apr != null && !apr.trim().isEmpty() ? new BigDecimal(apr.trim()) : BigDecimal.ZERO);
				fundApproval.setMay(may != null && !may.trim().isEmpty() ? new BigDecimal(may.trim()) : BigDecimal.ZERO);
				fundApproval.setJune(jun != null && !jun.trim().isEmpty() ? new BigDecimal(jun.trim()) : BigDecimal.ZERO);
				fundApproval.setJuly(jul != null && !jul.trim().isEmpty() ? new BigDecimal(jul.trim()) : BigDecimal.ZERO);
				fundApproval.setAugust(aug != null && !aug.trim().isEmpty() ? new BigDecimal(aug.trim()) : BigDecimal.ZERO);
				fundApproval.setSeptember(sep != null && !sep.trim().isEmpty() ? new BigDecimal(sep.trim()) : BigDecimal.ZERO);
				fundApproval.setOctober(oct != null && !oct.trim().isEmpty() ? new BigDecimal(oct.trim()) : BigDecimal.ZERO);
				fundApproval.setNovember(nov != null && !nov.trim().isEmpty() ? new BigDecimal(nov.trim()) : BigDecimal.ZERO);
				fundApproval.setDecember(dec != null && !dec.trim().isEmpty() ? new BigDecimal(dec.trim()) : BigDecimal.ZERO);
				fundApproval.setJanuary(jan != null && !jan.trim().isEmpty() ? new BigDecimal(jan.trim()) : BigDecimal.ZERO);
				fundApproval.setFebruary(feb != null && !feb.trim().isEmpty() ? new BigDecimal(feb.trim()) : BigDecimal.ZERO);
				fundApproval.setMarch(mar != null && !mar.trim().isEmpty() ? new BigDecimal(mar.trim()) : BigDecimal.ZERO);
				fundApproval.setModifiedBy(UserName);
				fundApproval.setModifiedDate(LocalDateTime.now());
				fundApproval.setRcStatusCode("INITIATION");
				fundApproval.setRcStatusCodeNext("FORWARDED");
				fundApproval.setStatus("N");
				
				FundApprovalAttachDto attachDto=new FundApprovalAttachDto();
				attachDto.setFileName(filenames);
				attachDto.setFiles(FileAttach);
				attachDto.setCreatedBy(UserName);
				attachDto.setCreatedDate(LocalDateTime.now());
			  
			    attachDto.setExistingAttachmentIds(existingAttachmentIds);
				
				 long status = fundApprovalService.EditFundRequestSubmit(fundApproval, attachDto); 
				
					
					if(status > 0) {
						redir.addAttribute("resultSuccess", "Fund Request Updated Successfully");
					}else {
						redir.addAttribute("resultFailure", "Fund Request Update Unsuccessful");
					}
			}
			
			FundApprovalBackButtonDto fundApprovalDto=(FundApprovalBackButtonDto) ses.getAttribute("FundApprovalAttributes");
			if(fundApprovalDto!=null)
			{
				redir.addAttribute("FromYear", fundApprovalDto.getFromYearBackBtn());
				redir.addAttribute("ToYear", fundApprovalDto.getToYearBackBtn());
				redir.addAttribute("DivisionDetails", fundApprovalDto.getDivisionBackBtn());
				redir.addAttribute("EstimateType", fundApprovalDto.getEstimatedTypeBackBtn());
			}
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside AddFundRequestSubmit.htm " + UserName, e);
			return "static/error";
		}
		return "redirect:/FundRequest.htm";
		
	}
	
	@RequestMapping(value = "GetMasterFlowDetails.htm", method = RequestMethod.GET)
	public @ResponseBody String getMasterFlowDetails(HttpSession ses, HttpServletRequest req) throws Exception {
		Gson json = new Gson();
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside GetMasterFlowDetails.htm " + UserName);
		try {
				String estimatedCost = req.getParameter("estimatedCost");
				String fundRequestId = req.getParameter("fundRequestId");
				if(estimatedCost!=null && fundRequestId!=null) 
				{
					return json.toJson(fundApprovalService.getMasterFlowDetails(estimatedCost,fundRequestId)); 
				}
				return null;
				
		} catch (Exception e) {
			logger.error(new Date() + "Inside GetMasterFlowDetails.htm " + UserName, e);
			e.printStackTrace();
			return null;
		}
	}
	
	@RequestMapping(value = "GetCommitteeMemberDetails.htm", method = RequestMethod.GET)
	public @ResponseBody String getCommitteeMemberDetails(HttpSession ses, HttpServletRequest req) throws Exception {
		Gson json = new Gson();
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside GetCommitteeMemberDetails.htm " + UserName);
		try {
				return json.toJson(fundApprovalService.getAllCommitteeMemberDetails(LocalDate.now())); 
		} catch (Exception e) {
			logger.error(new Date() + "Inside GetCommitteeMemberDetails.htm " + UserName, e);
			e.printStackTrace();
			return null;
		}
	}

	@RequestMapping(value="EditFundRequest.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String EditFundRequest(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside EditFundRequest.htm " + UserName);
		try
		{
			Long fundApprovalId=Long.valueOf(req.getParameter("fundApprovalId"));
			System.err.println("fundApprovalId Edit->"+fundApprovalId);
			Object[] getFundRequestObj=fundApprovalService.getFundRequestObj(fundApprovalId);
			List<Object[]> getFundRequestAttachList=fundApprovalService.getFundRequestAttachList(fundApprovalId);
			
			req.setAttribute("attachList",getFundRequestAttachList);
			req.setAttribute("filesize", attach_file_size);
			req.setAttribute("FundRequestObj", getFundRequestObj);
			req.setAttribute("ActionType", "Edit");		
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside EditFundRequest.htm " + UserName, e);
			return "static/error";
		}
		return "fundapproval/addFundRequest";
		
	}
	
	@RequestMapping(value = "GetFundRequestAttachmentAjax.htm", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public List<Map<String, Object>> getFundRequestAttachments(HttpServletRequest req) {
	    long fundApprovalId = Long.parseLong(req.getParameter("fundApprovalId"));
	    List<Map<String, Object>> resultList = new ArrayList<>();

	    try {
	        List<Object[]> list = fundApprovalService.getFundRequestAttachList(fundApprovalId);
	        if (list != null) {
	            for (Object[] obj : list) {
	                Map<String, Object> map = new HashMap<>();
	                map.put("fundApprovalAttachId", obj[0]);
	                map.put("fileName", obj[1]); // stored file name
	                map.put("originalFileName", obj[2]); // name to show
	                map.put("fundApprovalId", obj[3]);
	                resultList.add(map);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultList;
	}

	
	@RequestMapping(value = "PreviewAttachment.htm", method = {RequestMethod.GET} )
	public void previewAttachment(HttpServletRequest req, HttpServletResponse response) throws Exception {
		String fundApprovalAttachId=req.getParameter("attachid");
		Object[] attachmentdata=fundApprovalService.FundRequestAttachData(Long.valueOf(fundApprovalAttachId));
	    if (attachmentdata != null) {
	        File file = new File(uploadpath+"FundApproval"+File.separator+ attachmentdata[1]+File.separator+attachmentdata[3]);
	        String mimeType = Files.probeContentType(file.toPath());
	        response.setContentType(mimeType);
	        response.setHeader("Content-Disposition", "inline; filename=\"" + attachmentdata[3] + "\"");
	        Files.copy(file.toPath(), response.getOutputStream());
	        response.flushBuffer();
	    }
	}
	
	

	
	 @RequestMapping(value = "FundRequestAttachDownload.htm", method = {RequestMethod.GET} )
		public void ProjectMasterAttachDownload(HttpServletRequest req, HttpSession ses,HttpServletResponse res, RedirectAttributes redir)throws Exception
		{	
			String UserId = (String) ses.getAttribute("Username");
		logger.info(new Date() +"Inside FundRequestAttachDownload.htm "+UserId);
			try
		{	System.err.println("**********88888hitting download!!!!!!!");
				String fundApprovalAttachId=req.getParameter("attachid");
				System.err.println("DOWNLOAD fundApprovalId-"+fundApprovalAttachId);
				Object[] attachmentdata=fundApprovalService.FundRequestAttachData(Long.valueOf(fundApprovalAttachId));
				
				File my_file=null;
				my_file = new File(uploadpath+"FundApproval"+File.separator+ attachmentdata[1]+File.separator+attachmentdata[3]);
				res.setContentType("Application/octet-stream");	
		        res.setHeader("Content-disposition","attachment; filename="+attachmentdata[3].toString()); 
		        ServletOutputStream out = res.getOutputStream();
	            FileInputStream in = new FileInputStream(my_file);
		        byte[] buffer = new byte[4096];
	      int length;
		        while ((length = in.read(buffer)) > 0){
		           out.write(buffer, 0, length);
		        }
		        in.close();
		        out.flush();
		        out.close();
		        
		}catch 
			(Exception e) {
				e.printStackTrace(); 
				logger.error(new Date() +"Inside FundRequestAttachDownload.htm "+UserId,e);
			}
	}
	 
	 @RequestMapping(value = "FundRequestAttachDelete.htm", method = {RequestMethod.POST,RequestMethod.GET} )
		public String FundRequestAttachDelete(HttpServletRequest req, HttpSession ses,HttpServletResponse res, RedirectAttributes redir)throws Exception
		{	
			String UserId = (String) ses.getAttribute("Username");
			try
		{
				String fundApprovalAttachId=req.getParameter("attachid");
				String fundRequestId=req.getParameter("fundRequestId");
				System.err.println("DELETE fundApprovalId-"+fundApprovalAttachId);
				int count=fundApprovalService.FundRequestAttachDelete(Long.valueOf(fundApprovalAttachId) );
				System.err.println("DELETED->"+count);
				if (count > 0) {
					redir.addAttribute("resultSuccess", "Fund Request Attachment Deleted Successfully");
			      } else {
					redir.addAttribute("resultFailure", "Fund Request Attachment Delete Unsuccessful");
				  }
				
				redir.addAttribute("fundApprovalId", fundRequestId);
			return "redirect:/EditFundRequest.htm";
				
			}catch 
		(Exception e) {
			e.printStackTrace(); 
			logger.error(new Date() +"Inside FundRequestAttachDelete.htm "+UserId,e);
				
		}
			return null;
		}
	 
		@RequestMapping(value="FundApprovalForward.htm",method = {RequestMethod.GET,RequestMethod.POST})
		public String fundApprovalForward(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
		{
			String UserName = (String) ses.getAttribute("Username");
			long empId = (Long) ses.getAttribute("EmployeeId");
			logger.info(new Date() + "Inside FundApprovalForward.htm " + UserName);
			try
			{
				String fundRequestId=req.getParameter("FundRequestIdForward");
				String flowMasterId=req.getParameter("FlowMasterIdForward");
				String estimatedCost=req.getParameter("EstimatedCostForward");
				
				if(fundRequestId==null)
				{
					redir.addAttribute("resultFailure", "Something Went Wrong..!");
					return "redirect:/FundRequest.htm";
				}
				
				String rpbMember1=req.getParameter("RPBMemberDetails1");
				String rpbMemberRole1=req.getParameter("RPBMemberRole1");
				String rpbMember2=req.getParameter("RPBMemberDetails2");
				String rpbMemberRole2=req.getParameter("RPBMemberRole2");
				String rpbMember3=req.getParameter("RPBMemberDetails3");
				String rpbMemberRole3=req.getParameter("RPBMemberRole3");
				String subjectExpert=req.getParameter("SubjectExpertDetails");
				String subjectExpertRole=req.getParameter("SubjectExpertRole");
				String rpbSecretary=req.getParameter("RPBMemberSecretaryDetails");
				String rpbMemberSecretaryRole=req.getParameter("RPBMemberSecretaryRole");
				String chairman=req.getParameter("chairmanDetails");
				String chairmanRole=req.getParameter("chairmanRole");
				
				FundApproval fundApprovalData=fundApprovalService.getFundRequestDetails(fundRequestId);
				fundApprovalData.setRc1(rpbMember1!=null && rpbMember1!="" ? Long.parseLong(rpbMember1) : 0);
				fundApprovalData.setRc1Role(rpbMemberRole1!=null && rpbMemberRole1!="" ? rpbMemberRole1 : null);
				
				fundApprovalData.setRc2(rpbMember2!=null && rpbMember2!="" ? Long.parseLong(rpbMember2) : 0);
				fundApprovalData.setRc2Role(rpbMemberRole2!=null && rpbMemberRole2!="" ? rpbMemberRole2 : null);
				
				fundApprovalData.setRc3(rpbMember3!=null && rpbMember3!="" ? Long.parseLong(rpbMember3) : 0);
				fundApprovalData.setRc3Role(rpbMemberRole3!=null && rpbMemberRole3!="" ? rpbMemberRole3 : null);
				
				fundApprovalData.setRc4(subjectExpert!=null && subjectExpert!="" ? Long.parseLong(subjectExpert) : 0);
				fundApprovalData.setRc4Role(subjectExpertRole!=null && subjectExpertRole!="" ? subjectExpertRole : null);
				
				fundApprovalData.setRc5(rpbSecretary!=null && rpbSecretary!="" ? Long.parseLong(rpbSecretary) : 0);
				fundApprovalData.setRc5Role(rpbMemberSecretaryRole!=null && rpbMemberSecretaryRole!="" ? rpbMemberSecretaryRole : null);
				
				fundApprovalData.setApprovingOfficer(chairman!=null && chairman!="" ? Long.parseLong(chairman) : 0);
				fundApprovalData.setApprovingOfficerRole(chairmanRole!=null && chairmanRole!="" ? chairmanRole : null);
				
				fundApprovalData.setModifiedBy(UserName);
				fundApprovalData.setModifiedDate(LocalDateTime.now());;
				
				long status = fundApprovalService.fundRequestForward(fundApprovalData,flowMasterId,estimatedCost,empId); 
				
				
				if(status > 0) {
					redir.addAttribute("resultSuccess", "Fund Request Successfully Submitted");
				}else {
					redir.addAttribute("resultFailure", "Fund Request submit Unsuccessful");
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
				logger.error(new Date() + " Inside FundApprovalForward.htm " + UserName, e);
				return "static/error";
			}
			return "redirect:/FundRequest.htm";
			
		}
		
		@RequestMapping(value="FundReport.htm",method = {RequestMethod.GET,RequestMethod.POST})
		public String FundReport(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
		{
			String UserName = (String) ses.getAttribute("Username");
			logger.info(new Date() + "Inside FundApproval.htm " + UserName);
			String labCode = (ses.getAttribute("client_name")).toString();
			String loginType= (String)ses.getAttribute("LoginType");
			String empDivisionCode= (String)ses.getAttribute("EmployeeDivisionCode");
			String empDivisionName= (String)ses.getAttribute("EmployeeDivisionName");
			String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
			String divisionId = ((Long) ses.getAttribute("Division")).toString();
			try
			{
				String FromYear=req.getParameter("FromYear");
				String ToYear=req.getParameter("ToYear");
				String DivisionDetails=req.getParameter("DivisionDetails");
				String estimateType=req.getParameter("EstimateType");
				String status=req.getParameter("approvalStatus");
				String budgetHeadId=req.getParameter("budgetHeadId");
				String budgetItemId=req.getParameter("budgetItemId");
				String fromCost=req.getParameter("FromCost");
				String toCost=req.getParameter("ToCost");
				
				
				
				if(fromCost!=null) {
					fromCost=fromCost.trim();
				}
				if(toCost!=null) {
					toCost=toCost.trim();
				}
				
				
				if(estimateType==null)
				{
					estimateType="R";
				}
				
				String DivisionId=null;
				if(DivisionDetails!=null)
				{
					DivisionId=DivisionDetails.split("#")[0];
				}
				else
				{
					if(loginType!=null && !loginType.equalsIgnoreCase("A"))
					{
						DivisionId=divisionId;
						DivisionDetails=divisionId+"#"+empDivisionCode+"#"+empDivisionName;
					}
					else
					{
						DivisionId="-1";
						DivisionDetails="-1#All#All";
					}
				}
				
				String projectId="0";
				
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
					toCost="10000000";
				}
				
				if(status==null) {
					status="N";
				}
				
				if(Long.valueOf(budgetHeadId)==0) {
					budgetItemId="0";
				}
				
				List<Object[]> RequisitionList=fundApprovalService.getFundReportList(FinYear, DivisionId, estimateType, loginType, empId, projectId, budgetHeadId, budgetItemId, fromCost, toCost, status);
				List<Object[]> DivisionList=masterService.getDivisionList(labCode,empId,loginType);
				
				req.setAttribute("RequisitionList", RequisitionList);
				req.setAttribute("DivisionList", DivisionList);
				req.setAttribute("CurrentFinYear", DateTimeFormatUtil.getCurrentFinancialYear());
				req.setAttribute("ExistingbudgetHeadId", budgetHeadId);
				req.setAttribute("ExistingbudgetItemId", budgetItemId);
				req.setAttribute("ExistingfromCost", fromCost);
				req.setAttribute("ExistingtoCost", toCost);
				req.setAttribute("Existingstatus", status);
				
				
				//user selected different year Estimate type reset to RE
				FundApprovalBackButtonDto backDto=new FundApprovalBackButtonDto();
				   backDto.setDivisionBackBtn(DivisionDetails);
				   backDto.setDivisionName(DivisionDetails.split("#")[2]);
				   backDto.setDivisionCode(DivisionDetails.split("#")[1]);
				   backDto.setFromYearBackBtn(FinYear.split("-")[0]);
				   backDto.setToYearBackBtn( FinYear.split("-")[1]);
				   backDto.setEstimatedTypeBackBtn(estimateType);
				   backDto.setDivisionId(DivisionId);
				   backDto.setREYear(FromYear+"-"+ToYear);
				   backDto.setFBEYear((Long.parseLong(FromYear)+1)+"-"+(Long.parseLong(ToYear)+1));
				   
				   ses.setAttribute("FundApprovalAttributes", backDto);
				
			}
			catch(Exception e)
			{
				e.printStackTrace();
				logger.error(new Date() + " Inside RequisitionList.htm " + UserName, e);
				return "static/error";
			}
			return "fundapproval/fundReportList";
			
		}
		
		@RequestMapping(value="FundReportPrint.htm",method = {RequestMethod.GET,RequestMethod.POST})
		public String FundReportPrint(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
		{
			String UserName = (String) ses.getAttribute("Username");
			logger.info(new Date() + "Inside FundReportPrint.htm " + UserName);
			String labCode = (ses.getAttribute("client_name")).toString();
			String loginType= (String)ses.getAttribute("LoginType");
			String empDivisionCode= (String)ses.getAttribute("EmployeeDivisionCode");
			String empDivisionName= (String)ses.getAttribute("EmployeeDivisionName");
			String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
			String divisionId = ((Long) ses.getAttribute("Division")).toString();
			try
			{	
				String PrintAction= req.getParameter("PrintAction");
				String FromYear=req.getParameter("FromYear");
				String ToYear=req.getParameter("ToYear");
				String DivisionDetails=req.getParameter("DivisionDetails");
				String estimateType=req.getParameter("EstimateType");
				String status=req.getParameter("approvalStatus");
				String budgetHeadId=req.getParameter("budgetHeadId");
				String budgetItemId=req.getParameter("budgetItemId");
				String fromCost=req.getParameter("FromCost");
				String toCost=req.getParameter("ToCost");
				String fbeYear=req.getParameter("fbeYear");
				String reYear=req.getParameter("reYear");
				String ReOrFbe=null;
				String ReOrFbeYear=null;
				/*
				 * String ReOrFbe=estimateType.split("#")[1];
				 * System.err.println("ReOrFbe-"+ReOrFbe);
				 * estimateType=estimateType.split("#")[0];
				 * System.err.println("estimateType split-"+estimateType);
				 */
				
				
				String projectId="0";
				
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
					
				
				
				if(fromCost!=null) {
					fromCost=fromCost.trim();
				}
				if(toCost!=null) {
					toCost=toCost.trim();
				}
				
				
				if(estimateType==null)
				{
					estimateType="R";
				}
				
				String DivisionId=null;
				if(DivisionDetails!=null)
				{
					DivisionId=DivisionDetails.split("#")[0];
				}
				else
				{
					if(loginType!=null && !loginType.equalsIgnoreCase("A"))
					{
						DivisionId=divisionId;
						DivisionDetails=divisionId+"#"+empDivisionCode+"#"+empDivisionName;
					}
					else
					{
						DivisionId="-1";
						DivisionDetails="-1#All#All";
					}
				}
				
				if(Long.valueOf(budgetHeadId)==0) {
					budgetItemId="0";
				}
			
				/*
				 * 
				 * if(budgetHeadId==null) { budgetHeadId="0"; }
				 * 
				 * if(budgetItemId==null) { budgetItemId="0"; }
				 * 
				 * if(fromCost==null) { fromCost="0"; }
				 * 
				 * if(toCost==null) { toCost="10000000"; }
				 * 
				 * if(status==null) { status="N"; }
				 */
				
				List<Object[]> labInfoList=masterService.GetLabInfo(labCode);
			    String labName = null;
			    
			    for(Object[] obj : labInfoList) {
				     labName = String.valueOf(obj[1].toString());
			    }   
			    
			    
			    System.err.println("labCode--"+labCode);
				System.err.println("labName--"+labName);
				
				
			    if(labLogo.getLabLogoAsBase64()!=null) {

				       req.setAttribute("LabLogo", labLogo.getLabLogoAsBase64());
				    }
			    
			  
			    System.err.println("reYear-"+reYear);
			    System.err.println("fbeYear-"+fbeYear);
			    if("R".equalsIgnoreCase(estimateType)) {
			    	ReOrFbeYear=reYear;
			    	ReOrFbe="R";
			    }
			    else if ("F".equalsIgnoreCase(estimateType)) {
			    	ReOrFbeYear=fbeYear;
			    	ReOrFbe="F";
				}
			    
				List<Object[]> RequisitionList=fundApprovalService.getFundReportList(FinYear, DivisionId, estimateType, loginType, empId, projectId, budgetHeadId, budgetItemId, fromCost, toCost, status);
				
				System.err.println("RequisitionList"+RequisitionList.size());
				req.setAttribute("RequisitionList", RequisitionList);
			    req.setAttribute("CurrentFinYear", DateTimeFormatUtil.getCurrentFinancialYear());
			    req.setAttribute("ExistingbudgetHeadId", budgetHeadId);
			    req.setAttribute("ExistingbudgetItemId", budgetItemId);
			    req.setAttribute("ExistingfromCost", fromCost);
			    req.setAttribute("ExistingtoCost", toCost);
			    req.setAttribute("Existingstatus", status);
			    req.setAttribute("ReOrFbe", ReOrFbe);
			    req.setAttribute("ReOrFbeYear", ReOrFbeYear);
			    req.setAttribute("FinYear", FinYear);
			    req.setAttribute("labName", labName);
			    req.setAttribute("LabLogo", labLogo.getLabLogoAsBase64());
				
				if("pdf".equalsIgnoreCase(PrintAction)) {
					
					
					String filename="RPB Fund Report";
					String path=req.getServletContext().getRealPath("/view/temp");
			       
			        CharArrayWriterResponse customResponse = new CharArrayWriterResponse(resp);
					req.getRequestDispatcher("/view/fundapproval/fundReportListPrint.jsp").forward(req, customResponse);
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
					return "fundapproval/fundReportListPrint";
				}
				
				
			}
			catch(Exception e)
			{
				e.printStackTrace();
				logger.error(new Date() + " Inside FundReportPrint.htm " + UserName, e);
				return "static/error";
			}
			return "fundapproval/fundReportListPrint";
			
		}
		
		@RequestMapping(value = "getRPBApprovalHistoryAjax.htm",method= {RequestMethod.GET,RequestMethod.POST})
		public @ResponseBody String getRPBApprovalHistoryAjax(HttpServletRequest req,HttpServletResponse resp, HttpSession ses, RedirectAttributes redir)
		{
			String UserName = (String) ses.getAttribute("Username");
			logger.info(new Date() +"Inside getRPBApprovalHistoryAjax.htm"+UserName);
			Gson json = new Gson();
			List<Object[]>	fundDetails=null;
			try {
				
				String fundApprovalId=req.getParameter("fundApprovalId");
				
				if(fundApprovalId!=null)
				{ 
					 fundDetails = fundApprovalService.getParticularFundApprovalTransDetails(fundApprovalId);
				}
				
			} catch (Exception e) {
				
				e.printStackTrace();
				logger.error(new Date() + " Inside getRPBApprovalHistoryAjax.htm " + UserName, e);
				return "static/error";
				
			}
		    return json.toJson(fundDetails); 

		}
		
		@RequestMapping(value = "getRPBApprovalStatusAjax.htm",method= {RequestMethod.GET,RequestMethod.POST})
		public @ResponseBody String getRPBApprovalStatusAjax(HttpServletRequest req,HttpServletResponse resp, HttpSession ses, RedirectAttributes redir)
		{
			String UserName = (String) ses.getAttribute("Username");
			logger.info(new Date() +"Inside getRPBApprovalStatusAjax.htm"+UserName);
			long empId = (long) ses.getAttribute("EmployeeId");
			Gson json = new Gson();
			List<Object[]>	fundDetails=null;
			try {
				
				String fundApprovalId=req.getParameter("fundApprovalId");
				
				
				if(fundApprovalId!=null)
				{ 
					  fundDetails = fundApprovalService.getParticularFundApprovalDetails(fundApprovalId,empId);
				}
				
			} catch (Exception e) {
				
				e.printStackTrace();
				logger.error(new Date() + " Inside getRPBApprovalStatusAjax.htm " + UserName, e);
				return "static/error";
				
			}
			return json.toJson(fundDetails);
		}
		
		@RequestMapping(value ="GetBudgetHeadList.htm")
		public @ResponseBody String GetBudgetHeadList(HttpServletRequest req, HttpSession ses, RedirectAttributes redir) throws Exception{
			String userName =(String)ses.getAttribute("Username");
			logger.info(new Date() +"Inside GetBudgetHeadList.htm "+userName);	
			Gson json = new Gson();
			try 
			{   
				List<BudgetDetails> budgetHeadList=null;
				String projectDetails=req.getParameter("ProjectDetails");
				if(projectDetails!=null)
				{
					String[] project=projectDetails.split("#");
					if(project!=null && project.length>0) 
					{
						if(project[0]!=null) 
						{
							budgetHeadList=fundApprovalService.getBudgetHeadList(project[0]);
						}
					}
				}
				return json.toJson(budgetHeadList);
			}
			catch (Exception e){
				logger.error(new Date() +"Inside GetBudgetHeadList.htm "+userName ,e);
				e.printStackTrace();
				return null;
			}
		}
		
		@RequestMapping(value ="SelectbudgetItem.htm")
		public @ResponseBody String SelectbudgetItem(HttpServletRequest req, HttpSession ses, RedirectAttributes redir) throws Exception{
			String UserName =(String)ses.getAttribute("Username");
			logger.info(new Date() +"Inside SelectbudgetItem.htm "+UserName);	
			Gson json = new Gson();
			List<BudgetDetails> list = new ArrayList<>();
			try {
				String projectData = req.getParameter("projectid");
				String budgetHeadData = req.getParameter("budgetHeadId");
				
				long projectId=0;
				long budgetHeadId=0;
				if(projectData!=null)
				{        
					String arr[]=projectData.split("#");    // Splitting Project Code And Project Id
					projectId=Long.parseLong(arr[0]);
					budgetHeadId=Long.parseLong(budgetHeadData);
				}   
				
				List<Object[]> BudgetItemlist=fundApprovalService.getBudgetHeadItem(projectId,budgetHeadId);  // Fetching getBudgetHeadItem From DatasBase
				
				if (BudgetItemlist.size() > 0) {

					for (Object[] resultList:BudgetItemlist) 
					{
						BudgetDetails budgetItemDetails = new BudgetDetails();
						if(resultList!=null)
						{
							if(resultList[0]!=null)
							{
								budgetItemDetails.setBudgetItemId(Long.parseLong(resultList[0].toString()));
							}
							
							if(resultList[1]!=null)
							{
								budgetItemDetails.setHeadOfAccounts(resultList[1].toString());
							}
							
							if(resultList[2]!=null)
							{
								budgetItemDetails.setRefe(resultList[2].toString());
							}
							if(resultList[3]!=null)
							{
								budgetItemDetails.setMajorHead(resultList[3].toString()); 
							}
							if(resultList[4]!=null)
							{
								budgetItemDetails.setMinorHead(resultList[4].toString()); 
							}
							if(resultList[5]!=null)
							{
								budgetItemDetails.setSubHead(resultList[5].toString()); 
							}
							if(resultList[6]!=null)
							{
								budgetItemDetails.setSubMinorHead(resultList[6].toString()); 
							}
							list.add(budgetItemDetails);
						}
					}
				} else 
				{
					BudgetDetails budgetItemDetails = new BudgetDetails();
					budgetItemDetails.setBudgetItemId(-3);
					budgetItemDetails.setHeadOfAccounts("No Sanction");
					list.add(budgetItemDetails);
				}
			}catch (Exception e) {
				e.printStackTrace();
				logger.error(new Date() +" Inside SelectbudgetItem.htm "+UserName, e);
				return "static/error";
			}         
			return json.toJson(list, new TypeToken<List<BudgetDetails>>() {}.getType());
		}
		
		@RequestMapping(value="estimateTypeParticularDivList.htm",method = {RequestMethod.GET,RequestMethod.POST})
		public String estimateTypeParticularDivList(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
		{
			String UserName = (String) ses.getAttribute("Username");
			String loginType= (String)ses.getAttribute("LoginType");
			String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
			logger.info(new Date() + "Inside EditFundRequest.htm " + UserName);
			try
			{
				Long divisionId=Long.valueOf(req.getParameter("divisionId"));
				String estimateType=req.getParameter("estimateType");
				String FromYear=req.getParameter("FromYear");
				String ToYear=req.getParameter("ToYear");
				String status=req.getParameter("approvalStatus");
				String budgetHeadId=req.getParameter("budgetHeadId");
				String budgetItemId=req.getParameter("budgetItemId");
				String fromCost=req.getParameter("FromCost");
				String toCost=req.getParameter("ToCost");
				
				
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
				
				System.err.println("divisionId->"+divisionId);
				System.err.println("estimateType->"+estimateType);
				System.err.println("FromYear->"+FromYear);
				System.err.println("ToYear->"+ToYear);
				System.err.println("budgetheadID->"+budgetHeadId);
				System.err.println("budgetItemId->"+budgetItemId);
				System.err.println("fromCost->"+fromCost);
				System.err.println("toCost->"+toCost);
				System.err.println("status->"+status);
				System.err.println("loginType->"+loginType);
				System.err.println("empId->"+empId);
				System.err.println("FinYear->"+FinYear);
				
				List<Object[]> estimateTypeParticularDivList=fundApprovalService.estimateTypeParticularDivList(divisionId, estimateType,FinYear,loginType,empId,budgetHeadId,budgetItemId,fromCost,toCost,status);
				
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
				
			}
			catch(Exception e)
			{
				e.printStackTrace();
				logger.error(new Date() + " Inside estimateTypeParticularDivList.htm " + UserName, e);
				return "static/error";
			}
			return "fundapproval/ParticularDivTypeReportList";
			
		}
		
}
