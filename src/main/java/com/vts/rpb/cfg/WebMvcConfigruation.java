package com.vts.rpb.cfg;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Configuration
@ComponentScan(basePackages = "com.vts.*")
public class WebMvcConfigruation {

	 @Bean
	    public BCryptPasswordEncoder passwordencoder(){
	     return new BCryptPasswordEncoder();
	    }
	 
	 
}
