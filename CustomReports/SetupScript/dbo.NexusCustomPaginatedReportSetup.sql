SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
;

--create by : Samiksha on 8/1/2023 for Nexus custom paginated reports setup
-- ===================================================================
-- Author      : sasita maharjan
-- Create date : 12/27/2019
-- Description : custom backup for paginated report setup 
-- ===================================================================

--For ZenopleMaster,Zenople And ZenopleLx use '\\10.6.0.121\share\TelerikReport'  
----For other Database in esgdbsrv.westus.cloudapp.azure.com server use'C:\'  
-- =============================================  

--DECLARE @Json1 NVARCHAR(MAX);  
--SET @Json1 = '{"personId":1,"applicationId":1,"roleId":1}';  
--EXEC dbo.SpSessionContextTsk @Json = @Json1;  
--EXEC dbo.PaginatedReportSetup  
ALTER PROCEDURE [dbo].[NexusCustomPaginatedReportSetup]
AS
    BEGIN

        SET NOCOUNT ON;

        BEGIN TRY
            BEGIN TRANSACTION;
            
            DECLARE @UserPersonId INT = dbo.SfPersonIdGet ();

            IF ( @UserPersonId = 0 )
                BEGIN
                    RAISERROR ('Insert person not found.', 4, 1);
                END;

            --Invoice Path        
            DECLARE @DatabasePath NVARCHAR (1000);
            DECLARE @InvoiceSamplePath NVARCHAR (1000);

            DECLARE @DBName VARCHAR (100) = DB_NAME ();

            SELECT @DatabasePath = CASE WHEN @DBName IN ( 'Zenople', 'ZenopleMaster', 'ScriptTest', 'other' ) THEN
                                            N'\\10.6.0.121\share\TelerikReport'
                                        ELSE N'C:\ReportSetupDNU\TelerikReport'
                                   END;

            SELECT @InvoiceSamplePath = CASE WHEN @DBName IN ( 'Zenople', 'ZenopleMaster', 'ScriptTest', 'other' ) THEN
                                                 N'\\10.6.0.121\share\ReportSample'
                                             ELSE N'C:\ReportSetupDNU\ReportSample'
                                        END;

            DECLARE @PaginatedReportReportTypeListItemId INT = dbo.SfListItemIdGet ('ReportType', 'PaginatedReport');
            DECLARE @PayCheckStyleReportTypeListItemId INT = dbo.SfListItemIdGet ('ReportType', 'PayCheckStyle');
            DECLARE @InvoiceStyleReportTypeListItemId INT = dbo.SfListItemIdGet ('ReportType', 'InvoiceStyle');

            DECLARE @ActiveStatusListItemId INT = dbo.SfListItemIdGet ('Status', 'Active');

            -- Data Types        
            DECLARE @DateListItemId INT = dbo.SfListItemIdGet ('DataType', 'Date') ,
                    @DateTimeListItemId INT = dbo.SfListItemIdGet ('DataType', 'Date') ,
                    @MultiSelectListItemId INT = dbo.SfListItemIdGet ('DataType', 'MultiSelect') ,
                    @SelectListItemId INT = dbo.SfListItemIdGet ('DataType', 'Select') ,
                    @StringListItemId INT = dbo.SfListItemIdGet ('DataType', 'String') ,
                    @NumberListItemId INT = dbo.SfListItemIdGet ('DataType', 'Number') ,
                    @DecimalListItemId INT = dbo.SfListItemIdGet ('DataType', 'Decimal') ,
                    @MoneyListItemId INT = dbo.SfListItemIdGet ('DataType', 'Money') ,
                    @BooleanListItemId INT = dbo.SfListItemIdGet ('DataType', 'Boolean');
            --SELECT @BooleanListItemId        
            DECLARE @HiddenListItemId INT = dbo.SfListItemIdGet ('Visibility', 'Hidden');
            DECLARE @VisibleListItemId INT = dbo.SfListItemIdGet ('Visibility', 'Visible') ,
                    @ReportOptionApplicationListItemId INT = dbo.SfListItemIdGet ('ReportOption', 'Application') ,
                    @ReportOptionApplicationAndShareableListItemId INT = dbo.SfListItemIdGet (
                                                                             'ReportOption' , 'ApplicationAndShareable') ,
                    @ReportOptionShareableListItemId INT = dbo.SfListItemIdGet ('ReportOption', 'Shareable');
            DECLARE @AccountingGLListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Accounting/GL') ,
                    @AccountsPayableListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'AccountsPayable') ,
                    @AccountsReceivableListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'AccountsReceivable') ,
                    @AdminListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Admin') ,
                    @CommonListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Common') ,
                    @CustomerListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Customer') ,
                    @EmployeeListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Employee') ,
                    @GrossProfitTransactionListItemId INT = dbo.SfListItemIdGet (
                                                                'ReportCategory' , 'GrossProfit/Transaction') ,
                    @InvoiceListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Invoice') ,
                    @JobAssignmentListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Job&Assignment') ,
                    @LogListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Log') ,
                    @PayrollListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Payroll') ,
                    @ProfitReportListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'ProfitReport') ,
                    @RecruitingOnboardingListItemId INT = dbo.SfListItemIdGet (
                                                              'ReportCategory' , 'Recruiting&Onboarding') ,
                    @TimesheetListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Timesheet') ,
                    @UnCategorizedListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'UnCategorized') ,
                    @UnemploymentListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Unemployment') ,
                    @UtilityListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Utility') ,
                    @VacationAccrualsListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'VacationAccruals') ,
                    @WorkInjuryListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'WorkInjury') ,
                    @YearEndListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'YearEnd');


         


            ---------------- --Report---------------------------  

			  DECLARE @Json VARCHAR (MAX);
--PersonResume
                SELECT @Json = '{"report" :"NexusPersonResume",        
     "description" :"This report generates the resume for the person that includes skill, employment, education, interview as per the records in the Zenople.",     
	 "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (10)) + ',
	 "processingMethod": "CUONexus_RpPersonResume",
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ',           
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + ', 
                  
     "reportParameter":[        
           {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "UserPersonId",        
          "parent":null,                            
        "description" :"UserPersonId",         
        "processingMethod" :null,         
        "sortOrder":1,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
         },        
             {         
                 
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PersonId",        
          "parent":null,                            
        "description" :"PersonId",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"in",         
         "required":1,                   
           "defaultValue":null        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":0,                   
            "defaultValue":null   
         }
         ]               
         }'     ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'NexusPersonResume';
         


            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                -- ROLLBACK TRANSACTION;
                THROW;
        END CATCH;

    END;





GO

