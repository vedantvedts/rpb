package com.vts.rpb.fundapproval.modal;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Data

@Entity(name = "fund_approval_queries")
public class FundApprovalQueries {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "QueryId")
	private long queryId;
	
	@Column(name = "FundApprovalId")
	private long fundApprovalId;
	
	@Column(name = "EmpId")
	private long  empId;
	
	@Column(name = "Query", length = 100)
	private String query;
	
	@Column(name = "ActionDate")
	private LocalDateTime actionDate;
}