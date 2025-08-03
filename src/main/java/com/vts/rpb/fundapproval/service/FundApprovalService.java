package com.vts.rpb.fundapproval.service;

import java.time.LocalDate;
import java.util.List;

import com.vts.rpb.fundapproval.dto.BudgetDetails;
import com.vts.rpb.fundapproval.dto.FundApprovalAttachDto;
import com.vts.rpb.fundapproval.dto.FundApprovalDto;
import com.vts.rpb.fundapproval.modal.FundApproval;

public interface FundApprovalService 
{
	public List<Object[]> getFundApprovalList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId)  throws Exception;

	public long AddFundRequestSubmit(FundApproval approval, FundApprovalAttachDto attachDto) throws Exception;
	
	public long EditFundRequestSubmit(FundApproval approval, FundApprovalAttachDto attachDto) throws Exception;

	public List<Object[]> getMasterFlowDetails(String estimatedCost,String fundRequestId) throws Exception;
	
	public Object[] getFundRequestObj(long fundApprovalId) throws Exception;
	
	public List<Object[]> getFundRequestAttachList(long fundApprovalId) throws Exception;
	
	public Object[] FundRequestAttachData(long fundApprovalAttachId) throws Exception;
	
	public int FundRequestAttachDelete(long fundApprovalAttachId) throws Exception;

	public long fundRequestForward(FundApproval fundApprovalData,String flowMasterId,String estimatedCost,long empId) throws Exception;

	public FundApproval getFundRequestDetails(String fundRequestId) throws Exception;

	public List<Object[]> getFundPendingList(String empId,String finYear,String loginType,long formRole) throws Exception;

	public List<Object[]> getFundApprovedList(String empId, String finYear,String loginType) throws Exception;

	public List<Object[]> getParticularFundApprovalDetails(String fundApprovalId,long empId) throws Exception;
	
	public List<Object[]> getParticularFundApprovalTransDetails(String fundApprovalId) throws Exception;

	public long updateRecommendAndApprovalDetails(FundApprovalDto fundDto, long empId) throws Exception;

	public List<Object[]> getAllCommitteeMemberDetails(LocalDate currentDate) throws Exception;

	public List<Object[]> getFundReportList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost, String status)  throws Exception;
	
	public List<BudgetDetails> getBudgetHeadList(String projectId) throws Exception;
	
	public List<Object[]> getBudgetHeadItem(long ProjectId, long budgetHeadId) throws Exception;
	
	public String getCommitteeMemberCurrentStatus(String empId) throws Exception;
}
