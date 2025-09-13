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
    
	/* Bharani Changes in new Branch */
	
    @RequestMapping(value="FundRequest.htm",method = {RequestMethod.GET,RequestMethod.POST})
   	public String FundApproval(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
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
   			String committeeMember=fundApprovalService.getCommitteeMemberCurrentStatus(String.valueOf(empId));
   			String currentFinYear=DateTimeFormatUtil.getCurrentFinancialYear();
   			
   		 String FromYear = safeTrim(req.getParameter("FromYear"));
         String ToYear = safeTrim(req.getParameter("ToYear"));
         String DivisionDetails = safeTrim(req.getParameter("DivisionDetails"));
         String estimateType = safeTrim(req.getParameter("EstimateType"));
         
         	if(committeeMember == null)
         	{
         		committeeMember = "NA";
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
   					if(committeeMember!=null && (committeeMember.equalsIgnoreCase("CS") || committeeMember.equalsIgnoreCase("CC")))
   					{
   						DivisionId="-1";
   	   					DivisionDetails="-1#All#All";
   					}
   					else
   					{
   						DivisionId=divisionId;
   	   					DivisionDetails=divisionId+"#"+empDivisionCode+"#"+empDivisionName;
   					}
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
   				FinYear=FromYear.trim()+"-"+ToYear.trim();
   			}
   			
   			List<Object[]> RequisitionList=fundApprovalService.getFundApprovalList(FinYear,DivisionId,estimateType,loginType,empId,projectId,committeeMember);
   			List<Object[]> DivisionList=masterService.getDivisionList(labCode,empId,loginType,committeeMember);
   			
   			req.setAttribute("RequisitionList", RequisitionList);
   			req.setAttribute("DivisionList", DivisionList);
   			req.setAttribute("MemberType", committeeMember);
   			req.setAttribute("currentFinYear", currentFinYear);
   			
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

    private String safeTrim(String value) {
        return value == null ? null : value.trim();
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
					if(fundDetails.get(0).length > 0)
					{
						Object[] particularFundDetails=fundDetails.get(0);
						
						req.setAttribute("fundDetails",particularFundDetails);
						
						String fromYear =null,toYear = null,finYear = null;
						finYear = particularFundDetails[2]!=null ? particularFundDetails[2].toString() : null;
						fromYear = finYear != null ? finYear.split("-")[0] : null;						toYear = finYear != null ? finYear.split("-")[1] : null;
						
					   FundApprovalBackButtonDto backDto=new FundApprovalBackButtonDto();
		   			   backDto.setDivisionName(particularFundDetails[13]!=null ? particularFundDetails[13].toString() : "");
		   			   backDto.setDivisionCode(particularFundDetails[12]!=null ? particularFundDetails[12].toString() : "");
		   			   backDto.setFromYearBackBtn(fromYear);
		   			   backDto.setToYearBackBtn(toYear);
		   			   backDto.setEstimatedTypeBackBtn(particularFundDetails[1]!=null ? particularFundDetails[1].toString() : "");
		   			   backDto.setDivisionId(particularFundDetails[11]!=null ? particularFundDetails[11].toString() : "");
		   			   backDto.setREYear(fromYear+"-"+toYear);
		   			   backDto.setFBEYear((Long.parseLong(fromYear)+1)+"-"+(Long.parseLong(toYear)+1));
		   			   
		   			   ses.setAttribute("FundApprovalAttributes", backDto);
					}
				}
				
				req.setAttribute("employeeCurrentStatus",fundApprovalService.getCommitteeMemberCurrentStatus(String.valueOf(empId)));
				req.setAttribute("MasterFlowDetails",fundApprovalService.getMasterFlowDetails(fundApprovalId));
				req.setAttribute("AllCommitteeMasterDetails",fundApprovalService.getAllCommitteeMemberDetails(LocalDate.now()));
			}
			
			return "fundapproval/fundApprovalPreview";
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date()+"Inside fundapprovaldApprovalPreview.htm"+ UserName, e);
			return "static/error";
			
		}
	}
	
	// Recommendation, Return, Approval
	@RequestMapping(value="CommitteeMemberAction.htm", method = {RequestMethod.GET,RequestMethod.POST})
	public String fundApprovalSubmit(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		long empId = (Long) ses.getAttribute("EmployeeId");
		logger.info(new Date() + "Inside FundApprovalSubmit.htm " + UserName);
		String url=null;
		
		String fundApprovalId=req.getParameter("fundApprovalId");
		String action=req.getParameter("Action");
		String remarks=req.getParameter("remarks");
		String memberStatus=req.getParameter("memberStatus");
		String flowDetailsId=req.getParameter("flowDetailsId");
		
		try
		{
			System.out.println("fundApprovalId*****"+fundApprovalId);
			System.out.println("action*****"+action);
			System.out.println("remarks*****"+remarks);
			if(fundApprovalId==null || action==null || memberStatus == null || flowDetailsId == null)
			{
				redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
				return "redirect:/FundApprovalPreview.htm";
			}
			
			FundApprovalDto fundDto=new FundApprovalDto();
			fundDto.setFundApprovalId(fundApprovalId!=null ? Long.parseLong(fundApprovalId) : 0);
			fundDto.setRemarks(remarks!=null ? remarks.trim() : null);
			fundDto.setMemberStatus(memberStatus);
			fundDto.setFlowDetailsId(flowDetailsId);
			fundDto.setAction(action);
			fundDto.setCreatedBy(UserName);
			
			long status = fundApprovalService.updateRecommendAndApprovalDetails(fundDto,empId); 
			
			//  A - Approver, RE - Recommender, DA - Division Head Recc
			String actionMssg="NA";
			
			if(action.equalsIgnoreCase("A"))
			{
				actionMssg = "Approved";
			}
			else if(action.equalsIgnoreCase("R"))
			{
				actionMssg = "Returned";
			}
			else
			{
				actionMssg = "Recommended";
			}
			
			if(status > 0) {
				redir.addAttribute("resultSuccess", "Fund Request "+actionMssg+" Successfully..&#128077;");
			}else {
				redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
			}
			
			url="redirect:/FundApprovalList.htm";
					
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside BudgetApprovalForward.htm " + UserName, e);
			redir.addAttribute("FundApprovalIdSubmit", fundApprovalId);
			redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
			return "redirect:/FundApprovalPreview.htm";
		}
		return url;
		
	}
	
	@RequestMapping(value="RevokeFundRequest.htm", method = {RequestMethod.GET,RequestMethod.POST})
	public String revokeFundRequest(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		long empId = (Long) ses.getAttribute("EmployeeId");
		logger.info(new Date() + "Inside RevokeFundRequest.htm " + UserName);
		String url=null;
		try
		{
			String fundApprovalId=req.getParameter("fundApprovalIdRevoke");
			
			if(fundApprovalId == null)
			{
				return "redirect:/FundRequest.htm";
			}
			
			FundApprovalDto fundDto=new FundApprovalDto();
			fundDto.setFundApprovalId(fundApprovalId!=null ? Long.parseLong(fundApprovalId) : 0);
			fundDto.setCreatedBy(UserName);
			
			long status = fundApprovalService.revokeRecommendationDetails(fundDto,empId); 
			
			if(status > 0) {
				redir.addAttribute("resultSuccess", "Fund Request Revoked Successfully..&#128077;");
			}else {
				redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
			}
			
			url="redirect:/FundRequest.htm";
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside RevokeFundRequest.htm " + UserName, e);
			return "static/error";
		}
		return url;
		
	}
	// Delete Fund Request
	@RequestMapping(value="DeleteFundRequest.htm", method = {RequestMethod.GET,RequestMethod.POST})
	public String deleteFundRequest(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside DeleteFundRequest.htm " + UserName);
		String url=null;
		try
		{
			String fundApprovalId=req.getParameter("fundApprovalIdDelete");
			
			if(fundApprovalId == null)
			{
				return "redirect:/FundRequest.htm";
			}
			
			FundApprovalDto fundDto=new FundApprovalDto();
			fundDto.setFundApprovalId(fundApprovalId!=null ? Long.parseLong(fundApprovalId) : 0);
			fundDto.setCreatedBy(UserName);
			
			long status=fundApprovalService.deleteFundRequest(fundDto); 
			
			if(status > 0) {
				redir.addAttribute("resultSuccess", "Fund Request Deleted Successfully..&#128077;");
			}else {
				redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
			}
			
			url="redirect:/FundRequest.htm";
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside DeleteFundRequest.htm " + UserName, e);
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
			String action=req.getParameter("Action");
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
				List<Object[]> carryForwardList=fundApprovalService.getFundRequestCarryForwardDetails(fundApprovalDto,labCode,action);
				if(carryForwardList!=null && carryForwardList.size()>0)
				{
					req.setAttribute("carryForwardList", carryForwardList);
				}
			}
			
			req.setAttribute("budgetHeadId", budgetHeadId);
			req.setAttribute("budgetItemId", budgetItemId);
			req.setAttribute("action", action);
			
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
			String action=req.getParameter("Action");
			FundApprovalBackButtonDto fundApprovalDto=(FundApprovalBackButtonDto) ses.getAttribute("FundApprovalAttributes");
			int stringLength=1;
			if(demandItemOrderDetails!=null) 
			{
				stringLength=demandItemOrderDetails.length;
			}
			System.out.println("stringLength*****"+stringLength);
			
			String[] commitmentPayId = new String[stringLength],commitmentId = new String[stringLength],demandId=new String[stringLength],cfFundRequestId=new String[stringLength],itemNomenclature=new String[stringLength]
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
						System.out.println("demandItemOrderDetails[i]*****"+demandItemOrderDetails[i]);
						String serialNo=demandItemOrderDetails[i];
						
						String[] commitPayIds=req.getParameterValues("CommitmentPayId-"+serialNo);
						if(commitPayIds!=null && commitPayIds.length>0)
						{
							String commitmentPayIdDetails = Arrays.stream(commitPayIds).map(id -> id.split("#")[0]).collect(Collectors.joining(","));
							commitmentPayId[i]=commitmentPayIdDetails;
						}
						
						String[] demandIds=req.getParameterValues("BookingId-"+serialNo);
						System.out.println("demandIds******"+demandIds);
						if(demandIds!=null && demandIds.length>0)
						{
							String demandDetails = Arrays.stream(demandIds).map(id -> id.split("#")[0]).collect(Collectors.joining(","));
							System.out.println("demandDetails******"+demandDetails);
							demandId[i]=demandDetails;
						}
						
						String[] fundApprovalIds=req.getParameterValues("FundRequestId-"+serialNo);
						if(fundApprovalIds!=null && fundApprovalIds.length>0)
						{
							String fundRequestDetails = Arrays.stream(fundApprovalIds).map(id -> id.split("#")[0]).collect(Collectors.joining(","));
							cfFundRequestId[i]=fundRequestDetails;
						}
						System.out.println("demandId[i]*******"+demandId[i]);						
						fundRequestSerialNo[i]=serialNo;
						selectedFundRequestId[i]=req.getParameter("CFFundRequestId-"+serialNo);
						commitmentId[i]=req.getParameter("CFCommitmentId-"+serialNo);
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
			
			cogMonth.setActionType(action!=null ? action : null);
			
			if(selectedFundRequestId!=null)
			{
				cogMonth.setSelectedFundRequestId(selectedFundRequestId);
			}
			
			if(fundRequestSerialNo!=null)
			{
				cogMonth.setCarryForwardSerialNo(fundRequestSerialNo);
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
			
			if(commitmentId!=null) 
			{
				cogMonth.setCommitmentId(commitmentId);
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
				redir.addAttribute("resultSuccess", estimateTypeName+" Transfered Successfully ..&#128077;");
			}
			else
			{
				redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong ..!");
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
		String labCode = (ses.getAttribute("client_name")).toString();
		logger.info(new Date() + "Inside AddFundRequest.htm " + UserName);
		Long empId = (Long) ses.getAttribute("EmployeeId");
		try
		{
			req.setAttribute("rpbMemberType", fundApprovalService.getCommitteeMemberType(empId));
			req.setAttribute("ActionType", "add");	
			req.setAttribute("filesize", attach_file_size);
			req.setAttribute("officerList", masterService.getOfficersList(labCode));
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
			String initiationId=req.getParameter("selProposedProject");
			String budgetType=req.getParameter("budgetSel");
			String budget="0";
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
			
			if(action.equalsIgnoreCase("Add")) 
			{
				FundApproval fundApproval=new FundApproval();
				
				fundApproval.setFinYear(finYear.trim());
				fundApproval.setEstimateType(estimatedType.trim());
				fundApproval.setDivisionId(divisionId!=null ? Long.valueOf(divisionId) : 0);
				fundApproval.setInitiatingOfficer(empId!=null ? Long.valueOf(empId) : 0);
				 if("R".equalsIgnoreCase(estimatedType)) {
					 fundApproval.setReFbeYear(reYear.trim());
				    }
				    else if ("F".equalsIgnoreCase(estimatedType)) {
				     fundApproval.setReFbeYear(fbeYear.trim());
					}
				fundApproval.setBudgetType(budgetType.trim());
				fundApproval.setInitiationId(initiationId!=null ? Long.parseLong(initiationId) : 0);
				fundApproval.setProjectId(budget!=null ? Long.valueOf(budget) : 0);
				fundApproval.setBudgetHeadId(budgetHeadId!=null ? Long.valueOf(budgetHeadId) : 0);
				fundApproval.setBudgetItemId(budgetItemId!=null ? Long.valueOf(budgetItemId) : 0);
				fundApproval.setItemNomenclature(itemNomenclature.trim());
				fundApproval.setJustification(justification.trim());
				fundApproval.setRequisitionDate(DateTimeFormatUtil.getRegularToSqlDate(InitiationDate.trim()));
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
				fundApproval.setStatus("N");
				fundApproval.setSerialNo("0");	
				
				FundApprovalAttachDto attachDto=new FundApprovalAttachDto();
				attachDto.setFileName(filenames);
				attachDto.setFiles(FileAttach);
				attachDto.setCreatedBy(UserName);
				attachDto.setCreatedDate(LocalDateTime.now());
				
				 long status = fundApprovalService.AddFundRequestSubmit(fundApproval,attachDto); 
				
				 
				if(status > 0) {
					redir.addAttribute("resultSuccess", "Fund Request Added Successfully ..&#128077;");
				}else {
					redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
				}
			}
			else if(action.equalsIgnoreCase("Update")) 
			{
				FundApproval fundApproval=new FundApproval();
				
				fundApproval.setBudgetType(budgetType.trim());
				fundApproval.setInitiationId(initiationId!=null ? Long.parseLong(initiationId) : 0);
				fundApproval.setFundApprovalId(fundApprovalId!=null ? Long.valueOf(fundApprovalId) : 0);
				fundApproval.setFinYear(finYear.trim());
				fundApproval.setEstimateType(estimatedType.trim());
				fundApproval.setDivisionId(divisionId!=null ? Long.valueOf(divisionId) : 0);
				fundApproval.setInitiatingOfficer(empId!=null ? Long.valueOf(empId) : 0);
				fundApproval.setProjectId(budget!=null ? Long.valueOf(budget) : 0);
				fundApproval.setBudgetHeadId(budgetHeadId!=null ? Long.valueOf(budgetHeadId) : 0);
				fundApproval.setBudgetItemId(budgetItemId!=null ? Long.valueOf(budgetItemId) : 0);
				fundApproval.setItemNomenclature(itemNomenclature.trim());
				fundApproval.setJustification(justification.trim());
				fundApproval.setRequisitionDate(DateTimeFormatUtil.getRegularToSqlDate(InitiationDate.trim()));
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
				fundApproval.setStatus("N");
				
				FundApprovalAttachDto attachDto=new FundApprovalAttachDto();
				attachDto.setFileName(filenames);
				attachDto.setFiles(FileAttach);
				attachDto.setCreatedBy(UserName);
				attachDto.setCreatedDate(LocalDateTime.now());
			  
			    attachDto.setExistingAttachmentIds(existingAttachmentIds);
				
				 long status = fundApprovalService.EditFundRequestSubmit(fundApproval, attachDto); 
					
				if(status > 0) {
					redir.addAttribute("resultSuccess", "Fund Request Updated Successfully ..&#128077;");
				}else {
					redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
				}
			}
			else if(action.equalsIgnoreCase("Revise")) {
				
				long revisionCount=fundApprovalService.getRevisionListDetails(fundApprovalId,UserName);
				
				
				FundApproval exisitingFundApproval=fundApprovalService.getExisitingFundApprovalList(fundApprovalId);
				
				exisitingFundApproval.setRevisionCount(revisionCount);
				exisitingFundApproval.setInitiationId(initiationId!=null ? Long.parseLong(initiationId) : 0);
				exisitingFundApproval.setInitiatingOfficer(empId!=null ? Long.valueOf(empId) : 0);
				exisitingFundApproval.setProjectId(budget!=null ? Long.valueOf(budget) : 0);
				exisitingFundApproval.setBudgetHeadId(budgetHeadId!=null ? Long.valueOf(budgetHeadId) : 0);
				exisitingFundApproval.setBudgetItemId(budgetItemId!=null ? Long.valueOf(budgetItemId) : 0);
				exisitingFundApproval.setItemNomenclature(itemNomenclature!=null ? itemNomenclature.trim() : null);
				exisitingFundApproval.setJustification(justification!=null ? justification.trim() : null);
				exisitingFundApproval.setRequisitionDate(InitiationDate!=null ? DateTimeFormatUtil.getRegularToSqlDate(InitiationDate.trim()) : null);
				exisitingFundApproval.setFundRequestAmount(fundRequestAmount != null && !fundRequestAmount.trim().isEmpty() ? new BigDecimal(fundRequestAmount.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setApril(apr != null && !apr.trim().isEmpty() ? new BigDecimal(apr.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setMay(may != null && !may.trim().isEmpty() ? new BigDecimal(may.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setJune(jun != null && !jun.trim().isEmpty() ? new BigDecimal(jun.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setJuly(jul != null && !jul.trim().isEmpty() ? new BigDecimal(jul.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setAugust(aug != null && !aug.trim().isEmpty() ? new BigDecimal(aug.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setSeptember(sep != null && !sep.trim().isEmpty() ? new BigDecimal(sep.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setOctober(oct != null && !oct.trim().isEmpty() ? new BigDecimal(oct.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setNovember(nov != null && !nov.trim().isEmpty() ? new BigDecimal(nov.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setDecember(dec != null && !dec.trim().isEmpty() ? new BigDecimal(dec.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setJanuary(jan != null && !jan.trim().isEmpty() ? new BigDecimal(jan.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setFebruary(feb != null && !feb.trim().isEmpty() ? new BigDecimal(feb.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setMarch(mar != null && !mar.trim().isEmpty() ? new BigDecimal(mar.trim()) : BigDecimal.ZERO);
				exisitingFundApproval.setModifiedBy(UserName);
				exisitingFundApproval.setModifiedDate(LocalDateTime.now());
				exisitingFundApproval.setRemarks(exisitingFundApproval.getRemarks()!=null ? exisitingFundApproval.getRemarks().trim() : null);
				
				FundApprovalAttachDto attachDto=new FundApprovalAttachDto();
				attachDto.setFileName(filenames);
				attachDto.setFiles(FileAttach);
				attachDto.setCreatedBy(UserName);
				attachDto.setCreatedDate(LocalDateTime.now());
			  
			    attachDto.setExistingAttachmentIds(existingAttachmentIds);
				
				 long status = fundApprovalService.RevisionFundRequestSubmit(exisitingFundApproval, attachDto);
				
					
					if(status > 0) {
						redir.addAttribute("resultSuccess", "Fund Request Revised Successfully ..&#128077;");
					}else {
						redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
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
			redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
			return "redirect:/AddFundRequest.htm";
		}
		return "redirect:/FundRequest.htm";
		
	}
	
	@RequestMapping(value = "GetMasterFlowDetails.htm", method = RequestMethod.GET)
	public @ResponseBody String getMasterFlowDetails(HttpSession ses, HttpServletRequest req) throws Exception {
		Gson json = new Gson();
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside GetMasterFlowDetails.htm " + UserName);
		try {
				String fundRequestId = req.getParameter("fundRequestId");
				if(fundRequestId!=null) 
				{
					return json.toJson(fundApprovalService.getMasterFlowDetails(fundRequestId)); 
				}
				return null;
				
		} catch (Exception e) {
			logger.error(new Date() + "Inside GetMasterFlowDetails.htm " + UserName, e);
			e.printStackTrace();
			return null;
		}
	}
	
	@RequestMapping(value = "getProposedProjectDetails.htm", method = RequestMethod.GET)
	public @ResponseBody String getProposedProjectDetails(HttpSession ses, HttpServletRequest req) throws Exception {
		Gson json = new Gson();
		String UserName = (String) ses.getAttribute("Username");
		logger.info(new Date() + "Inside getProposedProjectDetails.htm " + UserName);
		try {
				return json.toJson(fundApprovalService.getProposedProjectDetails()); 
		} catch (Exception e) {
			logger.error(new Date() + "Inside getProposedProjectDetails.htm " + UserName, e);
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
		Long empId = (Long) ses.getAttribute("EmployeeId");
		logger.info(new Date() + "Inside EditFundRequest.htm " + UserName);
		try
		{
			Long fundApprovalId=Long.valueOf(req.getParameter("fundApprovalId"));
			Object[] getFundRequestObj=fundApprovalService.getFundRequestObj(fundApprovalId);
			List<Object[]> getFundRequestAttachList=fundApprovalService.getFundRequestAttachList(fundApprovalId);
			
			
			req.setAttribute("rpbMemberType", fundApprovalService.getCommitteeMemberType(empId));
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
	@RequestMapping(value="ReviseFundRequest.htm",method = {RequestMethod.GET,RequestMethod.POST})
	public String ReviseFundRequest(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	{
		String UserName = (String) ses.getAttribute("Username");
		Long empId = (Long) ses.getAttribute("EmployeeId");
		logger.info(new Date() + "Inside ReviseFundRequest.htm " + UserName);
		try
		{
			Long fundApprovalId=Long.valueOf(req.getParameter("fundApprovalId"));
			Object[] getFundRequestObj=fundApprovalService.getFundRequestObj(fundApprovalId);
			List<Object[]> getFundRequestAttachList=fundApprovalService.getFundRequestAttachList(fundApprovalId);
			
			
			req.setAttribute("rpbMemberType", fundApprovalService.getCommitteeMemberType(empId));
			req.setAttribute("attachList",getFundRequestAttachList);
			req.setAttribute("filesize", attach_file_size);
			req.setAttribute("FundRequestObj", getFundRequestObj);
			req.setAttribute("ActionType", "Revise");		
		}
		catch(Exception e)
		{
			e.printStackTrace();
			logger.error(new Date() + " Inside ReviseFundRequest.htm " + UserName, e);
			return "static/error";
		}
		return "fundapproval/addFundRequest";
		
	}
	
	@RequestMapping(value = "GetAttachmentDetailsAjax.htm", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public List<Map<String, Object>> GetAttachmentDetailsAjax(HttpServletRequest req) {
	    long fundApprovalId = Long.parseLong(req.getParameter("fundApprovalId"));
	    List<Map<String, Object>> resultList = new ArrayList<>();

	    try {
	    	List<Object[]> list = fundApprovalService.getAttachmentDetails(String.valueOf(fundApprovalId));

	        if (list != null) {
	            for (Object[] obj : list) {
	                Map<String, Object> map = new HashMap<>();
	                map.put("fundApprovalAttachId", obj[0]);
	                map.put("BudgetHead", obj[7]);
	                map.put("InitiatingOfficer", obj[14]); 
	                map.put("Designation", obj[15]);
	                map.put("DivisionShortName", obj[16]);
	                map.put("Division", obj[17]);
	                map.put("EstimateType", obj[1]);
	                map.put("REFBEYear", obj[4]);
	                map.put("ItemNomenculature", obj[10]);
	                map.put("Justification", obj[11]);
	                map.put("Status", obj[19]);
	                map.put("BudgetType", obj[20]);
	                map.put("SerialNo", obj[22]);
	                resultList.add(map);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultList;
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
		
		if(fundApprovalAttachId == null)
		{
			return;
		}
		
		Object[] attachmentdata=fundApprovalService.FundRequestAttachData(Long.valueOf(fundApprovalAttachId));
	    if (attachmentdata != null) 
	    {
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
		{	
				String fundApprovalAttachId=req.getParameter("attachid");
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
				String actionType=req.getParameter("ActionType");
				
				if ("Edit".equalsIgnoreCase(actionType)) {
					
				String fundApprovalAttachId=req.getParameter("attachid");
				String fundRequestId=req.getParameter("fundRequestId");
				int count=fundApprovalService.FundRequestAttachDelete(Long.valueOf(fundApprovalAttachId) );
				if (count > 0) {
					redir.addAttribute("resultSuccess", "Fund Request Attachment Deleted Successfully ..&#128077;");
			      } else {
					redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong ..!");
				  }
				
				redir.addAttribute("fundApprovalId", fundRequestId);
		     	return "redirect:/EditFundRequest.htm";
		     	
				}
				else if("Revise".equalsIgnoreCase(actionType)) {
					
					String fundApprovalAttachId=req.getParameter("attachid");
					String fundRequestId=req.getParameter("fundRequestId");
					int count=fundApprovalService.FundRequestAttachDelete(Long.valueOf(fundApprovalAttachId) );
					if (count > 0) {
						redir.addAttribute("resultSuccess", "Fund Request Attachment Deleted Successfully ..&#128077;");
				      } else {
						redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong ..!");
					  }
					
					redir.addAttribute("fundApprovalId", fundRequestId);
				return "redirect:/ReviseFundRequest.htm";
				
				}
				
				
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
				String fundFlowDetailsId=req.getParameter("FundFlowDetailsIdForward");
				String fundAction=req.getParameter("FundRequestAction");
				
				String divisionHead=req.getParameter("divisionHeadDetails");
				String[] rpbMember=req.getParameterValues("RPBMemberDetails");
				String[] subjectExpert=req.getParameterValues("SubjectExpertDetails");
				String rpbSecretary=req.getParameter("RPBMemberSecretaryDetails");
				String chairman=req.getParameter("chairmanDetails");
				System.out.println("fundAction********"+fundAction);
				
				if(fundRequestId==null || fundAction == null || fundFlowDetailsId == null ||
						divisionHead == null || rpbSecretary ==null || chairman == null)
				{
					redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
					return "redirect:/FundRequest.htm";
				}
				
				FundApprovalDto fundDto = new FundApprovalDto();
				
				fundDto.setFundApprovalId(fundRequestId !="" ? Long.parseLong(fundRequestId) :0);
				fundDto.setDivisionHeadId(divisionHead != "" ? Long.parseLong(divisionHead) : 0);
				fundDto.setMembersId(rpbMember);
				fundDto.setSubjectExpertsId(subjectExpert);
				fundDto.setSecretaryId(rpbSecretary != "" ? Long.parseLong(rpbSecretary) : 0);
				fundDto.setChairmanId(chairman != "" ? Long.parseLong(chairman) : 0);
				fundDto.setModifiedBy(UserName);
				fundDto.setModifiedDate(LocalDateTime.now());
				
//				fundApprovalData.setRc6(divisionHead!=null && divisionHead!="" ? Long.parseLong(divisionHead) : 0);
//				fundApprovalData.setRc6Role(divisionHeadRole!=null && divisionHeadRole!="" ? divisionHeadRole : null);
//				
//				fundApprovalData.setRc1(rpbMember1!=null && rpbMember1!="" ? Long.parseLong(rpbMember1) : 0);
//				fundApprovalData.setRc1Role(rpbMemberRole1!=null && rpbMemberRole1!="" ? rpbMemberRole1 : null);
//				
//				fundApprovalData.setRc2(rpbMember2!=null && rpbMember2!="" ? Long.parseLong(rpbMember2) : 0);
//				fundApprovalData.setRc2Role(rpbMemberRole2!=null && rpbMemberRole2!="" ? rpbMemberRole2 : null);
//				
//				fundApprovalData.setRc3(rpbMember3!=null && rpbMember3!="" ? Long.parseLong(rpbMember3) : 0);
//				fundApprovalData.setRc3Role(rpbMemberRole3!=null && rpbMemberRole3!="" ? rpbMemberRole3 : null);
//				
//				fundApprovalData.setRc4(subjectExpert!=null && subjectExpert!="" ? Long.parseLong(subjectExpert) : 0);
//				fundApprovalData.setRc4Role(subjectExpertRole!=null && subjectExpertRole!="" ? subjectExpertRole : null);
//				
//				fundApprovalData.setRc5(rpbSecretary!=null && rpbSecretary!="" ? Long.parseLong(rpbSecretary) : 0);
//				fundApprovalData.setRc5Role(rpbMemberSecretaryRole!=null && rpbMemberSecretaryRole!="" ? rpbMemberSecretaryRole : null);
//				
//				fundApprovalData.setApprovingOfficer(chairman!=null && chairman!="" ? Long.parseLong(chairman) : 0);
//				fundApprovalData.setApprovingOfficerRole(chairmanRole!=null && chairmanRole!="" ? chairmanRole : null);
				
				long status = fundApprovalService.fundRequestForward(fundDto,flowMasterId,empId,fundAction,fundFlowDetailsId); 
				
				String message = "";
				if(fundAction.equalsIgnoreCase("F"))
				{
					message = "Forwarded";
				}
				else if(fundAction.equalsIgnoreCase("RF"))
				{
					message = "Re-Forwarded";
				}
				
				if(status > 0) 
				{
					redir.addAttribute("resultSuccess", "Fund Request Successfully "+ message +"...&#128077;");
				}
				else 
				{
					redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
				logger.error(new Date() + " Inside FundApprovalForward.htm " + UserName, e);
				redir.addAttribute("resultFailure", "OOPS &#128551; Something Went Wrong..!");
				return "redirect:/FundRequest.htm";
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
				String amountFormat = req.getParameter("AmountFormat");
				int RupeeValue=0;
				
				String committeeMember=fundApprovalService.getCommitteeMemberType(Long.valueOf(empId));

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
					status="NA";
				}
				
				if(Long.valueOf(budgetHeadId)==0) {
					budgetItemId="0";
				}
				
				if (amountFormat == null || amountFormat.isEmpty()) {
				    if ("A".equalsIgnoreCase(loginType) 
				        || "CS".equalsIgnoreCase(committeeMember) 
				        || "CC".equalsIgnoreCase(committeeMember)) {
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
				    
				List<Object[]> RequisitionList=fundApprovalService.getFundReportList(FinYear, DivisionId, estimateType, loginType, empId, projectId, budgetHeadId, budgetItemId, fromCost, toCost, status,committeeMember,String.valueOf(RupeeValue));
				List<Object[]> DivisionList=masterService.getDivisionList(labCode,empId,loginType,committeeMember);
				String MemberType=fundApprovalService.getCommitteeMemberType(Long.valueOf(empId));
				
				req.setAttribute("RequisitionList", RequisitionList);
				req.setAttribute("DivisionList", DivisionList);
				req.setAttribute("CurrentFinYear", DateTimeFormatUtil.getCurrentFinancialYear());
				req.setAttribute("ExistingbudgetHeadId", budgetHeadId);
				req.setAttribute("ExistingbudgetItemId", budgetItemId);
				req.setAttribute("ExistingfromCost", fromCost);
				req.setAttribute("ExistingtoCost", toCost);
				req.setAttribute("Existingstatus", status);
				req.setAttribute("committeeMember", committeeMember);
				req.setAttribute("amountFormat", amountFormat);
				req.setAttribute("MemberType", MemberType);
				
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
				String amountFormat = req.getParameter("AmountFormat");
				int RupeeValue=0;
			
				String committeeMember=fundApprovalService.getCommitteeMemberType(Long.valueOf(empId));
				
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
				
			    if(labLogo.getLabLogoAsBase64()!=null) {

				       req.setAttribute("LabLogo", labLogo.getLabLogoAsBase64());
				    }
			    
			    if("R".equalsIgnoreCase(estimateType)) {
			    	ReOrFbeYear=reYear;
			    	ReOrFbe="R";
			    }
			    else if ("F".equalsIgnoreCase(estimateType)) {
			    	ReOrFbeYear=fbeYear;
			    	ReOrFbe="F";
				}
			    
			    if (amountFormat == null || amountFormat.isEmpty()) {
			        if ("A".equalsIgnoreCase(loginType) 
			            || "CS".equalsIgnoreCase(committeeMember) 
			            || "CC".equalsIgnoreCase(committeeMember)) {
			            amountFormat = "L"; 
			        } else {
			            amountFormat = "R"; 
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
			    
				List<Object[]> RequisitionList=fundApprovalService.getFundReportList(FinYear, DivisionId, estimateType, loginType, empId, projectId, budgetHeadId, budgetItemId, fromCost, toCost, status, committeeMember,String.valueOf(RupeeValue));
				
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
			    req.setAttribute("amountFormat", amountFormat);
			    
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
					status="NA";
				}
				
				if(Long.valueOf(budgetHeadId)==0) {
					budgetItemId="0";
				}
				
				 
				if (amountFormat == null || amountFormat.isEmpty()) {
				    if ("A".equalsIgnoreCase(loginType) 
				        || "CH".equalsIgnoreCase(memberType) 
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
			    
				List<Object[]> estimateTypeParticularDivList=fundApprovalService.estimateTypeParticularDivList(divisionId, estimateType,FinYear,loginType,empId,budgetHeadId,budgetItemId,fromCost,toCost,status,memberType,RupeeValue);
				
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
			String empDivisionCode= (String)ses.getAttribute("EmployeeDivisionCode");
			String empDivisionName= (String)ses.getAttribute("EmployeeDivisionName");
			String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
			try
			{	
				String PrintAction= req.getParameter("PrintAction");
				Long divisionId=Long.valueOf(req.getParameter("divisionId"));
				String estimateType=req.getParameter("estimateType");
				String FromYear=req.getParameter("FromYear");
				String ToYear=req.getParameter("ToYear");
				String status=req.getParameter("approvalStatus");
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
			    
			    String MemberType=fundApprovalService.getCommitteeMemberType(Long.valueOf(empId));

			    
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
				
				List<Object[]> estimateTypeParticularDivList=fundApprovalService.estimateTypeParticularDivList(divisionId, estimateType,FinYear,loginType,empId,budgetHeadId,budgetItemId,fromCost,toCost,status,memberType,RupeeValue);
				
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
				req.setAttribute("MemberType", MemberType);
				
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
		
		@RequestMapping(value = "HeaderHelpAction.htm", method = RequestMethod.GET)
		public String headerHelpAction(HttpServletRequest req, HttpSession ses, HttpServletResponse res) throws Exception {
			String UserId = (String) ses.getAttribute("Username");
			logger.info(new Date() +"Inside HeaderHelpAction.htm "+UserId);		
			try {
				
			}
			catch (Exception e) {
				e.printStackTrace();
				logger.error(new Date() +" Inside HeaderHelpAction.htm "+UserId, e);
			}
			return "fundapproval/rpbuserguide";
		}
		
}
