package com.vts.rpb.login.dao;

import java.util.List;

public interface LoginDao 
{
	List<Object[]> getMainModuleList(String loginType) throws Exception;

	List<Object[]> getSubModuleList(String loginType) throws Exception;

	public List<Object[]> getDivisionDetailsList(int RupeeValue,String FinYear,Long divisionId) throws Exception;

}
