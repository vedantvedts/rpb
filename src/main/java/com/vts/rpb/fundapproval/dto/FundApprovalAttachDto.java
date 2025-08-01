package com.vts.rpb.fundapproval.dto;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class FundApprovalAttachDto {
	private long FundApprovalAttachId;
	private long FundApprovalId;
	private String[] Path;
	private String[] FileName;
	private MultipartFile[] files;
	private String[] OriginalFileName;
	private String CreatedBy;
	private LocalDateTime CreatedDate;
	private String ModifiedBy;
	private LocalDateTime ModifiedDate;
}
