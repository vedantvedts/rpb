package com.vts.rpb.fundapproval.modal;


import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import lombok.Data;


@Data
@Entity(name ="ibas_fund_approval_trans")
public class FundApprovalTrans {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "FundApprovalTransId")
	private long fundApprovalTransId;
	
	@Column(name = "FundApprovalId")
	private long fundApprovalId;
	
	@Column(name = "RCStausCode", length = 50)
	private String rcStausCode;
	
	@Column(name = "Remarks", length = 255)
	private String remarks;
	
	@Column(name = "Role", length = 50)
	private String role;
	
	@Column(name = "ActionBy")
	private long actionBy;
	
	@Column(name = "ActionDate")
	private LocalDateTime actionDate;
	

}
