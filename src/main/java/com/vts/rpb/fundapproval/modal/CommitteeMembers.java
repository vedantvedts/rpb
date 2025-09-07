package com.vts.rpb.fundapproval.modal;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import lombok.Data;

@Data
@Entity(name ="ibas_committee_members")
public class CommitteeMembers {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "CommitteeMemberId")
	private long committeeMemberId;
	
	@Column(name = "MemberType", length = 2)
	private String memberType;
	
	@Column(name = "EmpId")
	private long empId;
	
	@Column(name = "FromDate")
	private LocalDate fromDate;
	
	@Column(name = "ToDate")
	private LocalDate toDate;
	
	@Column(name = "CreatedBy", length = 100)
	private String  createdBy;
	
	@Column(name = "CreatedDate")
	private LocalDateTime createdDate;
	
	@Column(name = "ModifiedBy", length = 100)
	private String modifiedBy;
	
	@Column(name = "ModifiedDate")
	private LocalDateTime modifiedDate;
	
	@Column(name = "IsActive")
	private int isActive=1;

}
