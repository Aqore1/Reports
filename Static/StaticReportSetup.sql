SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

/************* IMPORTANT *************/
/*  

-- ===================================================================        
-- Author      : Yawahang Rai        
-- Create date : 04/04/2019        
-- Description : Insert Predefined StaticReport Report       
 modified: sasita 1/12/2021: group total and grandtotal with different aggregates
 modified: sasita 2/25/2021: added employeestatus parameter and multiselect accrual plan logic for accrual balance report

 modified: sasita 6/29/2021 added minimalwage report's setup
-- ===================================================================  


 modified: Samiksha Poudel 7/20/2021 added report category update in all reporta
  modified: Sasita 9/10/2021 added GP bill column  ticket : 30090 and US: 29458
  modified: sasita 9/17/2021 added payrollregisterdetail report setup
  modified: sasita,pratigya,samiksha: 10/28/2021 added missing setups of standard reports
 --==================================================================
       -- Send report category property and value from here for each report to assign the category   
       -- if not send, Uncategorized category will be assigned     
     eg: {        
       {"report" :"ARAging",        
       "description" :"AR Aging",        
       "reportTypeListItemId": 12,        
       "category":"Employee"   -- add "category":"utility" for utility reports     
       }
       
     /* IF ANY DATE OR DATETIME TYPE COLUMNS For STATIC REPORT, MUST INSERT THE COLUMNS WITH DATE/DATETIME DATA TYPE*/        
     -- Date Format Eg: 2019-11-22 should be fetched from Report ProcessingMethod CodeEg: CAST(GETDATE() AS DATE) InsertDate AS insertDate        
     -- DateTime Format Eg: 2019-12-13T06:45:23.370 should be fetched from Report ProcessingMethod               
                            
     "sortOrder":1 in parameterValueData defines that the Parameter's order is first and  "sortOrder":2 is second and so on        
          
     ***** No need to define "sortOrder" for columnValueData: *****        
     => Column order is rendered as the column order keept in Sp data                
        
     ***** "groupOrder":1 Can be added to columnValueData: if any columns are groupped and The Order of the Groups are different from Column Order        
     eg: "Name" column in Sp is in order 1 and is isGroupped is 1 (true)        
      "Address" column in Sp is in order 2 and is isGroupped is 1 (true)        
       But the order of "Name" in Group should be 2 and "Address" should be 1        
       --------------------------------        
       Then, the data should be as:        
       --------------------------------        
       { "column":"Name", "isGroupped":1, "groupOrder":2},        
       { "column":"Address", "isGroupped":1, "groupOrder":1}        
                
       /* Parameter Start */                      
        -- creating ProcessingMethod                   
         If a report column is "company" and report parameter is "company" then the ProcessingMethod for the parameter should be "RpTblCompany"        
         Also, RpTblCompany should fetch data with atleast two keys:        
              
        Eg: companyId AS id and company AS company        
              
        Here, id is always same for every ProcessingMethod which is used as value field        
        And, company is used for display field which should be always same as the column name for which it is made        
              
        *** If you want the column name to be different, keep the value as column Alias but the column name should be same as the value field of RpTblCompany        
        Eg: columnValueData:[{"reportColumnId":0,"column":"company","alias":"companyName"}]        
                   
        -- default value for ProcessingMethod 
	   "ProcessingMethod": "RpTblListItemValue = {\"entity\":\"customer\",\"alias\":\"status\"}"          
                           
		-- for parameter's default value
		"defaultValue": "SpDefaultValueDateSel = {\"type\":\"firstOpenAccountingPeriodId\"}"  => for Id
		"defaultValue": "SpDefaultValueDateSel = {\"type\":\"firstOpenAccountingPeriod\"}"  => for date
		"defaultValue": "SpDefaultValueDateSel = {\"type\":\"firstOpenAccountingPeriod,currentOpenAccountingPeriod\"}"  => for date range
		"defaultValue": "abc" => for static value
		 => for default value having default Parameter value for ProcessingMethod eg: RpTblListItemValue
		"defaultValue": "SpDefaultValueDateSel = {\"type\":\"AllStatus\", \"defaultParam\": {\"searchText\": \"\",\"parentValue\": \"\", \"defaultParameter\":{\"category\":\"statu\s",\"alias\":\"status\",\"property\":\"relatesto\",\"propertyValue\":\"customer\"}}}"
		
		-- Note*** defaultValue ProcessingMethod  should always be OUTPUT type
				here, defaultValue is the value which will be populated in tile filter/parameter on the initial load
					> SpDefaultValueDateSel added above will fetch default value for the filter/parameter
					> {"type":"lastOpenAccountingPeriod"} will be passed to SpDefaultValueDateSel as a parameter
 
         > Pass "isVisible":0 if report parameter is hidden in UI         
         Eg: {        
         "parameterValueData": [{"reportParameterId":0,"description":"CheckDate","column":"CheckDate","operator":"between","sortOrder":1,"required":1,"isVisible":0}]        
          }        
         >  Report parameter is visible by default        
              
       If a child parameter has its Parent as required, keep the child as required        
       Eg: Company is a required parameter and its child is Office then, Offcie also should be required field   
	  
     /* Parameter End */      
	 
	 /* reportoptionListItemId */
		category : ReportOption

		ListItem : 
		1) Application : report that will be run from Other Application but not from RMS
		2) ApplicationAndShareable : both RMS and other Application
		3) Shareable: only in RMS
	
   /*Report List in ATM */	
	For Report List in ATM: ApplicationAndShareable and Shareable  reportoption type is only pulled
*/
/*
need group total and grandtotal with different aggregates 
{
  "reportColumnId": 0,
  "column": "InvoiceAmount",
  "alias": "Invoice Amount",
  "aggregation": "sum",
  "grandTotalAggregation": "average",
  "groupTotalAggregation": "min" ,
  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '
}

	  Added By Susmita on 06/22/2021 in reference to user story 27754
	  DESCRIPTION: New DataType moneyFour is added for those column having 4 decimal value
	  DECLARE @MoneyFourListItemId INT = dbo.SfListItemIdGet ('DataType', 'MoneyFour') 

	    "columnValueData":[        
          {"reportColumnId":0,"column":"ColumnName","alias":"AliasName","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyFourListItemId AS VARCHAR (MAX))
                               + '}]  
							   

		MoneyFour data type( four decimal place) for the columns :
		WCRate', 'ERTax', 'EETax', 'EmployerTax', 'Rate', 'EmployeeTax',TotalEETaxes, 

*/
ALTER PROCEDURE [dbo].[StaticReportSetup]
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY

            BEGIN TRANSACTION;

            -- Global Parameter        
            DECLARE @personIds VARCHAR (MAX) = '' ,
                    @rptParam VARCHAR (MAX);


            -- Data Types        
            DECLARE @DateListItemId INT = dbo.SfListItemIdGet ('DataType', 'Date') ,
                    @DateTimeListItemId INT = dbo.SfListItemIdGet ('DataType', 'DateTime') ,
                    @MultiSelectListItemId INT = dbo.SfListItemIdGet ('DataType', 'MultiSelect') ,
                    @SelectListItemId INT = dbo.SfListItemIdGet ('DataType', 'Select') ,
                    @StringListItemId INT = dbo.SfListItemIdGet ('DataType', 'String') ,
                    @NumberListItemId INT = dbo.SfListItemIdGet ('DataType', 'Number') ,
                    @DecimalListItemId INT = dbo.SfListItemIdGet ('DataType', 'Decimal') ,
                    @MoneyListItemId INT = dbo.SfListItemIdGet ('DataType', 'Money') ,
                    @MoneyFourListItemId INT = dbo.SfListItemIdGet ('DataType', 'MoneyFour') ,
                    @ReportOptionApplicationListItemId INT = dbo.SfListItemIdGet ('ReportOption', 'Application') ,
                    @ReportOptionApplicationAndShareableListItemId INT = dbo.SfListItemIdGet (
                                                                             'ReportOption' , 'ApplicationAndShareable') ,
                    @ReportOptionShareableListItemId INT = dbo.SfListItemIdGet ('ReportOption', 'Shareable');

            DECLARE @AccountingGLListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Accounting/GL');
            DECLARE @AccountsPayableListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'AccountsPayable');
            DECLARE @AccountsReceivableListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'AccountsReceivable');
            DECLARE @AdminListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Admin');
            DECLARE @CommonListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Common');
            DECLARE @CustomerListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Customer');
            DECLARE @EmployeeListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Employee');
            DECLARE @GrossProfitTransactionListItemId INT = dbo.SfListItemIdGet (
                                                                'ReportCategory' , 'GrossProfit/Transaction');
            DECLARE @InvoiceListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Invoice');
            DECLARE @JobAssignmentListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Job&Assignment');
            DECLARE @LogListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Log');
            DECLARE @PayrollListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Payroll');
            DECLARE @ProfitReportListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'ProfitReport');
            DECLARE @RecruitingOnboardingListItemId INT = dbo.SfListItemIdGet (
                                                              'ReportCategory' , 'Recruiting&Onboarding');
            DECLARE @TimesheetListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Timesheet');
            DECLARE @UnCategorizedListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'UnCategorized');
            DECLARE @UnemploymentListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Unemployment');
            DECLARE @UtilityListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'Utility');
            DECLARE @VacationAccrualsListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'VacationAccruals');
            DECLARE @WorkInjuryListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'WorkInjury');
            DECLARE @YearEndListItemId INT = dbo.SfListItemIdGet ('ReportCategory', 'YearEnd');


            --Employee merge Report     
            SELECT @rptParam = '
{"report":
			{"edit":"ReportDetail",
			"reportId":0,
			"report":"EmployeeMerge",
			"status":"Active", 
			"description":"This utiliity allows to merge two employee records into a single record in case of duplicate records. The records that are merged are person Id, SSN, company, person tasks, bank account, deductions, benefits, taxes, accruals, and accrual adjustments. The bad employee name will be updated as "FirstName zzzLastName" in our system." ,
			"processingMethod": "UtlEmployeeMerge",
			"categoryListItemId":' + CAST(@UtilityListItemId AS VARCHAR (MAX))
                               + ',
			"status":"Active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
			},

			"column":{"edit":"ReportProperty",
			"reportId":0,

			"columnValueData":[	
							    

							   
				  ],

"parameterValueData":[     
			{"reportParameterId":0,        
          "description":"Active Employee ID",        
           "column":"ActiveEmployeeID",         
           "processingMethod":"",        
           "operator":"equal",         
           "sortOrder":1,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
	       
		{"reportParameterId":0,        
         "description":"Inactive Employee ID",        
            "column":"InactiveEmployeeID",         
         "operator":"equal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '}
	  
	
	
							
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EmployeeMerge';

            --DeductionCode   --      
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"DeductionCode",        
           "status":"active",        
           "description":"This report shows a list of all deduction codes set up in the system.",         
           "processingMethod": "RpDeductionCodeStatic",
		    "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '

            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[],        
        
               
       "parameterValueData":[]        
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'DeductionCode';

            --BenefitCode        
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"BenefitCode",        
           "status":"active",        
           "description":"This report shows a list of all contribution codes set up in the system.",         
           "processingMethod": "RpBenefitCodeStatic",      
		    "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",   
       "reportId":0,        
        
        "columnValueData":[],        
        
               
       "parameterValueData":[]        
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'BenefitCode';

            --PayCode         
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"PayCode",        
           "status":"active",        
           "description":"This report shows a list of all pay codes set up in the system.",         
           "processingMethod": "RpPayCodeStatic", 
		   "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"active"    ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[],        
        
               
       "parameterValueData":[]        
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'PayCode';

            -- PaymentList Report          
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"PaymentList",        
           "status":"active",        
           "description":"This report shows the list of paychecks and details in a given date range.",         
           "processingMethod": "RpPaymentListStatic",   
		    "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
          {"reportColumnId":0,"column":"Net","alias":"Net","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"GrossAmount","alias":"Gross Amount","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"Tax","alias":"Tax","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"Deduction","alias":"Deduction","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"YTDGross","alias":"YTD Gross","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
            {"reportColumnId":0,"column":"CheckDate","alias":"Check Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}        
           ,        
            {"reportColumnId":0,"column":"AccountingPeriod","alias":"Accounting Period","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}        
        ],        
        
      "parameterValueData":[        
          {"reportParameterId":0,        
              "description":"Date Type",        
               "column":"DateType",         
               "processingMethod":"RpTblDateType",        
               "operator":"equal",         
               "sortOrder":1,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},  
							  {"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
                      {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":4,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
               
          {"reportParameterId":0,        
              "description":"Check Type",        
               "column":"CheckType",         
               "processingMethod":"RpTblCheckType",        
               "operator":"equal",         
               "sortOrder":7,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}, {"reportParameterId":0,        
              "description":"Check Satus",        
               "column":"CheckStatus",         
               "processingMethod":"RpTblCheckStatus",        
               "operator":"in",         
               "sortOrder":8,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'PaymentList';

            --AccrualBalance   done     
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"AccrualBalance",        
           "status":"active",        
           "description":"This report shows PTO accruals setup per employee along with its balance.",         
           "processingMethod": "RpAccrualBalanceStatic", 
		   "categoryListItemId":' + CAST(@VacationAccrualsListItemId AS VARCHAR (MAX))
                               + ',  
            "status":"active"  , 
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '      
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
        {"reportColumnId":0,"column":"Balance","alias":"Balance","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"Available","alias":"Available","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}   ,
							   
							    {"reportColumnId":0,"column":"LastCheckDate","alias":"Last Check Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}         
                  
                  
        ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"Accrual Plan",        
            "column":"AccrualPlan",         
         "processingMethod":"RpTblAccrualPlan",        
         "operator":"in",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,    
         "description":"Employee Status",    
            "column":"EmployeeStatus",  
  "processingMethod": "RpTblListItemValue = {\"category\":\"status\",\"alias\":\"status\",\"property\":\"relatesto\",\"propertyValue\":\"AccrualBalanceStatic\"}",  
  
         "operator":"in",     
         "sortOrder":2,    
         "required":0,    
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '} ]        
        },   
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'AccrualBalance';


            --PayrollAccrual        done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"PaymentAccrual",        
           "status":"active",        
           "description":"This report shows PTO accruals calculated for the selected accrual plan in a given date range.",         
           "processingMethod": "RpPayrollAccrualStatic", 
		   "categoryListItemId":' + CAST(@VacationAccrualsListItemId AS VARCHAR (MAX))
                               + ',  
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
       {"reportColumnId":0,"column":"Previous","alias":"Previous","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"Accrue","alias":"Accrue","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"Deplete","alias":"Deplete","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"Balance","alias":"Balance","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"Available","alias":"Available","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},        
        
          {"reportColumnId":0,"column":"RTPayHours","alias":"RT Pay Hours","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"DTPayHours","alias":"DT Pay Hours","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"OTPayHours","alias":"OT Pay Hours","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"HolPayHours","alias":"Hol Pay Hours","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"PTOPayHours","alias":"PTO Pay Hours","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportColumnId":0,"column":"OtherPayHours","alias":"Other Pay Hours","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}         
        ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"Accrual Plan",        
          "processingMethod":"RpTblAccrualPlan",        
            "column":"AccrualPlan",         
         "operator":"equal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
         "description":"Accounting Period Date",        
            "column":"AccountingPeriodDate",         
         "operator":"between",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'PaymentAccrual';

            ---PTO Detail        

            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"PTOAccrualSetupDetail",        
           "status":"active",        
           "description":"This report shows PTO accrual detail data, PTO accrual plan set up for each employee, and their balance.",         
           "processingMethod": "RpPTOAccrualSetupDetailStatic",         
           "categoryListItemId":' + CAST(@VacationAccrualsListItemId AS VARCHAR (MAX))
                               + '        ,
            "status":"active"  ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		 {"reportColumnId":0,"column":"Rate","alias":"Rate","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyFourListItemId AS VARCHAR (MAX))
                               + '}, 
							    {"reportColumnId":0,"column":"BalanceUnit","alias":"Balance Unit","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}, 
							    {"reportColumnId":0,"column":"PayPeriodLimit","alias":"Pay Period Limit","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}, 
		
           {"reportColumnId":0,"column":"YearlyLimit","alias":"Yearly Limit","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},        
        {"reportColumnId":0,"column":"LastPayRate","alias":"Last Pay Rate","aggregation":"average",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
        
       ],        
        
       "parameterValueData":[        
          {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":1,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
       {"reportParameterId":0,        
         "description":"Accrual Plan",        
            "column":"AccrualPlan",         
         "processingMethod":"RpTblAccrualPlan",        
         "operator":"in",         
         "sortOrder":3,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}        
                  
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'PTO Detail';




            ---Assignment List       
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"AssignmentList",
"status":"active",
"description":"Assignment List Report",
"processingMethod": "RpAssignmentListStatic",
"categoryListItemId":' + CAST(@JobAssignmentListItemId AS VARCHAR (MAX))
                               + ' ,
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[{"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
{"reportColumnId":0,"column":"ReturnType","alias":"Return Type","aggregation":"groupby","isGroupped":1,"groupOrder":3,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
{"reportColumnId":0,"column":"AssignmentId","alias":"Assignment Id","aggregation":"count",
"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},{"reportColumnId":0,"column":"SalaryPayRate","alias":"Salary Pay Rate","aggregation":"",
"dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
{"reportColumnId":0,"column":"SalaryBillRate","alias":"Salary Bill Rate","aggregation":"",
"dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportColumnId":0,"column":"RTPayRate","alias":"RT Pay Rate","aggregation":"",
"dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportColumnId":0,"column":"OTPayRate","alias":"OT Pay Rate","aggregation":"",
"dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportColumnId":0,"column":"DTPayRate","alias":"DT Pay Rate","aggregation":"",
"dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
							   
{"reportColumnId":0,"column":"RTBillRate","alias":"RT Bill Rate","aggregation":"",
"dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
							   
{"reportColumnId":0,"column":"OTBillRate","alias":"OT Bill Rate","aggregation":"",
"dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
							   
{"reportColumnId":0,"column":"DTBillRate","alias":"DT Bill Rate","aggregation":"",
"dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}

],

"parameterValueData":[{"reportParameterId":0,
"description":"Assignment Date",
"column":"AssignmentDate",
"operator":"between",
"sortOrder":1,
"required":1,
"isVisible":1,
"dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
{"reportParameterId":0,
"description":"ReturnType",
"column":"ReturnType",
"processingMethod":"RpTblReturnType",
"operator":"equals",
"sortOrder":2,
"required":0,
"isVisible":1,
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
{"reportParameterId":0,
"description":"Company",
"column":"Company",
"processingMethod":"RpTblTenantOrganization",
"operator":"in",
"sortOrder":3,
"required":1,
"isVisible":1,
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
{"reportParameterId":0,
"description":"Office",
"column":"Office",
"processingMethod":"RpTblOffice",
"parent": "Company",
"operator":"in",
"sortOrder":4,
"required":1,
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
{"reportParameterId":0,
"description":"Person",
"column":"Person",
"processingMethod":"",
"parent": "",
"operator":"contains",
"sortOrder":5,
"required":0,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
{"reportParameterId":0,
"description":"Customer",
"column":"Customer",
"processingMethod":"",
"operator":"contains",
"sortOrder":6,
"required":0,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,

{"reportParameterId":0,
"description":"End Reason",
"column":"EndReason",
"processingMethod": "RpTblListItemValue = {\"category\":\"EndReason\",\"alias\":\"endReason\"}",
"operator":"in",
"sortOrder":7,
"required":0,
"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + '}

]
},

"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'Assignment List';


            --CommentReportStatic done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
											"reportId":0,
											"report":"Comment",
											"status":"Active",
											"description":"This report shows comments inserted for the corresponding entity if any.", 
											"processingMethod": "RpCommentStatic",
											 "categoryListItemId":' + CAST(@CommonListItemId AS VARCHAR (MAX))
                               + ',  
											 "status":"Active",
											 "reportOptionListItemId":'
                               + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + '
											 },

						"column":{"edit":"ReportProperty",
							"reportId":0,

							  "columnValueData":[
						
							   {"reportColumnId":0,"column":"Alias","alias":"Alias","aggregation":"groupby","isGroupped":1,"groupOrder":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},{"reportColumnId":0,"column":"Date","alias":"Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '} 
							   
							   				    			    			    
							 ],
							   
							"parameterValueData":[{"reportParameterId":0,
								 "description":"Insert Date From",
							     "column":"InsertDateFrom", 
								 "operator":"greaterthanorequal", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
								 "description":"Insert Date To",
							     "column":"InsertDateTo", 
								 "operator":"lessthanorequal", 
								 "sortOrder":2,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								  {"reportParameterId":0,
							       "description":"RelatesTo",
							        "column":"RelatesTo", 
							        "processingMethod": "RpTblPersonOrOrganization",
							       "requireValueAsParent":1,
								   "operator":"in", 
							        "sortOrder":3,
									"required":1,
									"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
				    {"reportParameterId":0,
							       "description":"Name",
							        "column":"Name",
							        "operator":"contains", 
							        "sortOrder":4,
									"required":0,
									"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
				   	
								{"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":5,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
				   
							   {"reportParameterId":0,
							       "description":"Office",
							        "column":"Office", 
							        "processingMethod":"RpTblOffice",
									"parent": "Company",
							        "operator":"in", 
							        "sortOrder":6,
									"required":0,
									"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
								  {"reportParameterId":0,
							       "description":"Comment Type",
							        "column":"CommentType", 
							        "processingMethod":"RpTblCommentType",
							        "operator":"in", 
							        "sortOrder":7,
									"required":0,
									"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							
							   {"reportParameterId":0,
							       "description":"CommentBy",
							        "column":"CommentBy", 
							        "processingMethod":"RpTblCommentBy",
							        "operator":"in", 
							        "sortOrder":8,
									"required":0,
									"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
				    {"reportParameterId":0,
							       "description":"Show Detail",
							       "column":"ShowDetail", 	  
							       "processingMethod":"RpTblTruefalse",
							       "operator":"equals", 
							       "sortOrder":9,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
							       "description":"Subject",
							        "column":"Subject", 
							        "processingMethod":"",
							        "operator":"contains", 
							        "sortOrder":10,
									"required":0,
									"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
				   ]
								},
								"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'CommentReport';




            ---Missing Time Card   done     
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"MissingTimeCard",        
           "status":"active",        
           "description":"This report shows all assignments that were active but didn''t have timesheets records for the selected accounting period.",         
           "processingMethod": "RpMissingTimeCardStatic",         
           "categoryListItemId":' + CAST(@TimesheetListItemId AS VARCHAR (MAX))
                               + ',      
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		{"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},        
           {"reportColumnId":0,"column":"AssignmentId","alias":"Assignment Id","aggregation":"count",        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},{"reportColumnId":0,"column":"PayRate","alias":"Pay Rate","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportColumnId":0,"column":"BillRate","alias":"Bill Rate","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
        
                
       ],        
        
       "parameterValueData":[        
          {"reportParameterId":0,        
              "description":"AccountingPeriod",        
               "column":"AccountingPeriod",         
               "processingMethod":"RpTblAccountingPeriod",        
         "isVisible":1,        
         "parent": "",        
               "operator":"equals",         
               "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":2,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}        
               
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'Missing Time Card';


            --DailyTime         done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"DailyTime",        
           "status":"active",        
           "description":"This report shows all daily time punches and its details entered in a system in a given date range.",         
           "processingMethod": "RpDailyTimeStatic", 
		    "categoryListItemId":' + CAST(@TimesheetListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
       {"reportColumnId":0,"column":"Break","alias":"Break","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"PayUnit","alias":"Pay Unit","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"BillUnit","alias":"Bill Unit","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"ClockIn","alias":"Clock In","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"BreakOut","alias":"Break Out","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportColumnId":0,"column":"BreakIn","alias":"Break In","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportColumnId":0,"column":"ClockOut","alias":"Clock Out","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '}   ,
							   {"reportColumnId":0,"column":"Hours","alias":"Hours","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} 
               
        ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"AccountingPeriod",        
            "column":"AccountingPeriod",         
         "operator":"equals",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
         "description":"Customer",        
            "column":"Customer",         
         "operator":"contains",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'DailyTime';


            -- DeductionContributionSummaryByAgency   done      
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"DeductionContributionSummaryByAgency",        
           "status":"active",        
           "description":"This report shows all deductions and contributions calculated during a date range for a specific agency.",         
           "processingMethod": "RpDeductionContributionSummaryByAgencyStatic",        
		    "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
          {"reportColumnId":0,"column":"Amount","alias":"Amount","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
							   {"reportColumnId":0,"column":"Amount","alias":"Amount","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} 
                  
                  
        ],        
        
       "parameterValueData":[

	   
	   {"reportParameterId":0,        
              "description":"Date Type",        
               "column":"DateType",         
               "processingMethod":"RpTblDateType",        
               "operator":"equal",         
               "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},

									  {"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
  
					

          {"reportParameterId":0,        
         "description":"Agency",        
            "column":"Agency",        
         "processingMethod":"RpTblAgency",         
         "operator":"in",         
         "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
         "description":"Show Details",        
            "column":"Show Details",        
         "processingMethod":"RpTblYesNo",         
         "operator":"equals",         
         "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}        
                   
                 
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'DeductionContributionSummaryByAgency';


            -- DeductionContributionSetUpByAgency         
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"DeductionContributionSetUpByAgency",        
           "status":"active",        
           "description":"This report shows all employee deductions and benefits set up for a specific agency.",         
           "processingMethod": "RpDeductionContributionSetUpByAgencyStatic",  
		    "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
                  
                  
                  
        ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"Agency",        
            "column":"Agency",        
         "processingMethod":"RpTblAgency",         
         "operator":"in",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}        
                   
                 
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'DeductionContributionSetUpByAgency';



            -- InvalidRoutingNumbers   done     
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"InvalidRoutingNumbers",        
           "status":"active",        
           "description":"This report shows the list of employee account having invalid routing numbers.",         
           "processingMethod": "RpInvalidRoutingNumbersStatic",        
            "status":"active",        
           "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX)) + ' ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
          {"reportColumnId":0,"column":"AccountingPeriod","alias":"Accounting Period","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}        
                  
                  
        ],        
        
       "parameterValueData":[{"reportParameterId":0,
								 "description":"Start Date",
							     "column":"StartDate", 
								 "operator":"greaterthanorequal", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,
								 "description":"EndDate",
							     "column":"EndDate", 
								 "operator":"lessthanorequal", 
								 "sortOrder":2,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} 
                  
                   
                 
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'InvalidRoutingNumbers';

            --WAWCCost Report     done   
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"WAWCCost",
"status":"active",
"description":"This report shows WC-related information only for WA State under the earnings category including WC rate, WC code, pay hours, etc.",
"processingMethod": "RpWAWCCostStatic",
"categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (MAX))
                               + ' ,
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	
							{"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},

							  

							{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},


							   {"reportColumnId":0,"column":"EEWCCost","alias":"EE WC Cost","aggregation":"",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},

							     {"reportColumnId":0,"column":"ERWCCost","alias":"ER WC Cost","aggregation":"",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},

							   {"reportColumnId":0,"column":"TotalCost","alias":"Total Cost","aggregation":"",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},

							  

							   {"reportColumnId":0,"column":"EERate","alias":"EE Rate","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},

							    {"reportColumnId":0,"column":"ERRate","alias":"ER Rate","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},


					

							  {"reportColumnId":0,"column":"PayHours","alias":"Pay Hours","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} 


	  ],

"parameterValueData":[         {"reportParameterId":0,        
              "description":"Date Type",        
               "column":"DateType",         
               "processingMethod":"RpTblDateType",        
               "operator":"equal",         
               "sortOrder":1,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},  
							  {"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

	  
	 {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":4,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},  
	  {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":5,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}    
	
							
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'WAWCCost';


            --StateRelatedTax done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"StateRelatedTax",        
           "status":"active",        
           "description":"This report shows local tax deductions calculated including state tax for a given date range.",         
           "processingMethod": "RpStateRelatedTaxStatic",  
		   "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"active"  ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '       
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		  {"reportColumnId":0,"column":"TaxableGross","alias":"Taxable Gross","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , 
		{"reportColumnId":0,"column":"Tax","alias":"Tax","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , 
		{"reportColumnId":0,"column":"SubjectTax","alias":"Subject Tax","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}       ],        
        
               
       "parameterValueData":[
	   {
	   "reportParameterId":0,        
         "description":"CheckDate",        
            "column":"CheckDate",         
         "operator":"between",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},	
							    {"reportParameterId":0,        
         "description":"StateCode",        
            "column":"StateCode",         
         "operator":"in",         
           "processingMethod":"RpTblState",        
         "sortOrder":2,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}
	   ]        
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'StateRelatedTax';

            --Correction Report done

            SELECT @rptParam = '{"report":{"edit":"ReportDetail",

"reportId":0,
"report":"Correction",
"status":"Active", 
"description":"This report shows the corrected invoice and payment.",
"processingMethod": "RpCorrectionStatic",
"categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',  
"status":"Active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	
						{"reportColumnId":0,"column":"RelatesTo","alias":"Relates To","aggregation":"groupby","isGroupped":1,"groupOrder":1,
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},

				   {"reportColumnId":0,"column":"AccountingPeriod","alias":"Accounting Period","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}

							   
	  ],

"parameterValueData":[     
			{"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":1,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
	       
		{"reportParameterId":0,        
         "description":"AP Date",        
            "column":"APDate",         
         "operator":"between",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}
	  
	
	
							
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'Correction';


            --EmailLogStatic  
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
											"reportId":0,
											"report":"EmailLog",
											"status":"Active",
											"description":"This report shows a log of emails sent using Zenople including receiver email Id, date, status, and so on.", 
											"processingMethod": "RpEmailLogStatic",
											 "categoryListItemId":' + CAST(@LogListItemId AS VARCHAR (MAX))
                               + ' , 
											 "status":"Active",
											 "reportOptionListItemId":'
                               + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
											 },

						"column":{"edit":"ReportProperty",
							"reportId":0,

							  "columnValueData":[
						 {"reportColumnId":0,"column":"EmailAddress","alias":"Email Address","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"To","alias":"To","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"Subject","alias":"Subject","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"ScheduleDate","alias":"Schedule Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportColumnId":0,"column":"SentDate","alias":"Sent Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"EmailStatus","alias":"Email Status","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"EmailType","alias":"Email Type","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"ServiceBatchId","alias":"Service Batch Id","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} 			    			    			    
							 ],
							   
							"parameterValueData":[{"reportParameterId":0,
								 "description":"Schedule Date",
							     "column":"ScheduleDate", 
								 "operator":"between", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
						
								{"reportParameterId":0,
							       "description":"To",
							        "column":"To",
							        "operator":"contains", 
							        "sortOrder":2,
									"required":0,
									"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
				   ]
								},
								"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EmailLogReport';


            --NewHire Report 
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"NewHire",
"status":"active",
"description":"This report shows the list of persons who have got a check in the provided date range but who haven’t got any checks in the range between the start date and the number of days (parameter value) prior to the start date.",
"processingMethod": "RpNewhireStatic",
"categoryListItemId":' + CAST(@RecruitingOnboardingListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	

	{"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
							  

	{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,
		"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},

							   {"reportColumnId":0,"column":"State","alias":"State","aggregation":"groupby","isGroupped":1,"groupOrder":3,
		"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},

  {"reportColumnId":0,"column":"SSN","alias":"SSN","aggregation":"count",
	"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}


	
	  ],

   "parameterValueData":[  
   {"reportParameterId":0,        
              "description":"Date Type",        
               "column":"DateType",         
               "processingMethod":"RpTblDateType",        
               "operator":"equal",         
               "sortOrder":1,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},  
 

  {"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

				     {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},


{"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":4,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},

		{"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}, 
		 {"reportParameterId":0,        
         "description":"StateCode",        
            "column":"StateCode",         
         "operator":"in",         
           "processingMethod":"RpTblState",        
         "sortOrder":6,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},{"reportParameterId":0,        
         "description":"Number Of Days",        
            "column":"NumberOfDays",         
         "operator":"equals",         
           "processingMethod":"",        
         "sortOrder":7,        
         "required":0,        
		 "defaultValue": "60",
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX)) + '}],

 
"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'Newhire Report';


            --UsageInfo      done  
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"UsageInfo",        
           "status":"active",        
           "description":"This report shows the count of the user for login, SMS, phone, customer, check, invoice, and the amounts for payment, gross,invoicein a month.",         
           "processingMethod": "RpUsageInfoStatic",    
		   "categoryListItemId":' + CAST(@AdminListItemId AS VARCHAR (MAX))
                               + ' , 
            "status":"active"  ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		  {"reportColumnId":0,"column":"SumGrossOfPayment","alias":"Sum Gross Of Payment","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
		{"reportColumnId":0,"column":"SumInvoiceAmount","alias":"Sum Invoice Amount","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}        ],        
        
               
       "parameterValueData":[]        
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'UsageInfo';



            -- SalesByStateAndCity Report done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"SalesByStateAndCity",
"status":"Active",
"description":"This report shows total sales, GP, gross broken down by state and city in a given date range.",
"processingMethod": "RpSalesByStateAndCityStatic",
"status":"Active",
"categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX)) + ',
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	

							   {"reportColumnId":0,"column":"TotalBill","alias":"Total Bill","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},

							     {"reportColumnId":0,"column":"Gross","alias":"Gross","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},

							   {"reportColumnId":0,"column":"EmployerTax","alias":"Employer Tax","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyFourListItemId AS VARCHAR (MAX))
                               + '},

							  

							   {"reportColumnId":0,"column":"WCCost","alias":"WC Cost","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},

							    {"reportColumnId":0,"column":"GrossProfit","alias":"Gross Profit","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
	  {"reportColumnId":0,"column":"EmployeeCount","alias":"Employee Count","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},

							    {"reportColumnId":0,"column":"GPBill","alias":"GP Bill","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}
	  
	  ],

"parameterValueData":[        {"reportParameterId":0,        
         "description":"AP Date",        
            "column":"APDate",         
         "operator":"between",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},    
							  

					{"reportParameterId":0,        
              "description":"Company",        
               "column":"Company",         
               "processingMethod":"RpTblEmployerBackOffice",        
               "operator":"in",         
               "sortOrder":2,        
         "required":0,        
 "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + '}
							
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'SalesByStateAndCity';

            --TransactionwithPayrollandInvoiceDetail
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
											"reportId":0,
											"report":"TransactionwithPayrollandInvoiceDetail",
											"status":"Active",
											"description":"This report shows pay side and bill side information of employees in a given date range.", 
											"processingMethod": "RpTransactionwithPayrollandInvoiceDetailStatic",
											 "status":"Active",
											 "categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (MAX))
                               + ',
											 "reportOptionListItemId":'
                               + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
											 },

						"column":{"edit":"ReportProperty",
							"reportId":0,	
								 "columnValueData":[
							{"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							{"reportColumnId":0,"column":"Customer","alias":"Customer","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
						 {"reportColumnId":0,"column":"Department","alias":"Department","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
								{"reportColumnId":0,"column":"InvoiceDate","alias":"Invoice Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} ,
								{"reportColumnId":0,"column":"InvoiceNumber","alias":"Invoice Number","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							 {"reportColumnId":0,"column":"Balance","alias":"Balance","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
								{"reportColumnId":0,"column":"CheckNumber","alias":"Check Number","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"EmployeeName","alias":"Employee Name","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"SSN","alias":"SSN","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"CheckDate","alias":"Check Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"TotalBillHours","alias":"Total Bill Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
								{"reportColumnId":0,"column":"TotalPayHours","alias":"Total Pay Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
								{"reportColumnId":0,"column":"TotalBill","alias":"Total Bill","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
								{"reportColumnId":0,"column":"Gross","alias":"Gross","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportColumnId":0,"column":"Tax","alias":"Tax","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"Deduction","alias":"Deduction","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
				   {"reportColumnId":0,"column":"Benefit","alias":"Benefit","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"Net","alias":"Net","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
							    {"reportColumnId":0,"column":"DD","alias":"DD","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
							    {"reportColumnId":0,"column":"CheckStatus","alias":"Check Status","aggregation":"",
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},

							    {"reportColumnId":0,"column":"TotalAdjustmentPayHours","alias":"Total Adjustment Pay Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
								{"reportColumnId":0,"column":"TotalAdjustmentBillHours","alias":"Total Adjustment Bill Hours,"aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}
							 ],
							   
							"parameterValueData":[ {"reportParameterId":0,        
              "description":"Date Type",        
               "column":"DateType",         
               "processingMethod":"RpTblDateType",        
               "operator":"equal",         
               "sortOrder":1,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},  
							  {"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

								{"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":4,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
							       "description":"Office",
							        "column":"Office", 
							        "processingMethod":"RpTblOffice",
									"parent": "Company",
							        "operator":"in", 
							        "sortOrder":5,
									"required":0,
									"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
								{"reportParameterId":0,
							       "description":"Customer",
							        "column":"Customer",
							        "operator":"contains", 
							        "sortOrder":6,
									"required":0,
									"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
				   ]
								},
								"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'PayrollWithInvoiceDetail';


            --TimeClockSetupInfo         
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
									                "reportId":0,        
									                "report":"TimeClockSetupInfo",        
									                "status":"active",        
									                "description":"This report shows all the time clock setup and property details that have active assignments in a given date range.",         
									                "processingMethod": "RpTimeClockSetupInfoStatic", 
													 "categoryListItemId":'
                               + CAST(@TimesheetListItemId AS VARCHAR (MAX))
                               + ' ,
									                 "status":"active"   ,
					"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '     
									                 },        
									             
									           "column":{"edit":"ReportProperty",        
									            "reportId":0,        
									             
									             "columnValueData":[ ],        
									             
									                    
									            "parameterValueData":[
												{"reportParameterId":0,        
         "description":"Assignment Date",        
            "column":"AssignmentDate",          
         "operator":"between",         
         "sortOrder":1,       
         "required":1,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
							  {"reportParameterId":0,        
         "description":"TimeClock Status",        
            "column":"TimeClockStatus", 
			 "processingMethod":"RpTblStatus",
         "operator":"in",         
         "sortOrder":2,       
         "required":0,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '} ]        
									                       
									               },        
									             
									             "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'TimeClockInfo';




            --EmployeeBankDetail done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
											"reportId":0,
											"report":"EmployeeBankDetail",
											"status":"Active",
											"description":"This report shows the bank account details of all employees having bank account setup.", 
											"processingMethod": "RpEmployeeBankDetailStatic",
											 "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ',
											 "status":"Active" ,
					"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '     
											 },

						"column":{"edit":"ReportProperty",
							"reportId":0,

							
							 "columnValueData":[
						 
							 ],
							"parameterValueData":[
								{"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":1,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
							       "description":"Office",
							        "column":"Office", 
							        "processingMethod":"RpTblOffice",
									"parent": "Company",
							        "operator":"in", 
							        "sortOrder":2,
									"required":0,
									"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},

							   {"reportParameterId":0,
							       "description":"On Assignment",
							        "column":"OnAssignment", 
							        "processingMethod":"RpTblYesNo",								
							        "operator":"in", 
							        "sortOrder":3,
									"required":0,
									"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
				   ]
								},
								"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EmployeeBankDetail';


            -- UserActivity Report
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
											"reportId":0,
											"report":"UserActivity",
											"status":"Active",
											"description":"This report shows the user activity in a given date range. It includes number of login, SMS, employee, customer, job, check and invoice entered.", 
											"processingMethod": "RpUserActivityStatic", 	
											"categoryListItemId":' + CAST(@AdminListItemId AS VARCHAR (MAX))
                               + ',
											 "status":"Active" ,
											"reportOptionListItemId":'
                               + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
											 },

						"column":{"edit":"ReportProperty",
							"reportId":0,
							 "columnValueData":[
							  {"reportColumnId":0,"column":"LoginCount","alias":"Login Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"SMSCount","alias":"SMS Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"CommentCount","alias":"Comment Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"EmployeeCount","alias":"Employee Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"CustomerCount","alias":"Customer Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"JobCount","alias":"Job Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"AssignmentCount","alias":"Assignment Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"TransactionCount","alias":"Transaction Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"CheckCount","alias":"Check Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"InvoiceCount","alias":"Invoice Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"TaskCount","alias":"Task Count","aggregation":"sum",
	"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '}
							 					
							 ],

							"parameterValueData":[{"reportParameterId":0,
								 "description":"Date",
							     "column":"Date", 
								 "operator":"between", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}
							    ]
								},
								"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'GetSystemUsage';


            ---GreenShadesDataPopulate
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",          
           "reportId":0,          
           "report":"GreenShadesDataPopulate",               
           "Description":"This utility is used to generate records so that these can be synced to Green Shades.",           
           "processingMethod": "RpGreenShadesDataPopulateStatic",  
		   "categoryListItemId":' + CAST(@UtilityListItemId AS VARCHAR (MAX))
                               + ',
            "status":"Active"          
            },          
          
      "column":{"edit":"ReportProperty",          
       "reportId":0,          
          
          "columnValueData":[    ],
		  

       "parameterValueData":[         
	   {"reportParameterId":0,        
         "description":"Check Date",        
            "column":"CheckDate",         
         "operator":"between",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}, 
             {"reportParameterId":0,          
          "description":"Back Office Company",          
           "column":"BackOfficeCompany",           
           "processingMethod":"RpTblTenantOrganization",          
           "operator":"in",           
           "sortOrder":2,          
              "required":1,          
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
          ]          
        },          
          
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'GreenShadesDataPopulate';


            ---I9Log Report		  done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"I9Log",        
           "status":"active",        
           "description":"This report shows the log records including the person who edited(user), date, time,  all edits, and updates of the fields in the I9 form. It can be filtered by a specific person or in the date range provided.",        
           "processingMethod": "RpI9LogStatic",         
           "categoryListItemId":' + CAST(@LogListItemId AS VARCHAR (MAX))
                               + ' ,     
            "status":"active" ,
					"reportOptionListItemId":' + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + '            
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[  
				
{"reportColumnId":0,"column":"Employee","alias":"Employee","aggregation":"groupby","isGroupped":1,"groupOrder":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},{"reportColumnId":0,"column":"TaskId","alias":"Task Id","aggregation":"groupby","isGroupped":1,"groupOrder":2,        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '}
         ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"Assigned Date",        
            "column":"AssignedDate",          
         "operator":"between",         
         "sortOrder":1,       
         "required":0,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
			      
          {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":2,        
              "required":0,        
           "isVisible":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":3,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"PersonId",        
               "column":"PersonId",         
               "processingMethod":"",        
         "parent": "",        
               "operator":"equals",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '} ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'I9Log Report';

            --AuditLog  
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"AuditLog",
"status":"Active",
"description":"Audit Log Report",
"processingMethod": "RpAuditLogStatic",
"status":"Active" ,
"categoryListItemId":' + CAST(@LogListItemId AS VARCHAR (MAX)) + ',
"reportOptionListItemId":' + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + '     
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	{"reportColumnId":0,"column":"UpdatedDate","alias":"Updated Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '}
							
	  ],

"parameterValueData":[  {"reportParameterId":0,        
         "description":"Relates To",        
            "column":"RelatesTo",   
			 "requireValueAsParent":1,
         "operator":"equal",  
		 "processingMethod":"RpTblEntity",
         "sortOrder":1,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}      ,

{"reportParameterId":0,        
              "description":"Relates To Value",        
               "column":"RelatesToValue",                               
               "operator":"contains",         
               "sortOrder":2, 			   
         "required":0,        
 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}, 
				
	  
	  {"reportParameterId":0,        
         "description":"Category",        
            "column":"Category",   
				"parent": "RelatesTo",
         "operator":"in",  
		 "processingMethod":"RpTblCategory",
         "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							   
							   {"reportParameterId":0,        
              "description":"Start Date",        
               "column":"StartDate",                               
               "operator":"greaterthanorequal",         
               "sortOrder":3, 			   
         "required":0,        
 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}   ,

 {"reportParameterId":0,        
              "description":"End Date",        
               "column":"EndDate",                               
               "operator":"lessthanorequal",         
               "sortOrder":4, 			   
         "required":0,        
 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX)) + '}
	  
	
							
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'AuditLog';




            --EstimatedW2Report
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"EstimatedW2",        
           "status":"active",        
           "description":"This report shows the W2 estimated count for the selected year for each company.",        
           "processingMethod": "RpW2EstimationStatic", 
		    "categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"active"        
            },        

		  "column":{"edit":"ReportProperty",        
		   "reportId":0,        

			  "columnValueData": [ {"reportColumnId":0,"column":"TotalEmployeesWithConsentTrue","alias":"Total Employees With Consent True","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},

							     {"reportColumnId":0,"column":"EstimatedNumberOfW2AsOfToday","alias":"Estimated Number Of W2 As Of Today","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},

							   {"reportColumnId":0,"column":"EstimatedNumberOfPaperW2","alias":"Estimated Number Of Paper W2","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},

							   {"reportColumnId":0,"column":"TotalNumberOfEmployees","alias":"Total Number Of Employees","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '}],   

		   "parameterValueData":[
			{"reportParameterId":0,        
			 "description":"Year",        
				"column":"Year",         
			 "operator":"contains",         
			 "sortOrder":1,        
			 "required":1,        
			 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ]        
			},        

			"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EstimatedW2';


            --W2 Data Validation Report
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"W2DataValidation",        
           "status":"active",        
           "description":"This report shows records by checking the validation of users for invalid SSN, duplicate SSN, invalid address, missing resident address, multiple resident addresses, etc.",        
           "processingMethod": "RpW2DataValidationStatic", 
		   "categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (MAX))
                               + ' , 
            "status":"active"        
            },        

		  "column":{"edit":"ReportProperty",        
		   "reportId":0,        

			   "columnValueData":[ {"reportColumnId":0,"column":"Message","alias":"Message","aggregation":"groupby",  "groupOrder":1      ,
			 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
						],   

		   "parameterValueData":[
			{"reportParameterId":0,        
			 "description":"Year",        
				"column":"Year",         
			 "operator":"equal",         
			 "sortOrder":1,        
			 "required":1,        
			 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}   ,
						  {"reportParameterId":0,        
					 "description":"Company",        
					  "column":"Company",         
					  "processingMethod":"RpTblTenantOrganization",        
					  "operator":"in",         
					  "sortOrder":4,        
				"required":0,        
				"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
								   ]        
			},        

			"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'W2 Data Validation Report';

            --Time Clock Punch Report done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
											"reportId":0,
											"report":"TimeClockPunch",
											"status":"Active",
											"description":"This report shows all the time clock punch details in a given date range.", 
											"processingMethod": "RpTimeClockPunchStatic",
											 "categoryListItemId":' + CAST(@TimesheetListItemId AS VARCHAR (MAX))
                               + ' ,
											 "status":"Active",
											 "reportOptionListItemId":'
                               + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
											 },

						"column":{"edit":"ReportProperty",
							"reportId":0,

							  "columnValueData":[{"reportColumnId":0,"column":"ClockInPunch","alias":"Clock In Punch","aggregation":""     ,
			 "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportColumnId":0,"column":"BreakOutPunch","alias":"Break Out Punch","aggregation":""     ,
			 "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportColumnId":0,"column":"BreakInPunch","alias":"Break In Punch","aggregation":""     ,
			 "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportColumnId":0,"column":"ClockOutPunch","alias":"Clock Out Punch","aggregation":""     ,
			 "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '}
				   
				   ],
							   
							"parameterValueData":[{"reportParameterId":0,
								 "description":"Accounting Period",
							     "column":"AccountingPeriod", 								
								 "operator":"between", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},							   
								 {"reportParameterId":0,
							       "description":"Customer",
							        "column":"Customer",
							        "operator":"contains", 
							        "sortOrder":2,
									"required":0,
									"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
								 {"reportParameterId":0,
							       "description":"Person",
							        "column":"Person",
							        "operator":"contains", 
							        "sortOrder":3,
									"required":0,
									"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
				   ]
								},
								"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'TimeClockPunch';

            --W2ElectronicDisclosureConsent Report  
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"W2ElectronicDisclosureConsent",
"status":"active",
"description":"This report shows new hire records with their status of W2 electronic consent.",
"processingMethod": "RpW2ElectronicDisclosureConsentStatic",
 "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,
"columnValueData":[	

 {"reportColumnId":0,"column":"DOB","alias":"DOB","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}   ,
							   
 {"reportColumnId":0,"column":"HireDate","alias":"Hire Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}   ,

							  {"reportColumnId":0,"column":"FirstCheckDate","alias":"First Check Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}  
	
	  ],

   "parameterValueData":[  
  

  {"reportParameterId":0,        
         "description":"Hire Date From",        
           "column":"HireDateFrom",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

				     {"reportParameterId":0,        
         "description":"Hire Date To",        
           "column":"HireDateTo",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},


{"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":3,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},

		{"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}, 
		 {"reportParameterId":0,        
         "description":"Electronic Disclosure Consent",        
            "column":"ElectronicDisclosureConsent",         
         "operator":"equals",         
           "processingMethod":"RpTblElectronicDisclosureConsent",        
         "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + '}
		 ],

 
"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'Electronic Consent Report';



            --W2PopulatedDataCheckReport
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"W2PopulatedDataCheck",        
           "status":"active",        
           "description":"This report shows the exceptions after W2 is generated in case of invalid records.",        
           "processingMethod": "RpW2DataCheckStatic", 
		    "categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (MAX))
                               + ' , 
            "status":"active"        
            },        

      "column":{"edit":"ReportProperty",        
       "reportId":0,      
	   
	    "columnValueData":[ {"reportColumnId":0,"column":"Message","alias":"Message","aggregation":"groupby",  "groupOrder":1,      
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
					],  

       "parameterValueData":[
		{"reportParameterId":0,        
         "description":"Year",        
            "column":"Year",         
         "operator":"contains",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}   ,
				   	{"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":1,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
							   ]        
        },        

        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'W2PopulatedDataCheckReport';



            ---W2 Summary Report
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",          
           "reportId":0,          
           "report":"W2Summary",               
           "description":"This report shows the summary of the total W2 count throughout the offices under the company.",           
           "processingMethod": "RpW2SummaryStatic",      
		   "categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"Active"          
            },          
          
      "column":{"edit":"ReportProperty",          
       "reportId":0,          
          
          "columnValueData":[ 

		  {"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
				   		  {"reportColumnId":0,"column":"Message","alias":"Message","aggregation":"groupby","isGroupped":1,"groupOrder":2,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}


		 
		  ],
		  

       "parameterValueData":[         
	   {"reportParameterId":0,        
			 "description":"Year",        
				"column":"Year",         
			 "operator":"equal",         
			 "sortOrder":1,        
			 "required":1,        
			 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
							   
		{"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":2,
								      "required":1,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
          ]          
        },          
          
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'W2SummaryReport';


            --NewCustomer
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"NewCustomer",
"status":"active",
"description":"This report shows all new customers that have a new job order entered for the first time in a given date range.",
"processingMethod": "RpNewCustomerStatic",
 "categoryListItemId":' + CAST(@CustomerListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	{"reportColumnId":0,"column":"FirstBillDate","alias":"First Bill Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"YTDBilling","alias":"YTD Billing","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,{"reportColumnId":0,"column":"DateEntered","alias":"Date Entered","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},{"reportColumnId":0,"column":"JobInsertedDate","alias":"Job Inserted Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}],

"parameterValueData":[           
							  {"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

	  
	 {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":3,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},  
	  {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}    
	
							
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'NewCustomer';



            --1099Summary
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"1099Summary",        
           "status":"active",        
           "description":"This report shows the summary for 1099 form verification for year-end.",        
           "processingMethod": "Rp1099SummaryStatic", 
		    "categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active"        
            },        

		  "column":{"edit":"ReportProperty",        
		   "reportId":0,        

			  "columnValueData": [ {"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
				   		  {"reportColumnId":0,"column":"Message","alias":"Message","aggregation":"groupby","isGroupped":1,"groupOrder":2,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}],   

		   "parameterValueData":[
			{"reportParameterId":0,        
			 "description":"Year",        
				"column":"Year",         
			 "operator":"equal",         
			 "sortOrder":1,        
			 "required":1,        
			 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}   ,
						  {"reportParameterId":0,        
					 "description":"Company",        
					  "column":"Company",         
					  "processingMethod":"RpTblTenantOrganization",        
					  "operator":"in",         
					  "sortOrder":4,        
				"required":1,        
				"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
								   ]        
			},        

			"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT '1099Summary';

            --940Data
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"940Data",        
           "status":"active",        
           "description":"This report shows the summary of records for verifying FUTA information for year-end.",        
           "processingMethod": "Rp940DataStatic", 
		   "categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (MAX))
                               + ',  
            "status":"active"        
            },        

		  "column":{"edit":"ReportProperty",        
		   "reportId":0,        

			  "columnValueData": [{"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
				   		  {"reportColumnId":0,"column":"Message","alias":"Message","aggregation":"groupby","isGroupped":1,"groupOrder":2,
"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}],   

		   "parameterValueData":[
			{"reportParameterId":0,        
			 "description":"Year",        
				"column":"Year",         
			 "operator":"equal",         
			 "sortOrder":1,        
			 "required":1,        
			 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}   ,
						  {"reportParameterId":0,        
					 "description":"Company",        
					  "column":"Company",         
					  "processingMethod":"RpTblTenantOrganization",        
					  "operator":"in",         
					  "sortOrder":4,        
				"required":0,        
				"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
								   ]        
			},        

			"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT '940Data';

            --GLAudit
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"GLAudit",        
           "status":"active",        
           "description":"This report shows potential discrepancies in general records created by the system.",         
           "processingMethod": "RpGLAuditStatic",         
           "categoryListItemId":' + CAST(@AccountingGLListItemId AS VARCHAR (MAX))
                               + ',        
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[{"reportColumnId":0,"column":"PossibleDiscrepancyMessage","alias":"Possible Discrepancy Message","aggregation":"groupby","isGroupped":1,"groupOrder":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
				   {"reportColumnId":0,"column":"TotalPay","alias":"Total Pay","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
				   {"reportColumnId":0,"column":"Sales","alias":"Sales","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}
        
        
       ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"AccountingPeriod",        
            "column":"AccountingPeriod",          
         "operator":"equals",         
         "sortOrder":1,       
         "required":1,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}       
               
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'GLAudit';



            ---EVerifyLog Report		  
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"EVerifyLog",        
           "status":"active",        
           "description":"This report shows the log records of the E-verify form. It will show the log records of a maximum twelve months difference between the date range.",         
           "processingMethod": "RpEVerifyLogStatic",         
           "categoryListItemId":' + CAST(@LogListItemId AS VARCHAR (MAX))
                               + ',     
            "status":"active" ,
					"reportOptionListItemId":' + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + '            
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[  
				
{"reportColumnId":0,"column":"Employee","alias":"Employee","aggregation":"groupby","isGroupped":1,"groupOrder":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
         ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"Assigned Date",        
            "column":"AssignedDate",          
         "operator":"between",         
         "sortOrder":1,       
         "required":1,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
			      
          {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":2,        
              "required":0,        
           "isVisible":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":3,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"PersonId",        
               "column":"PersonId",         
               "processingMethod":"",        
         "parent": "",        
               "operator":"equals",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,        
              "description":"EVerify Status",        
               "column":"EVerifyStatus",         
               "processingMethod":"RpTblListItemValue = {\"category\":\"EverifyStatus\",\"alias\":\"Everify Status\",\"property\":\"relatesto\",\"propertyValue\":\"\"}",  
     "operator":"in",         
               "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
							   ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EVerifyLog Report';

            --SUTA recalculate
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"SUTARecalculate",        
           "status":"active",        
           "description":"SUTA Recalculate Report",         
           "processingMethod": "RpReCalculateSUTAStatic",        
            "status":"active",
			"categoryListItemId":' + CAST(@UtilityListItemId AS VARCHAR (MAX)) + ',
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '

            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		  {"reportColumnId":0,"column":"PostDate","alias":"Post Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} , 
		{"reportColumnId":0,"column":"CheckDate","alias":"Check Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"shouldBeTaxableGross","alias":"Should Be Taxable Gross","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}  ,
				   {"reportColumnId":0,"column":"FinalTaxableGross","alias":"Final Taxable Gross","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ],        
        
               
       "parameterValueData":[{"reportParameterId":0,
								 "description":"Company",
							     "column":"Company", 
								  "processingMethod":"RpTblBackOfficeCompany",
								 "operator":"equals", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
								  
							 {"reportParameterId":0,
							       "description":"Rate",
							       "column":"Rate", 	  
							       "processingMethod":"",
							       "operator":"equals", 
							       "sortOrder":2,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
								  
							 {"reportParameterId":0,
							       "description":"Person Id",
							       "column":"PersonId", 	  
							       "processingMethod":"",
							       "operator":"equals", 
							       "sortOrder":3,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},

				    {"reportParameterId":0,
							       "description":"Update Tax",
							       "column":"UpdateTax", 	  
							       "processingMethod":"RpTblYesNo",
							       "operator":"equals", 
							       "sortOrder":4,
							       "required":1,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}, 
				   {"reportParameterId":0,
							       "description":"Update Transaction",
							       "column":"UpdateTransaction", 	  
							       "processingMethod":"RpTblYesNo",
							       "operator":"equals", 
							       "sortOrder":5,
							       "required":1,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}
							,
							{"reportParameterId":0,
							       "description":"State",
							       "column":"State", 	  
							       "processingMethod":"RpTblState",
							       "operator":"in", 
							       "sortOrder":6,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}, 

				   {"reportParameterId":0,
							       "description":"Year",
							       "column":"Year", 	  
							       "processingMethod":"RpTblAccountingYear",
							       "operator":"equals", 
							       "sortOrder":7,
							       "required":1,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}, 
				   
				   {"reportParameterId":0,
							       "description":"Incorrect Only",
							       "column":"IncorrectOnly", 	  
							       "processingMethod":"RpTblYesNo",
							       "operator":"equals", 
							       "sortOrder":8,
							       "required":1,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
				   
				   {"reportParameterId":0,
							       "description":"Wage Base",
							       "column":"WageBase", 	  
							       "processingMethod":"",
							       "operator":"equals", 
							       "sortOrder":9,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}

							
							  
							  
							   ]
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'SUTA';


            --FUTA recalculate

            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"FUTARecalculate",        
           "status":"active",        
           "description":"FUTA Recalculate Report",         
           "processingMethod": "RpReCalculateFUTAStatic",        
            "status":"active",
			"categoryListItemId":' + CAST(@UtilityListItemId AS VARCHAR (MAX)) + ',
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '

            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		  {"reportColumnId":0,"column":"PostDate","alias":"Post Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} , 
		{"reportColumnId":0,"column":"CheckDate","alias":"Check Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"shouldBeTaxableGross","alias":"Should Be Taxable Gross","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}  ,
				   {"reportColumnId":0,"column":"FinalTaxableGross","alias":"Final Taxable Gross","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ],        
        
               
       "parameterValueData":[{"reportParameterId":0,
								 "description":"Company",
							     "column":"Company", 
								  "processingMethod":"RpTblBackOfficeCompany",
								 "operator":"equals", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},

				    {"reportParameterId":0,
							       "description":"Rate",
							       "column":"Rate", 	  
							       "processingMethod":"",
							       "operator":"equals", 
							       "sortOrder":2,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
								  
						
								  
							 {"reportParameterId":0,
							       "description":"Person Id",
							       "column":"PersonId", 	  
							       "processingMethod":"",
							       "operator":"equals", 
							       "sortOrder":3,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},

				    {"reportParameterId":0,
							       "description":"Update Tax",
							       "column":"UpdateTax", 	  
							       "processingMethod":"RpTblYesNo",
							       "operator":"equals", 
							       "sortOrder":4,
							       "required":1,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}, 
				   {"reportParameterId":0,
							       "description":"Update Transaction",
							       "column":"UpdateTransaction", 	  
							       "processingMethod":"RpTblYesNo",
							       "operator":"equals", 
							       "sortOrder":5,
							       "required":1,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
							

				   {"reportParameterId":0,
							       "description":"Year",
							       "column":"Year", 	  
							       "processingMethod":"RpTblAccountingYear",
							       "operator":"equals", 
							       "sortOrder":7,
							       "required":1,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}, 
				   
				   {"reportParameterId":0,
							       "description":"Incorrect Only",
							       "column":"IncorrectOnly", 	  
							       "processingMethod":"RpTblYesNo",
							       "operator":"equals", 
							       "sortOrder":8,
							       "required":1,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
				   
				   {"reportParameterId":0,
							       "description":"Wage Base",
							       "column":"WageBase", 	  
							       "processingMethod":"",
							       "operator":"equals", 
							       "sortOrder":9,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}

							
							  
							  
							   ]
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'FUTA';

            --1095C
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"1095C",        
           "status":"active",        
           "description":"This Utility is a spreadsheet view of the 1095 C form that generates records for healthcare coverage offered or provided to an employee by an employer.",        
           "processingMethod": "Rp1095CDataPopulateStatic", 
		    "categoryListItemId":' + CAST(@YearEndListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"active"        
            },        

		  "column":{"edit":"ReportProperty",        
		   "reportId":0,        

			  "columnValueData": [],   

		   "parameterValueData":[
			{"reportParameterId":0,        
			 "description":"Year",        
				"column":"Year",         
			 "operator":"contains",         
			 "sortOrder":1,        
			 "required":1,        
			 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
							    {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":2,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							    {"reportParameterId":0,        
          "description":"Reprocess Data",        
           "column":"ReprocessData",     
		   "processingMethod":"RpTblYesNo",
           "operator":"equals",         
           "sortOrder":3,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}]        
			},        

			"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT '1095C';



            --EssentialStaffCare
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"EssentialStaffCare",        
           "status":"active",        
           "description":"This report shows information filled by employees in the Essential Staff Care enrollment form including declining or acceptance of different plans.",         
           "processingMethod": "RpEssentialStaffCareStatic", 
            "status":"active" ,
				"categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ' ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[],        
        
      "parameterValueData":[        
           
							  {"reportParameterId":0,        
         "description":"Insert Date",        
           "column":"InsertDate",         
         "operator":"between",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
                      {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":2,        
            "required":1,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
               							   
								 {"reportParameterId":0,
							       "description":"PersonId",
							        "column":"PersonId",
							        "operator":"equals", 
							        "sortOrder":5,
									"required":0,									
									"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '}]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EssentialStaffCare';

            --SMS
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"TextingDetail",        
           "status":"active",        
           "description":"This report shows all details of any texting sent from and received in the Zenople system. It can be used to identify specific text''s delivery time or to find the total count of texts.",         
           "processingMethod": "RpTextingDetailStatic",        
            "status":"active",
			"categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX)) + ',
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '

            }, 

      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		  {"reportColumnId":0,"column":"SMSCount","alias":"SMS Count","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '} , 
		{"reportColumnId":0,"column":"ScheduleDate","alias":"Schedule Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"SentDate","alias":"SentDate","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}    ],        
        
               
       "parameterValueData":[{"reportParameterId":0,
								 "description":"Insert Date",
							     "column":"InsertDate", 
								 "operator":"between", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								  
							 {"reportParameterId":0,
							       "description":"Phone Profile Name",
							       "column":"PhoneProfileName", 	  
							       "processingMethod":"RpTblPhoneProfileName",
							       "operator":"in", 
							       "sortOrder":2,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
								  
							 {"reportParameterId":0,
							       "description":"SMS Type",
							       "column":"SMSType", 	  
							       "processingMethod":"RpTblSMSType",
							       "operator":"equals", 
							       "sortOrder":3,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},

				    {"reportParameterId":0,
							       "description":"Show Detail",
							       "column":"ShowDetail", 	  
							       "processingMethod":"RpTblYesNo",
							       "operator":"equals", 
							       "sortOrder":4,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}, 
				   {"reportParameterId":0,
							       "description":"Sender",
							       "column":"Sender", 	  
							       "processingMethod":"",
							       "operator":"contains", 
							       "sortOrder":5,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
							,
							{"reportParameterId":0,
							       "description":"Receiver ",
							       "column":"Receiver ", 	  
							       "processingMethod":"",
							       "operator":"contains", 
							       "sortOrder":6,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
							       "description":"Status",
							       "column":"Status", 	  
							       "processingMethod":"RpTblTextStatus",
							       "operator":"in", 
							       "sortOrder":7,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
							
							  
							   ]
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'SMS';


            --MinimalWage    
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"MinimalWage",        
           "status":"active",        
           "description":"This report shows minimum wage information setup in a Zenople system for different states, counties, and cities.",         
           "processingMethod": "RpMinimalWageStatic", 
		   "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"active"  , 
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '      
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
        {"reportColumnId":0,"column":"MinimumWage","alias":"Minimum Wage","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
        ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"Customer",        
            "column":"Customer",         
         "processingMethod":"",        
         "operator":"contains",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ]        
        },   
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'MinimalWage';



            --EmployeeAccrualHistory
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"EmployeeAccrualHistory",        
           "status":"active",        
           "description":"This report shows the vacation accrual history for a filtered employee.",         
           "processingMethod": "RpEmployeeAccrualHistoryStatic",        
            "status":"active",
			"categoryListItemId":' + CAST(@VacationAccrualsListItemId AS VARCHAR (MAX))
                               + ',
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '

            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		  {"reportColumnId":0,"column":"CheckDate","alias":"Check Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} , 
		{"reportColumnId":0,"column":"Gross","alias":"Gross","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"Tax","alias":"Tax","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"Deduction","alias":"Deduction","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"Net","alias":"Net","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"Previous","alias":"Previous","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"Accrue","alias":"Accrue","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"Deplete","alias":"Deplete","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"Balance","alias":"Balance","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"Available","alias":"Available","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"RTPayHours","alias":"RT Pay Hours","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"OTPayHours","alias":"OT Pay Hours","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"PTOPayHours","alias":"PTO Pay Hours","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
				   {"reportColumnId":0,"column":"TotalPayHours","alias":"Total Pay Hours","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} 
				   
				   
				   ],        
        
               
       "parameterValueData":[{"reportParameterId":0,
								 "description":"Person Id",
							     "column":"PersonId", 
								 "operator":"equals", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '}
							  
							  
							   ]
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EmployeeAccrualHistory';


            --MinimumWagebyCustomerWorksite    
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"MinimumWagebyCustomerWorksite",        
           "status":"active",        
           "description":"This report shows the minimum wage set up on a specific customer worksite.",         
           "processingMethod": "RpMinimumWagebyCustomerWorksiteStatic", 
		  "categoryListItemId":' + CAST(@CustomerListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active"  , 
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '      
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
        {"reportColumnId":0,"column":"MinimumWage","alias":"Minimum Wage","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
        ],        
        
       "parameterValueData":[{"reportParameterId":0,        
         "description":"Customer",        
            "column":"Customer",         
         "processingMethod":"",        
         "operator":"contains",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ]        
        },   
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'MinimumWageonJob';

            --PayrollRegisterDetail
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"PayrollRegisterDetail",        
           "status":"active",        
           "description":"This report is a spreadsheet view of the Payroll Register Report that shows records per check when show details filter and shows total per employee for the summary.",         
           "processingMethod": "RpPayrollRegisterDetailStatic",        
		    "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',  
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
        	
		       
         
{"reportColumnId":0,"column":"TotalHours","alias":"Total Hours","aggregation":"sum","dataTypeListItemId":'
                               + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,                
{"reportColumnId":0,"column":"Gross","alias":"Gross","aggregation":"sum","dataTypeListItemId":'
                               + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}



              
        ],        
        
       "parameterValueData":[

	   
	   

									  {"reportParameterId":0,        
         "description":"Check Date",        
           "column":"CheckDate",         
         "operator":"between",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
         {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":2,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":3,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},      
          {"reportParameterId":0,        
         "description":"Show Details",        
            "column":"ShowDetails",        
         "processingMethod":"RpTblYesNo",         
         "operator":"equals",         
         "sortOrder":4,    
		  "defaultValue":"No",   
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},        
                    {"reportParameterId":0,        
         "description":"Person Id",        
            "column":"PersonId",        
         "processingMethod":"",         
         "operator":"equals",         
         "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '}
                 
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'PayrollRegisterDetail';


            --- PersonAccrual
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"PersonAccrual",
"status":"active",
"description":"This report shows PTO accruals calculated broken down by accrual plan per employee.",
"processingMethod": "RpPersonAccrualStatic",
"status":"active",
 "categoryListItemId":' + CAST(@VacationAccrualsListItemId AS VARCHAR (MAX)) + ',
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	

	{"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
							  

	{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,
		"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
	{"reportColumnId":0,"column":"Accrual","alias":"Accrual","aggregation":"groupby","isGroupped":1,"groupOrder":3,
		"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
 {"reportColumnId":0,"column":"CheckDate","alias":"Check Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} ,
				    {"reportColumnId":0,"column":"ProcessDate","alias":"Process Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} ,

							  {"reportColumnId":0,"column":"Previous","alias":"Previous","aggregation":"",        
      "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,
		{"reportColumnId":0,"column":"Accrue","alias":"Accrue","aggregation":"",        
      "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,
				   	{"reportColumnId":0,"column":"Deplete","alias":"Deplete","aggregation":"",        
      "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,
		{"reportColumnId":0,"column":"Balance","alias":"Balance","aggregation":"",        
      "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} , 
		{"reportColumnId":0,"column":"Available","alias":"Available","aggregation":"",        
      "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} 
 

	
	  ],

   "parameterValueData":[
   		{"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":1,        
            "required":1,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
								   
								   {"reportParameterId":0,        
         "description":"Accrual Plan",        
            "column":"AccrualPlan",         
         "processingMethod":"RpTblAccrualPlan",        
         "operator":"in",         
         "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
								 "description":"Person Id",
							     "column":"PersonId", 
								 "operator":"equals", 
								 "sortOrder":4,
								 "required":0,
								 "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},

							    {"reportParameterId":0,        
         "description":"Include With balance",        
            "column":"IncludewithBalance",        
         "processingMethod":"RpTblYesNo",         
         "operator":"equals",         
         "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + '}  
								   ],

 
"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'Person Accrual Report';



            --EmployeeAssignmentSurvey

            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"EmployeeAssignmentSurvey",  
		   "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ',
           "status":"active",        
           "description":"This report shows the records from the employee assignment survey form which was completed by an employee after the end of each assignment.",         
           "processingMethod": "RpEmployeeAssignmentSurveyStatic",        
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '

            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		  {"reportColumnId":0,"column":"LastDayWorked","alias":"Last Day Worked","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}  ],        
        
               
       "parameterValueData":[{"reportParameterId":0,
								 "description":"Date Type",
							     "column":"DateType", 
								   "processingMethod":"RpTblTaskCompletionOrInsertDate",
								 "operator":"equal", 
								 "sortOrder":1,
								 "required":0,
								 "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,
								 "description":"Start Date",
							     "column":"StartDate", 
								 "operator":"greaterthanorequal", 
								 "sortOrder":2,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,
								 "description":"EndDate",
							     "column":"EndDate", 
								 "operator":"lessthanorequal", 
								 "sortOrder":3,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
				    {"reportParameterId":0,
							       "description":"Company",
							       "column":"Company", 	  
							       "processingMethod":"RpTblTenantOrganization",
							       "operator":"in", 
							       "sortOrder":4,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
							       "description":"Office",
							        "column":"Office", 
							        "processingMethod":"RpTblOffice",
									"parent": "Company",
							        "operator":"in", 
							        "sortOrder":5,
									"required":0,
									"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
							
							  
							  
							   ]
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EmployeeAssignmentSurvey';


            ---TaxableGrosswithDeduction


            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"TaxableGrosswithDeduction",        
           "status":"active",        
           "description":"This report shows the summary of employee taxes based on the company for the given date range. It includes pre-tax deduction, to show the difference between gross wages and taxable gross. For now, FIT, SIT, FICA, and MEDI are included.",         
           "processingMethod": "RpTaxableGrosswithDeductionStatic",   
		    "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[    
		 {"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
          {"reportColumnId":0,"column":"Checkdate","alias":"Check Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"Gross","alias":"Gross","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"TransactionType","alias":"Transaction Type","aggregation":"groupby","isGroupped":1,"groupOrder":2,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"SubjectTax","alias":"Subject Tax","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"TaxableGross","alias":"Taxable Gross","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
            {"reportColumnId":0,"column":"PreTax","alias":"Pre Tax","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
           ,        
            {"reportColumnId":0,"column":"ExcessWage","alias":"Excess Wage","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
        ],        
        
      "parameterValueData":[        
          
							  {"reportParameterId":0,        
         "description":"Check Date From",        
           "column":"CheckDateFrom",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"Check Date To",        
           "column":"CheckDateTo",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
                      {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblBackOfficeCompany",        
                  "operator":"equal",         
                  "sortOrder":3,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},        
               
          {"reportParameterId":0,        
              "description":"Transaction Type",        
               "column":"TransactionType",         
               "processingMethod":"RpTblEmployeeTransactionType",        
               "operator":"equal",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'TaxableGrosswithDeduction';



            ---BackgroundCheck

            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"BackgroundCheck",        
           "status":"active",        
           "description":"This report shows the records from the background check form which was completed by an employee.",         
           "processingMethod": "RpBackgroundCheckStatic",   
		    "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
          {"reportColumnId":0,"column":"OrderDate","alias":"Order Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"CompletionDate","alias":"Completion Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"BackgroundCheckInsertDate","alias":"Background Check Insert Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}       ,

				    {"reportColumnId":0,"column":"BackgroundCheckPackageCount","alias":"Background Check Package Count","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '} 
				   
        
        ],        
        
      "parameterValueData":[        
           
							  {"reportParameterId":0,        
         "description":"Background Check Insert Date From",        
           "column":"BackgroundCheckInsertDateFrom",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"Background Check Insert Date To",        
           "column":"BackgroundCheckInsertDateTo",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
                      {"reportParameterId":0,        
                 "description":"Show Details",        
                  "column":"ShowDetails",         
                  "processingMethod":"RpTblYesNo",        
                  "operator":"equals",         
                  "sortOrder":3,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'BackgroundCheck';


            --AdvanceBank
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"AdvanceBank",        
           "status":"active",        
           "description":"This report shows the advance bank detail of employees for the company.",         
           "processingMethod": "RpAdvanceBankStatic",  
		    "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '       
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		{"reportColumnId":0,"column":"LifeTimeLimit","alias":"Total to be paid","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"LifeTimeTotal","alias":"Total paid","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"ToBeReceived","alias":"To Be Received","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}  
		],        
        
               
       "parameterValueData":[    	{"reportParameterId":0,
							       "description":"Company",
							       "column":"Company", 	  
							       "processingMethod":"RpTblTenantOrganization",
							       "operator":"in", 
							       "sortOrder":1,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
				   ]
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'AdvanceBank';


            --MoneyNetwork
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"MoneyNetwork",
"status":"active",
"description":"Money Network Report",
"processingMethod": "RpMoneyNetworkStatic",
 "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,
"columnValueData":[	

 {"reportColumnId":0,"column":"AmountToUpload","alias":"Amount To Upload","aggregation":"sum",
 "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}

	  ],

   "parameterValueData":[  
  



  {"reportParameterId":0,        
         "description":"Start Date",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

				     {"reportParameterId":0,        
         "description":"End Date",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX)) + '}

		 ],

 
"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'MoneyNetwork';

            ---

            --PayrollAudit  done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"PayrollAudit",
"status":"Active",
"description":"Payroll Audit Report",
"processingMethod": "RpPayrollAuditStatic",
"status":"Active" ,
"categoryListItemId":' + CAST(@LogListItemId AS VARCHAR (MAX)) + ',
"reportOptionListItemId":' + CAST(@ReportOptionApplicationAndShareableListItemId AS VARCHAR (MAX))
                               + '     
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	{"reportColumnId":0,"column":"UpdatedDate","alias":"Updated Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '}
							
	  ],

"parameterValueData":[  

{"reportParameterId":0,        
              "description":"Start Date",        
               "column":"StartDate",                               
               "operator":"greaterthanorequal",         
               "sortOrder":1, 			   
         "required":1,        
 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}   ,

 {"reportParameterId":0,        
              "description":"End Date",        
               "column":"EndDate",                               
               "operator":"lessthanorequal",         
               "sortOrder":2, 			   
         "required":1,        
 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}  ,

 {"reportParameterId":0,        
              "description":"Person Id",        
               "column":"PersonId",                               
               "operator":"equals",         
               "sortOrder":3, 			   
         "required":0,        
 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX)) + '}  
	  
	  
	
							
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'PayrollAudit';


            ---Direct Deposit Detail        
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"DirectDepositDetail",        
           "status":"active",        
           "description":"This report shows the detailed record of payment by bank file type",         
           "processingMethod": "RpDirectDepositPayStatic",         
           "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ' ,
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		{"reportColumnId":0,"column":"PersonId","alias":"PersonId","aggregation":"count",
							  "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"Net","alias":"Net","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},        
           {"reportColumnId":0,"column":"Alias","alias":"Alias","aggregation":"groupby",  "isGroupped":1,"groupOrder":1,      
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}  
       ],        
        
       "parameterValueData":[        
           {
	   "reportParameterId":0,        
         "description":"Check Date",        
            "column":"CheckDate",         
         "operator":"between",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},    {"reportParameterId":0,        
         "description":"BankFileType",        
            "column":"Bank File Type",         
         "operator":"in",         
           "processingMethod":"RpTblBankFileType",        
         "sortOrder":2,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},     
          {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":3,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}     
               
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';

            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'DirectDepositDetail';

            --WeeklySalesYTDBill
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"WeeklySalesYTDBill",        
           "status":"active",        
           "description":"This shows the weekly sales YTD bill on a summary as well as detail level.",        
           "processingMethod": "RpWeeklySalesYTDBillStatic", 
		    "categoryListItemId": ' + CAST(@InvoiceListItemId AS VARCHAR (MAX))
                               + ',  
            "status":"active"        ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        "column":{"edit":"ReportProperty",
"reportId":0,
      "columnValueData":[	
							{"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
				   
							  

							{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},

							    	{"reportColumnId":0,"column":"Customer","alias":"Customer","aggregation":"groupby","isGroupped":1,"groupOrder":3,
							  "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
				    {"reportColumnId":0,"column":"Week1","alias":"Week 1","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,  {"reportColumnId":0,"column":"Week2","alias":"Week 2","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week3","alias":"Week 3","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week4","alias":"Week 4","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week5","alias":"Week 5","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week6","alias":"Week 6","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week7","alias":"Week 7","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week8","alias":"Week 8","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week9","alias":"Week 9","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week10","alias":"Week 10","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week11","alias":"Week 11","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week12","alias":"Week 12","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week13","alias":"Week 13","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week14","alias":"Week 14","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week15","alias":"Week 15","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week16","alias":"Week 16","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week17","alias":"Week 17","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week18","alias":"Week 18","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week19","alias":"Week 19","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week20","alias":"Week 20","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week21","alias":"Week 21","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week22","alias":"Week 22","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}, {"reportColumnId":0,"column":"Week23","alias":"Week 23","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week24","alias":"Week 24","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week25","alias":"Week 25","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week26","alias":"Week 26","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week27","alias":"Week 27","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week28","alias":"Week 28","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week29","alias":"Week 29","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week30","alias":"Week 30","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week31","alias":"Week 31","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week32","alias":"Week 32","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week33","alias":"Week 33","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week34","alias":"Week 34","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week35","alias":"Week 35","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week36","alias":"Week 36","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week37","alias":"Week 37","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week38","alias":"Week 38","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week39","alias":"Week 39","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week40","alias":"Week 49","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week41","alias":"Week 41","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week42","alias":"Week 42","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week43","alias":"Week 43","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week44","alias":"Week 44","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week45","alias":"Week 45","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week46","alias":"Week 46","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week47","alias":"Week 47","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week48","alias":"Week 48","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} , {"reportColumnId":0,"column":"Week49","alias":"Week 49","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,{"reportColumnId":0,"column":"Week50","alias":"Week 50","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
				   {"reportColumnId":0,"column":"Week51","alias":"Week 51","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
				    {"reportColumnId":0,"column":"Week52","alias":"Week 52","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,
				    {"reportColumnId":0,"column":"Week53","alias":"Week 53","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} 
				    ],
				   
       "parameterValueData":[
	   
	   {"reportParameterId":0,
			"description":"Year",
			"column":"Year",
			
			"operator":"equal",
			"sortOrder":1,
			"required":1,
			"dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,        
            "description":"Date Type",        
            "column":"DateType",         
            "processingMethod":"RpTblInvoiceAccoutingPeriodDate",        
            "operator":"equal",         
            "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},

{"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":3,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},  
	  {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},{"reportParameterId":0,  
                                 "description":"Roll Up To Root Customer",  
                        "column":"RollUpToRootCustomer",  
                                  "processingMethod":"RpTblTruefalse",  
                                  "operator":"equal",   
                                  "sortOrder":5,  
                            "required":1,  
                            "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},{"reportParameterId":0,  
                                 "description":"Show Summary",  
                        "column":"ShowSummary",  
                                  "processingMethod":"RpTblTruefalse",  
                                  "operator":"equal",   
                                  "sortOrder":6,  
                            "required":1,  
                            "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '} 
							   ],        
       "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            SELECT @rptParam;
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'WeeklySalesYTDBill';


            -- CustomerYeartoDate Report          
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"CustomerYearToDate",        
           "status":"active",        
           "description":"Customer Year To Date",         
           "processingMethod": "RpCustomerYeartoDateStatic",   
		    "categoryListItemId":' + CAST(@CustomerListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
         {"reportColumnId":0,"column":"Year","alias":"Year","aggregation":"groupby","isGroupped":1,"groupOrder":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
		 
		 {"reportColumnId":0,"column":"YTDSales","alias":"YTD Sales","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"YTDDiscount","alias":"YTD Discount","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"YTDCharge","alias":"YTD Charge","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"YTDSalesTax","alias":"YTD Sales Tax","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
           {"reportColumnId":0,"column":"YTDTotalBill","alias":"YTD Total Bill","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
          ,        
            {"reportColumnId":0,"column":"YTDInvoiceAmount","alias":"YTD Invoice Amount","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}        
                 
        ],        
        
      "parameterValueData":[        
          {"reportParameterId":0,        
              "description":"Date Type",        
               "column":"DateType",         
               "processingMethod":"RpTblApInvoiceDateType",        
               "operator":"equal",         
               "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},  
							  {"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
                      {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":4,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
               
           {"reportParameterId":0,        
          "description":"Customer",        
           "column":"Customer",         
           "processingMethod":"",        
           "operator":"contains",         
           "sortOrder":6,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}  ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'CustomerYeartoDate Report';


            --ActiveEmployees


            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"ActiveEmployees",
"status":"active",
"description":"Active Employees Report",
"processingMethod": "RpActiveEmployeesStatic",
 "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,
"columnValueData":[	

 {"reportColumnId":0,"column":"Company","alias":"Company","aggregation":"groupby","isGroupped":1,"groupOrder":1,
 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
	

 {"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,
 "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}

	  ],

   "parameterValueData":[  
  



  {"reportParameterId":0,        
         "description":"Insert Date From",        
           "column":"InsertDateFrom",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

				     {"reportParameterId":0,        
         "description":"Insert Date To",        
           "column":"InsertDateTo",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

		 {"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":3,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},

		{"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + '} 

		 ],

 
"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'ActiveEmployee';


            --EmployeePayrollSummary

            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"EmployeePayrollSummary",
"status":"active",
"description":"Employee Payroll Summary Report",
"processingMethod": "RpEmployeePayrollSummaryStatic",
  "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	

							   {"reportColumnId":0,"column":"Gross","alias":"Gross","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},

							   {"reportColumnId":0,"column":"Tax","alias":"Tax","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},

								   
								   {"reportColumnId":0,"column":"Deduction","alias":"Deduction","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"Net","alias":"Net","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"YTDGross","alias":"YTD Gross","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"RTHours","alias":"RT Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"OTHours","alias":"OT Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"DTHours","alias":"DT Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"HolHours","alias":"HolHours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"PTOHours","alias":"PTO Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"OtherHours","alias":"Other Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}


	  ],

"parameterValueData":[    
					   

{"reportParameterId":0,        
         "description":"Check Date",        
            "column":"CheckDate",         
         "operator":"between",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},    
							  

	  
	 {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":2,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},  
	  {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":3,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}    
	
							
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'EmployeePayrollSummary';



            --VaccinationTracking


            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"VaccinationTracking",        
           "status":"active",        
           "description":"Vaccination Tracking",         
           "processingMethod": "RpVaccinationTrackingStatic",   
		   "status":"active" ,
		   "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX)) + ',
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
            {"reportColumnId":0,"column":"StartDate","alias":"Start Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '}     ,
								   {"reportColumnId":0,"column":"EndDate","alias":"End Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '}     
        ],        
        
      "parameterValueData":[        
          
							  {"reportParameterId":0,        
         "description":"Completion Date From",        
           "column":"CompletionDateFrom",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"Completion Date To",        
           "column":"CompletionDateTo",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
                      {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":3,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'VaccinationTracking';


            --UserLog   
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",  
           "reportId":0,  
           "report":"UserLog",  
           "status":"Active",  
           "description":"User Log Report",   
           "processingMethod": "RpUserLogStatic",                
            "status":"Active" ,
			 "categoryListItemId":' + CAST(@AdminListItemId AS VARCHAR (MAX)) + '  ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },  
  
      "column":{"edit":"ReportProperty",  
       "reportId":0,  
  
        "columnValueData":[  

		{"reportColumnId":0,"column":"InsertDate","alias":"Insert Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '} 
        
        ],  
  
       "parameterValueData":[{"reportParameterId":0,  
         "description":"Insert Date",  
            "column":"InsertDate",   
         "operator":"between",   
         "sortOrder":1,  
         "required":1,  
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX)) + '}]  
        },  
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'UserLog';


            --PersonEEO
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"PersonEEO",
"status":"active",
"description":"Person EEO Report",
"processingMethod": "RpPersonEEOStatic",
 "categoryListItemId":' + CAST(@EmployeeListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,
"columnValueData":[	
		 {"reportColumnId":0,"column":"DateOfBirth","alias":"Date Of Birth","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} 
 
	
	  ],

   "parameterValueData":[  
  

  {"reportParameterId":0,        
         "description":"DOB From",        
           "column":"DOBFrom",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

				     {"reportParameterId":0,        
         "description":"DOB To",        
           "column":"DOBTo",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},


{"reportParameterId":0,
									 "description":"Marital Status",
									  "column":"MaritalStatus", 
									  "processingMethod":"RpTblMaritalStatus",
									  "operator":"equals", 
									  "sortOrder":3,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},

		{"reportParameterId":0,        
              "description":"Gender",        
               "column":"Gender",         
               "processingMethod":"RpTblGender",        
     
               "operator":"equals",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + '}
		 ],

 
"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'PersonEEO';




            ---HowHeardOf done

            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"HowHeardOf",        
           "status":"active",        
           "description":"This report shows how a candidate has applied into a system",         
           "processingMethod": "RpHowHeardOfStatic",   
		    "categoryListItemId":' + CAST(@RecruitingOnboardingListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },  

			  
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
		{"reportColumnId":0,"column":"Alias","alias":"Alias","aggregation":"groupby","isGroupped":1,"groupOrder":1,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
			{"reportColumnId":0,"column":"Office","alias":"Office","aggregation":"groupby","isGroupped":1,"groupOrder":2,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportColumnId":0,"column":"PersonId","alias":"Person Id","aggregation":"count",     
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportColumnId":0,"column":"CompletionDate","alias":"Completion Date",     
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								    {"reportColumnId":0,"column":"Count","alias":"Count","aggregation":"sum",     
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
				    {"reportColumnId":0,"column":"PaidCount","alias":"Paid Count","aggregation":"sum",     
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '}
       ], 

       "parameterValueData":[{"reportParameterId":0,        
         "description":"Completion Date From",        
            "column":"CompletionDateFrom",          
         "operator":"greaterthanorequal",         
         "sortOrder":1,       
         "required":1,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},   
								   {"reportParameterId":0,        
         "description":"Completion Date To",        
            "column":"CompletionDateTo",          
         "operator":"lessthanorequal",         
         "sortOrder":2,       
         "required":1,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},   
          {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":3,        
              "required":0,        
           "isVisible":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}  ,
				     {"reportParameterId":0,
							       "description":"Show Detail",
							       "column":"ShowDetail", 	  
							       "processingMethod":"RpTblTruefalse",
							       "operator":"equals", 
							       "sortOrder":5,
							       "required":0,
							       "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}    
               
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';

            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'How Heard Of';

            --CustomReportStatic done
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
											"reportId":0,
											"report":"CustomReport",
											"status":"Active",
											"description":"Custom Report", 
											"processingMethod": "RpCustomStatic",
											 "categoryListItemId":' + CAST(@CustomerListItemId AS VARCHAR (MAX))
                               + ',  
											 "status":"Active",
											 "reportOptionListItemId":'
                               + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
											 },

						"column":{"edit":"ReportProperty",
							"reportId":0,

							  "columnValueData":[],
							   
							"parameterValueData":[{"reportParameterId":0,
								 "description":"Insert Date From",
							     "column":"InsertDateFrom", 
								 "operator":"greaterthanorequal", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
								 "description":"Insert Date To",
							     "column":"InsertDateTo", 
								 "operator":"lessthanorequal", 
								 "sortOrder":2,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								  {"reportParameterId":0,
							       "description":"RelatesTo",
							        "column":"RelatesTo", 
							        "processingMethod": "RpTblCustomRelatesTo",
							       "RequireParentValue":1,
								   "operator":"in", 
							        "sortOrder":3,
									"required":1,
									"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
								{"reportParameterId":0,          
							"description":"CustomType",          
							"column":"CustomType",           
							 "processingMethod":"RpTblCustomType",          
							"operator":"in",    
							"parent" : "RelatesTo",
							 "sortOrder":4,          
							 "required":1,          
							"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
				   ]
								},
								"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'CustomReport';

            --IL Suta Tax Summary   --done      
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"ILSutaTaxSummary",        
           "status":"active",        
           "description":"IL Suta Tax Summary Report",         
           "processingMethod": "RpSutaTaxSummaryStatic",
		    "categoryListItemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                               + ',
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '

            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[],        
        
               
       "parameterValueData":[{"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":3,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}
				   ]        
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'IL Suta Tax Summary';

            --JobInfo
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"JobInfo",
		    "categoryListItemId":' + CAST(@JobAssignmentListItemId AS VARCHAR (MAX))
                               + ',
           "status":"active",        
           "description":"Job Info Report",         
           "processingMethod": "RpJobInfoStatic",        
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[ 
		{"reportColumnId":0,"column":"Required","alias":"Required","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
		  {"reportColumnId":0,"column":"TotalPlaced","alias":"Total Placed","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
	    {"reportColumnId":0,"column":"TotalPay","alias":"Total Pay","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
          {"reportColumnId":0,"column":"TotalBill","alias":"Total Bill","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
		 {"reportColumnId":0,"column":"TotalPayHours","alias":"Total Pay Hours","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
		 {"reportColumnId":0,"column":"TotalBillHours","alias":"Total Bill Hours","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
		   {"reportColumnId":0,"column":"JobId","alias":"Job ID","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@NumberListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"CreatedDate","alias":"Created Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"JobStartDate","alias":"Job Start Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"JobEndDate","alias":"Job End Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"FirstAssignmentStartDate","alias":"First Assignment Start Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"LastCheckDate","alias":"Last Check Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"LastInvoiceDate","alias":"Last Invoice Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '}
								   ],        
        
               
       "parameterValueData":[
	   {"reportParameterId":0,        
         "description":"Date Type",        
            "column":"DateType",  
			"processingMethod" :"RpTblJobDate", 
         "operator":"equals",         
         "sortOrder":1,			
         "required":1,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},   
				    {"reportParameterId":0,        
         "description":"Job Date From",        
           "column":"JobDateFrom",         
         "operator":"greaterthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
					{"reportParameterId":0,        
         "description":"Job Date To",        
           "column":"JobDateTo",         
         "operator":"lessthanorequal",         
         "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
          {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":4,        
            "required":1,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}  ,
							    {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
			"parent": "Company",        
               "operator":"in",         
               "sortOrder":5,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,
							       "description":"Customer",
							        "column":"Customer",
							        "operator":"contains", 
							        "sortOrder":6,
									"required":0,
									"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}]
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'JobInfo';

            ---JobsinJobPortal Report		  
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"JobsinJobPortal",        
           "status":"active",        
           "description":"This report shows the list of jobs in the job portals.",         
           "processingMethod": "RpJobsinJobPortalStatic",         
           "categoryListItemId":' + CAST(@JobAssignmentListItemId AS VARCHAR (MAX))
                               + '      ,
            "status":"active" ,
					"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '            
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[],        
        
       "parameterValueData":[
			      {"reportParameterId":0,        
         "description":"Expiration Date From",        
            "column":"ExpirationDateFrom",          
         "operator":"greaterthanorequal",         
         "sortOrder":1,       
         "required":0,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,        
         "description":"Expiration Date To",        
            "column":"ExpirationDateTo",          
         "operator":"lessthanorequal",         
         "sortOrder":2,       
         "required":0,        
         "isVisible":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
			{"reportParameterId":0,        
          "description":"Job Status",        
           "column":"JobStatus",         
           "processingMethod":"RpTblJobStatus",        
           "operator":"in",         
           "sortOrder":3,        
              "required":0,        
           "isVisible":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
          "description":"Job Portal",        
           "column":"JobPortal",         
           "processingMethod":"RpTblJobPortal",        
           "operator":"in",         
           "sortOrder":4,        
              "required":0,        
           "isVisible":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
         ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'JobsinJobPortal';


            --Assessment Report    done    
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",

"reportId":0,
"report":"Assessment",
"status":"Active", 
"description":"Assessment Report of person" ,
"processingMethod": "RpAssessmentStatic",
"categoryListItemId":' + CAST(@UtilityListItemId AS VARCHAR (MAX)) + ',
"status":"Active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[	
							    

							   
	  ],

"parameterValueData":[     
			{"reportParameterId":0,        
          "description":"Date Type",        
           "column":"DateType",         
           "processingMethod":"RpAssessmentDateType",        
           "operator":"equal",         
           "sortOrder":1,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
	       {"reportParameterId":0,        
          "description":"Start Date",        
           "column":"StartDate",         
           "processingMethod":"",        
           "operator":"greaterthanorequal",         
           "sortOrder":2,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
	       {"reportParameterId":0,        
          "description":"End Date",        
           "column":"EndDate",         
           "processingMethod":"",        
           "operator":"lessthanorequal",         
           "sortOrder":3,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
	       {"reportParameterId":0,        
          "description":"Assessment Type",        
           "column":"AssessmentType",         
           "processingMethod":"RpAssessmentType",        
           "operator":"in",         
           "sortOrder":4,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
							   ,
	       {"reportParameterId":0,        
          "description":"Status",        
           "column":"Status",         
           "processingMethod":"RpQualifyType",        
           "operator":"in",         
           "sortOrder":5,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}  ,
	       {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":6,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
	       {"reportParameterId":0,        
          "description":"Office",        
           "column":"Office",         
		    "parent": "Company",    
           "processingMethod":"RpTblOffice",        
           "operator":"in",         
           "sortOrder":7,        
              "required":1,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
	       {"reportParameterId":0,        
          "description":"Customer",        
           "column":"Customer",       
		    "parent": "Office",
           "processingMethod":"RpTblOrganization",        
           "operator":"in",         
           "sortOrder":8,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + '}
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'Assessment';

            --Commission
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"Commission",        
           "status":"active",        
           "description":"Commission Report",         
           "processingMethod": "RpCommissionStatic", 
		    "categoryListItemId":  ' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',  
            "status":"active"        
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
     
							   {"reportColumnId":0,"column":"Person","alias":"Person","isGroupped":"1","groupOrder":"1",        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
		  {"reportColumnId":0,"column":"Sales","alias":"Sales","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
          {"reportColumnId":0,"column":"GrossProfit","alias":"Gross Profit","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"GP","alias":"GP %","aggregation":"average",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '}	,
		{"reportColumnId":0,"column":"CommissionPercent","alias":"Commission Percent","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"Commission","alias":"Commission","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}

               
        ],        
        
       "parameterValueData":[ 
							   {"reportParameterId":0,
									 "description":"AccountingPeriod",
									  "column":"AccountingPeriod", 
									
									  "operator":"between", 
									  "sortOrder":1,
								      "required":1,
								      "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":2,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},{"reportParameterId":0,
							       "description":"Office",
							        "column":"Office", 
							        "processingMethod":"RpTblOffice",
									"parent": "Company",
							        "operator":"in", 
							        "sortOrder":3,
									"required":0,
									"dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
									 "description":"User",
									  "column":"User", 
									  "processingMethod":"RpTblUser",
									  "operator":"in", 
									  "sortOrder":4,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}	,
							   {"reportParameterId":0,
									 "description":"Roll Up to Parent Customer",
									  "column":"RollUpToParentCustomer", 
									  "processingMethod":"RpTblYesNo",
									  "operator":"in", 
									  "sortOrder":5,
								      "required":0,	 
									  "defaultValue": "No",
								      "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}
							   
							   ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'Commission';


            ---GrossProfitDetail
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"GrossProfitDetail",        
           "status":"active",        
           "description":"Gross Profit Detail",         
           "processingMethod": "RpGrossProfitDetailStatic",        
		    "categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                               + ',  
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[        
        	
		       
         
{"reportColumnId":0,"column":"TotalHours","alias":"Total Hours","aggregation":"sum","dataTypeListItemId":'
                               + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,                
{"reportColumnId":0,"column":"Gross","alias":"Gross","aggregation":"sum","dataTypeListItemId":'
                               + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '}



              
        ],        
        
       "parameterValueData":[

	   
	   

		 {"reportParameterId":0,        
         "description":"Start Date",        
           "column":"StartDate",         
         "operator":"equals",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,        
         "description":"End Date",        
           "column":"EndDate",         
         "operator":"equals",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
				   {"reportParameterId":0,        
         "description":"Date Type",        
            "column":"DateType",        
         "processingMethod":"RpTblGrossDateType",         
         "operator":"equals",         
         "sortOrder":3,    
		  "defaultValue":"No",   
         "required":1,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
         {"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":4,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},      
             
                    {"reportParameterId":0,        
         "description":"Group By",        
            "column":"GroupBy",        
         "processingMethod":"RpTblGrossGroupBy",         
         "operator":"in",         
         "sortOrder":6,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '} ,
             
                    {"reportParameterId":0,        
         "description":"Job Type",        
            "column":"JobType",        
         "processingMethod":"RpTblListItem",         
         "operator":"in",         
         "sortOrder":7,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '} ,
             
                    {"reportParameterId":0,        
         "description":"User Level",        
            "column":"UserLevel",        
         "processingMethod":"RpTblUserLevel",         
         "operator":"equals",         
         "sortOrder":8,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
             
                    {"reportParameterId":0,        
         "description":"User Type",        
            "column":"UserType",        
         "processingMethod":"RpTblUsertypeByUserLevel", 
		     "parent": "UserLevel", 
         "operator":"equals",         
         "sortOrder":9,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
             
                    {"reportParameterId":0,        
         "description":"User",        
            "column":"User",        
         "processingMethod":"RpTblUser",         
         "operator":"in",         
         "sortOrder":10,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
             
                    {"reportParameterId":0,        
         "description":"Roll Up to Parent Customer",        
            "column":"RollUpToParentCustomer",        
         "processingMethod":"RpTblTruefalse",         
         "operator":"equals",         
         "sortOrder":11,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
             
                    {"reportParameterId":0,        
         "description":"Customer",        
            "column":"Customer",        
         "processingMethod":"",         
         "operator":"contains",         
         "sortOrder":12,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}
                 
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'GrossProfitDetail';


            --NewCustomerOrderTrackingMetrics
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"NewCustomerOrderTrackingMetrics",
"status":"active",
"description":"New Customer Order Tracking Metrics Report",
"processingMethod": "RpNewCustomerOrderTrackingMetricsStatic",
 "categoryListItemId":' + CAST(@CustomerListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[],

"parameterValueData":[           
							  {"reportParameterId":0,        
         "description":"StartDate",        
           "column":"StartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"EndDate",        
           "column":"EndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},

	 {"reportParameterId":0,        
          "description":"Customer",        
           "column":"Customer",         
           "operator":"contains",         
           "sortOrder":3,        
              "required":1,        
			      "defaultValue":"%", 
              "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}	,

			  
	 {"reportParameterId":0,        
          "description":"User Type",        
           "column":"UserType",         
           "operator":"equals",         
           "sortOrder":4,        
              "required":1, 
			  "processingMethod": "RpTblOrganizationUserType"	,	   
              "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX)) + '}
],


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'NewCustomerOrderTrackingMetrics';


            --WorkInjuryList
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"WorkInjuryList",
"status":"active",
"description":"Work Injury List Report",
"processingMethod": "RpWorkInjuryListStatic",
 "categoryListItemId":' + CAST(@WorkInjuryListItemId AS VARCHAR (MAX))
                               + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
},

"column":{"edit":"ReportProperty",
"reportId":0,
"columnValueData":[	

 
	
	  ],

   "parameterValueData":[  
  

 {"reportParameterId":0,        
         "description":"Incident Start Date",        
           "column":"IncidentStartDate",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportParameterId":0,        
         "description":"Incident End Date",        
           "column":"IncidentEndDate",         
         "operator":"lessthanorequal",         
         "sortOrder":2,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},


{"reportParameterId":0,        
                 "description":"Company",        
                  "column":"Company",         
                  "processingMethod":"RpTblTenantOrganization",        
                  "operator":"in",         
                  "sortOrder":3,        
            "required":0,        
            "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX)) + '}		 ],

 
"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'WorkInjuryList';


            --TaskList
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",
											"reportId":0,
											"report":"TaskList",
											"status":"Active",
											"description":"This report shows the list of task assigned to a user in a given range.", 
											"processingMethod": "RpTaskListStatic",
											 "categoryListItemId":'
                               + CAST(@RecruitingOnboardingListItemId AS VARCHAR (MAX))
                               + ' , 
											 "status":"Active",
											 "reportOptionListItemId":'
                               + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
											 },

						"column":{"edit":"ReportProperty",
							"reportId":0,

							  "columnValueData":[],
							   
							"parameterValueData":[
							{"reportParameterId":0,        
         "description":"Task Insert Date",        
           "column":"TaskInsertDate",         
         "operator":"between",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
				    {"reportParameterId":0,
							       "description":"RelatesTo",
							        "column":"RelatesTo", 
							        "processingMethod": "RpTblTaskRelatesTo",
							       "RequireParentValue":1,
								   "operator":"in", 
							        "sortOrder":2,
									"required":1,
									"dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,
							       "description":"Relates To Name/Id/Number",
							        "column":"RelatesToName",
							        "operator":"contains", 
							        "sortOrder":3,
									"required":0,
									"dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '},
		 {"reportParameterId":0,        
          "description":"Company",        
           "column":"Company",         
           "processingMethod":"RpTblTenantOrganization",        
           "operator":"in",         
           "sortOrder":4,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
           {"reportParameterId":0,        
              "description":"Task Template",        
               "column":"TaskTemplate",         
               "processingMethod":"RpTblTaskTemplate",               
               "operator":"in",         
               "sortOrder":6,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
				    {"reportParameterId":0,        
              "description":"Task Status",        
               "column":"TaskStatus",         
               "processingMethod":"RpTblTaskStatus",               
               "operator":"in",         
               "sortOrder":7,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}
				   ]
								},
								"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'TaskList';


            --UserRole
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"UserRole",        
           "status":"active",        
           "description":"User Role",         
           "processingMethod": "RpUserRoleStatic",         
           "categoryListItemId":' + CAST(@AdminListItemId AS VARCHAR (MAX))
                               + '  ,
            "status":"active",
            "reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        

			   "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[
        {"reportColumnId":0,"column":"Entity","alias":"Entity","aggregation":"groupby",
                              "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '} ,
				   {"reportColumnId":0,"column":"EntityName","alias":"Entity Name",
				   "aggregation":"groupby",
                              "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                               + '}  ,
				   {"reportColumnId":0,"column":"UTCommission","alias":"UT Commission", 
                              "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} 

                
       ],        
	     "parameterValueData":[        
          {"reportParameterId":0,        
              "description":"Entity",        
               "column":"Entity",         
               "processingMethod":"RpTblEntityforUserRole",        
         "isVisible":1,        
         "parent": "",        
               "operator":"in",         
               "sortOrder":1,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}   ,  
               
          {"reportParameterId":0,        
          "description":"User Role",        
           "column":"UserRole",         
           "processingMethod":"RpTblUserRole",        
           "operator":"in",         
           "sortOrder":2,        
              "required":0,        
              "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},        
          {"reportParameterId":0,        
              "description":"UserRole Name",        
               "column":"UserRoleName",         
               "processingMethod":"RpTblUser",           
               "operator":"in",         
               "sortOrder":3,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@SelectListItemId AS VARCHAR (MAX))
                               + '}
               
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';

            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'UserRole';


            --TransactionItemByCategory
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
									                "reportId":0,        
									                "report":"TransactionItemByCategory",        
									                "status":"active",        
									                "description":"Transaction Item By Category",         
									                "processingMethod": "RpTransactionItemByCategoryStatic",        
									                 "status":"active"   ,
													   "categoryListItemId":'
                               + CAST(@TimesheetListItemId AS VARCHAR (MAX)) + ',
					"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '     
									                 },        
									             
									           "column":{"edit":"ReportProperty",        
									            "reportId":0,        
									             
									             "columnValueData":[
												  {"reportColumnId":0,"column":"ItemPay","alias":"Item Pay","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,        
           {"reportColumnId":0,"column":"ItemBill","alias":"Item Bill","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                               + '} ,{"reportColumnId":0,"column":"PayUnit","alias":"Pay Unit","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,{"reportColumnId":0,"column":"BillUnit","alias":"Bill Unit","aggregation":"sum",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                               + '} ,{"reportColumnId":0,"column":"AccountingPeriod","alias":"Accounting Period","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '} 
												 ],        
									             
									                    
									            "parameterValueData":[
												{"reportParameterId":0,
								 "description":"Accounting Period",
							     "column":"AccountingPeriod", 								
								 "operator":"between", 
								 "sortOrder":1,
								 "required":1,
								 "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
							  {"reportParameterId":0,
									 "description":"Company",
									  "column":"Company", 
									  "processingMethod":"RpTblTenantOrganization",
									  "operator":"in", 
									  "sortOrder":2,
								      "required":0,
								      "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '},
							   {"reportParameterId":0,        
              "description":"Office",        
               "column":"Office",         
               "processingMethod":"RpTblOffice",        
         "parent": "Company",        
               "operator":"in",         
               "sortOrder":3,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '}	,{"reportParameterId":0,        
         "description":"Pay Code Category",        
            "column":"PayCodeCategory",         
         "operator":"equal",  
		 "processingMethod":"RpTblPayCodeCategory",
         "sortOrder":4,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                               + '} 
							   
							   ]        
									                       
									               },        
									             
									             "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'TransactionItemByCategory';

            --CustomerSetup
            SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"CustomerSetup",
		    "category":' + CAST(@CustomerListItemId AS VARCHAR (MAX))
                               + ',
           "status":"active",        
           "description":"Gives the Information about the setup of the customer",         
           "processingMethod": "RpCustomerSetupStatic",        
            "status":"active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                               + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[ 
		{"reportColumnId":0,"column":"LastInvoiceDate","alias":"Last Invoice Date","aggregation":"", 
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
								   {"reportColumnId":0,"column":"FirstInvoiceDate","alias":"First Invoice Date","aggregation":"",    
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                               + '},
		{"reportColumnId":0,"column":"LastCommentDate","alias":"Last Comment Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateTimeListItemId AS VARCHAR (MAX))
                               + '}
								   ],        
        
               
       "parameterValueData":[]
                  
          },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
            EXEC dbo.SpStaticReportIns @Json = @rptParam;
            SELECT 'CustomerSetup';





            COMMIT TRANSACTION;

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            THROW;
        END CATCH;
    END;





































GO

