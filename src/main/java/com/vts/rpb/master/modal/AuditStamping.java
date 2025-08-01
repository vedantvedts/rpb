package com.vts.rpb.master.modal;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
@Entity(name = "auditstamping")
public class AuditStamping implements Serializable{
	
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "AuditStampingId")
    private long auditStampingId;
	
	@Column(name = "LoginId")
    private long loginId;
    
	@Column(name = "Username", length = 20)
    private String userName;
	
	@Column(name = "LoginDate")
    private LocalDate loginDate;
	
	@Column(name = "LoginDateTime")
    private LocalDateTime loginDateTime;
	
	@Column(name = "IpAddress", length = 255)
    private String ipAddress;
	
	@Column(name = "MacAddress", length = 255)
    private String macAddress;
	
	@Column(name = "LogOutType", length = 20)
    private String logoutType;
	
	@Column(name = "LogOutDateTime")
    private LocalDateTime logoutDateTime;



}
