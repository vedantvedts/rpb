package com.vts.rpb.login.service;

import java.util.List;

public interface LoginService 
{
	public List<Object[]> getMainModuleList(String loginType) throws Exception;
	
    public List<Object[]> getSubModuleList(String loginType) throws Exception;
    
    public List<Object[]> getDivisionDetailsList(int RupeeValue,String FinYear) throws Exception;
}
