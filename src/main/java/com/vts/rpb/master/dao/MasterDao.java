package com.vts.rpb.master.dao;

import java.util.List;

import com.vts.rpb.master.modal.AuditStamping;

public interface MasterDao 
{
	public long insertAuditStampingDetails(AuditStamping audit) throws Exception;

	public Object[] getUserFullDetails(long loginId) throws Exception;

	public AuditStamping getAuditPatchDetails(long auditStampingId) throws Exception;

	public long updateLoginStampingDetails(AuditStamping auditDetails) throws Exception;
	
	public List<Object[]> GetLabInfo(String Labcode) throws Exception;

	public List<Object[]> getDivisionList(String labCode, String empId, String loginType) throws Exception;

	public List<Object[]> getOfficersList() throws Exception;

	public List<Object[]> getAllOfficersList() throws Exception;

	public List<Object[]> getAllEmployeeDetailsByDivisionId(String divisionId) throws Exception;
}
