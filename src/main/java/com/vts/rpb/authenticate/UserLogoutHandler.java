package com.vts.rpb.authenticate;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutHandler;

import com.vts.rpb.master.dao.MasterDao;
import com.vts.rpb.master.modal.AuditStamping;

public class UserLogoutHandler  implements LogoutHandler  
{
	@Autowired
	private MasterDao masterDao;

	@Override
	public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) 
	{
		 HttpSession ses=request.getSession();
		 try 
		 {
	       	 long auditStampingId = ses.getAttribute("AuditStampingId")!=null ? (long) ses.getAttribute("AuditStampingId") : 0;
	       	 if(auditStampingId > 0) 
	       	 {
	       		AuditStamping auditDetails=masterDao.getAuditPatchDetails(auditStampingId);
	       		auditDetails.setLogoutDateTime(LocalDateTime.now());
	       		auditDetails.setLogoutType("L");
	       		masterDao.updateLoginStampingDetails(auditDetails);
	       	 }
       	 }
       	 catch (Exception e) 
		 {
			 e.printStackTrace();
		 }	
	}
	
	
}
