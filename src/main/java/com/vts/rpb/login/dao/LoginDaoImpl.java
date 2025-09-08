package com.vts.rpb.login.dao;

import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.transaction.Transactional;

@Transactional
@Repository
public class LoginDaoImpl implements LoginDao
{
	private static final Logger logger=LogManager.getLogger(LoginDaoImpl.class);
	
	@PersistenceContext
	EntityManager manager;
	
	@Value("${MdmDb}")
	private String mdmdb;

	@Override
	public List<Object[]> getMainModuleList(String loginType) throws Exception {
		logger.info(new Date() +"Inside DAOImpl getMainModuleList()");
		try {
			Query query=manager.createNativeQuery("SELECT DISTINCT(a.FormModuleId) , a.FormModuleName  ,a.ModuleIcon, a.ModuleUrl,a.IsActive ,a.SerialNo FROM form_module a INNER JOIN form_detail b ON a.FormModuleId=b.FormModuleId INNER JOIN form_role_access c ON b.FormDetailId=c.FormDetailId AND c.LoginType=:loginType AND c.IsActive=1 WHERE a.IsActive='1' ORDER BY a.SerialNo");
			query.setParameter("loginType", loginType);
			List<Object[]> list=(List<Object[]>)query.getResultList();
			
			return list;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date() +"Inside DAOImpl  getMainModuleList() "+ e);
			return null;
		}
	}

	@Override
	public List<Object[]> getSubModuleList(String loginType) throws Exception {
		logger.info(new Date() +"Inside DAOImpl getSubModuleList()");
		try {
			Query query=manager.createNativeQuery("SELECT a.formmoduleId,a.FormUrl,a.FormDispName,m.SerialNo,a.FormSerialNo FROM form_detail a INNER JOIN form_module m ON m.FormModuleId=a.FormModuleId INNER JOIN form_role_access r ON r.FormDetailId=a.FormDetailId AND r.LoginType=:loginType AND r.isactive='1' ORDER BY m.SerialNo,a.FormSerialNo");
			
			query.setParameter("loginType", loginType);
			List<Object[]> list=(List<Object[]>)query.getResultList();
			
			return list;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date() +"Inside DAOImpl  getSubModuleList() "+ e);
			return null;
		}
	}
	
	@Override
	public List<Object[]> getDivisionDetailsList(int RupeeValue,String FinYear,Long divisionId) throws Exception{
		logger.info(new Date() +"Inside DAOImpl getDivisionDetailsList()");
		try {
			Query query=manager.createNativeQuery("SELECT dm.DivisionId,dm.DivisionName,COUNT(f.FundApprovalId) AS TotalCount,COUNT(CASE WHEN f.EstimateType = 'R' THEN 1 END) AS RE_Count,COUNT(CASE WHEN f.EstimateType = 'F' THEN 1 END) AS FBE_Count, ROUND(SUM(CASE  WHEN f.EstimateType = 'R' THEN IFNULL(f.Apr, 0) + IFNULL(f.May, 0) + IFNULL(f.Jun, 0) + IFNULL(f.Jul, 0) +IFNULL(f.Aug, 0) + IFNULL(f.Sep, 0) + IFNULL(f.Oct, 0) + IFNULL(f.Nov, 0) + IFNULL(f.December, 0) + IFNULL(f.Jan, 0) + IFNULL(f.Feb, 0) + IFNULL(f.Mar, 0)  ELSE 0  END) / :rupeeValue, 2) AS RE_TotalCost,ROUND(SUM(CASE  WHEN f.EstimateType = 'F' THEN IFNULL(f.Apr, 0) + IFNULL(f.May, 0) + IFNULL(f.Jun, 0) + IFNULL(f.Jul, 0) +IFNULL(f.Aug, 0) + IFNULL(f.Sep, 0) + IFNULL(f.Oct, 0) + IFNULL(f.Nov, 0) +IFNULL(f.December, 0) + IFNULL(f.Jan, 0) + IFNULL(f.Feb, 0) + IFNULL(f.Mar, 0) ELSE 0 END) / :rupeeValue, 2) AS FBE_TotalCost, dm.DivisionCode FROM division_master dm LEFT JOIN fund_approval f ON f.DivisionId = dm.DivisionId WHERE f.finYear = :finYear AND (CASE WHEN '-1' = :divisionId THEN 1 = 1 ELSE f.DivisionId = :divisionId END) GROUP BY dm.DivisionId, dm.DivisionName;\n"
					+ "");
			query.setParameter("rupeeValue", RupeeValue);
			query.setParameter("finYear", FinYear);
			query.setParameter("divisionId", divisionId);
			List<Object[]> list=(List<Object[]>)query.getResultList();
			return list;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(new Date() +"Inside DAOImpl  getDivisionDetailsList() "+ e);
			return null;
		}
	}

}
