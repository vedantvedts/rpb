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
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.IntStream;

import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.vts.rpb.fundapproval.dao.FundApprovalDao;
import com.vts.rpb.fundapproval.dto.FundApprovalAttachDto;
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
				transModal.setRcStausCode(fundApproval.getRcStatusCode());
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
	public List<Object[]> getMasterFlowDetails(String estimatedCost) throws Exception {
		return fbedao.getMasterFlowDetails(estimatedCost);
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
		
		List<Object[]> masterFlowList=fbedao.getMasterFlowDetails(estimatedCost!=null ? estimatedCost : "0");
		
		String statusCodeNext=fundApprovalData.getRcStatusCodeNext();
		fundApprovalData.setRcStatusCode(statusCodeNext);
		fundApprovalData.setRcStatusCodeNext(statusCodeNext!=null ? getRcStatusCodeNext(masterFlowList,statusCodeNext) : null);
		fundApprovalData.setStatus("F");
		fundApprovalData.setModifiedBy(fundApprovalData.getModifiedBy());
		fundApprovalData.setModifiedDate(fundApprovalData.getModifiedDate());
		long approvalStatus=fbedao.updateFundRequest(fundApprovalData);
		
		if(approvalStatus>0)
		{
			FundApprovalTrans transaction=new FundApprovalTrans(); 
			transaction.setFundApprovalId(fundApprovalData.getFundApprovalId());
			transaction.setRcStausCode(fundApprovalData.getRcStatusCode());
			transaction.setActionBy(empId);
			transaction.setActionDate(LocalDateTime.now());
			long transStatus=fbedao.insertFundApprovalTransaction(transaction);
			
			if(transStatus>0)
			{
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
			;
		}
		return approvalStatus;
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
		return fbedao.getFundRequestDetails(fundRequestId);
	}

	@Override
	public List<Object[]> getFundPendingList(String empId,String finYear,String loginType) throws Exception {
		return fbedao.getFundPendingList(empId,finYear,loginType);
	}

	@Override
	public List<Object[]> getFundApprovedList(String empId, String finYear,String loginType) throws Exception {
		return fbedao.getFundApprovedList(empId,finYear,loginType);
	}

	@Override
	public List<Object[]> getParticularFundApprovalDetails(String fundApprovalId) throws Exception {
		return fbedao.getParticularFundApprovalDetails(fundApprovalId);
	}
	
	@Override
	public List<Object[]> getParticularFundApprovalTransDetails(String fundApprovalId) throws Exception{
		return fbedao.getParticularFundApprovalTransDetails(fundApprovalId);
	}

	@Override
	public long updateRecommendAndApprovalDetails(String fundApprovalId, String empId,String action) throws Exception {
		
		FundApproval fundApproval=fbedao.getFundRequestDetails(fundApprovalId);
		
		List<Object[]> masterFlowList=fbedao.getMasterFlowDetails(getTotalOfCashoutgoCost(fundApproval).toString());
		
		fundApproval.setRcStatusCode(fundApproval.getRcStatusCodeNext());
		fundApproval.setRcStatusCodeNext(action!=null && !action.equalsIgnoreCase("A") ? (fundApproval.getRcStatusCodeNext()!=null ? getRcStatusCodeNext(masterFlowList,fundApproval.getRcStatusCodeNext()) : null) : fundApproval.getRcStatusCodeNext());
		fundApproval.setStatus(action!=null && action.equalsIgnoreCase("A") ? "A" : fundApproval.getStatus());
		long status=fbedao.updateFundRequest(fundApproval);
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
	
}
