package com.vts.rpb.reports.dao;

import java.util.List;

public interface ReportDao 
{
	public List<Object[]> estimateTypeParticularDivList(String divisionId, String estimateType,String finYear, String loginType,String empId, String budget, String proposedProject, String budgetHeadId, String budgetItemId,String fromCost, String toCost,String status,String memberType,int RupeeValue) throws Exception;
}
