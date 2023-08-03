SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

/************* IMPORTANT *************/
/*  
created by sasita: 1/3/2022 
added setup for ContinentalNewHire

modified : Sasita 06/07/2023 added setup for Continental SyncStream Payroll, ContinentalCAPayData
*/
ALTER PROCEDURE [dbo].[ContinentalStaticReportSetup]
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


            BEGIN

       
--Continental401KWeeklyData
SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"Continental401kWeeklyData",
"status":"active",
"description":"This report gives the adjustment, benefit related data of employe who have recieved payment in the selected Week.",
"processingMethod": "CUOContinental_Rp401KWeeklyDataStatic",
"categoryListItemId":' + CAST(@RecruitingOnboardingListItemId AS VARCHAR (MAX))
                   + ',
"status":"active",
"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                   + '
},

 

"column":{"edit":"ReportProperty",
"reportId":0,

 

"columnValueData":[    
  {"reportColumnId":0,"column":"SSN","alias":"SSN","aggregation":"",
    "dataTypeListItemId":' + CAST(@StringListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"HireDate","alias":"Hire Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"DateofBirth","alias":"Date of Birth","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"TerminationDate","alias":"Termination Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"DateofRehire","alias":"Date of Rehire","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"PayrollDate","alias":"Payroll Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"EmployeeBeforeTaxBTK1","alias":"Employee Before-Tax - BTK1","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"EmployeeRothRTH1","alias":"Employee Roth - RTH1","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"SafeHarborMatchSHM1","alias":"Safe Harbor Match - SHM1","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"ProfitSharingERO1","alias":"Profit Sharing - ERO1","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"DiscretionaryEmployerMatchERM1","alias":"Discretionary Employer Match - ERM1","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"YTDHours","alias":"YTD Hours","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                   + '},
                                     {"reportColumnId":0,"column":"SalaryAmount","alias":"Salary Amount","aggregation":"",        
         "dataTypeListItemId":' + CAST(@MoneyListItemId AS VARCHAR (MAX))
                   + '},
				    {"reportColumnId":0,"column":"LoanRepayments","alias":"Loan Repayments","aggregation":"",        
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
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX)) + '}],

 


"personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
EXEC dbo.SpStaticReportIns @Json = @rptParam;
SELECT 'Continental401KWeeklyData';




                --ContinentalNewHire Report 
                SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"ContinentalNewHire",
"status":"active",
"description":"This report shows the list of employees who received their first check in the provided date range. It will also include any employees who may not have received any checks for at least the number of consecutive days provided in the number of days parameter.The only difference between standard and this report is we show full SSN in SSN Column.",
"processingMethod": "CUOContinental_RpNewhireStatic",
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
                                   + '},
								     {"reportColumnId":0,"column":"DOB","alias":"DOB","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '},
								     {"reportColumnId":0,"column":"HireDate","alias":"Hire Date","aggregation":"",        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '},
								     {"reportColumnId":0,"column":"StartDate","alias":"Start Date","aggregation":"",        
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

 
"personIds":"' +    CAST(@personIds AS VARCHAR (MAX)) + '"}';
                EXEC dbo.SpStaticReportIns @Json = @rptParam;
                SELECT 'ContinentalNewHire';
                --ContinentalCAPayData
                SELECT @rptParam = '{"report":{"edit":"ReportDetail",        
           "reportId":0,        
           "report":"ContinentalCAPayData",        
           "status":"active",        
           "description":"Continental CA Pay Data Report",         
           "processingMethod": "CUOContinental_RpCAPayDataStatic",        
		    "categoryListItemId":' + CAST(@GrossProfitTransactionListItemId AS VARCHAR (MAX))
                                   + ',  
            "status":"active" ,
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                                   + '
            },        
        
      "column":{"edit":"ReportProperty",        
       "reportId":0,        
        
        "columnValueData":[  
				   {"reportColumnId":0,"column":"HoursWorked","alias":"Hours Worked","aggregation":"sum","dataTypeListItemId":'
                                   + CAST(@DecimalListItemId AS VARCHAR (MAX))
                                   + '},
				   {"reportColumnId":0,"column":"AnnualComp","alias":"Annual Comp","aggregation":"sum","dataTypeListItemId":'
                                   + CAST(@MoneyListItemId AS VARCHAR (MAX))
                                   + '},
				   {"reportColumnId":0,"column":"EmployeeCount","alias":"Employee Count","aggregation":"sum","dataTypeListItemId":'
                                   + CAST(@NumberListItemId AS VARCHAR (MAX))
                                   + '},
				   {"reportColumnId":0,"column":"DateOfHire","alias":"Date Of Hire","aggregation":"","dataTypeListItemId":'
                                   + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '},
				   {"reportColumnId":0,"column":"DateTerminated","alias":"Date Terminated","aggregation":"","dataTypeListItemId":'
                                   + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '},
				   {"reportColumnId":0,"column":"WorkEndingDate","alias":"Work Ending Date","aggregation":"","dataTypeListItemId":'
                                   + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '},
				   {"reportColumnId":0,"column":"Date","alias":"Date","aggregation":"","dataTypeListItemId":'
                                   + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '}
				  
				   ],        
        
       "parameterValueData":[

		 {"reportParameterId":0,        
         "description":"Accounting Period From",        
           "column":"AccountingPeriodFrom",         
         "operator":"greaterthanorequal",         
         "sortOrder":1,        
         "required":1,        
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '},
				   {"reportParameterId":0,        
         "description":"Accounting Period To",        
           "column":"AccountingPeriodTo",         
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
         "description":"Customer",        
            "column":"Customer",        
         "processingMethod":"CUOContinental_RpTblCustomer",         
         "operator":"in", 
         "sortOrder":5,        
         "required":0,        
         "dataTypeListItemId":' + CAST(@MultiSelectListItemId AS VARCHAR (MAX))
                                   + '}
                 
          ]        
        },        
        
        "personIds":"' + CAST(@personIds AS VARCHAR (MAX)) + '"}';
                EXEC dbo.SpStaticReportIns @Json = @rptParam;
                SELECT 'ContinentalCAPayData';

                -- Continental SyncStream Payroll
                SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"Continental SyncStream Payroll",
 "categorylistitemId":' + CAST(@PayrollListItemId AS VARCHAR (MAX))
                                   + ',
"status":"Active",
"description":"Continental SyncStream Payroll",
"processingMethod": "CUOContinental_RpSyncStreamPayrollStatic",
"status":"Active",
			"reportOptionListItemId":' + CAST(@ReportOptionShareableListItemId AS VARCHAR (MAX))
                                   + '
},

"column":{"edit":"ReportProperty",
"reportId":0,

"columnValueData":[{"reportColumnId":0,"column":"Hours","alias":"Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                                   + '},
							   {"reportColumnId":0,"column":"RateOfPay","alias":"Rate Of Pay","aggregation":"",
							  "dataTypeListItemId":' + CAST(@MoneyFourListItemId AS VARCHAR (MAX))
                                   + '},
							   {"reportColumnId":0,"column":"DateHired","alias":"Date Hired","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '},
							   {"reportColumnId":0,"column":"DateTerminated","alias":"Date Terminated","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '},
							   {"reportColumnId":0,"column":"WorkEndingDate","alias":"Work Ending Date","aggregation":"",
							  "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX))
                                   + '}
							   ],

"parameterValueData":[        {"reportParameterId":0,        
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
         "dataTypeListItemId":' + CAST(@DateListItemId AS VARCHAR (MAX)) + '}],


"personIds":"' +    CAST(@personIds AS VARCHAR (MAX)) + '"}';
                EXEC dbo.SpStaticReportIns @Json = @rptParam;
                SELECT 'Continental SyncStream Payroll';

                --ContinentalEmployeePayrollSummary

                SELECT @rptParam = '{"report":{"edit":"ReportDetail",
"reportId":0,
"report":"ContinentalEmployeePayrollSummary",
"status":"active",
"description":"Continental Employee Payroll Summary Report",
"processingMethod": "CUOContinental_RpEmployeePayrollSummaryStatic",
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
								   {"reportColumnId":0,"column":"HolHours","alias":"Hol Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                                   + '},
								   {"reportColumnId":0,"column":"TotalPTOHours","alias":"Total PTO Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                                   + '},
								   {"reportColumnId":0,"column":"OtherHours","alias":"Other Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                                   + '},
				    {"reportColumnId":0,"column":"PSL","alias":"PSL Hours","aggregation":"sum",
							  "dataTypeListItemId":' + CAST(@DecimalListItemId AS VARCHAR (MAX))
                                   + '},
				   {"reportColumnId":0,"column":"PTO","alias":"PTO Hours","aggregation":"sum",
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


"personIds":"' +    CAST(@personIds AS VARCHAR (MAX)) + '"}';
                EXEC dbo.SpStaticReportIns @Json = @rptParam;
                SELECT 'ContinentalEmployeePayrollSummary';

            END;


            COMMIT TRANSACTION;

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            THROW;
        END CATCH;
    END;





































GO

