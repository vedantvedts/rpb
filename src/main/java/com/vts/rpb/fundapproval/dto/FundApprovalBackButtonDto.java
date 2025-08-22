package com.vts.rpb.fundapproval.dto;

import lombok.Data;
import java.io.Serializable;

@Data
public class FundApprovalBackButtonDto implements Serializable 
{
    private static final long serialVersionUID = 1L;
    private String FromYearBackBtn;
    private String ToYearBackBtn;
    private String EstimatedTypeBackBtn;
    private String DivisionBackBtn;
    private String DivisionCode;
    private String DivisionId;
    private String DivisionName;
    private String BudgetCode;
    private String ProjectDetails;    
    private String BudgetHeadDetails;
    private String FbeMainId;
    private String FBEYear;
    private String REYear;
    private String previousFinYear;
    private long budgetHeadId;
    private long budgetItemId;
    private String budgetType;
    private String proposedProject;
}
