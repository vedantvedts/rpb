
INSERT INTO rpb_dbupdates(filename,UpdateDate) VALUES('29-09-2025.sql', NOW());


ALTER TABLE `fund_approval`   
	ADD COLUMN `EstimateAction` VARCHAR(5) DEFAULT 'C' NULL COMMENT 'L - Last Year FBE Details, C - Current Year RE Details' AFTER `EstimateType`,
	ADD COLUMN `PDIDemandDate` DATE NULL COMMENT 'PDI - Probable Date of Demand Initiation' AFTER `RequisitionDate`;


Update tblbooking set FundRequestType= ‘R’;



ALTER TABLE `ibas_fund_members_linked`   
	ADD COLUMN `IsSkipped` VARCHAR(5) DEFAULT 'N' NULL AFTER `IsApproved`,
	ADD COLUMN `SkipReason` VARCHAR(5) NULL COMMENT 'T - TD, L - Leave' AFTER `IsSkipped`;

ALTER TABLE `ibas_fund_members_linked`   
	CHANGE `SkipReason` `SkipReason` VARCHAR(5) DEFAULT 'N' NULL COMMENT 'T - TD, L - Leave';

ALTER TABLE `ibas_fund_approval_trans`   
	ADD COLUMN `MemberLinkedId` BIGINT DEFAULT 0 NOT NULL AFTER `FundApprovalId`;


DELIMITER $$

DROP PROCEDURE IF EXISTS `Ibas_Fund_Approval_CarryForward`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ibas_Fund_Approval_CarryForward`(IN inDivisionId BIGINT,IN inBudgetHeadId BIGINT,IN inBudgetItemId BIGINT,IN inEstimateType VARCHAR(2), IN inFinYear VARCHAR(10), IN inPreviousFinYear VARCHAR(10), IN inAsOnDate DATETIME, IN inLabCode VARCHAR(20), IN inAction VARCHAR(50))
BEGIN

	 DECLARE actionDate DATE;
	 
	IF inEstimateType = 'F' THEN  SET actionDate = STR_TO_DATE(CONCAT(SUBSTRING_INDEX(inFinYear, '-', -1), '-03-31'), '%Y-%m-%d'); ELSE SET actionDate = inAsOnDate; END IF;

	IF inAction = 'Item' THEN
	   
		WITH currentYearFundRequestDetails AS (
		    SELECT IFNULL(GROUP_CONCAT(DISTINCT f.FundRequestId),-1) AS fundRequestId, IFNULL(GROUP_CONCAT(DISTINCT f.BookingId),-1) AS fundRequestBookingId, IFNULL(GROUP_CONCAT(DISTINCT f.CommitmentPayIds),-1) AS fundRequestPayId
		    FROM fund_approval f WHERE f.FinYear=inFinYear
		)

		# Item
		SELECT fa.FundApprovalId,fa.SerialNo,fa.EstimateType,fa.DivisionId,fa.FinYear,fa.ProjectId,fa.BudgetHeadId,fa.BudgetItemId,fa.ItemNomenclature,
		fa.RequisitionDate,fa.Justification,fa.FundRequestAmount,
		GREATEST(COALESCE(fa.FundRequestAmount - (SELECT SUM(b.EstimatedCost) FROM tblbooking b WHERE b.FbeSubId = fa.FundApprovalId AND b.FundRequestType='R' AND b.DemandFlag NOT IN ('N','C')), fa.FundRequestAmount),0) AS ItemBalance,
		fa.InitiatingOfficer,e.EmpName,ed.Designation,
		NULL AS BookingId,NULL AS DemandNo,NULL AS DeliveryMonth,0 AS EstimatedCost,0 AS DIPL,NULL AS CommitmentId,NULL AS FileNo,NULL AS SoNo,NULL AS SoDate,NULL AS DpDate,
		NULL AS SoCost,NULL AS OutCost,NULL AS CommitmentPayId,0 AS PayAmount,NULL AS PayDate,NULL AS PayFlag,'I' AS ItemStatus,NULL AS DemandItem,NULL AS SupplyOrderItem,
		1 AS SerialNoOrder,NULL AS demandFileNo,NULL AS soFileNo, NULL AS DemandDate
		FROM fund_approval fa
		LEFT JOIN employee_view e ON e.EmpId=fa.InitiatingOfficer
		LEFT JOIN employee_desig_view ed ON ed.DesigId=e.DesigId
		WHERE fa.FinYear=inPreviousFinYear AND fa.EstimateType=inEstimateType AND fa.DivisionId=inDivisionId AND fa.ProjectId='0' 
		AND (CASE WHEN '-1'=inBudgetHeadId THEN 1=1 ELSE fa.BudgetHeadId=inBudgetHeadId END) AND (CASE WHEN '-1'=inBudgetItemId THEN 1=1 ELSE fa.BudgetItemId=inBudgetItemId END)
		AND NOT FIND_IN_SET(fa.FundApprovalId,IFNULL((SELECT cfa.fundRequestId FROM currentYearFundRequestDetails cfa),'-1')) HAVING ItemBalance > 0 ORDER BY FundApprovalId,SerialNoOrder;
	   
	ELSEIF inAction = 'Demand' THEN
	
		WITH currentYearFundRequestDetails AS (
		    SELECT IFNULL(GROUP_CONCAT(DISTINCT f.FundRequestId),-1) AS fundRequestId, IFNULL(GROUP_CONCAT(DISTINCT f.BookingId),-1) AS fundRequestBookingId, IFNULL(GROUP_CONCAT(DISTINCT f.CommitmentPayIds),-1) AS fundRequestPayId
		    FROM fund_approval f WHERE f.FinYear=inFinYear
		)
	        
	        # demand
		SELECT fa.FundApprovalId,fa.SerialNo,fa.EstimateType,fa.DivisionId,fa.FinYear,fa.ProjectId,fa.BudgetHeadId,fa.BudgetItemId,fa.ItemNomenclature,
		fa.RequisitionDate,fa.Justification,fa.FundRequestAmount,
		GREATEST(COALESCE(fa.FundRequestAmount - (SELECT SUM(b.EstimatedCost) FROM tblbooking b WHERE b.FbeSubId = fa.FundApprovalId AND b.FundRequestType='R' AND b.DemandFlag NOT IN ('N','C')), fa.FundRequestAmount),0) AS ItemBalance,
		fa.InitiatingOfficer,e.EmpName,ed.Designation,
		b.BookingId,b.DemandNo,b.DeliveryMonth,IFNULL(b.EstimatedCost,0) AS EstimatedCost,
		GREATEST((
		CASE WHEN b.DemandFlag='Y' THEN 
		     # Supply Order Expenditure Deduction
		     IFNULL((b.EstimatedCost - IFNULL((SELECT SUM(IFNULL(cm.TotalCost,0)) FROM tblcommitment cm WHERE cm.DemandNo=b.DemandNo AND cm.IsCancel<>'Y' AND cm.ControlDate <= inAsOnDate),0)),0)
		     
		     WHEN b.DemandFlag='M' THEN 
		     # Direct Bill Expenditure and Imprest Expenditure Deduction
		     IFNULL((b.EstimatedCost - (IFNULL((SELECT SUM(IFNULL(p.Amount,0)) FROM tblpayment p LEFT JOIN tblpaymentcheque c ON c.PaymentId=p.PaymentId WHERE p.DemandNo=b.DemandNo AND p.BillFlag <> 'R' AND 
		     (CASE WHEN inLabCode IN ('LRDE', 'ADE') THEN p.CreatedDate <= inAsOnDate ELSE (CASE WHEN (c.PaymentId IS NOT NULL AND c.PaymentId <> '0') THEN c.ChequeSlipDate <= inAsOnDate ELSE p.UbDate <= inAsOnDate END) END) AND p.Category='D'),0) + 
		     IFNULL((IFNULL((SELECT SUM(IFNULL(BookedCost,0)) FROM imprest_booking WHERE DemandNo = b.DemandNo AND IsActive='1' AND BookingDate <= inAsOnDate), 0) - 
		     IFNULL((SELECT SUM(IFNULL(ib.BookedCost,0) - IFNULL((SELECT SUM(IFNULL(SettlementAmount,0)) FROM imprest_settlement WHERE FIND_IN_SET(ib.ImprestBookingId,ImprestBookingId)),ib.BookedCost))
		     FROM imprest_booking ib WHERE ib.DemandNo = b.DemandNo AND ib.IsActive='1' AND ib.BookingDate <= inAsOnDate),0)),0))),0) 
		     
		     # New Demand
		     ELSE IFNULL(b.EstimatedCost,0) END
		
		),0) AS DIPL,NULL AS CommitmentId,NULL AS FileNo,NULL AS SoNo,NULL AS SoDate,NULL AS DpDate,NULL AS SoCost,NULL AS OutCost,NULL AS CommitmentPayId,NULL AS PayAmount,NULL AS PayDate,
		NULL AS PayFlag,'D' AS ItemStatus,b.ItemFor AS DemandItem,NULL AS SupplyOrderItem,2 AS SerialNoOrder,b.FileNo AS demandFileNo,NULL AS soFileNo, b.DemandDate
		FROM tblbooking b
		LEFT JOIN fund_approval fa ON fa.FundApprovalId=b.FbeSubId
		LEFT JOIN employee_view e ON e.EmpId=fa.InitiatingOfficer
		LEFT JOIN employee_desig_view ed ON ed.DesigId=e.DesigId
		LEFT JOIN division_master_view d ON d.DivisionCode=b.DivisionCode
		WHERE d.DivisionId=inDivisionId AND b.ProjectId='0' AND (CASE WHEN '-1'=inBudgetHeadId THEN 1=1 ELSE b.BudgetHeadId=inBudgetHeadId END) AND (CASE WHEN '-1'=inBudgetItemId THEN 1=1 ELSE b.BudgetItemId=inBudgetItemId END)
		AND NOT FIND_IN_SET(b.BookingId,IFNULL((SELECT cfa.fundRequestBookingId FROM currentYearFundRequestDetails cfa),'-1')) AND b.DemandDate <= actionDate AND b.FundRequestType = 'R' -- R - Fund Approval
		HAVING DIPL > 0 
		
	        ORDER BY SerialNoOrder,BookingId;
	        
	ELSEIF inAction = 'SupplyOrder' THEN
	
		WITH currentYearFundRequestDetails AS (
		    SELECT IFNULL(GROUP_CONCAT(DISTINCT f.FundRequestId),-1) AS fundRequestId, IFNULL(GROUP_CONCAT(DISTINCT f.BookingId),-1) AS fundRequestBookingId, IFNULL(GROUP_CONCAT(DISTINCT f.CommitmentPayIds),-1) AS fundRequestPayId
		    FROM fund_approval f WHERE f.FinYear=inFinYear
		)
		
		# commitment
		SELECT fa.FundApprovalId,fa.SerialNo,fa.EstimateType,fa.DivisionId,fa.FinYear,fa.ProjectId,fa.BudgetHeadId,fa.BudgetItemId,fa.ItemNomenclature,
		fa.RequisitionDate,fa.Justification,fa.FundRequestAmount,
		GREATEST(COALESCE(fa.FundRequestAmount - (SELECT SUM(b.EstimatedCost) FROM tblbooking b WHERE b.FbeSubId = fa.FundApprovalId AND b.FundRequestType='R' AND b.DemandFlag NOT IN ('N','C')), fa.FundRequestAmount),0) AS ItemBalance,
		fa.InitiatingOfficer,e.EmpName,ed.Designation,
		b.BookingId,b.DemandNo,b.DeliveryMonth,IFNULL(b.EstimatedCost,0) AS EstimatedCost,
		GREATEST((
		CASE WHEN b.DemandFlag='Y' THEN 
		     # Supply Order Expenditure Deduction
		     IFNULL((b.EstimatedCost - IFNULL((SELECT SUM(IFNULL(cm.TotalCost,0)) FROM tblcommitment cm WHERE cm.DemandNo=b.DemandNo AND cm.IsCancel<>'Y' AND cm.ControlDate <= inAsOnDate),0)),0)
		     
		     WHEN b.DemandFlag='M' THEN 
		     # Direct Bill Expenditure and Imprest Expenditure Deduction
		     IFNULL((b.EstimatedCost - (IFNULL((SELECT SUM(IFNULL(p.Amount,0)) FROM tblpayment p LEFT JOIN tblpaymentcheque c ON c.PaymentId=p.PaymentId WHERE p.DemandNo=b.DemandNo AND p.BillFlag <> 'R' AND 
		     (CASE WHEN inLabCode IN ('LRDE', 'ADE') THEN p.CreatedDate <= inAsOnDate ELSE (CASE WHEN (c.PaymentId IS NOT NULL AND c.PaymentId <> '0') THEN c.ChequeSlipDate <= inAsOnDate ELSE p.UbDate <= inAsOnDate END) END) AND p.Category='D'),0) + 
		     IFNULL((IFNULL((SELECT SUM(IFNULL(BookedCost,0)) FROM imprest_booking WHERE DemandNo = b.DemandNo AND IsActive='1' AND BookingDate <= inAsOnDate), 0) - 
		     IFNULL((SELECT SUM(IFNULL(ib.BookedCost,0) - IFNULL((SELECT SUM(IFNULL(SettlementAmount,0)) FROM imprest_settlement WHERE FIND_IN_SET(ib.ImprestBookingId,ImprestBookingId)),ib.BookedCost))
		     FROM imprest_booking ib WHERE ib.DemandNo = b.DemandNo AND ib.IsActive='1' AND ib.BookingDate <= inAsOnDate),0)),0))),0)
		     
		     # New Demand
		     ELSE IFNULL(b.EstimatedCost,0) END
		
		),0) AS DIPL,c.CommitmentId,c.FileNo,c.SoNo,c.SoDate,c.DpDate,c.TotalCost AS SoCost,
		IFNULL((CASE WHEN c.CommitmentFlag='M' THEN cr.TotalCost ELSE c.TotalCost END),0) - 
		IFNULL((SELECT SUM(IFNULL(PA.Amount,0)) FROM tblpayment PA WHERE (CASE WHEN c.CommitmentFlag='M' THEN PA.CommitmentId=cr.CommitmentId ELSE PA.CommitmentId=c.CommitmentId END) AND PA.BillFlag<>'R' AND PA.BillFlag='A' AND PA.Category IN ('C') AND (CASE WHEN inLabCode IN ('ADE','LRDE','CASDIC') THEN PA.CreatedDate ELSE PA.UbDate END) <= inAsOnDate GROUP BY PA.CommitmentId),0) AS OutCost,
		cp.CommitmentPayId,IFNULL(cp.PayAmount,0) AS PayAmount,cp.PayDate,
		cp.PayFlag,'C' AS ItemStatus,NULL AS DemandItem,c.ItemFor AS SupplyOrderItem,1 AS SerialNoOrder,b.FileNo AS demandFileNo,c.FileNo AS soFileNo, NULL AS DemandDate
		FROM tblcommitment c
		INNER JOIN tblcommitmentpay cp ON cp.ControlNo=c.ControlNo AND cp.PayFlag='N' AND cp.PayDate <= actionDate
		INNER JOIN tblbooking b ON b.DemandNo=c.DemandNo AND b.FundRequestType = 'R' -- R - Fund Approval
		LEFT JOIN fund_approval fa ON fa.FundApprovalId=b.FbeSubId
		LEFT JOIN employee_view e ON e.EmpNo=c.OfficerCode
		LEFT JOIN employee_desig_view ed ON ed.DesigId=e.DesigId
		LEFT JOIN tblcommitmentrev cr ON cr.CommitmentId=c.CommitmentId AND cr.RevisionNo IN (SELECT MAX(cpr.RevisionNo) FROM tblcommitmentrev cpr WHERE cpr.CommitmentId=c.CommitmentId)
		LEFT JOIN division_master_view d ON d.DivisionId=inDivisionId AND d.DivisionCode=c.DivisionCode
		WHERE d.DivisionId=inDivisionId AND c.ProjectId='0'
		AND (CASE WHEN '-1'=inBudgetHeadId THEN 1=1 ELSE c.BudgetHeadId=inBudgetHeadId END) AND (CASE WHEN '-1'=inBudgetItemId THEN 1=1 ELSE c.BudgetItemId=inBudgetItemId END)
		AND NOT FIND_IN_SET(cp.CommitmentPayId,IFNULL((SELECT cfa.fundRequestPayId FROM currentYearFundRequestDetails cfa),'-1')) AND c.SoDate <= actionDate

	        ORDER BY SerialNoOrder,CommitmentId;
	
	END IF;

END$$

DELIMITER ;
DELIMITER $$

DROP PROCEDURE IF EXISTS `Ibas_Fund_Master_Flow_Details`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ibas_Fund_Master_Flow_Details`(IN inFundRequestId BIGINT)
BEGIN
    DECLARE totalFundCost DECIMAL(17,2) DEFAULT 0;

    -- fetch totalFundCost from fund_approval table
    SELECT (IFNULL(Apr,0) + IFNULL(May,0) + IFNULL(Jun,0) + IFNULL(Jul,0) + IFNULL(Aug,0) + IFNULL(Sep,0) + IFNULL(OCT,0) + IFNULL(Nov,0) + IFNULL(December,0) + IFNULL(Jan,0) + IFNULL(Feb,0) + IFNULL(Mar,0)) INTO totalFundCost FROM fund_approval WHERE FundApprovalId = inFundRequestId LIMIT 1;

    WITH RECURSIVE Numbers AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM Numbers WHERE n <= 20  -- adjust upper limit if needed when committee member more than 20
    ),
    
    all_employee AS (
      SELECT e.EmpId,e.EmpNo,e.EmpName,e.DesigId,ed.Designation,e.DivisionId,d.DivisionCode,d.DivisionShortName,d.DivisionName
      FROM employee_view e
      LEFT JOIN employee_desig_view ed ON ed.DesigId = e.DesigId
      LEFT JOIN division_master_view d ON d.DivisionId=e.DivisionId
      WHERE e.IsActive = '1'
      ),
     members_linked AS (
        SELECT fml.MemberLinkedId, fml.FundApprovalId, fml.EmpId, fml.MemberType, fml.IsApproved, fml.FlowMasterId, fml.IsSkipped, fml.SkipReason,
        (CASE WHEN fml.SkipReason = 'T' THEN 'TD' WHEN fml.SkipReason = 'L' THEN 'Leave' END) AS SkipReasonDetails
        FROM ibas_fund_members_linked fml 
        WHERE fml.FundApprovalId = inFundRequestId AND fml.IsActive = '1'
    ),

	fund_transaction AS (
	SELECT trans.FundApprovalTransId, trans.FundApprovalId, trans.MemberLinkedId, trans.FlowDetailsId,
	trans.Remarks, trans.ActionBy, trans.ActionDate FROM 
	ibas_fund_approval_trans trans
	INNER JOIN members_linked fml ON fml.MemberLinkedId = trans.MemberLinkedId
	INNER JOIN fund_approval f ON f.FundApprovalId = fml.FundApprovalId
	INNER JOIN ibas_flow_details fd ON fd.FlowDetailsId = trans.FlowDetailsId AND fd.StatusType = 'A'
	WHERE f.FundApprovalId = inFundRequestId
	),
	
    flow_master AS (
        SELECT ifm.FlowMasterId, ifm.MemberCount, ifm.SubjectExpertCount
        FROM ibas_flow_master ifm
        WHERE ifm.IsActive = 1 AND totalFundCost >= ifm.StartCost AND (ifm.EndCost = -1 OR totalFundCost <= ifm.EndCost)
    ),
    DH AS (
        SELECT DISTINCT b.FlowMasterId, 'DH' AS MemberType, 'Division Head' AS MemberName, 'For Recommendation' AS MemberAction, 'divisionHeadDetails' AS idAttribute, 'divisionHeadDetails' AS nameAttribute, ml.MemberLinkedId, ml.EmpId, ml.IsApproved, ml.IsSkipped, ml.SkipReason, ml.SkipReasonDetails
        FROM flow_master b
        LEFT JOIN members_linked ml ON ml.MemberType = 'DH' AND ml.FlowMasterId = b.FlowMasterId
    ),
    CM AS (

    SELECT b.FlowMasterId, 'CM' AS MemberType, 'RPB Member' AS MemberName,'For Recommendation' AS MemberAction,CONCAT('RPBMemberDetails-', ROW_NUMBER() OVER (PARTITION BY b.FlowMasterId ORDER BY ml.MemberLinkedId)) AS idAttribute, 'RPBMemberDetails' AS nameAttribute, ml.MemberLinkedId, ml.EmpId, ml.IsApproved, ml.IsSkipped, ml.SkipReason, ml.SkipReasonDetails
    FROM flow_master b
    LEFT JOIN members_linked ml ON ml.MemberType = 'CM' AND ml.FlowMasterId = b.FlowMasterId 
    LEFT JOIN Numbers n ON n.n <= b.MemberCount AND ml.MemberLinkedId IS NULL WHERE b.MemberCount <> -1 AND (CASE WHEN b.FlowMasterId >'1' THEN 1=1 ELSE 1 <> 1 END)

    UNION ALL

    SELECT b.FlowMasterId, 'CM' AS MemberType, 'RPB Member' AS MemberName,'For Recommendation' AS MemberAction,CONCAT('RPBMemberDetails-', ROW_NUMBER() OVER (PARTITION BY b.FlowMasterId ORDER BY ml.MemberLinkedId)) AS idAttribute, 'RPBMemberDetails' AS nameAttribute,
           ml.MemberLinkedId, ml.EmpId, ml.IsApproved, ml.IsSkipped, ml.SkipReason, ml.SkipReasonDetails
    FROM ibas_committee_members c
    JOIN flow_master b ON b.MemberCount = -1
    LEFT JOIN members_linked ml ON ml.MemberType = 'CM' AND ml.FlowMasterId = b.FlowMasterId AND ml.EmpId = c.EmpId WHERE c.MemberType = 'CM'
   ),
    SE AS (
        SELECT DISTINCT b.FlowMasterId, 'SE' AS MemberType, 'Subject Expert' AS MemberName, 'For Recommendation' AS MemberAction,CONCAT('SubjectExpertDetails-', ROW_NUMBER() OVER (PARTITION BY b.FlowMasterId ORDER BY ml.MemberLinkedId)) AS idAttribute, 'SubjectExpertDetails' AS nameAttribute, ml.MemberLinkedId, ml.EmpId, ml.IsApproved, ml.IsSkipped, ml.SkipReason, ml.SkipReasonDetails
        FROM flow_master b
        LEFT JOIN members_linked ml ON ml.MemberType = 'SE' AND ml.FlowMasterId = b.FlowMasterId
        LEFT JOIN Numbers n ON n.n <= b.SubjectExpertCount AND ml.MemberLinkedId IS NULL WHERE b.SubjectExpertCount <> -1 AND (CASE WHEN b.FlowMasterId >'1' THEN 1=1 ELSE 1 <> 1 END)
    ),
    CS AS (
        SELECT DISTINCT b.FlowMasterId, 'CS' AS MemberType, 'RPB Member Secretary' AS MemberName, 'For Noting' AS MemberAction, 'MemberSecretaryDetails' AS idAttribute, 'MemberSecretaryDetails' AS nameAttribute, ml.MemberLinkedId, ml.EmpId, ml.IsApproved, ml.IsSkipped, ml.SkipReason, ml.SkipReasonDetails
        FROM flow_master b
        LEFT JOIN members_linked ml ON ml.MemberType = 'CS' AND ml.FlowMasterId = b.FlowMasterId
    ),
    CC AS (
        SELECT DISTINCT b.FlowMasterId, 'CC' AS MemberType, 'RPB Chairman' AS MemberName, 'For Approval' AS MemberAction, 'chairmanDetails' AS idAttribute, 'chairmanDetails' AS nameAttribute, ml.MemberLinkedId, ml.EmpId, ml.IsApproved, ml.IsSkipped, ml.SkipReason, ml.SkipReasonDetails
        FROM flow_master b
        LEFT JOIN members_linked ml ON ml.MemberType = 'CC' AND ml.FlowMasterId = b.FlowMasterId
    )
    
    SELECT DISTINCT fund_flow_details.FlowMasterId, fund_flow_details.MemberType, fund_flow_details.MemberName, fund_flow_details.EmpId, fund_flow_details.IsApproved, 
    fund_flow_details.MemberLinkedId, e.EmpName, e.Designation, ftn.Remarks, fund_flow_details.MemberAction, fund_flow_details.idAttribute, fund_flow_details.nameAttribute, fund_flow_details.IsSkipped, 
    fund_flow_details.SkipReason, fund_flow_details.SkipReasonDetails, DATE_FORMAT(ftn.ActionDate, '%b %e, %Y, %l:%i:%s %p') AS approvedDate
    FROM (
        SELECT DH.FlowMasterId, DH.MemberType, DH.MemberName, DH.EmpId, DH.IsApproved, DH.MemberLinkedId, DH.MemberAction, DH.idAttribute, DH.nameAttribute, DH.IsSkipped, DH.SkipReason, DH.SkipReasonDetails FROM DH
        UNION ALL
        SELECT CM.FlowMasterId, CM.MemberType, CM.MemberName, CM.EmpId, CM.IsApproved, CM.MemberLinkedId, CM.MemberAction, CM.idAttribute, CM.nameAttribute, CM.IsSkipped, CM.SkipReason, CM.SkipReasonDetails FROM CM
        UNION ALL
        SELECT SE.FlowMasterId, SE.MemberType, SE.MemberName, SE.EmpId, SE.IsApproved, SE.MemberLinkedId, SE.MemberAction, SE.idAttribute, SE.nameAttribute, SE.IsSkipped, SE.SkipReason, SE.SkipReasonDetails FROM SE
        UNION ALL
        SELECT CS.FlowMasterId, CS.MemberType, CS.MemberName, CS.EmpId, CS.IsApproved, CS.MemberLinkedId, CS.MemberAction, CS.idAttribute, CS.nameAttribute, CS.IsSkipped, CS.SkipReason, CS.SkipReasonDetails FROM CS
        UNION ALL
        SELECT CC.FlowMasterId, CC.MemberType, CC.MemberName, CC.EmpId, CC.IsApproved, CC.MemberLinkedId, CC.MemberAction, CC.idAttribute, CC.nameAttribute, CC.IsSkipped, CC.SkipReason, CC.SkipReasonDetails FROM CC
    ) AS fund_flow_details
    LEFT JOIN all_employee e ON e.EmpId = fund_flow_details.EmpId
    LEFT JOIN fund_transaction ftn ON ftn.MemberLinkedId = fund_flow_details.MemberLinkedId;

END$$

DELIMITER ;


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
	SUBSTRING_INDEX(SUBSTRING_INDEX(cml.RcIsApproved, ',', FIND_IN_SET(InEmpId, cml.RcEmpIds)),',',-1) = 'Y' END);

END$$

DELIMITER ;
DELIMITER $$

DROP PROCEDURE IF EXISTS `Ibas_ParticularFundRequestDetails`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ibas_ParticularFundRequestDetails`(IN InFundApprovalId BIGINT,IN InEmpId BIGINT)
BEGIN

	      WITH 
	    all_employee AS (
	      SELECT e.EmpId, e.EmpNo, e.EmpName, e.DesigId, ed.Designation, e.DivisionId, d.DivisionCode, d.DivisionShortName, d.DivisionName
	      FROM employee_view e
	      LEFT JOIN employee_desig_view ed ON ed.DesigId = e.DesigId
	      LEFT JOIN division_master_view d ON d.DivisionId = e.DivisionId
	      WHERE e.IsActive = '1'
	    ),
	    
	    LinkedMembersStatus AS (
	      SELECT ml.FundApprovalId, GROUP_CONCAT(ml.EmpId ORDER BY ml.MemberLinkedId) AS RcEmpIds, GROUP_CONCAT(ml.MemberType ORDER BY ml.MemberLinkedId) AS RcMemberTypes, GROUP_CONCAT(ml.IsApproved ORDER BY ml.MemberLinkedId) AS RcIsApproved, GROUP_CONCAT(ml.IsSkipped ORDER BY ml.MemberLinkedId) AS IsSkippeds, GROUP_CONCAT(ml.SkipReason ORDER BY ml.MemberLinkedId) AS SkipReasons, GROUP_CONCAT(ml.MemberLinkedId ORDER BY ml.MemberLinkedId) AS MemberLinkedIds
	      FROM ibas_fund_members_linked ml
	      INNER JOIN fund_approval fa ON fa.FundApprovalId = ml.FundApprovalId AND fa.FundApprovalId = InFundApprovalId
	      GROUP BY FundApprovalId
	      ),
	    
	    fund_transaction AS (
		SELECT trans.FundApprovalTransId, trans.FundApprovalId, trans.MemberLinkedId, trans.FlowDetailsId,
		trans.Remarks, trans.ActionBy, trans.ActionDate FROM 
		ibas_fund_approval_trans trans
		INNER JOIN ibas_fund_members_linked fml ON fml.MemberLinkedId = trans.MemberLinkedId
		INNER JOIN fund_approval f ON f.FundApprovalId = fml.FundApprovalId
		INNER JOIN ibas_flow_details fd ON fd.FlowDetailsId = trans.FlowDetailsId AND fd.StatusType = 'A'
		WHERE f.FundApprovalId = InFundApprovalId
		),
	    
	    LinkedMembersEmployeeDetails AS (
	      SELECT lmd.FundApprovalId,GROUP_CONCAT(CONCAT(e.EmpName,', ',e.Designation) ORDER BY FIND_IN_SET(e.EmpId, lmd.RcEmpIds) SEPARATOR '###') AS RcEmpDetails, 
	      GROUP_CONCAT(COALESCE(ft.Remarks, 'NA') ORDER BY FIND_IN_SET(e.EmpId, lmd.RcEmpIds) SEPARATOR '###') AS RcRemarks,
	      GROUP_CONCAT(COALESCE(DATE_FORMAT(ft.ActionDate, '%b %e, %Y, %l:%i:%s %p'), 'NA') ORDER BY FIND_IN_SET(e.EmpId, lmd.RcEmpIds) SEPARATOR '###') AS ActionDate
	      FROM LinkedMembersStatus lmd
	      LEFT JOIN all_employee e ON FIND_IN_SET(e.EmpId,lmd.RcEmpIds)
	      LEFT JOIN fund_transaction ft ON ft.ActionBy = e.EmpId
	      GROUP BY FundApprovalId
	      )
	     
 
 
	SELECT f.FundApprovalId, f.EstimateType, f.FinYear, f.REFBEYear, f.ProjectId, f.BudgetHeadId, f.BudgetItemId, f.RequisitionDate, 
	bh.BudgetHeadDescription,bi.HeadOfAccounts,bi.SubHead,f.DivisionId,dm.DivisionCode,dm.DivisionName,f.ItemNomenclature,f.Justification,
	f.RequisitionDate,(IFNULL(Apr,0) + IFNULL(May,0) + IFNULL(Jun,0) + IFNULL(Jul,0) + IFNULL(Aug,0) + IFNULL(Sep,0) + IFNULL(OCT,0) + IFNULL(Nov,0) + IFNULL(December,0) + IFNULL(Jan,0) + IFNULL(Feb,0) + IFNULL(Mar,0)) AS ItemCost,
	f.InitiatingOfficer,
	CONCAT(iof.EmpName, ', ', iof.Designation) AS InitiatingOfficerName, f.Status, cml.RcMemberTypes, cml.RcEmpIds, cml.RcIsApproved, lmed.RcEmpDetails, lmed.RcRemarks, f.ReturnedBy, 
	DATE_FORMAT(f.ReturnedDate, '%d-%m-%Y') AS ReturnedDate, cml.IsSkippeds, cml.MemberLinkedIds, lmed.ActionDate, DATE_FORMAT(f.RequisitionDate, '%b %e, %Y') AS RequisitionDateformated, cml.SkipReasons
	
	FROM fund_approval f
	LEFT JOIN tblbudgethead bh ON bh.BudgetHeadId = f.BudgetHeadId 
	LEFT JOIN tblbudgetitem bi ON bi.BudgetItemId=f.BudgetItemId
	LEFT JOIN division_master_view dm ON dm.DivisionId = f.DivisionId 
	LEFT JOIN LinkedMembersStatus cml ON cml.FundApprovalId=f.FundApprovalId
	LEFT JOIN all_employee iof  ON iof.EmpId = f.InitiatingOfficer
	LEFT JOIN LinkedMembersEmployeeDetails lmed ON lmed.FundApprovalId = f.FundApprovalId

	WHERE f.FundApprovalId=InFundApprovalId;

END$$

DELIMITER ;


