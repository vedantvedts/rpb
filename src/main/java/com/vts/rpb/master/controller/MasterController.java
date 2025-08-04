package com.vts.rpb.master.controller;

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
import com.vts.rpb.master.service.MasterService;

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
		logger.info(new Date() +"Inside SelectAllemployeeAjax.htm "+UserName);	
		List<Object[]> EmployeeList =null;
		Gson json = new Gson();
		try {            
				EmployeeList = masterService.getAllOfficersList();
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
}
