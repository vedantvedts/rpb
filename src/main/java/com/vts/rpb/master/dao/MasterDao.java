package com.vts.rpb.master.dao;

import java.util.List;

import com.vts.rpb.fundapproval.modal.CommitteeMembers;
import com.vts.rpb.master.modal.AuditStamping;

public interface MasterDao 
{
	public long insertAuditStampingDetails(AuditStamping audit) throws Exception;

	public Object[] getUserFullDetails(long loginId) throws Exception;

	public AuditStamping getAuditPatchDetails(long auditStampingId) throws Exception;

	public long updateLoginStampingDetails(AuditStamping auditDetails) throws Exception;
	
	public List<Object[]> GetLabInfo(String Labcode) throws Exception;

	public List<Object[]> getDivisionList(String labCode, String empId, String loginType,String committeeMember) throws Exception;

	public List<Object[]> getOfficersList(String labCode) throws Exception;

	public List<Object[]> getAllOfficersList(String labCode) throws Exception;

	public List<Object[]> getAllEmployeeDetailsByDivisionId(String divisionId) throws Exception;

	public List<Object[]> getCommitteeMasterList()throws Exception;

	public long saveCommitteeMembers(CommitteeMembers cm)throws Exception;

	public CommitteeMembers getCommitteeMemberDetails(long committeeMemberId)throws Exception;

	public long EditCommitteMemberDetails(CommitteeMembers comMember)throws Exception;

	public List<Object[]> getParticularDivisionDetails(String divisionId)throws Exception;
}