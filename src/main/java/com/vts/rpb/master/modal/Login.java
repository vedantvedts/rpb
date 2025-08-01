package com.vts.rpb.master.modal;

import java.time.LocalDateTime;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "login")
@Data
public class Login {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "LoginId")
	private long loginId;
	
	@Column(name = "username", length = 20)
    private String userName;
	
	@Column(name = "Password", length = 255)
    private String password;
	
	@Column(name = "EmpId")
    private long empId;
	
	@Column(name = "DivisionId")
    private long divisionId;
	
	@Column(name = "FormRoleId")
    private long formRoleId;
	
	@Column(name = "LoginType", length = 1)
    private String loginType;
	
	@Column(name = "Ibas", length = 1)
    private String ibas;
	
	@Column(name = "Pfms", length = 1)
    private String pfms;
	
	@Column(name = "IsActive")
    private int isActive;
	
	@Column(name = "CreatedBy", length = 100)
    private String createdBy;
	
	@Column(name = "CreatedDate")
    private LocalDateTime createdDate;
	
	@Column(name = "ModifiedBy", length = 100)
    private String modifiedBy;
	
	@Column(name = "ModifiedDate")
    private LocalDateTime modifiedDate;
   
}