package com.vts.rpb.reports.service;

import java.util.List;

public interface ReportService 
{
	public List<Object[]> estimateTypeParticularDivList(String divisionId, String estimateType,String finYear, String loginType,String empId, String buget, String proposedProject, String budgetHeadId, String budgetItemId,String fromCost, String toCost,String status,String memberType,int RupeeValue) throws Exception;
}
