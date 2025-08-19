package com.vts.rpb.cfg;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.vts.rpb.authenticate.LoginSuccessHandler;
import com.vts.rpb.authenticate.UserLogoutHandler;
import com.vts.rpb.authenticate.UserLogoutSuccessHandler;
import com.vts.rpb.authenticate.userDetailsImp;


@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfiguration 
{
	 @Value("${LabCode}")
	 private String labCode;
	 
	 @Autowired
	 private LoginSuccessHandler loginSuccessHandler;
	    
     @Autowired
     private UserLogoutSuccessHandler userLogoutSuccessHandler;
	 
	 @Bean
	 SecurityFilterChain filterChain(HttpSecurity http) throws Exception 
	 {
        http.authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/login", "/RPB", "/webjars/**", "/resources/**", "/view/**").permitAll()
                .anyRequest().authenticated()
            )
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .addLogoutHandler(userLogoutHandler())
                .logoutSuccessHandler(userLogoutSuccessHandler)
            )
            .oauth2Login(oauth -> oauth.successHandler(loginSuccessHandler))
            .headers(headers -> headers.frameOptions().sameOrigin())
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
            	    .invalidSessionUrl("/sessionExpired")
            	    .sessionConcurrency(concurrency -> concurrency
        	        .maximumSessions(5)
        	        .maxSessionsPreventsLogin(false)
            	    ));

	        return http.build();
	    }
		
		@Bean
		AuthenticationProvider authenticationProvider() throws Exception 
		{
			DaoAuthenticationProvider daoAuthenticationProvider = new DaoAuthenticationProvider();
			daoAuthenticationProvider.setUserDetailsService(userDetailsService());
			daoAuthenticationProvider.setPasswordEncoder(passwordEncoder());
			return daoAuthenticationProvider;
		}
		
		@Bean
		public AuthenticationManager authenticationManager(HttpSecurity http, PasswordEncoder passwordEncoder, UserDetailsService userDetailsService) throws Exception 
		{
		    return http.getSharedObject(AuthenticationManagerBuilder.class)
		               .userDetailsService(userDetailsService)
		               .passwordEncoder(passwordEncoder)
		               .and()
		               .build();
		}
		
		@Bean
		UserDetailsService userDetailsService() 
		{
			return new userDetailsImp();
		}
		
		@Bean
		@Primary
		PasswordEncoder passwordEncoder() throws Exception
		{
			return new BCryptPasswordEncoder();
		}
		
		@Bean
		LogoutHandler userLogoutHandler() 
		{
			return new UserLogoutHandler();
		}
}
