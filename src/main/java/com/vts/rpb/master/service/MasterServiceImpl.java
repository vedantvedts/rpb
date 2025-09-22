package com.vts.rpb.master.service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.vts.rpb.fundapproval.modal.CommitteeMembers;
import com.vts.rpb.master.dao.MasterDao;
import com.vts.rpb.master.modal.AuditStamping;

@Service
public class MasterServiceImpl implements MasterService 
{
	private static final Logger logger=LogManager.getLogger(MasterServiceImpl.class);

	@Autowired
	MasterDao masterDao; 

	@Override
	public long insertAuditStampingDetails(AuditStamping audit) throws Exception {
		return masterDao.insertAuditStampingDetails(audit);
	}
	
	@Override
	public List<Object[]> GetLabInfo(String Labcode) throws Exception {
		logger.info(new Date() +"Inside serviceImpl LabInfo");	
		return masterDao.GetLabInfo(Labcode);
	}

	@Override
	public List<Object[]> getOfficersList(String labCode) throws Exception {
		return masterDao.getOfficersList(labCode);
	}

	@Override
	public List<Object[]> getDivisionList(String labCode, String empId, String loginType,String committeeMember) throws Exception {
		return masterDao.getDivisionList(labCode,empId,loginType,committeeMember);
	}

	@Override
	public List<Object[]> getAllOfficersList(String labCode) throws Exception {
		return masterDao.getAllOfficersList(labCode);
	}

	@Override
	public List<Object[]> getAllEmployeeDetailsByDivisionId(String divisionId) throws Exception {
		return masterDao.getAllEmployeeDetailsByDivisionId(divisionId);
	}

	@Override
	public List<Object[]> CommitteeMasterList() throws Exception {
		
		return masterDao.getCommitteeMasterList();
	}

	@Override
	public long saveCommitteeMembers(CommitteeMembers cm) throws Exception {
		
		return masterDao.saveCommitteeMembers(cm);
	}

	@Override
	public long EditCommitteeMembers(CommitteeMembers cm) throws Exception {
		try {
			CommitteeMembers comMember= masterDao.getCommitteeMemberDetails(cm.getCommitteeMemberId());
			
			comMember.setMemberType(cm.getMemberType());
			comMember.setEmpId(cm.getEmpId());
			comMember.setFromDate(cm.getFromDate());
			comMember.setToDate(cm.getToDate());
			comMember.setModifiedBy(cm.getModifiedBy());
			comMember.setModifiedDate(LocalDateTime.now());
			
			
			return masterDao.EditCommitteMemberDetails(comMember);
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return 0;
		
	}

	@Override
	public Object[] getDivisionDetails(String divisionId) throws Exception {
		Object[] divisionDetails = null;
		List<Object[]> list = masterDao.getParticularDivisionDetails(divisionId);
		if(list!=null && list.size() > 0)
		{
			divisionDetails = list.get(0);
		}
		return divisionDetails;
	}

}