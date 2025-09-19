package com.vts.rpb.reports.service;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.vts.rpb.reports.dao.ReportDao;

@Service
public class ReportServiceImpl implements ReportService
{
	private static final Logger logger=LogManager.getLogger(ReportServiceImpl.class);
	
	@Autowired
	ReportDao reportDao;
	
	@Override
	public List<Object[]> estimateTypeParticularDivList(String divisionId, String estimateType,String finYear, String loginType,String empId, String budget, String proposedProject, String budgetHeadId, String budgetItemId,String fromCost, String toCost,String status,String memberType,int RupeeValue) throws Exception{
		return reportDao.estimateTypeParticularDivList(divisionId, estimateType,finYear,loginType,empId, budget, proposedProject, budgetHeadId,budgetItemId,fromCost,toCost,status,memberType,RupeeValue);
	}
	
	
}
