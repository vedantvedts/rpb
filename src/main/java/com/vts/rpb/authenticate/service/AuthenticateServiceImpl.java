package com.vts.rpb.authenticate.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.vts.rpb.authenticate.dao.AuthenticateDao;

@Service
public class AuthenticateServiceImpl implements AuthenticateService
{
	@Autowired
	private AuthenticateDao authDao;

	@Override
	public List<Object[]> getMainModuleList(String loginType) throws Exception {
		return authDao.getMainModuleList(loginType);
	}

	@Override
	public List<Object[]> getSubModuleList(String loginType) throws Exception {
		return authDao.getSubModuleList(loginType);
	}

}
