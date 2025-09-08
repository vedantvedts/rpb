package com.vts.rpb.master.modal;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity

@Table(name="ibas_committee_members")
public class CommitteeMembers {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "CommitteeMemberId")
	private long CommitteeMemberId;
	
	@Column(name = "MemberType", length = 2)
    private String MemberType;
	
	@Column(name = "EmpId")
    private long empId;
	
	@Column(name = "FromDate")
    private LocalDate FromDate;
	
	@Column(name = "ToDate")
    private LocalDate ToDate;
	
	@Column(name = "CreatedBy", length = 100)
    private String CreatedBy;
	
	@Column(name = "CreatedDate")
    private LocalDateTime CreatedDate;
	
	@Column(name = "ModifiedBy", length = 100)
    private String modifiedBy;
	
	@Column(name = "ModifiedDate")
    private LocalDateTime modifiedDate;
	
	@Column(name = "IsActive")
    private int isActive;
}
