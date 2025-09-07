package com.vts.rpb.master.dao;

import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.vts.rpb.fundapproval.modal.CommitteeMembers;
import com.vts.rpb.master.modal.AuditStamping;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.transaction.Transactional;

@Transactional
@Repository
public class MasterDaoImpl implements MasterDao {
	
	private static final Logger logger=LogManager.getLogger(MasterDaoImpl.class);
	
	@PersistenceContext
	EntityManager manager;
	
	@Value("${MdmDb}")
	private String mdmdb;

	@Override
	public long insertAuditStampingDetails(AuditStamping audit) throws Exception {
		logger.info(new Date() + "Inside DaoImpl insertAuditStampingDetails()");
		try {
			manager.persist(audit);
			manager.flush();
			return audit.getAuditStampingId();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date()+"Inside DaoImpl insertAuditStampingDetails" ,e);
			return 0;
		}
	}

	@Override
	public Object[] getUserFullDetails(long loginId) throws Exception {
		logger.info(new Date() +"Inside DAOImpl getUserFullDetails()");
		try {
			Query query=manager.createNativeQuery("SELECT CONCAT(IFNULL(CONCAT(e.Title,' '),''), e.EmpName) AS 'empname', fr.FormRoleName, e.EmpNo, e.LabCode, ed.Designation, d.DivisionCode, d.DivisionName FROM login l INNER JOIN "+mdmdb+".employee e ON e.EmpId=l.EmpId LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId=e.DesigId LEFT JOIN form_role fr ON fr.FormRoleId=l.FormRoleId LEFT JOIN "+mdmdb+".division_master d ON d.DivisionId=e.DivisionId WHERE l.LoginId=:loginId");
			query.setParameter("loginId", loginId);
			List<Object[]> list=(List<Object[]>)query.getResultList();
			
			if(list!=null && list.size()>0)
			{
				return list.get(0);
			}
			
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date() +"Inside DAOImpl  getUserFullDetails() "+ e);
			return null;
		}
	}

	@Override
	public AuditStamping getAuditPatchDetails(long auditStampingId) throws Exception {
		logger.info(new Date() + "Inside DaoImpl getAuditPatchDetails()");
		try {
			return manager.find(AuditStamping.class,auditStampingId);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date()+"Inside DaoImpl getAuditPatchDetails" ,e);
			return null;
		}
	}

	@Override
	public long updateLoginStampingDetails(AuditStamping auditDetails) throws Exception {
		logger.info(new Date() + "Inside DaoImpl updateLoginStampingDetails()");
		try {
			manager.merge(auditDetails);
			manager.flush();
			return auditDetails.getAuditStampingId();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date()+"Inside DaoImpl updateLoginStampingDetails" ,e);
			return 0;
		}
	}
	
	@Override
	public List<Object[]> GetLabInfo(String Labcode) throws Exception {
		logger.info(new Date() +"Inside DAOImpl GetLabInfo() ");
		try
		{
			Query query= manager.createNativeQuery("SELECT a.LabCode, a.LabName, a.LabUnitCode, a.LabAddress, a.LabCity, a.LabPin  FROM lab_master a WHERE a.LabCode=:Labcode");
			query.setParameter("Labcode", Labcode);
			List<Object[]> LabInfo=  (List<Object[]>)query.getResultList();
			return LabInfo;
		}		
		catch (Exception e)
		{
			logger.error(new Date()  + "Inside DAO GetLabInfo() " + e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Object[]> getDivisionList(String labCode,String empId,String logintype,String committeeMember) throws Exception {
		logger.info(new Date() +"Inside DaoImpl getDivisionList");
		try
		{
			Query query=manager.createNativeQuery("SELECT DISTINCT d.DivisionId, d.DivisionCode, d.LabCode, d.DivisionName, d.IsActive FROM "+mdmdb+".division_master d INNER JOIN "+mdmdb+".employee e ON e.DivisionId=d.DivisionId AND e.LabCode=:labCode AND e.IsActive='1' AND (CASE WHEN 'A' =:logintype OR :committeeMember IN ('CS', 'CC')  THEN 1=1 ELSE e.EmpId =:empId END) WHERE d.LabCode =:labCode AND d.IsActive='1'");
			query.setParameter("labCode", labCode);
			query.setParameter("empId", empId);
			query.setParameter("logintype", logintype);
			query.setParameter("committeeMember", committeeMember);
			List<Object[]> List=(List<Object[]>)query.getResultList();
			return List;
		}
		catch(Exception e)
		{
			logger.error(new Date() +"Inside DAO getDivisionList() "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Object[]> getOfficersList() throws Exception {
		logger.info(new Date() +"Inside MaterDaoImpl getOfficerList");
		try {
		Query query=manager.createNativeQuery("SELECT a.EmpId, a.EmpNo, CONCAT(IFNULL(CONCAT(a.Title,' '),''), a.EmpName) AS 'EmpName' , b.Designation, a.ExtNo, a.Email, c.DivisionName, a.DesigId, a.DivisionId, a.SrNo, a.IsActive,a.LabCode,a.PunchCardNo  FROM "+mdmdb+".employee a,"+mdmdb+".employee_desig b, "+mdmdb+".division_master c WHERE a.DesigId= b.DesigId AND a.DivisionId= c.DivisionId  ORDER BY a.SrNo=0,a.SrNo");
		List<Object[]> OfficerList=(List<Object[]>)query.getResultList();
		return OfficerList;
		
		} catch (Exception e) {
			logger.error(new Date() +"Inside MaterDaoImpl getOfficerList");
			e.printStackTrace();
			return null; 
		}
	}

	@Override
	public List<Object[]> getAllOfficersList() throws Exception {
		logger.info(new Date() +"Inside MaterDaoImpl getAllOfficersList");
		try {
		Query query=manager.createNativeQuery("SELECT a.EmpId, a.EmpNo, CONCAT(IFNULL(CONCAT(a.Title,' '),''), a.EmpName) AS 'EmpName' , b.Designation, a.ExtNo, a.Email, c.DivisionName, a.DesigId, a.DivisionId, a.SrNo, a.IsActive,a.LabCode,a.PunchCardNo  FROM "+mdmdb+".employee a,"+mdmdb+".employee_desig b,"+mdmdb+".division_master c WHERE a.DesigId= b.DesigId AND a.DivisionId= c.DivisionId AND a.IsActive = '1' ORDER BY a.SrNo=0,a.SrNo ");
		List<Object[]> OfficerList=(List<Object[]>)query.getResultList();
		return OfficerList;
		
		} catch (Exception e) {
			logger.error(new Date() +"Inside MaterDaoImpl getAllOfficersList");
			e.printStackTrace();
			return null; 
		}
	}

	@Override
	public List<Object[]> getAllEmployeeDetailsByDivisionId(String divisionId) throws Exception {
		logger.info(new Date() +"Inside MaterDaoImpl getAllEmployeeDetailsByDivisionId");
		try {
		Query query= manager.createNativeQuery("SELECT e.EmpId, e.LabCode, e.EmpNo, e.EmpName, e.DesigId, d.Designation, CONCAT(e.EmpName, ', ', d.Designation) AS MergedName, e.DivisionId FROM "+mdmdb+".employee e LEFT JOIN "+mdmdb+".employee_desig d ON d.DesigId = e.DesigId WHERE e.DivisionId = :DivisionId AND e.IsActive = '1'");
		query.setParameter("DivisionId",divisionId);
		List<Object[]> OfficerList=(List<Object[]>)query.getResultList();
		return OfficerList;
		
		} catch (Exception e) {
			logger.error(new Date() +"Inside MaterDaoImpl getAllEmployeeDetailsByDivisionId");
			e.printStackTrace();
			return null; 
		}
	}

	@Override
	public List<Object[]> getCommitteeMasterList() throws Exception {
		logger.info(new Date() +"Inside MaterDaoImpl getCommitteeMasterList");
		try {
		Query query= manager.createNativeQuery("SELECT cm.MemberType, cm.EmpId, cm.FromDate, cm.ToDate, e.EmpName, d.DesigCode, cm.CommitteeMemberId FROM ibas_committee_members cm INNER JOIN "+mdmdb+".employee e ON e.EmpId=cm.EmpId LEFT JOIN "+mdmdb+".employee_desig d ON d.DesigId = e.DesigId WHERE cm.IsActive='1'");
		List<Object[]> getCommitteeMasterList=(List<Object[]>)query.getResultList();
		return getCommitteeMasterList;
		
		} catch (Exception e) {
			logger.error(new Date() +"Inside MaterDaoImpl getCommitteeMasterList");
			e.printStackTrace();
			return null; 
		}
	}

	@Override
	public long saveCommitteeMembers(CommitteeMembers cm) throws Exception {
		logger.info(new Date() +"Inside MaterDaoImpl saveCommitteeMembers");
		try {
			manager.persist(cm);
			manager.flush();
			
			return cm.getCommitteeMemberId();
		}catch(Exception e) {
			logger.error(new Date() +"Inside MaterDaoImpl saveCommitteeMembers");
			e.printStackTrace();
			return 0; 
		}
	}

	@Override
	public CommitteeMembers getCommitteeMemberDetails(long committeeMemberId) throws Exception {
		
		return  manager.find(CommitteeMembers.class, committeeMemberId);
	}

	@Override
	public long EditCommitteMemberDetails(CommitteeMembers comMember) throws Exception {
		try {
			manager.merge(comMember);
			manager.flush();
			return comMember.getCommitteeMemberId();

		} catch (Exception e) {
			logger.error(new Date() +"Inside DAO updateFundRequest() "+ e);
			e.printStackTrace();
			return 0;
		}
	}

}
