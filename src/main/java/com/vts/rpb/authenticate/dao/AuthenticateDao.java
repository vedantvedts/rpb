package com.vts.rpb.authenticate.dao;

import java.util.List;

public interface AuthenticateDao 
{
	List<Object[]> getMainModuleList(String loginType) throws Exception;

	List<Object[]> getSubModuleList(String loginType) throws Exception;

}
