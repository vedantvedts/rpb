
INSERT INTO rpb_dbupdates(filename,UpdateDate) VALUES('06-10-2025.sql', NOW());


ALTER TABLE `fund_approved_revision`   
	DROP COLUMN `RC1`, 
	DROP COLUMN `RC1Role`, 
	DROP COLUMN `RC2`, 
	DROP COLUMN `RC2Role`, 
	DROP COLUMN `RC3`, 
	DROP COLUMN `RC3Role`, 
	DROP COLUMN `RC4`, 
	DROP COLUMN `RC4Role`, 
	DROP COLUMN `RC5`, 
	DROP COLUMN `RC5Role`, 
	DROP COLUMN `RC6`, 
	DROP COLUMN `RC6Role`, 
	DROP COLUMN `ApprovingOfficer`, 
	DROP COLUMN `ApprovingOfficerRole`, 
	DROP COLUMN `RCStatusCode`, 
	DROP COLUMN `RCStatusCodeNext`, 
	ADD COLUMN `EstimateAction` VARCHAR(5) DEFAULT 'C' NULL COMMENT 'L - Last Year FBE Details, C - Current Year RE Details' AFTER `EstimateType`,
	ADD COLUMN `RevokedBy` BIGINT DEFAULT 0 NOT NULL AFTER `ApprovalDate`,
	ADD COLUMN `RevokedDate` DATETIME NULL AFTER `RevokedBy`,
	ADD COLUMN `ReturnedBy` BIGINT DEFAULT 0 NOT NULL AFTER `RevokedDate`,
	ADD COLUMN `ReturnedDate` DATETIME NULL AFTER `ReturnedBy`,
	ADD COLUMN `ApprovedBy` BIGINT DEFAULT 0 NOT NULL AFTER `ReturnedDate`,
	ADD COLUMN `ApprovedDate` DATETIME NULL AFTER `ApprovedBy`;
	
	
	DELIMITER $$

DROP PROCEDURE IF EXISTS `Ibas_FundApprovalListAndApprovedList`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ibas_FundApprovalListAndApprovedList`(IN InFinYear VARCHAR (11),IN InEmpId BIGINT(20), IN InListType VARCHAR(2),IN InLoginType VARCHAR(5))
BEGIN
	-- InListType - F - Pending List, A - Approved

      WITH all_employee AS (
      SELECT e.EmpId,e.EmpNo,e.EmpName,e.DesigId,ed.Designation,e.DivisionId,d.DivisionCode,d.DivisionShortName,d.DivisionName
      FROM employee_view e
      LEFT JOIN employee_desig_view ed ON ed.DesigId = e.DesigId
      LEFT JOIN division_master_view d ON d.DivisionId=e.DivisionId
      WHERE e.IsActive = '1'
      ),
       LinkedMembersStatus AS (
	      SELECT ml.FundApprovalId, GROUP_CONCAT(ml.EmpId) AS RcEmpIds, GROUP_CONCAT(ml.MemberType) AS RcMemberTypes, GROUP_CONCAT(ml.IsApproved) AS RcIsApproved, GROUP_CONCAT(ml.IsSkipped) AS IsSkipped
	      FROM ibas_fund_members_linked ml
	      INNER JOIN fund_approval fa ON fa.FundApprovalId = ml.FundApprovalId AND fa.FinYear = InFinYear
	      GROUP BY FundApprovalId
	      )
 
	SELECT f.FundApprovalId, f.EstimateType, f.FinYear, f.REFBEYear, f.ProjectId, f.BudgetHeadId, f.BudgetItemId, f.RequisitionDate, 
	bh.BudgetHeadDescription,bi.HeadOfAccounts,bi.SubHead,f.DivisionId,dm.DivisionCode,dm.DivisionName,f.ItemNomenclature,f.Justification,
	f.RequisitionDate,(IFNULL(Apr,0) + IFNULL(May,0) + IFNULL(Jun,0) + IFNULL(Jul,0) + IFNULL(Aug,0) + IFNULL(Sep,0) + IFNULL(OCT,0) + IFNULL(Nov,0) + IFNULL(December,0) + IFNULL(Jan,0) + IFNULL(Feb,0) + IFNULL(Mar,0)) AS ItemCost,
	CONCAT(iof.EmpName, ', ', iof.Designation) AS InitiatingOfficerName, f.Status, cml.RcMemberTypes, cml.RcEmpIds, cml.RcIsApproved
	FROM fund_approval f
	LEFT JOIN tblbudgethead bh ON bh.BudgetHeadId = f.BudgetHeadId 
	LEFT JOIN tblbudgetitem bi ON bi.BudgetItemId=f.BudgetItemId
	LEFT JOIN division_master_view dm ON dm.DivisionId = f.DivisionId 
	LEFT JOIN all_employee iof  ON iof.EmpId = f.InitiatingOfficer
        LEFT JOIN LinkedMembersStatus cml ON cml.FundApprovalId=f.FundApprovalId

	WHERE f.FinYear = InFinYear AND (CASE WHEN InListType='F' THEN (f.Status = 'F' OR f.Status = 'B') ELSE 1=1 END) AND 
	FIND_IN_SET(InEmpId,cml.RcEmpIds) AND 
	SUBSTRING_INDEX(SUBSTRING_INDEX(cml.IsSkipped, ',', FIND_IN_SET(InEmpId, cml.RcEmpIds)),',',-1) = 'N' AND
	(CASE WHEN InListType = 'F' THEN 
	SUBSTRING_INDEX(SUBSTRING_INDEX(cml.RcIsApproved, ',', FIND_IN_SET(InEmpId, cml.RcEmpIds)),',',-1) = 'N'
	ELSE 
	SUBSTRING_INDEX(SUBSTRING_INDEX(cml.RcIsApproved, ',', FIND_IN_SET(InEmpId, cml.RcEmpIds)),',',-1) = 'Y' END)
	AND f.EstimateAction = 'C';

END$$

DELIMITER ;
