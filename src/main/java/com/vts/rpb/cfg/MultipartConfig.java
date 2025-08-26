package com.vts.rpb.cfg;

import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.unit.DataSize;

import jakarta.servlet.MultipartConfigElement;

@Configuration
public class MultipartConfig {

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        
        // Use DataSize instead of String for max file size and max request size
        factory.setMaxFileSize(DataSize.ofMegabytes(500));  // 100MB
        factory.setMaxRequestSize(DataSize.ofMegabytes(500));  // 100MB
        factory.setFileSizeThreshold(DataSize.ofMegabytes(2));  // 2MB threshold for memory
     
       
        // Return the multipart configuration
        return factory.createMultipartConfig();
    }
}
