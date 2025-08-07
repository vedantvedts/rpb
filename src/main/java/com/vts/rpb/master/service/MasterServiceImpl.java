package com.vts.rpb.master.service;

import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	public List<Object[]> getOfficersList() throws Exception {
		return masterDao.getOfficersList();
	}

	@Override
	public List<Object[]> getDivisionList(String labCode, String empId, String loginType) throws Exception {
		return masterDao.getDivisionList(labCode,empId,loginType);
	}

	@Override
	public List<Object[]> getAllOfficersList() throws Exception {
		return masterDao.getAllOfficersList();
	}

	@Override
	public List<Object[]> getAllEmployeeDetailsByDivisionId(String divisionId) throws Exception {
		return masterDao.getAllEmployeeDetailsByDivisionId(divisionId);
	}

}
