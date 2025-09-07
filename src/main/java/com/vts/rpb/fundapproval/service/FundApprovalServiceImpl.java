package com.vts.rpb.fundapproval.service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.function.Consumer;
import java.util.stream.Collectors;

import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.vts.rpb.fundapproval.dto.BudgetDetails;
import com.google.gson.JsonElement;
import com.vts.rpb.fundapproval.dao.FundApprovalDao;
import com.vts.rpb.fundapproval.dto.FundApprovalAttachDto;
import com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto;
import com.vts.rpb.fundapproval.dto.FundApprovalDto;
import com.vts.rpb.fundapproval.dto.FundRequestCOGDetails;
import com.vts.rpb.fundapproval.modal.FundApproval;
import com.vts.rpb.fundapproval.modal.FundApprovalAttach;
import com.vts.rpb.fundapproval.modal.FundApprovalTrans;
import com.vts.rpb.fundapproval.modal.FundApprovedRevision;
import com.vts.rpb.fundapproval.modal.LinkedCommitteeMembers;

@Service
public class FundApprovalServiceImpl implements FundApprovalService 
{
	@Autowired
	FundApprovalDao fundApprovalDao;

	@Value("${ApplicationFilesDrive}")
	String uploadpath;
	
	@Value("${Attach_File_Size}")
	String attach_file_size;
	
	@Autowired
	private Environment env;
	
	private static final Logger logger=LogManager.getLogger(FundApprovalServiceImpl.class);
	
	@Override
	public List<Object[]> getFundApprovalList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId,String committeeMember) throws Exception {
		return fundApprovalDao.getFundApprovalList(finYear,divisionId,estimateType,loginType,empId,projectId,committeeMember);
	}
	
	@Override
	public long AddFundRequestSubmit(FundApproval fundApproval, FundApprovalAttachDto attachDto) throws Exception
	{	
		 long FundApprovalId=fundApprovalDao.AddFundRequestSubmit(fundApproval);
		 	if(FundApprovalId >0) {
		 		
		 		String filePath = Paths.get(uploadpath, "FundApproval",String.valueOf(FundApprovalId)).toString();
		 		String pathDB=Paths.get("FundApproval",String.valueOf(FundApprovalId)).toString();
		 		
		 		File filepath = new File(filePath);
				long ret = 0;
				if (!filepath.exists()) {
					filepath.mkdirs();
				}
				
				for (int i = 0; i < attachDto.getFiles().length; i++) {
					if (!attachDto.getFiles()[i].isEmpty()) {
						FundApprovalAttach modal = new FundApprovalAttach();
						modal.setFundApprovalId(FundApprovalId);
						modal.setFileName(attachDto.getFileName()[i].trim());
						modal.setOriginalFileName(attachDto.getFiles()[i].getOriginalFilename().trim());
			
						modal.setCreatedBy(attachDto.getCreatedBy());
						modal.setCreatedDate(LocalDateTime.now());
			
						String fullFilePath = filePath +  modal.getOriginalFileName();
			
						File file = new File(fullFilePath);
						int count = 0;
						while (true) {
							file = new File(fullFilePath);
			
							if (file.exists()) {
								count++;
								fullFilePath = filePath;
							} else {
								if (count > 0) {
									modal.setOriginalFileName(FilenameUtils.getBaseName(modal.getOriginalFileName()) + "-"
											+ count + "." + FilenameUtils.getExtension(modal.getOriginalFileName()));
								}
								break;
							}
						}
			
						modal.setPath(pathDB);
			
						  SaveFile(filePath, modal.getOriginalFileName(), attachDto.getFiles()[i]);
						  ret = fundApprovalDao.AddFundRequestAttachSubmit(modal);
						 
			
					}
				}
				
				FundApprovalTrans transModal=new FundApprovalTrans();
				transModal.setFundApprovalId(fundApproval.getFundApprovalId());
				transModal.setRcStausCode("INITIATION");
				transModal.setRemarks(fundApproval.getRemarks());
				transModal.setActionBy(fundApproval.getInitiatingOfficer());
				transModal.setActionDate(LocalDateTime.now());
				fundApprovalDao.AddFundApprovalTrans(transModal);
		 	}
		 	
		 return 1L;
	}
	
	@Override
	public long EditFundRequestSubmit(FundApproval approval, FundApprovalAttachDto attachDto) throws Exception {
	    long fundApprovalId = fundApprovalDao.EditFundRequestSubmit(approval);
	    
	    if (fundApprovalId > 0) {
	        String filePath = Paths.get(uploadpath, "FundApproval", String.valueOf(fundApprovalId)).toString();
	        String pathDB = Paths.get("FundApproval", String.valueOf(fundApprovalId)).toString();
	        
	        File filepath = new File(filePath);
	        if (!filepath.exists()) {
	            filepath.mkdirs();
	        }
	        
	        for (int i = 0; i < attachDto.getFiles().length; i++) {
	            if (!attachDto.getFiles()[i].isEmpty()) {
	                // Check if attachment with this name already exists
	                Object[] existingAttach = fundApprovalDao.findAttachmentByFundAndName(fundApprovalId, attachDto.getFileName()[i]);
	                
	                if (existingAttach != null) {
	                    // Update existing attachment
	                    FundApprovalAttach modal = new FundApprovalAttach();
	                    modal.setFundApprovalAttachId((Long) existingAttach[0]);
	                    modal.setFundApprovalId(fundApprovalId);
	                    modal.setFileName(attachDto.getFileName()[i].trim());
	                    modal.setOriginalFileName(attachDto.getFiles()[i].getOriginalFilename().trim());
	                    modal.setModifiedBy(attachDto.getCreatedBy());
	                    modal.setModifiedDate(LocalDateTime.now());
	                    modal.setPath(pathDB);
	                    
	                    // Delete old file
	                    File oldFile = new File(env.getProperty("ApplicationFilesDrive") + "FundApproval" + 
	                        File.separator + existingAttach[1] + File.separator + existingAttach[3]);
	                    Files.deleteIfExists(oldFile.toPath());
	                    
	                    // Save new file
	                    SaveFile(filePath, modal.getOriginalFileName(), attachDto.getFiles()[i]);
	                    fundApprovalDao.updateFundRequestAttach(modal);
	                } else {
	                    // Add new attachment
	                    FundApprovalAttach modal = new FundApprovalAttach();
	                    modal.setFundApprovalId(fundApprovalId);
	                    modal.setFileName(attachDto.getFileName()[i].trim());
	                    modal.setOriginalFileName(attachDto.getFiles()[i].getOriginalFilename().trim());
	                    modal.setCreatedBy(attachDto.getCreatedBy());
	                    modal.setCreatedDate(LocalDateTime.now());
	                    
	                    String fullFilePath = filePath + File.separator + modal.getOriginalFileName();
	                    File file = new File(fullFilePath);
	                    int count = 0;
	                    while (file.exists()) {
	                        count++;
	                        String newName = FilenameUtils.getBaseName(modal.getOriginalFileName()) + "-" + count + 
	                            "." + FilenameUtils.getExtension(modal.getOriginalFileName());
	                        fullFilePath = filePath + File.separator + newName;
	                        file = new File(fullFilePath);
	                        if (count > 0) {
	                            modal.setOriginalFileName(newName);
	                        }
	                    }
	                    
	                    modal.setPath(pathDB);
	                    SaveFile(filePath, modal.getOriginalFileName(), attachDto.getFiles()[i]);
	                    fundApprovalDao.AddFundRequestAttachSubmit(modal);
	                    
	                }
	            }
	        }
	    }
	    return 1L;
	}
	
	@Override
	public long RevisionFundRequestSubmit(FundApproval approval, FundApprovalAttachDto attachDto) throws Exception {
	    long fundApprovalId = fundApprovalDao.RevisionFundRequestSubmit(approval);
	    
	    if (fundApprovalId > 0) {
	        String filePath = Paths.get(uploadpath, "FundApproval", String.valueOf(fundApprovalId)).toString();
	        String pathDB = Paths.get("FundApproval", String.valueOf(fundApprovalId)).toString();
	        
	        File filepath = new File(filePath);
	        if (!filepath.exists()) {
	            filepath.mkdirs();
	        }
	        
	        for (int i = 0; i < attachDto.getFiles().length; i++) {
	            if (!attachDto.getFiles()[i].isEmpty()) {
	                // Check if attachment with this name already exists
	                Object[] existingAttach = fundApprovalDao.findAttachmentByFundAndName(fundApprovalId, attachDto.getFileName()[i]);
	                
	                if (existingAttach != null) {
	                    // Update existing attachment
	                    FundApprovalAttach modal = new FundApprovalAttach();
	                    modal.setFundApprovalAttachId((Long) existingAttach[0]);
	                    modal.setFundApprovalId(fundApprovalId);
	                    modal.setFileName(attachDto.getFileName()[i].trim());
	                    modal.setOriginalFileName(attachDto.getFiles()[i].getOriginalFilename().trim());
	                    modal.setModifiedBy(attachDto.getCreatedBy());
	                    modal.setModifiedDate(LocalDateTime.now());
	                    modal.setPath(pathDB);
	                    
	                    // Delete old file
	                    File oldFile = new File(env.getProperty("ApplicationFilesDrive") + "FundApproval" + 
	                        File.separator + existingAttach[1] + File.separator + existingAttach[3]);
	                    Files.deleteIfExists(oldFile.toPath());
	                    
	                    // Save new file
	                    SaveFile(filePath, modal.getOriginalFileName(), attachDto.getFiles()[i]);
	                    fundApprovalDao.updateFundRequestAttach(modal);
	                } else {
	                    // Add new attachment
	                    FundApprovalAttach modal = new FundApprovalAttach();
	                    modal.setFundApprovalId(fundApprovalId);
	                    modal.setFileName(attachDto.getFileName()[i].trim());
	                    modal.setOriginalFileName(attachDto.getFiles()[i].getOriginalFilename().trim());
	                    modal.setCreatedBy(attachDto.getCreatedBy());
	                    modal.setCreatedDate(LocalDateTime.now());
	                    
	                    String fullFilePath = filePath + File.separator + modal.getOriginalFileName();
	                    File file = new File(fullFilePath);
	                    int count = 0;
	                    while (file.exists()) {
	                        count++;
	                        String newName = FilenameUtils.getBaseName(modal.getOriginalFileName()) + "-" + count + 
	                            "." + FilenameUtils.getExtension(modal.getOriginalFileName());
	                        fullFilePath = filePath + File.separator + newName;
	                        file = new File(fullFilePath);
	                        if (count > 0) {
	                            modal.setOriginalFileName(newName);
	                        }
	                    }
	                    
	                    modal.setPath(pathDB);
	                    SaveFile(filePath, modal.getOriginalFileName(), attachDto.getFiles()[i]);
	                    fundApprovalDao.AddFundRequestAttachSubmit(modal);
	                    
	                }
	            }
	        }
	    }
	    return 1L;
	}
	
	public static void SaveFile(String uploadpath, String fileName, MultipartFile multipartFile) throws IOException {
	
		Path uploadPath = Paths.get(uploadpath);
	
		if (!Files.exists(uploadPath)) {
			Files.createDirectories(uploadPath);
		}
	
		try (InputStream inputStream = multipartFile.getInputStream()) {
			Path filePath = uploadPath.resolve(fileName);
			Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException ioe) {
			throw new IOException("Could not save image file: " + fileName, ioe);
		}
	}
	
	@Override
	public List<Object[]> getMasterFlowDetails(String estimatedCost,String fundRequestId) throws Exception {
		return fundApprovalDao.getMasterFlowDetails(estimatedCost,fundRequestId!=null ? Long.parseLong(fundRequestId) : 0);
	}
	
	@Override
	public Object[] getFundRequestObj(long fundApprovalId) throws Exception{
		return fundApprovalDao.getFundRequestObj(fundApprovalId);
	}
	
	@Override
	public List<Object[]> getFundRequestAttachList(long fundApprovalId) throws Exception{
		
		List<Object[]> getFundRequestAttachList = null;
		try {
			getFundRequestAttachList = fundApprovalDao.getFundRequestAttachList(fundApprovalId);
					
			}catch (Exception e) {
			logger.error(new Date() +"Inside MasterServiceImpl getFundRequestAttachList");
			e.printStackTrace();
		}
		return getFundRequestAttachList;
	}
	
	public Object[] FundRequestAttachData(long fundApprovalAttachId) throws Exception{
		Object[] FundRequestAttachData = null;
		try {
			FundRequestAttachData = fundApprovalDao.FundRequestAttachData(fundApprovalAttachId);
			}catch (Exception e) {
			logger.error(new Date() +"Inside MasterServiceImpl FundRequestAttachData");
			e.printStackTrace();
		}
		return FundRequestAttachData;
	}
	
	@Override
	public int FundRequestAttachDelete(long fundApprovalAttachId) throws Exception {
		logger.info(new Date() + "Inside SERVICE FundRequestAttachDelete ");
		Object[] attachdata = fundApprovalDao.FundRequestAttachData(fundApprovalAttachId);
		File my_file=null;
		my_file = new File(env.getProperty("ApplicationFilesDrive")+"FundApproval"+File.separator + attachdata[1] +File.separator + attachdata[3]);
		boolean result = Files.deleteIfExists(my_file.toPath());
	 if(result) {
			return fundApprovalDao.FundRequestAttachDelete(fundApprovalAttachId);
	 }else {
		   return 0;
	 }

 }
	
	@Override
	public long fundRequestForward(FundApproval fundApprovalData,String flowMasterId,String estimatedCost,long empId, String fundStatus) throws Exception {
		
		FundApprovalTrans transaction=new FundApprovalTrans();
		transaction.setFundApprovalId(fundApprovalData.getFundApprovalId());
		transaction.setRcStausCode((fundStatus!=null && (fundStatus.equalsIgnoreCase("R") || fundStatus.equalsIgnoreCase("E")) ? "RE-" : "") +"FORWARDED");
		transaction.setActionBy(empId);
		transaction.setActionDate(LocalDateTime.now());
		long transStatus=fundApprovalDao.insertFundApprovalTransaction(transaction);
		
		int fundApprovalIdCount=fundApprovalDao.getFundApprovalIdCountFromCommitteeLinked(fundApprovalData.getFundApprovalId());
		if(fundApprovalIdCount == 0)
		{
			List<Object[]> masterFlowList=fundApprovalDao.getMasterFlowDetails(estimatedCost!=null ? estimatedCost : "0",fundApprovalData.getFundApprovalId());
			if(masterFlowList!=null && masterFlowList.size()>0)
			{
				masterFlowList.forEach(row -> {
					System.out.println("*******masterFlowList******");
					System.out.println(Arrays.toString(row));
				    LinkedCommitteeMembers linkedMembers = new LinkedCommitteeMembers();
				    linkedMembers.setFundApprovalId(fundApprovalData.getFundApprovalId()); 
				    
				    if(row[2]!=null)
				    {
				    	if(!(row[2].toString()).equalsIgnoreCase("INITIATION") && !(row[2].toString()).equalsIgnoreCase("FORWARDED"))
				    	{
				    		if((row[2].toString()).equalsIgnoreCase("DIVISION HEAD APPROVED"))
					    	{
					    		linkedMembers.setEmpId(fundApprovalData.getRc6());
					    		linkedMembers.setMemberType("DH");    // Division Head
					    	}
					    	else if((row[2].toString()).equalsIgnoreCase("RO1 RECOMMENDED"))
					    	{
					    		linkedMembers.setEmpId(fundApprovalData.getRc1());
					    		linkedMembers.setMemberType("CM");    // CM-Committee Member
					    	}
					    	else if((row[2].toString()).equalsIgnoreCase("RO2 RECOMMENDED"))
					    	{
					    		linkedMembers.setEmpId(fundApprovalData.getRc2());
					    		linkedMembers.setMemberType("CM");    // CM-Committee Member
					    	}
					    	else if((row[2].toString()).equalsIgnoreCase("RO3 RECOMMENDED"))
					    	{
					    		linkedMembers.setEmpId(fundApprovalData.getRc3());
					    		linkedMembers.setMemberType("CM");    // CM-Committee Member
					    	}
					    	else if((row[2].toString()).equalsIgnoreCase("SE RECOMMENDED"))
					    	{
					    		linkedMembers.setEmpId(fundApprovalData.getRc4());
					    		linkedMembers.setMemberType("SE");    // CM-Subject Member
					    	}
					    	else if((row[2].toString()).equalsIgnoreCase("RPB MEMBER SECRETARY APPROVED"))
					    	{
					    		linkedMembers.setEmpId(fundApprovalData.getRc5());
					    		linkedMembers.setMemberType("CS");    // CM-RPB Secretary
					    	}
					    	else if((row[2].toString()).equalsIgnoreCase("CHAIRMAN APPROVED"))
					    	{
					    		linkedMembers.setEmpId(fundApprovalData.getApprovingOfficer());
					    		linkedMembers.setMemberType("CC");    // CM-Committee chairman
					    	}
					    	
					    	linkedMembers.setIsApproved("N");
						    linkedMembers.setCreatedBy(fundApprovalData.getModifiedBy());
						    linkedMembers.setCreatedDate(LocalDateTime.now());
						    linkedMembers.setIsActive(1);
						    
						    try {
						    	if(fundStatus.equalsIgnoreCase("F") || fundStatus.equalsIgnoreCase("E"))   // F - Forward, E - Revoke
						    	{
									fundApprovalDao.insertLinkedCommitteeMembers(linkedMembers);
						    	}
							} catch (Exception e) {
								e.printStackTrace();
							}
				    	}
				    }
				    
				});

			}
		}
		
		long approvalStatus=0;
		if(transStatus > 0)
		{
			fundApprovalData.setStatus("F");
			fundApprovalData.setModifiedBy(fundApprovalData.getModifiedBy());
			fundApprovalData.setModifiedDate(fundApprovalData.getModifiedDate());
			approvalStatus=fundApprovalDao.updateFundRequest(fundApprovalData);
		}
		
		return approvalStatus;
	}
	
	private String[] getCurrentEmployeeFundDetails(long empId, long fundApprovalId,String status) throws Exception
	{
		String[] currentDetails=new String[2];
		FundApproval fundDetails=fundApprovalDao.getFundRequestDetails(fundApprovalId);
		
		if(status!=null)
		{
			if(status.equalsIgnoreCase("E"))   // E - Revoke
			{
				currentDetails[0]="REVOKED";
				currentDetails[1]=null;
				return currentDetails;
			}
			
			if(fundDetails.getRc1() > 0 && fundDetails.getRc1() == empId)
			{
				if(status.equalsIgnoreCase("RE"))
				{
					currentDetails[0]="RO1 RECOMMENDED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO1 RETURNED";
				}
				else if(status.equalsIgnoreCase("E"))
				{
					currentDetails[0]="RO1 REVOKED";
				}
				
				currentDetails[1]=fundDetails.getRc1Role();
			}
			
			if(fundDetails.getRc2() > 0 && fundDetails.getRc2() == empId)
			{
				if(status.equalsIgnoreCase("RE"))
				{
					currentDetails[0]="RO2 RECOMMENDED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO2 RETURNED";
				}
				else if(status.equalsIgnoreCase("E"))
				{
					currentDetails[0]="RO2 REVOKED";
				}
				currentDetails[1]=fundDetails.getRc2Role();
			}
			
			if(fundDetails.getRc3() > 0 && fundDetails.getRc3() == empId)
			{
				if(status.equalsIgnoreCase("RE"))
				{
					currentDetails[0]="RO3 RECOMMENDED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO3 RETURNED";
				}
				else if(status.equalsIgnoreCase("E"))
				{
					currentDetails[0]="RO3 REVOKED";
				}
				currentDetails[1]=fundDetails.getRc3Role();
			}
			
			if(fundDetails.getRc4() > 0 && fundDetails.getRc4() == empId)
			{
				if(status.equalsIgnoreCase("RE"))
				{
					currentDetails[0]="SE RECOMMENDED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="SE RETURNED";
				}
				else if(status.equalsIgnoreCase("E"))
				{
					currentDetails[0]="SE REVOKED";
				}
				currentDetails[1]=fundDetails.getRc4Role();
			}
			
			if(fundDetails.getRc5() > 0 && fundDetails.getRc5() == empId)
			{
				if(status.equalsIgnoreCase("RE"))
				{
					currentDetails[0]="RPB MEMBER SECRETARY APPROVED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RPB MEMBER SECRETARY RETURNED";
				}
				else if(status.equalsIgnoreCase("E"))
				{
					currentDetails[0]="RPB MEMBER SECRETARY REVOKED";
				}
				currentDetails[1]=fundDetails.getRc5Role();
			}
			
			if(fundDetails.getRc6() > 0 && fundDetails.getRc6() == empId)
			{
				if(status.equalsIgnoreCase("DA"))
				{
					currentDetails[0]="DIVISION HEAD APPROVED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="DIVISION HEAD RETURNED";
				}
				else if(status.equalsIgnoreCase("E"))
				{
					currentDetails[0]="DIVISION HEAD REVOKED";
				}
				currentDetails[1]=fundDetails.getRc6Role();
			}
			
			if(fundDetails.getApprovingOfficer() > 0 && fundDetails.getApprovingOfficer() == empId)
			{
				if(status.equalsIgnoreCase("A"))
				{
					currentDetails[0]="CHAIRMAN APPROVED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="CHAIRMAN RETURNED";
				}
				else if(status.equalsIgnoreCase("E"))
				{
					currentDetails[0]="CHAIRMAN REVOKED";
				}
				currentDetails[1]=fundDetails.getApprovingOfficerRole();
			}
		}
		
		return currentDetails;
	}
	
	@Override
	public FundApproval getFundRequestDetails(String fundRequestId) throws Exception {
		return fundApprovalDao.getFundRequestDetails(fundRequestId!=null ? Long.parseLong(fundRequestId) : 0);
	}

	@Override
	public List<Object[]> getFundPendingList(String empId,String finYear,String loginType,long formRole) throws Exception {
		return fundApprovalDao.getFundPendingList(empId,finYear,loginType,formRole);
	}

	@Override
	public List<Object[]> getFundApprovedList(String empId, String finYear,String loginType) throws Exception {
		return fundApprovalDao.getFundApprovedList(empId,finYear,loginType);
	}

	@Override
	public List<Object[]> getParticularFundApprovalDetails(String fundApprovalId,long empId) throws Exception {
		return fundApprovalDao.getParticularFundApprovalDetails(fundApprovalId,empId);
	}
	
	@Override
	public List<Object[]> getParticularFundApprovalTransDetails(String fundApprovalId) throws Exception{
		return fundApprovalDao.getParticularFundApprovalTransDetails(fundApprovalId);
	}

	@Override
	public long updateRecommendAndApprovalDetails(FundApprovalDto fundDto, long empId) throws Exception {
		
		FundApproval fundApproval=fundApprovalDao.getFundRequestDetails(fundDto.getFundApprovalId());
		String[] employeeDetails=getCurrentEmployeeFundDetails(empId, fundApproval.getFundApprovalId(), fundDto.getAction());
		
		FundApprovalTrans transaction=new FundApprovalTrans(); 
		transaction.setFundApprovalId(fundApproval.getFundApprovalId());
		transaction.setRcStausCode(employeeDetails!=null && employeeDetails.length > 0 ? employeeDetails[0] : null);
		transaction.setRemarks(fundDto.getRemarks());
		transaction.setRole(employeeDetails!=null && employeeDetails.length > 0 ? employeeDetails[1] : null);
		transaction.setActionBy(empId);
		transaction.setActionDate(LocalDateTime.now());
		fundApprovalDao.insertFundApprovalTransaction(transaction);
		
			if(fundDto.getAction()!=null)
			{
				if(fundDto.getAction().equalsIgnoreCase("A") || fundDto.getAction().equalsIgnoreCase("DA") || fundDto.getAction().equalsIgnoreCase("RE"))  // A - Approve or recommend, DH - Division Head Approve
				{
					fundApprovalDao.updateParticularLinkedCommitteeDetails(empId,fundApproval.getFundApprovalId(),"Y");
				}
//				else if(fundDto.getAction().equalsIgnoreCase("R"))   // R - Return
//				{
//					updateLinkedCommitteeMembersReturn(fundApproval);
//				}
				else if(fundDto.getAction().equalsIgnoreCase("E"))   // E - Revoke
				{
					deleteLinkedCommitteeMembersRevoke(fundApproval);
				}
			}
		
			long status=0;
			if(fundDto.getAction()!=null)
			{
				if(fundDto.getAction().equalsIgnoreCase("A")) //  A -Approver
				{
					fundApproval.setStatus("A");
					fundApproval.setSerialNo(createSerialNo(fundApproval.getReFbeYear(),fundApproval.getEstimateType()));
				}
				else if(fundDto.getAction().equalsIgnoreCase("R")) //  R - Returned
				{
					fundApproval.setStatus("R");
				}
				else if(fundDto.getAction().equalsIgnoreCase("E")) //  E - Revoked
				{
					fundApproval.setStatus("E");
					fundApproval.setRc1(0);
					fundApproval.setRc1Role(null);
					fundApproval.setRc2(0);
					fundApproval.setRc2Role(null);
					fundApproval.setRc3(0);
					fundApproval.setRc3Role(null);
					fundApproval.setRc4(0);
					fundApproval.setRc4Role(null);
					fundApproval.setRc5(0);
					fundApproval.setRc5Role(null);
					fundApproval.setRc6(0);
					fundApproval.setRc6Role(null);
					fundApproval.setApprovingOfficer(0);
					fundApproval.setApprovingOfficerRole(null);
				}
				else
				{
					fundApproval.setStatus(fundApproval.getStatus());
				}
			}
			
			status=fundApprovalDao.updateFundRequest(fundApproval);
		
		return status;
	}
	
	private void updateLinkedCommitteeMembersReturn(FundApproval fundApproval) throws Exception
	{
		List<Object[]> cmmtMemberLinkedList = fundApprovalDao.getCommitteeMemberLinkedDetails(fundApproval.getFundApprovalId());
		if(cmmtMemberLinkedList!=null && cmmtMemberLinkedList.size()>0)
		{
			cmmtMemberLinkedList.forEach(row -> {
				if(row[0]!=null) 
				{
					LinkedCommitteeMembers linkedMembers = new LinkedCommitteeMembers();
					try {
						linkedMembers = fundApprovalDao.getCommitteeMemberLinkedDetails(row[0].toString());
						linkedMembers.setIsApproved("N");
					    linkedMembers.setModifiedBy(fundApproval.getModifiedBy());
					    linkedMembers.setModifiedDate(LocalDateTime.now());
					    
					    fundApprovalDao.updateLinkedCommitteeMembers(linkedMembers);
					    
					} catch (Exception e) {
						
						e.printStackTrace();
					}
				}
			});
		}
	}
	
	private void deleteLinkedCommitteeMembersRevoke(FundApproval fundApproval) throws Exception
	{
		List<Object[]> cmmtMemberLinkedList = fundApprovalDao.getCommitteeMemberLinkedDetails(fundApproval.getFundApprovalId());
		if(cmmtMemberLinkedList!=null && cmmtMemberLinkedList.size()>0)
		{
			cmmtMemberLinkedList.forEach(row -> {
				if(row[0]!=null) 
				{
					try {
						  fundApprovalDao.deleteLinkedCommitteeMembers(row[0].toString());
						
					} catch (Exception e) {
						
						e.printStackTrace();
					}
				}
			});
		}
	}

	@Override
	public List<Object[]> getAllCommitteeMemberDetails(LocalDate currentDate) throws Exception {
		return fundApprovalDao.getAllCommitteeMemberDetails(currentDate);
	}
	
	@Override
	public List<Object[]> getFundReportList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost, String status,String committeeMember,String RupeeValue)  throws Exception{
		
		return fundApprovalDao.getFundReportList(finYear, divisionId, estimateType, loginType, empId, projectId, budgetHeadId, budgetItemId, fromCost, toCost, status, committeeMember,RupeeValue);
	}
	
	@Override
	public List<BudgetDetails> getBudgetHeadList(String projectId) throws Exception {
		
		List<Object[]> budgetHeadList=null;
		if(projectId!=null) 
		{
			if(!projectId.equalsIgnoreCase("0"))
			{
				budgetHeadList=fundApprovalDao.getProjectBudgetHeadList(projectId);
			}
			
			if(projectId.equalsIgnoreCase("0"))
			{
				budgetHeadList=fundApprovalDao.getGeneralBudgetHeadList();
			}
			
			if(budgetHeadList==null || budgetHeadList.isEmpty())
			{
				budgetHeadList=new ArrayList<Object[]>();
				budgetHeadList.add(new Object[] {"0","No Record Found","NRF"});
			}
		}
		
		List<BudgetDetails> finalList = budgetHeadList == null ? new ArrayList<>() :
		   
			budgetHeadList.stream().filter(Objects::nonNull).map(resultList -> {
		            BudgetDetails budgetHeadDetails = new BudgetDetails();
		            if (resultList[0] != null) {
		                budgetHeadDetails.setBudgetHeadId(Integer.parseInt(resultList[0].toString()));
		            }
		            if (resultList[1] != null) {
		                budgetHeadDetails.setBudgetHeaddescription(resultList[1].toString());
		            }
		            if (resultList[2] != null) {
		                budgetHeadDetails.setBudgetHeadCode(resultList[2].toString());
		            }
		            return budgetHeadDetails;
		        })
		        .collect(Collectors.toList());
		
		return finalList;
	}
	
	@Override
	public List<Object[]> getBudgetHeadItem(long ProjectId, long budgetHeadId) throws Exception 
	{
		List<Object[]> BudgetHeadItem=null;
		if(ProjectId>0) 
		{
			BudgetHeadItem=fundApprovalDao.getPrjBudgetHeadItem(ProjectId,budgetHeadId);
		}
		else
		{
			BudgetHeadItem=fundApprovalDao.getGenBudgetHeadItem(budgetHeadId);
		}
		return BudgetHeadItem;
	}

	@Override
	public String getCommitteeMemberCurrentStatus(String empId) throws Exception {
		List<Object[]> list=fundApprovalDao.getCommitteeMemberCurrentStatus(empId);
		String memberType=null;
		if(list!=null && list.size()>0)
		{
			memberType=list.get(0)!=null && list.get(0).length>0 && list.get(0)[1]!=null ? list.get(0)[1].toString() : null;
		}
		return memberType;
	}
	
	public String createSerialNo(String fbeReYear,String estimateType)
	{
		try 
		{
			int maxCount =0;
			if(estimateType!=null && estimateType.equalsIgnoreCase("F"))
			{
				List<Object[]> result = fundApprovalDao.getMaxSerialNoCount(fbeReYear,estimateType);
				if(result!=null && result.size()>0)
				{
					maxCount= result.stream().findFirst().map(row -> row[0]).map(Object::toString).map(Integer::parseInt).orElse(0);
				}
			}
			
			if(estimateType!=null && estimateType.equalsIgnoreCase("R"))
			{
				int previousYearFBESerialNoCount=0,SelectedYearREserialNoCount=0;
				if(fbeReYear!=null) 
				{    // getting selected or RE Year Revised Estimate Serial No(Max)
					List<Object[]> resultRE = fundApprovalDao.getMaxSerialNoCount(fbeReYear,estimateType);
					if(resultRE!=null && resultRE.size()>0)
					{
						SelectedYearREserialNoCount= resultRE.stream().findFirst().map(row -> row[0]).map(Object::toString).map(Integer::parseInt).orElse(0);
						
						if(SelectedYearREserialNoCount==0) // if Revised Estimate Serial No is Zero then we will check in Last Year FBE
					    {
							List<Object[]> resultFBE = fundApprovalDao.getMaxSerialNoCount(fbeReYear,"F");
							if(resultFBE!=null && resultFBE.size()>0)
							{
								previousYearFBESerialNoCount= resultFBE.stream().findFirst().map(row -> row[0]).map(Object::toString).map(Integer::parseInt).orElse(0);
							}
							maxCount=previousYearFBESerialNoCount;
					    }
					    else
					    {
					    	maxCount=SelectedYearREserialNoCount;
					    }
					}
				}
			}
			String[] years = fbeReYear.split("-");
	        String shortYearRange = years[0].substring(2) + "-" + years[1].substring(2);
	        return shortYearRange+"/"+(maxCount+1);
			
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public List<Object[]> getFundRequestCarryForwardDetails(FundApprovalBackButtonDto fundApprovalDto,String labCode,String action) throws Exception {
		return fundApprovalDao.getFundRequestCarryForwardDetails(fundApprovalDto,labCode,action);
	}
	
	@Override
	public List<Object[]> estimateTypeParticularDivList(long divisionId, String estimateType,String finYear, String loginType,String empId, String budgetHeadId, String budgetItemId,String fromCost, String toCost,String status,String memberType,int RupeeValue) throws Exception{
		return fundApprovalDao.estimateTypeParticularDivList(divisionId, estimateType,finYear,loginType,empId,budgetHeadId,budgetItemId,fromCost,toCost,status,memberType,RupeeValue);
	}
	
	
	@Override
	public long insertCarryForwardItemDetails(FundRequestCOGDetails cogMonth,FundApprovalBackButtonDto backDto, String userName) throws Exception {
		
	    if (cogMonth == null || isEmpty(cogMonth.getCarryForwardSerialNo()) || cogMonth.getActionType() == null) {
	        return -1;
	    }

	    String estimateType = Optional.ofNullable(backDto).map(FundApprovalBackButtonDto::getEstimatedTypeBackBtn).orElse(null);

	    String fbeReYear = resolveFbeReYear(backDto, estimateType);

	    long count = 0;
	    String action = cogMonth.getActionType();

	    for (int i = 0; i < cogMonth.getCarryForwardSerialNo().length; i++) {
	        FundApproval fundRequest = buildFundRequest(cogMonth, backDto, estimateType, fbeReYear, action, i);
	        fundRequest.setCreatedBy(userName);
	        fundRequest.setCreatedDate(LocalDateTime.now());
	        fundRequest.setStatus("N");

	        long fbeStatus = fundApprovalDao.insertCarryForwardItemDetails(fundRequest);

	        if (fbeStatus > 0) {
	            count++;
	            copyAttachments(fundRequest, cogMonth, i, userName);
	            transactionHistry(fundRequest, userName);
	        }
	    }

	    return (count == cogMonth.getCarryForwardSerialNo().length) ? 1 : 0;
	}

	// ---------------- Helper Methods ----------------

	private boolean isEmpty(Object[] arr) {
	    return arr == null || arr.length == 0;
	}

	private String resolveFbeReYear(FundApprovalBackButtonDto backDto, String estimateType) {
	    if (backDto == null || estimateType == null) return null;

	    switch (estimateType.toUpperCase()) {
	        case "R":
	            return backDto.getREYear();
	        case "F":
	            return backDto.getFBEYear();
	        default:
	            return null;
	    }
	}

	private FundApproval buildFundRequest(FundRequestCOGDetails cogMonth,FundApprovalBackButtonDto backDto,String estimateType,String fbeReYear,String action,int index) throws Exception{

	    long projectId = 0, budgetHeadId = 0, budgetItemId = 0, initiatingOfficer = 0, divisionId = 0;

	    if ("Demand".equalsIgnoreCase(action) && cogMonth.getDemandId().length > 0 && cogMonth.getDemandId()[index]!=null) 
	    {
	        Object[] demandArray = getFirstRow(fundApprovalDao.getDemandDetails(cogMonth.getDemandId()[index]));
	        if (demandArray != null) 
	        {
	            projectId = getLong(demandArray[3]);
	            budgetHeadId = getLong(demandArray[4]);
	            budgetItemId = getLong(demandArray[5]);
	            initiatingOfficer = getLong(demandArray[9]);
	            divisionId = getLong(demandArray[7]);
	        }
	    } 
	    else if ("SupplyOrder".equalsIgnoreCase(action) && cogMonth.getCommitmentId().length > 0 && cogMonth.getCommitmentId()[index]!=null) 
	    {
	        Object[] commitmentArray = getFirstRow(fundApprovalDao.getCommitmmentDetails(cogMonth.getCommitmentId()[index]));
	        if (commitmentArray != null) 
	        {
	            projectId = getLong(commitmentArray[3]);
	            budgetHeadId = getLong(commitmentArray[4]);
	            budgetItemId = getLong(commitmentArray[5]);
	            initiatingOfficer = getLong(commitmentArray[9]);
	            divisionId = getLong(commitmentArray[7]);
	        }
	    } 
	    else if ("Item".equalsIgnoreCase(action)) 
	    {
	        FundApproval lastYearfundRequest = fundApprovalDao.getFundRequestDetails(Long.parseLong(cogMonth.getSelectedFundRequestId()[index]));
	        if (lastYearfundRequest != null) 
	        {
	            projectId = lastYearfundRequest.getProjectId();
	            budgetHeadId = lastYearfundRequest.getBudgetHeadId();
	            budgetItemId = lastYearfundRequest.getBudgetItemId();
	            initiatingOfficer = lastYearfundRequest.getInitiatingOfficer();
	            divisionId = lastYearfundRequest.getDivisionId();
	        }
	    }

	    FundApproval fundRequest = new FundApproval();
	    fundRequest.setSerialNo("0");
	    fundRequest.setEstimateType(estimateType);
	    fundRequest.setDivisionId(divisionId);
	    fundRequest.setFinYear(backDto.getFromYearBackBtn() + "-" + backDto.getToYearBackBtn());
	    fundRequest.setReFbeYear(fbeReYear);
	    fundRequest.setProjectId(projectId);
	    fundRequest.setBudgetHeadId(budgetHeadId);
	    fundRequest.setBudgetItemId(budgetItemId);
	    fundRequest.setBookingId(parseLongSafe(cogMonth.getDemandId(), index));
	    fundRequest.setFundRequestId(parseLongSafe(cogMonth.getFundRequestId(), index));
	    fundRequest.setCommitmentPayIds(getStringSafe(cogMonth.getCommitmentPayId(), index));
	    fundRequest.setInitiatingOfficer(initiatingOfficer);
	    fundRequest.setItemNomenclature(getStringSafe(cogMonth.getItemNomenclature(), index));
	    fundRequest.setRequisitionDate(LocalDate.now());

	    setMonthlyAmounts(fundRequest, cogMonth, index);

	    return fundRequest;
	}

	private void copyAttachments(FundApproval fundRequest, FundRequestCOGDetails cogMonth,int index, String userName) throws Exception {
		
	    List<Object[]> attachments = fundApprovalDao.getFundRequestAttachList(fundRequest.getFundApprovalId());
	    if (attachments == null || attachments.isEmpty()) return;

	    attachments.forEach(row -> {
	        FundApprovalAttach attach = new FundApprovalAttach();
	        attach.setFundApprovalId(fundRequest.getFundApprovalId());
	        attach.setFileName(getString(row[1]));
	        attach.setOriginalFileName(getString(row[2]));
	        attach.setPath(getString(row[4]));
	        attach.setCreatedBy(userName);
	        attach.setCreatedDate(LocalDateTime.now());

	        try {
	            fundApprovalDao.AddFundRequestAttachSubmit(attach);
	        } catch (Exception e) {
	            logger.error("Failed to copy attachment for FundApprovalId {}", fundRequest.getFundApprovalId(), e);
	            e.printStackTrace();
	        }
	    });
	}
	
	private void transactionHistry(FundApproval fundRequest, String userName) throws Exception {
		
		FundApprovalTrans transModal=new FundApprovalTrans();
		transModal.setFundApprovalId(fundRequest.getFundApprovalId());
		transModal.setRcStausCode("INITIATION");
		transModal.setRemarks(fundRequest.getRemarks());
		transModal.setActionBy(fundRequest.getInitiatingOfficer());
		transModal.setActionDate(LocalDateTime.now());
		fundApprovalDao.AddFundApprovalTrans(transModal);
	}

	private void setMonthlyAmounts(FundApproval fundRequest, FundRequestCOGDetails cogMonth, int i) {
	    setAmount(fundRequest::setFundRequestAmount, cogMonth.getFbeAmount(), i);
	    setAmount(fundRequest::setApril, cogMonth.getAprAmount(), i);
	    setAmount(fundRequest::setMay, cogMonth.getMayAmount(), i);
	    setAmount(fundRequest::setJune, cogMonth.getJunAmount(), i);
	    setAmount(fundRequest::setJuly, cogMonth.getJulAmount(), i);
	    setAmount(fundRequest::setAugust, cogMonth.getAugAmount(), i);
	    setAmount(fundRequest::setSeptember, cogMonth.getSepAmount(), i);
	    setAmount(fundRequest::setOctober, cogMonth.getOctAmount(), i);
	    setAmount(fundRequest::setNovember, cogMonth.getNovAmount(), i);
	    setAmount(fundRequest::setDecember, cogMonth.getDecAmount(), i);
	    setAmount(fundRequest::setJanuary, cogMonth.getJanAmount(), i);
	    setAmount(fundRequest::setFebruary, cogMonth.getFebAmount(), i);
	    setAmount(fundRequest::setMarch, cogMonth.getMarAmount(), i);
	}

	// ---------------- Utility Methods ----------------

	private void setAmount(Consumer<BigDecimal> setter, String[] arr, int index) {
	    if (arr != null && arr.length > index && arr[index] != null && !arr[index].isEmpty()) {
	        setter.accept(new BigDecimal(arr[index]));
	    }
	}

	private long parseLongSafe(String[] arr, int index) {
	    try {
	        return (arr != null && arr.length > index && arr[index] != null) ? Long.parseLong(arr[index]) : 0;
	    } catch (NumberFormatException e) {
	        return 0;
	    }
	}

	private String getStringSafe(String[] arr, int index) {
	    return (arr != null && arr.length > index) ? arr[index] : null;
	}

	private Object[] getFirstRow(List<Object[]> list) {
	    return (list != null && !list.isEmpty()) ? list.get(0) : null;
	}

	private long getLong(Object obj) {
	    return (obj != null) ? Long.parseLong(obj.toString()) : 0;
	}

	private String getString(Object obj) {
	    return (obj != null) ? obj.toString() : null;
	}

	
	@Override
	public String getCommitteeMemberType (long empId) throws Exception{
		List<Object[]> committeeType= fundApprovalDao.getCommitteeMemberType(empId);
		 if (committeeType != null && !committeeType.isEmpty()) {
		        Object[] firstRow = committeeType.get(0);
		        return firstRow[0].toString();
		    }
		    return null;
	}

	@Override
	public List<Object[]> getProposedProjectDetails() throws Exception {
		return fundApprovalDao.getProposedProjectDetails();
	}
	
	@Override
	public List<Object[]> getAttachmentDetails(String fundApprovalId) throws Exception {
		return fundApprovalDao.getAttachmentDetails(fundApprovalId);
	}
	
	@Override
	public FundApproval getExisitingFundApprovalList(String fundApprovalId) throws Exception{
	  return fundApprovalDao.getRevisionListDetails(fundApprovalId);
	}
	
	@Override
	public long getRevisionListDetails(String fundApprovalId,String UserName) throws Exception{
		
		FundApproval fundApprovalRevise=fundApprovalDao.getRevisionListDetails(fundApprovalId);
		
		if(fundApprovalRevise!=null) {
			long revisionCount=fundApprovalDao.getRevisionCount(fundApprovalId);
			revisionCount+=1;
			FundApprovedRevision revision = new FundApprovedRevision();
			
			revision.setFundApprovalId(fundApprovalRevise.getFundApprovalId());
			revision.setEstimateType(fundApprovalRevise.getEstimateType());
			revision.setSerialNo(fundApprovalRevise.getSerialNo());
			revision.setDivisionId(fundApprovalRevise.getDivisionId());
			revision.setFinYear(fundApprovalRevise.getFinYear());
			revision.setReFbeYear(fundApprovalRevise.getReFbeYear());
			revision.setInitiationId(fundApprovalRevise.getInitiationId());
			revision.setBudgetType(fundApprovalRevise.getBudgetType());
			revision.setProjectId(fundApprovalRevise.getProjectId());
			revision.setBudgetHeadId(fundApprovalRevise.getBudgetHeadId());
			revision.setBudgetItemId(fundApprovalRevise.getBudgetItemId());
			revision.setFundRequestId(fundApprovalRevise.getFundRequestId());
			revision.setBookingId(fundApprovalRevise.getBookingId());
			revision.setCommitmentPayIds(fundApprovalRevise.getCommitmentPayIds());
			revision.setItemNomenclature(fundApprovalRevise.getItemNomenclature());
			revision.setRequisitionDate(fundApprovalRevise.getRequisitionDate());
			revision.setJustification(fundApprovalRevise.getJustification());
			revision.setFundRequestAmount(fundApprovalRevise.getFundRequestAmount());
			revision.setApril(fundApprovalRevise.getApril());
			revision.setMay(fundApprovalRevise.getMay());
			revision.setJune(fundApprovalRevise.getJune());
			revision.setJuly(fundApprovalRevise.getJuly());
			revision.setAugust(fundApprovalRevise.getAugust());
			revision.setSeptember(fundApprovalRevise.getSeptember());
			revision.setOctober(fundApprovalRevise.getOctober());
			revision.setNovember(fundApprovalRevise.getNovember());
			revision.setDecember(fundApprovalRevise.getDecember());
			revision.setJanuary(fundApprovalRevise.getJanuary());
			revision.setFebruary(fundApprovalRevise.getFebruary());
			revision.setMarch(fundApprovalRevise.getMarch());
			revision.setInitiatingOfficer(fundApprovalRevise.getInitiatingOfficer());
			revision.setRc1(fundApprovalRevise.getRc1());
			revision.setRc1Role(fundApprovalRevise.getRc1Role());
			revision.setRc2(fundApprovalRevise.getRc2());
			revision.setRc2Role(fundApprovalRevise.getRc2Role());
			revision.setRc3(fundApprovalRevise.getRc3());
			revision.setRc3Role(fundApprovalRevise.getRc3Role());
			revision.setRc4(fundApprovalRevise.getRc4());
			revision.setRc4Role(fundApprovalRevise.getRc4Role());
			revision.setRc5(fundApprovalRevise.getRc5());
			revision.setRc5Role(fundApprovalRevise.getRc5Role());
			revision.setRc6(fundApprovalRevise.getRc6());
			revision.setRc6Role(fundApprovalRevise.getRc6Role());
			revision.setApprovingOfficer(fundApprovalRevise.getApprovingOfficer());
			revision.setApprovingOfficerRole(fundApprovalRevise.getApprovingOfficerRole());
			revision.setRcStatusCode(fundApprovalRevise.getRcStatusCode());
			revision.setRcStatusCodeNext(fundApprovalRevise.getRcStatusCodeNext());
			revision.setStatus(fundApprovalRevise.getStatus());
			revision.setRemarks(fundApprovalRevise.getRemarks());
			revision.setApprovalDate(fundApprovalRevise.getApprovalDate());
			revision.setRevisionCount(revisionCount);
			revision.setCreatedBy(UserName);
			revision.setCreatedDate(LocalDateTime.now());

			fundApprovalDao.RevisionDetailsSubmit(revision);
			
			return revisionCount;
		}
		return 0;
		
	}

	@Override
	public long actionForRevokeRequest(FundApprovalDto fundDto, long empId) throws Exception {
		FundApproval fundApproval=fundApprovalDao.getFundRequestDetails(fundDto.getFundApprovalId());
		String[] employeeDetails=getCurrentEmployeeFundDetails(empId, fundApproval.getFundApprovalId(), fundDto.getAction());
		FundApprovalTrans transaction=new FundApprovalTrans(); 
		transaction.setFundApprovalId(fundApproval.getFundApprovalId());
		transaction.setRcStausCode(employeeDetails!=null && employeeDetails.length > 0 ? employeeDetails[0] : null);
		transaction.setRemarks(fundDto.getRemarks());
		transaction.setRole(employeeDetails!=null && employeeDetails.length > 0 ? employeeDetails[1] : null);
		transaction.setActionBy(empId);
		transaction.setActionDate(LocalDateTime.now());
		fundApprovalDao.insertFundApprovalTransaction(transaction);
		
			if(fundDto.getAction()!=null)
			{
				if(fundDto.getAction().equalsIgnoreCase("A")) 
				{
					fundApprovalDao.updateParticularLinkedCommitteeDetails(empId,fundApproval.getFundApprovalId(),"Y");
				}
				else if(fundDto.getAction().equalsIgnoreCase("R"))
				{
					updateLinkedCommitteeMembersReturn(fundApproval);
				}
			}
		
		long status=0;
			if(fundDto.getAction()!=null)
			{
				if(fundDto.getAction().equalsIgnoreCase("A")) //  A -Approver
				{
					fundApproval.setStatus("A");
					fundApproval.setSerialNo(createSerialNo(fundApproval.getReFbeYear(),fundApproval.getEstimateType()));
				}
				else if(fundDto.getAction().equalsIgnoreCase("R")) //  R - Returned
				{
					fundApproval.setStatus("R");
				}
			}
			
			status=fundApprovalDao.updateFundRequest(fundApproval);
		
		return status;
	}

	@Override
	public long deleteFundRequest(FundApprovalDto fundDto) throws Exception {
		
		long status = 0;
		if(fundDto!=null) 
		{
			if(fundDto.getFundApprovalId()!=0) {
				status = fundApprovalDao.deleteFundRequestDetails(fundDto.getFundApprovalId());
			}
			
		}
		return status;
	}
	
}
