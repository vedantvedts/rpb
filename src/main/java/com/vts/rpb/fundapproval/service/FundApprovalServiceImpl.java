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
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.vts.rpb.fundapproval.dto.BudgetDetails;
import com.vts.rpb.fundapproval.dao.FundApprovalDao;
import com.vts.rpb.fundapproval.dto.FundApprovalAttachDto;
import com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto;
import com.vts.rpb.fundapproval.dto.FundApprovalDto;
import com.vts.rpb.fundapproval.dto.FundRequestCOGDetails;
import com.vts.rpb.fundapproval.modal.FundApproval;
import com.vts.rpb.fundapproval.modal.FundApprovalAttach;
import com.vts.rpb.fundapproval.modal.FundApprovalQueries;
import com.vts.rpb.fundapproval.modal.FundApprovalTrans;
import com.vts.rpb.fundapproval.modal.FundApprovedRevision;
import com.vts.rpb.fundapproval.modal.FundLinkedMembers;

@Service
@Transactional
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
	@Transactional
	public long AddFundRequestSubmit(FundApproval fundApproval, FundApprovalAttachDto attachDto, Long userId) throws Exception
	{	
		long status = 0;
		
		 long FundApprovalId = fundApprovalDao.AddFundRequestSubmit(fundApproval);
		 
		 	if(FundApprovalId >0) 
		 	{
		 		String filePath = Paths.get(uploadpath, "FundApproval",String.valueOf(FundApprovalId)).toString();
		 		String pathDB=Paths.get("FundApproval",String.valueOf(FundApprovalId)).toString();
		 		
		 		File filepath = new File(filePath);
				long ret = 0;
				if (!filepath.exists()) {
					filepath.mkdirs();
				}
				
				if(attachDto != null)
				{
					for (int i = 0; i < attachDto.getFiles().length; i++) 
					{
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
				}
				
				FundApprovalTrans transModal=new FundApprovalTrans();
				transModal.setFundApprovalId(fundApproval.getFundApprovalId());
				transModal.setFlowDetailsId(getFundFlowDetailsId("INI","N"));
				transModal.setRemarks(fundApproval.getRemarks());
				transModal.setActionBy(userId);
				transModal.setActionDate(LocalDateTime.now());
				
				status = fundApprovalDao.AddFundApprovalTrans(transModal);
		 	}
		 	
		 return status;
	}
	
	@Override
	@Transactional
	public long EditFundRequestSubmit(FundApproval approval, FundApprovalAttachDto attachDto) throws Exception {
	    
		long status = 0;
		
		long fundApprovalId = fundApprovalDao.EditFundRequestSubmit(approval);
	    
	    if (fundApprovalId > 0) 
	    {
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
	        status = 1;
	    }
	    return status;
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
	public List<Object[]> getMasterFlowDetails(String fundRequestId) throws Exception {
		return fundApprovalDao.getMasterFlowDetails(fundRequestId!=null ? Long.parseLong(fundRequestId) : 0);
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
	@Transactional
	public long fundRequestForward(FundApprovalDto fundDto, long empId) throws Exception {
		
		long status = 0;
		
		if(fundDto != null)
		{
			FundApproval fundDetails = fundApprovalDao.getFundRequestDetails(fundDto.getFundApprovalId());
			
			int fundApprovalIdCount = fundApprovalDao.getFundApprovalIdCountFromCommitteeLinked(fundDto.getFundApprovalId());
			if(fundApprovalIdCount == 0)
			{
				// Insert Division Head
				FundLinkedMembers dhMember = buildLinkedMember(fundDto, "DH", fundDto.getDivisionHeadId());
				insertSafe(dhMember);

				// Insert Committee Member
				if (fundDto.getMembersId() != null) {
				    Arrays.stream(fundDto.getMembersId())
				          .map(Long::parseLong)
				          .map(employeeId -> buildLinkedMember(fundDto, "CM", employeeId)) 
				          .forEach(this::insertSafe);
				}
				
				// Insert Subject Expert
				if (fundDto.getSubjectExpertsId() != null) {
					Arrays.stream(fundDto.getSubjectExpertsId())
					.map(Long::parseLong)
					.map(employeeId -> buildLinkedMember(fundDto, "SE", employeeId)) 
					.forEach(this::insertSafe);
				}
				
				// Insert Committee Secretary
				FundLinkedMembers secretaryMember = buildLinkedMember(fundDto, "CS", fundDto.getSecretaryId());
				insertSafe(secretaryMember);
				
				// Insert Committee Chairman
				FundLinkedMembers chairMember = buildLinkedMember(fundDto, "CC", fundDto.getChairmanId());
				insertSafe(chairMember);
				
			}
			
			System.out.println("fundDto.getAction()****"+fundDto.getAction());
			
			String transAction = "";
			if(fundDto.getAction()!=null) 
			{
				if(fundDto.getAction().equalsIgnoreCase("F"))
				{
					fundDetails.setStatus("F");
					transAction = "FWD";
				}
				else if(fundDto.getAction().equalsIgnoreCase("RF")) 
				{
					transAction = "R-FWD";
					fundDetails.setStatus("F");
				}
				else if(fundDto.getAction().equalsIgnoreCase("R"))    // R - Return Re-Forward 
				{
					transAction = "R-FWD";
					fundDetails.setStatus("B");  // C - returned re-forward
				}
				
				FundApprovalTrans transModal = buildFundTransactonDetails(fundDto,transAction,"N",empId);
				fundApprovalDao.insertFundApprovalTransaction(transModal);
				
				fundDetails.setModifiedBy(fundDto.getModifiedBy());
				fundDetails.setModifiedDate(fundDto.getModifiedDate());
				
				status = fundApprovalDao.updateFundRequest(fundDetails);
			}
		}
		
		return status;
	}
	
	private FundLinkedMembers buildLinkedMember(FundApprovalDto fundDto, String memberType, Long empId) {
	    FundLinkedMembers linkedMembers = new FundLinkedMembers();
	    linkedMembers.setFundApprovalId(fundDto.getFundApprovalId());
	    linkedMembers.setFlowMasterId(fundDto.getFlowMasterId()!=null ? Long.parseLong(fundDto.getFlowMasterId()) : 0);
	    linkedMembers.setMemberType(memberType);
	    linkedMembers.setEmpId(empId);
	    linkedMembers.setIsApproved("N");
	    linkedMembers.setCreatedBy(fundDto.getModifiedBy());
	    linkedMembers.setCreatedDate(LocalDateTime.now());
	    linkedMembers.setIsActive(1);
	    return linkedMembers;
	}
	
	private FundApprovalTrans buildFundTransactonDetails(FundApprovalDto fundDto,String action, String actionType, Long empId) throws Exception {
		
		long flowDetailsId = getFundFlowDetailsId(action,actionType);
		
		FundApprovalTrans transaction = new FundApprovalTrans();
		
		transaction.setFundApprovalId(fundDto.getFundApprovalId());
		transaction.setMemberLinkedId(fundDto.getFundMemberLinkedId());
		transaction.setFlowDetailsId(flowDetailsId);
		transaction.setRemarks(fundDto.getRemarks()!=null && fundDto.getRemarks()!="" ? fundDto.getRemarks().trim() : null);
		transaction.setActionBy(empId);
		transaction.setActionDate(LocalDateTime.now());
		return transaction;
	}

	private void insertSafe(FundLinkedMembers linkedMembers) {
	    try {
	        fundApprovalDao.insertLinkedCommitteeMembers(linkedMembers);
	    } catch (Exception e) {
	    	throw new RuntimeException("Failed to insert committee member: " + linkedMembers, e);
	    }
	}
	
	private long getFundFlowDetailsId(String action, String actionType) throws Exception
	{
		long flowDetailsId = 0;
		List<Object[]> getStatus = fundApprovalDao.getTransactionStatusDetails(action,actionType);
		if(getStatus != null && getStatus.size() > 0)
		{
			if(getStatus.get(0) != null && getStatus.get(0).length > 0)
			{
				flowDetailsId = getStatus.get(0)[0] !=null ? Long.parseLong(getStatus.get(0)[0].toString()): 0;
			}
		}
		return flowDetailsId;
	}

	
	@Override
	@Transactional
	public long revokeRecommendationDetails(FundApprovalDto fundDto, long empId) throws Exception {
		
		long status = 0;
		
		FundApproval fundDetails = fundApprovalDao.getFundRequestDetails(fundDto.getFundApprovalId());
		
		if(fundDetails == null)
		{
			throw new RuntimeException("Failed to delete committee member: " + fundDetails);
		}
		
		fundDetails.setStatus("E");  // E - Revoked
		fundDetails.setRevokedBy(empId);
		fundDetails.setRevokedDate(LocalDateTime.now());
		fundApprovalDao.updateFundRequest(fundDetails);
		
		deleteLinkedMembers(fundDetails);
		
		FundApprovalTrans transModal = buildFundTransactonDetails(fundDto,fundDto.getAction(),"N",empId);
		status = fundApprovalDao.insertFundApprovalTransaction(transModal);
		
		return status;
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

	// Return, Recommend, Approve
	@Override
	@Transactional
	public long updateRecommendAndApprovalDetails(FundApprovalDto fundDto, long empId) throws Exception {
		
		long status = 0;
		FundApproval fundApproval=fundApprovalDao.getFundRequestDetails(fundDto.getFundApprovalId());
		
			if(fundDto.getAction()!=null)
			{
				if(fundDto.getAction().equalsIgnoreCase("A"))  // A - Approve or recommend
				{
					updateParticularLinkedMemberDetails(fundDto,empId,fundApproval.getFundApprovalId());
					
					if(fundDto.getMemberStatus()!=null && fundDto.getMemberStatus().equalsIgnoreCase("CC")) {
						fundApproval.setStatus("A");
						fundApproval.setSerialNo(createSerialNo(fundApproval.getReFbeYear(),fundApproval.getEstimateType()));
					}
					
				}
				else if(fundDto.getAction().equalsIgnoreCase("R"))
				{
					fundApproval.setStatus("R");
					fundApproval.setReturnedBy(empId);
					fundApproval.setReturnedDate(LocalDateTime.now());
				}
				
				FundApprovalTrans transModal = buildFundTransactonDetails(fundDto,fundDto.getMemberStatus(),fundDto.getAction(),empId);
				fundApprovalDao.insertFundApprovalTransaction(transModal);
				
				status = fundApprovalDao.updateFundRequest(fundApproval);
			}
		
		return status;
	}
	
	private void updateParticularLinkedMemberDetails(FundApprovalDto fundDto, long empId, long fundApprovalId) throws Exception {
		
		FundLinkedMembers linkedMemberModal = fundApprovalDao.getLinkedMemberDetailsByEmpId(empId, fundApprovalId);
		if(linkedMemberModal != null) 
		{
			linkedMemberModal.setIsApproved("Y");
			linkedMemberModal.setModifiedBy(fundDto.getModifiedBy());
			linkedMemberModal.setModifiedDate(LocalDateTime.now());
			fundApprovalDao.updateLinkedCommitteeMembers(linkedMemberModal);
		}
		
	}

	private void updateLinkedCommitteeMembersReturn(FundApproval fundApproval) throws Exception
	{
		List<Object[]> cmmtMemberLinkedList = fundApprovalDao.getLinkedMemberDetails(fundApproval.getFundApprovalId());
		if(cmmtMemberLinkedList!=null && cmmtMemberLinkedList.size()>0)
		{
			cmmtMemberLinkedList.forEach(row -> {
				if(row[0]!=null) 
				{
					FundLinkedMembers linkedMembers = new FundLinkedMembers();
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
	
	private void deleteLinkedMembers(FundApproval fundApproval) throws Exception
	{
		List<Object[]> linkedMemberList = fundApprovalDao.getLinkedMemberDetails(fundApproval.getFundApprovalId());
		if(linkedMemberList!=null && linkedMemberList.size()>0)
		{
			linkedMemberList.forEach(row -> {
				if(row[0]!=null) 
				{
					try {
						  fundApprovalDao.deleteLinkedCommitteeMembers(row[0].toString());
						
					} catch (Exception e) {
						
						throw new RuntimeException("Failed to delete committee member: " + row[0], e);
						
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
	public List<Object[]> estimateTypeParticularDivList(long divisionId, String estimateType,String finYear, String loginType,String empId,String budget, String proposedProject, String budgetHeadId, String budgetItemId,String fromCost, String toCost,String status,String memberType,int RupeeValue) throws Exception{
		return fundApprovalDao.estimateTypeParticularDivList(divisionId, estimateType,finYear,loginType,empId,budget,proposedProject,budgetHeadId,budgetItemId,fromCost,toCost,status,memberType,RupeeValue);
	}
	
	
	@Override
	@Transactional
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
	        fundRequest.setBudgetType("B");
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
	public String getCommitteeMembersLinked (long empId) throws Exception{
		List<Object[]> committeeType= fundApprovalDao.getCommitteeMembersLinked(empId);
		 if (committeeType != null && !committeeType.isEmpty()) {
		        Object[] firstRow = committeeType.get(0);
		        return firstRow[0].toString();
		    }
		    return null;
	}
	
	@Override
	public List<Object[]> committeeMemberFundApprovalCount(String committeeMember,String empId) throws Exception{
		List<Object[]> totalCountFundApproval= fundApprovalDao.committeeMemberFundApprovalCount(committeeMember,empId);
		if (totalCountFundApproval != null && !totalCountFundApproval.isEmpty()) {
	        
	        return totalCountFundApproval;
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
			Long revisionCount=fundApprovalDao.getRevisionCount(fundApprovalId);
			
			if (revisionCount == null) {
				System.err.println("Current Rev count is null-"+revisionCount);
			    revisionCount = 0L;
			} else {
				System.err.println("Current Rev count-"+revisionCount);
			    revisionCount++;
			}
			
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
//			revision.setRc1(fundApprovalRevise.getRc1());
//			revision.setRc1Role(fundApprovalRevise.getRc1Role());
//			revision.setRc2(fundApprovalRevise.getRc2());
//			revision.setRc2Role(fundApprovalRevise.getRc2Role());
//			revision.setRc3(fundApprovalRevise.getRc3());
//			revision.setRc3Role(fundApprovalRevise.getRc3Role());
//			revision.setRc4(fundApprovalRevise.getRc4());
//			revision.setRc4Role(fundApprovalRevise.getRc4Role());
//			revision.setRc5(fundApprovalRevise.getRc5());
//			revision.setRc5Role(fundApprovalRevise.getRc5Role());
//			revision.setRc6(fundApprovalRevise.getRc6());
//			revision.setRc6Role(fundApprovalRevise.getRc6Role());
//			revision.setApprovingOfficer(fundApprovalRevise.getApprovingOfficer());
//			revision.setApprovingOfficerRole(fundApprovalRevise.getApprovingOfficerRole());
//			revision.setRcStatusCode(fundApprovalRevise.getRcStatusCode());
//			revision.setRcStatusCodeNext(fundApprovalRevise.getRcStatusCodeNext());
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
	@Transactional
	public long deleteFundRequest(FundApprovalDto fundDto) throws Exception {
		
		long status = 0;
		if(fundDto!=null) 
		{
			if(fundDto.getFundApprovalId()!=0) {
				fundApprovalDao.deleteFundRequestDetails(fundDto.getFundApprovalId());
				fundApprovalDao.deleteFundRequestAttachmentDetails(fundDto.getFundApprovalId());
				fundApprovalDao.deleteFundRequestQueriesDetails(fundDto.getFundApprovalId());
				fundApprovalDao.deleteFundRequestRevisionDetails(fundDto.getFundApprovalId());
				fundApprovalDao.deleteFundRequestTransDetails(fundDto.getFundApprovalId());
				fundApprovalDao.deleteFundRequestLinkedMembersDetails(fundDto.getFundApprovalId());
				status = 1;
			}
		}
		return status;
	}

	@Override
	@Transactional
	public long editRecommendationDetails(FundApprovalDto fundDto, long empId) throws Exception {

		long status = 0;
		
		if(fundDto != null)
		{
			if(fundDto.getMemberLinkedId() != null && fundDto.getMemberLinkedId().length > 0 && fundDto.getReccEmpId()!=null && fundDto.getReccEmpId().length > 0)
			{
				int arrayLength = 0;
				for(int i=0; i < fundDto.getMemberLinkedId().length ; i++)
				{
					String linkedMemberId = fundDto.getMemberLinkedId()[i];
					String linkedEmpId = fundDto.getReccEmpId()[i];
					if(linkedMemberId !=null && linkedEmpId != null)
					{
						FundLinkedMembers modal = fundApprovalDao.getCommitteeMemberLinkedDetails(linkedMemberId);
						modal.setEmpId(Long.parseLong(linkedEmpId));
						
						String skippStatus = getSkippedStatusDetails(fundDto.getSkippedStatus(), i);
						
						modal.setIsSkipped(skippStatus);
						
						if(skippStatus.equalsIgnoreCase("Y"))
						{
							modal.setSkipReason(getReasonDetails(fundDto.getReasonType(), i));
						}
						else
						{
							modal.setSkipReason("N");
						}
						
						modal.setModifiedBy(fundDto.getModifiedBy());
						modal.setModifiedDate(LocalDateTime.now());
						
						long modalStatus = fundApprovalDao.updateLinkedCommitteeMembers(modal);
						if(modalStatus > 0) {
							arrayLength ++;
						};
					}
				}
				
				if(arrayLength == fundDto.getMemberLinkedId().length) 
				{
					status = 1;
				}
			}
		}
		
		return status;
	}
	
	private String getSkippedStatusDetails(String[] skippedStatus, int serialNo) {
		
		if(skippedStatus == null || skippedStatus.length == 0) {
			return "N";
		}
		
		String status = skippedStatus[serialNo];
		
		if(status == null)
		{
			status = "N";
		}
		
		return status;
	}
	
	private String getReasonDetails(String[] getReasonDetails, int serialNo) {
		
		if(getReasonDetails == null || getReasonDetails.length == 0) {
			return "N";
		}
		
		String status = getReasonDetails[serialNo];
		
		if(status == null)
		{
			status = "N";
		}
		
		return status;
	}

	@Override
	public long fundApprovalQuerySubmit(FundApprovalQueries FundApprovalQueries) {
		return fundApprovalDao.fundApprovalQuerySubmit(FundApprovalQueries);
	}
	
	@Override
	public List<Object[]> getParticularFundQueryHeader(String fundApprovalId) throws Exception{
		return fundApprovalDao.getParticularFundQueryHeader(fundApprovalId);
	}
	
	@Override
	public List<Object[]> getFundApprovalQueryDetails(String fundApprovalId) throws Exception{
		
		return fundApprovalDao.getFundApprovalQueryDetails(fundApprovalId);
	}
	
	@Override
	public List<Object[]> getFundApprovalRevisionDetails(String fundApprovalId) throws Exception{
		return fundApprovalDao.getFundApprovalRevisionDetails(fundApprovalId);
	}

	@Override
	public List<Object[]> getPreviousYearFundDetailsList(String previousFinYear, String finYear, String loginType, String memberType, String empId) throws Exception {
		return fundApprovalDao.getPreviousYearFundDetailsList(previousFinYear,finYear,loginType,memberType,empId);
	}

	@Override
	@Transactional
	public long transferFundDetails(String[] fundApprovalIds, String finYear, String estimateType, String userName) throws Exception {
		
		long status = 0;
		if(fundApprovalIds != null && fundApprovalIds.length > 0)
		{
			for(int i = 0; i < fundApprovalIds.length; i++)
			{
				transferSelectedFundDetails(fundApprovalIds[i], finYear, estimateType, userName);
			}
			status = 1;
		}
		return status;
	}

	private void transferSelectedFundDetails(String oldFundApprovalId, String finYear, String estimateType, String userName) {
		
		if(oldFundApprovalId == null)
		{
			throw new RuntimeException("fundApprovalId is " + oldFundApprovalId);
		}
			
		long newFundApprovalId = fundApprovalDao.transferFundApprovalDetails(oldFundApprovalId, finYear, estimateType, userName);
		fundApprovalDao.transferFundAttchmentDetails(oldFundApprovalId, newFundApprovalId, userName);
		fundApprovalDao.transferFundQuriesDetails(oldFundApprovalId, newFundApprovalId);
		fundApprovalDao.transferRevisionOfFundApprovalDetails(oldFundApprovalId, newFundApprovalId, finYear, estimateType, userName);
		fundApprovalDao.transferFundTransDetails(oldFundApprovalId, newFundApprovalId);
		fundApprovalDao.transferFundMemberLinkedDetails(oldFundApprovalId, newFundApprovalId, userName);
		
	}
	
}