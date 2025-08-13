package com.vts.rpb.login.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.vts.rpb.login.dao.LoginDao;

@Service
public class LoginServiceImpl implements LoginService
{
	@Autowired
	private LoginDao loginDao;

	@Override
	public List<Object[]> getMainModuleList(String loginType) throws Exception {
		return loginDao.getMainModuleList(loginType);
	}

	@Override
	public List<Object[]> getSubModuleList(String loginType) throws Exception {
		return loginDao.getSubModuleList(loginType);
	}
	
	@Override
	public List<Object[]> getDivisionDetailsList(int RupeeValue,String FinYear,Long divisionId) throws Exception{
		return loginDao.getDivisionDetailsList(RupeeValue,FinYear,divisionId);
	}

}
