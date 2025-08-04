package com.vts.rpb.master.service;

import java.util.List;

import com.vts.rpb.master.modal.AuditStamping;

public interface MasterService 
{
	public long insertAuditStampingDetails(AuditStamping audit) throws Exception;
	
	public List<Object[]> GetLabInfo(String LabCode) throws Exception;

	public List<Object[]> getOfficersList() throws Exception;

	public List<Object[]> getDivisionList(String labCode, String empId, String loginType) throws Exception;

	public List<Object[]> getAllOfficersList() throws Exception;

	public List<Object[]> getAllEmployeeDetailsByDivisionId(String divisionId) throws Exception;
}
