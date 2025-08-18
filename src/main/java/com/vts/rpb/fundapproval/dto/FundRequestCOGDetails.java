package com.vts.rpb.fundapproval.dto;

import lombok.Data;

@Data
public class FundRequestCOGDetails 
{
	private String[] employee;
	private String[] budgetItem;
	private String[] ItemNomenclature;
	private String[] FbeAmount;
	private String[] AprAmount;
	private String[] MayAmount;
	private String[] JunAmount;
	private String[] JulAmount;
	private String[] AugAmount;
	private String[] SepAmount;
	private String[] OctAmount;
	private String[] NovAmount;
	private String[] DecAmount;
	private String[] JanAmount;
	private String[] FebAmount;
	private String[] MarAmount;
	private String[] FutureMonth;
	private String[] CommitmentId;
	private String[] CommitmentPayId;
	private String[] DemandId;
	private String[] fundRequestId;
	private String[] carryForwardSerialNo;
	private String[] selectedFundRequestId;
	private String actionType;
}
