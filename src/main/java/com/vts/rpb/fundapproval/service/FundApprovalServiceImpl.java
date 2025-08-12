package com.vts.rpb.fundapproval.service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Objects;
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
import com.vts.rpb.fundapproval.dao.FundApprovalDao;
import com.vts.rpb.fundapproval.dto.FundApprovalAttachDto;
import com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto;
import com.vts.rpb.fundapproval.dto.FundApprovalDto;
import com.vts.rpb.fundapproval.dto.FundRequestCOGDetails;
import com.vts.rpb.fundapproval.modal.FundApproval;
import com.vts.rpb.fundapproval.modal.FundApprovalAttach;
import com.vts.rpb.fundapproval.modal.FundApprovalTrans;
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
	public List<Object[]> getFundApprovalList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId) throws Exception {
		return fundApprovalDao.getFundApprovalList(finYear,divisionId,estimateType,loginType,empId,projectId);
	}
	
	@Override
	public long AddFundRequestSubmit(FundApproval fundApproval, FundApprovalAttachDto attachDto) throws Exception
	{	
		 long FundApprovalId=fundApprovalDao.AddFundRequestSubmit(fundApproval);
		 	System.err.println("SERVICE FundApprovalId->"+FundApprovalId);
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
						modal.setFileName(attachDto.getFileName()[i]);
						modal.setOriginalFileName(attachDto.getFiles()[i].getOriginalFilename());
			
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
	    System.err.println("SERVICE FundApprovalId->" + fundApprovalId);
	    
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
	                System.err.println("Service->existingAttach--"+Arrays.toString(existingAttach));
	                
	                if (existingAttach != null) {
	                    // Update existing attachment
	                    FundApprovalAttach modal = new FundApprovalAttach();
	                    modal.setFundApprovalAttachId((Long) existingAttach[0]);
	                    modal.setFundApprovalId(fundApprovalId);
	                    modal.setFileName(attachDto.getFileName()[i]);
	                    modal.setOriginalFileName(attachDto.getFiles()[i].getOriginalFilename());
	                    modal.setModifiedBy(attachDto.getCreatedBy());
	                    modal.setModifiedDate(LocalDateTime.now());
	                    modal.setPath(pathDB);
	                    
	                    // Delete old file
	                    File oldFile = new File(env.getProperty("ApplicationFilesDrive") + "FundApproval" + 
	                        File.separator + existingAttach[1] + File.separator + existingAttach[3]);
	                    Files.deleteIfExists(oldFile.toPath());
	                    System.err.println("EXISTING if SECTION-");
	                    
	                    // Save new file
	                    SaveFile(filePath, modal.getOriginalFileName(), attachDto.getFiles()[i]);
	                    fundApprovalDao.updateFundRequestAttach(modal);
	                } else {
	                    // Add new attachment
	                    FundApprovalAttach modal = new FundApprovalAttach();
	                    modal.setFundApprovalId(fundApprovalId);
	                    modal.setFileName(attachDto.getFileName()[i]);
	                    modal.setOriginalFileName(attachDto.getFiles()[i].getOriginalFilename());
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
	                    
	                    System.err.println("NEW else SECTION-");
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
			System.err.println("SERVICE getFundRequestAttachList-"+fundApprovalId);
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
			System.err.println("SERVICE FundRequestAttachData-"+fundApprovalAttachId);
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
	public long fundRequestForward(FundApproval fundApprovalData,String flowMasterId,String estimatedCost,long empId) throws Exception {
		
		FundApprovalTrans transaction=new FundApprovalTrans(); 
		transaction.setFundApprovalId(fundApprovalData.getFundApprovalId());
		transaction.setRcStausCode("FORWARDED");
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
				    LinkedCommitteeMembers linkedMembers = new LinkedCommitteeMembers();
				    linkedMembers.setFundApprovalId(fundApprovalData.getFundApprovalId()); 
				    
				    if(row[2]!=null)
				    {
				    	if((row[2].toString()).equalsIgnoreCase("RO1 RECOMMENDED"))
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
					    	if(!(row[2].toString()).equalsIgnoreCase("INITIATION") && !(row[2].toString()).equalsIgnoreCase("FORWARDED"))
					    	{
								fundApprovalDao.insertLinkedCommitteeMembers(linkedMembers);
					    	}
						} catch (Exception e) {
							e.printStackTrace();
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
			if(fundDetails.getRc1() > 0 && fundDetails.getRc1() == empId)
			{
				if(!status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO1 RECOMMENDED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO1 RETURNED";
				}
				currentDetails[1]=fundDetails.getRc1Role();
			}
			
			if(fundDetails.getRc2() > 0 && fundDetails.getRc2() == empId)
			{
				if(!status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO2 RECOMMENDED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO2 RETURNED";
				}
				currentDetails[1]=fundDetails.getRc2Role();
			}
			
			if(fundDetails.getRc3() > 0 && fundDetails.getRc3() == empId)
			{
				if(!status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO3 RECOMMENDED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO3 RETURNED";
				}
				currentDetails[1]=fundDetails.getRc3Role();
			}
			
			if(fundDetails.getRc4() > 0 && fundDetails.getRc4() == empId)
			{
				if(!status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="SE RECOMMENDED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="SE RETURNED";
				}
				currentDetails[1]=fundDetails.getRc4Role();
			}
			
			if(fundDetails.getRc5() > 0 && fundDetails.getRc5() == empId)
			{
				if(!status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RPB MEMBER SECRETARY APPROVED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="RPB MEMBER SECRETARY RETURNED";
				}
				currentDetails[1]=fundDetails.getRc5Role();
			}
			
			if(fundDetails.getApprovingOfficer() > 0 && fundDetails.getApprovingOfficer() == empId)
			{
				if(!status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="CHAIRMAN APPROVED";
				}
				else if(status.equalsIgnoreCase("R"))
				{
					currentDetails[0]="CHAIRMAN RETURNED";
				}
				currentDetails[1]=fundDetails.getApprovingOfficerRole();
			}
		}
		
		return currentDetails;
	}
	
//	private String getRcStatusCodeNext(List<Object[]> masterFlowList,String statusCodeNext) throws Exception
//	{
//		masterFlowList.forEach(row->System.out.println(Arrays.toString(row)));
//		 return IntStream.range(0, masterFlowList.size() - 1).filter(i -> statusCodeNext.equals(masterFlowList.get(i)[2].toString()))
//		            .mapToObj(i -> masterFlowList.get(i + 1)[2].toString())
//		            .findFirst()
//		            .orElse(null); // return null if not found or last in the list
//	}
//	
//	private BigDecimal getTotalOfCashoutgoCost(FundApproval fundApproval) throws Exception
//	{
//		BigDecimal totalCost=BigDecimal.ZERO;
//		if(fundApproval!=null)
//		{
//			totalCost=fundApproval.getApril().add(fundApproval.getMay()).add(fundApproval.getJune()).add(fundApproval.getJuly())
//					.add(fundApproval.getAugust()).add(fundApproval.getSeptember()).add(fundApproval.getOctober()).add(fundApproval.getNovember())
//					.add(fundApproval.getDecember()).add(fundApproval.getJanuary()).add(fundApproval.getFebruary()).add(fundApproval.getMarch());
//		}
//		return totalCost;
//	}
	
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
				if(!fundDto.getAction().equalsIgnoreCase("R"))  // Except return 
				{
					fundApprovalDao.updateParticularLinkedCommitteeDetails(empId,fundApproval.getFundApprovalId(),"Y");
				}
				
				if(fundDto.getAction().equalsIgnoreCase("R")) 
				{
					fundApprovalDao.updateParticularLinkedCommitteeDetails(empId,fundApproval.getFundApprovalId(),"Y");
				}
				
			}
		
		long status=0;
			if(fundDto.getAction()!=null)
			{
				if(!fundDto.getAction().equalsIgnoreCase("RE")) //  RE - Recommend
				{
					fundApproval.setStatus(fundDto.getAction());
				}
				
				if(fundDto.getAction().equalsIgnoreCase("A"))
				{
					fundApproval.setSerialNo(createSerialNo(fundApproval.getReFbeYear(),fundApproval.getEstimateType()));
				}
			}
			fundApproval.setStatus(fundApproval.getStatus());
			status=fundApprovalDao.updateFundRequest(fundApproval);
		
		return status;
	}

	@Override
	public List<Object[]> getAllCommitteeMemberDetails(LocalDate currentDate) throws Exception {
		return fundApprovalDao.getAllCommitteeMemberDetails(currentDate);
	}
	
	@Override
	public List<Object[]> getFundReportList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost, String status)  throws Exception{
		
		return fundApprovalDao.getFundReportList(finYear, divisionId, estimateType, loginType, empId, projectId, budgetHeadId, budgetItemId, fromCost, toCost, status);
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
	public List<Object[]> getFundRequestCarryForwardDetails(FundApprovalBackButtonDto fundApprovalDto,String labCode)
			throws Exception {
		return fundApprovalDao.getFundRequestCarryForwardDetails(fundApprovalDto,labCode);
	}
	
	@Override
	public List<Object[]> estimateTypeParticularDivList(long divisionId, String estimateType,String finYear, String loginType,String empId, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost,String status) throws Exception{
		return fundApprovalDao.estimateTypeParticularDivList(divisionId, estimateType,finYear,loginType,empId,budgetHeadId,budgetItemId,fromCost,toCost,status);
	}

	@Override
	public long insertCarryForwardItemDetails(FundRequestCOGDetails cogMonth,FundApprovalBackButtonDto backDto, String userName) throws Exception {
		long status=0,count=0;
		if(cogMonth!=null && cogMonth.getCarryForwardSerialNo().length>0)
		{
			String fbeReYear=null,estimateType=null;
			if(backDto!=null)
			{
				if(backDto.getEstimatedTypeBackBtn()!=null)
				{
					estimateType=backDto.getEstimatedTypeBackBtn();
				}
				
				if(estimateType.equalsIgnoreCase("R"))
				{
					fbeReYear=backDto.getREYear();
				}
				else if(estimateType.equalsIgnoreCase("F"))
				{
					fbeReYear=backDto.getFBEYear();
				}
			}
			for(int i=0;i<cogMonth.getCarryForwardSerialNo().length;i++)
			{
				if(cogMonth.getItemNomenclature()[i]!=null && cogMonth.getFbeAmount()!=null && cogMonth.getFbeAmount()[i]!=null && !(cogMonth.getFbeAmount()[i]).equalsIgnoreCase("0"))
				{
					if(cogMonth.getSelectedFundRequestId()!=null && cogMonth.getSelectedFundRequestId()[i]!=null && cogMonth.getSelectedFundRequestId()[i]!="")
					{
						FundApproval lastYearfundRequest=fundApprovalDao.getFundRequestDetails(Long.parseLong(cogMonth.getSelectedFundRequestId()[i]));
						
						if(lastYearfundRequest!=null) 
						{
							FundApproval fundRequest=new FundApproval();
							String serialNo=createSerialNo(fbeReYear,estimateType);
							fundRequest.setSerialNo(serialNo!=null ? serialNo : "0");
							fundRequest.setEstimateType(estimateType);
							fundRequest.setDivisionId(lastYearfundRequest.getDivisionId());
							fundRequest.setFinYear(backDto.getFromYearBackBtn() +"-"+ backDto.getToYearBackBtn());
							fundRequest.setReFbeYear(fbeReYear);
							fundRequest.setProjectId(lastYearfundRequest.getProjectId());
							fundRequest.setBudgetHeadId(lastYearfundRequest.getBudgetHeadId());
							fundRequest.setBudgetItemId(lastYearfundRequest.getBudgetItemId());
							fundRequest.setBookingId(cogMonth.getDemandId()[i]!=null ? Long.parseLong(cogMonth.getDemandId()[i]) : 0);
							fundRequest.setFundRequestId(cogMonth.getFundRequestId()!=null && cogMonth.getFundRequestId()[i]!=null ? Long.parseLong(cogMonth.getFundRequestId()[i]) : 0);
							fundRequest.setCommitmentPayIds(cogMonth.getCommitmentPayId()[i]!=null ? cogMonth.getCommitmentPayId()[i].toString() : null);
							fundRequest.setBudgetItemId(lastYearfundRequest.getBudgetItemId());
							fundRequest.setInitiatingOfficer(lastYearfundRequest.getInitiatingOfficer());
							fundRequest.setItemNomenclature(cogMonth.getItemNomenclature()[i]!=null ? cogMonth.getItemNomenclature()[i] : null);
							fundRequest.setRequisitionDate(LocalDate.now());
							
							if(cogMonth.getFbeAmount()!=null && cogMonth.getFbeAmount()[i]!=null && cogMonth.getFbeAmount()[i]!="")
							{
								fundRequest.setFundRequestAmount(new BigDecimal(cogMonth.getFbeAmount()[i]));
							}
							
							if(cogMonth.getAprAmount()!=null && cogMonth.getAprAmount()[i]!=null && cogMonth.getAprAmount()[i]!="")
							{
								fundRequest.setApril(new BigDecimal(cogMonth.getAprAmount()[i]));
							}
							
							if(cogMonth.getMayAmount()!=null && cogMonth.getMayAmount()[i]!=null && cogMonth.getMayAmount()[i]!="")
							{
								fundRequest.setMay(new BigDecimal(cogMonth.getMayAmount()[i]));
							}
							if(cogMonth.getJunAmount()!=null && cogMonth.getJunAmount()[i]!=null && cogMonth.getJunAmount()[i]!="")
							{
								fundRequest.setJune(new BigDecimal(cogMonth.getJunAmount()[i]));
							}
							if(cogMonth.getJulAmount()!=null && cogMonth.getJulAmount()[i]!=null && cogMonth.getJulAmount()[i]!="")
							{
								fundRequest.setJuly(new BigDecimal(cogMonth.getJulAmount()[i]));
							}
							if(cogMonth.getAugAmount()!=null && cogMonth.getAugAmount()[i]!=null && cogMonth.getAugAmount()[i]!="")
							{
								fundRequest.setAugust(new BigDecimal(cogMonth.getAugAmount()[i]));
							}
							if(cogMonth.getSepAmount()!=null && cogMonth.getSepAmount()[i]!=null && cogMonth.getSepAmount()[i]!="")
							{
								fundRequest.setSeptember(new BigDecimal(cogMonth.getSepAmount()[i]));
							}
							if(cogMonth.getOctAmount()!=null && cogMonth.getOctAmount()[i]!=null && cogMonth.getOctAmount()[i]!="")
							{
								fundRequest.setOctober(new BigDecimal(cogMonth.getOctAmount()[i]));
							}
							if(cogMonth.getNovAmount()!=null && cogMonth.getNovAmount()[i]!=null && cogMonth.getNovAmount()[i]!="")
							{
								fundRequest.setNovember(new BigDecimal(cogMonth.getNovAmount()[i]));
							}
							if(cogMonth.getDecAmount()!=null && cogMonth.getDecAmount()[i]!=null && cogMonth.getDecAmount()[i]!="")
							{
								fundRequest.setDecember(new BigDecimal(cogMonth.getDecAmount()[i]));
							}
							if(cogMonth.getJanAmount()!=null && cogMonth.getJanAmount()[i]!=null && cogMonth.getJanAmount()[i]!="")
							{
								fundRequest.setJanuary(new BigDecimal(cogMonth.getJanAmount()[i]));
							}
							if(cogMonth.getFebAmount()!=null && cogMonth.getFebAmount()[i]!=null && cogMonth.getFebAmount()[i]!="")
							{
								fundRequest.setFebruary(new BigDecimal(cogMonth.getFebAmount()[i]));
							}
							if(cogMonth.getMarAmount()!=null && cogMonth.getMarAmount()[i]!=null && cogMonth.getMarAmount()[i]!="")
							{
								fundRequest.setMarch(new BigDecimal(cogMonth.getMarAmount()[i]));
							}
							
							fundRequest.setRc1(lastYearfundRequest.getRc1());
							fundRequest.setRc1Role(lastYearfundRequest.getRc1Role());
							
							fundRequest.setRc2(lastYearfundRequest.getRc2());
							fundRequest.setRc2Role(lastYearfundRequest.getRc2Role());
							
							fundRequest.setRc3(lastYearfundRequest.getRc3());
							fundRequest.setRc3Role(lastYearfundRequest.getRc3Role());
							
							fundRequest.setRc4(lastYearfundRequest.getRc4());
							fundRequest.setRc4Role(lastYearfundRequest.getRc4Role());
							
							fundRequest.setRc5(lastYearfundRequest.getRc5());
							fundRequest.setRc5Role(lastYearfundRequest.getRc5Role());
							
							fundRequest.setApprovingOfficer(lastYearfundRequest.getApprovingOfficer());
							fundRequest.setApprovingOfficerRole(lastYearfundRequest.getApprovingOfficerRole());
							
							fundRequest.setApprovalDate(lastYearfundRequest.getApprovalDate());				
							
							fundRequest.setStatus("A");
							fundRequest.setCreatedBy(userName);
							fundRequest.setCreatedDate(LocalDateTime.now());
							
							long fbeStatus=fundApprovalDao.insertCarryForwardItemDetails(fundRequest);
							
							if(fbeStatus>0)
							{
								count++;
							}
						}
					}
				}
			}

			if(count==cogMonth.getCarryForwardSerialNo().length)
			{
				status=1;
			}
		}
		else
		{
			status=-1;
		}
		
		return status;
	}
	
}
