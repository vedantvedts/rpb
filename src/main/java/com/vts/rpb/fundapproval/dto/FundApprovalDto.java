package com.vts.rpb.fundapproval.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class FundApprovalDto {
	
	private long FundApprovalId;
	private String EstimateType;
	private BigDecimal DivisionId;
	private String FinYear;
	private String REFBEYear;
	private long ProjectId;
	private long BudgetHeadId;
	private long BudgetItemId;
	private long BookingId;
	private String CommitmentPayIds;
	private String ItemNomenclature;
	private LocalDate RequisitionDate;
	private String Justification;
	private BigDecimal Apr;
	private BigDecimal May;
	private BigDecimal Jun;
	private BigDecimal Jul;
	private BigDecimal Aug;
	private BigDecimal Sep;
	private BigDecimal Oct;
	private BigDecimal Nov;
	private BigDecimal Dec;
	private BigDecimal Jan;
	private BigDecimal Feb;
	private BigDecimal Mar;
	private long InitiatingOfficer;
	private long RC1;
	private String RC1Role;
	private long RC2;
	private String RC2Role;
	private long RC3;
	private String RC3Role;
	private long RC4;
	private String RC4Role;
	private long RC5;
	private String RC5Role;
	private long ApprovingOfficer;
	private String ApprovingOfficerRole;
	private String RCStatusCode;
	private String RCStatusCodeNext;
	private String Status;
	private String Remarks;
	private String action;
	private LocalDate ApprovalDate;
	private String CreatedBy;
	private LocalDateTime CreatedDate;
	private String ModifiedBy;
	private LocalDateTime ModifiedDate;
	
	
}
