package com.vts.rpb.fundapproval.modal;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import lombok.Data;


@Data
@Entity(name ="ibas_fund_members_linked")
public class FundLinkedMembers {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "MemberLinkedId")
	private long committeeMemberLinkedId;
	
	@Column(name = "FundApprovalId")
	private long fundApprovalId;
	
	@Column(name = "FlowMasterId")
	private long flowMasterId;
	
	@Column(name = "EmpId")
	private long empId;
	
	// CC - Chairman, SC - Standby Chairman, CM - Committee Member, CS - Committee Secretary, SE - Subject Expert, DH - Division Head
	@Column(name = "MemberType", length = 2)
	private String memberType;

	@Column(name = "IsApproved", length = 1)
	private String isApproved = "N";
	
	@Column(name = "IsSkipped", length = 5)
	private String isSkipped = "N";
	
	@Column(name = "SkipReason", length = 5)
	private String skipReason;
	
	@Column(name = "CreatedBy", length = 100)
	private String  createdBy;
	
	@Column(name = "CreatedDate")
	private LocalDateTime createdDate;
	
	@Column(name = "ModifiedBy", length = 100)
	private String modifiedBy;
	
	@Column(name = "ModifiedDate")
	private LocalDateTime modifiedDate;
	
	@Column(name = "IsActive")
	private int isActive;

}
