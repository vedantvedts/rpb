package com.vts.rpb.fundapproval.service;

import java.time.LocalDate;
import java.util.List;

import com.google.gson.JsonElement;
import com.vts.rpb.fundapproval.dto.BudgetDetails;
import com.vts.rpb.fundapproval.dto.FundApprovalAttachDto;
import com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto;
import com.vts.rpb.fundapproval.dto.FundApprovalDto;
import com.vts.rpb.fundapproval.dto.FundRequestCOGDetails;
import com.vts.rpb.fundapproval.modal.FundApproval;
import com.vts.rpb.fundapproval.modal.FundApprovedRevision;

public interface FundApprovalService 
{
	public List<Object[]> getFundApprovalList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId,String committeeMember) throws Exception;

	public long AddFundRequestSubmit(FundApproval approval, FundApprovalAttachDto attachDto, Long userId) throws Exception;
	
	public long EditFundRequestSubmit(FundApproval approval, FundApprovalAttachDto attachDto) throws Exception;
	
	public long RevisionFundRequestSubmit(FundApproval approved, FundApprovalAttachDto attachDto) throws Exception;

	public List<Object[]> getMasterFlowDetails(String fundRequestId) throws Exception;
	
	public Object[] getFundRequestObj(long fundApprovalId) throws Exception;
	
	public List<Object[]> getFundRequestAttachList(long fundApprovalId) throws Exception;
	
	public Object[] FundRequestAttachData(long fundApprovalAttachId) throws Exception;
	
	public int FundRequestAttachDelete(long fundApprovalAttachId) throws Exception;

	public long fundRequestForward(FundApprovalDto fundDto, long empId) throws Exception;

	public FundApproval getFundRequestDetails(String fundRequestId) throws Exception;

	public List<Object[]> getFundPendingList(String empId,String finYear,String loginType,long formRole) throws Exception;

	public List<Object[]> getFundApprovedList(String empId, String finYear,String loginType) throws Exception;

	public List<Object[]> getParticularFundApprovalDetails(String fundApprovalId,long empId) throws Exception;
	
	public List<Object[]> getParticularFundApprovalTransDetails(String fundApprovalId) throws Exception;

	public long updateRecommendAndApprovalDetails(FundApprovalDto fundDto, long empId) throws Exception;

	public List<Object[]> getAllCommitteeMemberDetails(LocalDate currentDate) throws Exception;

	public List<Object[]> getFundReportList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost, String status,String committeeMember,String RupeeValue)  throws Exception;
	
	public List<BudgetDetails> getBudgetHeadList(String projectId) throws Exception;
	
	public List<Object[]> getBudgetHeadItem(long ProjectId, long budgetHeadId) throws Exception;
	
	public String getCommitteeMemberCurrentStatus(String empId) throws Exception;

	public List<Object[]> getFundRequestCarryForwardDetails(FundApprovalBackButtonDto fundApprovalDto,String labCode,String action) throws Exception;
	
	public List<Object[]> estimateTypeParticularDivList(long divisionId, String estimateType,String finYear, String loginType,String empId, String budgetHeadId, String budgetItemId,String fromCost, String toCost,String status,String memberType,int RupeeValue) throws Exception;

	public long insertCarryForwardItemDetails(FundRequestCOGDetails cogMonth, FundApprovalBackButtonDto dto, String userName) throws Exception;

	public String getCommitteeMemberType (long empId) throws Exception;

	public List<Object[]> getProposedProjectDetails() throws Exception;
	
	public List<Object[]> getAttachmentDetails(String fundApprovalId) throws Exception;
	
	public FundApproval getExisitingFundApprovalList(String fundApprovalId) throws Exception;
	
	public long getRevisionListDetails(String fundApprovalId,String UserName) throws Exception;

	public long deleteFundRequest(FundApprovalDto fundDto) throws Exception;

	public long revokeRecommendationDetails(FundApprovalDto fundDto, long empId) throws Exception;

	public long editRecommendationDetails(FundApprovalDto fundDto, long empId) throws Exception;
}
