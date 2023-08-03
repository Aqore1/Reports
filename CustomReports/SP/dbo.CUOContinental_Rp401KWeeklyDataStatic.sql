SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
/*  
-- =============================================  
-- Author:  Sunil Nepali  
-- Create date: 06/28/2023  
-- Description: This report gives the adjustment, benefit related data of employe who have recieved payment in the selected Week. (Ticket 47469)  
-- =============================================  
  -- Modified:  Sunil Nepali  
-- Create date: 07/11/2023  
-- Description: Logic updated for terminated date 
-- ============================================= 
*/
-- ===================================================================
-- Modified By : Abhishek KC
-- Modified On : 7/14/2023
-- Description : commented the statement after CTE Expression
-- ===================================================================
--modified by : Samiksha on 7/19/2023, 7/18/2023 : changed logic for Salary, Salary Qualifier, marital status, gender, payroll date, termination date (Ticket 48778 )
--modiifed by Samiksha on 7/27/2023: changed logic for rehire date and termination date: If they are on active assignment, they should not have rehired date and termination date, else, pull rehire date from system and termination date will be the recently ended assignment date. (Ticket 48778)
--modified by Samiksha on 8/2/2023, added Loan Repayments logic (Ticket 49661)

ALTER PROCEDURE dbo.[CUOContinental_Rp401KWeeklyDataStatic]
    @Json NVARCHAR (MAX) OUTPUT
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

                    --DECLARE @Year INT = ( SELECT pv.Value  
                    --                      FROM   #ParamValue AS pv  
                    --                      WHERE  pv.NAME = 'Year' );  


                    DECLARE @EmailListItemiD INT = dbo.SfListItemIdGet ('ContactInformationType', 'Email');
                    DECLARE @HiredDateListItemId INT = dbo.SfListItemIdGet ('DateType', 'HiredDate');

                    DECLARE @StartDate DATE = ( SELECT pv.Value
                                                FROM   #ParamValue AS pv
                                                WHERE  pv.NAME = 'CheckDateFrom' );

                    DECLARE @EndDate DATE = ( SELECT pv.Value
                                              FROM   #ParamValue AS pv
                                              WHERE  pv.NAME = 'CheckDateTo' );




                    EXEC dbo.EncryptionKeyOpen;

                    CREATE TABLE #401kEmployee
                    (   EmployeeId INT ,
                        PlanNumber NVARCHAR (25)
                            DEFAULT '520241-01' ,
                        SSN NVARCHAR (25) ,
                        LastName NVARCHAR (50) ,
                        FirstName NVARCHAR (50) ,
                        MiddleName NVARCHAR (50) ,
                        Suffix NVARCHAR (100) ,
                        DateofBirth DATE ,
                        Gender NVARCHAR (100) ,
                        MaritalStatus NVARCHAR (100) ,
                        StateId INT ,
                        Address1 NVARCHAR (50) ,
                        Address2 NVARCHAR (50) ,
                        City NVARCHAR (25) ,
                        StateCode NVARCHAR (5) ,
                        ZipCode NVARCHAR (10) ,
                        HomePhoneNumber NVARCHAR (500) ,
                        WorkPhoneNumber NVARCHAR (500) ,
                        WorkEmailAddress NVARCHAR (100) ,
                        CountryCode NVARCHAR (100) ,
                        HireDate DATE ,
                        TerminationDate DATE ,
                        DateofRehire DATE ,
                        PayrollDate DATE ,
                        PaymentId INT ,
                        EmployeeBeforeTaxBTK1 MONEY
                            DEFAULT 0 ,
                        EmployeeRothRTH1 MONEY
                            DEFAULT 0 ,
                        SafeHarborMatchSHM1 MONEY
                            DEFAULT 0 ,
                        ProfitSharingERO1 MONEY
                            DEFAULT 0 ,
                        DiscretionaryEmployerMatchERM1 MONEY
                            DEFAULT 0 ,
                        YTDHours DECIMAL (10, 4)
                            DEFAULT 0 ,
                        SalaryAmount DECIMAL (10, 4)
                            DEFAULT 0 ,
                        SalaryAmountQualifier NVARCHAR (50) ,
                        LoanRepayments MONEY DEFAULT 0);


                    INSERT #401kEmployee ( EmployeeId ,
                                           FirstName ,
                                           LastName ,
                                           SSN ,
                                           DateofBirth ,
                                           Gender ,
                                           MaritalStatus ,
                                           HireDate ,
                                           PayrollDate )
                           SELECT p.PersonId ,
                                  p.FirstName ,
                                  p.LastName ,
                                  dbo.SfDecrypt (p.TIN, 'd') ,
                                  dbo.SfDecrypt (pe.DateOfBirth, 'd') ,
                                  CASE WHEN dbo.SfListItemGet (pe.GenderListItemId) = 'Male' THEN 'M'
                                       WHEN dbo.SfListItemGet (pe.GenderListItemId) = 'Female' THEN 'F'
                                       ELSE ''
                                  END ,
                                  CASE WHEN dbo.SfListItemGet (pe.MaritalStatusListItemId) = 'Divorced' THEN 'D'
                                       WHEN dbo.SfListItemGet (pe.MaritalStatusListItemId) = 'Married' THEN 'M'
                                       WHEN dbo.SfListItemGet (pe.MaritalStatusListItemId) = 'Unmarried' THEN 'S'
                                       WHEN dbo.SfListItemGet (pe.MaritalStatusListItemId) = 'Widowed' THEN 'W'
                                  END ,
                                  pdt.Date ,
                                  tp.CheckDate -- ,

                           FROM   dbo.TfPaymentDataSel (@UserPersonId) AS tp
                                  INNER JOIN dbo.Person AS p ON p.PersonId = tp.PersonId
                                  LEFT JOIN dbo.PersonEEO AS pe ON pe.PersonId = p.PersonId
                                  LEFT JOIN dbo.PersonDateType AS pdt ON  pdt.PersonId = p.PersonId
                                                                      AND pdt.DateTypeListItemId = @HiredDateListItemId
                           WHERE  tp.CheckDate BETWEEN @StartDate AND @EndDate;


                    UPDATE ke
                    SET    ke.SalaryAmount = tl.PayRate ,
                           ke.SalaryAmountQualifier = tl.qualifier
                    FROM   #401kEmployee AS ke
                           INNER JOIN ( SELECT   tl.PersonId ,
                                                 pb.CheckDate ,
                                                 MAX (ti.PayRate) PayRate ,
                                                 'H' AS qualifier
                                        --,
                                        --                                    CASE WHEN tc.TransactionCode = 'RT' THEN 'H'
                                        --                                         WHEN tc.TransactionCode = 'Salary' THEN
                                        --                                             CASE WHEN dbo.SfListItemGet (tl.PayPeriodListItemId) = 'Annual' THEN
                                        --                                                      'A'
                                        --                                                  WHEN dbo.SfListItemGet (tl.PayPeriodListItemId) = 'Monthly' THEN
                                        --                                                      'M'
                                        --                                                  WHEN dbo.SfListItemGet (tl.PayPeriodListItemId) = 'Semi Monthly' THEN
                                        --                                                      'S'
                                        --                                                  WHEN dbo.SfListItemGet (tl.PayPeriodListItemId) = 'Bi Weekly' THEN
                                        --                                                      'B'
                                        --                                                  WHEN dbo.SfListItemGet (tl.PayPeriodListItemId) = 'Weekly' THEN
                                        --                                                      'W'
                                        --                                                  WHEN dbo.SfListItemGet (tl.PayPeriodListItemId) = 'Hourly' THEN
                                        --                                                      'H'
                                        --                                             END
                                        --                                    END AS qualifier
                                        FROM     dbo.TransactionLink AS tl
                                                 INNER JOIN dbo.Payment AS p ON p.PaymentId = tl.PaymentId
                                                 INNER JOIN dbo.PaymentBatch AS pb ON pb.PaymentBatchId = p.PaymentBatchId
                                                 INNER JOIN dbo.TransactionItem AS ti ON ti.TransactionId = tl.TransactionId
                                                 INNER JOIN dbo.TransactionCode AS tc ON tc.TransactionCodeId = ti.TransactionCodeId
                                        WHERE    tc.TransactionCode IN ( 'Salary', 'RT' )
                                        AND      pb.CheckDate BETWEEN @StartDate AND @EndDate
                                        GROUP BY tl.PersonId ,
                                                 pb.CheckDate ) tl ON  ke.EmployeeId = tl.PersonId
                                                                   AND tl.CheckDate = ke.PayrollDate;



                    UPDATE ke
                    SET    ke.Address1 = a.Address1 ,
                           ke.Address2 = a.Address2 ,
                           ke.City = a.City ,
                           ke.ZipCode = a.ZipCode ,
                           ke.StateCode = s.StateCode ,
                           ke.CountryCode = c.CountryCode
                    FROM   #401kEmployee AS ke
                           LEFT JOIN dbo.PersonCurrent AS pc ON pc.PersonId = ke.EmployeeId
                           LEFT JOIN dbo.Address AS a ON a.AddressId = pc.AddressId
                           LEFT JOIN dbo.State AS s ON s.StateId = a.StateId
                           LEFT JOIN dbo.Country AS c ON c.CountryId = s.CountryId;


                    DECLARE @WorkPhoneNumberListItemId INT = dbo.SfListItemIdGet ('ContactInformation', 'WorkPhone');

                    UPDATE ke
                    SET    ke.HomePhoneNumber = ci2.Value
                    FROM   #401kEmployee AS ke
                           INNER JOIN dbo.PersonCurrent AS pc ON pc.PersonId = ke.EmployeeId
                           INNER JOIN dbo.ContactInformation AS ci2 ON ci2.ContactInformationId = pc.PhoneContactInformationId;

                    UPDATE ke
                    SET    ke.WorkPhoneNumber = ci.Value
                    FROM   #401kEmployee AS ke
                           INNER JOIN dbo.PersonContactInformation AS pci ON pci.PersonId = ke.EmployeeId
                           INNER JOIN dbo.ContactInformation AS ci ON  ci.ContactInformationId = pci.ContactInformationId
                                                                   AND ci.ContactInformationTypeListItemId = @WorkPhoneNumberListItemId;

                    SELECT DISTINCT pb2.CheckDate ,
                                    a.AssignmentId ,
                                    e.EmployeeId ,
                                    a.StartDate ,
                                    a.EndDate
                    INTO   #temp
                    FROM   #401kEmployee e
                           INNER JOIN dbo.Assignment AS a ON a.PersonId = e.EmployeeId
                           INNER JOIN dbo.[Transaction] AS t ON t.AssignmentId = a.AssignmentId
                           INNER JOIN dbo.TransactionLink AS tl ON tl.TransactionId = t.TransactionId
                           INNER JOIN dbo.Payment AS pb ON pb.PaymentId = tl.PaymentId
                           INNER JOIN dbo.PaymentBatch AS pb2 ON pb2.PaymentBatchId = pb.PaymentBatchId;



                    UPDATE e
                    SET    e.HireDate = a.StartDate
                    FROM   #401kEmployee e
                           INNER JOIN #temp AS t ON e.EmployeeId = t.EmployeeId
                           INNER JOIN ( SELECT   DISTINCT MIN (t.CheckDate) AS CheckDate ,
                                                          t.EmployeeId
                                        FROM     #temp AS t
                                        GROUP BY t.EmployeeId ) t2 ON  t2.CheckDate = t.CheckDate
                                                                   AND t.EmployeeId = t2.EmployeeId
                           INNER JOIN dbo.Assignment AS a ON a.AssignmentId = t.AssignmentId;


                    UPDATE ke
                    SET    ke.WorkEmailAddress = ci2.Value
                    FROM   #401kEmployee AS ke
                           INNER JOIN dbo.PersonCurrent AS pc ON pc.PersonId = ke.EmployeeId
                           INNER JOIN dbo.ContactInformation AS ci2 ON ci2.ContactInformationId = pc.EmailContactInformationId;


                    WITH AssignmentEndDate
                    AS ( SELECT DISTINCT a.EmployeeId ,
                                         a.EndDate AS AssignmentEndDate --CASE WHEN a.EndDate IS NULL THEN NULL ELSE a.EndDate END AS EndDate 
                         FROM   #temp AS a
                                INNER JOIN ( SELECT   DISTINCT a.EmployeeId ,
                                                               MAX (a.StartDate) AS startdate
                                             FROM     #temp AS a
                                             GROUP BY a.EmployeeId ) a2 ON  a.EmployeeId = a2.EmployeeId
                                                                        AND a.StartDate = a2.startdate ) ,
                         CheckDate
                    AS ( SELECT   DISTINCT t.EmployeeId ,
                                           MAX (t.CheckDate) AS CheckDate
                         FROM     #temp AS t
                         GROUP BY t.EmployeeId )
                    UPDATE ke
                    SET    ke.TerminationDate = a.AssignmentEndDate
                    --FROM   #401kEmployee AS ke
                    FROM   AssignmentEndDate a
                           INNER JOIN CheckDate c ON c.EmployeeId = a.EmployeeId
                           INNER JOIN #401kEmployee AS ke ON ke.EmployeeId = a.EmployeeId
                    WHERE  DATEDIFF (DAY, a.AssignmentEndDate, GETDATE ()) > 90;



                    UPDATE ke
                    SET    ke.TerminationDate = NULL
                    FROM   #401kEmployee ke
                    WHERE  ke.EmployeeId IN ( SELECT DISTINCT t.EmployeeId
                                              FROM   #temp t
                                              WHERE  t.EndDate IS NULL );



                    UPDATE ke
                    SET    ke.TerminationDate = CASE WHEN TerminationDate IS NOT NULL
                                                     AND  TerminationDate < a2.AssignmentEndDate THEN a2.AssignmentEndDate
                                                     ELSE TerminationDate
                                                END
                    --FROM   #401kEmployee AS ke
                    FROM   #401kEmployee AS ke
                           INNER JOIN ( SELECT   a2.PersonId ,
                                                 MAX (a2.EndDate) AS AssignmentEndDate
                                        FROM     dbo.Assignment AS a2
                                        GROUP BY a2.PersonId ) a2 ON a2.PersonId = ke.EmployeeId;


                    UPDATE ke
                    SET    ke.HireDate = pdt.Date
                    FROM   #401kEmployee AS ke
                           INNER JOIN dbo.PersonDateType AS pdt ON pdt.PersonId = ke.EmployeeId
                    WHERE  dbo.SfListItemGet (pdt.DateTypeListItemId) = 'HiredDate';




                    UPDATE ke
                    SET    ke.DateofRehire = pdt.Date
                    FROM   #401kEmployee AS ke
                           INNER JOIN dbo.PersonDateType AS pdt ON pdt.PersonId = ke.EmployeeId
                    WHERE  dbo.SfListItemGet (pdt.DateTypeListItemId) = 'RehiredDate';

                    --SELECT pc.AssignmentId, ke.DateofRehire, ke.TerminationDate, * FROM  #401kEmployee AS ke
                    --INNER JOIN  dbo.PersonCurrent AS pc ON pc.PersonId = ke.EmployeeId
                    --WHERE ke.EmployeeId = 482347


                    --SELECT *
                    UPDATE ke
                    SET    ke.DateofRehire = CASE WHEN pc.AssignmentId IS NOT NULL THEN NULL
                                                  ELSE ke.DateofRehire
                                             END
                    FROM   #401kEmployee AS ke
                           INNER JOIN dbo.PersonCurrent AS pc ON ke.EmployeeId = pc.PersonId;


                    --SELECT * 
                    UPDATE ke
                    SET    ke.TerminationDate = CASE WHEN ke.DateofRehire IS NOT NULL THEN x.maxenddate
                                                     ELSE ke.TerminationDate
                                                END
                    FROM   #401kEmployee AS ke
                           INNER JOIN ( SELECT   a.PersonId ,
                                                 MAX (a.EndDate) maxenddate
                                        FROM     #401kEmployee AS ke
                                                 INNER JOIN dbo.Assignment AS a ON ke.EmployeeId = a.PersonId
                                        GROUP BY a.PersonId ) x ON ke.EmployeeId = x.PersonId;




                    -- SELECT *   
                    UPDATE ke
                    SET    ke.EmployeeBeforeTaxBTK1 = x.Adjustment
                    FROM   #401kEmployee AS ke
                           INNER JOIN ( SELECT   SUM (tpds.Adjustment) AS Adjustment ,
                                                 tpds.PersonId
                                        FROM     dbo.TfPaymentAdjustmentDataSel (@UserPersonId) AS tpds
                                        WHERE    tpds.TransactionCode = '401K'
                                        AND      tpds.CheckDate BETWEEN @StartDate AND @EndDate
                                        GROUP BY tpds.PersonId ) x ON x.PersonId = ke.EmployeeId;

                    UPDATE ke
                    SET    ke.SafeHarborMatchSHM1 = x.Adjustment
                    FROM   #401kEmployee AS ke
                           INNER JOIN ( SELECT   SUM (tpds.Adjustment) AS Adjustment ,
                                                 tpds.PersonId
                                        FROM     dbo.TfPaymentAdjustmentDataSel (@UserPersonId) AS tpds
                                        WHERE    tpds.TransactionCode = '401KER'
                                        AND      tpds.CheckDate BETWEEN @StartDate AND @EndDate
                                        GROUP BY tpds.PersonId ) x ON x.PersonId = ke.EmployeeId;

                    UPDATE ke
                    SET    ke.EmployeeRothRTH1 = x.Adjustment
                    FROM   #401kEmployee AS ke
                           INNER JOIN ( SELECT   SUM (tpds.Adjustment) AS Adjustment ,
                                                 tpds.PersonId
                                        FROM     dbo.TfPaymentAdjustmentDataSel (@UserPersonId) AS tpds
                                        WHERE    tpds.TransactionCode = '401k Roth'
                                        AND      tpds.CheckDate BETWEEN @StartDate AND @EndDate
                                        GROUP BY tpds.PersonId ) x ON x.PersonId = ke.EmployeeId;


                    UPDATE ke
                    SET    ke.YTDHours = x.TotalPayHours
                    FROM   #401kEmployee AS ke
                           INNER JOIN ( SELECT   tpds.PersonId ,
                                                 SUM (tpds.TotalPayHours) TotalPayHours
                                        FROM     dbo.TfPaymentDataSel (@UserPersonId) AS tpds
                                                 INNER JOIN ( SELECT DISTINCT ke2.EmployeeId
                                                              FROM   #401kEmployee AS ke2 ) x ON x.EmployeeId = tpds.PersonId
                                        WHERE    YEAR (tpds.CheckDate) = YEAR (@EndDate)
                                        GROUP BY tpds.PersonId ) x ON x.PersonId = ke.EmployeeId;


                    UPDATE ke
                    SET    ke.LoanRepayments = x.Adjustment
                    FROM   #401kEmployee AS ke
                           INNER JOIN ( SELECT   tpads.PersonId ,
                                                 SUM (tpads.Adjustment) Adjustment
                                        FROM     dbo.TfPaymentAdjustmentDataSel (@UserPersonId) AS tpads
                                        WHERE    tpads.CheckDate BETWEEN @StartDate AND @EndDate
                                        AND      tpads.TransactionCode = '401k_loan payback'
                                        GROUP BY tpads.PersonId ) x ON x.PersonId = ke.EmployeeId;


                    SELECT @Json = ISNULL (
                                   ( SELECT   DISTINCT ke.PlanNumber [Plan Number] ,
                                                       ke.EmployeeId [Employee Id] ,
                                                       ke.SSN ,
                                                       ke.LastName [Last Name] ,
                                                       ke.FirstName [First Name] ,
                                                       ke.MiddleName [Middle Name] ,
                                                       ke.Suffix ,
                                                       ke.DateofBirth [Date of Birth] ,
                                                       ke.Gender ,
                                                       ke.MaritalStatus [Marital Status] ,
                                                       ke.Address1 ,
                                                       ke.Address2 ,
                                                       ke.City ,
                                                       ke.StateCode [State Code] ,
                                                       ke.ZipCode [Zip Code] ,
                                                       ke.HomePhoneNumber [Home Phone Number] ,
                                                       ke.WorkPhoneNumber [Work Phone Number] ,
                                                       ke.WorkEmailAddress [Work Email Address] ,
                                                       ke.CountryCode [Country Code] ,
                                                       ke.HireDate [HireDate] ,
                                                       ke.TerminationDate [TerminationDate] ,
                                                       ke.DateofRehire [Date of Rehire] ,
                                                       ke.PayrollDate [Payroll Date] ,
                                                       ke.EmployeeBeforeTaxBTK1 [Employee Before-Tax - BTK1] ,
                                                       ke.EmployeeRothRTH1 [Employee Roth - RTH1] ,
                                                       ke.SafeHarborMatchSHM1 [Safe Harbor Match - SHM1] ,
                                                       ke.ProfitSharingERO1 [Profit Sharing - ERO1] ,
                                                       ke.DiscretionaryEmployerMatchERM1 [Discretionary Employer Match - ERM1] ,
                                                      ke.LoanRepayments [Loan Repayments] ,
                                                       ke.YTDHours [YTD Hours] ,
                                                       ke.SalaryAmount [Salary Amount] ,
                                                       ke.SalaryAmountQualifier [Salary Amount Qualifier]
                                     FROM     #401kEmployee AS ke
                                     ORDER BY ke.EmployeeId
                                   --ke.LastName ,
                                   -- ke.PayrollDate DESC
                                   FOR JSON PATH, INCLUDE_NULL_VALUES ) ,
                                   '[]');

                    DROP TABLE IF EXISTS #401kEmployee ,
                                         #ParamValue ,
                                         #temp ,
                                         #temp2;



                END;
        END TRY
        BEGIN CATCH


            THROW;

        END CATCH;

    END;



GO

