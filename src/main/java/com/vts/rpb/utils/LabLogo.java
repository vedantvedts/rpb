package com.vts.rpb.utils;

import java.io.FileNotFoundException;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class LabLogo {
	
	@Value("${ApplicationFilesDrive}")
	private  String applicationFilesDrive;
	
	@Value("${headerLogo}")
	private  String headerlogo;
	
	@Value("${LabCode}")
	private  String LabCode;
	
	public  String getLabLogoAsBase64() throws Exception {
      
		
		Path logoPath = Paths.get(applicationFilesDrive,"images","lablogos",headerlogo);
		
		try {
			return Base64.getEncoder().encodeToString(FileUtils.readFileToByteArray(logoPath.toFile()));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			System.err.println("File Not Found at Path " + logoPath);
			return null;
		}
	}
	
	//method for the geting the image for Covering Letter

	public  String getImageAsBase64(String imageName) throws Exception {
      
		Path logoPath = Paths.get(applicationFilesDrive,"images","lablogos",imageName);
		try {
			 return Base64.getEncoder().encodeToString(FileUtils.readFileToByteArray(logoPath.toFile()));
			 } 
		catch (FileNotFoundException e) {
			e.printStackTrace();
			System.err.println("File Not Found at Path " + logoPath);
			return null;
		}
	}
	

}
