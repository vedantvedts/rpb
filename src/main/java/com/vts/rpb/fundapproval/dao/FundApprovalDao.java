package com.vts.rpb.fundapproval.dao;

import java.time.LocalDate;
import java.util.List;

import com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto;
import com.vts.rpb.fundapproval.modal.FundApproval;
import com.vts.rpb.fundapproval.modal.FundApprovalAttach;
import com.vts.rpb.fundapproval.modal.FundApprovalTrans;
import com.vts.rpb.fundapproval.modal.LinkedCommitteeMembers;

public interface FundApprovalDao 
{
public long AddFundRequestSubmit(FundApproval modal) throws Exception;
	
	public long AddFundApprovalTrans(FundApprovalTrans transModal) throws Exception;
	
	public long EditFundRequestSubmit(FundApproval modal) throws Exception;
	
	public long AddFundRequestAttachSubmit(FundApprovalAttach Attach) throws Exception;

	public List<Object[]> getFundApprovalList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId) throws Exception;

	public List<Object[]> getMasterFlowDetails(String estimatedCost,long fundRequestId) throws Exception;

	public Object[] getFundRequestObj(long fundApprovalId) throws Exception;
	
	public List<Object[]> getFundRequestAttachList(long fundApprovalId) throws Exception;
	
	public Object[] FundRequestAttachData(long fundApprovalAttachId) throws Exception;
	
	public int FundRequestAttachDelete(long fundApprovalAttachId) throws Exception;

	public FundApproval getFundRequestDetails(long fundRequestId) throws Exception;

	public long updateFundRequest(FundApproval fundApprovalData) throws Exception;

	public List<Object[]> getFundPendingList(String empId,String finYear,String loginType,long formRole) throws Exception;

	public List<Object[]> getFundApprovedList(String empId, String finYear,String loginType) throws Exception;

	public List<Object[]> getParticularFundApprovalDetails(String fundApprovalId,long empId) throws Exception;

	
	public List<Object[]> getParticularFundApprovalTransDetails(String fundApprovalId) throws Exception;
	
	public List<Object[]> getAllCommitteeMemberDetails(LocalDate currentDate) throws Exception;
	
	public List<Object[]> getFundReportList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost, String status)  throws Exception;

	public long insertFundApprovalTransaction(FundApprovalTrans transaction) throws Exception;

	public long insertLinkedCommitteeMembers(LinkedCommitteeMembers linkedMembers) throws Exception;
	
	public List<Object[]> getProjectBudgetHeadList(String projectId) throws Exception;
	
	public List<Object[]> getGeneralBudgetHeadList() throws Exception;
	
	public List<Object[]> getPrjBudgetHeadItem(long projectId, long budgetHeadId) throws Exception;
	
	public List<Object[]> getGenBudgetHeadItem(long budgetHeadId) throws Exception;

	public List<Object[]> getCommitteeMemberCurrentStatus(String empId) throws Exception;

	public int updateParticularLinkedCommitteeDetails(long empId, long fundApprovalId,String isApproved) throws Exception;

	public int getFundApprovalIdCountFromCommitteeLinked(long fundApprovalId) throws Exception;
	
	public int updateFundRequestAttach(FundApprovalAttach attach) throws Exception;
	
	public Object[] findAttachmentByFundAndName(long fundApprovalId, String fileName) throws Exception;

	public List<Object[]> getMaxSerialNoCount(String fbeReYear, String estimateType) throws Exception;

	public List<Object[]> getFundRequestCarryForwardDetails(FundApprovalBackButtonDto fundApprovalDto,String labCode,String action) throws Exception;
	
	public List<Object[]> estimateTypeParticularDivList(long divisionId, String estimateType,String finYear, String loginType,String empId, String budgetHeadId, String budgetItemId,String fromCost, String toCost,String status,String memberType) throws Exception;

	public long insertCarryForwardItemDetails(FundApproval fundRequest) throws Exception;

	public String getCommitteeMemberType (long empId) throws Exception;

	public List<Object[]> getDemandDetails(String demandId) throws Exception;

	public List<Object[]> getCommitmmentDetails(String commitmentId) throws Exception;
}
