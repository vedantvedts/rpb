package com.vts.rpb.authenticate;

import java.io.IOException;
import java.net.InetAddress;
import java.util.Arrays;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.vts.rpb.login.service.LoginService;
import com.vts.rpb.master.dao.MasterDao;
import com.vts.rpb.master.modal.Login;
import com.vts.rpb.master.service.MasterService;


@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler 
{
	@Value("${LabCode}")
	private String labcode;
	
	@Autowired
    private LoginRepository loginRepository;
	
	@Autowired
	private MasterDao masterDao;
	
	@Autowired
	private MasterService masterService;
	
	@Autowired
	private LoginService authService;
	
    @Override
    public void onAuthenticationSuccess(HttpServletRequest req,HttpServletResponse response, Authentication authentication) throws IOException  
    {
    	HttpSession ses = req.getSession();
    	String validUrl="";
    	try 
    	{
    		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    		Login login = loginRepository.findByUserName(auth.getName());	

			if(login!=null && login.getLoginId() > 0)
			{
				 Object[] EmpDetails = masterDao.getUserFullDetails(login.getLoginId()); 
				 
				 if(EmpDetails != null && EmpDetails.length > 0) {
					 ses.setAttribute("LoginId", login.getLoginId()); 
		    	      ses.setAttribute("Division",EmpDetails[7]); 	
		    	      ses.setAttribute("LoginType", login.getLoginType()); 
		    	      ses.setAttribute("EmployeeId", login.getEmpId()); 
		    	      ses.setAttribute("FormRole", login.getFormRoleId()); 
		    	      ses.setAttribute("MainModuleList", authService.getMainModuleList(login.getLoginType())); 
		    	      ses.setAttribute("SubModuleList", authService.getSubModuleList(login.getLoginType())); 
		    	      ses.setAttribute("Username",auth.getName());
		    	      ses.setAttribute("EmployeeNo", EmpDetails[2]); 
		    	      ses.setAttribute("EmployeeName", EmpDetails[0]); 
		    	      ses.setAttribute("EmployeeDesign", EmpDetails[4]); 
		    	      ses.setAttribute("EmployeeDivisionCode", EmpDetails[5]); 
		    	      ses.setAttribute("EmployeeDivisionName", EmpDetails[6]); 
		    	      ses.setAttribute("client_name", labcode);
		    	      ses.setAttribute("LoginTypeName", masterService.FormRoleName(login.getLoginType()));
		    			
		    		validUrl=req.getContextPath() + "/MainDashBoard.htm";
				 }
				 else
				 {
					 validUrl=req.getContextPath() + "/login";
				 }
	    	     
			}
			else
			{
				validUrl=req.getContextPath() + "/login";
			}
      
     }catch (Exception e) {
    	e.printStackTrace();
     }
   	 
   	 response.sendRedirect(validUrl);
   }
}
