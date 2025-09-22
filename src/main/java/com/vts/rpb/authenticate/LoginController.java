package com.vts.rpb.authenticate;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.vts.rpb.fundapproval.service.FundApprovalService;
import com.vts.rpb.login.service.LoginService;
import com.vts.rpb.master.service.MasterService;
import com.vts.rpb.utils.DateTimeFormatUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	
	@Autowired
	MasterService masterService;
	
	@Autowired
	LoginService loginService;
	
	@Autowired
	FundApprovalService fundApprovalService;
	
	private static final Logger logger=LogManager.getLogger(AuthenticationController.class);
	
	   @RequestMapping(value = {"MainDashBoard.htm"}, method = RequestMethod.GET)
	   public String dashBoardPage(HttpServletRequest req,HttpSession ses) throws Exception 
	   {	
		   String labCode = (ses.getAttribute("client_name")).toString();
		   String loginType= (String)ses.getAttribute("LoginType");
		   String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
		   Long divisionId =(Long) ses.getAttribute("Division");
		   String amountFormat = req.getParameter("AmountFormat");
		   String FromYear=req.getParameter("FromYear");
		   String ToYear=req.getParameter("ToYear");
		   int RupeeValue=0;
		  
		    if (amountFormat == null || amountFormat.isEmpty()) {
		        amountFormat = "L"; // default
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
			
			String memberType=fundApprovalService.getCommitteeMemberType(Long.valueOf(empId));
			if("CS".equalsIgnoreCase(memberType) || "CC".equalsIgnoreCase(memberType) || "A".equalsIgnoreCase(loginType)) {
				divisionId=-1L;
			}
		    
		    List<Object[]> DivisionList=masterService.getDivisionList(labCode,empId,loginType,memberType);
		    DivisionList.forEach(row -> System.out.println(Arrays.toString(row)));
		    System.out.println("----------------------------------------");
			List<Object[]> DivisionDetailsList=loginService.getDivisionDetailsList(RupeeValue,FinYear,divisionId);
			DivisionDetailsList.forEach(row -> System.out.println(Arrays.toString(row)));
			
			String memberLoginType=fundApprovalService.getCommitteeMemberCurrentStatus(String.valueOf(empId));
			ses.setAttribute("memberLoginType", memberLoginType);
		   req.setAttribute("DivisionList", DivisionList);
		   req.setAttribute("DivisionDetailsList", DivisionDetailsList);
		   req.setAttribute("amountFormat", amountFormat);
		   req.setAttribute("fromYear", FromYear);
		   req.setAttribute("toYear", ToYear);
		   return "dashboard/homePage";
	   }
	   
		@RequestMapping(value ="ApprovalCount.htm",method=RequestMethod.GET)
		public @ResponseBody String ApprovalCount(HttpSession ses , HttpServletRequest req)throws Exception
		{
			 String Username = (String) ses.getAttribute("Username");
			 String empId = ((Long) ses.getAttribute("EmployeeId")).toString();
		     logger.info(new Date() + "Inside ApprovalCount.htm " + Username);
			Gson json = new Gson();
			try {  
				String committeeMember=fundApprovalService.getCommitteeMembersLinked(Long.valueOf(empId));
				List<Object[]>  result = fundApprovalService.committeeMemberFundApprovalCount(committeeMember,empId);
				return json.toJson(result);   //return to Ajax Where You Call Hide.htm
			    }catch (Exception e){
				e.printStackTrace();
			    }
			    return null;
		}
}
