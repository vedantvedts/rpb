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
import java.util.stream.IntStream;

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
import com.vts.rpb.fundapproval.dto.FundApprovalDto;
import com.vts.rpb.fundapproval.modal.FundApproval;
import com.vts.rpb.fundapproval.modal.FundApprovalAttach;
import com.vts.rpb.fundapproval.modal.FundApprovalTrans;
import com.vts.rpb.fundapproval.modal.LinkedCommitteeMembers;

@Service
public class FundApprovalServiceImpl implements FundApprovalService 
{
	@Autowired
	FundApprovalDao fbedao;

	@Value("${ApplicationFilesDrive}")
	String uploadpath;
	
	@Value("${Attach_File_Size}")
	String attach_file_size;
	
	@Autowired
	private Environment env;
	
	private static final Logger logger=LogManager.getLogger(FundApprovalServiceImpl.class);
	
	@Override
	public List<Object[]> getFundApprovalList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId) throws Exception {
		return fbedao.getFundApprovalList(finYear,divisionId,estimateType,loginType,empId,projectId);
	}
	
	@Override
	public long AddFundRequestSubmit(FundApproval fundApproval, FundApprovalAttachDto attachDto) throws Exception
	{	
		 long FundApprovalId=fbedao.AddFundRequestSubmit(fundApproval);
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
						  ret = fbedao.AddFundRequestAttachSubmit(modal);
						 
			
					}
				}
				
				FundApprovalTrans transModal=new FundApprovalTrans();
				transModal.setFundApprovalId(fundApproval.getFundApprovalId());
				transModal.setRcStausCode("INITIATION");
				transModal.setRemarks(fundApproval.getRemarks());
				transModal.setActionBy(fundApproval.getInitiatingOfficer());
				transModal.setActionDate(LocalDateTime.now());
				fbedao.AddFundApprovalTrans(transModal);
		 	}
		 	
		 return 1L;
	}
	
	public long EditFundRequestSubmit(FundApproval approval, FundApprovalAttachDto attachDto) throws Exception{
		long FundApprovalId=fbedao.EditFundRequestSubmit(approval);
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
					  ret = fbedao.AddFundRequestAttachSubmit(modal);
					 
		
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
		return fbedao.getMasterFlowDetails(estimatedCost,fundRequestId!=null ? Long.parseLong(fundRequestId) : 0);
	}
	
	@Override
	public Object[] getFundRequestObj(long fundApprovalId) throws Exception{
		return fbedao.getFundRequestObj(fundApprovalId);
	}
	
	@Override
	public List<Object[]> getFundRequestAttachList(long fundApprovalId) throws Exception{
		
		List<Object[]> getFundRequestAttachList = null;
		try {
			System.err.println("SERVICE getFundRequestAttachList-"+fundApprovalId);
			getFundRequestAttachList = fbedao.getFundRequestAttachList(fundApprovalId);
					
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
			FundRequestAttachData = fbedao.FundRequestAttachData(fundApprovalAttachId);
			System.out.println(Arrays.toString(FundRequestAttachData));
			}catch (Exception e) {
			logger.error(new Date() +"Inside MasterServiceImpl FundRequestAttachData");
			e.printStackTrace();
		}
		return FundRequestAttachData;
	}
	
	@Override
	public int FundRequestAttachDelete(long fundApprovalAttachId) throws Exception {
		logger.info(new Date() + "Inside SERVICE FundRequestAttachDelete ");
		Object[] attachdata = fbedao.FundRequestAttachData(fundApprovalAttachId);
		System.out.println(Arrays.toString(attachdata));
		File my_file=null;
		System.out.println("ApplicationFilesDrive: " + env.getProperty("ApplicationFilesDrive")+"FundApproval"+File.separator + attachdata[1] +File.separator + attachdata[3]);
		my_file = new File(env.getProperty("ApplicationFilesDrive")+"FundApproval"+File.separator + attachdata[1] +File.separator + attachdata[3]);
		boolean result = Files.deleteIfExists(my_file.toPath());
	 if(result) {
			return fbedao.FundRequestAttachDelete(fundApprovalAttachId);
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
		long transStatus=fbedao.insertFundApprovalTransaction(transaction);
		
		int fundApprovalIdCount=fbedao.getFundApprovalIdCountFromCommitteeLinked(fundApprovalData.getFundApprovalId());
		if(fundApprovalIdCount == 0) 
		{
			List<Object[]> masterFlowList=fbedao.getMasterFlowDetails(estimatedCost!=null ? estimatedCost : "0",fundApprovalData.getFundApprovalId());
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
								fbedao.insertLinkedCommitteeMembers(linkedMembers);
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
			approvalStatus=fbedao.updateFundRequest(fundApprovalData);
		}
		
		return approvalStatus;
	}
	
	private String[] getCurrentEmployeeFundDetails(long empId, long fundApprovalId) throws Exception
	{
		String[] currentDetails=new String[2];
		FundApproval fundDetails=fbedao.getFundRequestDetails(fundApprovalId);
		
		if(fundDetails.getStatus()!=null)
		{
			if(fundDetails.getRc1() > 0 && fundDetails.getRc1() == empId)
			{
				if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO1 RECOMMENDED";
				}
				else if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO1 RETURNED";
				}
				currentDetails[1]=fundDetails.getRc1Role();
			}
			
			if(fundDetails.getRc2() > 0 && fundDetails.getRc2() == empId)
			{
				if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO2 RECOMMENDED";
				}
				else if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO2 RETURNED";
				}
				currentDetails[1]=fundDetails.getRc2Role();
			}
			
			if(fundDetails.getRc3() > 0 && fundDetails.getRc3() == empId)
			{
				if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO3 RECOMMENDED";
				}
				else if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="RO3 RETURNED";
				}
				currentDetails[1]=fundDetails.getRc3Role();
			}
			
			if(fundDetails.getRc4() > 0 && fundDetails.getRc4() == empId)
			{
				if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="SE RECOMMENDED";
				}
				else if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="SE RETURNED";
				}
				currentDetails[1]=fundDetails.getRc4Role();
			}
			
			if(fundDetails.getRc5() > 0 && fundDetails.getRc5() == empId)
			{
				if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="RPB MEMBER SECRETARY APPROVED";
				}
				else if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="RPB MEMBER SECRETARY RETURNED";
				}
				currentDetails[1]=fundDetails.getRc5Role();
			}
			
			if(fundDetails.getApprovingOfficer() > 0 && fundDetails.getApprovingOfficer() == empId)
			{
				if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="CHAIRMAN APPROVED";
				}
				else if(!fundDetails.getStatus().equalsIgnoreCase("R"))
				{
					currentDetails[0]="CHAIRMAN RETURNED";
				}
				currentDetails[1]=fundDetails.getApprovingOfficerRole();
			}
		}
		
		return currentDetails;
	}
	
	private String getRcStatusCodeNext(List<Object[]> masterFlowList,String statusCodeNext) throws Exception
	{
		masterFlowList.forEach(row->System.out.println(Arrays.toString(row)));
		 return IntStream.range(0, masterFlowList.size() - 1).filter(i -> statusCodeNext.equals(masterFlowList.get(i)[2].toString()))
		            .mapToObj(i -> masterFlowList.get(i + 1)[2].toString())
		            .findFirst()
		            .orElse(null); // return null if not found or last in the list
	}
	
	private BigDecimal getTotalOfCashoutgoCost(FundApproval fundApproval) throws Exception
	{
		BigDecimal totalCost=BigDecimal.ZERO;
		if(fundApproval!=null)
		{
			totalCost=fundApproval.getApril().add(fundApproval.getMay()).add(fundApproval.getJune()).add(fundApproval.getJuly())
					.add(fundApproval.getAugust()).add(fundApproval.getSeptember()).add(fundApproval.getOctober()).add(fundApproval.getNovember())
					.add(fundApproval.getDecember()).add(fundApproval.getJanuary()).add(fundApproval.getFebruary()).add(fundApproval.getMarch());
		}
		return totalCost;
	}
	
	@Override
	public FundApproval getFundRequestDetails(String fundRequestId) throws Exception {
		return fbedao.getFundRequestDetails(fundRequestId!=null ? Long.parseLong(fundRequestId) : 0);
	}

	@Override
	public List<Object[]> getFundPendingList(String empId,String finYear,String loginType,long formRole) throws Exception {
		return fbedao.getFundPendingList(empId,finYear,loginType,formRole);
	}

	@Override
	public List<Object[]> getFundApprovedList(String empId, String finYear,String loginType) throws Exception {
		return fbedao.getFundApprovedList(empId,finYear,loginType);
	}

	@Override
	public List<Object[]> getParticularFundApprovalDetails(String fundApprovalId,long empId) throws Exception {
		return fbedao.getParticularFundApprovalDetails(fundApprovalId,empId);
	}
	
	@Override
	public List<Object[]> getParticularFundApprovalTransDetails(String fundApprovalId) throws Exception{
		return fbedao.getParticularFundApprovalTransDetails(fundApprovalId);
	}

	@Override
	public long updateRecommendAndApprovalDetails(FundApprovalDto fundDto, long empId) throws Exception {
		
		FundApproval fundApproval=fbedao.getFundRequestDetails(fundDto.getFundApprovalId());
		String[] employeeDetails=getCurrentEmployeeFundDetails(empId, fundApproval.getFundApprovalId());
		FundApprovalTrans transaction=new FundApprovalTrans(); 
		transaction.setFundApprovalId(fundApproval.getFundApprovalId());
		transaction.setRcStausCode(employeeDetails!=null && employeeDetails.length > 0 ? employeeDetails[0] : null);
		transaction.setRemarks(fundDto.getRemarks());
		transaction.setRole(employeeDetails!=null && employeeDetails.length > 0 ? employeeDetails[1] : null);
		transaction.setActionBy(empId);
		transaction.setActionDate(LocalDateTime.now());
		long transStatus=fbedao.insertFundApprovalTransaction(transaction);
		
			if(fundDto.getAction()!=null)
			{
				if(!fundDto.getAction().equalsIgnoreCase("R"))  // Except return 
				{
					fbedao.updateParticularLinkedCommitteeDetails(empId,fundApproval.getFundApprovalId(),"Y");
				}
				
				if(fundDto.getAction().equalsIgnoreCase("R")) 
				{
					List<Object[]> masterFlowList=fbedao.getMasterFlowDetails(getTotalOfCashoutgoCost(fundApproval).toString(),fundApproval.getFundApprovalId());
					if(masterFlowList!=null && masterFlowList.size()>0)
					{
						masterFlowList.forEach(row -> 
						{
							try {
									if(row[4]!=null)
									{
										fbedao.updateParticularLinkedCommitteeDetails(Long.parseLong(row[4].toString()),fundApproval.getFundApprovalId(),"N");	
									}
							} catch (Exception e) {
								e.printStackTrace();
							}
						});

					}
				}
			}
		
		long status=0;
			if(fundDto.getAction()!=null)
			{
				if(!fundDto.getAction().equalsIgnoreCase("RE")) //  RE - Recommend
				{
					fundApproval.setStatus(fundDto.getAction());
				}
			}
			fundApproval.setStatus(fundApproval.getStatus());
			status=fbedao.updateFundRequest(fundApproval);
		
		//List<Object[]> masterFlowList=fbedao.getMasterFlowDetails(getTotalOfCashoutgoCost(fundApproval).toString());
		//fundApproval.setRcStatusCode(fundApproval.getRcStatusCodeNext());
		//fundApproval.setRcStatusCodeNext(fundDto.getAction()!=null && !fundDto.getAction().equalsIgnoreCase("A") ? (fundApproval.getRcStatusCodeNext()!=null ? getRcStatusCodeNext(masterFlowList,fundApproval.getRcStatusCodeNext()) : null) : fundApproval.getRcStatusCodeNext());
		
		return status;
	}

	@Override
	public List<Object[]> getAllCommitteeMemberDetails(LocalDate currentDate) throws Exception {
		return fbedao.getAllCommitteeMemberDetails(currentDate);
	}
	
	@Override
	public List<Object[]> getFundReportList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost, String status)  throws Exception{
		
		return fbedao.getFundReportList(finYear, divisionId, estimateType, loginType, empId, projectId, budgetHeadId, budgetItemId, fromCost, toCost, status);
	}
	
	@Override
	public List<BudgetDetails> getBudgetHeadList(String projectId) throws Exception {
		
		List<Object[]> budgetHeadList=null;
		if(projectId!=null) 
		{
			if(!projectId.equalsIgnoreCase("0"))
			{
				budgetHeadList=fbedao.getProjectBudgetHeadList(projectId);
			}
			
			if(projectId.equalsIgnoreCase("0"))
			{
				budgetHeadList=fbedao.getGeneralBudgetHeadList();
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
			BudgetHeadItem=fbedao.getPrjBudgetHeadItem(ProjectId,budgetHeadId);
		}
		else
		{
			BudgetHeadItem=fbedao.getGenBudgetHeadItem(budgetHeadId);
		}
		return BudgetHeadItem;
	}

	@Override
	public String getCommitteeMemberCurrentStatus(String empId) throws Exception {
		List<Object[]> list=fbedao.getCommitteeMemberCurrentStatus(empId);
		String memberType=null;
		if(list!=null && list.size()>0)
		{
			memberType=list.get(0)!=null && list.get(0).length>0 && list.get(0)[1]!=null ? list.get(0)[1].toString() : null;
		}
		return memberType;
	}
	
}
