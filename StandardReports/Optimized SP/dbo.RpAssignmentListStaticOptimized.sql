SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
-- Stored Procedure

-- Stored Procedure

-- Stored Procedure

-- =============================================        
-- Author:  <Pratigya.Thapa>        
-- Create date: <02/04/2020>        
-- Description: This Sp will show Assignment Detail data        
/*      
EXEC dbo.SpSessionContextTsk @Json = N'{"personId":2000000}' -- nvarchar(max)        
EXEC dbo.SpSessionContextTsk @Json = N'{"personId":2000000}'; -- nvarchar(max)        

DECLARE @json VARCHAR (MAX) = '{"reportId":200837,"parameters":[{"reportParameterId":213763,"parameterValue":"1/1/2020,2/4/2020"},{"reportParameterId":213765,"parameterValue":"198,207249,207250,207251"},{"reportParameterId":213766,"parameterValue":null}  


,{"reportParameterId":213767,"parameterValue":NULL}]}';        


EXEC dbo.SpStaticReportSel @Json = @json OUTPUT; -- varchar(max)        

SELECT @json;        
*/

--modified by : Samiksha Poudel
--modified date: 09/07/2021
--description: changed inner join to left join on contactinformation table

-- =============================================     
--Modify By: Pratigya Thapa
--Modifiaction Date: 3/2/2022
--Modification: Resource Issue for Worksite State, Worksite City and Entered By, Bug:31961
-- =============================================     

-- =============================================     
--modified by : Samiksha
--modified date : 3/4/2022
--description: added Ended assignment in logic and Placed By Column (Ticket 32437 )
---================================================

/*
Modified by : Sudeep Shrestha
Modified Date : 05/04/2022
Description : Duplicate ReportParameterId handled through ReportParameterName
*/
-- ============================================= 
--Modified by : Ashesh Bajracharya
--Modified Date : 05/04/2022
--Description : Duplicate ReportParameterId handled through ReportParameterName    
-- =============================================   
-- =============================================     
--modified by : Samiksha
--modified date : 6/30/2922
--description: deleted assignments with no end reason if specific end reasons are selected
---================================================
-- =============================================     
--modified by : Ashesh Bajracharya
--modified date : 7/1/2022
--description: added columns 'FirstName', 'LastName', 'PO#', 'Extra1-Extra4' Ticket (4597)
---================================================
-- =============================================     
--modified by : Ashesh Bajracharya
--modified date : 7/14/2022
--description: added columns 'Charge' with reference to Userstory 34348
---================================================

-- ===================================================================
-- Modified By : Abhishek KC
-- Modified On : 9/8/2022
-- Description : Left join is null clause from from ON clause to WHERE Clause
-- Ticket	   : https://aqore.freshdesk.com/a/tickets/37370
-- ===================================================================

-- Modified By mrijan on 10/16/2022 to pull GP columns from table
--modified by: sasita 11/7/2022 added logic to pull shift from job as per USER STORY 35976 v.22.11
--Approved by: Sunil Nepali on 11/10/2022
---================================================
-------=============================================================
--modified by Samiksha on 12/22/2022 --pulled RTpayrate, rtbillrate,otpayrate,otbillrate,dtpayrate and dtbillrate (Ticket 6953) and changed existing Payrate and bill rate to salary payrate and salary bill rate: User story :39111
--Approved by: Sunil Nepali on 12/22/2022
------------================================================

ALTER PROCEDURE [dbo].[RpAssignmentListStatic]
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
                    RAISERROR ('INSERT Person NOT FOUND.', 16, 1);
                END;
            ELSE
                BEGIN
                    DECLARE @AssignmentDate NVARCHAR (25) ,
                            @StartDate DATE ,
                            @EndDate DATE ,
                            @Person NVARCHAR (4000) ,
                            @Customer NVARCHAR (100);


                    CREATE TABLE #ParamValue
                    (   NAME VARCHAR (50) ,
                        ParamId INT ,
                        Value VARCHAR (MAX) ,
                        reportParameterName VARCHAR (100));

                    INSERT INTO #ParamValue ( NAME ,
                                              ParamId ,
                                              Value ,
                                              reportParameterName )
                                SELECT rp.[Column] ,
                                       oj.reportParameterId ,
                                       NULLIF (ISNULL (oj.parameterValue, ''), '') ,
                                       oj.reportParameterName
                                FROM
                                       OPENJSON (@Json, '$.parameters')
                                           WITH ( reportParameterId INT ,
                                                  parameterValue VARCHAR (MAX) ,
                                                  reportParameterName VARCHAR (100)) AS oj
                                       INNER JOIN dbo.ReportParameter AS rp ON rp.ReportParameterId = oj.reportParameterId;

                    --SELECT *
                    --FROM   #ParamValue AS pv;



                    DECLARE @CompanyId NVARCHAR (MAX);
                    SELECT @CompanyId = ISNULL (( SELECT pv.Value
                                                  FROM   #ParamValue AS pv
                                                  WHERE  pv.[NAME] = 'Company'
                                                  AND    pv.Value IS NOT NULL ) ,
                                                'ALL');

                    DECLARE @OfficeId NVARCHAR (MAX) = ISNULL (( SELECT pv.Value
                                                                 FROM   #ParamValue AS pv
                                                                 WHERE  pv.[NAME] = 'Office'
                                                                 AND    pv.Value IS NOT NULL ) ,
                                                               'ALL');


                    --SELECT @AssignmentDate = ( SELECT pv.Value
                    --                           FROM   #ParamValue AS pv
                    --                           WHERE  pv.[NAME] = 'AssignmentDate' );

                    SELECT @StartDate = ( SELECT pv.Value
                                          FROM   #ParamValue AS pv
                                          WHERE  pv.reportParameterName = 'AssignmentDateFrom' );

                    SELECT @EndDate = ( SELECT pv.Value
                                        FROM   #ParamValue AS pv
                                        WHERE  pv.reportParameterName = 'AssignmentDateTo' );

                    DECLARE @EndReason NVARCHAR (MAX) = ISNULL (( SELECT pv.Value
                                                                  FROM   #ParamValue AS pv
                                                                  WHERE  pv.NAME = 'EndReason'
                                                                  AND    pv.Value IS NOT NULL ) ,
                                                                'All');

                    --CREATE TABLE #AssignmentDate
                    --(   id INT IDENTITY (1, 1) ,
                    --    assignmentDate DATE );

                    --INSERT INTO #AssignmentDate ( assignmentDate )
                    --            SELECT a.value
                    --            FROM   STRING_SPLIT(@AssignmentDate, ',') AS a;

                    --SELECT @StartDate = ad.assignmentDate
                    --FROM   #AssignmentDate AS ad
                    --WHERE  ad.id = 1;

                    --SELECT @EndDate = ad.assignmentDate
                    --FROM   #AssignmentDate AS ad
                    --WHERE  ad.id = 2;






                    SELECT @Person = ISNULL (( SELECT pv.Value
                                               FROM   #ParamValue AS pv
                                               WHERE  pv.NAME = 'Person' ) ,
                                             '%');

                    SELECT @Customer = ISNULL (( SELECT pv.Value
                                                 FROM   #ParamValue AS pv
                                                 WHERE  pv.NAME = 'Customer' ) ,
                                               '%');

                    DECLARE @returnType VARCHAR (100);
                    SELECT @returnType = ( SELECT pv.Value
                                           FROM   #ParamValue AS pv
                                           WHERE  pv.NAME = 'ReturnType' );



                    CREATE TABLE #Company
                    ( OrganizationId INT );
                    CREATE TABLE #Office
                    ( OfficeId INT );

                    IF ( @CompanyId = 'ALL' )
                        BEGIN
                            INSERT #Company ( OrganizationId )
                                   SELECT DISTINCT tpdas.OrganizationId
                                   FROM   dbo.TfPersonDataAccessSel (@UserPersonId, 1) AS tpdas;
                        END;
                    ELSE
                        BEGIN
                            INSERT #Company ( OrganizationId )
                                   SELECT CAST(value AS INT)
                                   FROM   STRING_SPLIT(@CompanyId, ',') AS br;

                        END;

                    IF ( @OfficeId = 'ALL' )
                        BEGIN
                            INSERT INTO #Office ( OfficeId )
                                        SELECT DISTINCT pda.OfficeId
                                        FROM   dbo.TfPersonDataAccessSel (@UserPersonId, 1) AS pda
                                               INNER JOIN #Company AS o ON o.OrganizationId = pda.OrganizationId;
                        END;
                    ELSE
                        BEGIN
                            INSERT INTO #Office ( OfficeId )
                                        SELECT CAST(value AS INT)
                                        FROM   STRING_SPLIT(@OfficeId, ',') AS br;
                        END;


                    CREATE TABLE #EndReason --modified by Samiksha
                    ( EndReasonListItemId INT );
                    IF ( @EndReason = 'All' )
                        BEGIN
                            INSERT #EndReason ( EndReasonListItemId )
                                   SELECT li.ListItemId
                                   FROM   dbo.ListItem AS li
                                          INNER JOIN dbo.ListItemCategory AS lic ON lic.ListItemCategoryId = li.ListItemCategoryId
                                   WHERE  lic.Category = 'EndReason';

                        END;

                    ELSE
                        BEGIN
                            INSERT #EndReason ( EndReasonListItemId )
                                   SELECT CAST(value AS INT)
                                   FROM   STRING_SPLIT(@EndReason, ',') AS br;

                        END;



                    CREATE TABLE #returnType
                    (   Id INT IDENTITY (1, 1) ,
                        ReturnType NVARCHAR (100));

                    IF @returnType IS NULL
                        BEGIN
                            INSERT #returnType ( ReturnType )
                            VALUES ( 'ActiveAssignment' ) ,
                                   ( 'StartAssignment' ) ,
                                   ( 'EndedAssignment' );
                        END;
                    ELSE
                        BEGIN
                            INSERT #returnType ( ReturnType )
                                   SELECT br.value
                                   FROM   STRING_SPLIT(@returnType, ',') AS br;
                        END;



                    DECLARE @RecruiterUserTypeListItemId INT = dbo.SfListItemIdGet ('UserType', 'Recruiter');
                    DECLARE @EnteredByUserTypeListItemId INT = dbo.SfListItemIdGet ('UserType', 'EnteredBy');
                    DECLARE @PlacedByByUserTypeListItemId INT = dbo.SfListItemIdGet ('UserType', 'PlacedBy');
                    DECLARE @AmountListItemId INT = dbo.SfListItemIdGet ('PercentOrAmount', 'Amount');
                    DECLARE @PercentageListItemId INT = dbo.SfListItemIdGet ('PercentOrAmount', 'Percent');
                    -- SELECT @PlacedByByUserTypeListItemId


                    CREATE TABLE #AssignmentDetailList
                    (   ReturnType NVARCHAR (100) ,
                        Company NVARCHAR (15) ,
                        TenantOrganizationId INT ,
                        AssignmentId INT ,
                        AssignmentStatus VARCHAR (50) ,
                        Office NVARCHAR (100) ,
                        Customer NVARCHAR (100) ,
                        FirstName NVARCHAR (MAX) ,
                        LastName NVARCHAR (MAX) ,
                        CandidateName NVARCHAR (4000) ,
                        Recruiter NVARCHAR (4000) ,
                        EnteredBy NVARCHAR (4000) ,
                        Department NVARCHAR (100) ,
                        JobId INT ,
                        StartDate DATE ,
                        EndDate DATE ,
                        InputDate DATE ,
                        EndReason VARCHAR (50) ,
                        Performance VARCHAR (50) ,
                        JobTitle NVARCHAR (100) ,
                        WCCode NVARCHAR (25) ,
                        City NVARCHAR (25) ,
                        StateCode NVARCHAR (5) ,
                        SalaryPayRate MONEY ,      --modified by Samiksha  User story :39111
                        SalaryBillRate MONEY ,
                        PhoneNumber NVARCHAR (500) ,
                        [Shift] NVARCHAR (50) ,
                        LastPaidDate DATE ,
                        PersonId INT ,
                        GPPercent DECIMAL (10, 4)
                            DEFAULT ( 0 ) ,
                        WCCodeRate DECIMAL (10, 4) ,
                        SUTAState VARCHAR (25) ,
                        SUTATax DECIMAL (10, 2) ,
                        Burden DECIMAL (10, 2) ,
                        FUTA DECIMAL (10, 2) ,
                        FICA DECIMAL (10, 2) ,
                        Medicare DECIMAL (10, 2) ,
                        Markup DECIMAL (10, 2) ,
                        FederalTaxBurden DECIMAL (10, 2) ,
                        TotalBurden DECIMAL (10, 2) ,
                        StateId INT ,
                        OrganizationId INT ,
                        OtherTaxBurden DECIMAL (10, 2)
                            DEFAULT ( 0 ) ,
                        OtherBurden DECIMAL (10, 2)
                            DEFAULT ( 0 ) ,
                        TotalRTCost MONEY ,
                        RTGPAmount MONEY ,
                        WCCodeId INT ,
                        MarkupId INT ,
                        PlacedBy NVARCHAR (4000) , --modified by samiksha
                        EndReasonListItemId INT ,
                        PONumber NVARCHAR (50) ,
                        Extra1 NVARCHAR (50) ,
                        Extra2 NVARCHAR (50) ,
                        Extra3 NVARCHAR (50) ,
                        Extra4 NVARCHAR (50) ,
                        Charge NVARCHAR (500) ,
                        RTPayRate MONEY ,          --added by Samiksha:12/16/2022
                        OTPayRate MONEY ,
                        DTPayRate MONEY ,
                        RTBillRate MONEY ,
                        OTBillRate MONEY ,
                        DTBillRate MONEY );

                    IF EXISTS ( SELECT TOP 1 1
                                FROM   #returnType AS rt
                                WHERE  rt.ReturnType = 'ActiveAssignment' )
                        BEGIN

                            INSERT INTO #AssignmentDetailList ( ReturnType ,
                                                                Company ,
                                                                [TenantOrganizationId] ,
                                                                AssignmentId ,
                                                                PersonId ,
                                                                AssignmentStatus ,
                                                                Office ,
                                                                Customer ,
                                                                [OrganizationId] ,
                                                                FirstName ,
                                                                LastName ,
                                                                CandidateName ,
                                                                --Recruiter ,
                                                                -- EnteredBy ,
                                                                Department ,
                                                                JobId ,
                                                                StartDate ,
                                                                EndDate ,
                                                                EndReason ,
                                                                Performance ,
                                                                JobTitle ,
                                                                WCCode ,
                                                                City ,
                                                                StateCode ,
                                                                InputDate ,
                                                                PhoneNumber ,
                                                                [Shift] ,
                                                                [WCCodeId] ,
                                                                [MarkupId] ,
                                                                [StateId] ,
                                                                [SUTAState] ,
                                                                -- PlacedBy ,
                                                                EndReasonListItemId ,
                                                                PONumber ,
                                                                Extra1 ,
                                                                Extra2 ,
                                                                Extra3 ,
                                                                Extra4 ,
                                                                Charge )
                                        --SELECT 'Active Assignment' ,
                                        --       tads.Alias ,
                                        --       [tads].[TenantOrganizationId] ,
                                        --       tads.AssignmentId ,
                                        --       tads.PersonId ,
                                        --       li.ListItem AS assignmentStatus ,
                                        --       tads.Office AS office ,
                                        --       tads.Organization AS customer ,
                                        --       [tads].[OrganizationId] ,
                                        --       tads.FirstName ,
                                        --       tads.LastName ,
                                        --       tads.Name AS candidateName ,
                                        --                                    -- p.Name AS recruiter ,
                                        --                                    -- ep.Name AS EnteredBy ,
                                        --       tads.Department ,
                                        --       tads.JobId ,
                                        --       tads.StartDate ,
                                        --       tads.EndDate ,
                                        --       tads.EndReason ,
                                        --       tads.Performance ,
                                        --       tads.JobTitle ,
                                        --       tads.WCCode ,
                                        --       tads.City ,
                                        --       tads.StateCode ,
                                        --       a.InsertDate ,
                                        --       ci.Value ,
                                        --       ISNULL (s.Shift, s2.Shift) , --sasita 11/7/2022 added logic to pull shift from job USER STORY 35976
                                        --       [tads].[WCCodeId] ,
                                        --       [a].[MarkUpId] ,
                                        --       [tads].[StateId] ,
                                        --       [tads].[StateCode] ,
                                        --                                    --  p3.Name ,
                                        --       a.EndReasonListItemId ,
                                        --       j.PurchaseOrderNumber ,
                                        --       j.Extra1 ,
                                        --       j.Extra2 ,
                                        --       j.Extra3 ,
                                        --       j.Extra4 ,
                                        --       c.Charge + ' : '
                                        --       + CASE WHEN c.PercentOrAmountListItemId = @AmountListItemId THEN
                                        --                  CONCAT (
                                        --                      '$' ,
                                        --                      CAST(c.Value AS VARCHAR (10)),
                                        --                      ' ON ' ,
                                        --                      dbo.SfListItemGet (c.TierBasedOnListItemId))
                                        --              WHEN c.PercentOrAmountListItemId = @PercentageListItemId THEN
                                        --                  CONCAT (
                                        --                      CAST(c.Value AS VARCHAR (10)) ,
                                        --                      '%' ,
                                        --                      ' ON ' ,
                                        --                      dbo.SfListItemGet (c.TierBasedOnListItemId))
                                        --         END
                                        --FROM   dbo.TfAssignmentDataSel (@UserPersonId) AS tads
                                        --       INNER JOIN dbo.Assignment AS a ON a.AssignmentId = tads.AssignmentId
                                        --       LEFT JOIN #EndReason AS er ON er.EndReasonListItemId = tads.EndReasonListItemId
                                        --       INNER JOIN dbo.ListItem AS li ON li.ListItemId = a.StatusListItemId
                                        --       INNER JOIN dbo.Person AS p2 ON p2.PersonId = tads.PersonId
                                        --       INNER JOIN dbo.PersonCurrent AS pc ON pc.PersonId = p2.PersonId
                                        --       -- INNER JOIN dbo.ContactInformation AS ci ON ci.ContactInformationId = pc.PhoneContactInformationId
                                        --       LEFT JOIN dbo.ContactInformation AS ci ON ci.ContactInformationId = pc.PhoneContactInformationId --modified by Samiksha
                                        --       INNER JOIN #Office AS o2 ON o2.OfficeId = tads.OfficeId
                                        --       LEFT JOIN dbo.Shift AS s ON s.ShiftId = tads.ShiftId
                                        --       LEFT JOIN dbo.Job AS j ON j.JobId = tads.JobId
                                        --       LEFT JOIN dbo.Shift AS s2 ON s2.ShiftId = j.ShiftId --sasita 11/7/2022 added logic to pull shift from job USER STORY 35976
                                        --       LEFT JOIN dbo.TempJob AS tj ON tj.JobId = j.JobId
                                        --       LEFT JOIN dbo.Charge AS c ON c.ChargeId = tj.ChargeId
                                        --WHERE  ( @EndDate >= tads.StartDate
                                        --     AND ( @StartDate <= ISNULL (tads.EndDate, @StartDate)))
                                        --AND    p2.Name LIKE CASE WHEN @Person = '%'
                                        --                         OR   @Person = '' THEN p2.Name
                                        --                         ELSE '%' + @Person + '%'
                                        --                    END
                                        --AND    tads.Organization LIKE CASE WHEN @Customer = '%'
                                        --                                   OR   @Customer = '' THEN tads.Organization
                                        --                                   ELSE '%' + @Customer + '%'
                                        --                              END;

                                        SELECT 'Active Assignment' ,
                                               tor.Alias ,
                                               tor.OrganizationId ,
                                               tads.AssignmentId ,
                                               tads.PersonId ,
                                               li.ListItem ,
                                               o.Office ,
                                               o3.Organization ,
                                               o3.[OrganizationId] ,
                                               p2.FirstName ,
                                               p2.LastName ,
                                               p2.Name ,
                                                                            -- p.Name ,
                                                                            -- ep.Name ,
                                               o3.Department ,
                                               j.JobId ,
                                               a.StartDate ,
                                               a.EndDate ,
                                               li2.ListItem ,
                                               li3.ListItem ,
                                               j.JobTitle ,
                                               wc.WCCode ,
                                               ad.City ,
                                               s3.StateCode ,
                                               a.InsertDate ,
                                               ci.Value ,
                                               ISNULL (s.Shift, s2.Shift) , --sasita 11/7/2022 added logic to pull shift from job USER STORY 35976
                                               wc.[WCCodeId] ,
                                               [a].[MarkUpId] ,
                                               s3.[StateId] ,
                                               s3.[StateCode] ,
                                                                            -- p3.Name ,
                                               a.EndReasonListItemId ,
                                               j.PurchaseOrderNumber ,
                                               j.Extra1 ,
                                               j.Extra2 ,
                                               j.Extra3 ,
                                               j.Extra4 ,
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
                                        FROM   dbo.TfAssignmentSel (@UserPersonId, 0) AS tads
                                               INNER JOIN dbo.Assignment AS a ON a.AssignmentId = tads.AssignmentId
                                               LEFT JOIN #EndReason AS er ON er.EndReasonListItemId = a.EndReasonListItemId
                                               LEFT JOIN dbo.ListItem AS li2 ON li2.ListItemId = a.EndReasonListItemId
                                               LEFT JOIN dbo.ListItem AS li3 ON li3.ListItemId = a.PerformanceListItemId
                                               INNER JOIN dbo.ListItem AS li ON li.ListItemId = a.StatusListItemId
                                               INNER JOIN dbo.Person AS p2 ON p2.PersonId = tads.PersonId --AND a.PersonId = 16146356

                                               INNER JOIN dbo.PersonCurrent AS pc ON pc.PersonId = p2.PersonId
                                               LEFT JOIN dbo.ContactInformation AS ci ON ci.ContactInformationId = pc.PhoneContactInformationId --modified by Samiksha
                                               INNER JOIN dbo.Office AS o ON o.OfficeId = a.OfficeId
                                               INNER JOIN dbo.TenantOrganization AS tor ON tor.OrganizationId = o.OrganizationId
                                               INNER JOIN #Office AS o2 ON o2.OfficeId = a.OfficeId
                                               LEFT JOIN dbo.Shift AS s ON s.ShiftId = a.ShiftId
                                               INNER JOIN dbo.Job AS j ON j.JobId = a.JobId
                                               INNER JOIN dbo.OrganizationAddress AS oa ON j.OrganizationAddressId = oa.OrganizationAddressId
                                               INNER JOIN dbo.[Address] AS ad ON oa.AddressId = ad.AddressId
                                               INNER JOIN dbo.State AS s3 ON s3.StateId = ad.StateId
                                               INNER JOIN dbo.Organization AS o3 ON o3.OrganizationId = j.OrganizationId
                                               LEFT JOIN dbo.Shift AS s2 ON s2.ShiftId = j.ShiftId --sasita 11/7/2022 added logic to pull shift from job USER STORY 35976
                                               INNER JOIN dbo.TempJob AS tj ON tj.JobId = j.JobId
                                               INNER JOIN dbo.WCCode AS wc ON wc.WCCodeId = tj.WCCodeId
                                               LEFT JOIN dbo.Charge AS c ON c.ChargeId = tj.ChargeId
                                        WHERE  ( @EndDate >= a.StartDate
                                             AND ( @StartDate <= ISNULL (a.EndDate, @StartDate)))
                                        AND    p2.Name LIKE CASE WHEN @Person = '%'
                                                                 OR   @Person = '' THEN p2.Name
                                                                 ELSE '%' + @Person + '%'
                                                            END
                                        AND    o3.Organization LIKE CASE WHEN @Customer = '%'
                                                                         OR   @Customer = '' THEN o3.Organization
                                                                         ELSE '%' + @Customer + '%'
                                                                    END;









                        END;

                    IF EXISTS ( SELECT TOP 1 1
                                FROM   #returnType AS rt
                                WHERE  rt.ReturnType = 'StartAssignment' )
                        BEGIN

                            INSERT INTO #AssignmentDetailList ( ReturnType ,
                                                                Company ,
                                                                [TenantOrganizationId] ,
                                                                AssignmentId ,
                                                                PersonId ,
                                                                AssignmentStatus ,
                                                                Office ,
                                                                Customer ,
                                                                [OrganizationId] ,
                                                                FirstName ,
                                                                LastName ,
                                                                CandidateName ,
                                                                --  Recruiter ,
                                                                --EnteredBy ,
                                                                Department ,
                                                                JobId ,
                                                                StartDate ,
                                                                EndDate ,
                                                                EndReason ,
                                                                Performance ,
                                                                JobTitle ,
                                                                WCCode ,
                                                                City ,
                                                                StateCode ,
                                                                InputDate ,
                                                                PhoneNumber ,
                                                                [Shift] ,
                                                                [WCCodeId] ,
                                                                [MarkupId] ,
                                                                [StateId] ,
                                                                [SUTAState] ,
                                                                --  PlacedBy ,
                                                                EndReasonListItemId ,
                                                                PONumber ,
                                                                Extra1 ,
                                                                Extra2 ,
                                                                Extra3 ,
                                                                Extra4 ,
                                                                Charge )
                                        SELECT 'Start Assignment' ,
                                               tor.Alias ,
                                               tor.OrganizationId ,
                                               tads.AssignmentId ,
                                               tads.PersonId ,
                                               li.ListItem ,
                                               o.Office ,
                                               o3.Organization ,
                                               o3.[OrganizationId] ,
                                               p2.FirstName ,
                                               p2.LastName ,
                                               p2.Name ,
                                                                            -- p.Name ,
                                                                            -- ep.Name ,
                                               o3.Department ,
                                               j.JobId ,
                                               a.StartDate ,
                                               a.EndDate ,
                                               li2.ListItem ,
                                               li3.ListItem ,
                                               j.JobTitle ,
                                               wc.WCCode ,
                                               ad.City ,
                                               s3.StateCode ,
                                               a.InsertDate ,
                                               ci.Value ,
                                               ISNULL (s.Shift, s2.Shift) , --sasita 11/7/2022 added logic to pull shift from job USER STORY 35976
                                               wc.[WCCodeId] ,
                                               [a].[MarkUpId] ,
                                               s3.[StateId] ,
                                               s3.[StateCode] ,
                                                                            -- p3.Name ,
                                               a.EndReasonListItemId ,
                                               j.PurchaseOrderNumber ,
                                               j.Extra1 ,
                                               j.Extra2 ,
                                               j.Extra3 ,
                                               j.Extra4 ,
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
                                        FROM   dbo.TfAssignmentSel (@UserPersonId, 0) AS tads
                                               LEFT JOIN #AssignmentDetailList AS adl ON adl.AssignmentId = tads.AssignmentId
                                               INNER JOIN dbo.Assignment AS a ON a.AssignmentId = tads.AssignmentId
                                               LEFT JOIN #EndReason AS er ON er.EndReasonListItemId = a.EndReasonListItemId
                                               LEFT JOIN dbo.ListItem AS li2 ON li2.ListItemId = a.EndReasonListItemId
                                               LEFT JOIN dbo.ListItem AS li3 ON li3.ListItemId = a.PerformanceListItemId
                                               INNER JOIN dbo.ListItem AS li ON li.ListItemId = a.StatusListItemId
                                               INNER JOIN dbo.Person AS p2 ON p2.PersonId = tads.PersonId --AND a.PersonId = 16146356

                                               INNER JOIN dbo.PersonCurrent AS pc ON pc.PersonId = p2.PersonId
                                               LEFT JOIN dbo.ContactInformation AS ci ON ci.ContactInformationId = pc.PhoneContactInformationId --modified by Samiksha
                                               INNER JOIN dbo.Office AS o ON o.OfficeId = a.OfficeId
                                               INNER JOIN dbo.TenantOrganization AS tor ON tor.OrganizationId = o.OrganizationId
                                               INNER JOIN #Office AS o2 ON o2.OfficeId = a.OfficeId
                                               LEFT JOIN dbo.Shift AS s ON s.ShiftId = a.ShiftId
                                               INNER JOIN dbo.Job AS j ON j.JobId = a.JobId
                                               INNER JOIN dbo.OrganizationAddress AS oa ON j.OrganizationAddressId = oa.OrganizationAddressId
                                               INNER JOIN dbo.[Address] AS ad ON oa.AddressId = ad.AddressId
                                               INNER JOIN dbo.State AS s3 ON s3.StateId = ad.StateId
                                               INNER JOIN dbo.Organization AS o3 ON o3.OrganizationId = j.OrganizationId
                                               LEFT JOIN dbo.Shift AS s2 ON s2.ShiftId = j.ShiftId --sasita 11/7/2022 added logic to pull shift from job USER STORY 35976
                                               INNER JOIN dbo.TempJob AS tj ON tj.JobId = j.JobId
                                               INNER JOIN dbo.WCCode AS wc ON wc.WCCodeId = tj.WCCodeId
                                               LEFT JOIN dbo.Charge AS c ON c.ChargeId = tj.ChargeId
                                        WHERE  CAST(a.StartDate AS DATE) BETWEEN @StartDate AND @EndDate
                                        AND    p2.Name LIKE CASE WHEN @Person = '%'
                                                                 OR   @Person = '' THEN p2.Name
                                                                 ELSE '%' + @Person + '%'
                                                            END
                                        AND    o3.Organization LIKE CASE WHEN @Customer = '%'
                                                                           OR   @Customer = '' THEN o3.Organization
                                                                           ELSE '%' + @Customer + '%'
                                                                      END
                                        AND    adl.AssignmentId IS NULL; -->Abhishek KC 9/8/2022











                        END;



                    IF EXISTS ( SELECT TOP 1 1
                                FROM   #returnType AS rt
                                WHERE  rt.ReturnType = 'EndedAssignment' ) --modified by Samiskha
                        BEGIN


                            INSERT INTO #AssignmentDetailList ( ReturnType ,
                                                                Company ,
                                                                [TenantOrganizationId] ,
                                                                AssignmentId ,
                                                                PersonId ,
                                                                AssignmentStatus ,
                                                                Office ,
                                                                Customer ,
                                                                [OrganizationId] ,
                                                                FirstName ,
                                                                LastName ,
                                                                CandidateName ,
                                                                --Recruiter ,
                                                                -- EnteredBy ,
                                                                Department ,
                                                                JobId ,
                                                                StartDate ,
                                                                EndDate ,
                                                                EndReason ,
                                                                Performance ,
                                                                JobTitle ,
                                                                WCCode ,
                                                                City ,
                                                                StateCode ,
                                                                InputDate ,
                                                                PhoneNumber ,
                                                                [Shift] ,
                                                                [WCCodeId] ,
                                                                [MarkupId] ,
                                                                [StateId] ,
                                                                [SUTAState] ,
                                                                -- PlacedBy ,
                                                                EndReasonListItemId ,
                                                                PONumber ,
                                                                Extra1 ,
                                                                Extra2 ,
                                                                Extra3 ,
                                                                Extra4 ,
                                                                Charge )
                                        SELECT 'Ended Assignment' ,
                                               tor.Alias ,
                                               tor.OrganizationId ,
                                               tads.AssignmentId ,
                                               tads.PersonId ,
                                               li.ListItem ,
                                               o.Office ,
                                               o3.Organization ,
                                               o3.[OrganizationId] ,
                                               p2.FirstName ,
                                               p2.LastName ,
                                               p2.Name ,
                                                                            -- p.Name ,
                                                                            -- ep.Name ,
                                               o3.Department ,
                                               j.JobId ,
                                               a.StartDate ,
                                               a.EndDate ,
                                               li2.ListItem ,
                                               li3.ListItem ,
                                               j.JobTitle ,
                                               wc.WCCode ,
                                               ad.City ,
                                               s3.StateCode ,
                                               a.InsertDate ,
                                               ci.Value ,
                                               ISNULL (s.Shift, s2.Shift) , --sasita 11/7/2022 added logic to pull shift from job USER STORY 35976
                                               wc.[WCCodeId] ,
                                               [a].[MarkUpId] ,
                                               s3.[StateId] ,
                                               s3.[StateCode] ,
                                                                            -- p3.Name ,
                                               a.EndReasonListItemId ,
                                               j.PurchaseOrderNumber ,
                                               j.Extra1 ,
                                               j.Extra2 ,
                                               j.Extra3 ,
                                               j.Extra4 ,
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
                                        FROM   dbo.TfAssignmentSel (@UserPersonId, 0) AS tads
                                               LEFT JOIN #AssignmentDetailList AS adl ON adl.AssignmentId = tads.AssignmentId
                                               INNER JOIN dbo.Assignment AS a ON a.AssignmentId = tads.AssignmentId
                                               INNER JOIN #EndReason AS er ON er.EndReasonListItemId = a.EndReasonListItemId
                                               INNER JOIN dbo.ListItem AS li2 ON li2.ListItemId = a.EndReasonListItemId
                                               LEFT JOIN dbo.ListItem AS li3 ON li3.ListItemId = a.PerformanceListItemId
                                               INNER JOIN dbo.ListItem AS li ON li.ListItemId = a.StatusListItemId
                                               INNER JOIN dbo.Person AS p2 ON p2.PersonId = tads.PersonId --AND a.PersonId = 16146356

                                               INNER JOIN dbo.PersonCurrent AS pc ON pc.PersonId = p2.PersonId
                                               LEFT JOIN dbo.ContactInformation AS ci ON ci.ContactInformationId = pc.PhoneContactInformationId --modified by Samiksha
                                               INNER JOIN dbo.Office AS o ON o.OfficeId = a.OfficeId
                                               INNER JOIN dbo.TenantOrganization AS tor ON tor.OrganizationId = o.OrganizationId
                                               INNER JOIN #Office AS o2 ON o2.OfficeId = a.OfficeId
                                               LEFT JOIN dbo.Shift AS s ON s.ShiftId = a.ShiftId
                                               INNER JOIN dbo.Job AS j ON j.JobId = a.JobId
                                               INNER JOIN dbo.OrganizationAddress AS oa ON j.OrganizationAddressId = oa.OrganizationAddressId
                                               INNER JOIN dbo.[Address] AS ad ON oa.AddressId = ad.AddressId
                                               INNER JOIN dbo.State AS s3 ON s3.StateId = ad.StateId
                                               INNER JOIN dbo.Organization AS o3 ON o3.OrganizationId = j.OrganizationId
                                               LEFT JOIN dbo.Shift AS s2 ON s2.ShiftId = j.ShiftId --sasita 11/7/2022 added logic to pull shift from job USER STORY 35976
                                               INNER JOIN dbo.TempJob AS tj ON tj.JobId = j.JobId
                                               INNER JOIN dbo.WCCode AS wc ON wc.WCCodeId = tj.WCCodeId
                                               LEFT JOIN dbo.Charge AS c ON c.ChargeId = tj.ChargeId
                                        WHERE  CAST(a.EndDate AS DATE) BETWEEN @StartDate AND @EndDate
                                        AND    p2.Name LIKE CASE WHEN @Person = '%'
                                                                 OR   @Person = '' THEN p2.Name
                                                                 ELSE '%' + @Person + '%'
                                                            END
                                        AND    o3.Organization LIKE CASE WHEN @Customer = '%'
                                                                           OR   @Customer = '' THEN o3.Organization
                                                                           ELSE '%' + @Customer + '%'
                                                                      END
                                        AND    adl.AssignmentId IS NULL; -->Abhishek KC 9/8/2022




                        END;

                    --SELECT *
                    UPDATE adl
                    SET    adl.EnteredBy = ep.Name
                    FROM   #AssignmentDetailList AS adl
                           INNER JOIN dbo.AssignmentUserType aut ON  aut.UserTypeListItemId = @EnteredByUserTypeListItemId
                                                                 AND aut.AssignmentId = adl.AssignmentId
                           INNER JOIN dbo.Person ep ON ep.PersonId = aut.UserTypePersonId;

                    UPDATE adl
                    SET    adl.Recruiter = p.Name
                    FROM   #AssignmentDetailList AS adl
                           INNER JOIN dbo.PersonUserType AS put ON  put.UserTypeListItemId = @RecruiterUserTypeListItemId
                                                                AND put.PersonId = adl.PersonId
                           INNER JOIN dbo.Person AS p ON p.PersonId = put.UserTypePersonId;


                    UPDATE adl
                    SET    adl.PlacedBy = p3.Name
                    FROM   #AssignmentDetailList AS adl
                           INNER JOIN dbo.AssignmentUserType put2 ON  put2.AssignmentId = adl.AssignmentId
                                                                  AND put2.UserTypeListItemId = @PlacedByByUserTypeListItemId
                           INNER JOIN dbo.Person AS p3 ON p3.PersonId = put2.UserTypePersonId;


                    --SELECT   *
                    --FROM     #AssignmentDetailList AS al
                    --ORDER BY al.Company ,
                    --         al.Office ,
                    --         al.Customer ,
                    --         al.CandidateName;

                    --SELECT 1 / 0;

                    IF @EndReason <> 'All' --added by Samiksha
                        BEGIN

                            DELETE adl
                            FROM   #AssignmentDetailList AS adl
                            WHERE  adl.EndReasonListItemId IS NULL
                            OR     adl.EndReasonListItemId NOT IN ( SELECT er.EndReasonListItemId
                                                                    FROM   #EndReason AS er );


                        END;







                    UPDATE adl
                    SET    adl.[GPPercent] = a.EstimatedGrossProfitPercent
                    FROM   [#AssignmentDetailList] AS [adl]
                           INNER JOIN dbo.Assignment AS a ON a.AssignmentId = adl.AssignmentId;


                    /*PhoneNumber*/
                    UPDATE adl
                    SET    adl.PhoneNumber = '(' + SUBSTRING (adl.PhoneNumber, 1, 3) + ')' + ' '
                                             + SUBSTRING (adl.PhoneNumber, 4, 3) + '-' + SUBSTRING (adl.PhoneNumber, 7, 4)
                    FROM   #AssignmentDetailList AS adl;

                    /*update for lastPaidDate*/
                    UPDATE adl
                    SET    adl.LastPaidDate = lpd.LastPaidDate
                    FROM   #AssignmentDetailList AS adl
                           INNER JOIN ( SELECT   MAX (pb.CheckDate) AS LastPaidDate ,
                                                 p.PersonId
                                        FROM     dbo.Payment AS p
                                                 INNER JOIN dbo.PaymentBatch AS pb ON pb.PaymentBatchId = p.PaymentBatchId
                                                 INNER JOIN #AssignmentDetailList AS adl ON adl.PersonId = p.PersonId
                                        GROUP BY p.PersonId ) AS lpd ON lpd.PersonId = adl.PersonId;

                    DECLARE @SalaryTransactionCodeId INT = dbo.SfTransactionCodeIdGet ('Earnings', 'Salary', 'Salary'); --added by Samiksha


                    UPDATE adl
                    SET    adl.SalaryPayRate = ar.PayRate , --added by Samiksha: User story 39111
                           adl.SalaryBillRate = ar.BillRate
                    FROM   #AssignmentDetailList AS adl
                           INNER JOIN dbo.AssignmentRate AS ar ON  ar.AssignmentId = adl.AssignmentId
                                                               AND ar.TransactionCodeId = @SalaryTransactionCodeId;




                    UPDATE adl --added by Samiksha: User story 39111
                    SET    adl.RTPayRate = ISNULL (pays.RT, 0) ,
                           adl.RTBillRate = ISNULL (bills.RT, 0) ,
                           adl.OTPayRate = ISNULL (pays.OT, 0) ,
                           adl.OTBillRate = ISNULL (bills.OT, 0) ,
                           adl.DTPayRate = ISNULL (pays.DT, 0) ,
                           adl.DTBillRate = ISNULL (bills.DT, 0)
                    FROM   #AssignmentDetailList AS adl
                           INNER JOIN ( SELECT pay.AssignmentId ,
                                               pay.DT ,
                                               pay.OT ,
                                               pay.RT
                                        FROM   ( SELECT a.AssignmentId ,
                                                        ar.PayRate AS pay ,
                                                        tc.TransactionCode
                                                 FROM   dbo.Assignment AS a
                                                        INNER JOIN dbo.AssignmentRate AS ar ON ar.AssignmentId = a.AssignmentId
                                                        INNER JOIN dbo.TransactionCode AS tc ON tc.TransactionCodeId = ar.TransactionCodeId
                                                        INNER JOIN #AssignmentDetailList AS aa ON aa.AssignmentId = a.AssignmentId ) AS x
                                        PIVOT ( MAX(pay)
                                                FOR TransactionCode IN ( [RT], [OT], [DT] )) AS pay ) AS pays ON adl.AssignmentId = pays.AssignmentId
                           INNER JOIN ( SELECT bill.AssignmentId ,
                                               bill.DT ,
                                               bill.OT ,
                                               bill.RT
                                        FROM   ( SELECT ars.AssignmentId ,
                                                        ars.BillRate AS bill ,
                                                        tc.TransactionCode
                                                 FROM   dbo.Assignment AS ats
                                                        INNER JOIN dbo.AssignmentRate AS ars ON ars.AssignmentId = ats.AssignmentId
                                                        INNER JOIN dbo.TransactionCode AS tc ON tc.TransactionCodeId = ars.TransactionCodeId
                                                        INNER JOIN #AssignmentDetailList AS act ON act.AssignmentId = ats.AssignmentId ) AS bills
                                        PIVOT ( MAX(bill)
                                                FOR TransactionCode IN ( [RT], [OT], [DT] )) AS bill ) AS bills ON bills.AssignmentId = adl.AssignmentId;

                    SELECT @Json = ISNULL (
                                   ( SELECT   al.ReturnType [Return Type] ,                    --modified by Samiksha
                                              al.Company ,
                                              al.Office ,
                                              al.City AS [Worksite City] ,
                                              al.StateCode AS [Worksite State] ,
                                              al.Customer ,
                                              al.Department ,
                                              al.PersonId AS [Employee Id] ,
                                              al.FirstName AS [First Name] ,
                                              al.LastName AS [Last Name] ,
                                              al.CandidateName AS [Employee Name] ,
                                              al.PhoneNumber AS [Phone Number] ,
                                              al.Recruiter ,
                                              al.EnteredBy [Entered By] ,
                                              al.PlacedBy [Placed By] ,
                                              al.AssignmentStatus AS [Assignment Status] ,
                                              al.JobTitle AS [Job Title] ,
                                              al.PONumber AS [PO Number] ,
                                              al.Shift ,
                                              al.EndReason AS [End Reason] ,
                                              al.Performance ,
                                              al.Extra1 ,
                                              al.Extra2 ,
                                              al.Extra3 ,
                                              al.Extra4 ,
                                              al.WCCode AS [WC Code] ,
                                              ISNULL (al.SalaryPayRate, 0) [Salary Pay Rate] , --modified  by Samiskha  User story 39111
                                              ISNULL (al.SalaryBillRate, 0) [Salary Bill Rate] ,
                                              al.RTPayRate [RT Pay Rate] ,                     --added by Samiksha  User story 39111
                                              al.RTBillRate [RT Bill Rate] ,
                                              al.OTPayRate [OT Pay Rate] ,
                                              al.OTBillRate [OT Bill Rate] ,
                                              al.DTPayRate [DT Pay Rate] ,
                                              al.DTBillRate [DT Bill Rate] ,
                                              al.Charge ,
                                              CONVERT (VARCHAR (10), al.InputDate, 101) AS [Input Date] ,
                                              CONVERT (VARCHAR (10), al.StartDate, 101) AS [Start Date] ,
                                              CONVERT (VARCHAR (10), al.EndDate, 101) AS [End Date] ,
                                              CONVERT (VARCHAR (10), al.LastPaidDate, 101) AS [Last Paid Date] ,
                                              al.AssignmentId AS [Assignment Id] ,
                                              al.JobId AS [Job Id] ,
                                              al.GPPercent [GP Percent]
                                     FROM     #AssignmentDetailList AS al
                                     ORDER BY al.Company ,
                                              al.Office ,
                                              al.Customer ,
                                              al.CandidateName
                                   FOR JSON PATH, INCLUDE_NULL_VALUES ) ,
                                   '[]');


                    DROP TABLE #AssignmentDetailList;
                    DROP TABLE #Company;
                    DROP TABLE #Office;
                    DROP TABLE #ParamValue;
                END;

        END TRY
        BEGIN CATCH


            THROW;

        END CATCH;

    END;
GO

