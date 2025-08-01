package com.vts.rpb.authenticate;

import org.springframework.data.jpa.repository.JpaRepository;

import com.vts.rpb.master.modal.Login;


public interface LoginRepository extends JpaRepository<Login, Long> 
{
	Login findByUserName(String Username);
}
