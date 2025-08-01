package com.vts.rpb.authenticate;

import java.io.IOException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class UserLogoutSuccessHandler implements LogoutSuccessHandler {
	
    @Value("${rpbLogOut}")
    private String rpbLogOut;
    
    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response,Authentication authentication) throws IOException 
    {
    	try {
	          response.sendRedirect(rpbLogOut);
        } catch (Exception e) {
            response.sendRedirect("/login?logout"); // fallback
        }
    }
}
