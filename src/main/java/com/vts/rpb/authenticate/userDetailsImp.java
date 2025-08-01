package com.vts.rpb.authenticate;

import java.net.InetAddress;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.vts.rpb.master.dao.MasterDao;
import com.vts.rpb.master.modal.AuditStamping;
import com.vts.rpb.master.modal.Login;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class userDetailsImp implements UserDetailsService
{
	private static final String LOCALHOST_IP = "0:0:0:0:0:0:0:1";

	@Autowired
    private LoginRepository loginRepository;
	
	@Autowired
    private HttpServletRequest request;
	
	@Autowired
	private HttpSession session;
	
	@Autowired
	MasterDao masterDao;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Login login = loginRepository.findByUserName(username);
		if(login!=null && login.getIsActive()==1)
		{
			Set<GrantedAuthority> grantedAuthorities = new HashSet<>();
			String ipAddress = getClientIpAddress();

            try {
                AuditStamping stamping = new AuditStamping();
                stamping.setLoginId(login.getLoginId());
                stamping.setUserName(login.getUserName());
                stamping.setLoginDate(LocalDate.now());
                stamping.setLoginDateTime(LocalDateTime.now());
                stamping.setIpAddress(ipAddress);

                long auditStampId=masterDao.insertAuditStampingDetails(stamping);
                if(auditStampId>0)
                {
                	session.setAttribute("AuditStampingId", auditStampId);
                }
                
            } catch (Exception e) {
                e.printStackTrace();
            }

            return new org.springframework.security.core.userdetails.User(login.getUserName(),login.getPassword(),grantedAuthorities);
        } else {
            throw new UsernameNotFoundException("Username not found or inactive");
        }
	}
	
	 private String getClientIpAddress() {
	        try {
	            String ip = request.getRemoteAddr();
	            if (LOCALHOST_IP.equalsIgnoreCase(ip)) {
	                InetAddress localHost = InetAddress.getLocalHost();
	                return localHost.getHostAddress();
	            }
	            return ip;
	        } catch (Exception e) {
	            e.printStackTrace();
	            return "Not Available";
	        }
	    }

}
