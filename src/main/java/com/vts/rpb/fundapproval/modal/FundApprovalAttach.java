package com.vts.rpb.fundapproval.modal;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity(name = "fund_approval_attach")
public class FundApprovalAttach {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "FundApprovalAttachId")
	private long FundApprovalAttachId;
	
	@Column(name = "FundApprovalId")
	private long fundApprovalId;
	
	@Column(name = "Path", length = 255)
	private String Path;
	
	@Column(name = "FileName", length = 100)
	private String FileName;
	
	@Column(name = "OriginalFileName", length = 255)
	private String OriginalFileName;
	
	@Column(name = "CreatedBy", length = 100)
	private String CreatedBy;
	
	@Column(name = "CreatedDate")
	private LocalDateTime CreatedDate; 
	
	@Column(name = "ModifiedBy", length = 100)
	private String ModifiedBy;
	
	@Column(name = "ModifiedDate")
	private LocalDateTime ModifiedDate;
}
