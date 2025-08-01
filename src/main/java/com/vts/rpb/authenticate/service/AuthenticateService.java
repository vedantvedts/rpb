package com.vts.rpb.authenticate.service;

import java.util.List;

public interface AuthenticateService 
{
	public List<Object[]> getMainModuleList(String loginType) throws Exception;
	
    public List<Object[]> getSubModuleList(String loginType) throws Exception;
}
