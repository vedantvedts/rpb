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
	private long divisionHeadId;
	private String[] membersId;
	private String[] subjectExpertsId;
	private long secretaryId;
	private long chairmanId;
	private String Status;
	private String Remarks;
	private String action;
	private LocalDate ApprovalDate;
	private String CreatedBy;
	private LocalDateTime CreatedDate;
	private String ModifiedBy;
	private LocalDateTime ModifiedDate;
	private String memberStatus;
	private String flowDetailsId;
	
	
}
