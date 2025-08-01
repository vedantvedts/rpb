package com.vts.rpb.fundapproval.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BudgetDetails {

	private int budgetHeadId;
	private String budgetHeadCode;
	private String budgetHeaddescription;
	private String refe; 
	private String headOfAccounts;
	private long budgetItemId; 
	private String majorHead;
	private String minorHead;
	private String subHead;
	private String subMinorHead;
	private String officerCode;
	private String empId;
	private String officerName;
	private String officerDesig;
	private String sanctionCost;
	private String expenditure;
	private String balance;
}
