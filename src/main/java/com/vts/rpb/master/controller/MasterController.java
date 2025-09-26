package com.vts.rpb.master.controller;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.vts.rpb.fundapproval.controller.FundApprovalController;
import com.vts.rpb.fundapproval.modal.CommitteeMembers;
import com.vts.rpb.master.service.MasterService;
import com.vts.rpb.utils.DateTimeFormatUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class MasterController 
{
	private static final Logger logger = LogManager.getLogger(FundApprovalController.class);
	
	@Autowired
	private MasterService masterService;
	
	@RequestMapping(value ="SelectAllemployeeAjax.htm")
	public @ResponseBody String selectAllemployeeAjax(HttpServletRequest req, HttpSession ses, RedirectAttributes redir) throws Exception{
		String UserName =(String)ses.getAttribute("Username");
		String labCode = (ses.getAttribute("client_name")).toString();
		logger.info(new Date() +"Inside SelectAllemployeeAjax.htm "+UserName);	
		List<Object[]> EmployeeList =null;
		Gson json = new Gson();
		try {            
				EmployeeList = masterService.getAllOfficersList(labCode);
		}catch (Exception e){
			logger.error(new Date() +"Inside SelectAllemployeeAjax.htm "+UserName ,e);
			e.printStackTrace();
		}
		 return json.toJson(EmployeeList);   
	}
	
	@RequestMapping(value ="GetUserNameListByDivisionId.htm", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String GetUserNameListByDivisionId(HttpServletRequest req, HttpServletResponse res, HttpSession ses, RedirectAttributes redir) throws Exception {
	    String UserName = (String) ses.getAttribute("Username");
	    logger.info(new Date() + "Inside GetUserNameListByDivisionId.htm " + UserName);
	    List<Object[]> UserNameListByDivisionId = null;
	    Gson json = new Gson();
	    try {
	        String DivisionId = req.getParameter("DivisionId");
	        UserNameListByDivisionId = masterService.getAllEmployeeDetailsByDivisionId(DivisionId);
	    } catch (Exception e) {
	        logger.error(new Date() + "Inside GetUserNameListByDivisionId.htm " + UserName, e);
	        e.printStackTrace();
	    }
	    return json.toJson(UserNameListByDivisionId);
	}
	
	//CommitteMaster.htm
	   @RequestMapping(value="CommitteMaster.htm",method = {RequestMethod.GET,RequestMethod.POST})
	   	public String CommitteMaster(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
	   	{
	   		String UserName = (String) ses.getAttribute("Username");
	   		logger.info(new Date() + "Inside CommitteMaster.htm " + UserName);
	   		try
	   		{
	   			
	   			req.setAttribute("CommitteMaster", masterService.CommitteeMasterList());
	   			
	   			
	   		}catch(Exception e) {
	   			e.printStackTrace();
	   		}
	   		
	   		return "master/committeeMaster";
	   	}
	   
	   
		@RequestMapping(value ="EmployeeListAjax.htm")
		public @ResponseBody String ScheduleListAjax(HttpServletRequest req, HttpSession ses, RedirectAttributes redir) throws Exception{
		
			String UserName =(String)ses.getAttribute("Username");
			logger.info(new Date() +"Inside EmployeeListAjax.htm "+UserName);	
			String labCode = (ses.getAttribute("client_name")).toString();
			Gson json = new Gson();
			List<Object[]>getAllOfficersList=null;
			
			try {
				getAllOfficersList=masterService.getOfficersListWithoutCommitteeMembers(labCode);
			}catch (Exception e) {
				e.printStackTrace();
			}
			
			return json.toJson(getAllOfficersList);
	     }
		
		
		  @RequestMapping(value="committeMasterAdd.htm",method = {RequestMethod.GET,RequestMethod.POST})
		   	public String CommitteMasterAdd(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
		   	{
		   		String UserName = (String) ses.getAttribute("Username");
		   		logger.info(new Date() + "Inside committeMasterAdd.htm " + UserName);
		   		try
		   		{
		   			CommitteeMembers cm=new CommitteeMembers();
		   			cm.setMemberType(req.getParameter("MemberType"));
		   			cm.setEmpId(Long.parseLong(req.getParameter("Employee")));
		   			cm.setFromDate(DateTimeFormatUtil.getRegularToSqlDate(req.getParameter("FromDate")));
		   			cm.setToDate(DateTimeFormatUtil.getRegularToSqlDate(req.getParameter("ValidDate")));
		   			cm.setCreatedBy(UserName);
		   			cm.setCreatedDate(LocalDateTime.now());
		   			
		   			long count=masterService.saveCommitteeMembers(cm);
		   			
		   			if(count > 0) {
						redir.addAttribute("resultSuccess", "Committee 	Master Add Successfully");
					}else {
						redir.addAttribute("resultFailure", "Committee 	Master Add Unsuccessful");
					}
		   			
		   		}catch(Exception e) {
		   			e.printStackTrace();
		   		}
		   		
		   		return "redirect:/CommitteMaster.htm";
		   	}
		  
		  
		  //committeMasterEdit.htm
		  @RequestMapping(value="committeMasterEdit.htm",method = {RequestMethod.GET,RequestMethod.POST})
		   	public String CommitteMasterEdit(HttpServletRequest req,HttpServletResponse resp,HttpSession ses,RedirectAttributes redir) throws Exception
		   	{
		   		String UserName = (String) ses.getAttribute("Username");
		   		System.out.println("----");
		   		logger.info(new Date() + "Inside committeMasterEdit.htm " + UserName);
		   		try
		   		{
		   			CommitteeMembers cm=new CommitteeMembers();
		   			cm.setCommitteeMemberId(Long.parseLong(req.getParameter("CommiteeMemberId")));
		   			cm.setMemberType(req.getParameter("MemberType"));
		   			cm.setEmpId(Long.parseLong(req.getParameter("Employee")));
		   			cm.setFromDate(DateTimeFormatUtil.getRegularToSqlDate(req.getParameter("FromDate")));
		   			cm.setToDate(DateTimeFormatUtil.getRegularToSqlDate(req.getParameter("ValidDate")));
		   			cm.setModifiedBy(UserName);
		   			cm.setModifiedDate(LocalDateTime.now());
		   			
		   			long count=masterService.EditCommitteeMembers(cm);
		   			
		   			if(count > 0) {
						redir.addAttribute("resultSuccess", "Committee 	Master Edit Successfully");
					}else {
						redir.addAttribute("resultFailure", "Committee 	Master Edit Unsuccessful");
					}
		   			
		   		}catch(Exception e) {
		   			e.printStackTrace();
		   		}
		   		
		   		return "redirect:/CommitteMaster.htm";
		   	}
		
	
}
