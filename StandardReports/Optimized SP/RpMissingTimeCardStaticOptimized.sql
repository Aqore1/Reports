SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- =============================================        
-- Author:  <Pratigya.Thapa>        
-- Create date: <04/25/2020>        
-- Description: This Sp will display the missing time card data for those active assignment that is not in transactionbatch   (transactionId may or may not be created 
--if created, transactionbatchid should be null)   

--modified by: Bishal Basyal (7/17/2021): excluded assignments if StartDate is same as selected AP date: ticket #29168 [section A]

--EXEC dbo.SpSessionContextTsk @Json = N'{"personId":1}'; -- nvarchar(max)        


--DECLARE @json VARCHAR (MAX) = '{"reportId":200209,"parameters":[{"reportParameterId":201919,"parameterValue":200326},{"reportParameterId":201921,"parameterValue":"200062"}]}';        


--EXEC dbo.SpStaticReportSel @Json = @json OUTPUT; -- varchar(max)        

--SELECT @json;        
-- =============================================    
--modifed by Mrijan  on 9/9/2021 to remove code to pull distinct office id from all assignment
--modified by Ashesh Bajracharya on 2/14/2022 to remove columns 'City' and 'State Code', And added 'Worksite Address'. User Story (31581)
--modified by: Bishal Basyal (02/25/2022): changed oa.AddressId to tads.AddressId : ticket #32450 [section B]
-- modified by: Ashesh Bajracharya (06/20/2022): added column 'IsDD' with reference to Userstory 33912
--- modified by : Kolaj Joshi (6/30/2022): added placed by : userstory 34057
-- modified by: Ashesh Bajracharya (7/14/2022): added column 'Charge' with reference to Userstory 34348
-- modified by: Ashesh Bajracharya (7/21/2022): corrected jod Id to job Id. Ticket(4891)
-- ===============================================
--modified by: Sasita 2/16/2023: fixed logic to remove corrected transactions as per ticket #42073
-- ===============================================

/*
 DECLARE @AutomationUserPersonId INT = dbo.SfAutomationUserPersonIdGet ();
 DECLARE @p NVARCHAR (MAX) = N' { "personId":' + CAST(@AutomationUserPersonId AS VARCHAR (MAX)) + N'}';
 EXEC dbo.SpSessionContextTsk @Json = @p
DECLARE @Json VARCHAR (MAX) = '{"reportId":200209,"parameters":[{"reportParameterId":201919,"parameterValue":200500},{"reportParameterId":201920,"parameterValue":"200003,200004,200002,200001,15604085,15635913"},{"reportParameterId":201921,"parameterValue":"200001,200002,200003,200004,200005,200006,200007,200008,200009,200010,200011,200012,200013,200014,200015,200016,200017,200018,200019,200020,200021,200022,200023,200024,200025,200026,200027,200028,200029,200030,200031,200032,200033,200034,200035,200036,200037,200038,200039,200040,200041,200042,200043,200044,200045,200046,200047,200048,200049,200050,200051,200052,200053,200054,200055,200056,200057,200058,200059,200060,200061,200062,200063,200064,200065,200066,200067,200069,200070,200071,200077,200078,200079,200080,200081,200082,200083,200084,200085,200086,200087,200088,200089,200090,200091,200092,200093,200094,200095,200096,200097,200098,200099,200100,200101,200102,200103,200104,200105,200106,200107,200108,200109,200110,200111,200112,200113,200114,201115,201116,201117,201118,202119,202120,202121,203122,203123,203124,203125,203126,203127,203128,203129,203130,203131,203132,203133,203134,203135,203136,203137,204138,204139,204140,204141,204142,204143,204144,204145,204146,204147,204148,204149,204150,204151,204152,204153,204154,204155,204156,204157,204158,204159,204160,204161,204162,204163,204164,204165,204166,204167,204168"}]}'
EXEC dbo.RpMissingTimeCardStatic @Json = @Json OUTPUT -- varchar(max)
SELECT @Json

 DECLARE @AutomationUserPersonId INT = dbo.SfAutomationUserPersonIdGet ();
 DECLARE @p NVARCHAR (MAX) = N' { "personId":' + CAST(@AutomationUserPersonId AS VARCHAR (MAX)) + N'}';
 EXEC dbo.SpSessionContextTsk @Json = @p
DECLARE @Json VARCHAR (MAX) = '{"reportId":200209,"parameters":[{"reportParameterId":201919,"parameterValue":200500},{"reportParameterId":201920,"parameterValue":"200003,200004,200002,200001,15604085,15635913"},{"reportParameterId":201921,"parameterValue":"200001,200002,200003,200004,200005,200006,200007,200008,200009,200010,200011,200012,200013,200014,200015,200016,200017,200018,200019,200020,200021,200022,200023,200024,200025,200026,200027,200028,200029,200030,200031,200032,200033,200034,200035,200036,200037,200038,200039,200040,200041,200042,200043,200044,200045,200046,200047,200048,200049,200050,200051,200052,200053,200054,200055,200056,200057,200058,200059,200060,200061,200062,200063,200064,200065,200066,200067,200069,200070,200071,200077,200078,200079,200080,200081,200082,200083,200084,200085,200086,200087,200088,200089,200090,200091,200092,200093,200094,200095,200096,200097,200098,200099,200100,200101,200102,200103,200104,200105,200106,200107,200108,200109,200110,200111,200112,200113,200114,201115,201116,201117,201118,202119,202120,202121,203122,203123,203124,203125,203126,203127,203128,203129,203130,203131,203132,203133,203134,203135,203136,203137,204138,204139,204140,204141,204142,204143,204144,204145,204146,204147,204148,204149,204150,204151,204152,204153,204154,204155,204156,204157,204158,204159,204160,204161,204162,204163,204164,204165,204166,204167,204168"}]}'
EXEC dbo.zzsam_RpMissingTimeCardStatic @Json = @Json OUTPUT -- varchar(max)
SELECT @Json
*/

ALTER PROCEDURE [dbo].[zzsam_RpMissingTimeCardStatic]
(
    @Json VARCHAR (MAX) OUTPUT )
AS
    BEGIN

        SET NOCOUNT ON;
        BEGIN TRY

            DECLARE @UserPersonId INT;

            SELECT @UserPersonId = dbo.SfPersonIdGet ();
            IF ( @UserPersonId = 0 )
                BEGIN
                    RAISERROR ('Insert person not found.', 16, 1);
                END;
            ELSE
                BEGIN
                    DECLARE @AccountingPeriodId INT;
                    DECLARE @AccountingPeriod DATE;
                    DECLARE @CompanyId VARCHAR (50);
                    DECLARE @RecruiterUserTypeListItemId INT = dbo.SfListItemIdGet ('UserType', 'Recruiter');
                    DECLARE @PlacedByTypeListItemId INT = dbo.SfListItemIdGet ('UserType', 'PlacedBy');

                    DECLARE @TimesheetTransactionBatchTypeListItemId INT = dbo.SfListItemIdGet (
                                                                               'TransactionBatchType' , 'Timesheet');
                    CREATE TABLE #ParamValue
                    (   NAME VARCHAR (50) ,
                        ParamId INT ,
                        Value VARCHAR (MAX));

                    INSERT INTO #ParamValue ( NAME ,
                                              ParamId ,
                                              Value )
                                SELECT rp.[Column] ,
                                       oj.reportParameterId ,
                                       NULLIF (ISNULL (oj.parameterValue, ''), '')
                                FROM
                                       OPENJSON (@Json, '$.parameters')
                                           WITH ( reportParameterId INT ,
                                                  parameterValue VARCHAR (MAX)) AS oj
                                       INNER JOIN dbo.ReportParameter AS rp ON rp.ReportParameterId = oj.reportParameterId;



                    SELECT @CompanyId = ISNULL (( SELECT pv.Value
                                                  FROM   #ParamValue AS pv
                                                  WHERE  pv.[NAME] = 'Company' ) ,
                                                'All');

                    DECLARE @OfficeId NVARCHAR (MAX) = ISNULL (( SELECT pv.Value
                                                                 FROM   #ParamValue AS pv
                                                                 WHERE  pv.[NAME] = 'Office' ) ,
                                                               'All');


                    SELECT @AccountingPeriodId = ( SELECT pv.Value
                                                   FROM   #ParamValue AS pv
                                                   WHERE  pv.[NAME] = 'AccountingPeriod' );

                    SELECT @AccountingPeriod = ( SELECT ap.AccountingPeriod
                                                 FROM   dbo.AccountingPeriod AS ap
                                                 WHERE  ap.AccountingPeriodId = @AccountingPeriodId );

                    DECLARE @ActiveListItemId INT = dbo.SfListItemIdGet ('Status', 'Active');
                    DECLARE @RemainingListItemId INT = dbo.SfListItemIdGet ('BankAmountType', 'Remaining');
                    DECLARE @AmountListItemId INT = dbo.SfListItemIdGet ('PercentOrAmount', 'Amount');
                    DECLARE @PercentageListItemId INT = dbo.SfListItemIdGet ('PercentOrAmount', 'Percent');

                    CREATE TABLE #Company
                    ( OrganizationId INT );


                    CREATE TABLE #Office
                    ( OfficeId INT );

                    IF ( @CompanyId = 'All' )
                        BEGIN
                            INSERT #Company ( OrganizationId )
                                   SELECT DISTINCT tpdas.OrganizationId
                                   FROM   dbo.TfPersonDataAccessSel (@UserPersonId, 1) AS tpdas;
                        END;
                    ELSE
                        BEGIN
                            INSERT #Company ( OrganizationId )
                                   SELECT DISTINCT CAST(value AS INT)
                                   FROM   STRING_SPLIT(@CompanyId, ',') AS br;

                        END;

                    IF ( @OfficeId = 'All' )
                        BEGIN
                            INSERT INTO #Office ( OfficeId )
                                        SELECT DISTINCT pda.OfficeId
                                        FROM   dbo.TfPersonDataAccessSel (@UserPersonId, 1) AS pda
                                               INNER JOIN #Company AS o ON o.OrganizationId = pda.OrganizationId;
                        END;
                    ELSE
                        BEGIN
                            INSERT INTO #Office ( OfficeId )
                                        SELECT DISTINCT CAST(value AS INT)
                                        FROM   STRING_SPLIT(@OfficeId, ',') AS br;
                        END;


                    /*For Active Assignment data fetch*/
                    /*select Office from Assignment */


                    /*Those End Reason of the assignment under the office that has "false" value for property "CreateTransaction"*/

                    DECLARE @LstEndReason TABLE
                    (   ListItemId INT ,
                        OfficeId INT );
                    INSERT INTO @LstEndReason ( ListItemId ,
                                                OfficeId )
                                SELECT DISTINCT lp.ListItemId ,
                                                a.OfficeId
                                FROM   #Office AS a
                                       CROSS APPLY dbo.TfListItemPropertySel (
                                                       a.OfficeId, 'EndReason', 'CreateTransaction', 'False') AS lp;

                    /*Select those assignment that has value true for the property "CreateTransaction (active assignment)"*/


                    CREATE TABLE #ActiveAssignment
                    ( AssignmentId INT );

                    INSERT INTO #ActiveAssignment ( AssignmentId )
                                SELECT DISTINCT a.AssignmentId
                                FROM   dbo.Assignment AS a
                                       INNER JOIN #Office AS o ON o.OfficeId = a.OfficeId
                                --WHERE  CAST(a.StartDate AS DATE) <= @AccountingPeriod  --[section A] old
                                WHERE  CAST(a.StartDate AS DATE) < @AccountingPeriod --[section A] new
                                AND    ( CAST(a.EndDate AS DATE) > DATEADD (DAY, -7, @AccountingPeriod)
                                      OR a.EndDate IS NULL )
                                AND    ISNULL (a.EndReasonListItemId, 0) NOT IN ( SELECT lp.ListItemId
                                                                                  FROM   @LstEndReason AS lp
                                                                                  WHERE  lp.OfficeId = a.OfficeId );


                    /*Assignment List that has missing Time entry*/

                    CREATE TABLE #MissingTimeCardList
                    (   Id INT IDENTITY (1, 1) ,
                        AssignmentId INT ,
                        AssignmentStatus VARCHAR (50) ,
                        Company NVARCHAR (100) ,
                        Office NVARCHAR (100) ,
                        Customer NVARCHAR (100) ,
                        PersonId INT ,
                        CandidateName NVARCHAR (4000) ,
                        Recruiter NVARCHAR (4000) ,
                        PlacedBy NVARCHAR (4000) ,
                        Department NVARCHAR (100) ,
                        JobId INT ,
                        StartDate DATE ,
                        EndDate DATE ,
                        InputDate DATE ,
                        EndReason VARCHAR (50) ,
                        Performance VARCHAR (50) ,
                        JobTitle NVARCHAR (100) ,
                        WCCode NVARCHAR (25) ,
                        WorksiteAddress NVARCHAR (500) ,
                        --  City NVARCHAR (25) ,
                        --  StateCode NVARCHAR (5) ,
                        PayRate MONEY ,
                        BillRate MONEY ,
                        LastPaidDate DATE ,
                        ShiftId INT ,
                        Shift NVARCHAR (50) ,
                        PayCycle VARCHAR (50) ,
                        PayWeek VARCHAR (25) ,
                        IsDD VARCHAR (10) -- Added by Ashesh 
                            DEFAULT 'No' ,
                        Charge NVARCHAR (500));



                    INSERT INTO #MissingTimeCardList ( AssignmentId ,
                                                       AssignmentStatus ,
                                                       Company ,
                                                       Office ,
                                                       Customer ,
                                                       PersonId ,
                                                       CandidateName ,
                                                       Department ,
                                                       JobId ,
                                                       StartDate ,
                                                       EndDate ,
                                                       EndReason ,
                                                       Performance ,
                                                       JobTitle ,
                                                       WCCode ,
                                                       WorksiteAddress ,
                                                       InputDate ,
                                                       ShiftId ,
                                                       PayCycle ,
                                                       PayWeek ,
                                                       Charge )
                                SELECT   a.AssignmentId ,
                                         li2.ListItem ,
                                         tor.Alias ,
                                         o.Office ,
                                         o2.Organization ,
                                         a.PersonId ,
                                         p2.Name ,
                                         o2.Department ,
                                         a2.JobId ,
                                         a2.StartDate ,
                                         a2.EndDate ,
                                         li3.ListItem ,
                                         li4.ListItem ,
                                         j.JobTitle ,
                                         wc.WCCode ,
                                                                               --dbo.SfFullAddressGet (a.AddressId) ,---section B
                                         dbo.SfFullAddressGet (ad.AddressId) , ---section B
                                                                               --  tads.City ,
                                                                               --  tads.StateCode ,

                                         a2.InsertDate ,
                                         a2.ShiftId ,
                                         li.ListItem ,
                                         osp.PayWeek ,
                                         c.Charge + ' : '
                                         + CASE WHEN c.PercentOrAmountListItemId = @AmountListItemId THEN
                                                    CONCAT (
                                                        '$' ,
                                                        CAST(c.Value AS VARCHAR (10)),
                                                        ' ON ' ,
                                                        dbo.SfListItemGet (c.TierBasedOnListItemId))
                                                WHEN c.PercentOrAmountListItemId = @PercentageListItemId THEN
                                                    CONCAT (
                                                        CAST(c.Value AS VARCHAR (10)) ,
                                                        '%' ,
                                                        ' ON ' ,
                                                        dbo.SfListItemGet (c.TierBasedOnListItemId))
                                           END
                                FROM     dbo.TfAssignmentSel (@UserPersonId, 0) AS a
                                         INNER JOIN #ActiveAssignment AS aa ON aa.AssignmentId = a.AssignmentId
                                         INNER JOIN dbo.Assignment AS a2 ON a2.AssignmentId = a.AssignmentId
                                         INNER JOIN dbo.ListItem AS li2 ON a2.StatusListItemId = li2.ListItemId
                                         LEFT JOIN dbo.ListItem AS li3 ON li3.ListItemId = a2.EndReasonListItemId
                                         LEFT JOIN dbo.ListItem AS li4 ON li4.ListItemId = a2.PerformanceListItemId
                                         INNER JOIN dbo.Office AS o ON o.OfficeId = a2.OfficeId
                                         INNER JOIN dbo.TenantOrganization AS tor ON tor.OrganizationId = o.OrganizationId
                                         INNER JOIN dbo.Job AS j ON j.JobId = a2.JobId
                                         INNER JOIN dbo.TempJob AS tj ON tj.JobId = j.JobId
                                         INNER JOIN dbo.WCCode AS wc ON wc.WCCodeId = tj.WCCodeId
                                         INNER JOIN dbo.OrganizationAddress AS oa ON j.OrganizationAddressId = oa.OrganizationAddressId
                                         INNER JOIN dbo.[Address] AS ad ON oa.AddressId = ad.AddressId
                                         INNER JOIN dbo.Organization AS o2 ON o2.OrganizationId = j.OrganizationId
                                         INNER JOIN dbo.Person AS p2 ON p2.PersonId = a.PersonId
                                         INNER JOIN dbo.OrganizationServiceProfile AS osp ON osp.OrganizationId = o2.OrganizationId
                                         INNER JOIN dbo.ListItem AS li ON li.ListItemId = osp.PayCycleListItemId
                                         LEFT JOIN dbo.[Transaction] AS t ON  t.AssignmentId = a.AssignmentId
                                                                          AND t.AccountingPeriodId = @AccountingPeriodId
                                         LEFT JOIN dbo.TransactionLink AS tl ON tl.TransactionId = t.TransactionId
                                         LEFT JOIN dbo.Charge AS c ON c.ChargeId = tj.ChargeId
                                         LEFT JOIN dbo.TransactionBatch AS tb ON tb.TransactionBatchId = tl.TransactionBatchId
                                WHERE    tl.TransactionBatchId IS NULL
                                AND      ISNULL (tb.TransactionBatchTypeListItemId, 0) IN ( 0 ,
                                                                                            @TimesheetTransactionBatchTypeListItemId ) --sasita
                                ORDER BY o.Office ,
                                         o2.Organization ,
                                         p2.Name;



                    /*update for Shift*/

                    --SELECT *
                    UPDATE mtcl
                    SET    mtcl.Recruiter = p.Name
                    FROM   #MissingTimeCardList AS mtcl
                           INNER JOIN dbo.PersonUserType AS put ON  put.PersonId = mtcl.PersonId
                                                                AND put.UserTypeListItemId = @RecruiterUserTypeListItemId
                           INNER JOIN dbo.Person AS p ON p.PersonId = put.UserTypePersonId;

                    UPDATE mtcl
                    SET    mtcl.PlacedBy = p3.Name
                    FROM   #MissingTimeCardList AS mtcl
                           INNER JOIN dbo.AssignmentUserType AS aut ON  aut.AssignmentId = mtcl.AssignmentId
                                                                    AND aut.UserTypeListItemId = @PlacedByTypeListItemId
                           INNER JOIN dbo.Person AS p3 ON p3.PersonId = aut.UserTypePersonId;



                    UPDATE mtcl
                    SET    mtcl.PayRate = ISNULL (ra.PayRate, 0) ,
                           mtcl.BillRate = ISNULL (ra.BillRate, 0)
                    FROM   #MissingTimeCardList AS mtcl
                           INNER JOIN ( SELECT   MAX (ar.PayRate) PayRate ,
                                                 MAX (ar.BillRate) BillRate ,
                                                 ar.AssignmentId
                                        FROM     dbo.AssignmentRate AS ar
                                                 INNER JOIN dbo.TransactionCode AS tc ON tc.TransactionCodeId = ar.TransactionCodeId
                                        WHERE    tc.TransactionCode IN ( 'RT', 'Salary' )
                                        GROUP BY ar.AssignmentId ) ra ON ra.AssignmentId = mtcl.AssignmentId;


                    UPDATE mtc
                    SET    mtc.Shift = s.Shift
                    FROM   #MissingTimeCardList AS mtc
                           LEFT JOIN dbo.Shift AS s ON s.ShiftId = mtc.ShiftId;

                    /*update for lastPaidDate*/
                    UPDATE mtc
                    SET    mtc.LastPaidDate = lpd.LastPaidDate
                    FROM   #MissingTimeCardList AS mtc
                           INNER JOIN ( SELECT   MAX (pb.CheckDate) AS LastPaidDate ,
                                                 p.PersonId
                                        FROM     dbo.Payment AS p
                                                 INNER JOIN dbo.PaymentBatch AS pb ON pb.PaymentBatchId = p.PaymentBatchId
                                                 INNER JOIN #MissingTimeCardList AS mtcl ON mtcl.PersonId = p.PersonId
                                        GROUP BY p.PersonId ) AS lpd ON lpd.PersonId = mtc.PersonId;

                                                 /*update for DirectDeposit*/ -- added by Ashesh
                    UPDATE mtc
                    SET    mtc.IsDD = 'Yes'
                    FROM   #MissingTimeCardList AS mtc
                    WHERE  EXISTS ( SELECT TOP 1 1
                                    FROM   dbo.PersonBankAccount AS pba
                                    WHERE  pba.StatusListItemId = @ActiveListItemId
                                    AND    pba.AmountTypeListItemId = @RemainingListItemId
                                    AND    pba.PersonId = mtc.PersonId );

								--	SELECT * FROM  #MissingTimeCardList AS mtcl

                    SELECT @Json = ISNULL (( SELECT al.Company [Company] ,
                                                    al.Office [Office] ,
                                                    al.WorksiteAddress [Worksite Address] ,
                                                                              --  al.City [City] ,
                                                                              -- al.StateCode [State Code] ,
                                                    al.Customer [Customer] ,
                                                    al.Department [Department] ,
                                                    al.PersonId [Person Id] ,
                                                    al.CandidateName [Person] ,
                                                    al.Recruiter [Recruiter] ,
                                                    al.PlacedBy [Placed By] , -- sec AA
                                                    al.AssignmentStatus [Assignment Status] ,
                                                    al.JobTitle [Job Title] ,
                                                    al.Shift [Shift] ,
                                                    al.EndReason [End Reason] ,
                                                    al.Performance [Performance] ,
                                                    al.WCCode [WC Code] ,
                                                    al.PayRate [Pay Rate] ,
                                                    al.BillRate [Bill Rate] ,
                                                    al.Charge ,
                                                    CONVERT (VARCHAR (10), al.InputDate, 101) AS [Input Date] ,
                                                    CONVERT (VARCHAR (10), al.StartDate, 101) AS [Start Date] ,
                                                    CONVERT (VARCHAR (10), al.EndDate, 101) AS [End Date] ,
                                                    CONVERT (VARCHAR (10), al.LastPaidDate, 101) AS [Last Paid Date] ,
                                                    al.AssignmentId AS [Assignment Id] ,
                                                    al.JobId AS [Job Id] ,
                                                    al.PayCycle [Pay Cycle] ,
                                                    al.PayWeek [Pay Week] ,
                                                    al.IsDD [Is DD]
                                             FROM   #MissingTimeCardList AS al
                                           FOR JSON PATH, INCLUDE_NULL_VALUES ) ,
                                           '[]');


                    DROP TABLE #MissingTimeCardList;
                    DROP TABLE #Company;
                    DROP TABLE #Office;
                    DROP TABLE #ParamValue;
                    DROP TABLE #ActiveAssignment;
                END;

        END TRY
        BEGIN CATCH


            THROW;

        END CATCH;

    END;

GO

