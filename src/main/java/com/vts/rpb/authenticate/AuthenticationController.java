package com.vts.rpb.authenticate;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthenticationController 
{
	private static final Logger logger=LogManager.getLogger(AuthenticationController.class);
	
	   @RequestMapping(value = {"/"}, method = RequestMethod.GET)
	    public String rpbFundApproval(HttpServletRequest req,HttpSession ses) throws Exception 
	    {
	    	return "redirect:/RpbFundApprovalAuthenticate";
	    }
	   
	   @RequestMapping(value = {"MainDashBoard.htm"}, method = RequestMethod.GET)
	   public String dashBoardPage(HttpServletRequest req,HttpSession ses) throws Exception 
	   {
		   return "dashboard/homePage";
	   }
	   
	   @RequestMapping(value = "getModuleId.htm", method = RequestMethod.GET)
		public @ResponseBody void getModuleId(HttpServletRequest req, HttpSession ses) throws Exception {
			
			String mainModuleValue = (String)req.getParameter("mainModuleValue");	
			if(mainModuleValue !=null) {
				ses.setAttribute("MainModuleId", mainModuleValue);
			}
			else {
				ses.setAttribute("MainModuleId", "0");
			}
		}

		/*******************************************Developer Tools Settings*********************************************************/
		@RequestMapping(value = "UpdateDeveloperToolsStatus.htm")
		public @ResponseBody String UpdateDeveloperToolsStatus(HttpServletRequest req, HttpSession ses) throws Exception {
			String status = req.getParameter("status");
			Gson json = new Gson();
			try {
				long parseStatus=0;
					if(status!=null && !status.equalsIgnoreCase("null"))
					{
						ses.setAttribute("DeveloperToolsStatus", status);
						parseStatus=Long.parseLong(status);
					}
				return json.toJson(parseStatus);	
			}
			catch (Exception e) {
				e.printStackTrace();
				return null;
			}
		}

	
}
