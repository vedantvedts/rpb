package com.vts.rpb.authenticate.dao;

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
public class AuthenticateDaoImpl implements AuthenticateDao
{
	private static final Logger logger=LogManager.getLogger(AuthenticateDaoImpl.class);
	
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

}
