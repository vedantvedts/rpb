package com.vts.rpb.fundapproval.dao;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.stereotype.Repository;

import com.vts.rpb.fundapproval.dto.FundApprovalBackButtonDto;
import com.vts.rpb.fundapproval.modal.FundApproval;
import com.vts.rpb.fundapproval.modal.FundApprovalAttach;
import com.vts.rpb.fundapproval.modal.FundApprovalQueries;
import com.vts.rpb.fundapproval.modal.FundApprovalTrans;
import com.vts.rpb.fundapproval.modal.FundApprovedRevision;
import com.vts.rpb.fundapproval.modal.FundLinkedMembers;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Repository
public class FundApprovalDaoImpl implements FundApprovalDao {
	
	private static final Logger logger=LogManager.getLogger(FundApprovalDaoImpl.class);
	
	@PersistenceContext
	EntityManager manager;
	
	@Value("${MdmDb}")
	private String mdmdb;

	@Override
	public List<Object[]> getFundApprovalList(String finYear, String divisionId, String estimateType, String loginType,String empId, String projectId,String committeeMember) throws Exception {
		try {

			Query query= manager.createNativeQuery("SELECT f.FundApprovalId,f.EstimateType,f.DivisionId,f.FinYear,f.REFBEYear,f.ProjectId,f.BudgetHeadId,h.BudgetHeadDescription,f.BudgetItemId,i.HeadOfAccounts,i.MajorHead,i.MinorHead,i.SubHead,i.SubMinorHead,f.BookingId,f.CommitmentPayIds,f.ItemNomenclature,f.Justification,ROUND((f.Apr + f.May + f.Jun + f.Jul + f.Aug + f.Sep + f.Oct + f.Nov + f.December + f.Jan + f.Feb +f.Mar),2) AS EstimatedCost,f.InitiatingOfficer,e.EmpName,ed.Designation,f.Remarks,f.PDIDemandDate,f.status, d.DivisionCode, d.DivisionName,f.InitiationId, f.BudgetType, ini.ProjectShortName, ini.ProjectTitle ,cml.IsApproved, d.DivisionHeadId FROM fund_approval f LEFT JOIN "+mdmdb+".employee e ON e.EmpId=f.InitiatingOfficer LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId=e.DesigId LEFT JOIN tblbudgethead h ON h.BudgetHeadId=f.BudgetHeadId LEFT JOIN tblbudgetitem i ON i.BudgetItemId=f.BudgetItemId LEFT JOIN "+mdmdb+".division_master d ON d.DivisionId=f.DivisionId LEFT JOIN  "+mdmdb+".pfms_initiation ini ON ini.InitiationId = f.InitiationId LEFT JOIN ibas_fund_members_linked cml ON cml.FundApprovalId = f.FundApprovalId AND cml.MemberType = 'DH' WHERE f.FinYear=:finYear AND f.ProjectId=:projectId AND f.EstimateType=:estimateType AND (CASE WHEN '-1' = :divisionId THEN 1 = 1 ELSE f.DivisionId = :divisionId END) AND (CASE WHEN ('A'=:loginType OR :committeeMember IN ('CS', 'CC')) THEN 1=1 ELSE f.DivisionId IN (SELECT DivisionId FROM "+mdmdb+".employee WHERE EmpId=:empId) END) ORDER BY f.FundApprovalId DESC");
			
			System.out.println("finYear****"+finYear);
			System.out.println("divisionId****"+divisionId);
			System.out.println("estimateType****"+estimateType);
			System.out.println("loginType****"+loginType);
			System.out.println("empId****"+empId);
			System.out.println("projectId****"+projectId);
			System.out.println("committeeMember****"+committeeMember);
			
			query.setParameter("finYear",finYear);
			query.setParameter("divisionId",divisionId);
			query.setParameter("estimateType",estimateType);
			query.setParameter("loginType",loginType);
			query.setParameter("empId",empId);
			query.setParameter("projectId",projectId);
			query.setParameter("committeeMember",committeeMember);
			List<Object[]> List =  (List<Object[]>)query.getResultList();
			return List;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundApprovalList() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public long AddFundRequestSubmit(FundApproval fundApproval) throws Exception {
		try {
			manager.persist(fundApproval);
			manager.flush();
			
			return fundApproval.getFundApprovalId();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO AddFundRequestSubmit() "+ e);
			e.printStackTrace();
			return 0L;
		}
	}
	
	@Override
	public long AddFundApprovalTrans(FundApprovalTrans fundApprovalTrans) throws Exception {
		try {
			manager.persist(fundApprovalTrans);
			manager.flush();
			
			return fundApprovalTrans.getFundApprovalTransId();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO AddFundApprovalTrans() "+ e);
			e.printStackTrace();
			return 0L;
		}
	}
	
	@Override
	public long AddFundRequestAttachSubmit(FundApprovalAttach Attach) throws Exception{
		try {
			manager.persist(Attach);
			manager.flush();
			return Attach.getFundApprovalAttachId();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO AddFundRequestAttachSubmit() "+ e);
			e.printStackTrace();
			return 0L;
		}
	}
	
	@Override
	public int updateFundRequestAttach(FundApprovalAttach attach) throws Exception {
	    try {
	        Query query = manager.createNativeQuery("UPDATE fund_approval_attach SET FileName=:fileName, OriginalFileName=:originalFileName WHERE FundApprovalAttachId=:attachId");
	        query.setParameter("fileName", attach.getFileName());
	        query.setParameter("originalFileName", attach.getOriginalFileName());
	        query.setParameter("attachId", attach.getFundApprovalAttachId());
	        return query.executeUpdate();
	    } catch (Exception e) {
	        logger.error(new Date() + "Inside DAO updateFundRequestAttach() " + e);
	        e.printStackTrace();
	        return 0;
	    }
	}

	@Override
	public Object[] findAttachmentByFundAndName(long fundApprovalId, String fileName) throws Exception {
	    try {
	        Query query = manager.createNativeQuery("SELECT FundApprovalAttachId, FundApprovalId, FileName, OriginalFileName FROM fund_approval_attach WHERE FundApprovalId=:fundApprovalId AND FileName=:fileName");
	        query.setParameter("fundApprovalId", fundApprovalId);
	        query.setParameter("fileName", fileName);
	        return (Object[]) query.getSingleResult();
	  
	    } catch (Exception e) {
	        logger.error(new Date() + "Inside DAO findAttachmentByFundAndName() " + e);
	        e.printStackTrace();
	        return null;
	    }
	}

	@Override
	public List<Object[]> getMasterFlowDetails(long fundRequestId) throws Exception {
		try {
			Query query= manager.createNativeQuery("CALL Ibas_Fund_Master_Flow_Details(:fundRequestId)");
			System.out.println("CALL Ibas_Fund_Master_Flow_Details('"+fundRequestId+"');");
			query.setParameter("fundRequestId",fundRequestId);
			List<Object[]> List =  (List<Object[]>)query.getResultList();
			return List;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getMasterFlowDetails() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	public Object[] getFundRequestObj(long fundApprovalId) throws Exception{
		try {
			Query query= manager.createNativeQuery("SELECT f.FundApprovalId,f.EstimateType,f.DivisionId,f.FinYear,f.REFBEYear,f.ProjectId,f.BudgetHeadId,h.BudgetHeadDescription,f.BudgetItemId,i.HeadOfAccounts,f.ItemNomenclature,f.Justification, f.Apr , f.May , f.Jun , f.Jul ,f.Aug, f.Sep , f.Oct , f.Nov , f.December ,f.Jan , f.Feb ,f.Mar,ROUND((f.Apr + f.May + f.Jun + f.Jul + f.Aug + f.Sep + f.Oct + f.Nov + f.December + f.Jan + f.Feb +f.Mar),2) AS EstimatedCost,f.InitiatingOfficer, e.EmpName,ed.Designation,dm.DivisionCode,dm.DivisionName,f.PDIDemandDate,f.status,f.BudgetType,f.InitiationId FROM fund_approval f LEFT JOIN "+mdmdb+".employee e ON e.EmpId=f.InitiatingOfficer LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId=e.DesigId LEFT JOIN tblbudgethead h ON h.BudgetHeadId=f.BudgetHeadId LEFT JOIN "+mdmdb+".division_master dm ON dm.DivisionId=f.DivisionId LEFT JOIN tblbudgetitem i ON i.BudgetItemId=f.BudgetItemId WHERE f.FundApprovalId=:fundApprovalId ORDER BY f.FundApprovalId DESC");
			query.setParameter("fundApprovalId", fundApprovalId);
			return (Object[])query.getSingleResult();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundRequestObj() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	public List<Object[]> getFundRequestAttachList(long fundApprovalId) throws Exception{
		try {
			List<Object[]> getFundRequestAttachList = null;
			Query query= manager.createNativeQuery("SELECT FundApprovalAttachId,FileName,OriginalFileName,FundApprovalId,Path FROM fund_approval_attach  WHERE FundApprovalId=:fundApprovalId");
			query.setParameter("fundApprovalId", fundApprovalId);
			getFundRequestAttachList=(List<Object[]>)query.getResultList();
			
			return getFundRequestAttachList;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundRequestAttachList() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	public Object[] FundRequestAttachData(long fundApprovalAttachId) throws Exception{
	try {
		Object[] FundRequestAttachData = null;
		Query query= manager.createNativeQuery("SELECT FundApprovalAttachId,FundApprovalId,FileName,OriginalFileName  FROM fund_approval_attach  WHERE FundApprovalAttachId=:fundApprovalAttachId");
		query.setParameter("fundApprovalAttachId", fundApprovalAttachId);
		FundRequestAttachData=(Object[])query.getSingleResult();
		return FundRequestAttachData;
		
	}catch (Exception e) {
		logger.error(new Date() +"Inside DAO getFundRequestAttachList() "+ e);
		e.printStackTrace();
		return null;
	}
}
	
	@Override
	public int FundRequestAttachDelete(long fundApprovalAttachId) throws Exception
	{
		
		try {
			Query query=manager.createNativeQuery("DELETE FROM fund_approval_attach WHERE FundApprovalAttachId=:fundApprovalAttachId ");
			query.setParameter("fundApprovalAttachId", fundApprovalAttachId);
			return query.executeUpdate();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO FundRequestAttachDelete() "+ e);
			e.printStackTrace();
			return 0;
		}
	}

	
	@Override
	public FundApproval getFundRequestDetails(long fundRequestId) throws Exception {
		try {
			return manager.find(FundApproval.class,fundRequestId);

		} catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundRequestDetails() "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public long updateFundRequest(FundApproval fundApprovalData) throws Exception {
		try {
			manager.merge(fundApprovalData);
			manager.flush();
			return fundApprovalData.getFundApprovalId();

		} catch (Exception e) {
			logger.error(new Date() +"Inside DAO updateFundRequest() "+ e);
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public List<Object[]> getFundPendingList(String empId,String finYear,String loginType,long formRole) throws Exception {
		try {
			Query query= manager.createNativeQuery("CALL Ibas_FundApprovalListAndApprovedList(:finYear,:empId,:ListType,:loginType)");
			System.out.println("CALL Ibas_FundApprovalListAndApprovedList('"+finYear+"','"+empId+"','F','"+loginType+"');");
			query.setParameter("empId",empId);
			query.setParameter("finYear",finYear);
			query.setParameter("ListType","F");
			query.setParameter("loginType",loginType);
			//query.setParameter("formRole",formRole);
			List<Object[]> List =  (List<Object[]>)query.getResultList();
			return List;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundPendingList() "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Object[]> getFundApprovedList(String empId, String finYear,String loginType) throws Exception {
		try {
			Query query= manager.createNativeQuery("CALL Ibas_FundApprovalListAndApprovedList(:finYear,:empId,:ListType,:loginType)");
			System.out.println("CALL Ibas_FundApprovalListAndApprovedList('"+finYear+"','"+empId+"','A','"+loginType+"');");
			query.setParameter("empId",empId);
			query.setParameter("finYear",finYear);
			query.setParameter("ListType","A");
			query.setParameter("loginType",loginType);
			List<Object[]> List =  (List<Object[]>)query.getResultList();
			return List;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundPendingList() "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Object[]> getParticularFundApprovalDetails(String fundApprovalId,long empId) throws Exception {
		try {
			System.out.println("CALL Ibas_ParticularFundRequestDetails('"+fundApprovalId+"','"+empId+"');");
			Query query= manager.createNativeQuery("CALL Ibas_ParticularFundRequestDetails(:fundApprovalId,:empId)");
			query.setParameter("fundApprovalId",fundApprovalId);
			query.setParameter("empId",empId);
			List<Object[]> List =  (List<Object[]>)query.getResultList();
			return List;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getParticularFundApprovalDetails() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public List<Object[]> getParticularFundApprovalTransDetails(String fundApprovalId) throws Exception {
		try {
			Query query= manager.createNativeQuery("SELECT f.FundApprovalId,e.EmpName,d.Designation,fd.StatusName,f.Remarks,f.ActionDate,f.ActionBy FROM ibas_fund_approval_trans f LEFT JOIN "+mdmdb+".employee e ON e.EmpId = f.ActionBy LEFT JOIN "+mdmdb+".employee_desig d ON d.DesigId= e.DesigId LEFT JOIN ibas_flow_details fd ON fd.FlowDetailsId = f.FlowDetailsId WHERE FundApprovalId=:fundApprovalId");
			query.setParameter("fundApprovalId",fundApprovalId);
			List<Object[]> List =  (List<Object[]>)query.getResultList();
			return List;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getParticularFundApprovalTransDetails() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public long EditFundRequestSubmit(FundApproval modal) throws Exception{
		try {
			FundApproval fundApproval=manager.find(FundApproval.class, modal.getFundApprovalId());
			
			fundApproval.setBudgetType(modal.getBudgetType());
			fundApproval.setInitiationId(modal.getInitiationId());
			fundApproval.setFinYear(modal.getFinYear());
			fundApproval.setEstimateType(modal.getEstimateType());
			fundApproval.setDivisionId(modal.getDivisionId());
			fundApproval.setInitiatingOfficer(modal.getInitiatingOfficer());
			fundApproval.setProjectId(modal.getProjectId());
			fundApproval.setBudgetHeadId(modal.getBudgetHeadId());
			fundApproval.setBudgetItemId(modal.getBudgetItemId());
			fundApproval.setItemNomenclature(modal.getItemNomenclature());
			fundApproval.setJustification(modal.getJustification());
			fundApproval.setRequisitionDate(modal.getRequisitionDate());
			fundApproval.setFundRequestAmount(modal.getFundRequestAmount());
			fundApproval.setApril(modal.getApril());
			fundApproval.setMay(modal.getMay());
			fundApproval.setJune(modal.getJune());
			fundApproval.setJuly(modal.getJuly());
			fundApproval.setAugust(modal.getAugust());
			fundApproval.setSeptember(modal.getSeptember());
			fundApproval.setOctober(modal.getOctober());
			fundApproval.setNovember(modal.getNovember());
			fundApproval.setDecember(modal.getDecember());
			fundApproval.setJanuary(modal.getJanuary());
			fundApproval.setFebruary(modal.getFebruary());
			fundApproval.setMarch(modal.getMarch());
			fundApproval.setModifiedBy(modal.getModifiedBy());
			fundApproval.setModifiedDate(modal.getModifiedDate());
			manager.flush();
			return fundApproval.getFundApprovalId();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO EditFundRequestSubmit() "+ e);
			e.printStackTrace();
			return 0L;
		}
	}
	
	@Override
	public long RevisionFundRequestSubmit(FundApproval modal) throws Exception{
		try {
			FundApproval saved = manager.merge(modal);
	        manager.flush();
	        return saved.getFundApprovalId();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO RevisionFundRequestSubmit() "+ e);
			e.printStackTrace();
			return 0L;
		}
	}

	@Override
	public List<Object[]> getAllCommitteeMemberDetails(LocalDate currentDate) throws Exception {
		try {
			Query query= manager.createNativeQuery("SELECT cm.CommitteeMemberId,cm.MemberType,cm.EmpId,e.EmpName,ed.Designation,cm.FromDate,cm.ToDate FROM ibas_committee_members cm LEFT JOIN "+mdmdb+".employee e ON e.EmpId=cm.EmpId LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId=e.DesigId WHERE cm.IsActive='1' AND (:currentDate BETWEEN cm.FromDate AND cm.ToDate)");
			query.setParameter("currentDate",currentDate);
			List<Object[]> List =  (List<Object[]>)query.getResultList();
			return List;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getParticularFundApprovalDetails() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	


	@Override
	public long insertFundApprovalTransaction(FundApprovalTrans transaction) throws Exception {
		try {
			manager.persist(transaction);
			manager.flush();
			return transaction.getFundApprovalTransId();

		} catch (Exception e) {
			logger.error(new Date() +"Inside DAO insertFundApprovalTransaction() "+ e);
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public long insertLinkedCommitteeMembers(FundLinkedMembers linkedMembers) throws Exception {
		try {
			manager.merge(linkedMembers);
			manager.flush();
			return linkedMembers.getCommitteeMemberLinkedId();

		} catch (Exception e) {
			logger.error(new Date() +"Inside DAO insertLinkedCommitteeMembers() "+ e);
			e.printStackTrace();
			return 0;
		}
	}
	
	private static final String PROJECTBUDGETHEADLIST="SELECT DISTINCT h.BudgetHeadId,h.BudgetHeadDescription,h.BudgetHeadCode FROM tblbudgethead h INNER JOIN tblbudgetitem i ON i.BudgetHeadId=h.BudgetHeadId INNER JOIN tblprojectsanction s ON s.BudgetItemId=i.BudgetItemId AND s.ProjectId=:projectId ORDER BY h.BudgetHeadId";
	@Override
	public List<Object[]> getProjectBudgetHeadList(String projectId) throws Exception {
		logger.info(new Date() +"Inside DaoImpl getProjectBudgetHeadList");
		try
		{
			Query query=manager.createNativeQuery(PROJECTBUDGETHEADLIST);
			query.setParameter("projectId", projectId);
			List<Object[]> List=(List<Object[]>)query.getResultList();
			return List;
		}
		catch(Exception e)
		{
			logger.error(new Date() +"Inside DAO getProjectBudgetHeadList() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	private static final String GENERALBUDGETHEADLIST="SELECT DISTINCT b.BudgetHeadId,b.BudgetHeadDescription,b.BudgetHeadCode FROM tblbudgethead b WHERE b.BudgetType IN('G','B')";
	@Override
	public List<Object[]> getGeneralBudgetHeadList() throws Exception {
		logger.info(new Date() +"Inside DaoImpl getGeneralBudgetHeadList");
		try
		{
			Query query=manager.createNativeQuery(GENERALBUDGETHEADLIST);
			List<Object[]> List=(List<Object[]>)query.getResultList();
			return List;
		}
		catch(Exception e)
		{
			logger.error(new Date() +"Inside DAO getGeneralBudgetHeadList() "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	private static final String SELECTPRJBUDGETHEADITEM="SELECT DISTINCT c.BudgetItemId,c.HeadOfAccounts,c.ReFe,c.MajorHead,c.MinorHead,c.SubHead,c.SubMinorHead FROM tblbudgethead b,tblbudgetitem c WHERE b.BudgetHeadId=c.BudgetHeadId AND b.BudgetHeadId=:budgetHeadId AND c.BudgetItemId IN (SELECT a.BudgetItemId FROM tblprojectsanction a WHERE a.ProjectId=:ProjectId) AND c.IsActive='1' ORDER BY c.BudgetItemId";
	@Override
	public List<Object[]> getPrjBudgetHeadItem(long projectId, long budgetHeadId) throws Exception {
		try {
			Query query= manager.createNativeQuery(SELECTPRJBUDGETHEADITEM);
			query.setParameter("ProjectId", projectId);
			query.setParameter("budgetHeadId", budgetHeadId);
			List<Object[]> ProjectDetailslist =  (List<Object[]>)query.getResultList();
			return ProjectDetailslist;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getBudgetHeadItem "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	private static final String SELECTGENBUDGETHEADITEM="SELECT DISTINCT c.BudgetItemId,c.HeadOfAccounts,c.ReFe,c.MajorHead,c.MinorHead,c.SubHead,c.SubMinorHead FROM tblbudgethead b,tblbudgetitem c  WHERE b.BudgetHeadId=c.BudgetHeadId AND b.BudgetHeadId=:budgetHeadId AND c.IsActive='1' ORDER BY c.BudgetItemId";
	@Override
	public List<Object[]> getGenBudgetHeadItem(long budgetHeadId) throws Exception {
		
       try {
			Query query= manager.createNativeQuery(SELECTGENBUDGETHEADITEM);
			query.setParameter("budgetHeadId", budgetHeadId);
			List<Object[]> GeneralDetailslist =  (List<Object[]>)query.getResultList();
			return GeneralDetailslist;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getBudgetHeadItem "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Object[]> getCommitteeMemberCurrentStatus(String empId) throws Exception {
		 try {
				Query query= manager.createNativeQuery("SELECT cm.CommitteeMemberId,cm.MemberType,cm.EmpId,cm.FromDate,cm.ToDate FROM ibas_committee_members cm WHERE cm.EmpId=:empId AND cm.IsActive='1' UNION SELECT '0','DH',dm.DivisionHeadId,NULL AS FromDate,NULL AS ToDate FROM "+mdmdb+".division_master dm WHERE dm.DivisionHeadId=:empId AND dm.IsActive='1'");
				query.setParameter("empId", empId);
				List<Object[]> list =  (List<Object[]>)query.getResultList();
				return list;
				
			}catch (Exception e) {
				logger.error(new Date() +"Inside DAO getCommitteeMemberCurrentStatus "+ e);
				e.printStackTrace();
				return null;
			}
	}


	@Override
	public int updateParticularLinkedCommitteeDetails(long empId, long fundApprovalId,String isApproved) throws Exception {
		try {
			Query query= manager.createNativeQuery("UPDATE ibas_fund_members_linked SET IsApproved=:isApproved WHERE FundApprovalId=:fundApprovalId AND EmpId=:empId AND IsActive='1'");
			
			System.out.println("empId *****"+ empId);
			System.out.println("isApproved *****"+ isApproved);
			System.out.println("fundApprovalId *****"+ fundApprovalId);
			
			query.setParameter("empId", empId);
			query.setParameter("isApproved", isApproved);
			query.setParameter("fundApprovalId", fundApprovalId);
			return query.executeUpdate();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO updateParticularLinkedCommitteeDetails "+ e);
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public int getFundApprovalIdCountFromCommitteeLinked(long fundApprovalId) throws Exception {
		try {
			Query query= manager.createNativeQuery("select count(FundApprovalId) from ibas_fund_members_linked where FundApprovalId=:fundApprovalId and IsActive='1'");
			query.setParameter("fundApprovalId", fundApprovalId);
			return ((Number) query.getSingleResult()).intValue();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundApprovalIdCountFromCommitteeLinked "+ e);
			e.printStackTrace();
			return 0;
		}
	}
	
	private static final String GETFBESUBCOUNTONSINO="SELECT MaxCount, finYear FROM (SELECT IFNULL(MAX(CAST(SUBSTRING_INDEX(IFNULL(s.ItemSerialNo, 'NA/0'), '/', -1) AS UNSIGNED)), 0) AS MaxCount,:fbeReYear AS finYear FROM fbe_sub s INNER JOIN fbe_main a ON a.FbeMainId = s.FbeMainId AND a.Status = 'A' AND (CASE WHEN :estimateType = 'R' THEN a.REYear WHEN :estimateType = 'F' THEN a.FBEYear END) = :fbeReYear WHERE s.Status = 'A' UNION ALL SELECT IFNULL(MAX(CAST(SUBSTRING_INDEX(IFNULL(fa.SerialNo, 'NA/0'), '/', -1) AS UNSIGNED)), 0) AS MaxCount,:fbeReYear AS finYear FROM fund_approval fa WHERE fa.REFBEYear = :fbeReYear AND fa.EstimateType = :estimateType) AS CombinedTable ORDER BY MaxCount DESC LIMIT 1";
	@Override
	public List<Object[]> getMaxSerialNoCount(String fbeReYear,String estimateType) throws Exception {
		
       try {
			Query query= manager.createNativeQuery(GETFBESUBCOUNTONSINO);
			query.setParameter("fbeReYear", fbeReYear);
			query.setParameter("estimateType", estimateType);
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result; 
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getMaxSerialNoCount "+ e);
			e.printStackTrace();
			return null;
		}
	}

	private static final String GETFUNDREQUESTCARRYFORWARD="CALL Ibas_Fund_Approval_CarryForward(:divisionId,:budgetHeadId,:budgetItemId,:estimatedType,:finYear,:previousFinYear,:asOnDate,:labCode,:action)";
	@Override
	public List<Object[]> getFundRequestCarryForwardDetails(FundApprovalBackButtonDto fundApprovalDto,String labCode,String action) throws Exception {
		 try {
			    System.out.println("CALL Ibas_Fund_Approval_CarryForward('"+fundApprovalDto.getDivisionId()+"','"+fundApprovalDto.getBudgetHeadId()+"','"+fundApprovalDto.getBudgetItemId()+"','"+fundApprovalDto.getEstimatedTypeBackBtn()+"','"+fundApprovalDto.getFromYearBackBtn() +"-" +fundApprovalDto.getToYearBackBtn()+"','"+(fundApprovalDto.getFromYearBackBtn()!=null ? Integer.parseInt(fundApprovalDto.getFromYearBackBtn())-1 : 0)+ "-" +(fundApprovalDto.getToYearBackBtn()!=null ? Integer.parseInt(fundApprovalDto.getToYearBackBtn())-1 : 0)+"','"+LocalDate.now()+"','"+labCode+"','"+action+"');");
				Query query= manager.createNativeQuery(GETFUNDREQUESTCARRYFORWARD);
				query.setParameter("divisionId", fundApprovalDto.getDivisionId());
				query.setParameter("estimatedType", fundApprovalDto.getEstimatedTypeBackBtn());
				query.setParameter("asOnDate", LocalDate.now());
				query.setParameter("labCode",labCode);
				query.setParameter("action",action);
				query.setParameter("budgetHeadId",fundApprovalDto.getBudgetHeadId());
				query.setParameter("budgetItemId",fundApprovalDto.getBudgetItemId());
				query.setParameter("finYear",fundApprovalDto.getFromYearBackBtn() +"-" +fundApprovalDto.getToYearBackBtn());
				query.setParameter("previousFinYear", (fundApprovalDto.getFromYearBackBtn()!=null ? Integer.parseInt(fundApprovalDto.getFromYearBackBtn())-1 : 0)+ "-" +(fundApprovalDto.getToYearBackBtn()!=null ? Integer.parseInt(fundApprovalDto.getToYearBackBtn())-1 : 0));  // passing previous financialYear
				List<Object[]> result = (List<Object[]>)query.getResultList();
				return result; 
				
			}catch (Exception e) {
				logger.error(new Date() +"Inside DAO getFundRequestCarryForwardDetails "+ e);
				e.printStackTrace();
				return null;
			}
	}
	
	@Override
	public List<Object[]> estimateTypeParticularDivList(long divisionId, String estimateType,String finYear, String loginType,String empId,String budget, String proposedProject, String budgetHeadId, String budgetItemId,
			String fromCost, String toCost,String status,String memberType,int RupeeValue) throws Exception{
		try {

			Query query= manager.createNativeQuery("SELECT f.FundApprovalId, dm.DivisionId, dm.DivisionName, f.EstimateType, f.DivisionId, f.FinYear, f.REFBEYear, f.ProjectId, f.BudgetHeadId, h.BudgetHeadDescription, f.BudgetItemId, i.HeadOfAccounts, i.MajorHead, i.MinorHead, i.SubHead, i.SubMinorHead,f.BookingId, f.CommitmentPayIds, f.ItemNomenclature, f.Justification, ROUND(IFNULL((f.Apr+f.May+f.Jun+f.Jul+f.Aug+f.Sep+f.Oct+f.Nov+f.December+f.Jan+f.Feb+f.Mar)/:rupeeValue,0),2) AS EstimatedCost, f.InitiatingOfficer, e.EmpName, ed.Designation, f.Remarks, f.Status, f.PDIDemandDate, dm.DivisionCode,ifa_latest_approver.Remarks AS ChairmanRemarks, attach.Attachments,pf.ProjectShortName FROM fund_approval f LEFT JOIN  "+mdmdb+".employee e ON e.EmpId=f.InitiatingOfficer LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId=e.DesigId LEFT JOIN tblbudgethead h ON h.BudgetHeadId=f.BudgetHeadId LEFT JOIN tblbudgetitem i ON i.BudgetItemId=f.BudgetItemId LEFT JOIN "+mdmdb+".division_master dm ON dm.DivisionId=:divisionId LEFT JOIN (SELECT att.FundApprovalId,GROUP_CONCAT(CONCAT(att.FileName, '::', att.OriginalFileName, '::', att.Path, '::',att.FundApprovalAttachId) SEPARATOR '||') AS Attachments FROM fund_approval_attach att GROUP BY att.FundApprovalId) attach ON attach.FundApprovalId = f.FundApprovalId LEFT JOIN (SELECT t.FundApprovalId, t.Remarks FROM ibas_fund_approval_trans t INNER JOIN ibas_flow_details fd ON  fd.FlowDetailsId = t.FlowDetailsId AND fd.StatusCode = 'CC' AND fd.StatusType = 'A') ifa_latest_approver ON ifa_latest_approver.FundApprovalId = f.FundApprovalId LEFT JOIN "+mdmdb+".pfms_initiation pf ON pf.InitiationId = :proposedProject  WHERE f.FinYear=:finYear AND f.ProjectId=0 AND (('-1'=:budget) OR ((CASE WHEN 'N'=:budget THEN f.InitiationId = :proposedProject ELSE f.InitiationId = 0 END) AND (CASE WHEN 0=:budgetHeadId THEN 1=1 ELSE f.BudgetHeadId=:budgetHeadId END) AND (CASE WHEN 0=:budgetItemId THEN 1=1 ELSE f.BudgetItemId=:budgetItemId END))) AND f.EstimateType=:estimateType AND (CASE WHEN '-1'=:divisionId THEN 1=1 ELSE f.DivisionId=:divisionId END) AND (CASE WHEN 'A'=:loginType THEN 1=1 ELSE (CASE WHEN :memberType='CC' OR :memberType='CS' THEN 1=1 ELSE f.DivisionId IN (SELECT DivisionId FROM "+mdmdb+".employee WHERE EmpId=:empId) END) END) AND ( CASE WHEN :statuss = 'NA' THEN 1 WHEN :statuss = 'A'  THEN CASE WHEN f.Status = 'A' THEN 1 ELSE 0 END ELSE CASE WHEN f.Status <> 'A' THEN 1 ELSE 0 END END) = 1 HAVING EstimatedCost BETWEEN :fromCost AND :toCost ORDER BY h.BudgetHeadDescription DESC");

			System.out.println("divisionId****"+divisionId);
			System.out.println("estimateType****"+estimateType);
			System.out.println("finYear****"+finYear);
			System.out.println("loginType****"+loginType);
			System.out.println("empId****"+empId);
			System.out.println("budgetHeadId****"+budgetHeadId);
			System.out.println("budgetItemId****"+budgetItemId);
			System.out.println("fromCost****"+fromCost);
			System.out.println("toCost****"+toCost);
			System.out.println("status****"+status);
			System.out.println("memberType****"+memberType);
			System.out.println("RupeeValue****"+RupeeValue);
			
			query.setParameter("divisionId", divisionId);
			query.setParameter("estimateType", estimateType);
			query.setParameter("finYear",finYear);
			query.setParameter("loginType",loginType);
			query.setParameter("empId",empId);
			query.setParameter("budget",budget);
			query.setParameter("proposedProject",proposedProject);
			query.setParameter("budgetHeadId",budgetHeadId);
			query.setParameter("budgetItemId",budgetItemId);
			query.setParameter("fromCost",fromCost);
			query.setParameter("toCost",toCost);
			query.setParameter("statuss",status);
			query.setParameter("memberType",memberType);
			query.setParameter("rupeeValue",RupeeValue);
			return query.getResultList();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO estimateTypeParticularDivList "+ e);
			e.printStackTrace();
			return null;
		}
	}

	
	@Override
	public long insertCarryForwardItemDetails(FundApproval fundRequest) throws Exception {
		try {
			manager.persist(fundRequest);
			manager.flush();
			
			return fundRequest.getFundApprovalId();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO insertCarryForwardItemDetails() "+ e);
			e.printStackTrace();
			return 0L;
		}
	}
	
	@Override
	public List<Object[]> getCommitteeMemberType (long empId) throws Exception{
		try {
			Query query= manager.createNativeQuery("SELECT MemberType,EmpId FROM ibas_committee_members WHERE EmpId=:empId");
			query.setParameter("empId", empId);
			return (List<Object[]>) query.getResultList();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getCommitteeMemberType "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public List<Object[]> getCommitteeMembersLinked (long empId) throws Exception{
		try {
			Query query= manager.createNativeQuery("SELECT MemberType,EmpId FROM ibas_fund_members_linked WHERE EmpId=:empId");
			query.setParameter("empId", empId);
			return (List<Object[]>) query.getResultList();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getCommitteeMembersLinked "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Object[]> committeeMemberFundApprovalCount(String committeeMember,String empId) throws Exception{
		try {
			Query query= manager.createNativeQuery("SELECT  l.memberType, f. EstimateType, f.FinYear,dm.DivisionCode,ROUND(IFNULL((f.Apr+f.May+f.Jun+f.Jul+f.Aug+f.Sep+f.Oct+f.Nov+f.December+f.Jan+f.Feb+f.Mar),0),2) AS EstimatedCost, f.FundApprovalId \n"
					+ "FROM ibas_fund_members_linked l\n"
					+ "LEFT JOIN fund_approval f  ON f.fundApprovalId= l.fundApprovalId LEFT JOIN "+mdmdb+".division_master dm ON dm.DivisionId=f.DivisionId \n"
					+ "WHERE (l.memberType = :member OR (l.memberType = 'SE' AND 'CM' = :member)  ) AND l.empID = :EmpId AND l.isApproved = 'N' AND (f.status='F' OR f.status='B')\n"
					+ "  AND ((l.memberType = 'DH')OR ( l.memberType IN ('CM','SE') AND EXISTS ( SELECT 1 FROM ibas_fund_members_linked X WHERE x.fundApprovalId = l.fundApprovalId AND x.memberType = 'DH' AND x.isApproved = 'Y' ) )\n"
					+ "  OR ( l.memberType = 'CS' AND EXISTS (SELECT 1 FROM ibas_fund_members_linked X WHERE x.fundApprovalId = l.fundApprovalId AND x.memberType = 'DH' AND x.isApproved = 'Y')\n"
					+ "  AND NOT EXISTS (SELECT 1 FROM ibas_fund_members_linked Y WHERE y.fundApprovalId = l.fundApprovalId AND y.memberType IN ('CM','SE') AND y.isApproved = 'N' ) )\n"
					+ "  OR ( l.memberType = 'CC' AND EXISTS (\n"
					+ "  SELECT 1 FROM ibas_fund_members_linked z WHERE z.fundApprovalId = l.fundApprovalId AND z.memberType = 'CS' AND z.isApproved = 'Y'))) AND l.IsSkipped = 'N' ORDER BY l.fundApprovalId;\n");
			query.setParameter("member", committeeMember);
			query.setParameter("EmpId", empId);
			return (List<Object[]>) query.getResultList();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO committeeMemberFundApprovalCount "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public List<Object[]> getDemandDetails(String demandId) throws Exception {
	 try {
			Query query= manager.createNativeQuery("SELECT b.BookingId,b.DemandNo,b.ProjectCode,b.ProjectId,b.BudgetHeadId,b.BudgetItemId,b.DivisionCode,d.DivisionId,b.OfficerCode,e.EmpId FROM tblbooking b LEFT JOIN "+mdmdb+".division_master d ON d.DivisionCode=b.DivisionCode LEFT JOIN "+mdmdb+".employee e ON e.EmpNo=b.OfficerCode WHERE b.BookingId=:demandId");
			query.setParameter("demandId", demandId);
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result; 
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getDemandDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Object[]> getCommitmmentDetails(String commitmentId) throws Exception {
		try {
			Query query= manager.createNativeQuery("SELECT c.CommitmentId,c.SoNo,c.ProjectCode,c.ProjectId,c.BudgetHeadId,c.BudgetItemId,c.DivisionCode,d.DivisionId,c.OfficerCode,e.EmpId FROM tblcommitment c LEFT JOIN "+mdmdb+".division_master d ON d.DivisionCode=c.DivisionCode LEFT JOIN "+mdmdb+".employee e ON e.EmpNo=c.OfficerCode WHERE c.CommitmentId=:commitmentId");
			query.setParameter("commitmentId", commitmentId);
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result; 
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getCommitmmentDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Object[]> getProposedProjectDetails() throws Exception {
		try {
			Query query= manager.createNativeQuery("SELECT i.InitiationId,i.EmpId,i.DivisionId,i.ProjectShortName,i.ProjectTitle,i.FeCost,i.ReCost,i.ProjectCost FROM "+mdmdb+".pfms_initiation i WHERE i.IsActive='1'");
			
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getProposedProjectDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public List<Object[]> getAttachmentDetails(String fundApprovalId) throws Exception {
		try {
			Query query= manager.createNativeQuery("SELECT f.FundApprovalId,(CASE WHEN f.EstimateType='R' THEN 'RE' WHEN f.EstimateType='F' THEN 'FBE' END) AS EstimateType,f.DivisionId,f.FinYear,f.REFBEYear,f.ProjectId,f.BudgetHeadId,h.BudgetHeadDescription,f.BudgetItemId,i.HeadOfAccounts,f.ItemNomenclature,f.Justification,ROUND((f.Apr + f.May + f.Jun + f.Jul + f.Aug + f.Sep + f.Oct + f.Nov + f.December + f.Jan + f.Feb +f.Mar),2) AS EstimatedCost,f.InitiatingOfficer, e.EmpName,ed.Designation,dm.DivisionCode,dm.DivisionName,f.PDIDemandDate,(CASE WHEN f.status='A' THEN 'Approved' WHEN f.status='N' THEN 'Forward Pending' WHEN f.status='F' THEN 'Forwarded' WHEN f.status='R' THEN 'Returned' WHEN f.status='E' THEN 'Revoked' ELSE f.status END) AS StatusType,CASE WHEN f.BudgetType='B' THEN 'General' WHEN f.BudgetType='N' THEN 'Proposed Project' ELSE f.BudgetType END AS BudgetType,f.InitiationId,f.SerialNo FROM fund_approval f LEFT JOIN "+mdmdb+".employee e ON e.EmpId=f.InitiatingOfficer LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId=e.DesigId LEFT JOIN tblbudgethead h ON h.BudgetHeadId=f.BudgetHeadId LEFT JOIN "+mdmdb+".division_master dm ON dm.DivisionId=f.DivisionId LEFT JOIN tblbudgetitem i ON i.BudgetItemId=f.BudgetItemId WHERE f.FundApprovalId=:fundApprovalId ORDER BY f.FundApprovalId DESC");
			query.setParameter("fundApprovalId", fundApprovalId);
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getAttachmentDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public FundApproval getRevisionListDetails(String fundApprovalId) throws Exception{
		try {
			FundApproval fundApprovalRevise=manager.find(FundApproval.class, fundApprovalId);
			return fundApprovalRevise;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getRevisionListDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	
	
	@Override
	public Long getRevisionCount(String fundApprovalId) throws Exception {
	    try {
	        Query query = manager.createNativeQuery(
	            "SELECT MAX(r.revisionCount) FROM fund_approved_revision r WHERE r.fundApprovalId = :fundApprovalId"
	        );
	        query.setParameter("fundApprovalId", fundApprovalId);
	        Object result = query.getSingleResult();
	        return (result != null) ? ((Number) result).longValue() : null;
	    } catch (Exception e) {
	        logger.error(new Date() + " Inside DAO getRevisionCount " + e);
	        e.printStackTrace();
	        return null;
	    }
	}

	
	@Override
	public long RevisionDetailsSubmit(FundApprovedRevision revision) throws Exception{
		try {
			manager.persist(revision);
			manager.flush();
			
			return revision.getFundApprovedRevisionId();
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getRevisionCount "+ e);
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public List<Object[]> getLinkedMemberDetails(long fundApprovalId) throws Exception {
		try {
			Query query= manager.createNativeQuery("SELECT cml.MemberLinkedId,cml.FundApprovalId,cml.EmpId,cml.MemberType,cml.IsApproved FROM ibas_fund_members_linked cml WHERE cml.FundApprovalId = :fundApprovalId AND cml.IsActive = '1'");
			query.setParameter("fundApprovalId", fundApprovalId);
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getLinkedMemberDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public FundLinkedMembers getCommitteeMemberLinkedDetails(String committeMemberLinkedId) throws Exception {
		try {
			return manager.find(FundLinkedMembers.class,committeMemberLinkedId);

		} catch (Exception e) {
			logger.error(new Date() +"Inside DAO getCommitteeMemberLinkedDetails() "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public long updateLinkedCommitteeMembers(FundLinkedMembers linkedMembers) throws Exception {
		try {
			manager.merge(linkedMembers);
			manager.flush();
			return linkedMembers.getCommitteeMemberLinkedId();

		} catch (Exception e) {
			logger.error(new Date() +"Inside DAO updateLinkedCommitteeMembers() "+ e);
			e.printStackTrace();
			return 0;
		}
		
	}

	@Override
	public void deleteLinkedCommitteeMembers(String committeeMemberLinkedId) throws Exception {
		
		try {
			FundLinkedMembers linkedMembersToDelete = manager.find(FundLinkedMembers.class, Long.parseLong(committeeMemberLinkedId));

		    if (linkedMembersToDelete != null) {
		        manager.remove(linkedMembersToDelete);
		        manager.flush();
		    } 

		} catch (Exception e) {
		    logger.error(new Date() + " Inside DAO deleteLinkedCommitteeMembers() " + e);
		    e.printStackTrace();
		}
		
	}

	@Override
	public long deleteFundRequestDetails(long fundApprovalId) throws Exception {
		try {
			FundApproval fundApprovalModal = manager.find(FundApproval.class, fundApprovalId);

		    if (fundApprovalModal != null) {
		        manager.remove(fundApprovalModal);
		        manager.flush();
		    } 
		    return 1;
		} catch (Exception e) {
		    logger.error(new Date() + " Inside DAO deleteFundRequestDetails() " + e);
		    e.printStackTrace();
		    return 0;
		}
	}

	@Override
	public List<Object[]> getTransactionStatusDetails(String action, String actionType) throws Exception {
		try {
			Query query= manager.createNativeQuery("SELECT FlowDetailsId, StatusCode, StatusName, StatusType FROM ibas_flow_details WHERE StatusCode = :action AND StatusType = :actionType");
			query.setParameter("action", action);   // INI, FWD, R-FWD, RVK, CM, SE, CS, CC, DH
			query.setParameter("actionType", actionType);  // R, A  -> R - Returned, A - Approved
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getTransactionStatusDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public FundLinkedMembers getLinkedMemberDetailsByEmpId(long empId, long fundApprovalId) {
		 try {
		        String jpql = "SELECT f FROM ibas_fund_members_linked f WHERE f.fundApprovalId = :fundApprovalId AND f.empId = :empId";
		        return manager.createQuery(jpql, FundLinkedMembers.class)
		                      .setParameter("empId", empId)
		                      .setParameter("fundApprovalId", fundApprovalId)
		                      .getSingleResult();
		        
		    } catch (Exception e) {
		        logger.error(new Date() + " Inside DAO getLinkedMemberDetailsByEmpId() " + e);
		        e.printStackTrace();
		        return null;
		    }
	}
	
	@Override
	public long fundApprovalQuerySubmit(FundApprovalQueries FundApprovalQueries) {
	try {
		manager.persist(FundApprovalQueries);
		manager.flush();
		
		return FundApprovalQueries.getQueryId();
		
	} catch (Exception e) {
		logger.error(new Date() +"Inside DAO fundApprovalQuerySubmit "+ e);
		e.printStackTrace();
		return 0L;
	}	
	}
	
	
	@Override
	public List<Object[]> getParticularFundQueryHeader(String fundApprovalId) throws Exception{
		try {
			Query query= manager.createNativeQuery("SELECT CASE WHEN f.BudgetType='B' THEN 'General' WHEN f.BudgetType='N' THEN 'Proposed Project' ELSE NULL END AS BudgetType,pi.ProjectShortName, bh.BudgetHeadDescription,\n"
					+ "e.EmpName AS Initiator_name,ed.Designation, f.ItemNomenclature, \n"
					+ "(IFNULL(f.Apr,0) + IFNULL(f.May,0) + IFNULL(f.Jun,0) + IFNULL(f.Jul,0) + IFNULL(f.Aug,0) + IFNULL(f.Sep,0) + IFNULL(f.OCT,0) + IFNULL(f.Nov,0) + IFNULL(f.December,0) + \n"
					+ "IFNULL(f.Jan,0) + IFNULL(f.Feb,0) + IFNULL(f.Mar,0)) AS ItemCost,dm.DivisionCode FROM fund_approval f\n"
					+ "LEFT JOIN tblbudgethead bh ON bh.BudgetHeadId = f.BudgetHeadId \n"
					+ "LEFT JOIN tblbudgetitem bi ON bi.BudgetItemId=f.BudgetItemId\n"
					+ "LEFT JOIN "+mdmdb+".employee e ON e.EmpId = f.InitiatingOfficer \n"
					+ "LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId = e.DesigId\n"
					+ "LEFT JOIN "+mdmdb+".pfms_initiation PI ON pi.InitiationId = f.InitiationId\n"
					+ "LEFT JOIN "+mdmdb+".division_master dm ON dm.DivisionId= f.DivisionId\n"
					+ " WHERE f.FundApprovalId=:fundApprovalId ");

			query.setParameter("fundApprovalId", fundApprovalId);  
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getParticularFundQueryHeader "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public List<Object[]> getFundApprovalQueryDetails(String fundApprovalId) throws Exception{
		try {
			Query query= manager.createNativeQuery("SELECT r.FundApprovalId, e.EmpId,e.EmpName, ed.Designation, dm.DivisionCode,r.Query , r.ActionDate FROM fund_approval_queries r LEFT JOIN "+mdmdb+".employee e ON e.EmpId = r.EmpId LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId = e.DesigId LEFT JOIN "+mdmdb+".division_master dm ON dm.DivisionId=e.DivisionId WHERE r.FundApprovalId=:fundApprovalId ORDER BY r.ActionDate ASC");

			query.setParameter("fundApprovalId", fundApprovalId);  
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundApprovalQueryDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	@Override
	public List<Object[]> getFundApprovalRevisionDetails(String fundApprovalId) throws Exception{
		try {
			Query query= manager.createNativeQuery("SELECT f.FundApprovedRevisionId, f.FundApprovalId,f.RevisionCount,CASE WHEN f.BudgetType='B' THEN 'General' WHEN f.BudgetType='N' THEN 'Proposed Project' ELSE NULL END AS BudgetType,bh.BudgetHeadDescription, e.EmpName,ed.Designation, f.ItemNomenclature,\n"
					+ "					(IFNULL(f.Apr,0) + IFNULL(f.May,0) + IFNULL(f.Jun,0) + IFNULL(f.Jul,0) + IFNULL(f.Aug,0) + IFNULL(f.Sep,0) + IFNULL(f.OCT,0) + IFNULL(f.Nov,0) + IFNULL(f.December,0) + \n"
					+ "					IFNULL(f.Jan,0) + IFNULL(f.Feb,0) + IFNULL(f.Mar,0)) AS EstimatedCost FROM fund_approved_revision f\n"
					+ "					LEFT JOIN tblbudgethead bh ON bh.BudgetHeadId = f.BudgetHeadId \n"
					+ "					LEFT JOIN "+mdmdb+".employee e ON e.EmpId = f.InitiatingOfficer \n"
					+ "					LEFT JOIN "+mdmdb+".employee_desig ed ON ed.DesigId = e.DesigId\n"
					+ "					WHERE f.FundApprovalId=:fundApprovalId");

			query.setParameter("fundApprovalId", fundApprovalId);  
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundApprovalQueryDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}
	
	

	@Override
	public void deleteFundRequestAttachmentDetails(long fundApprovalId) {
		
		String jpql = "SELECT att FROM fund_approval_attach att WHERE att.FundApprovalId = :fundApprovalId";
		List<FundApprovalAttach> attachList = manager.createQuery(jpql, FundApprovalAttach.class)
                .setParameter("fundApprovalId", fundApprovalId)
                .getResultList();
		
		if(attachList != null)
		{
			attachList.forEach(row -> {
				FundApprovalAttach attachModal = manager.find(FundApprovalAttach.class, row.getFundApprovalAttachId());

			    if (attachModal != null) {
			        manager.remove(attachModal);
			        manager.flush();
			    } 
			});
		}
	}

	@Override
	public void deleteFundRequestQueriesDetails(long fundApprovalId) {
		String jpql = "SELECT aq FROM fund_approval_queries aq WHERE aq.fundApprovalId = :fundApprovalId";
		List<FundApprovalQueries> queriesList = manager.createQuery(jpql, FundApprovalQueries.class)
                .setParameter("fundApprovalId", fundApprovalId)
                .getResultList();
		
		if(queriesList != null)
		{
			queriesList.forEach(row -> {
				FundApprovalQueries queryModal = manager.find(FundApprovalQueries.class, row.getQueryId());

			    if (queryModal != null) {
			        manager.remove(queryModal);
			        manager.flush();
			    } 
			});
		}
		
	}

	@Override
	public void deleteFundRequestRevisionDetails(long fundApprovalId) {
		
		String jpql = "SELECT fr FROM fund_approved_revision fr WHERE fr.fundApprovalId = :fundApprovalId";
		List<FundApprovedRevision> revisionList = manager.createQuery(jpql, FundApprovedRevision.class)
                .setParameter("fundApprovalId", fundApprovalId)
                .getResultList();
		
		if(revisionList != null)
		{
			revisionList.forEach(row -> {
				FundApprovedRevision revisionModal = manager.find(FundApprovedRevision.class, row.getFundApprovedRevisionId());

			    if (revisionModal != null) {
			        manager.remove(revisionModal);
			        manager.flush();
			    } 
			});
		}
	}

	@Override
	public void deleteFundRequestTransDetails(long fundApprovalId) {
		
		String jpql = "SELECT ft FROM ibas_fund_approval_trans ft WHERE ft.fundApprovalId = :fundApprovalId";
		List<FundApprovalTrans> transList = manager.createQuery(jpql, FundApprovalTrans.class)
                .setParameter("fundApprovalId", fundApprovalId)
                .getResultList();
		
		if(transList != null)
		{
			transList.forEach(row -> {
				FundApprovalTrans transModal = manager.find(FundApprovalTrans.class, row.getFundApprovalTransId());

			    if (transModal != null) {
			        manager.remove(transModal);
			        manager.flush();
			    } 
			});
		}
		
	}

	@Override
	public void deleteFundRequestLinkedMembersDetails(long fundApprovalId) {
		
		String jpql = "SELECT fl FROM ibas_fund_members_linked fl WHERE fl.fundApprovalId = :fundApprovalId";
		List<FundLinkedMembers> linkedList = manager.createQuery(jpql, FundLinkedMembers.class)
                .setParameter("fundApprovalId", fundApprovalId)
                .getResultList();
		
		if(linkedList != null)
		{
			linkedList.forEach(row -> {
				FundLinkedMembers linkedModal = manager.find(FundLinkedMembers.class, row.getCommitteeMemberLinkedId());

			    if (linkedModal != null) {
			        manager.remove(linkedModal);
			        manager.flush();
			    } 
			});
		}
	}

	
	@Override
	public List<Object[]> getPreviousYearFundDetailsList(String previousFinYear, String loginType, String memberType) throws Exception {
		try {
			Query query= manager.createNativeQuery("SELECT f.FundApprovalId,f.EstimateType,f.DivisionId,f.FinYear,f.REFBEYear,f.ProjectId,f.BudgetHeadId,h.BudgetHeadDescription,f.BudgetItemId,i.HeadOfAccounts,i.MajorHead,i.MinorHead,i.SubHead,i.SubMinorHead,f.BookingId,f.CommitmentPayIds,f.ItemNomenclature,f.Justification,ROUND((f.Apr + f.May + f.Jun + f.Jul + f.Aug + f.Sep + f.Oct + f.Nov + f.December + f.Jan + f.Feb +f.Mar),2) AS EstimatedCost,f.InitiatingOfficer,e.EmpName,ed.Designation,f.Remarks,f.PDIDemandDate,f.status, d.DivisionCode, d.DivisionName,f.InitiationId,f.BudgetType, ini.ProjectShortName, ini.ProjectTitle, d.DivisionHeadId FROM fund_approval f LEFT JOIN pms_dms_dev.employee e ON e.EmpId=f.InitiatingOfficer LEFT JOIN pms_dms_dev.employee_desig ed ON ed.DesigId=e.DesigId LEFT JOIN tblbudgethead h ON h.BudgetHeadId=f.BudgetHeadId LEFT JOIN tblbudgetitem i ON i.BudgetItemId=f.BudgetItemId LEFT JOIN pms_dms_dev.division_master d ON d.DivisionId=f.DivisionId LEFT JOIN  pms_dms_dev.pfms_initiation ini ON ini.InitiationId = f.InitiationId WHERE f.FinYear=:previousFinYear AND f.EstimateType='F' AND ('A'=:loginType OR :memberType IN ('CS', 'CC')) ORDER BY f.FundApprovalId DESC");

			query.setParameter("previousFinYear", previousFinYear);  
			query.setParameter("loginType", loginType);  
			query.setParameter("memberType", memberType);  
			List<Object[]> result = (List<Object[]>)query.getResultList();
			return result;
			
		}catch (Exception e) {
			logger.error(new Date() +"Inside DAO getFundApprovalQueryDetails "+ e);
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public void transferFundApprovalDetails(String fundApprovalId, String finYear, String estimateType, String userName) {
		
		FundApproval fundModal = manager.find(FundApproval.class, Long.parseLong(fundApprovalId));
		FundApproval newFundModal = new FundApproval();
		BeanUtils.copyProperties(fundModal, newFundModal, "createdBy", "createdDate", "modifiedBy", "modifiedDate");
		newFundModal.setFundApprovalId(0);
		newFundModal.setFinYear(finYear);
		newFundModal.setEstimateType(estimateType);
		newFundModal.setEstimateAction("L");
		newFundModal.setReFbeYear(finYear);
		newFundModal.setCreatedBy(userName);
		newFundModal.setCreatedDate(LocalDateTime.now());
		
		manager.persist(newFundModal);;
	}

}