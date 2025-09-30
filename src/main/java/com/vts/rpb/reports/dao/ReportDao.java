package com.vts.rpb.reports.dao;

import java.util.List;

public interface ReportDao 
{
	public List<Object[]> estimateTypeParticularDivList(String divisionId, String estimateType,String finYear, String loginType,String empId, String budget, String proposedProject, String budgetHeadId, String budgetItemId,String fromCost, String toCost,String status,String memberType,int RupeeValue) throws Exception;
	
	public List<Object[]> getFundReportList(String finYear, String divisionId, String estimateType, String loginType,String empId, String  budget,String proposedProject, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost, String status,String committeeMember,String RupeeValue)  throws Exception;
	
	public List<Object[]> getFbeReportList(String finYear, String divisionId, String loginType,String empId, String  budget,String proposedProject, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost,String committeeMember,String RupeeValue)  throws Exception;
	
	public List<Object[]> getNoteSheetFundDetails(String fundApprovalId);
	
	public List<Object[]> getNoteSheetMemberDetails(String fundApprovalId);
}
