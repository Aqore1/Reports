SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

/* 
-- =============================================        
-- Author:  Samiksha Poudel         
-- Create date: 08/24/2021        
-- Description: this Sp selects data for  Fill Ratio report       
-- =============================================     

--==========================================
--modified by: Samiksha
--Modified date: 11/11/2021 
--Description: made report logo fixes as per USER STORY 29209 and TASK 29833
-- =============================================      
--==========================================
--modified by: Sasita
--Modified date: 9/1/2022
--Description: --sasita:9/1/2022 fixed divided by 0 issue when required =0 and placed =0 for ticket : 5619
-- =============================================    
  DECLARE @Json VARCHAR (MAX) ='{
"UserPersonId":1 ,
"DateType":"ActiveJobDate" ,
"StartDate":"7/1/2022"  ,
"EndDate":"7/31/2022"  , 
"Company":"200003" ,
"Office" :"",
"Customer":"%" }'
EXEC dbo.RpFillRatio @Json = @Json OUTPUT -- varchar(max)
SELECT @Json     
*/
ALTER PROCEDURE [dbo].[RpFillRatio]
(
    @Json VARCHAR (MAX) OUTPUT )
AS
    BEGIN
        SET NOCOUNT ON;
        IF 1 = 0
            BEGIN
                SET FMTONLY OFF;
            END;


        DECLARE @UserPersonId INT = JSON_VALUE (@Json, '$.UserPersonId') ,
                @Office NVARCHAR (MAX) = JSON_VALUE (@Json, '$.Office') ,
                @Company NVARCHAR (MAX) = JSON_VALUE (@Json, '$.Company') ,
                @StartDate DATE = JSON_VALUE (@Json, '$.StartDate') ,
                @EndDate DATE = JSON_VALUE (@Json, '$.EndDate') ,
                @DateType VARCHAR (50) = JSON_VALUE (@Json, '$.DateType') ,
                @Customer NVARCHAR (MAX) = JSON_VALUE (@Json, '$.Customer');


        --SELECT @StartDate
        --SELECT @Company
        --SELECT @DateType

        SELECT @Company = ISNULL (NULLIF(@Company, ''), 'All');
        SELECT @Office = ISNULL (NULLIF(@Office, ''), 'All');
        SELECT @DateType = ISNULL (NULLIF(@DateType, ''), 'InsertDate');
        SELECT @Customer = CASE WHEN ISNULL (NULLIF(@Customer, ''), '') = '' THEN '%'
                                ELSE RTRIM (LTRIM (@Customer))
                           END;



        CREATE TABLE #Company
        ( OrganizationId INT );

        IF ( @Company = 'All' )
            BEGIN
                INSERT #Company ( OrganizationId )
                       SELECT DISTINCT tpdas.OrganizationId
                       FROM   dbo.TfPersonDataAccessSel (@UserPersonId, 1) AS tpdas;
            END;
        ELSE
            BEGIN
                INSERT #Company ( OrganizationId )
                       SELECT CAST(value AS INT)
                       FROM   STRING_SPLIT(@Company, ',') AS br;

            END;

        CREATE TABLE #Office
        ( OfficeId INT );

        IF ( @Office = 'All' )
            BEGIN

                INSERT #Office ( OfficeId )
                       SELECT pda.OfficeId
                       FROM   dbo.TfPersonDataAccessSel (@UserPersonId, 1) AS pda
                              INNER JOIN #Company AS o ON o.OrganizationId = pda.OrganizationId;
            END;
        ELSE
            BEGIN

                INSERT #Office ( OfficeId )
                       SELECT CAST(value AS INT)
                       FROM   STRING_SPLIT(@Office, ',') AS br;

            END;
        --SELECT *
        --FROM   #Office AS o;

        CREATE TABLE #fillRatio
        (   Company NVARCHAR (15) ,
            CompanyId INT ,
            Office NVARCHAR (100) ,
            OfficeId INT ,
            [CustomerId] INT ,
            Customer NVARCHAR (100) ,
            JobId INT ,
            [JobTitle] NVARCHAR (100) ,
            [Status] NVARCHAR (50) ,
            [DateEntered] DATE ,
            [StartDate] DATE ,
            [EndDate] DATE ,
            [Required] INT ,
            Placed INT ,
            [FillRatio] DECIMAL (10, 2) ,
            [Showed] DECIMAL (10, 2)
                DEFAULT 0.00 ,
            [ShowedRatio] DECIMAL (10, 2)
                DEFAULT 0.00 ,
            OrderBy INT );

        IF @DateType = 'InsertDate'
            BEGIN

                INSERT #fillRatio ( Company ,
                                    CompanyId ,
                                    Office ,
                                    OfficeId ,
                                    CustomerId ,
                                    Customer ,
                                    JobId ,
                                    JobTitle ,
                                    Status ,
                                    DateEntered ,
                                    [StartDate] ,
                                    [EndDate] ,
                                    Required ,
                                    Placed ,
                                    FillRatio ,
                                    Showed ,
                                    ShowedRatio )
                       SELECT   tjds.Alias ,
                                tjds.TenantOrganizationId ,
                                tjds.Office ,
                                o.OfficeId ,
                                tjds.OrganizationId ,
                                tjds.Organization ,
                                tjds.JobId ,
                                tjds.JobTitle ,
                                tjds.status ,
                                tjds.InsertDate ,
                                CONVERT (VARCHAR (11), tjds.StartDate, 101) ,
                                CONVERT (VARCHAR (11), tjds.EndDate, 101) ,
                                tjds.Required ,
                                tjds.Placed ,
                                ROUND (
                                    CASE WHEN tjds.Placed = 0 THEN 0
                                         ELSE
                                             CASE WHEN tjds.Required = 0 THEN 0
                                                  ELSE
                                                      CAST(tjds.Placed AS DECIMAL (10, 2))
                                                      / CAST(tjds.Required AS DECIMAL (10, 2))
                                             END
                                    END , --sasita:9/1/2022 fixed divided by 0 issue when required =0 ticket : 5619
                                    2) ,
                                x.showcount ,
                                CASE WHEN tjds.Placed = 0 THEN 0
                                     ELSE CAST(x.showcount AS DECIMAL (10, 2)) / CAST(tjds.Placed AS DECIMAL (10, 2))
                                END --sasita:9/1/2022 fixed divided by 0 issue if placed =0 ticket : 5619
                       FROM     dbo.TfJobDataSel (@UserPersonId) AS tjds
                                INNER JOIN #Office AS o ON o.OfficeId = tjds.OfficeId
                                INNER JOIN ( SELECT   tl.JobId ,
                                                      COUNT (DISTINCT tl.PersonId) showcount
                                             FROM     TransactionLink tl
                                                      INNER JOIN Job j ON j.JobId = tl.JobId
                                                      INNER JOIN dbo.TransactionFinance tf ON tf.TransactionId = tl.TransactionId
                                             WHERE    tl.TransactionBatchId IS NOT NULL
                                             AND      tf.TotalPay <> 0
                                             AND      CAST(j.InsertDate AS DATE) BETWEEN @StartDate AND @EndDate
                                             GROUP BY tl.JobId ) x ON x.JobId = tjds.JobId
                       WHERE    CAST(tjds.InsertDate AS DATE) BETWEEN @StartDate AND @EndDate
                       AND      tjds.Organization LIKE CASE WHEN @Customer = '%' THEN tjds.Organization
                                                            ELSE '%' + @Customer + '%'
                                                       END
                       ORDER BY tjds.Alias ,
                                tjds.Office ,
                                tjds.Organization;
            END;

        ELSE IF @DateType = 'ActiveJobDate'
                 BEGIN
                     INSERT #fillRatio ( Company ,
                                         CompanyId ,
                                         Office ,
                                         OfficeId ,
                                         CustomerId ,
                                         Customer ,
                                         JobId ,
                                         JobTitle ,
                                         Status ,
                                         DateEntered ,
                                         [StartDate] ,
                                         [EndDate] ,
                                         Required ,
                                         Placed ,
                                         FillRatio ,
                                         Showed ,
                                         ShowedRatio ,
                                         OrderBy )
                            SELECT tjds.Alias ,
                                   tjds.TenantOrganizationId ,
                                   tjds.Office ,
                                   o.OfficeId ,
                                   tjds.OrganizationId ,
                                   tjds.Organization ,
                                   tjds.JobId ,
                                   tjds.JobTitle ,
                                   tjds.status ,
                                   CONVERT (VARCHAR (11), CAST(tjds.InsertDate AS DATE), 101) ,
                                   CONVERT (VARCHAR (11), tjds.StartDate, 101) ,
                                   CONVERT (VARCHAR (11), tjds.EndDate, 101) ,
                                   tjds.Required ,
                                   tjds.Placed ,
                                   ROUND (
                                       CASE WHEN tjds.Placed = 0 THEN 0
                                            ELSE
                                                CASE WHEN tjds.Required = 0 THEN 0
                                                     ELSE
                                                         CAST(tjds.Placed AS DECIMAL (10, 2))
                                                         / CAST(tjds.Required AS DECIMAL (10, 2))
                                                END
                                       END , --sasita:9/1/2022 fixed divided by 0 issue when required =0 ticket : 5619
                                       2) ,
                                   x.showcount ,
                                   CASE WHEN tjds.Placed = 0 THEN 0
                                        ELSE
                                            CAST(x.showcount AS DECIMAL (10, 2)) / CAST(tjds.Placed AS DECIMAL (10, 2))
                                   END , --sasita:9/1/2022 fixed divided by 0 issue when placed =0 ticket : 5619
                                   1
                            FROM   dbo.TfJobDataSel (@UserPersonId) AS tjds
                                   LEFT JOIN dbo.Assignment AS a ON a.JobId = tjds.JobId
                                   INNER JOIN #Office AS o ON o.OfficeId = tjds.OfficeId
                                   LEFT JOIN ( SELECT   tl.JobId ,
                                                        COUNT (DISTINCT tl.PersonId) showcount
                                               FROM     TransactionLink tl
                                                        INNER JOIN Job j ON j.JobId = tl.JobId
                                                        INNER JOIN dbo.TransactionFinance tf ON tf.TransactionId = tl.TransactionId
                                               WHERE    tl.TransactionBatchId IS NOT NULL
                                               AND      tf.TotalPay <> 0
                                               AND      CAST(j.InsertDate AS DATE) BETWEEN @StartDate AND @EndDate
                                               GROUP BY tl.JobId ) x ON x.JobId = tjds.JobId
                            WHERE  a.JobId IS NULL
                            -- AND    tjds.EndDate IS NULL
                            AND    tjds.status = 'Active'
                            AND    tjds.Organization LIKE CASE WHEN @Customer = '%' THEN tjds.Organization
                                                               ELSE '%' + @Customer + '%'
                                                          END
                            UNION
                            SELECT tjds.Alias ,
                                   tjds.TenantOrganizationId ,
                                   tjds.Office ,
                                   o.OfficeId ,
                                   tjds.OrganizationId ,
                                   tjds.Organization ,
                                   tjds.JobId ,
                                   tjds.JobTitle ,
                                   tjds.status ,
                                   CONVERT (VARCHAR (11), CAST(tjds.InsertDate AS DATE), 101) ,
                                   CONVERT (VARCHAR (11), tjds.StartDate, 101) ,
                                   CONVERT (VARCHAR (11), tjds.EndDate, 101) ,
                                   tjds.Required ,
                                   tjds.Placed ,
                                   ROUND (
                                       CASE WHEN tjds.Placed = 0 THEN 0
                                            ELSE
                                                CASE WHEN tjds.Required = 0 THEN 0
                                                     ELSE
                                                         CAST(tjds.Placed AS DECIMAL (10, 2))
                                                         / CAST(tjds.Required AS DECIMAL (10, 2))
                                                END
                                       END , --sasita:9/1/2022 fixed divided by 0 issue when required =0 ticket : 5619
                                       2) ,
                                   x.showcount ,
                                   CASE WHEN tjds.Placed = 0 THEN 0
                                        ELSE
                                            CAST(x.showcount AS DECIMAL (10, 2)) / CAST(tjds.Placed AS DECIMAL (10, 2))
                                   END , --sasita:9/1/2022 fixed divided by 0 issue when placed =0 ticket : 5619
                                   2
                            FROM   dbo.TfJobDataSel (@UserPersonId) AS tjds
                                   LEFT JOIN dbo.Assignment AS a ON a.JobId = tjds.JobId
                                   INNER JOIN #Office AS o ON o.OfficeId = tjds.OfficeId
                                   INNER JOIN ( SELECT   tl.JobId ,
                                                         COUNT (DISTINCT tl.PersonId) showcount
                                                FROM     TransactionLink tl
                                                         INNER JOIN Job j ON j.JobId = tl.JobId
                                                         INNER JOIN dbo.TransactionFinance tf ON tf.TransactionId = tl.TransactionId
                                                WHERE    tl.TransactionBatchId IS NOT NULL
                                                AND      tf.TotalPay <> 0
                                                AND      CAST(j.InsertDate AS DATE) BETWEEN @StartDate AND @EndDate
                                                GROUP BY tl.JobId ) x ON x.JobId = tjds.JobId
                            WHERE  CAST(a.StartDate AS DATE) BETWEEN @StartDate AND @EndDate
                            AND    tjds.Organization LIKE CASE WHEN @Customer = '%' THEN tjds.Organization
                                                               ELSE '%' + @Customer + '%'
                                                          END
                            ORDER BY tjds.Alias ,
                                     tjds.Office ,
                                     tjds.Organization;




                 END;

        --SELECT *
        --FROM   #fillRatio AS fr;

        --DECLARE @ServerName VARCHAR (100) = @@SERVERNAME;
        --DECLARE @DBName VARCHAR (100) = DB_NAME ();
        --DECLARE @Logo VARCHAR (1000);



        --SELECT @Logo = DbURL.apiUrl + 'repository/'
        --               + CONCAT (CAST(t.TenantId AS VARCHAR (10)), dbo.SfNumericValueGet (t.InsertDate)) + '/'
        --               + 'reportlogo'
        --FROM   dbo.Tenant AS t
        --       CROSS APPLY ( SELECT oj.apiUrl AS apiUrl
        --                     FROM   dbo.TfOptionSel ('System', 'BaseUrl', 'Organization', t.OrganizationId) os
        --                            CROSS APPLY
        --                            OPENJSON (os.OptionValue)
        --                                WITH ( apiUrl VARCHAR (100) ,
        --                                       [server] VARCHAR (2000) ,
        --                                       databaseId INT ,
        --                                       databaseName VARCHAR (100)) AS oj
        --                     WHERE  oj.[server] = @ServerName
        --                     AND    ( oj.databaseName = @DBName )) AS DbURL;

        DECLARE @Logo VARCHAR (1000);
        SELECT @Logo = dbo.SfReportLogoURLGet () + dbo.SfOfficeStaffCompanyIdGet (@UserPersonId) + '/' + 'reportlogo';




        SELECT @Json = ISNULL (( SELECT ISNULL (@Logo, 'noImage') AS Logo ,
        --( SELECT   DISTINCT fr.Company ,
        --                    fr.CompanyId ,
        ( SELECT   fr2.Company ,
                   fr2.CompanyId ,
                   fr2.Office ,
                   fr2.OfficeId ,
                   fr2.CustomerId ,
                   fr2.Customer ,
                   fr2.JobId ,
                   fr2.JobTitle ,
                   fr2.Status ,
                   CONVERT (VARCHAR (11), CAST(fr2.DateEntered AS DATE), 101) DateEntered ,
                   CONVERT (VARCHAR (11), CAST(fr2.[StartDate] AS DATE), 101) StartDate ,
                   CONVERT (VARCHAR (11), CAST(fr2.[EndDate] AS DATE), 101) EndDate ,
                   fr2.Required ,
                   fr2.Placed ,
                   fr2.FillRatio ,
                   ISNULL (fr2.Showed, 0) Showed ,
                   fr2.ShowedRatio
          FROM     #fillRatio AS fr2
       --   WHERE    fr.CompanyId = fr2.CompanyId
          ORDER BY fr2.OrderBy ,
                   fr2.Company ,
                   fr2.Office ,
                   fr2.Customer ,
                   fr2.JobTitle ,
                   fr2.StartDate
        FOR JSON PATH, INCLUDE_NULL_VALUES ) AS fillRatioData
        --  FROM     #fillRatio AS fr
        --  ORDER BY fr.Company
        --FOR JSON PATH, INCLUDE_NULL_VALUES ) AS companyData
                               FOR JSON PATH, INCLUDE_NULL_VALUES ) ,
                               '[]');







        DROP TABLE #Office ,
                   #Company ,
                   #fillRatio;



    END;
GO

