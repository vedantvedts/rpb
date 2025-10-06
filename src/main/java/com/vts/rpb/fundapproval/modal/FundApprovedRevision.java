package com.vts.rpb.fundapproval.modal;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Data
@Entity(name ="fund_approved_revision")
public class FundApprovedRevision {

	

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "FundApprovedRevisionId")
	private long fundApprovedRevisionId;
	
	@Column(name = "FundApprovalId")
	private long fundApprovalId;
	
	@Column(name = "EstimateType", length = 1)
	private String estimateType;
	
	@Column(name = "EstimateAction", length = 5)
	private String estimateAction;
	
	@Column(name = "SerialNo", length = 20)
	private String serialNo;
	
	@Column(name = "DivisionId")
	private long divisionId;
	
	@Column(name = "FinYear", length = 11)
	private String finYear;
	
	@Column(name = "REFBEYear", length = 5)
	private String reFbeYear;
	
	@Column(name = "InitiationId")
	private long initiationId;
	
	@Column(name = "BudgetType", length = 1)
	private String budgetType;
	
	@Column(name = "ProjectId")
	private long projectId;
	
	@Column(name = "BudgetHeadId")
	private long budgetHeadId;
	
	@Column(name = "BudgetItemId")
	private long budgetItemId;
	
	@Column(name = "FundRequestId")
	private long fundRequestId=0;
	
	@Column(name = "BookingId")
	private long bookingId=0;
	
	@Column(name = "CommitmentPayIds", length = 255)
	private String commitmentPayIds;
	
	@Column(name = "ItemNomenclature", length = 500)
	private String itemNomenclature;
	
	@Column(name = "RequisitionDate")
	private LocalDate RequisitionDate;
	
	@Column(name = "Justification", length = 500)
	private String justification;
	
	@Column(name = "FundRequestAmount", precision = 17, scale = 2, nullable = false)
	private BigDecimal fundRequestAmount = BigDecimal.ZERO;
	
	@Column(name = "Apr", precision = 17, scale = 2, nullable = false)
	private BigDecimal april = BigDecimal.ZERO;
	
	@Column(name = "May", precision = 17, scale = 2, nullable = false)
	private BigDecimal may = BigDecimal.ZERO;
	
	@Column(name = "Jun", precision = 17, scale = 2, nullable = false)
	private BigDecimal june = BigDecimal.ZERO;
	
	@Column(name = "Jul", precision = 17, scale = 2, nullable = false)
	private BigDecimal july = BigDecimal.ZERO;
	
	@Column(name = "Aug", precision = 17, scale = 2, nullable = false)
	private BigDecimal august = BigDecimal.ZERO;
	
	@Column(name = "Sep", precision = 17, scale = 2, nullable = false)
	private BigDecimal september = BigDecimal.ZERO;
	
	@Column(name = "Oct", precision = 17, scale = 2, nullable = false)
	private BigDecimal october = BigDecimal.ZERO;
	
	@Column(name = "Nov", precision = 17, scale = 2, nullable = false)
	private BigDecimal november = BigDecimal.ZERO;
	
	@Column(name = "December", precision = 17, scale = 2, nullable = false)
	private BigDecimal december = BigDecimal.ZERO;
	
	@Column(name = "Jan", precision = 17, scale = 2, nullable = false)
	private BigDecimal january = BigDecimal.ZERO;
	
	@Column(name = "Feb", precision = 17, scale = 2, nullable = false)
	private BigDecimal february = BigDecimal.ZERO;
	
	@Column(name = "Mar", precision = 17, scale = 2, nullable = false)
	private BigDecimal march = BigDecimal.ZERO;
	
	@Column(name = "InitiatingOfficer")
	private long InitiatingOfficer=0;
	
	@Column(name = "Status", length = 1)
	private String status="N";
	
	@Column(name = "Remarks", length = 255)
	private String remarks;
	
	@Column(name = "RevisionCount")
	private long revisionCount=0;
	
	@Column(name = "ApprovalDate")
	private LocalDate approvalDate;
	
	@Column(name = "RevokedBy", length = 100)
	private long revokedBy;
	
	@Column(name = "RevokedDate")
	private LocalDateTime revokedDate;
	
	@Column(name = "ReturnedBy")
	private long returnedBy;
	
	@Column(name = "ReturnedDate")
	private LocalDateTime returnedDate;
	
	@Column(name = "ApprovedBy")
	private long approvedBy;
	
	@Column(name = "ApprovedDate")
	private LocalDateTime approvedDate;
	
	@Column(name = "CreatedBy", length = 100)
	private String  createdBy;
	
	@Column(name = "CreatedDate")
	private LocalDateTime createdDate;
	
}
