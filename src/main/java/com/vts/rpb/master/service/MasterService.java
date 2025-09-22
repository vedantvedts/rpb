package com.vts.rpb.master.service;

import java.util.List;

import com.vts.rpb.fundapproval.modal.CommitteeMembers;
import com.vts.rpb.master.modal.AuditStamping;

public interface MasterService 
{
	public long insertAuditStampingDetails(AuditStamping audit) throws Exception;
	
	public List<Object[]> GetLabInfo(String LabCode) throws Exception;

	public List<Object[]> getOfficersList(String labCode) throws Exception;

	public List<Object[]> getDivisionList(String labCode, String empId, String loginType,String committeeMember) throws Exception;

	public List<Object[]> getAllOfficersList(String labCode) throws Exception;

	public List<Object[]> getAllEmployeeDetailsByDivisionId(String divisionId) throws Exception;

	public List<Object[]> CommitteeMasterList()throws Exception;

	public long saveCommitteeMembers(CommitteeMembers cm)throws Exception;

	public long EditCommitteeMembers(CommitteeMembers cm)throws Exception;

	public Object[] getDivisionDetails(String divisionId) throws Exception;
}