SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
/*
-- =============================================        
-- Author:  Sriti Prajapati        
-- Create date: 3/03/2019        
-- Description: setup for report         
-- Modified by:Sasita Maharjan     1/19/2021    
--For ZenopleMaster,Zenople And ZenopleLx use '\\10.6.0.121\share\'        
---- For other Database in esgdbsrv.westus.cloudapp.azure.com server use'C:\'        
-- =============================================    
--Modified by : Pratigya Thapa
--Modification: category added for all reports
--Modified Date: 7/21/2021
-- =============================================  

-- =============================================    
--Modified by : Dikshya
--Modification: renaming reportname,description,spname as per userstory 30242
--Modified Date: 11/24/2021
-- ============================================= 

  Last Modified: 3/3/2021>> setup fixes for XML updates and processing methods

Last Modified: 5/3/2021>> sasita visibility issue fix for entity columns 
  modified: sasita,pratigya,samiksha: 10/28/2021 added missing setups of standard reports
Modified: 12/10/2021 >> sasita added workercompcost setup 
 -- =============================================    
--Modified by : Manjil Munankarmi
--Modification: changed vacationAccruals to PTOAccruals, USER STORY 30260
--Modified Date: 12/14/2021
-- ============================================= 
 -- =============================================    
--Modified by : Sasita
--Modification: added description in each report setup
--Modified Date: 12/14/2021
-- ============================================= 
 -- =============================================    
--Modified by : Sasita
--Modification: renamed category key to categoryListItemId key
--Modified Date: 12/15/2021
-- ============================================= 
 -- =============================================    
--Modified by : Sasita
--Modification: renamed category key to categoryListItemId key
--Modified Date: 12/15/2021
-- =============================================
 -- =============================================    
--Modified by : Sasita
--Modification: added IsDDExceptEmail Parameter in Paycheck and PaycheckMiddle
--Modified Date: 6/9/2022
-- =============================================
/*
DECLARE @Json1 NVARCHAR(MAX);        
SET @Json1 = '{"personId":1,"applicationId":1,"roleId":1}';        
EXEC dbo.SpSessionContextTsk @Json = @Json1;        
EXEC dbo.PaginatedReportSetup   
      
			 send report categoryListItemId property and value from here for each report to assign the categoryListItemId        
			 eg: {        
			 {"report" :"ARAging",        
			 "description" :"AR Aging",        
			 "reportTypeListItemId": 12,        
			 "categoryListItemId":"Employee"        
			 }        
        
			 -- if not send, Uncategorized categoryListItemId will be assigned 
			 
			 /* reportoptionListItemId */

--categoryListItemId : ReportOption

--ListItem :

--1) Application : report that will be run from Other Application but not from RMS
--2) ApplicationAndShareable : both RMS and other Application
--3) Shareable: only in RMS

/* reportoption End */

/*Report List in ATM */

--For Report List in ATM: ApplicationAndShareable and Shareable  reportoption type is only pulled
*/
 

*/


ALTER PROCEDURE [dbo].[PaginatedReportSetup]
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
                    @PTOAccrualsListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'PTOAccruals') ,
                    @WorkInjuryListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'WorkInjury') ,
                    @YearEndListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'YearEnd');


            ---------------- --Report---------------------------  
            DECLARE @Json VARCHAR (MAX);


            BEGIN
                SELECT @Json = '{"report" :"ARAging",        
     "description" :"This report provides the aging balance for all invoices grouped by customers based on the date provided. The aging buckets used are Current, 1-30, 31-60, 61-90, and over 90 days. This report can be further filtered by office and customers.",        
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',  
	 "categoryListItemId":' + CAST(@AccountsReceivableListItemId AS VARCHAR (MAX)) + ',
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ',    
							       
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "processingMethod" :"RpInvoiceDueDateSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":0,                  
        "defaultValue":[{"key":"DateType","value":"DueDate","isParameter":1}]        
        }, 
          {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "AsOfDate",        
          "parent":null,                            
        "description" :"AsOfDate",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
                 
                
          {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
          "description" :"Company",        
          "processingMethod" :"RpOrganizationSel",          
          "sortOrder":4,        
          "operator":"in",         
          "required":1,                
          "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
         "parent":"Company",        
         "description" :"Office",         
         "processingMethod" :"RpOfficeByOrganizationSel",        
         "sortOrder":5,        
         "operator":"in",         
         "required":0,                   
         "defaultValue":null        
        },        
         {         
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "GroupBy",         
        "parent":null,                     
         "description" :"GroupBy",        
        "processingMethod" :"RpArAgingGroupBySel",         
           "sortOrder":6,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":null        
        },        
               
        {         
        "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Customer",         
        "parent":null,        
        "processingMethod" :null,         
           "sortOrder":7,        
           "operator":"equals",         
        "required":0,                  
        "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]        
        }  ,  
							      { 
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',		
								"column": "ShowSummary", 
							    "description" :"Show Summary",
								"processingMethod" :"RpTrueFalseSel",	
							    "sortOrder":8,
							    "operator":"equals",	
								"required":1,						    
								"defaultValue":null
								} 
								,{ 
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',		
								"column": "RollUpToParentCustomer", 
							    "description" :"Roll Up to Parent Customer",
								"processingMethod" :"RpYesNoSel",	
							    "sortOrder":9,
							    "operator":"equals",	
								"required":1,						    
								"defaultValue":[{"key":"RollUpToParentCustomer","value":"False","isParameter":1}] 
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
           "sortOrder":10,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
            }          
          ]        
         
          }'    ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json;
                PRINT 'ARAging';

                SELECT @Json = '{"report" :"ARBatch",
					"description" :"This reports prints after posting of AR payment batch. It includes all the payments in a batch and also be run for specific customers in a given a date range.",
					"categoryListItemId":' + CAST(@AccountsReceivableListItemId AS VARCHAR (MAX))
                               + ',
					"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',
					"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,
							     
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
							  
							    "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							    "column": "ARBatchId",
							   "parent":null,						   							    
								"description" :"ARBatchId",	
								"processingMethod" :null,	
								"sortOrder":2,
							    "operator":"equals",	
								 "required":1,											
							    "defaultValue":[{"key":"ARBatchId","value":0,"isParameter":1}]
							  },
							  	  {         
						 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "DateType",         
						 "parent":null,        
							"description" :"Date Type",	
						 "processingMethod" :"RpPostAccountingPeriodDateSel",         
						    "sortOrder":2,        
						    "operator":"equals",         
						 "required":0,                  
						 "defaultValue":[{"key":"DateType","value":"AccountingPeriodDate","isParameter":1}]        
						 },
							   { 
							   "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							    "column": "StartDate",
							   "parent":null,						   							    
								"description" :"Start Date",	
								"processingMethod" :null,	
								"sortOrder":3,
							    "operator":"equals",	
								 "required":0,											
							    "defaultValue":null
							  
							  },
							  { 
							   "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							    "column": "EndDate",
							   "parent":null,						   							    
								"description" :"End Date",	
								"processingMethod" :null,	
								"sortOrder":4,
							    "operator":"equals",	
								 "required":0,											
							    "defaultValue":null
							  
							  },
						
						 { 
						"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							   "column": "Company",
							   "parent":null, 						    
								"description" :"Company",
								"processingMethod" :"RpOrganizationSel",		
								"sortOrder":5,
								"operator":"in",	
								"required":0,								
							    "defaultValue":null
							  },
							  { 
							   "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							  "column": "Office",
							   "parent":"Company",		   
							   "description" :"Office",	
							   "processingMethod" :"RpOfficeByOrganizationSel",
							    "sortOrder":6,
							   "operator":"in",	
								"required":0,							    
								"defaultValue":null
								},													
								{ 
							    "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							   "column": "Customer",
							   "parent":null, 						    
								"description" :"Customer",
								"processingMethod" :null,		
								"sortOrder":7,
								"operator":"contains",	
								"required":0,								
							    "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]
							  },{     

              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',    
           "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',     
              "column": "ReportId",    
             "parent":null,                        
           "description" :"Report Id",     
           "processingMethod" :null,     
           "sortOrder":8,    
              "operator":"equals",     
            "required":0,               
              "defaultValue":null    
            }     
								 
							  ]
							  }';
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json;
                PRINT 'ARBatch';

                --PayCheck
                SELECT @Json = '{"report" :"PayCheck",        
     "description" :"This is a  paycheck report that provides transaction details including taxes, deductions, benefits, banks, and accruals. In case of a live check, the MICR line and a signature will be viewed during printing only with a check in the bottom section.",
	 "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX)) + ',      
     "reportTypeListItemId":' + CAST(@PayCheckStyleReportTypeListItemId AS VARCHAR (10))
                               + ',    
							   
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,        
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
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
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "CallPurpose",        
          "parent":null,                            
        "description" :"Call Purpose",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"CallPurpose","value":"PayCheck","isParameter":1}]        
         },        
          {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentBatchId",        
          "parent":null,                            
        "description" :"PaymentBatchId",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentBatchId","value":"0","isParameter":1}]        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentId",        
          "parent":null,                            
        "description" :"PaymentId",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentId","value":"0","isParameter":1}]        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PrintType",        
          "parent":null,                    
        "description" :"Print Type",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"PrintType","value":"Both","isParameter":1}]        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@BooleanListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "DisplayMICR",        
          "parent":null,                            
        "description" :"Display MICR",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"DisplayMICR","value":"false","isParameter":1}]        
         },        
          {         
                 
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "SortOrder1",        
          "parent":null,                            
        "description" :"Sort Order 1",         
        "processingMethod" :"RpPaycheckSortTypeSel",         
        "sortOrder":7,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"SortOrder1","value":"FirstName,LastName","isParameter":1}]        
         },
		 {         
                 
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "SortOrder2",        
          "parent":null,                            
        "description" :"Sort Order 2",         
        "processingMethod" :"RpPaycheckSortTypeSel",         
        "sortOrder":8,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"SortOrder2","value":"Customer","isParameter":1}]        
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
        "sortOrder":9,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@BooleanListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "IsDDExceptEmail",        
          "parent":null,                            
        "description" :"Is DD Except Email",         
        "processingMethod" :null,         
        "sortOrder":10,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"IsDDExceptEmail","value":"false","isParameter":1}]        
         }        
         ]        
         }'     ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'PayCheck';


                --PayrollRegister
                SELECT @Json = '{"report" :"PayrollRegister",        
     "description" :"This report shows all paychecks in a given date range that includes detailed level transactions, taxes, contributions, deductions, accruals, and bank information.  It can be further filtered in summary only level.",
	 "categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (10)) + ',   
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ',    
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
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentBatchId",        
          "parent":null,                            
        "description" :"PaymentBatchId",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentBatchId","value":"0","isParameter":1}]        
         },        
       
         {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":3,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },        
        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
                 
         },        
          {         
                 
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "CallPurpose",        
          "parent":null,                            
        "description" :"Call Purpose",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"CallPurpose","value":"CheckRegister","isParameter":1}]        
         },        
         {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
        "description" :"Company",        
        "processingMethod" :"RpOrganizationSel",          
         "sortOrder":7,        
           "operator":"in",         
         "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
          "parent":"Company",        
                  
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":8,        
          "operator":"in",         
         "required":0,                   
        "defaultValue":null        
        },        
             
        {         
        "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "SSN",         
        "parent":null,        
           "description" :"SSN",        
        "processingMethod" :null,         
           "sortOrder":9,        
           "operator":"contains",         
        "required":0,                   
        "defaultValue":[{"key":"SSN","value":"%","isParameter":1}]        
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
        "sortOrder":10,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }     ,          
           {           
              "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Customer",          
             "parent":null,                     
           "description" :"Customer",          
           "processingMethod" :null,            
           "sortOrder":11,          
           "operator":"contains",           
           "required":0,                  
              "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]          
            },  
				{ 
					"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
					"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',		
					"column": "ShowSummary", 
				    "description" :"Show Summary",
					"processingMethod" :"RpTrueFalseSel",	
				    "sortOrder":12,
				    "operator":"equals",	
					"required":1,						    
					"defaultValue":null
								}        
         ]        
        
          }'    ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'PayrollRegister';


                --PayrollJournal
                SELECT @Json = '{"report" :"PayrollJournal",        
     "description" :"This report shows all paychecks in a given date range that includes a summarized level of transactions, taxes, contributions, deductions, accruals, and bank information. It can be further filtered in summary only level.",    
	 "categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (10)) + ',
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,       
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },        
        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
         {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "PaymentType",         
        "parent":null,        
           "description" :"PaymentType",        
        "processingMethod" :"RpPaymentTypeSel",         
           "sortOrder":5,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"PaymentType","value":"Both","isParameter":1}]        
        },        
         {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Organization",        
          "parent":null,                   
        "description" :"Organization",        
        "processingMethod" :"RpOrganizationSel",          
         "sortOrder":6,        
           "operator":"in",         
         "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
          "parent":"Organization",        
                  
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":7,        
          "operator":"in",         
         "required":0,                   
        "defaultValue":null        
        },                                          
        {         
        "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "SSN",         
        "parent":null,        
           "description" :"SSN",        
        "processingMethod" :null,         
           "sortOrder":8,        
           "operator":"contains",         
        "required":0,                   
        "defaultValue":[{"key":"SSN","value":"%","isParameter":1}]        
        },        
                
        {         
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Bank",         
        "parent":null,        
           "description" :"Bank",        
        "processingMethod" :"RpBankSel",         
           "sortOrder":9,        
           "operator":"in",         
        "required":0,                   
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
        "sortOrder":10,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         },        
         {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "ShowSummary",         
                
                
           "description" :"Show Summary",        
        "processingMethod" :"RpTrueFalseSel",         
"sortOrder":11,        
           "operator":"equals",   
        "required":1,                  
        "defaultValue":null        
        }        
         ]        
         }'     ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'PayrollJournal';

                --PaymentBatch
                SELECT @Json = '{"report" :"PaymentBatch",        
     "description" :"This report prints after posting the payment batch. It includes all the payments in a batch.", 
	 "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX)) + ',     
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,     
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Entity",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"Entity",        
        "processingMethod" :null,         
           "sortOrder":2,        
           "operator":"equals",         
        "required":0,                   
        "defaultValue":[{"key":"Entity","value":"PaymentBatch","isParameter":1}]         
        },        
        {         
        "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "EntityId",         
        "parent":null,        
           "description" :"Payment BatchId",        
        "processingMethod" :null,         
           "sortOrder":3,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":[{"key":"EntityId","value":0,"isParameter":1}]        
        },    
		
		 {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":4,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },
        {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "StartDate",        
        "parent":null,                            
        "description" :"Start Date",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "EndDate",                
		   "parent":null,                            
        "description" :"End Date",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
                 
         },        
         {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
        "description" :"Company",        
        "processingMethod" :"RpOrganizationSel",          
         "sortOrder":7,        
           "operator":"in",         
         "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
          "parent":"Company",        
                  
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":8,        
          "operator":"in",         
         "required":0,                   
        "defaultValue":null        
        },        
        
           
        {         
                 
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "SortBy",        
          "parent":null,                            
        "description" :"Sort By",         
        "processingMethod" :"RpPaymentBatchSortTypeSel",         
        "sortOrder":9,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } ,        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":10,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }        
         ]        
         }'     ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'PaymentBatch';




                --PersonResume
                SELECT @Json = '{"report" :"PersonResume",        
     "description" :"This report generates the resume for the person that includes skill, employment, education, interview as per the records in the Zenople.",     
	 "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (10)) + ',
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
                PRINT 'PersonResume';

                --InvoiceBatch
                SELECT @Json = '{"report" :"InvoiceBatch",        
     "description" :"This report prints after posting of invoice batch. It includes all the invoices in a batch and also runs for specific customers in a given date range.",   
	 "categoryListItemId":' + CAST(@InvoiceListItemId AS VARCHAR (10)) + ',  
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + '      ,      
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Entity",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"Entity",        
        "processingMethod" :null,         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":[{"key":"Entity","value":"InvoiceBatch","isParameter":1}]        
        },        
        {         
        "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "EntityId",         
        "parent":null,        
           "description" :"Invoice BatchId",        
        "processingMethod" :null,         
           "sortOrder":3,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":[{"key":"EntityId","value":0,"isParameter":1}]        
        }, 
		 {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,                      
           "description" :"Date Type",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":4,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":[{"key":"Category","value":"InvoiceDateType","isParameter":1}]        
        }, 
        {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
                 
         },        
         {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
        "description" :"Company",        
        "processingMethod" :"RpOrganizationSel",          
         "sortOrder":7,        
           "operator":"in",         
         "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
          "parent":"Company",        
                  
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":8,        
          "operator":"in",         
         "required":0,                   
        "defaultValue":null        
        },        
         
            
        {         
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Customer",        
          "parent":null,                   
        "description" :"Customer",        
        "processingMethod" :null,          
        "sortOrder":9,        
        "operator":"contains",         
        "required":0,                
           "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]        
         }  ,        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":10,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }       
         ]        
        
         }'     ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'InvoiceBatch';

                --PayCheckMiddle
                SELECT @Json = '{"report" :"PayCheckMiddle",        
     "description" :"This is a  paycheck report that provides transaction details including taxes, deductions, benefits, banks, and accruals. In case of a live check, the MICR line, and a signature will be viewed during printing only along with a check in the middle section.",    
	 "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX)) + ',
     "reportTypeListItemId":' + CAST(@PayCheckStyleReportTypeListItemId AS VARCHAR (10))
                               + ',    
							   
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,        
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
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
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "CallPurpose",        
          "parent":null,                            
        "description" :"Call Purpose",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"CallPurpose","value":"PayCheck","isParameter":1}]        
         },        
          {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentBatchId",        
          "parent":null,                            
        "description" :"PaymentBatchId",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentBatchId","value":"0","isParameter":1}]        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentId",        
          "parent":null,                            
        "description" :"PaymentId",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentId","value":"0","isParameter":1}]        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PrintType",        
          "parent":null,                    
        "description" :"Print Type",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"PrintType","value":"Both","isParameter":1}]        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@BooleanListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "DisplayMICR",        
          "parent":null,                            
        "description" :"Display MICR",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"DisplayMICR","value":"false","isParameter":1}]        
         },        
          {         
                 
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "SortOrder1",        
          "parent":null,                            
        "description" :"Sort Order 1",         
        "processingMethod" :"RpPaycheckSortTypeSel",         
        "sortOrder":7,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"SortOrder1","value":"FirstName,LastName","isParameter":1}]        
         },
		 {         
                 
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "SortOrder2",        
          "parent":null,                            
        "description" :"Sort Order 2",         
        "processingMethod" :"RpPaycheckSortTypeSel",         
        "sortOrder":8,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"SortOrder2","value":"Customer","isParameter":1}]        
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
        "sortOrder":9,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } ,        
         {         
                 
           "dataTypeListItemId":' + CAST(@BooleanListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "IsDDExceptEmail",        
          "parent":null,                            
        "description" :"Is DD Except Email",         
        "processingMethod" :null,         
        "sortOrder":10,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"IsDDExceptEmail","value":"false","isParameter":1}]        
         }          
         ]        
         }'     ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'PayCheckMiddle';

                --TransactionBatch
                SELECT @Json = '{"report" :"TransactionBatch",          
        "description" :"This report shows detailed timesheet information including hours, transaction code, units, and margin. This report can also be used to verify, confirm, and process transactions.", 
		"categoryListItemId":' + CAST(@TimesheetListItemId AS VARCHAR (MAX))
                               + ',      
        "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
        "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,       
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
                      
              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "TransactionBatchId",          
             "parent":null,                              
           "description" :"TransactionBatchId",           
           "processingMethod" :null,           
           "sortOrder":2,          
              "operator":"equals",           
            "required":1,                     
              "defaultValue":[{"key":"TransactionBatchId","value":0,"isParameter":1}]          
            },          
             {           
             "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "StartDate",          
             "parent":null,                              
           "description" :"StartDate",           
           "processingMethod" :null,           
           "sortOrder":3,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
                      
            },          
            {           
             "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "EndDate",          
             "parent":null,                              
           "description" :"EndDate",           
           "processingMethod" :null,           
           "sortOrder":4,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
                      
            },          
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Company",          
             "parent":null,                     
           "description" :"Company",          
           "processingMethod" :"RpOrganizationSel",            
           "sortOrder":5,          
           "operator":"in",           
           "required":0,                  
              "defaultValue":null          
            },          
            {           
             "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
            "column": "Office",          
             "parent":"Company",               
             "description" :"Office",           
             "processingMethod" :"RpOfficeByOrganizationSel",          
              "sortOrder":6,          
             "operator":"in",           
           "required":0,                     
           "defaultValue":null          
           },          
                  
                   
           {           
              "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Customer",          
             "parent":null,                     
           "description" :"Customer",          
           "processingMethod" :null,            
           "sortOrder":7,          
           "operator":"contains",           
           "required":0,                  
              "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]          
            },          
             {           
                      
              "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "Sortby",          
             "parent":null,                              
           "description" :"Sort By",           
           "processingMethod" :"RpSortTypeSel",           
           "sortOrder":8,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":[{"key":"Sortby","value":"Customer","isParameter":1}]          
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
           "sortOrder":9,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
            }          
            ]          
            }'  ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'TransactionBatch';


                --AgencyPaycheck
                SELECT @Json = '{"report" :"AgencyPayCheck",        
     "description" :"This is a check designed which is used to pay the agencies.",        
     "reportTypeListItemId":' + CAST(@PayCheckStyleReportTypeListItemId AS VARCHAR (10))
                               + ',     
	 "categoryListItemId":' + CAST(@AccountsPayableListItemId AS VARCHAR (MAX)) + ',
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,      
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
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
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "CallPurpose",        
          "parent":null,                            
        "description" :"Call Purpose",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"CallPurpose","value":"PayCheck","isParameter":1}]        
         },        
          {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentBatchId",        
          "parent":null,                            
        "description" :"PaymentBatchId",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentBatchId","value":"0","isParameter":1}]        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentId",        
          "parent":null,                            
        "description" :"PaymentId",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentId","value":"0","isParameter":1}]        
         },        
         {         
                 
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PrintType",        
          "parent":null,                            
        "description" :"Print Type",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"PrintType","value":"Both","isParameter":1}]        
         },        
         {         
                 
    "dataTypeListItemId":' + CAST(@BooleanListItemId AS VARCHAR (MAX)) + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "DisplayMICR",        
          "parent":null,                            
        "description" :"Display MICR",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":[{"key":"DisplayMICR","value":"false","isParameter":1}]        
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
        "sortOrder":7,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }        
         ]        
         }'     ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'AgencyPayCheck';

                --DeductionSubmittal
                SELECT @Json = '{"report" :"DeductionSubmittal",        
     "description" :"This report shows all deductions that were paid to the agencies along with employee information and case information/reference. It is designed to be submitted along with the agency check that was generated.",   
	 "categoryListItemId":' + CAST(@AccountsPayableListItemId AS VARCHAR (MAX)) + ',  
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,      
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
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
        
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentBatchId",        
          "parent":null,                            
        "description" :"PaymentBatchId",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentBatchId","value":0,"isParameter":1}]        
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
         } ,        
          {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":4,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date(AP)",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
        
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date(AP)",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
        
         },        
          {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
        "description" :"Company",        
        "processingMethod" :"RpOrganizationSel",          
        "sortOrder":7,        
        "operator":"in",         
        "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
          "parent":"Company",             
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":8,        
          "operator":"in",         
        "required":0,                   
        "defaultValue":null        
        }  
         ]        
         }'     ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'DeductionSubmittal';

                --Please dont change the name of TaskReport , this name is used in UI so it will affect the report execution.
                SELECT @Json = ' {"report" :"TaskReport",        
     "description" :"This report lists out all the tasks shown on the screen for printing purposes based on the filters.",        
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
          "categoryListItemId":' + CAST(@CommonListItemId AS VARCHAR (10)) + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,         
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
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
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
                
        ]          
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'TaskReport';

                ---Statement Report        
                SELECT @Json = '[ {"report" :"Statement",          
     "description" :"This report shows all invoices with open balances grouped by the customer. It can further be filtered for a specific customer. It can also be filtered to only show past due.",           
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
          "categoryListItemId":' + CAST(@InvoiceListItemId AS VARCHAR (10)) + ',          
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,  
		"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
          "column": "Customer",          
          "parent":null,                     
        "description" :"Customer",          
        "processingMethod" :null,            
         "sortOrder":3,          
           "operator":"contains",           
         "required":0,                  
           "defaultValue":null         
         },{           
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "OrganizationId",          
          "parent":null,                     
        "description" :"OrganizationId",          
        "processingMethod" :null,            
         "sortOrder":2,          
           "operator":"equals",           
         "required":0,                  
           "defaultValue":[{"key":"OrganizationId","value":"0","isParameter":1}]          
         } ,        
   {           
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',          
       "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "Include",          
          "parent":null,                     
        "description" :"Include",          
        "processingMethod" :"RpIncludeTypeSel",            
         "sortOrder":4,          
           "operator":"equals",           
         "required":1,                  
           "defaultValue":null   
         } ,        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }        
                   
                  
                  
        ]            
        }]'     ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json; -- varchar(max)          
                PRINT 'Statement';

                --Invoice
                SELECT @Json = '{"report" :"Invoice",        
     "description" :"This report is an invoice statement provided to the customer for all the transactions done during the billing period.",     
	 "categoryListItemId":' + CAST(@InvoiceListItemId AS VARCHAR (10)) + ',
     "reportTypeListItemId":' + CAST(@InvoiceStyleReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ',        
                   
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
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
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Category",         
        "parent":null,        
           "description" :"Category",        
        "processingMethod" :null,         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":[{"key":"Category","value":"ReportInvoiceEntity","isParameter":1}]        
        },        
         {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Entity",         
        "parent":"Category",        
           "description" :"Entity",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":3,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":null        
        },        
        {         
        "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "EntityId",         
        "parent":null,        
           "description" :"EntityId",        
        "processingMethod" :null,         
           "sortOrder":4,        
           "operator":"equals",         
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
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }        
        ]        
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'Invoice';

                --InvoicewithJobPosition
                SELECT @Json = '{"report" :"InvoicewithJobPosition",        
     "description" :"This report is an invoice statement provided to the customer for all the transactions done during the billing period with the job title.",
	 "categoryListItemId":' + CAST(@InvoiceListItemId AS VARCHAR (10)) + ',        
     "reportTypeListItemId":' + CAST(@InvoiceStyleReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ',        
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
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
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
      "column": "Category",         
        "parent":null,        
           "description" :"Category",        
        "processingMethod" :null,         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":[{"key":"Category","value":"ReportInvoiceEntity","isParameter":1}]        
        },        
         {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Entity",         
        "parent":"Category",        
           "description" :"Entity",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":3,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":null        
        },        
        {         
        "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "EntityId",         
        "parent":null,        
           "description" :"EntityId",        
        "processingMethod" :null,         
           "sortOrder":4,        
           "operator":"equals",         
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
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }        
        ]        
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'InvoicewithJobPosition';


                --WorkerCompCostWithHours
                SELECT @Json = '{"report" :"WorkerCompCostWithHours",          
     "description" :"This report shows total worker comp wages, rates, and costs with hours.",          
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
          "categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (10))
                               + ',          
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,          
                     
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
         },{           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "StartDate",          
          "parent":null,                              
        "description" :"Start Date(AP)",            
        "processingMethod" :null,           
        "sortOrder":2,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         },          
         {           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "EndDate",          
          "parent":null,                              
        "description" :"End Date(AP)",        
        "processingMethod" :null,           
        "sortOrder":3,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         },
           {           
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "Organization",          
          "parent":null,                     
        "description" :"Company",          
        "processingMethod" :"RpOrganizationSel",            
         "sortOrder":4,          
           "operator":"in",           
         "required":0,                  
           "defaultValue":null          
         },{           
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
         "column": "Office",          
          "parent":"Organization",          
                    
          "description" :"Office",           
          "processingMethod" :"RpOfficeByOrganizationSel",          
           "sortOrder":5,          
          "operator":"in",           
         "required":0,                     
        "defaultValue":null          
        },        
   {           
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "CustomerOrganization",          
          "parent":null,                     
        "description" :"Customer",          
        "processingMethod" :null,            
        "sortOrder":6,          
        "operator":"contains",           
        "required":0,                  
           "defaultValue":[{"key":"CustomerOrganization","value":"%","isParameter":1}]          
         }   ,{     

              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',    
           "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',     
              "column": "ReportId",    
             "parent":null,                        
           "description" :"Report Id",     
           "processingMethod" :null,     
           "sortOrder":7,    
              "operator":"equals",     
            "required":0,               
              "defaultValue":null    
            }      
                   
                  
                  
        ]            
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json; -- varchar(max)        
                PRINT 'WorkerCompCostWithHours';


                --AccruedHours
                SELECT @Json = '{"report" :"AccruedHours",          
"description" :"This report shows the total hours per employee in a given date range. This report can be further filtered to show accrued hours for the specific client, or specific employee. This report could be used to identify the employee benefits based on accrued hours.",          
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
  "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX)) + ',   
  "isSytem":      ' + CAST(1 AS VARCHAR (10)) + ' ,
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,      
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },{           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "StartDate",          
          "parent":null,                              
        "description" :"Start Date (AP/CK)",           
        "processingMethod" :null,           
        "sortOrder":3,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         },{           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "EndDate",          
          "parent":null,                              
        "description" :"End Date (AP/CK)",           
        "processingMethod" :null,           
        "sortOrder":4,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         } ,{           
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "Organization",          
          "parent":null,                     
        "description" :"Company",          
        "processingMethod" :"RpOrganizationSel",            
         "sortOrder":5,          
           "operator":"in",           
         "required":0 ,                  
           "defaultValue":null          
         },{           
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
         "column": "Office",          
          "parent":"Organization",          
                    
          "description" :"Office",           
          "processingMethod" :"RpOfficeByOrganizationSel",          
           "sortOrder":6,          
          "operator":"in",           
         "required":0,                     
        "defaultValue":null          
        },        
          {   
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',  
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',   
          "column": "OnAssignment",  
          "parent":null,             
        "description" :"OnAssignment",  
        "processingMethod" :"RpOnAssignmentSel",    
         "sortOrder":7,  
           "operator":"equals",   
         "required":0,          
           "defaultValue":null
         }, {           
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "EmployeeName",          
          "parent":null,                     
        "description" :"Employee Name",          
        "processingMethod" :null,            
        "sortOrder":8,          
        "operator":"contains",           
        "required":0,                  
           "defaultValue":[{"key":"EmployeeName","value":"%","isParameter":1}]          
         } ,
         {           
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "Customer",          
          "parent":null,                     
        "description" :"Customer",          
        "processingMethod" :null,            
        "sortOrder":9,          
        "operator":"contains",           
        "required":0,                  
           "defaultValue":[{"key":"CustomerOrganization","value":"%","isParameter":1}]          
         },        
       
    
           {           
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "TotalHours",          
    "parent":null,                     
        "description" :"Total Hours",          
        "processingMethod" :null,            
        "sortOrder":10,          
        "operator":"greaterthanorequal",           
        "required":0,                  
         "defaultValue":[{"key":"TotalHours","value":"0.00","isParameter":1}]          
         }   ,{     

              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',    
           "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',     
              "column": "ReportId",    
             "parent":null,                        
           "description" :"Report Id",     
           "processingMethod" :null,     
           "sortOrder":11,    
              "operator":"equals",     
            "required":0,               
              "defaultValue":null    
            }          
                  
                  
        ]            
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json;
                PRINT 'AccruedHours';


                   --DeductionSummary
                SELECT @Json = '{"report" :"DeductionSummary",          
         "description" :"This report shows employees'' deductions in a given date range at a summary level.",      
		 "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX)) + ',
         "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
         "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ',           
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "StartDate",          
              "parent":null,                              
            "description" :"Start Date",           
            "processingMethod" :null,           
            "sortOrder":2,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },          
             {           
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "EndDate",          
              "parent":null,                              
            "description" :"End Date",           
            "processingMethod" :null,           
            "sortOrder":3,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },   
			 
			  {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":4,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },     
                       
             {           
               "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "Company",          
              "parent":null,                     
            "description" :"Company",          
            "processingMethod" :"RpOrganizationSel",            
             "sortOrder":5,          
               "operator":"in",           
             "required":0,                  
               "defaultValue":null          
             },          
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Office",          
              "parent":"Company",            
              "description" :"Office",           
              "processingMethod" :"RpOfficeByOrganizationSel",          
               "sortOrder":6,          
              "operator":"in",           
             "required":0,                     
            "defaultValue":null          
            } ,
			{        
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
               + ',      
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',        
        "column": "DeductionCode",        
        "parent":null,      

           "description" :"DeductionCode",      
        "processingMethod" :"RpTransactionCodeSel",        
           "sortOrder":7,      
           "operator":"in",        
        "required":0,                
        "defaultValue":null      
        }, {        
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
               + ',      
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',        
        "column": "GroupBy",        
        "parent":null,      

           "description" :"Group By",      
        "processingMethod" :"RpOfficeGroupBySel",        
           "sortOrder":8,      
           "operator":"equals",        
        "required":1,                
        "defaultValue":[{"key":"GroupBy","value":"None","isParameter":1}]  }    ,
            {           
                      
              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "ReportId",          
             "parent":null,                              
           "description" :"Report Id",           
           "processingMethod" :null,           
           "sortOrder":9,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
            }        
            ]}' ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'DeductionSummary';

                --BenefitSummary
                SELECT @Json = ' {"report" :"BenefitSummary",          
         "description" :"This report shows employer benefit contribution amounts grouped by benefit code in a given date range at a summary level.", 
		 "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',       
         "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
         "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ',         
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },
             {           
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "StartDate",          
              "parent":null,                              
            "description" :"Start Date",           
            "processingMethod" :null,           
            "sortOrder":3,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },          
             {           
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "EndDate",          
              "parent":null,                              
            "description" :"End Date",           
            "processingMethod" :null,           
            "sortOrder":4,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },  
			
                       
             {           
               "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "Organization",          
              "parent":null,                     
            "description" :"Organization",          
            "processingMethod" :"RpOrganizationSel",            
             "sortOrder":5,          
              "operator":"in",           
             "required":0,                  
               "defaultValue":null          
             },          
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Office",          
              "parent":"Organization",            
              "description" :"Office",           
              "processingMethod" :"RpOfficeByOrganizationSel",          
               "sortOrder":6,          
              "operator":"in",           
             "required":0,                     
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
           "sortOrder":7,    
              "operator":"equals",     
            "required":0,               
              "defaultValue":null    
            }         
            ]          
            }'  ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'BenefitSummaryReport';
                --InvoiceRegister
                SELECT @Json = '{"report" :"InvoiceRegister",        
     "description" :"This report shows detailed invoice information generated in a given date range along with discounts, charges, invoice amount, payment amount, and balance.", 
	 "categoryListItemId":' + CAST(@InvoiceListItemId AS VARCHAR (10)) + ',     
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,        
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"InvoiceDateType","isParameter":1}]        
        },        
        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date(AP)",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date(AP)",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
                 
         {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Organization",        
          "parent":null,                   
        "description" :"Organization",        
        "processingMethod" :"RpOrganizationSel",          
         "sortOrder":5,        
           "operator":"in",         
         "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
      "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
          "parent":"Organization",        
                  
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":6,        
          "operator":"in",         
         "required":0,                   
        "defaultValue":null        
        } ,        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":7,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }  
         ]        
         }'     ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'InvoiceRegister';


             
                --PaymentDeduction
               SELECT @Json = '{"report" :"PaymentDeduction",        
     "description" :"This report shows the deduction amount withheld from an employee''s paycheck. It includes agency information and case information/references for the given date range.",    
	 "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX)) + ',
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,     
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
"required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },        
        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
                 
         {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',         
          "column": "Organization",        
          "parent":null,                   
        "description" :"Company",        
        "processingMethod" :"RpOrganizationSel",          
         "sortOrder":5,        
           "operator":"in",         
         "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',         
         "column": "Office",        
          "parent":"Organization",        
                  
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":6,        
          "operator":"in",         
         "required":0,                   
        "defaultValue":null        
        },        
             {         
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',          
        "column": "DeductionCode",         
        "parent":null,        
             
           "description" :"Deduction Code",        
        "processingMethod" :"RpTransactionCodeSel",         
           "sortOrder":7,        
           "operator":"in",         
        "required":1,                  
        "defaultValue":null       
        }, 
		 {         
                 
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',         
           "column": "NamePersonId",        
          "parent":null,                            
        "description" :"Name / Person Id",         
        "sortOrder":8,        
           "operator":"contains",         
         "required":0,                   
           "defaultValue":null        
         }, 
		{         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',          
        "column": "GroupBy",         
        "parent":null,                    
           "description" :"Group By",        
        "processingMethod" :"RpOfficeGroupBySel",         
           "sortOrder":9,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"GroupBy","value":"None","isParameter":1}]  }      ,
		

		 {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":10,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 



             
       ]  }';


EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
PRINT 'PaymentDeduction';

                --EmployeeWageStatement
                SELECT @Json = '{"report" :"EmployeeWageStatement",          
         "description" :"This report shows the wage details of all payments received by an employee within a date range. It can be used for wage verification purposes.", 
		 "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',        
         "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
         "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ',      
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
            "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',            
            "column": "DateType",           
             "parentMappingId":1,          
            "parent":null,           
               "description" :"DateType",          
            "processingMethod" :"RpListItemSel",           
               "sortOrder":2,          
               "operator":"equals",           
            "required":1,                    
            "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]          
            },          
          
             {           
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "StartDate",          
              "parent":null,                              
            "description" :"Start Date",           
            "processingMethod" :null,           
            "sortOrder":3,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
          },          
             {           
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "EndDate",          
              "parent":null,                              
            "description" :"End Date",           
            "processingMethod" :null,           
            "sortOrder":4,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },          
                      
              {           
               "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "Company",          
              "parent":null,                     
            "description" :"Company",          
            "processingMethod" :"RpOrganizationSel",            
             "sortOrder":5,          
               "operator":"in",           
             "required":0,                  
               "defaultValue":null          
             },          
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Office",          
              "parent":"Company",             
              "description" :"Office",           
              "processingMethod" :"RpOfficeByOrganizationSel",          
               "sortOrder":6,          
            "operator":"in",           
            "required":0,                     
            "defaultValue":null          
            },          
                 
            {           
            "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',            
            "column": "SSN",           
            "parent":null,          
                      
               "description" :"SSN",          
            "processingMethod" :null,           
               "sortOrder":7,          
               "operator":"contains",           
            "required":0,                     
            "defaultValue":[{"key":"SSN","value":"%","isParameter":1}]          
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
           "sortOrder":8,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
            }                    
             ]               
                    
              }';
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'EmployeeWageStatement';


                --Management
                SELECT @Json = '{"report" :"Management",          
         "description" :"This report shows the overall summary of a company which includes financial, payroll, sales, and tax records that are broken down into the company and office level.", 
		 "categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',        
         "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
         "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,       
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "StartDate",          
              "parent":null,                              
            "description" :"Start Date",           
            "processingMethod" :null,           
            "sortOrder":2,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },          
             {           
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "EndDate",          
              "parent":null,                              
            "description" :"End Date",           
            "processingMethod" :null,           
            "sortOrder":3,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },          
                      
             {           
               "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "Organization",          
              "parent":null,                     
            "description" :"Organization",          
            "processingMethod" :"RpOrganizationSel",            
             "sortOrder":4,          
               "operator":"in",           
             "required":0,                  
               "defaultValue":null          
             },          
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Office",          
              "parent":"Organization",          
              "description" :"Office",           
              "processingMethod" :"RpOfficeByOrganizationSel",          
               "sortOrder":5,          
              "operator":"in",           
             "required":0,                     
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
            "sortOrder":6,          
               "operator":"equals",           
             "required":0,                     
               "defaultValue":null          
             }          
            ]          
                      
             }' ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'Management';

                --Gross Profit         
                SELECT @Json = '{"report" :"GrossProfit",          
     "description" :"This report is a summary report that shows gross profit and detailed information of the gross profit broken down by each office.",          
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
          "categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',          
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,     
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "StartDate",          
          "parent":null,                              
        "description" :"StartDate(AP)",           
        "processingMethod" :null,           
        "sortOrder":2,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         },{           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "EndDate",          
          "parent":null,                              
        "description" :"EndDate(AP)",           
        "processingMethod" :null,           
        "sortOrder":3,          
           "operator":"equals",           
         "required":1,              
           "defaultValue":null          
                   
         } 
		 ,{           
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "Organization",          
          "parent":null,                     
        "description" :"Company",          
        "processingMethod" :"RpOrganizationSel",            
         "sortOrder":4,          
           "operator":"in",           
         "required":0,                  
           "defaultValue":null          
         },{           
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
         "column": "Office",          
          "parent":"Organization",          
                    
          "description" :"Office",           
          "processingMethod" :"RpOfficeByOrganizationSel",          
           "sortOrder":5,          
          "operator":"in",           
     "required":0,                     
        "defaultValue":null          
        }  ,        
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }       
            
                         ]            
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'Gross Profit';



                --StartSheet
                SELECT @Json = '{"report" :"StartSheet",        
 "description" :"This report shows details of employee assignment with rates, their contact information, and worksite address.",  
 "categoryListItemId":' + CAST(@JobAssignmentListItemId AS VARCHAR (10)) + ',   
 "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
 "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ',      
	  "reportOptionListItemId":' + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + ',  
  "reportParameter":[        
       {         
        
       "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + ',        
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
        
       "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + ',        
    "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
       "column": "AssignmentId",        
      "parent":null,                            
    "description" :"AssignmentId",         
    "processingMethod" :null,         
    "sortOrder":1,        
       "operator":"equals",         
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
        "sortOrder":8,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }         
     ]        
     }'         ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'StartSheet';


                --TransactionBatchDetail
                SELECT @Json = '{"report" :"TransactionBatchDetail",          
        "description" :"This report shows detailed timesheet information including hours, transaction code, units, and margin. This report can also be used to verify, confirm, and process transactions.",   
		"categoryListItemId":' + CAST(@TimesheetListItemId AS VARCHAR (MAX)) + ', 
        "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
        "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,       
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
                      
              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "TransactionBatchId",          
             "parent":null,                              
           "description" :"TransactionBatchId",           
           "processingMethod" :null,           
           "sortOrder":2,          
              "operator":"equals",           
            "required":1,                     
              "defaultValue":[{"key":"TransactionBatchId","value":0,"isParameter":1}]          
            },          
             {           
             "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "StartDate",          
             "parent":null,                              
           "description" :"StartDate",           
           "processingMethod" :null,           
           "sortOrder":3,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
                      
            },          
            {           
             "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "EndDate",          
             "parent":null,                              
           "description" :"EndDate",           
           "processingMethod" :null,           
           "sortOrder":4,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
                      
            },          
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Company",          
             "parent":null,                     
           "description" :"Company",          
           "processingMethod" :"RpOrganizationSel",            
           "sortOrder":5,          
           "operator":"in",           
           "required":0,                  
              "defaultValue":null          
            },          
            {           
             "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
            "column": "Office",          
             "parent":"Company",               
             "description" :"Office",           
             "processingMethod" :"RpOfficeByOrganizationSel",          
              "sortOrder":6,          
             "operator":"in",           
           "required":0,                     
           "defaultValue":null          
           },          
                  
                   
           {           
              "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Customer",          
             "parent":null,                     
           "description" :"Customer",          
           "processingMethod" :null,            
           "sortOrder":7,          
           "operator":"contains",           
           "required":0,                  
              "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]          
            },          
             {           
                      
              "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "Sortby",          
             "parent":null,                              
           "description" :"Sort By",           
           "processingMethod" :"RpSortTypeSel",           
           "sortOrder":8,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":[{"key":"Sortby","value":"Customer","isParameter":1}]          
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
           "sortOrder":9,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
            }          
            ]          
            }'  ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'TransactionBatchDetail';


                ---WCCostSummarybyCustomer        
                SELECT @Json = '{"report" :"WCCostSummarybyCustomer",    
       "description" :"This report shows total worker comp wages, rates, and costs grouped by customer.",    
       "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',    
            "categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (10))
                               + ',    
       "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,    
					   "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
            "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',    
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
             "column": "StartDate",    
            "parent":null,                        
          "description" :"Start Date(AP)",     
          "processingMethod" :null,     
          "sortOrder":2,    
             "operator":"equals",     
           "required":1,               
             "defaultValue":null    

           },    
           {     
            "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',    
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
             "column": "EndDate",    
            "parent":null,                        
          "description" :"End Date(AP)",     
          "processingMethod" :null,     
          "sortOrder":3,    
             "operator":"equals",     
           "required":1,               
             "defaultValue":null    

           },
             {     
             "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',    
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
            "column": "Company",    
            "parent":null,               
          "description" :"Company",    
          "processingMethod" :"RpOrganizationSel",      
           "sortOrder":4,    
             "operator":"in",     
           "required":1,            
             "defaultValue":null    
           },
	 {     
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',    
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
           "column": "Office",    
            "parent":"Company",    

            "description" :"Office",     
            "processingMethod" :"RpOfficeByOrganizationSel",    
             "sortOrder":5,    
            "operator":"in",     
           "required":1,               
          "defaultValue":null    
          },   
   {     
             "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',    
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
            "column": "Customer",    
            "parent":null,               
          "description" :"Customer",    
          "processingMethod" :null,      
          "sortOrder":6,    
          "operator":"contains",     
          "required":0,            
             "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]    
           }  ,    
            {     

              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',    
           "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',     
              "column": "ReportId",    
             "parent":null,                        
           "description" :"Report Id",     
           "processingMethod" :null,     
           "sortOrder":7,    
              "operator":"equals",     
            "required":0,               
              "defaultValue":null    
            } 

          ]      
          }'    ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'WCCostSummarybyCustomer';

                --InvoiceTimeSheet
                SELECT @Json = '{"report" :"InvoiceTimeSheet",        
     "description" :"This report shows timeclock punch information related to an invoice for their punch in, punch out, break-in, break-out information.",     
	 "categoryListItemId":' + CAST(@TimesheetListItemId AS VARCHAR (MAX)) + ',
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ',        
                  	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        "column": "InvoiceNumber",         
        "parent":null,        
           "description" :"Invoice Number",        
        "processingMethod" :null,         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":null        
        },{         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "APStartDate",        
          "parent":null,                            
        "description" :"AP Start Date",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "APEndDate",        
          "parent":null,                            
        "description" :"AP End Date",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":0,                   
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
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "Customer",        
          "parent":null,                            
        "description" :"Customer",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"contains",         
         "required":0,                   
           "defaultValue":null        
                 
         }        
        ]        
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'InvoiceTimeSheet';

                --GrossProfitDetail        
                --Report not needed for ESSG
                SELECT @Json = '{"report" :"GrossProfitDetail",            
     "description" :"This report shows gross profit and information that makes up the gross profit. It can be further filtered with a  group by office/User/Customer/Job Type/WC Code/ Employee to see detail and summary.",            
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',            
          "categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',            
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,            
                      	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
                    
     "reportParameter":[{  
  
     "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + ',  
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
						 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "DateType",         
						 "parent":null,        
							"description" :"Date Type",	
						 "processingMethod" :"RpDateTypeSel",         
						    "sortOrder":2,        
						    "operator":"equals",         
						 "required":1,                  
						 "defaultValue":[{"key":"DateType","value":"Accounting Period Date","isParameter":1}]        
						 },
	{             
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
           "column": "StartDate",            
          "parent":null,                                
        "description" :"Start Date",             
        "processingMethod" :null,             
        "sortOrder":3,            
           "operator":"equals",             
         "required":1,                       
           "defaultValue":null   } ,
		   {             
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
           "column": "EndDate",            
          "parent":null,                                
        "description" :"EndDate",             
        "processingMethod" :null,             
        "sortOrder":4,            
           "operator":"equals",             
         "required":1,                
           "defaultValue":null            
                     
         },

	 {             
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
          "column": "Organization",            
          "parent":null,                       
 "description" :"Company",            
        "processingMethod" :"RpOrganizationSel",              
         "sortOrder":5,            
           "operator":"in",             
         "required":0,                    
           "defaultValue":null            
         },
	 
	 {             
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
         "column": "Office",            
          "parent":"Organization",            
                      
          "description" :"Office",             
          "processingMethod" :"RpOfficeByOrganizationSel",            
           "sortOrder":6,            
          "operator":"in",             
     "required":0,                       
        "defaultValue":null            
        },

	 {         
						 "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "GroupBy",         
						 "parent":null,        
							"description" :"Group By",	
						 "processingMethod" :"RpGroupBySel",         
						    "sortOrder":7,        
						    "operator":"in",         
						 "required":1,                  
						 "defaultValue":[{"key":"GroupBy","value":"Office","isParameter":1}]        
						 },
						 {         
						 "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "JobType",         
						 "parent":null,        
							"description" :"Job Type",	
						 "processingMethod" :"RpListItemSel",         
						    "sortOrder":8,        
						    "operator":"in",         
						 "required":1,                  
						 "defaultValue":[{"key":"Category","value":"JobType","isParameter":1}]    
						 },
						 {         
						 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "UserLevel",         
						 "parent":null,        
							"description" :"User Level",	
						 "processingMethod" :"RpUserLevelSel",         
						    "sortOrder":9,        
						    "operator":"equals",         
						 "required":0,                  
						 "defaultValue":null  
						 },

	 {         
						 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "UserType",         
						 "parent":"UserLevel",        
							"description" :"User Type",	
						 "processingMethod" :"RpUsertypeByUserLevelSel",         
						    "sortOrder":10,        
						    "operator":"equals",         
						 "required":0,                  
						 "defaultValue":null
						 },
						 {         
						 "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "User",         
						 "parent":null,        
							"description" :"User",	
						 "processingMethod" :"RpUserSel",         
						    "sortOrder":11,        
						    "operator":"in",         
						 "required":0,                  
						 "defaultValue":null  
						 },{ 
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',		
								"column": "RollUpToParentCustomer", 
							    "description" :"Roll Up to Parent Customer",
								"processingMethod" :"RpTrueFalseSel",	
							    "sortOrder":12,
							    "operator":"equals",	
								"required":1,						    
								"defaultValue":[{"key":"RollUpToParentCustomer","value":"False","isParameter":1}] 
								},{ 
							    "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							   "column": "Customer",
							   "parent":null, 						    
								"description" :"Customer",
								"processingMethod" :null,		
								"sortOrder":13,
								"operator":"contains",	
								"required":0,								
							    "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]
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
        "sortOrder":14,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
              
                         ]              
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'GrossProfitDetail';



                --UnappliedCash
                SELECT @Json = '{"report" :"UnappliedCash",
					"description" :"This report shows all the unapplied cash/credits per customer that are remaining.",
					"categoryListItemId":' + CAST(@AccountsReceivableListItemId AS VARCHAR (MAX))
                               + ',
					"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',
					"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,	  
						   "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
							  
							    "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							    "column": "ARBatchId",
							   "parent":null,						   							    
								"description" :"ARBatchId",	
								"processingMethod" :null,	
								"sortOrder":2,
							    "operator":"equals",	
								 "required":1,											
							    "defaultValue":[{"key":"ARBatchId","value":0,"isParameter":1}]
							  },
							  
							  
						  
							  {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentAsOfDate",        
          "parent":null,                            
        "description" :"PaymentAsOfDate",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         }, { 
						"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							   "column": "Organization",
							   "parent":null, 						    
								"description" :"Company",
								"processingMethod" :"RpOrganizationSel",		
								"sortOrder":4,
								"operator":"in",	
								"required":0,								
							    "defaultValue":null
							  },
							  { 
							   "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							  "column": "Office",
							   "parent":"Organization",		   
							   "description" :"Office",	
							   "processingMethod" :"RpOfficeByOrganizationSel",
							    "sortOrder":5,
							   "operator":"in",	
								"required":0,							    
								"defaultValue":null
								},{ 
							    "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							   "column": "Customer",
							   "parent":null, 						    
								"description" :"Customer",
								"processingMethod" :null,		
								"sortOrder":6,
								"operator":"contains",	
								"required":0,								
							    "defaultValue":[{"key":"CustomerOrganization","value":"%","isParameter":1}]
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
        "sortOrder":7,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
								 
							  ]
							  }';
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json;
                PRINT 'UnappliedCash';

                ---New Hire report--------
                SELECT @Json = N'{"report" :"NewHire",
"description" :"This report shows the list of employees who received their first check in the provided date range. It will also include any employees who may not have received any checks for at least the number of consecutive days provided in the number of days parameter.",
"categoryListItemId":' + CAST(@RecruitingOnboardingListItemId AS VARCHAR (MAX)) + ',
"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10)) + N',
"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + N' ,	
							   "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
                    

"reportParameter":[
{

"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },



{
"dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',
"column": "StartDate",
"parent":null,
"description" :"Start Date",
"processingMethod" :null,
"sortOrder":3,
"operator":"equals",
"required":1,
"defaultValue":null

},
{
"dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',
"column": "EndDate",
"parent":null,
"description" :"End Date",
"processingMethod" :null,
"sortOrder":4,
"operator":"equals",
"required":1,
"defaultValue":null

},{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',
"column": "Organization",
"parent":null,
"description" :"Company",
"processingMethod" :"RpOrganizationSel",
"sortOrder":5,
"operator":"in",
"required":1,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',
"column": "Office",
"parent":"Organization",
"description" :"Office",
"processingMethod" :"RpOfficeByOrganizationSel",
"sortOrder":6,
"operator":"in",
"required":0,
"defaultValue":null
},


{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',
"column": "State",
"parent":null,
"description" :"State",
"processingMethod" :"RpStateSel",
"sortOrder":7,
"operator":"in",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',
"column": "NumberOfDays",
"parent":null,
"description" :"NumberOfDays",
"processingMethod" :null,
"sortOrder":8,
"operator":"equals",
"required":0,
"defaultValue":[{"key":"NumberOfDays","value":"60","isParameter":1}]         
},{     

              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',    
           "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',     
              "column": "ReportId",    
             "parent":null,                        
           "description" :"Report Id",     
           "processingMethod" :null,     
           "sortOrder":9,    
              "operator":"equals",     
            "required":0,               
              "defaultValue":null    
            }   



]
}'              ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'NewHire';

                -- DeductionSubmittalbyOffice
                SELECT @Json = '{"report" :"DeductionSubmittalbyOffice",        
     "description" :"This report shows all deductions that were paid to the agencies along with employee information and case information/reference broken down by Office. It is designed to be submitted along with the agency check that was generated.",  
	 "categoryListItemId":' + CAST(@AccountsPayableListItemId AS VARCHAR (MAX)) + ',   
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + '    , 
							   	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "PaymentBatchId",        
          "parent":null,                            
        "description" :"PaymentBatchId",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":[{"key":"PaymentBatchId","value":0,"isParameter":1}]        
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
         } ,        
          {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":4,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date(AP)",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
        
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date(AP)",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
        
         },        
          {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
        "description" :"Company",        
        "processingMethod" :"RpOrganizationSel",          
        "sortOrder":7,        
        "operator":"in",         
        "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
          "parent":"Company",             
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":8,        
          "operator":"in",         
        "required":0,                   
        "defaultValue":null        
        }  ,        
        
        {         
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DeductionType",         
        "parent":null,        
           "description" :"DeductionType",        
        "processingMethod" :"RpTransactionTypeAdjustmentSel",         
           "sortOrder":9,        
       "operator":"in",         
        "required":0,                  
        "defaultValue":null        
        }       
         ]        
         }'     ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'DeductionSubmittalbyOffice';


                -- Migration Summary Report
                SELECT @Json = N'{"report" :"MigrationSummary",  
     "description" :"This report shows the summary of migrated employee including count of employee, customer, job, assignment, comment and benefit, deduction, tax amount, taxable gross, net, gross of last 6 years and invoice amount, total bill, sales tax, discount, charge, balance of customer and tax amount, taxable gross, gross, balance of tenant organization quarterly.",  
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + N',  
          "categoryListItemId":' + CAST(@AdminListItemId AS VARCHAR (MAX)) + ',  
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + N' ,  
            	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
                    
     "reportParameter":[ 
	 { 
							  
							    "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + N',
								"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',	
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
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + N',  
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   
          "column": "ReferenceNote",  
          "parent":null,             
        "description" :"Reference Note",  
        "processingMethod" :"",    
         "sortOrder":2,  
           "operator":"contains",   
         "required":0,          
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
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'MigrationSummary';



                --ClientBilling
                SELECT @Json = '{"report" :"ClientBilling",          
        "description" :"This report shows all detailed billing transactions of customers with a total billed amount, bill unit, and count of invoice and employee. It can be filtered by a specific customer, job title and also can be seen as a summary report.",   
		"categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',  
        "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',   
			   "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
        "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,          
                       
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"Category","value":"InvoiceDateType","isParameter":1}]        
        },
             
            {           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "StartDate",          
          "parent":null,                              
        "description" :"Start Date",           
        "processingMethod" :null,           
        "sortOrder":3,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         },
		 {           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "EndDate",          
          "parent":null,                              
        "description" :"End Date",           
        "processingMethod" :null,           
        "sortOrder":4,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null                            
         },     
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Company",          
             "parent":null,                     
           "description" :"Company",          
           "processingMethod" :"RpOrganizationSel",            
           "sortOrder":5,          
           "operator":"in",           
           "required":0,                  
              "defaultValue":null          
            },          			
            {           
             "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
            "column": "Office",          
             "parent":"Company",               
             "description" :"Office",           
             "processingMethod" :"RpOfficeByOrganizationSel",          
              "sortOrder":6,          
             "operator":"in",           
           "required":0,                     
           "defaultValue":null          
           },   
		    {     
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',    
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
          "column": "CustomerOrganization",    
          "parent":null,               
        "description" :"Customer",    
        "processingMethod" :null,      
        "sortOrder":7,    
        "operator":"contains",     
        "required":0,            
           "defaultValue":[{"key":"CustomerOrganization","value":"%","isParameter":1}]    
         },  
		 {     
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',    
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
          "column": "JobPosition",    
          "parent":null,               
        "description" :"JobPosition",    
        "processingMethod" :null,      
        "sortOrder":8,    
        "operator":"contains",     
        "required":0,            
           "defaultValue":[{"key":"JobPosition","value":"%","isParameter":1}]    
         }, 		 
			{         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "RollUpToRootCustomer",         
        "parent":null,                     
         "description" :"RollUpToRootCustomer",        
        "processingMethod" :"RpYesNoSel",         
           "sortOrder":9,        
           "operator":"equals",         
        "required":0,                  
        "defaultValue":[{"key":"RollUpToRootCustomer","value":"No","isParameter":1}]        
        },
		{         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "ShowSummary",         
        "parent":null,                     
         "description" :"ShowSummary",        
        "processingMethod" :"RpTrueFalseSel",         
           "sortOrder":10,        
           "operator":"equals",         
        "required":0,                  
        "defaultValue":[{"key":"ShowSummary","value":"False","isParameter":1}]        
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
           "sortOrder":11,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
            }          
            ]          
            }'  ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'ClientBilling';


                ----Comment Report--------
                SELECT @Json = '{"report" :"Comment",          
        "description" :"This report shows the all comments. It can be further filtered by a specific employee/ customer/ contact/ job/ assignment and date range.",      
		"categoryListItemId":' + CAST(@CommonListItemId AS VARCHAR (10)) + ',
        "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',  
		 "reportOptionListItemId":' + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + ',
        "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,          
                       
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
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "StartDate",          
          "parent":null,                              
        "description" :"Start Date",           
        "processingMethod" :null,           
        "sortOrder":2,          
           "operator":"equals",           
         "required":0,                     
           "defaultValue":null          
                   
         },
		 {           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "EndDate",          
          "parent":null,                              
        "description" :"End Date",           
        "processingMethod" :null,           
        "sortOrder":3,          
           "operator":"equals",           
         "required":0,                     
           "defaultValue":null                            
         },     {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "RelatesTo",         
        "parent":null,                     
         "description" :"RelatesTo",        
        "processingMethod" :"RpRelatesToSel",         
           "sortOrder":4,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":null        
        },   
		    {     
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',    
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
          "column": "Name",    
          "parent":null,               
        "description" :"Name",    
        "processingMethod" :null,      
        "sortOrder":5,    
        "operator":"contains",     
        "required":0,            
           "defaultValue":[{"key":"Name","value":"%","isParameter":1}]    
         },
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Company",          
             "parent":null,                     
           "description" :"Company",          
           "processingMethod" :"RpOrganizationSel",            
           "sortOrder":6,          
           "operator":"in",           
           "required":0,                  
              "defaultValue":null          
            },          			
            {           
             "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
            "column": "Office",          
             "parent":"Company",               
             "description" :"Office",           
             "processingMethod" :"RpOfficeByOrganizationSel",          
              "sortOrder":7,          
             "operator":"in",           
           "required":0,                     
           "defaultValue":null          
           },  		 
			
		{           
             "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
            "column": "CommentType",                                     
             "description" :"Comment Type",           
             "processingMethod" :"RpCommentTypeSel",          
              "sortOrder":8,          
             "operator":"in",           
           "required":0,                     
           "defaultValue":null          
           },   
		   {           
             "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
           "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
            "column": "CommentBy",                                     
             "description" :"Comment By",           
             "processingMethod" :"RpCommentBySel",          
              "sortOrder":9,          
             "operator":"in",           
           "required":0,                     
           "defaultValue":null          
           },
		   {         
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "GroupBy",         
        "parent":null,                     
         "description" :"GroupBy",        
        "processingMethod" :"RpGroupByCommentSel",         
           "sortOrder":10,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":null        
        },
		{         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "ShowSummary",         
        "parent":null,                     
         "description" :"ShowSummary",        
        "processingMethod" :"RpTrueFalseSel",         
           "sortOrder":11,        
           "operator":"equals",         
        "required":0,                  
        "defaultValue":[{"key":"ShowSummary","value":"False","isParameter":1}]        
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
           "sortOrder":12,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
            }          
            ]          
            }'  ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'Comment';


                --EmployeeSummary
                SELECT @Json = '{"report" :"EmployeeSummary",        
     "description" :"This report shows the information of a specific employee including their assignments, skills, educations, comments, SMS, and so on.",     
	 "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (10)) + ',
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',        
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ',           
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
                PRINT 'EmployeeSummary';

                --TransactionBatchWithMargin  
                SELECT @Json = '{"report" :"TransactionBatchwithMargin",    
          "description" :"This report shows detailed timesheet information including hours, transaction code, units, and margin. This report can also be used to verify, confirm, and process transactions.", 
		  "categoryListItemId":' + CAST(@TimesheetListItemId AS VARCHAR (MAX)) + ',
          "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',    
          "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ',    
		 "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
                  
                "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',    
             "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
                "column": "TransactionBatchId",    
               "parent":null,                        
             "description" :"TransactionBatchId",     
             "processingMethod" :null,     
             "sortOrder":1,    
                "operator":"equals",     
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
              }';
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)  
                PRINT 'TransactionBatchWithMargin';


                --W2 4 Up Report
                SELECT @Json = '{"report" :"W24Up",
"description" :"This report shows wage and tax records that an employer is required to send to a particular employee and the Internal Revenue Service (IRS) at the end of the year.",
"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10)) + ',
"categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (10)) + ',
"isSytem": ' +      CAST(1 AS VARCHAR (10)) + ' ,
"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',

"reportParameter":[
{

"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',
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
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Year",

"parentMappingId":1,
"description" :"Year",
"processingMethod" :"RpAccountingPeriodYearSel",
"sortOrder":2,
"operator":"equals",
"required":1,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Organization",
"parent":null,
"description" :"Organization",
"processingMethod" :"RpCompanyBackOfficeSel",
"sortOrder":3,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Office",
"parent":"Organization",
"description" :"Office",
"processingMethod" :"RpOfficeByOrganizationSel",
"sortOrder":4,
"operator":"in",
"required":0,
"defaultValue":null
},


{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',
"column": "OrderBy",
"parent":null,
"description" :"Order By",
"processingMethod" :"RpOrderBySel",
"sortOrder":5,
"operator":"equals",
"required":0,
"defaultValue":null

},


{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "SSN",
"parent":null,
"description" :"SSN",
"sortOrder":6,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "ControlNumberFrom",
"parent":null,
"description" :"Control Number From",
"sortOrder":7,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "ControlNumberTo",
"parent":null,
"description" :"Control Number To",
"sortOrder":8,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "LocalTax",
"parent":null,
"description" :"Local Tax",
"sortOrder":9,
"operator":"equals",
"required":0,
"defaultValue":null
},

{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "WHTaxState",
"parent":null,
"description" :"WH Tax State",
"sortOrder":10,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "EmployeeStatus",
"parent":null,
"description" :"Employee Status",
"processingMethod" :"RpEmployeeStatusSel" ,
"sortOrder":11,
"operator":"in",
"required":0,
"defaultValue":null
},

{
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "IncludeElectronicW2S",
"parent":null,
"description" :"Include Electronic W2S",
"processingMethod" :"RpYesNoSel" ,
"sortOrder":12,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "ShowCorrected",
"parent":null,
"description" :"Show Corrected",
"processingMethod" :"RpYesNoSel" ,
"sortOrder":13,
"operator":"equals",
"required":0,
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
        "sortOrder":14,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 


]
}'              ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'W24Up';


                -- 1099NEC Report
                SELECT @Json = '{"report" :"1099NEC",
"description" :"This report shows independent contractor payments reported for any non-employee compensation.",
"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10)) + ',
"categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (10)) + ',
"isSytem": ' +      CAST(1 AS VARCHAR (10)) + ' ,
"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',

"reportParameter":[
{

"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',
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
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Year",

"parentMappingId":1,
"description" :"Year",
"processingMethod" :"RpAccountingPeriodYearSel",
"sortOrder":2,
"operator":"equals",
"required":1,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Organization",
"parent":null,
"description" :"Organization",
"processingMethod" :"RpOrganizationSel",
"sortOrder":3,
"operator":"in",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "SSN",
"parent":null,
"description" :"SSN",
"sortOrder":4,
"operator":"equals",
"required":0,
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
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
]
}'              ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT '1099NEC';


                --TaxSummary
                SELECT @Json = '{"report" :"TaxSummary",          
         "description" :"This report shows payroll taxes within a period of time at a summary level and can be used for verifying quarterly and yearly taxes.",    
		 "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX)) + ', 
         "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
         "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,      
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",         
        "parent":null,        
        "parentMappingId":1,         
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                 
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },
			 
             {           
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "StartDate",          
              "parent":null,                              
            "description" :"Start Date",           
            "processingMethod" :null,           
            "sortOrder":3,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },          
             {           
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "EndDate",          
              "parent":null,                              
            "description" :"End Date",           
            "processingMethod" :null,           
            "sortOrder":4,          
               "operator":"equals",           
             "required":1,                     
               "defaultValue":null          
                       
             },          
               
             {           
               "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "Organization",          
              "parent":null,                     
            "description" :"Organization",          
            "processingMethod" :"RpOrganizationSel",            
             "sortOrder":5,          
               "operator":"in",           
             "required":0,                  
               "defaultValue":null          
             },          
             {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "Office",          
              "parent":"Organization",            
              "description" :"Office",           
              "processingMethod" :"RpOfficeByOrganizationSel",          
               "sortOrder":6,          
              "operator":"in",           
             "required":0,                     
            "defaultValue":null          
            },          
                 
              
               
            {           
               "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
              "column": "RelatesTo",          
              "parent":null,                     
            "description" :"Relates To",          
            "processingMethod" :"RpListItemSel",            
            "sortOrder":7,          
            "operator":"equals",           
            "required":0,                  
               "defaultValue":[{"key":"Category","value":"ReportTaxType","isParameter":1}]          
             } ,
			 {           
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
             "column": "TaxType",          
              "parent":"RelatesTo",            
              "description" :"Tax Type",           
              "processingMethod" :"RpTaxTypeByRelatesToSel",          
               "sortOrder":8,          
              "operator":"in",           
             "required":0,                     
            "defaultValue":null          
            },
			 {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "GroupByOffice",         
        "parent":null,        
             
           "description" :"GroupBy Office",        
        "processingMethod" :"RpYesNoSel",         
           "sortOrder":9,        
           "operator":"equals",         
        "required":1,                  
        "defaultValue":[{"key":"GroupByOffice","value":"Yes","isParameter":1}]        
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
        "sortOrder":10,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
            ]            
            }'  ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'TaxSummary';


                -- 1095C
                SELECT @Json = '{"report" :"1095C",
								"description" :"This report shows important information about the healthcare coverage offered or provided to an employee by an employer.",
								"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',
								"categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (10))
                               + ',
								"isSytem": ' + CAST(1 AS VARCHAR (10)) + ' ,
								"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,
								"reportOptionListItemId":'
                               + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + ',

								"reportParameter":[
								{

								"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + N',
								"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',
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
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
								"column": "Year",

								"parentMappingId":1,
								"description" :"Year",
								"processingMethod" :"RpAccountingPeriodYearSel",
								"sortOrder":2,
								"operator":"equals",
								"required":1,
								"defaultValue":null
								},
								{
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
								"column": "Organization",
								"parent":null,
								"description" :"Organization",
								"processingMethod" :"RpCompanyBackOfficeSel",
								"sortOrder":3,
								"operator":"equals",
								"required":1,
								"defaultValue":null
								},
								{
								"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
								"column": "SSN",
								"parent":null,
								"description" :"SSN",
								"sortOrder":4,
								"operator":"equals",
								"required":0,
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
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
								]
								}';
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT '1095C';


                --W2Correction
                SELECT @Json = '{"report" :"W2Correction",
"description" :"This report shows a new W2 with the corrected data of an employee.",
"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10)) + ',
"categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (10)) + ',
"isSytem": ' +      CAST(1 AS VARCHAR (10)) + ' ,
"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',

"reportParameter":[
{

"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',
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
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Year",

"parentMappingId":1,
"description" :"Year",
"processingMethod" :"RpAccountingPeriodYearSel",
"sortOrder":2,
"operator":"equals",
"required":1,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Organization",
"parent":null,
"description" :"Organization",
"processingMethod" :"RpCompanyBackOfficeSel",
"sortOrder":3,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Office",
"parent":"Organization",
"description" :"Office",
"processingMethod" :"RpOfficeByOrganizationSel",
"sortOrder":4,
"operator":"in",
"required":0,
"defaultValue":null
},


{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',
"column": "OrderBy",
"parent":null,
"description" :"Order By",
"processingMethod" :"RpOrderBySel",
"sortOrder":5,
"operator":"equals",
"required":0,
"defaultValue":null

},


{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "SSN",
"parent":null,
"description" :"SSN",
"sortOrder":6,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "ControlNumberFrom",
"parent":null,
"description" :"Control Number From",
"sortOrder":7,
"operator":"equals",
"required":0,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "ControlNumberTo",
"parent":null,
"description" :"Control Number To",
"sortOrder":8,
"operator":"equals",
"required":0,
"defaultValue":null
},


{
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "EmployeeStatus",
"parent":null,
"description" :"Employee Status",
"processingMethod" :"RpEmployeeStatusSel" ,
"sortOrder":9,
"operator":"in",
"required":0,
"defaultValue":null
},

{
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "IncludeElectronicW2S",
"parent":null,
"description" :"Include Electronic W2S",
"processingMethod" :"RpYesNoSel" ,
"sortOrder":10,
"operator":"equals",
"required":0,
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
        "sortOrder":11,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 

]
}'              ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'W2Correction';

                --W2
                SELECT @Json = '{"report" :"W2",
"description" :"This report shows wage and tax records that an employer requires to send to a particular employee and the Internal Revenue Service (IRS) at the end of the year.",
"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10)) + ',
"categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (10)) + ',
"isSytem": ' +      CAST(1 AS VARCHAR (10)) + ' ,
"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',

"reportParameter":[
{

"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + N',
"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',
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
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Year",

"parentMappingId":1,
"description" :"Year",
"processingMethod" :"RpAccountingPeriodYearSel",
"sortOrder":2,
"operator":"equals",
"required":1,
"defaultValue":null
},
{
"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "Organization",
"parent":null,
"description" :"Organization",
"processingMethod" :"RpCompanyBackOfficeSel",
"sortOrder":3,
"operator":"equals",
"required":1,
"defaultValue":null
},

{
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',
"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
"column": "SSN",
"parent":null,
"description" :"SSN",
"sortOrder":4,
"operator":"equals",
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
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }

]
}'              ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'W2';



                --1094C
                SELECT @Json = '{"report" :"1094C",
								"description" :"This report includes the data reported to the Internal Revenue Service summary information for each employer.",
								"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',
								"categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (10))
                               + ',
								"isSytem": ' + CAST(1 AS VARCHAR (10)) + ' ,
								"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,
								"reportOptionListItemId":'
                               + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + ',

								"reportParameter":[
								{

								"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + N',
								"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',
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
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
								"column": "Year",

								"parentMappingId":1,
								"description" :"Year",
								"processingMethod" :"RpAccountingPeriodYearSel",
								"sortOrder":2,
								"operator":"equals",
								"required":1,
								"defaultValue":null
								},
								{
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',
								"column": "Organization",
								"parent":null,
								"description" :"Organization",
								"processingMethod" :"RpCompanyBackOfficeSel",
								"sortOrder":3,
								"operator":"equals",
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
        "sortOrder":4,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
								]
								}';
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT '1094C';


                --1095CLabel
                SELECT @Json = '{"report" :"1095CLabel",          
"description" :"This report generates a label for an envelope for the 1095C form.",          
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
  "categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (10)) + ',   
  "isSytem":      ' + CAST(1 AS VARCHAR (10)) + ' ,
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,      
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "Company",          
          "parent":null,                     
        "description" :"Company",          
        "processingMethod" :"RpOrganizationSel",            
         "sortOrder":2,          
           "operator":"in",           
         "required":0 ,                  
           "defaultValue":null          
         },
		 {         
          "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "Year",        
          "parent":null,                            
        "description" :"Year",         
        "processingMethod" :"RpAccountingPeriodYearSel",         
        "sortOrder":3,        
           "operator":"equals",         
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
           "sortOrder":4,    
              "operator":"equals",     
            "required":0,               
              "defaultValue":null    
            }          
                  
                  
        ]            
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json;
                PRINT '1095clabel';

                --	GrossProfitSummary
                SELECT @Json = '{"report" :"GrossProfitSummary",            
     "description" :"This report shows the summary of gross profit, total bill and pay hours of each office with charts. ",            
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',            
          "categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',            
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,            
                      	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
                    
     "reportParameter":[{  
  
     "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + ',  
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
						 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "DateType",         
						 "parent":null,        
							"description" :"Date Type",	
						 "processingMethod" :"RpDateTypeSel",         
						    "sortOrder":2,        
						    "operator":"equals",         
						 "required":1,                  
						 "defaultValue":[{"key":"DateType","value":"Accounting Period Date","isParameter":1}]        
						 },
	{             
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
           "column": "StartDate",            
          "parent":null,                                
        "description" :"Start Date",             
        "processingMethod" :null,             
        "sortOrder":3,            
           "operator":"equals",             
         "required":1,                       
           "defaultValue":null   } ,
		   {             
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
           "column": "EndDate",            
          "parent":null,                                
        "description" :"EndDate",             
        "processingMethod" :null,             
        "sortOrder":4,            
           "operator":"equals",             
         "required":1,                
           "defaultValue":null            
                     
         },

	 {             
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
          "column": "Organization",            
          "parent":null,                       
 "description" :"Company",            
        "processingMethod" :"RpOrganizationSel",              
         "sortOrder":5,            
           "operator":"in",             
         "required":0,                    
           "defaultValue":null            
         },
	 
	 {             
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
         "column": "Office",            
          "parent":"Organization",            
                      
          "description" :"Office",             
          "processingMethod" :"RpOfficeByOrganizationSel",            
           "sortOrder":6,            
          "operator":"in",             
     "required":0,                       
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
        "sortOrder":7,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
              
                         ]              
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'GrossProfitSummary';

                --GrossProfitbyCustomer
                SELECT @Json = '{"report" :"GrossProfitbyCustomer",            
     "description" :"This report is a summary report that shows gross profit and information that makes up the gross profit of each customer broken down by office.",            
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',            
          "categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',            
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,            
                      	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
                    
     "reportParameter":[{  
  
     "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + ',  
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
						 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
						 "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
						 "column": "DateType",         
						 "parent":null,        
							"description" :"Date Type",	
						 "processingMethod" :"RpDateTypeSel",         
						    "sortOrder":2,        
						    "operator":"equals",         
						 "required":1,                  
						 "defaultValue":[{"key":"DateType","value":"Accounting Period Date","isParameter":1}]        
						 },
	{             
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
           "column": "StartDate",            
          "parent":null,                                
        "description" :"Start Date",             
        "processingMethod" :null,             
        "sortOrder":3,            
           "operator":"equals",             
         "required":1,                       
           "defaultValue":null   } ,
		   {             
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
           "column": "EndDate",            
          "parent":null,                                
        "description" :"EndDate",             
        "processingMethod" :null,             
        "sortOrder":4,            
           "operator":"equals",             
         "required":1,                
           "defaultValue":null            
                     
         },

	 {             
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
          "column": "Organization",            
          "parent":null,                       
 "description" :"Company",            
        "processingMethod" :"RpOrganizationSel",              
         "sortOrder":5,            
           "operator":"in",             
         "required":0,                    
           "defaultValue":null            
         },
	 
	 {             
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
         "column": "Office",            
          "parent":"Organization",            
                      
          "description" :"Office",             
          "processingMethod" :"RpOfficeByOrganizationSel",            
           "sortOrder":6,            
          "operator":"in",             
     "required":0,                       
        "defaultValue":null            
        },
		{ 
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',		
								"column": "RollUpToParentCustomer", 
							    "description" :"Roll Up to Parent Customer",
								"processingMethod" :"RpTrueFalseSel",	
							    "sortOrder":6,
							    "operator":"equals",	
								"required":1,						    
								"defaultValue":[{"key":"RollUpToParentCustomer","value":"False","isParameter":1}] 
								},{ 
							    "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',	
							   "column": "Customer",
							   "parent":null, 						    
								"description" :"Customer",
								"processingMethod" :null,		
								"sortOrder":7,
								"operator":"contains",	
								"required":0,								
							    "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]
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
        "sortOrder":8,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 
              
                         ]              
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'GrossProfitbyCustomer';


                -- SalesComparisonsFourWeeks
                SELECT @Json = N'{"report" :"SalesComparisonsFourWeeks",  
     "description" :"This report shows the sales, margin, and hours comparison by the customer for the given date and the three previous weeks. ",  
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + N',  
          "categoryListItemId": ' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',  
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + N' ,  
            
     "reportParameter":[ 
	 { 
							    "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + N',
								"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',	
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
							       "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + N',  
							     "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   
							        "column": "AsOfDate",  
							       "parent":null,                      
							     "description" :"AsOfDate",   
							     "processingMethod" :null,   
							     "sortOrder":2,  
							        "operator":"equals",   
							      "required":1,             
							        "defaultValue":null  
							      },
						 {   
							       "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + N',  
							     "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   
							        "column": "Organization",  
							       "parent":null,                      
							     "description" :"Organization",   
							     "processingMethod" :"RpOrganizationSel",   
							     "sortOrder":3,  
							        "operator":"in",   
							      "required":1,             
							        "defaultValue":null  
							      },  
							{   
							       "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',  
							     "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',   
							      "column": "Office",  
							       "parent":"Organization",    
							       "description" :"Office",   
							       "processingMethod" :"RpOfficeByOrganizationSel",  
							        "sortOrder":4,  
							       "operator":"in",   
							      "required":0,             
							     "defaultValue":null  
							     }	,{         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } 	
							
        ]    
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'SalesComparisonsFourWeeks';


                -- SalesComparisonsFourWeeksWithPriorYear
                SELECT @Json = N'{"report" :"SalesComparisonsFourWeeksWithPriorYear",  
     "description" :"This report shows sales by customer compared to previous years sales. It includes records for four weeks from the given date.",  
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + N',  
            "categoryListItemId": ' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + N',  
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + N' ,  
            
     "reportParameter":[ 
	 { 
							  
							    "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + N',
								"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',	
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
							       "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + N',  
							     "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   
							        "column": "Organization",  
							       "parent":null,                      
							     "description" :"Organization",   
							     "processingMethod" :"RpOrganizationSel",   
							     "sortOrder":3,  
							        "operator":"in",   
							      "required":1,             
							        "defaultValue":null  
							        
							      },  


								    {   
							       "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + N',  
							     "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   
							      "column": "Office",  
							       "parent":"Organization",    
							       "description" :"Office",   
							       "processingMethod" :"RpOfficeSelByOrganization",  
							        "sortOrder":0,  
							       "operator":"in",   
							      "required":0,             
							     "defaultValue":null  
							     }		,



							      {   
							       "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + N',  
							     "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   
							        "column": "AsOfDate",  
							       "parent":null,                      
							     "description" :"AsOfDate",   
							     "processingMethod" :null,   
							     "sortOrder":2,  
							        "operator":"equals",   
							      "required":1,             
							        "defaultValue":null  
							        
							      }



        ]    
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'SalesComparisonsFourWeeksWithPriorYear';

                --- Fill Ratio
                SELECT @Json = N'{"report" :"FillRatio",  
     "description" :"This report shows the ratio of filled employees and showed employees. Fill ratio is defined by placed versus required employees whereas showed ratio is defined by the number of employees having transactions versus placed employees.",  
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + N',  
          "categoryListItemId":' + CAST(@JobAssignmentListItemId AS VARCHAR (MAX)) + ',  
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + N' ,  
         "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
   
     "reportParameter":[ 
	 { 
							  
							    "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + N',
								"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',	
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
       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',          
       "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',            
       "column": "DateType",           
       "parent":null,          
       "description" :"Date Type",   
       "processingMethod" :"RpFillingRatioDateTypeSel",           
          "sortOrder":2,          
          "operator":"equals",           
       "required":0        
       },  
							  


								  {   
							       "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + N',  
							     "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   
							        "column": "StartDate",  
							       "parent":null,                      
							     "description" :"Start Date",   
							     "processingMethod" :null,   
							     "sortOrder":3,  
							        "operator":"equals",   
							      "required":1,             
							        "defaultValue":null  
							        
							      },  

							      {   
							       "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + N',  
							     "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   
							        "column": "EndDate",  
							       "parent":null,                      
							     "description" :"End Date",   
							     "processingMethod" :null,   
							     "sortOrder":4,  
							        "operator":"equals",   
							      "required":1,             
							        "defaultValue":null  
							        
							      },  

								 
		 {   
      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',  
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',   
          "column": "Company",  
          "parent":null,             
        "description" :"Company",  
        "processingMethod" :"RpOrganizationSel",    
        "sortOrder":5,  
        "operator":"in",   
        "required":0,          
           "defaultValue":null  
         },  
         {   
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',  
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',   
         "column": "Office",  
          "parent":"Company",       
          "description" :"Office",   
          "processingMethod" :"RpOfficeByOrganizationSel",  
           "sortOrder":6,  
          "operator":"in",   
        "required":0,             
        "defaultValue":null  
        }  ,

		 {     
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + ',    
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
          "column": "Customer",    
          "parent":null,               
        "description" :"Customer",    
        "processingMethod" :null,      
         "sortOrder":7,    
           "operator":"contains",     
         "required":1,            
           "defaultValue":null    
         }

		 

	  
         

        ]    
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'Fill Ratio';

                --TurnOver        
                SELECT @Json = '{"report" :"TurnOver",          
"description" :"This report is used to provide employee turnover rates that were actively working or ended their assignment within the date range. This report can be filtered by client/job. ",          
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',          
  "categoryListItemId":' + CAST(@JobAssignmentListItemId AS VARCHAR (MAX)) + ',          
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' , 
	"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
         },{           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "StartDate",          
          "parent":null,                              
        "description" :"Start Date",           
        "processingMethod" :null,           
        "sortOrder":2,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         },{           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "EndDate",          
          "parent":null,                              
        "description" :"End Date",           
        "processingMethod" :null,           
        "sortOrder":3,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         } ,{           
          "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "FilterBy",          
          "parent":null,                              
        "description" :"Filter By",           
        "processingMethod" :"RpFilterBySel",           
        "sortOrder":4,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null               
                   
         },{           
          "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "FilterByValue",          
          "parent":null,                              
        "description" :"Filter By Value",           
        "processingMethod" :null,           
        "sortOrder":5,          
           "operator":"contains",           
         "required":1,                     
           "defaultValue":[{"key":"FilterByValue","value":"%","isParameter":1}]           
                   
         },{           
          "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "Department",          
          "parent":null,                              
        "description" :"Department",           
        "processingMethod" :null,           
        "sortOrder":6,          
           "operator":"contains",           
         "required":0,                     
           "defaultValue":[{"key":"Department","value":"%","isParameter":1}]           
                   
         },{           
          "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "Shift",          
          "parent":null,                              
        "description" :"Shift",           
        "processingMethod" :null,           
        "sortOrder":7,          
           "operator":"contains",           
         "required":0,                     
           "defaultValue":[{"key":"Shift","value":"%","isParameter":1}]           
                   
         },{           
          "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "JobTitle",          
          "parent":null,                              
        "description" :"Job Title",           
        "processingMethod" :null,           
        "sortOrder":8,          
           "operator":"contains",           
         "required":0,                     
           "defaultValue":[{"key":"JobTitle","value":"%","isParameter":1}]    
                   
         },{           
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "TurnoverEndReason",          
          "parent":null,                              
        "description" :"Turnover End Reason",           
        "processingMethod" :"RpListItemSel",           
        "sortOrder":9,          
           "operator":"in",           
         "required":0,                     
           "defaultValue":[{"key":"Category","value":"EndReason","isParameter":1}]                
                   
         },{           
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
           "column": "ExcludedEndReason",          
          "parent":null,                              
        "description" :"Excluded End Reason",           
        "processingMethod" :"RpListItemSel",           
        "sortOrder":10,          
           "operator":"in",           
         "required":0,                     
           "defaultValue":[{"key":"Category","value":"EndReason","isParameter":1}]                
                   
         },{           
                       
               "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "ReportId",          
              "parent":null,                              
            "description" :"Report Id",           
            "processingMethod" :null,           
            "sortOrder":11,          
               "operator":"equals",           
             "required":0,                     
               "defaultValue":null          
             } ]            
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json;
                PRINT 'TurnOver';

                --ExecutiveSummary
                SELECT @Json = '{"report" :"ExecutiveSummary",            
     "description" :"This report is a combination of different charts that includes records of gross profit, gross wages, customer count, turnover ratio, fill ratio, total bill, outstanding balance, AR aging, candidate count, Employee count and user count.",            
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',            
          "categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (MAX))
                               + ',            
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,            
                      	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
                    
     "reportParameter":[{  
  
     "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + ',  
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
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',            
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             
           "column": "AccountingPeriod",            
          "parent":null,                                
        "description" :"Accounting Period",             
        "processingMethod" :null,             
        "sortOrder":2,            
           "operator":"equals",             
         "required":1,                       
           "defaultValue":null   } ,
		  
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
        }'      ;
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
                PRINT 'ExecutiveSummary';

                --- Cash Requirement
                SELECT @Json = N'{"report" :"CashRequirement",       
				"description" :"This report shows details of liabilities and the amount of cash needed to process payroll.",   
				"categoryListItemId": ' + CAST(@AccountingGLListItemId AS VARCHAR (MAX))
                               + ',   
				"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + N',            
							        
							   "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + N' ,   
						 "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',
							   "reportParameter":[    {   

           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + N',  
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',   
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
          "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',    
          "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',      
          "column": "DateType",     
          "parent":null,    
          "parentMappingId":1,     
             "description" :"DateType",    
          "processingMethod" :"RpListItemSel",     
             "sortOrder":2,    
             "operator":"equals",     
          "required":1,              
          "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]     
          },    

		  {     
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + N',    
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',     
               "column": "StartDate",    
              "parent":null,                        
            "description" :"Start Date",     
            "processingMethod" :null,     
            "sortOrder":3,    
               "operator":"equals",     
             "required":1,               
               "defaultValue":null    

             },    
             {     
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + N',    
            "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',     
               "column": "EndDate",    
              "parent":null,                        
            "description" :"End Date",     
            "processingMethod" :null,     
            "sortOrder":4,    
               "operator":"equals",     
             "required":1,               
               "defaultValue":null    

             }, 
                        {   "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + N', "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   "column": "Organization",         
							   "parent":null,                    
							   "description" :"Organization",     							   
							   "processingMethod" :"RpOrganizationSel",       
							   "sortOrder":5,          
							   "operator":"in",       
							   "required":1, "defaultValue":null },    

							   {   "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + N',   "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',"column": "Office",   
							   "parent":"Organization",                  
							   "description" :"Office",          
							   "processingMethod" :"RpOfficeByOrganizationSel",     
							   "sortOrder":6,          
							   "operator":"in",       
								  "required":1,          
								 "defaultValue":null        
								 }    ,    

							  
            {     

              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',    
           "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',     
              "column": "ReportId",    
             "parent":null,                        
           "description" :"Report Id",     
           "processingMethod" :null,     
           "sortOrder":8,    
              "operator":"equals",     
            "required":0,               
              "defaultValue":null    
            }                   
								 ]         
								 }';
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'CashRequirement';


                --InvoicewithMarkupPercent
                SELECT @Json = N'{"report" :"InvoicewithMarkupPercent",  
     "description" :"This report is an invoice statement provided to the customer for all the transactions done during the billing period with the mark-up percent.",  
     "reportTypeListItemId":' + CAST(@InvoiceStyleReportTypeListItemId AS VARCHAR (10))
                               + N',  
         "categoryListItemId":' + CAST(@InvoiceListItemId AS VARCHAR (MAX)) + ', 
		   "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
                               + N',
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + N' ,  
            
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
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Category",         
        "parent":null,        
           "description" :"Category",        
        "processingMethod" :null,         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":[{"key":"Category","value":"ReportInvoiceEntity","isParameter":1}]        
        },        
         {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Entity",         
        "parent":"Category",        
           "description" :"Entity",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":3,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":null        
        },        
        {         
        "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "EntityId",         
        "parent":null,        
           "description" :"EntityId",        
        "processingMethod" :null,         
           "sortOrder":4,        
           "operator":"equals",         
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
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }        
        ]        
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'InvoicewithMarkupPercent';

                --InvoicewithMarkupandPayRate
                SELECT @Json = N'{"report" :"InvoicewithMarkupandPayRate",  
     "description" :"This report is an invoice statement provided to the customer for all the transactions done during the billing period with mark up percent and the payrate.",  
     "reportTypeListItemId":' + CAST(@InvoiceStyleReportTypeListItemId AS VARCHAR (10))
                               + N',  
         "categoryListItemId":' + CAST(@InvoiceListItemId AS VARCHAR (MAX)) + ', 
		   "reportOptionListItemId":' + CAST(@ReportOptionApplicationListItemId AS VARCHAR (MAX))
                               + N',
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + N' ,  
            
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
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Category",         
        "parent":null,        
           "description" :"Category",        
        "processingMethod" :null,         
           "sortOrder":2,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":[{"key":"Category","value":"ReportInvoiceEntity","isParameter":1}]        
        },        
         {         
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Entity",         
        "parent":"Category",        
           "description" :"Entity",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":3,        
           "operator":"equals",         
        "required":1,                   
        "defaultValue":null        
        },        
        {         
        "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "EntityId",         
        "parent":null,        
           "description" :"EntityId",        
        "processingMethod" :null,         
           "sortOrder":4,        
           "operator":"equals",         
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
        "sortOrder":5,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }        
        ]        
        }'      ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'InvoicewithMarkupandPayRate';

                --CashReceipt
                SELECT @Json = N'{"report" :"CashReceipt",       "description" :"This report all AR payments received during a given date range. It can be further filtered by Payment Type and Reason Code.",       "reportTypeListItemId":'
                               + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + N',            "categoryListItemId":'
                               + CAST(@AccountsReceivableListItemId AS VARCHAR (MAX)) + ',       "statusListItemId":'
                               + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + N' ,           "reportOptionListItemId":'
                               + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',        "reportParameter":[ 	 { 							  							    "dataTypeListItemId":'
                               + CAST(@NumberListItemId AS VARCHAR (MAX)) + N',								"visibilityListItemId":'
                               + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + N',								    "column": "UserPersonId",							   "parent":null,						   							    								"description" :"UserPersonId",									"processingMethod" :null,									"sortOrder":1,							    "operator":"equals",									 "required":1,																		    "defaultValue":null							  },							    {                         "dataTypeListItemId":'
                               + CAST(@NumberListItemId AS VARCHAR (MAX)) + ',          "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',              "column": "BatchId",            "parent":null,                              "description" :"BatchId",           "processingMethod" :null,           "sortOrder":2,             "operator":"equals",            "required":0,                        "defaultValue":[{"key":"BatchId","value":0,"isParameter":1}]           },							  {                  "dataTypeListItemId":'
                               + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',                 "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',                   "column": "DateType",                  "parent":null,                 "description" :"Date Type",          "processingMethod" :"RpPostAccountingPeriodDateSel",                     "sortOrder":3,                    "operator":"equals",                  "required":1,                           "defaultValue":[{"key":"DateType","value":"AccountingPeriodDate","isParameter":1}]                 },  							  								  {   							       "dataTypeListItemId":'
                               + CAST(@DateListItemId AS VARCHAR (MAX)) + N',  							     "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   							        "column": "StartDate",  							       "parent":null,                      							     "description" :"Start Date",   							     "processingMethod" :null,   							     "sortOrder":4,  							        "operator":"equals",   							      "required":0,             							        "defaultValue":null  							        							      },  							      {   							       "dataTypeListItemId":'
                               + CAST(@DateListItemId AS VARCHAR (MAX)) + N',  							     "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + N',   							        "column": "EndDate",  							       "parent":null,                      							     "description" :"End Date",   							     "processingMethod" :null,   							     "sortOrder":5,  							        "operator":"equals",   							      "required":0,             							        "defaultValue":null  							        							      },  								 		 {         "dataTypeListItemId":'
                               + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',          "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             "column": "Company",            "parent":null,                     "description" :"Company",          "processingMethod" :"RpOrganizationSel",            "sortOrder":6,          "operator":"in",           "required":0,                     "defaultValue":null           },           {             "dataTypeListItemId":'
                               + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',          "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',            "column": "Office",            "parent":"Company",                 "description" :"Office",             "processingMethod" :"RpOfficeByOrganizationSel",             "sortOrder":7,            "operator":"in",           "required":0,                     "defaultValue":null          },  		 	   {                   "dataTypeListItemId":'
                               + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',                  "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',                    "column": "PaymentType",                   "parent":null,                     "description" :"PaymentType",                  "processingMethod" :"RpPaymentMethodSel",                      "sortOrder":8,                     "operator":"equals",                   "required":1,                            "defaultValue":[{"key":"PaymentType","value":"All","isParameter":1}]                  },  				 {                   "dataTypeListItemId":'
                               + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',                  "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',                    "column": "ReasonCode",                   "parent":null,                     "description" :"ReasonCode",                  "processingMethod" :"RpPaymentReasonSel",                      "sortOrder":9,                     "operator":"in",                   "required":1,                            "defaultValue":null                 },  								{              "dataTypeListItemId":'
                               + CAST(@StringListItemId AS VARCHAR (MAX)) + ',          "visibilityListItemId":'
                               + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',             "column": "CustomerName",            "parent":null,                     "description" :"Customer Organization",          "processingMethod" :null,            "sortOrder":10,          "operator":"contains",           "required":0,                     "defaultValue":[{"key":"CustomerName","value":"%","isParameter":1}]           }  ,{                                                 "dataTypeListItemId":'
                               + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',                      "visibilityListItemId":'
                               + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',                          "column": "ReportId",                        "parent":null,                                          "description" :"Report Id",                       "processingMethod" :null,                       "sortOrder":11,                         "operator":"equals",                        "required":0,                                    "defaultValue":null                       }                  ]            }';
                EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
                PRINT 'CashReceipt';




                SELECT @Json = '{"report" :"WorkerCompCost",        
     "description" :"This report shows total worker comp wages, rates, and cost. It can be further filtered with a group by Office/ Customer/ State/ WC Code/ Employee to see detail and summary. The WC Rate is calculated using the formula WC Cost divided by WC Wage.",        
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ', 
	 "categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (MAX)) + ',

	"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + ',				
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ' ,        
                  
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
        "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DateType",                  
           "description" :"DateType",        
        "processingMethod" :"RpListItemSel",         
           "sortOrder":2,        
           "operator":"equals",         
        "required":0,                  
        "defaultValue":[{"key":"Category","value":"ReportDateType","isParameter":1}]        
        },        

		  {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },   

		  {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },          
         {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
        "description" :"Company",        
        "processingMethod" :"RpOrganizationSel",          
         "sortOrder":5,        
           "operator":"in",         
         "required":0,                
           "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
      "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
          "parent":"Company",                         
          "description" :"Office",         
          "processingMethod" :"RpOfficeByOrganizationSel",        
           "sortOrder":6,        
          "operator":"in",         
         "required":0,                   
        "defaultValue":null        
        }   ,
	
		{   
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + ',  
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',    
        "column": "GroupBy",   
           "description" :"GrouppBy",  
        "processingMethod" :"RpWCCostGroupBySel",   
           "sortOrder":7,  
           "operator":"in",   
        "required":1,            
        "defaultValue":[{"key":"GroupBy","value":"Office","isParameter":1}]   
        },
		 {     
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',    
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',     
          "column": "State",    
          "parent":null,               
        "description" :"State",    
        "processingMethod" :"RpStateSel",      
        "sortOrder":8,    
        "operator":"in",     
        "required":0,            
           "defaultValue":null   
         },
		{           
           "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',           
          "column": "Customer",          
          "parent":null,                     
        "description" :"Customer",          
        "processingMethod" :null,            
        "sortOrder":9,          
        "operator":"contains",           
        "required":0,                  
           "defaultValue":[{"key":"Customer","value":"%","isParameter":1}]          
         }    ,{           
                       
               "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + ',          
            "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
                               + ',           
               "column": "ReportId",          
              "parent":null,                              
            "description" :"Report Id",           
            "processingMethod" :null,           
            "sortOrder":10,          
               "operator":"equals",           
             "required":0,                     
               "defaultValue":null          
             } 
               
         
         ]        
         }'     ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
                PRINT 'WorkerCompCost';

				SELECT @Json = '{"report" :"LeaderBoard",          
     "description" :"Leader Board Report",          
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
               + ',          
          "category":' + CAST(@AdminListItemId AS VARCHAR (MAX)) + ',          
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + ' ,     
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
         }, {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         } ,
	 
           {           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',           
           "column": "StartDate",          
          "parent":null,                              
        "description" :"StartDate",           
        "processingMethod" :null,           
        "sortOrder":3,          
           "operator":"equals",           
         "required":1,                     
           "defaultValue":null          
                   
         },{           
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',           
           "column": "EndDate",          
          "parent":null,                              
        "description" :"EndDate",           
        "processingMethod" :null,           
        "sortOrder":4,          
           "operator":"equals",           
         "required":1,              
           "defaultValue":null } 
		 ,{         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
          "description" :"Company",        
          "processingMethod" :"RpOrganizationSel",          
          "sortOrder":5,        
          "operator":"in",         
          "required":1,                
          "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
         "parent":"Company",        
         "description" :"Office",         
         "processingMethod" :"RpOfficeByOrganizationSel",        
         "sortOrder":6,        
         "operator":"in",         
         "required":0,                   
         "defaultValue":null        
        },{           
           "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
               + ',          
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',           
          "column": "UserRole",          
          "parent":null,                     
        "description" :"User Role",          
        "processingMethod" :"RpUserRoleSel",            
         "sortOrder":7,          
           "operator":"equals",           
         "required":1,                  
           "defaultValue":null          
         }      
               ]            
        }';
EXEC dbo.SpPaginatedReportSetupIns @Json = @Json;
PRINT 'LeaderBoard';

--StaffActivity
SELECT @Json = N'{"report" :"StaffActivity",        
     "description" :"Staff Activity report",        
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
               + N',   
	 "categoryListItemId":' + CAST(@AdminListItemId AS VARCHAR (MAX)) + N',
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10)) + N' ,        
	"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
               + N',
                  
     "reportParameter":[        
           {         
                
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
               + N',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
               + N',         
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
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
               + N',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + N',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
               + N',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + N',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
                 
         {         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
               + N',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + N',         
          "column": "Recruiter",        
          "parent":null,                   
        "description" :"Recruiter",        
        "processingMethod" :"RpRecruiterSel",          
         "sortOrder":4,        
           "operator":"in",         
         "required":0,                
           "defaultValue":null        
         },
		 { 
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
               + N',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + N',		
								"column": "ShowSummary", 
							    "description" :"Show Summary",
								"processingMethod" :"RpTrueFalseSel",	
							    "sortOrder":5,
							    "operator":"equals",	
								"required":0,						    
								"defaultValue":null
								} ,
         {         
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
               + N',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
               + N',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":6,        
           "operator":"equals",         
         "required":0,                   
           "defaultValue":null        
         }
         ]        
         }';
EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json; -- varchar(max)        
PRINT 'StaffActivity';



--PayrollSummary
SELECT @Json = '{"report" :"PayrollSummary",
								"description" :"Payroll Summary Report",
								"reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
               + ',
								"categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (10))
               + ',
								"isSystem": ' + CAST(1 AS VARCHAR (10)) + ' ,
								"statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
               + ' ,
								"reportOptionListItemId":'
               + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
               + ',

								"reportParameter":[
								{

								"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
               + N',
								"visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
               + N',
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
                 
           "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@HiddenListItemId AS VARCHAR (MAX))
               + ',         
           "column": "ReportId",        
          "parent":null,                            
        "description" :"Report Id",         
        "processingMethod" :null,         
        "sortOrder":2,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
         },
		  {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',         
           "column": "StartDate",        
          "parent":null,                            
        "description" :"Start Date",         
        "processingMethod" :null,         
        "sortOrder":3,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },        
         {         
          "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',         
           "column": "EndDate",        
          "parent":null,                            
        "description" :"End Date",         
        "processingMethod" :null,         
        "sortOrder":4,        
           "operator":"equals",         
         "required":1,                   
           "defaultValue":null        
                 
         },
								{         
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',         
          "column": "Company",        
          "parent":null,                   
          "description" :"Company",        
          "processingMethod" :"RpOrganizationSel",          
          "sortOrder":5,        
          "operator":"in",         
          "required":0,                
          "defaultValue":null        
         },        
			{
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',
								"column": "GroupBy",
								"description" :"GroupBy",
								"processingMethod" :"RpPayrollSummaryGroupBySel",
								"sortOrder":6,
								"operator":"equals",
								"required":1,                
								"defaultValue":[{"key":"GroupBy","value":"Company","isParameter":1}]    
								},
			{
								"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',
								"column": "TaxType",
								"description" :"TaxType",
								"processingMethod" :"RpListItemSel",
								"sortOrder":7,
								"operator":"equals",
								"required":1,
								 "defaultValue":[{"key":"Category","value":"ReportTaxType","isParameter":1}]
								},
								
			{
								"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',
								"column": "ToInclude",
								"description" :"ToInclude",
								"processingMethod" :"RpPayrollSummaryToIncludeSel",
								"sortOrder":8,
								"operator":"equals",
								"required":0,
								 "defaultValue":null  
								},
								
			{
								"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
               + ',
								"visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
               + ',
								"column": "PersonId",
								"description" :"Person Id",
								"processingMethod" :null,
								"sortOrder":9,
								"operator":"equals",
								"required":1,
								"defaultValue":[{"key":"PersonId","value":"0","isParameter":1}]   
								}
								]
								}';
EXEC dbo.SpPaginatedReportSetupIns @Json = @Json OUTPUT;
PRINT 'PayrollSummary';


--DocumentExpiration
                SELECT @Json = '{"report" :"DocumentExpiration",        
     "description" :"This report related to the expiration Of documents",        
     "reportTypeListItemId":' + CAST(@PaginatedReportReportTypeListItemId AS VARCHAR (10))
                               + ',  
	 "categoryListItemId":' + CAST(@CommonListItemId AS VARCHAR (MAX)) + ',
     "statusListItemId":' + CAST(@ActiveStatusListItemId AS VARCHAR (10))
                               + ',    
							       
	  "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
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
           "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
          "column": "Company",        
          "parent":null,                   
          "description" :"Company",        
          "processingMethod" :"RpOrganizationSel",          
          "sortOrder":4,        
          "operator":"in",         
          "required":1,                
          "defaultValue":null        
         },        
         {         
          "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',         
         "column": "Office",        
         "parent":"Company",        
         "description" :"Office",         
         "processingMethod" :"RpOfficeByOrganizationSel",        
         "sortOrder":5,        
         "operator":"in",         
         "required":0,                   
         "defaultValue":null        
        },        
         {         
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DocumentType",         
        "parent":null,                     
         "description" :"DocumentType",        
        "processingMethod" :"RpDocumentTypeSel",         
           "sortOrder":6,        
           "operator":"in",         
        "required":1,                  
        "defaultValue":null        
        },        
         {         
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "DocumentStatus",         
        "parent":null,                     
         "description" :"DocumentStatus",        
        "processingMethod" :"RpDocumentStatusSel",         
           "sortOrder":6,        
           "operator":"in",         
        "required":1,                  
        "defaultValue":null        
        },        
         {         
        "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "ExpirationStatus",         
        "parent":null,                     
         "description" :"ExpirationStatus",        
        "processingMethod" :"RpExpirationStatusSel",         
           "sortOrder":6,        
           "operator":"in",         
        "required":1,                  
        "defaultValue":null        
        },{         
        "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + ',        
        "visibilityListItemId":' + CAST(@VisibleListItemId AS VARCHAR (MAX))
                               + ',          
        "column": "Days",         
        "parent":null,                     
         "description" :"Days",        
        "processingMethod" :"Days",         
           "sortOrder":6,        
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
           "sortOrder":10,          
              "operator":"equals",           
            "required":0,                     
              "defaultValue":null          
            }          
          ]        
         
          }'    ;
                EXEC dbo.[SpPaginatedReportSetupIns] @Json = @Json;
                PRINT 'DocumentExpiration';




            END;

            -------------------- --paginatedReport-----------------------------        
            --ARAging

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'ARAging' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)
                                               @Filename = N'ARAgingReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpARAging';
            END;
            --ARBatchReport        
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'ARBatch' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)        
                                               @Filename = N'ARBatchReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpARBatch';
            END;

            --PayCheck        
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'PayCheck' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,  -- nvarchar(1000)        
                                               @Filename = N'PayCheckReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpPaycheck';
            END;
            --PayrollRegister
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'PayrollRegister' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,         -- nvarchar(1000)
                                               @Filename = N'PayrollRegisterReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpPayrollRegister';
            END;
            --PayrollJournalReport        

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'PayrollJournal' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,        -- nvarchar(1000)        
                                               @Filename = N'PayrollJournalReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpPayrollJournal';
            END;


            --PaymentBatch
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'PaymentBatch' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,      -- nvarchar(1000)
                                               @Filename = N'PaymentBatchReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpPaymentBatch';
            END;


            --PersonResume        
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'PersonResume' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,      -- nvarchar(1000)        
                                               @Filename = N'PersonResumeReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpPersonResume';
            END;

            --InvoiceBatchReport        
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'InvoiceBatch' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,      -- nvarchar(1000)        
                                               @Filename = N'InvoiceBatchReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpInvoiceBatch';
            END;


            --PayCheckMiddle        
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'PayCheckMiddle' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,        -- nvarchar(1000)        
                                               @Filename = N'PayCheckMiddleReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpPaycheck';
            END;

            --TransactionBatchStandard
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'TransactionBatch' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,          -- nvarchar(1000)
                                               @Filename = N'TransactionBatchReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpTransactionBatch';
            END;


            --AgencyPayCheck        
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'AgencyPayCheck' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,        -- nvarchar(1000)        
                                               @Filename = N'AgencyPayCheckReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpAgencyPayCheck';
            END;

            --DeductionSubmittalReport          
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'DeductionSubmittal' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,            -- nvarchar(1000)          
                                               @Filename = N'DeductionSubmittalReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpSubmittalReport';
            END;



            --TaskReport        
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'TaskReport' ,      -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)        
                                               @Filename = N'TaskReport.xml' ,    -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpTask';
            END;


            --StatementReport        
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'Statement' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,   -- nvarchar(1000)          
                                               @Filename = N'StatementReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpStatement';
            END;


            ---Invoice
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'Invoice' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)
                                               @Filename = N'InvoiceReport.xml' ,
                                               @ProcessingMethod = 'RpInvoice';

            END;

            ---InvoicewithJobPosition
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'InvoicewithJobPosition' , -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,        -- nvarchar(1000)
                                               @Filename = N'InvoicewithJobPositionReport.xml' ,
                                               @ProcessingMethod = 'RpInvoice';

            END;


            --WorkerCompCostWithHours        
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'WorkerCompCostWithHours' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,                 -- nvarchar(1000)          
                                               @Filename = N'WorkerCompCostWithHoursReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpWorkerCompCostWithHours';
            END;


            -----AccruedHours        
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'AccruedHours' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,      -- nvarchar(1000)          
                                               @Filename = N'AccruedHoursReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpAccruedHours';
            END;

            ---DeductionSummaryReport          

            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'DeductionSummary' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,          -- nvarchar(1000)          
                                               @Filename = N'DeductionSummaryReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpDeductionSummary';
            END;


            ---BenefitSummaryReport          

            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'BenefitSummary' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,        -- nvarchar(1000)          
                                               @Filename = N'BenefitSummaryReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpBenefitSummary';
            END;




            --InvoiceRegisterReport          

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'InvoiceRegister' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,         -- nvarchar(1000)          
                                               @Filename = N'InvoiceRegisterReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpInvoiceRegister';
            END;

            --PaymentDeduction          

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'PaymentDeduction' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,          -- nvarchar(1000)          
                                               @Filename = N'PaymentDeductionReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpPaymentDeduction';
            END;

            --EmployeeWageStatement        
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'EmployeeWageStatement' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,               -- nvarchar(1000)          
                                               @Filename = N'EmployeeWageStatementReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpEmployeeWageStatement';
            END;


            --ManagmentReport          
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'Management' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,    -- nvarchar(1000)          
                                               @Filename = N'ManagementReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpManagement';
            END;


            --Gross Profit        
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'GrossProfit' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,     -- nvarchar(1000)          
                                               @Filename = N'GrossProfitReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpGrossProfit';
            END;

            --startsheet
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'StartSheet' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,    -- nvarchar(1000)        
                                               @Filename = N'StartSheetReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpStartSheet';
            END;

            ----TransactionBatchDetailReport         
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'TransactionBatchDetail' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,                -- nvarchar(1000)          
                                               @Filename = N'TransactionBatchDetailReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpTransactionBatchDetail';
            END;


            ----WCCostSummarybyCustomer  

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'WCCostSummarybyCustomer' ,       -- nvarchar(50)  
                                               @ImageFolderPath = @DatabasePath ,               -- nvarchar(1000)  
                                               @Filename = N'CustomerWCCostSummaryReport.xml' , -- nvarchar(1000)  
                                               @ProcessingMethod = 'RpWCCostSummarybyCustomer';
            END;






            --InvoiceTimeSheet
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'InvoiceTimeSheet' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,          -- nvarchar(1000)        
                                               @Filename = N'InvoiceTimeSheetReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpInvoiceTimeSheet';
            END;

            -- GrossProfitDetail
            /*not needed for ESSG*/
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'GrossProfitDetail' ,         -- nvarchar(50)            
                                               @ImageFolderPath = @DatabasePath ,           -- nvarchar(1000)            
                                               @Filename = N'GrossProfitDetailReport.xml' , -- nvarchar(1000)            
                                               @ProcessingMethod = 'RpGrossProfitDetail';
            END;


            --UnappliedCash        
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'UnappliedCash' ,         -- nvarchar(50)        
                                               @ImageFolderPath = @DatabasePath ,       -- nvarchar(1000)        
                                               @Filename = N'UnappliedCashReport.xml' , -- nvarchar(1000)        
                                               @ProcessingMethod = 'RpUnappliedCash';
            END;

            --NewHire--

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'NewHire' ,         -- nvarchar(50)  
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)  
                                               @Filename = N'NewHireReport.xml' , -- nvarchar(1000)  
                                               @ProcessingMethod = 'RpNewhire';
            END;

            --DeductionSubmittalbyOffice          
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'DeductionSubmittalbyOffice' ,       -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,                  -- nvarchar(1000)          
                                               @Filename = N'OfficeDeductionSubmittalReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpDeductionSubmittalbyOffice';
            END;

            --MigrationSummary

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'MigrationSummary' ,         -- nvarchar(50)  
                                               @ImageFolderPath = @DatabasePath ,          -- nvarchar(1000)  
                                               @Filename = N'MigrationSummaryReport.xml' , -- nvarchar(1000)  
                                               @ProcessingMethod = 'RpMigrationSummary';
            END;


            --ClientBilling Report
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'ClientBilling' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,       -- nvarchar(1000)          
                                               @Filename = N'ClientBillingReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpClientBillings';
            END;



            --Comment Report
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'Comment' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)          
                                               @Filename = N'CommentReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpComment';
            END;

            --EmployeeSummary Report
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'EmployeeSummary' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,         -- nvarchar(1000)          
                                               @Filename = N'EmployeeSummaryReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpEmployeeSummary';
            END;

            --TransactionBatchWithMargin    
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'TransactionBatchwithMargin' ,         -- nvarchar(50)    
                                               @ImageFolderPath = @DatabasePath ,                    -- nvarchar(1000)    
                                               @Filename = N'TransactionBatchwithMarginReport.xml' , -- nvarchar(1000)    
                                               @ProcessingMethod = 'RpTransactionBatchwithMargin';
            END;



            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'W24Up' ,           -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)
                                               @Filename = N'W24UpReport.xml' ,   -- nvarchar(1000)
                                               @ProcessingMethod = 'RpW24Up';
            END;

            --1099NEC Report
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'1099NEC' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)
                                               @Filename = N'1099NECReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'Rp1099NEC';
            END;

            ---TaxSummaryReport          
            BEGIN
                EXEC [dbo].[SpImportReportXML] @ReportName = N'TaxSummary' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,    -- nvarchar(1000)          
                                               @Filename = N'TaxSummaryReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpTaxSummary';
            END;

            --1095C
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'1095C' ,           -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)
                                               @Filename = N'1095CReport.xml' ,   -- nvarchar(1000)
                                               @ProcessingMethod = 'Rp1095C';
            END;

            --W2Correction
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'W2Correction' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,      -- nvarchar(1000)
                                               @Filename = N'W2CorrectionReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpW2C';
            END;

            --W2Correction
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'W2' ,              -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)
                                               @Filename = N'W2Report.xml' ,      -- nvarchar(1000)
                                               @ProcessingMethod = 'RpW2';
            END;


            --1094C
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'1094C' ,           -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath , -- nvarchar(1000)
                                               @Filename = N'1094CReport.xml' ,   -- nvarchar(1000)
                                               @ProcessingMethod = 'Rp1094C';
            END;


            --1095CLabel Report
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'1095CLabel' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,    -- nvarchar(1000)
                                               @Filename = N'1095CLabelReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'Rp1095CLabel';
            END;



            --GrossProfitSummaryReport
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'GrossProfitSummary' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,            -- nvarchar(1000)
                                               @Filename = N'GrossProfitSummaryReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpGrossProfitSummary';
            END;

            --GrossProfitbyCustomer
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'GrossProfitbyCustomer' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,               -- nvarchar(1000)
                                               @Filename = N'GrossProfitbyCustomerReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpGrossProfitbyCustomer';
            END;


            --SalesComparisonsFourWeeks
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'SalesComparisonsFourWeeks' ,   -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,             -- nvarchar(1000)
                                               @Filename = N'SalesComparisonsFourWeeks.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpSalesComparisonsFourWeeks';
            END;

            --SalesComparisonsFourWeeksWithPriorYear
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'SalesComparisonsFourWeeksWithPriorYear' ,   -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,                          -- nvarchar(1000)
                                               @Filename = N'SalesComparisonsFourWeeksWithPriorYear.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpSalesComparisonsFourWeeksWithPriorYear';
            END;

            --ExecutiveSummary
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'ExecutiveSummary' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,          -- nvarchar(1000)
                                               @Filename = N'ExecutiveSummaryReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpExecutiveSummary';
            END;

            --InvoicewithMarkupPercent
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'InvoicewithMarkupPercent' ,  -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,           -- nvarchar(1000)
                                               @Filename = N'InvoicewithMarkupReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpInvoice';
            END;

            --InvoicewithMarkupandPayRate
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'InvoicewithMarkupandPayRate' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,                     -- nvarchar(1000)
                                               @Filename = N'InvoicewithMarkupandPayRateReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpInvoice';
            END;
            --InvoicewithMarkupandPayRate
            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'WorkerCompCost' ,         -- nvarchar(50)
                                               @ImageFolderPath = @DatabasePath ,        -- nvarchar(1000)
                                               @Filename = N'WorkerCompCostReport.xml' , -- nvarchar(1000)
                                               @ProcessingMethod = 'RpWorkerCompCost';
            END;

            /* Removed Reports

			
            --OfficeTaxSummary          

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'OfficeTaxSummary' ,         -- nvarchar(50)          
                                               @ImageFolderPath = @DatabasePath ,          -- nvarchar(1000)          
                                               @Filename = N'OfficeTaxSummaryReport.xml' , -- nvarchar(1000)          
                                               @ProcessingMethod = 'RpOfficeTaxSummary';
            END;
			  ----WCCostSummary  

            BEGIN

                EXEC [dbo].[SpImportReportXML] @ReportName = N'WCCostSummary' ,         -- nvarchar(50)  
                                               @ImageFolderPath = @DatabasePath ,       -- nvarchar(1000)  
                                               @Filename = N'WCCostSummaryReport.xml' , -- nvarchar(1000)  
                                               @ProcessingMethod = 'RpWcCostSummary';
            END;
			
			*/
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                --ROLLBACK TRANSACTION;        
                THROW;
        END CATCH;

    END;
GO

