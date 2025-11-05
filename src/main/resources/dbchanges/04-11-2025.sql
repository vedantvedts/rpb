
INSERT INTO rpb_dbupdates(filename,UpdateDate) VALUES('04-11-2025.sql', NOW());


DELIMITER $$

DROP PROCEDURE IF EXISTS `create_master_views`$$

CREATE PROCEDURE `create_master_views`(IN InDataBaseName VARCHAR(100))
BEGIN
    -- project_master_view
    SET @sql = 'DROP VIEW IF EXISTS project_master_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW project_master_view AS SELECT * FROM ', InDataBaseName, '.project_master');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- project_main_view
    SET @sql = 'DROP VIEW IF EXISTS project_main_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW project_main_view AS SELECT * FROM ', InDataBaseName, '.project_main');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- division_group_view
    SET @sql = 'DROP VIEW IF EXISTS division_group_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW division_group_view AS SELECT * FROM ', InDataBaseName, '.division_group');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- division_master_view
    SET @sql = 'DROP VIEW IF EXISTS division_master_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW division_master_view AS SELECT * FROM ', InDataBaseName, '.division_master');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- employee_view
    SET @sql = 'DROP VIEW IF EXISTS employee_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW employee_view AS SELECT * FROM ', InDataBaseName, '.employee');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- employee_desig_view
    SET @sql = 'DROP VIEW IF EXISTS employee_desig_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW employee_desig_view AS SELECT * FROM ', InDataBaseName, '.employee_desig');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- lab_master_view
    SET @sql = 'DROP VIEW IF EXISTS lab_master_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW lab_master_view AS SELECT * FROM ', InDataBaseName, '.lab_master');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- vendor_view
    SET @sql = 'DROP VIEW IF EXISTS vendor_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW vendor_view AS SELECT * FROM ', InDataBaseName, '.vendor');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
     -- project_initiation
    SET @sql = 'DROP VIEW IF EXISTS project_initiation_view';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('CREATE VIEW project_initiation_view AS SELECT * FROM ', InDataBaseName, '.pfms_initiation');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS `Ibas_FundRequestList`$$

CREATE PROCEDURE `Ibas_FundRequestList`(IN inFinYear VARCHAR (11),IN inDivisionId BIGINT(20), IN inEstimateType VARCHAR(5),IN inLoginType VARCHAR(5), IN inEmpId BIGINT(20), IN inProjectId BIGINT(20), IN inCommitteeMember VARCHAR(10))
BEGIN

      WITH LinkedMembersStatus AS (
	      SELECT ml.FundApprovalId, GROUP_CONCAT(ml.EmpId) AS RcEmpIds, GROUP_CONCAT(ml.MemberType) AS RcMemberTypes, GROUP_CONCAT(ml.IsApproved) AS RcIsApproved, GROUP_CONCAT(ml.IsSkipped) AS IsSkipped
	      FROM ibas_fund_members_linked ml
	      INNER JOIN fund_approval fa ON fa.FundApprovalId = ml.FundApprovalId AND fa.FinYear = inFinYear
	      GROUP BY FundApprovalId
	      )
	
	SELECT f.FundApprovalId, f.EstimateType, f.DivisionId, f.FinYear, f.REFBEYear, f.ProjectId, f.BudgetHeadId, h.BudgetHeadDescription, f.BudgetItemId, i.HeadOfAccounts, i.MajorHead, 
	i.MinorHead, i.SubHead, i.SubMinorHead, f.BookingId, f.CommitmentPayIds, f.ItemNomenclature, f.Justification, 
	ROUND((f.Apr + f.May + f.Jun + f.Jul + f.Aug + f.Sep + f.Oct + f.Nov + f.December + f.Jan + f.Feb +f.Mar),2) AS EstimatedCost, f.InitiatingOfficer, e.EmpName, ed.Designation, f.Remarks, 
	f.PDIDemandDate, f.status, d.DivisionCode, d.DivisionName,f.InitiationId, f.BudgetType, ini.ProjectShortName, ini.ProjectTitle, d.DivisionHeadId, cml.RcMemberTypes, cml.RcIsApproved
	 FROM fund_approval f 
	 LEFT JOIN employee_view e ON e.EmpId=f.InitiatingOfficer 
	 LEFT JOIN employee_desig_view ed ON ed.DesigId=e.DesigId 
	 LEFT JOIN tblbudgethead h ON h.BudgetHeadId=f.BudgetHeadId 
	 LEFT JOIN tblbudgetitem i ON i.BudgetItemId=f.BudgetItemId 
	 LEFT JOIN division_master_view d ON d.DivisionId=f.DivisionId 
	 LEFT JOIN project_initiation_view ini ON ini.InitiationId = f.InitiationId 
	 LEFT JOIN LinkedMembersStatus cml ON cml.FundApprovalId=f.FundApprovalId
	 WHERE f.FinYear = inFinYear AND f.ProjectId = inProjectId AND f.EstimateType = inEstimateType AND 
	 (CASE WHEN '-1' = inDivisionId THEN 1 = 1 ELSE f.DivisionId = inDivisionId END) AND 
	 (CASE WHEN ('A' = inLoginType OR inCommitteeMember IN ('CS', 'CC')) THEN 1=1 ELSE f.DivisionId IN (SELECT DivisionId FROM employee_view WHERE EmpId = inEmpId) END) 
	 ORDER BY f.FundApprovalId DESC;

END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `Ibas_EstimateTypeParticularDivList_Rpt`$$

CREATE PROCEDURE `Ibas_EstimateTypeParticularDivList_Rpt`(IN inFinYear VARCHAR (11),IN inDivisionId BIGINT(20), IN inEstimateType VARCHAR(5),IN inLoginType VARCHAR(5), IN inEmpId BIGINT(20), IN inInitiationId BIGINT(20), IN inBudget VARCHAR(50), IN inBudgetHeadId BIGINT(20), IN inBudgetItemId BIGINT(20), IN inFromCost VARCHAR(50), IN inToCost VARCHAR(50), IN inStatus VARCHAR(20), IN inMemberType VARCHAR(10), IN inAmountType INT)
BEGIN

      WITH LinkedMembersStatus AS (
	      SELECT ml.FundApprovalId, GROUP_CONCAT(ml.EmpId) AS RcEmpIds, GROUP_CONCAT(ml.MemberType) AS RcMemberTypes, GROUP_CONCAT(ml.IsApproved) AS RcIsApproved, GROUP_CONCAT(ml.IsSkipped) AS IsSkipped
	      FROM ibas_fund_members_linked ml
	      INNER JOIN fund_approval fa ON fa.FundApprovalId = ml.FundApprovalId AND fa.FinYear = inFinYear
	      GROUP BY FundApprovalId
	      )
	      
	SELECT f.FundApprovalId, dm.DivisionId, dm.DivisionName, f.EstimateType, f.DivisionId, f.FinYear, f.REFBEYear, f.ProjectId, f.BudgetHeadId, h.BudgetHeadDescription, f.BudgetItemId, 
	i.HeadOfAccounts, i.MajorHead, i.MinorHead, i.SubHead, i.SubMinorHead,f.BookingId, f.CommitmentPayIds, f.ItemNomenclature, f.Justification, 
	ROUND(IFNULL((f.Apr + f.May + f.Jun + f.Jul + f.Aug + f.Sep + f.Oct + f.Nov + f.December + f.Jan + f.Feb + f.Mar) / inAmountType,0),2) AS EstimatedCost, f.InitiatingOfficer, e.EmpName, ed.Designation, 
	f.Remarks, f.Status, f.PDIDemandDate, dm.DivisionCode, ifa_latest_approver.Remarks AS ChairmanRemarks, attach.Attachments, cml.RcMemberTypes, cml.RcIsApproved
	FROM fund_approval f 
	LEFT JOIN employee_view e ON e.EmpId=f.InitiatingOfficer 
	LEFT JOIN employee_desig_view ed ON ed.DesigId=e.DesigId 
	LEFT JOIN tblbudgethead h ON h.BudgetHeadId=f.BudgetHeadId 
	LEFT JOIN tblbudgetitem i ON i.BudgetItemId=f.BudgetItemId 
	LEFT JOIN division_master_view dm ON dm.DivisionId = inDivisionId 
	LEFT JOIN (
			SELECT att.FundApprovalId,GROUP_CONCAT(CONCAT(att.FileName, '::', att.OriginalFileName, '::', att.Path, '::',att.FundApprovalAttachId) SEPARATOR '||') AS Attachments 
			FROM fund_approval_attach att 
			GROUP BY att.FundApprovalId
			
		  ) attach ON attach.FundApprovalId = f.FundApprovalId 
	
	LEFT JOIN LinkedMembersStatus cml ON cml.FundApprovalId = f.FundApprovalId
	LEFT JOIN (
			SELECT t.FundApprovalId, t.Remarks 
			FROM ibas_fund_approval_trans t 
			INNER JOIN ibas_flow_details fd ON  fd.FlowDetailsId = t.FlowDetailsId AND fd.StatusCode = 'CC' AND fd.StatusType = 'A'
			
		  ) ifa_latest_approver ON ifa_latest_approver.FundApprovalId = f.FundApprovalId 
		  
	WHERE f.FinYear = inFinYear AND f.ProjectId = 0 AND (('-1' = inBudget) OR ((CASE WHEN 'N' = inBudget THEN f.InitiationId = inInitiationId ELSE f.InitiationId = 0 END) 
	AND (CASE WHEN 0 = inBudgetHeadId THEN 1=1 ELSE f.BudgetHeadId = inBudgetHeadId END) AND (CASE WHEN 0 = inBudgetItemId THEN 1=1 ELSE f.BudgetItemId = inBudgetItemId END))) 
	AND f.EstimateType = inEstimateType AND (CASE WHEN '-1' = inDivisionId THEN 1=1 ELSE f.DivisionId = inDivisionId END) AND 
	(CASE WHEN 'A' = inLoginType THEN 1=1 ELSE (CASE WHEN inMemberType = 'CC' OR inMemberType = 'CS' THEN 1=1 ELSE f.DivisionId IN (SELECT DivisionId FROM employee_view WHERE EmpId = inEmpId) END) END)
	AND (CASE WHEN inStatus = 'NA' THEN 1 WHEN inStatus = 'A' THEN (CASE WHEN f.Status = 'A' THEN 1 ELSE 0 END) ELSE (CASE WHEN f.Status <> 'A' THEN 1 ELSE 0 END) END) = 1 
	HAVING EstimatedCost BETWEEN inFromCost AND inToCost 
	ORDER BY f.FundApprovalId DESC;

END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS `Ibas_FundReportList_Rpt`$$

CREATE PROCEDURE `Ibas_FundReportList_Rpt`(IN inFinYear VARCHAR (11),IN inDivisionId BIGINT(20), IN inEstimateType VARCHAR(5),IN inLoginType VARCHAR(5), IN inEmpId BIGINT(20), IN inInitiationId BIGINT(20), IN inBudget VARCHAR(50), IN inBudgetHeadId BIGINT(20), IN inBudgetItemId BIGINT(20), IN inFromCost VARCHAR(50), IN inToCost VARCHAR(50), IN inStatus VARCHAR(20), IN inMemberType VARCHAR(10), IN inAmountType INT)
BEGIN

      WITH LinkedMembersStatus AS (
	      SELECT ml.FundApprovalId, GROUP_CONCAT(ml.EmpId) AS RcEmpIds, GROUP_CONCAT(ml.MemberType) AS RcMemberTypes, GROUP_CONCAT(ml.IsApproved) AS RcIsApproved, GROUP_CONCAT(ml.IsSkipped) AS IsSkipped
	      FROM ibas_fund_members_linked ml
	      INNER JOIN fund_approval fa ON fa.FundApprovalId = ml.FundApprovalId AND fa.FinYear = inFinYear
	      GROUP BY FundApprovalId
	      )
	      
	SELECT DISTINCT f.FundApprovalId, f.EstimateType, f.DivisionId,  f.FinYear, f.REFBEYear, f.ProjectId, f.BudgetHeadId, h.BudgetHeadDescription, f.BudgetItemId, i.HeadOfAccounts, 
	i.MajorHead, i.MinorHead, i.SubHead, i.SubMinorHead, f.BookingId, f.CommitmentPayIds, f.ItemNomenclature, f.Justification, 
	ROUND(IFNULL((f.Apr + f.May + f.Jun + f.Jul + f.Aug + f.Sep + f.Oct + f.Nov + f.December + f.Jan + f.Feb + f.Mar) / inAmountType,0),2) AS EstimatedCost, f.InitiatingOfficer, e.EmpName, 
	ed.Designation, f.Remarks, f.status, f.PDIDemandDate, ifa_latest_approver.StatusCode AS ApproverStausCode, ifa_latest_approver.Remarks AS ApproverRemarks, 
	attach.Attachments, dm.divisionId, dm.divisionName, dm.divisionCode, pf.ProjectShortName, cml.RcMemberTypes, cml.RcIsApproved
	FROM fund_approval f 
	LEFT JOIN employee_view e ON e.EmpId=f.InitiatingOfficer 
	LEFT JOIN employee_desig_view ed ON ed.DesigId=e.DesigId 
	LEFT JOIN tblbudgethead h ON h.BudgetHeadId=f.BudgetHeadId 
	LEFT JOIN LinkedMembersStatus cml ON cml.FundApprovalId = f.FundApprovalId
	LEFT JOIN (
			SELECT t.FundApprovalId, t.Remarks,fd.StatusCode 
			FROM ibas_fund_approval_trans t 
			INNER JOIN ibas_flow_details fd ON  fd.FlowDetailsId = t.FlowDetailsId AND fd.StatusCode = 'APR' AND fd.StatusType = 'A'
			
		   ) ifa_latest_approver ON ifa_latest_approver.FundApprovalId = f.FundApprovalId 
		   
	LEFT JOIN (
			SELECT att.FundApprovalId,GROUP_CONCAT(CONCAT(att.FileName, '::', att.OriginalFileName, '::', att.Path, '::',att.FundApprovalAttachId) SEPARATOR '||') AS Attachments 
			FROM fund_approval_attach att 
			GROUP BY att.FundApprovalId
			
		   ) attach ON attach.FundApprovalId = f.FundApprovalId 
		   
	LEFT JOIN tblbudgetitem i ON i.BudgetItemId=f.BudgetItemId 
	LEFT JOIN division_master_view dm ON dm.DivisionId = inDivisionId 
	LEFT JOIN project_initiation_view pf ON pf.InitiationId = inInitiationId 
	
	WHERE f.FinYear = inFinYear AND f.ProjectId = 0 AND (('-1' = inBudget) OR ((CASE WHEN 'N' = inBudget THEN f.InitiationId = inInitiationId ELSE f.InitiationId = 0 END) 
	AND (CASE WHEN 0 = inBudgetHeadId THEN 1=1 ELSE f.BudgetHeadId = inBudgetHeadId END) AND (CASE WHEN 0 = inBudgetItemId THEN 1=1 ELSE f.BudgetItemId = inBudgetItemId END))) 
	AND f.EstimateType = inEstimateType AND (CASE WHEN '-1' = inDivisionId THEN 1=1 ELSE f.DivisionId = inDivisionId END) AND (CASE WHEN 'A' = inLoginType THEN 1=1 ELSE 
	(CASE WHEN inMemberType = 'CC' OR inMemberType = 'CS' THEN 1=1 ELSE f.DivisionId IN (SELECT DivisionId FROM employee_view WHERE EmpId = inEmpId) END) END) 
	AND (CASE WHEN inStatus = 'NA' THEN 1 WHEN inStatus = 'A' THEN (CASE WHEN f.Status = 'A' THEN 1 ELSE 0 END) ELSE (CASE WHEN f.Status <> 'A' THEN 1 ELSE 0 END) END) = 1 
	HAVING EstimatedCost BETWEEN inFromCost AND inToCost 
	ORDER BY h.BudgetHeadDescription DESC;

END$$

DELIMITER ;