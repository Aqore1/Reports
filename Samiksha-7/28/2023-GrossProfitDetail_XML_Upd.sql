--SELECT *
UPDATE pr SET pr.ReportXML='<?xml version="1.0" encoding="utf-8"?>
<Report DataSourceName="GrossProfitwebServiceDataSource" Width="10.6in" Name="Gross Profit Detail Report" ShowSnapGrid="True" ShowDimensions="False" xmlns="http://schemas.telerik.com/reporting/2021/2.0">
  <Style>
    <BorderStyle Bottom="None" Right="None" />
    <BorderColor Bottom="191, 191, 191" Right="191, 191, 191" />
    <BorderWidth Bottom="1pt" Right="1pt" />
  </Style>
  <DataSources>
    <WebServiceDataSource ParameterValues="{&quot;@ReportId&quot;:&quot;200339&quot;,&quot;@UserPersonId&quot;:&quot;1&quot;,&quot;@RollUpToParentCustomer&quot;:&quot;false&quot;,&quot;@Customer&quot;:&quot;%&quot;,&quot;@DateType&quot;:&quot;Accounting Period Date&quot;,&quot;@JobType&quot;:&quot;All&quot;,&quot;@StartDate&quot;:&quot;06/01/2020&quot;,&quot;@EndDate&quot;:&quot;06/07/2020&quot;,&quot;@GroupBy&quot;:&quot;User&quot;,&quot;@Organization&quot;:&quot;200003&quot;,&quot;@Office&quot;:&quot;200060,200003&quot;,&quot;@UserLevel&quot;:&quot;Customer&quot;,&quot;@UserType&quot;:&quot;200549&quot;,&quot;@User&quot;:&quot;1&quot;,&quot;Content-Type&quot;:&quot;application/json&quot;}" AuthParameterValues="null" ServiceUrl="##PaginatedReportapi/reportservice/data" Method="Post" Body="{&#xD;&#xA;&quot;ReportId&quot;     :@ReportId,&#xD;&#xA;&quot;UserPersonId&quot;   :@UserPersonId,   &#xD;&#xA;&quot;RollUpToParentCustomer&quot;:&quot;@RollUpToParentCustomer&quot;,&#xD;&#xA;&quot;Customer&quot;:&quot;@Customer&quot;,&#xD;&#xA;&quot;DateType&quot;: &quot;@DateType&quot;,&#xD;&#xA;&quot;JobType&quot;:&quot;@JobType&quot;,&#xD;&#xA;&quot;StartDate&quot;:&quot;@StartDate&quot;,&#xD;&#xA;&quot;EndDate&quot;:&quot;@EndDate&quot; ,&#xD;&#xA;&quot;GroupBy&quot;:&quot;@GroupBy&quot;,&#xD;&#xA; &quot;Office&quot;:&quot;@Office&quot;,&#xD;&#xA;&quot;Organization&quot;:&quot;@Organization&quot;,&#xD;&#xA;&quot;UserLevel&quot;:&quot;@UserLevel&quot;,&#xD;&#xA;&quot;UserType&quot;:&quot;@UserType&quot;,&#xD;&#xA;&quot;User&quot;:&quot;@User&quot;&#xD;&#xA;}" Name="GrossProfitwebServiceDataSource">
      <Parameters>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@ReportId">
          <Value>
            <String>= Parameters.ReportId.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@UserPersonId">
          <Value>
            <String>= Parameters.UserPersonId.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@RollUpToParentCustomer">
          <Value>
            <String>= Parameters.RollUpToParentCustomer.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@Customer">
          <Value>
            <String>= Parameters.Customer.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@DateType">
          <Value>
            <String>= Parameters.DateType.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@JobType">
          <Value>
            <String>= Join('','',Parameters.JobType.Value)</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@StartDate">
          <Value>
            <String>= Parameters.StartDate.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@EndDate">
          <Value>
            <String>= Parameters.EndDate.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@GroupBy">
          <Value>
            <String>=Join('','', Parameters.GroupBy.Value)</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@Organization">
          <Value>
            <String>= Join('','',Parameters.Organization.Value)</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@Office">
          <Value>
            <String>= Join('','',Parameters.Office.Value)</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@UserLevel">
          <Value>
            <String>= Parameters.UserLevel.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@UserType">
          <Value>
            <String>= Parameters.UserType.Value</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Inline" Name="@User">
          <Value>
            <String>=Join('','', Parameters.User.Value)</String>
          </Value>
        </WebServiceParameter>
        <WebServiceParameter WebServiceParameterType="Header" Name="Content-Type">
          <Value>
            <String>application/json</String>
          </Value>
        </WebServiceParameter>
      </Parameters>
    </WebServiceDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="null" ConnectionString="BradyLive1" SelectCommand="dbo.RpDateTypeSel" SelectCommandType="StoredProcedure" Name="DateTypeSqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="{&quot;@UserPersonId&quot;:&quot;1&quot;}" ConnectionString="BradyLive1" SelectCommand="dbo.RpOrganizationSel" SelectCommandType="StoredProcedure" Name="CompanyListSqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Int32" Name="@UserPersonId">
          <Value>
            <String>= Parameters.UserPersonId.Value</String>
          </Value>
        </SqlDataSourceParameter>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="{&quot;@UserPersonId&quot;:&quot;1&quot;,&quot;@Organization&quot;:&quot;200001,200003&quot;}" ConnectionString="BradyLive1" SelectCommand="dbo.RpOfficeByOrganizationSel" SelectCommandType="StoredProcedure" Name="OfficeListSqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Int32" Name="@UserPersonId">
          <Value>
            <String>= Parameters.UserPersonId.Value</String>
          </Value>
        </SqlDataSourceParameter>
        <SqlDataSourceParameter DbType="AnsiString" Name="@Organization">
          <Value>
            <String>= Join('','',Parameters.Organization.Value)</String>
          </Value>
        </SqlDataSourceParameter>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="null" ConnectionString="BradyLive1" SelectCommand="dbo.RpGroupBySel" SelectCommandType="StoredProcedure" Name="GroupBySqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="{&quot;@UserPersonId&quot;:&quot;1&quot;,&quot;@Category&quot;:&quot;JobType&quot;}" ConnectionString="BradyLive1" SelectCommand="dbo.RpListItemSel" SelectCommandType="StoredProcedure" Name="JobTypesqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Int32" Name="@UserPersonId">
          <Value>
            <String>= Parameters.UserPersonId.Value</String>
          </Value>
        </SqlDataSourceParameter>
        <SqlDataSourceParameter DbType="AnsiString" Name="@Category">
          <Value>
            <String>JobType</String>
          </Value>
        </SqlDataSourceParameter>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="null" ConnectionString="BradyLive1" SelectCommand="dbo.RpUserLevelSel" SelectCommandType="StoredProcedure" Name="UserLevelSqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="{&quot;@UserPersonId&quot;:&quot;1&quot;,&quot;@UserLevel&quot;:&quot;Customer&quot;}" ConnectionString="BradyLive1" SelectCommand="dbo.RpUsertypeByUserLevelSel" SelectCommandType="StoredProcedure" Name="UserTypeSqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Int32" Name="@UserPersonId">
          <Value>
            <String>= Parameters.UserPersonId.Value</String>
          </Value>
        </SqlDataSourceParameter>
        <SqlDataSourceParameter DbType="AnsiString" Name="@UserLevel">
          <Value>
            <String>= Parameters.UserLevel.Value</String>
          </Value>
        </SqlDataSourceParameter>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="{&quot;@UserPersonId&quot;:&quot;1&quot;}" ConnectionString="BradyLive1" SelectCommand="dbo.RpUserSel" SelectCommandType="StoredProcedure" Name="UserSqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Int32" Name="@UserPersonId">
          <Value>
            <String>= Parameters.UserPersonId.Value</String>
          </Value>
        </SqlDataSourceParameter>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="null" ConnectionString="BradyLive1" SelectCommand="dbo.RpTrueFalseSel" SelectCommandType="StoredProcedure" Name="RollUptoParentCustomerSqlDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Boolean" Name="@ReturnJson" />
      </Parameters>
    </SqlDataSource>
    <SqlDataSource QueryDesignerState="null" ParameterValues="{&quot;@UserPersonId&quot;:&quot;3&quot;}" ConnectionString="BradyLive1" SelectCommand="dbo.RpPersonNameSel" SelectCommandType="StoredProcedure" Name="usernameDataSource">
      <Parameters>
        <SqlDataSourceParameter DbType="Int32" Name="@UserPersonId">
          <Value>
            <String>= Parameters.UserPersonId.Value</String>
          </Value>
        </SqlDataSourceParameter>
      </Parameters>
    </SqlDataSource>
  </DataSources>
  <Items>
    <PageHeaderSection Height="0.052in" Name="pageHeaderSection1">
      <Style Visible="False" />
    </PageHeaderSection>
    <DetailSection CanShrink="False" KeepTogether="False" Height="10.244in" Name="detailSection1">
      <Style Visible="True" />
      <Items>
        <List Width="10.6in" Height="6.449in" Left="0in" Top="0in" KeepTogether="False" Name="list1">
          <Body>
            <Cells>
              <TableCell RowIndex="1" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                <ReportItem>
                  <Panel Width="1017.6px" Height="0.104in" Left="0in" Top="0in" CanShrink="True" KeepTogether="False" Name="panel1">
                    <Style Visible="False" />
                  </Panel>
                </ReportItem>
              </TableCell>
              <TableCell RowIndex="2" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                <ReportItem>
                  <Panel Width="1017.6px" Height="3.043in" Left="0in" Top="0in" KeepTogether="False" Name="company total">
                    <Items>
                      <Table Width="7.404in" Height="2.557in" Left="1.598in" Top="0.243in" Name="table1">
                        <Body>
                          <Cells>
                            <TableCell RowIndex="1" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.177in" Left="0in" Top="0in" Value="Gross Wages" Format="{0}" Name="textBox109">
                                  <Style TextAlign="Justify" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.177in" Left="0in" Top="0in" Value="Sales" Format="{0}" Name="textBox185">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Format="{0}" Name="textBox299" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Format="{0}" Name="textBox300" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Format="{0}" Name="textBox314" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Bottom="Solid" Right="None" />
                                    <BorderColor Bottom="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Bottom="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Name="textBox315" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Name="textBox329" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="0" RowSpan="1" ColumnSpan="6">
                              <ReportItem>
                                <TextBox Width="7.404in" Height="0.25in" Left="0in" Top="0in" Value="{Fields.companyalias} Total" Name="textBox345">
                                  <Style BackgroundColor="191, 191, 191" TextAlign="Center" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="Solid" Bottom="Solid" Left="Solid" Right="Solid" />
                                    <BorderColor Top="191, 191, 191" Bottom="166, 166, 166" Left="191, 191, 191" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.177in" Left="0in" Top="0in" Value="=fields.companygrossOnly" Format="{0:C2}" Name="textBox359" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox360" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Top="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox376" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox392" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Name="textBox406" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="Solid" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Name="textBox407" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Format="{0}" Name="textBox456" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="None" Left="Solid" />
                                    <BorderColor Top="Black" Left="166, 166, 166" />
                                    <BorderWidth Top="1pt" Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox464" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                    <BorderStyle Top="None" Right="Solid" />
                                    <BorderColor Top="Black" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox472" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Value="Payroll Cost " Format="{0}" Name="textBox476" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="Solid" Bottom="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="Black" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Value="=fields.companyPayrollCost" Format="{0:C2}" Name="textBox477" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                    <BorderStyle Top="Solid" Right="None" />
                                    <BorderColor Top="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox480" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Format="{0}" Name="textBox505" StyleName="">
                                  <Style TextAlign="Justify" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox506" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox507" StyleName="">
                                  <Style TextAlign="Justify" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox508" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.177in" Left="0in" Top="0in" Value="=Fields.companyBillAmount" Format="{0:C2}" Name="textBox515" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="Solid" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.2in" Left="0in" Top="0in" Value="Discount Amount" Format="{0}" Name="textBox518" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.2in" Left="0in" Top="0in" Value="=Fields.companyDiscountAmount" Format="{0:C2}" Name="textBox519" StyleName="">
                                  <Style Color="Red" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Value="Gross Profit " Format="{0}" Name="textBox523" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="Solid" Bottom="None" Left="Solid" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="191, 191, 191" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyGrossProfit" Format="{0:C2}" Name="textBox524" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                    <BorderStyle Top="Solid" Bottom="None" Left="None" Right="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Format="{0}" Name="textBox525" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:P2}" Name="textBox526" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                    <BorderStyle Right="Solid" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.2in" Left="0in" Top="0in" Value="DHFee " Format="{0:C2}" Name="textBox529" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.2in" Left="0in" Top="0in" Value="=fields.companyDHFee" Format="{0:C2}" Name="textBox530" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.2in" Left="0in" Top="0in" Value="Agency Cost" Name="textBox168" StyleName="">
                                  <Style TextAlign="Justify" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.2in" Left="0in" Top="0in" Value="=fields.companyAgencyCost" Format="{0:C2}" Name="textBox173" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.2in" Left="0in" Top="0in" Value="Employer Taxes " Format="{0}" Name="textBox174" StyleName="">
                                  <Style TextAlign="Justify" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.2in" Left="0in" Top="0in" Value="=Fields.companyEmployerTaxes" Format="{0:C2}" Name="textBox175" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.2in" Left="0in" Top="0in" Value="Wc Cost" Format="{0}" Name="textBox177" StyleName="">
                                  <Style TextAlign="Justify" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.2in" Left="0in" Top="0in" Value="=Fields.companyWcCost" Format="{0:C2}" Name="textBox187" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Top="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Value="Burden " Format="{0}" Name="textBox189" StyleName="">
                                  <Style TextAlign="Justify" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyBurden" Format="{0:C2}" Name="textBox190" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.039in" Height="0.17in" Left="0in" Top="0in" Value="Er Contributions" Format="{0:C2}" Name="textBox191" StyleName="">
                                  <Style TextAlign="Justify" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyErContributions" Format="{0:C2}" Name="textBox192" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.177in" Left="0in" Top="0in" Value="Reimbursement" Format="{0}" Name="textBox194" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.2in" Left="0in" Top="0in" Value="Charge" Format="{0:C2}" Name="textBox196" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.2in" Left="0in" Top="0in" Value="=Fields.companycharge" Format="{0:C2}" Name="textBox197" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="Solid" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Format="{0}" Name="textBox198" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox201" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Top="None" Right="Solid" />
                                    <BorderColor Top="Gray" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.2in" Left="0in" Top="0in" Value="GP Adj Bill" Format="{0}" Name="textBox202" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.2in" Left="0in" Top="0in" Value="=Fields.companyGPAdjBill" Format="{0:C2}" Name="textBox203" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Right="Solid" />
                                    <BorderColor Right="166, 166, 166" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Value="GP Bill" Format="{0}" Name="textBox204" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="Solid" Bottom="None" Left="Solid" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companygPBill" Format="{0:C2}" Name="textBox207" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                    <BorderStyle Top="Solid" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Value="Payroll Cost " Format="{0}" Name="textBox208" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="None" Left="Solid" />
                                    <BorderColor Top="Black" Left="166, 166, 166" />
                                    <BorderWidth Top="1pt" Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Value="=fields.companyPayrollCost" Format="{0:C2}" Name="textBox209" StyleName="">
                                  <Style Color="Red" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                    <BorderStyle Top="None" Right="Solid" />
                                    <BorderColor Top="Black" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Value="GP Adj Pay" Name="textBox210" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyGPAdjPay" Format="{0:C2}" Name="textBox211" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                    <BorderStyle Top="None" Right="Solid" />
                                    <BorderColor Top="Gray" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.477in" Height="0.17in" Left="0in" Top="0in" Value="Gross Profit (%) " Format="{0}" Name="textBox212" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyGrossProfitPercent" Format="{0:P2}" Name="textBox213" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                    <BorderStyle Right="Solid" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.177in" Left="0in" Top="0in" Value="=fields.companyReimbursement" Format="{0:C2}" Name="textBox195" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.2in" Left="0in" Top="0in" Value="Deduction" Format="{0}" Name="textBox214" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.2in" Left="0in" Top="0in" Value="=fields.companyDeduction" Format="{0:C2}" Name="textBox215" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.2in" Left="0in" Top="0in" Value="Adj Bill" Format="{0:C2}" Name="textBox216" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.2in" Left="0in" Top="0in" Value="=fields.companyAdjustmentBill" Format="{0:C2}" Name="textBox217" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Value="Total Billed Hours " Format="{0:C2}" Name="textBox220" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Value="=fields.companyTotalBillHours" Format="{0:N2}" Name="textBox221" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Value="Total Paid Hours&#xD;&#xA;" Format="{0:C2}" Name="textBox222" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Value="=fields.companyTotalPayHours" Format="{0:N2}" Name="textBox223" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Value="Total Pay" Format="{0:C2}" Name="textBox227" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Value="Total Bill" Format="{0}" Name="textBox228" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyTotalPay" Format="{0:C2}" Name="textBox232" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyTotalBill" Format="{0:C2}" Name="textBox233" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Value="Sales Tax" Format="{0}" Name="textBox234" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companySalesTax" Format="{0:C2}" Name="textBox218" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Value="Total Invoice Amount" Format="{0}" Name="textBox219" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Value="=(fields.companyTotalBill+fields.companySalesTax+fields.companycharge-fields.companyDiscountAmount)" Format="{0:C2}" Name="textBox238" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Value="No. of Customers " Format="{0}" Name="textBox246" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyNumberOfCustomer" Format="{0}" Name="textBox248" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.594in" Height="0.17in" Left="0in" Top="0in" Value="No. of Employees" Format="{0}" Name="textBox2" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.294in" Height="0.17in" Left="0in" Top="0in" Value="=Fields.companyNumberOfEmployee" Format="{0}" Name="textBox3" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                          </Cells>
                          <Columns>
                            <Column Width="1.039in" />
                            <Column Width="1in" />
                            <Column Width="1.477in" />
                            <Column Width="1in" />
                            <Column Width="1.594in" />
                            <Column Width="1.294in" />
                          </Columns>
                          <Rows>
                            <Row Height="0.25in" />
                            <Row Height="0.177in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.17in" />
                            <Row Height="0.17in" />
                            <Row Height="0.17in" />
                            <Row Height="0.17in" />
                            <Row Height="0.17in" />
                            <Row Height="0.17in" />
                            <Row Height="0.17in" />
                            <Row Height="0.17in" />
                            <Row Height="0.17in" />
                          </Rows>
                        </Body>
                        <Corner />
                        <Style>
                          <BorderStyle Top="Solid" Bottom="Solid" Left="Solid" Right="Solid" />
                          <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                          <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                        </Style>
                        <RowGroups>
                          <TableGroup Name="group47">
                            <ChildGroups>
                              <TableGroup Name="group48" />
                            </ChildGroups>
                          </TableGroup>
                          <TableGroup Name="detailTableGroup2">
                            <ChildGroups>
                              <TableGroup Name="group29" />
                              <TableGroup Name="group58" />
                              <TableGroup Name="group57" />
                              <TableGroup Name="group20" />
                              <TableGroup Name="group30" />
                              <TableGroup Name="group31" />
                              <TableGroup Name="group32" />
                              <TableGroup Name="group36" />
                              <TableGroup Name="group38" />
                              <TableGroup Name="group35" />
                              <TableGroup Name="group40" />
                              <TableGroup Name="group34" />
                              <TableGroup Name="group37" />
                            </ChildGroups>
                            <Groupings>
                              <Grouping />
                            </Groupings>
                          </TableGroup>
                        </RowGroups>
                        <ColumnGroups>
                          <TableGroup Name="tableGroup5" />
                          <TableGroup Name="group49" />
                          <TableGroup Name="tableGroup6" />
                          <TableGroup Name="group50" />
                          <TableGroup Name="group51" />
                          <TableGroup Name="tableGroup7" />
                        </ColumnGroups>
                        <Bindings>
                          <Binding Path="DataSource" Expression="=fields.companyTotal" />
                        </Bindings>
                      </Table>
                    </Items>
                  </Panel>
                </ReportItem>
              </TableCell>
              <TableCell RowIndex="0" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                <ReportItem>
                  <Panel Width="1017.6px" Height="316.98px" Left="0in" Top="0in" KeepTogether="False" Name="header">
                    <Items>
                      <Table Width="10.6in" Height="3.26in" Left="0in" Top="0in" KeepTogether="False" Name="table6">
                        <Body>
                          <Cells>
                            <TableCell RowIndex="7" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.14in" Height="0.2in" Left="0in" Top="0in" Value="=IIF(Join('','',Parameters.GroupBy.Value) LIKE ''*Employee*'',Fields.employee,&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) LIKE ''*WC Code*'',Fields.wCCode,&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) LIKE ''*Job Type*'',Fields.jobType,&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) LIKE ''*Customer*'',IsNull(Fields.customer,'''') + '',''+IsNull(Fields.department,''''),&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) LIKE ''*User*'',IsNull(Fields.userTypePerson,''''),&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) LIKE ''*Office*'',Fields.office,''''))))))" Name="textBox637" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.payhours)" Format="{0:N2}" Name="textBox638" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.65in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billAmount)" Format="{0:C2}" Name="textBox639" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.payhours)" Format="{0:N2}" Name="textBox640" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.65in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.billAmount)" Format="{0:C2}" Name="textBox641" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.payhours)" Format="{0:N2}" Name="textBox642" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.65in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billAmount)" Format="{0:C2}" Name="textBox643" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.14in" Height="0.2in" Left="0in" Top="0in" Value="{Fields.jobType}" Name="textBox646" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.14in" Height="0.2in" Left="0in" Top="0in" Value="{Fields.customer}" Name="textBox647" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.14in" Height="0.21in" Left="0in" Top="0in" Value="{IsNull(Fields.userTypePerson,'''')}" Name="textBox648" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.14in" Height="0.2in" Left="0in" Top="0in" Value="{Fields.office}" Name="textBox649" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.dHFee)" Format="{0:C2}" Name="textBox652" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.dHFee)" Format="{0:C2}" Name="textBox653" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.dHFee)" Format="{0:C2}" Name="textBox654" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjBill)" Format="{0:C2}" Name="textBox656" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.gPAdjBill)" Format="{0:C2}" Name="textBox657" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjBill)" Format="{0:C2}" Name="textBox658" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossWages)" Format="{0:C2}" Name="textBox664" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.grossWages)" Format="{0:C2}" Name="textBox665" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossWages)" Format="{0:C2}" Name="textBox666" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjPay)" Format="{0:C2}" Name="textBox668" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.gPAdjPay)" Format="{0:C2}" Name="textBox669" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjPay)" Format="{0:C2}" Name="textBox670" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.employerTaxes)" Format="{0:C2}" Name="textBox676" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.employerTaxes)" Format="{0:C2}" Name="textBox677" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.employerTaxes)" Format="{0:C2}" Name="textBox678" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.wcCost)" Format="{0:C2}" Name="textBox680" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.wcCost)" Format="{0:C2}" Name="textBox681" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.wcCost)" Format="{0:C2}" Name="textBox682" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjCost)" Format="{0:C2}" Name="textBox684" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.gPAdjCost)" Format="{0:C2}" Name="textBox685" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjCost)" Format="{0:C2}" Name="textBox686" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.burden)" Format="{0:C2}" Name="textBox688" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.burden)" Format="{0:C2}" Name="textBox689" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.burden)" Format="{0:C2}" Name="textBox690" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.erContribution)" Format="{0:C2}" Name="textBox692" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.erContribution)" Format="{0:C2}" Name="textBox693" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.erContribution)" Format="{0:C2}" Name="textBox694" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossProfit)" Format="{0:C2}" Name="textBox696" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.grossProfit)" Format="{0:C2}" Name="textBox697" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossProfit)" Format="{0:C2}" Name="textBox698" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.billHours)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.billHours)&lt;&gt;0,&#xD;&#xA;sum(Fields.billHours),null),'''')" Format="{0:C2}" Name="textBox700" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.21in" Left="0in" Top="0in" Value="=iif(sum(Fields.billHours)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.billHours)&lt;&gt;0,&#xD;&#xA;sum(Fields.billHours),null),'''')" Format="{0:C2}" Name="textBox701" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.billHours)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.billHours)&lt;&gt;0,&#xD;&#xA;sum(Fields.billHours),null),'''')" Format="{0:C2}" Name="textBox702" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.gPBill),null),'''')" Format="{0:P2}" Name="textBox704" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.21in" Left="0in" Top="0in" Value="=iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.gPBill),null),'''')" Format="{0:P2}" Name="textBox705" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.gPBill),null),'''')" Format="{0:P2}" Name="textBox706" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="0" RowSpan="1" ColumnSpan="4">
                              <ReportItem>
                                <TextBox Width="2.99in" Height="0.2in" Left="0in" Top="0in" Value="   Job Type: {Fields.jobType}" Name="textBox709" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="0" RowSpan="1" ColumnSpan="4">
                              <ReportItem>
                                <TextBox Width="2.99in" Height="0.2in" Left="0in" Top="0in" Value="    WC Code: {Fields.wCCode}" Name="textBox710" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Name="textBox711" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox712" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox715" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox716" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox717" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox718" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox719" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox720" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Name="textBox721" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox726" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox727" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox728" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox729" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox730" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox731" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Name="textBox732" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox734" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="Black" Bottom="Black" Left="Black" Right="Black" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox735" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox736" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox737" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Name="textBox738" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox739" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Name="textBox741" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox742" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox744" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox745" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox746" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox747" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox748" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox749" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox750" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Name="textBox751" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Name="textBox752" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox753" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox755" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Name="textBox756" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox758" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox759" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox760" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox761" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox762" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox763" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox764" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Name="textBox765" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Name="textBox766" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.payhours)" Format="{0:N2}" Name="textBox767" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billHours)" Format="{0:N2}" Name="textBox768" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.65in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billAmount)" Format="{0:C2}" Name="textBox769" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.dHFee)" Format="{0:C2}" Name="textBox770" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjBill)" Format="{0:C2}" Name="textBox771" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossWages)" Format="{0:C2}" Name="textBox773" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjPay)" Format="{0:C2}" Name="textBox774" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.employerTaxes)" Format="{0:C2}" Name="textBox776" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.wcCost)" Format="{0:C2}" Name="textBox777" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjCost)" Format="{0:C2}" Name="textBox778" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.burden)" Format="{0:C2}" Name="textBox779" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.erContribution)" Format="{0:C2}" Name="textBox780" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossProfit)" Format="{0:C2}" Name="textBox781" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.billHours)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.billHours)&lt;&gt;0,&#xD;&#xA;sum(Fields.billHours),null),'''')" Format="{0:C2}" Name="textBox782" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.gPBill),null),'''')" Format="{0:P2}" Name="textBox783" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.payhours)" Format="{0:N2}" Name="textBox784" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billHours)" Format="{0:N2}" Name="textBox785" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.65in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billAmount)" Format="{0:C2}" Name="textBox786" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.dHFee)" Format="{0:C2}" Name="textBox787" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjBill)" Format="{0:C2}" Name="textBox788" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossWages)" Format="{0:C2}" Name="textBox790" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjPay)" Format="{0:C2}" Name="textBox791" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.employerTaxes)" Format="{0:C2}" Name="textBox793" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.wcCost)" Format="{0:C2}" Name="textBox794" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjCost)" Format="{0:C2}" Name="textBox795" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.burden)" Format="{0:C2}" Name="textBox796" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.erContribution)" Format="{0:C2}" Name="textBox797" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossProfit)" Format="{0:C2}" Name="textBox798" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.billHours)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.billHours)&lt;&gt;0,&#xD;&#xA;sum(Fields.billHours),null),'''')" Format="{0:C2}" Name="textBox799" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.gPBill),null),'''')" Format="{0:P2}" Name="textBox800" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billHours)" Format="{0:N2}" Name="textBox801" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.billHours)" Format="{0:N2}" Name="textBox802" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billHours)" Format="{0:N2}" Name="textBox803" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.payhours)" Format="{0:N2}" Name="textBox807" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billHours)" Format="{0:N2}" Name="textBox808" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.65in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billAmount)" Format="{0:C2}" Name="textBox809" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.dHFee)" Format="{0:C2}" Name="textBox810" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjBill)" Format="{0:C2}" Name="textBox811" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossWages)" Format="{0:C2}" Name="textBox813" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjPay)" Format="{0:C2}" Name="textBox814" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.employerTaxes)" Format="{0:C2}" Name="textBox816" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.wcCost)" Format="{0:C2}" Name="textBox817" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjCost)" Format="{0:C2}" Name="textBox818" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.burden)" Format="{0:C2}" Name="textBox819" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.erContribution)" Format="{0:C2}" Name="textBox820" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossProfit)" Format="{0:C2}" Name="textBox821" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.billHours)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.billHours)&lt;&gt;0,&#xD;&#xA;sum(Fields.billHours),null),'''')" Format="{0:C2}" Name="textBox822" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.gPBill),null),'''')" Format="{0:P2}" Name="textBox823" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.14in" Height="0.2in" Left="0in" Top="0in" Value="{Fields.wCCode}" Name="textBox824" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="0" RowSpan="1" ColumnSpan="4">
                              <ReportItem>
                                <TextBox Width="2.99in" Height="0.2in" Left="0in" Top="0in" Value=" User: {IsNull(Fields.userTypePerson,'''')}" Name="textBox806" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Bottom="Dotted" />
                                    <BorderColor Bottom="191, 191, 191" />
                                    <BorderWidth Bottom="1pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="0" RowSpan="1" ColumnSpan="4">
                              <ReportItem>
                                <TextBox Width="2.99in" Height="0.2in" Left="0in" Top="0in" Value="Office: {Fields.office}" Name="textBox708" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Bottom="Solid" />
                                    <BorderColor Bottom="191, 191, 191" />
                                    <BorderWidth Bottom="1pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox5" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Name="textBox6" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.25in" Left="0in" Top="0in" Name="textBox15" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Bold="True" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.25in" Left="0in" Top="0in" Name="textBox16" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="None" />
                                    <BorderColor Bottom="191, 191, 191" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.25in" Left="0in" Top="0in" Name="textBox18" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.25in" Left="0in" Top="0in" Name="textBox19" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.25in" Left="0in" Top="0in" Name="textBox21" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.25in" Left="0in" Top="0in" Name="textBox22" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.25in" Left="0in" Top="0in" Name="textBox23" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.25in" Left="0in" Top="0in" Name="textBox24" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.25in" Left="0in" Top="0in" Name="textBox25" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.25in" Left="0in" Top="0in" Name="textBox27" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.25in" Left="0in" Top="0in" Name="textBox28" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.25in" Left="0in" Top="0in" Name="textBox29" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="0" RowSpan="1" ColumnSpan="4">
                              <ReportItem>
                                <TextBox Width="2.99in" Height="0.25in" Left="0in" Top="0in" Value="Company: {Fields.tenantOrganizationalias}" Name="textBox50" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="None" Bottom="Solid" />
                                    <BorderColor Top="Black" Bottom="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Name="textBox13" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox14" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Name="textBox51" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox53" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox55" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox56" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox57" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox58" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox59" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox61" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox62" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Name="textBox83" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="0" RowSpan="1" ColumnSpan="4">
                              <ReportItem>
                                <TextBox Width="2.99in" Height="0.2in" Left="0in" Top="0in" Value="Subtotal-{Fields.tenantOrganizationalias}" Name="textBox9" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.14in" Height="0.2in" Left="0in" Top="0in" Value="=CountDistinct(Fields.customerId)" Name="textBox8" StyleName="">
                                  <Style Visible="True" TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.payhours)" Format="{0:N2}" Name="textBox7" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billHours)" Format="{0:N2}" Name="textBox10" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.65in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.billAmount)" Format="{0:C2}" Name="textBox11" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.dHFee)" Format="{0:C2}" Name="textBox31" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjBill)" Format="{0:C2}" Name="textBox33" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossWages)" Format="{0:C2}" Name="textBox35" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjPay)" Format="{0:C2}" Name="textBox36" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.employerTaxes)" Format="{0:C2}" Name="textBox39" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.wcCost)" Format="{0:C2}" Name="textBox40" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPAdjCost)" Format="{0:C2}" Name="textBox41" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.burden)" Format="{0:C2}" Name="textBox42" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.erContribution)" Format="{0:C2}" Name="textBox43" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.grossProfit)" Format="{0:C2}" Name="textBox44" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.billHours)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.billHours)&lt;&gt;0,&#xD;&#xA;sum(Fields.billHours),null),'''')" Format="{0:C2}" Name="textBox45" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.2in" Left="0in" Top="0in" Value="=iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.grossProfit)/ iif(sum(Fields.gPBill)&lt;&gt;0,sum(Fields.gPBill),null),'''')" Format="{0:P2}" Name="textBox46" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.14in" Height="0.4in" Left="0in" Top="0in" Value="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',''Employee'',&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',''WC Code'',&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',''Job Type'',&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value)Like ''*Customer*'',''Customer - Department'',&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',''User'',&#xD;&#xA;IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',''Office'',''''))))))&#xD;&#xA;" Name="textBox108" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.4in" Left="0in" Top="0in" Value="Pay Hrs" Format="{0}" Name="textBox47">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.4in" Left="0in" Top="0in" Value="Bill Hrs" Format="{0}" Name="textBox48">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.65in" Height="0.4in" Left="0in" Top="0in" Value="Sales" Format="{0}" Name="textBox49">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.35in" Height="0.4in" Left="0in" Top="0in" Value="DH Fee" Name="textBox85" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="7" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.4in" Left="0in" Top="0in" Value="GP Adj Bill" Name="textBox87" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderColor Default="BlanchedAlmond" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.4in" Left="0in" Top="0in" Value="Gross Wages/AgencyCost" Name="textBox89" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.4in" Left="0in" Top="0in" Value="GP Adj Pay" Name="textBox90" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.4in" Left="0in" Top="0in" Value="Er Taxes" Name="textBox92" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.4in" Left="0in" Top="0in" Value="WC Cost" Name="textBox93" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.4in" Left="0in" Top="0in" Value="GP Adj Cost" Name="textBox94" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="14" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.4in" Left="0in" Top="0in" Value="Burden" Name="textBox95" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="15" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.4in" Left="0in" Top="0in" Value="Er Contr." Name="textBox96" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="16" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.4in" Left="0in" Top="0in" Value="Gross Profit" Name="textBox97" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="17" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.4in" Left="0in" Top="0in" Value="GP/Billed Hour" Name="textBox98" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="18" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.46in" Height="0.4in" Left="0in" Top="0in" Value="GP%" Name="textBox100" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.25in" Left="0in" Top="0in" Name="textBox106" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderColor Bottom="191, 191, 191" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.4in" Left="0in" Top="0in" Value="GP Bill" Name="textBox111" StyleName="">
                                  <Style BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderColor Default="BlanchedAlmond" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox148" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPBill)" Format="{0:C2}" Name="textBox150" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.25in" Left="0in" Top="0in" Name="textBox151" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderColor Bottom="191, 191, 191" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.4in" Left="0in" Top="0in" Value="Charge" Name="textBox153" StyleName="">
                                  <Style BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderColor Default="BlanchedAlmond" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox169" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.25in" Left="0in" Top="0in" Name="textBox171" StyleName="">
                                  <Style Visible="False" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderColor Bottom="191, 191, 191" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox186" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.4in" Left="0in" Top="0in" Value="Disc." Name="textBox188" StyleName="">
                                  <Style Visible="True" BackgroundColor="217, 217, 217" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.discount)" Format="{0:C2}" Name="textBox172" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.discount)" Format="{0:C2}" Name="textBox178" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.discount)" Format="{0:C2}" Name="textBox179" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.discount)" Format="{0:C2}" Name="textBox180" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.discount)" Format="{0:C2}" Name="textBox182" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.discount)" Format="{0:C2}" Name="textBox183" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.discount)" Format="{0:C2}" Name="textBox184" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.charge)" Format="{0:C2}" Name="textBox1" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.charge)" Format="{0:C2}" Name="textBox4" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.charge)" Format="{0:C2}" Name="textBox17" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.charge)" Format="{0:C2}" Name="textBox20" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.charge)" Format="{0:C2}" Name="textBox30" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.charge)" Format="{0:C2}" Name="textBox34" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.charge)" Format="{0:C2}" Name="textBox37" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPBill)" Format="{0:C2}" Name="textBox54" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="False" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Employee*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPBill)" Format="{0:C2}" Name="textBox88" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPBill)" Format="{0:C2}" Name="textBox91" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPBill)" Format="{0:C2}" Name="textBox125" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.21in" Left="0in" Top="0in" Value="=sum(fields.gPBill)" Format="{0:C2}" Name="textBox131" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Value="=sum(fields.gPBill)" Format="{0:C2}" Name="textBox137" StyleName="">
                                  <Style Visible="True" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" Bold="True" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox159" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox154" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox162" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox112" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox160" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox164" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Job Type*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="6" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.4in" Height="0.2in" Left="0in" Top="0in" Name="textBox161" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.5in" Height="0.2in" Left="0in" Top="0in" Name="textBox165" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="8" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox115" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*WC Code*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox170" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="Black" Bottom="Black" Left="Black" Right="Black" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox116" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="Black" Bottom="Black" Left="Black" Right="Black" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="12" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox166" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="Black" Bottom="Black" Left="Black" Right="Black" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="13" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.45in" Height="0.2in" Left="0in" Top="0in" Name="textBox167" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="Black" Bottom="Black" Left="Black" Right="Black" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="0" RowSpan="1" ColumnSpan="10">
                              <ReportItem>
                                <TextBox Width="6.04in" Height="0.2in" Left="0in" Top="0in" Value="  Customer: {Fields.customer}                Department:{Fields.department}" Name="textBox805" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Bottom="Dashed" />
                                    <BorderColor Bottom="191, 191, 191" />
                                    <BorderWidth Bottom="1pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Customer*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox134" StyleName="">
                                  <Style Visible="True" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*Office*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="4" RowSpan="1" ColumnSpan="3">
                              <ReportItem>
                                <TextBox Width="1.25in" Height="0.2in" Left="0in" Top="0in" Value="Customer #: {CountDistinct(Fields.customerId)}" Name="textBox142" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="7" RowSpan="1" ColumnSpan="2">
                              <ReportItem>
                                <TextBox Width="1.1in" Height="0.2in" Left="0in" Top="0in" Value="Employee #: {CountDistinct(Fields.employeeId)}" Name="textBox260" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="9" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.7in" Height="0.2in" Left="0in" Top="0in" Name="textBox77" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="10" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.55in" Height="0.2in" Left="0in" Top="0in" Name="textBox80" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="11" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="0.6in" Height="0.2in" Left="0in" Top="0in" Name="textBox143" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                  <ConditionalFormatting>
                                    <FormattingRule>
                                      <Style Visible="False" />
                                      <Filters>
                                        <Filter Expression="=IIF(Join('','',Parameters.GroupBy.Value) Like ''*User*'',True,False)" Operator="Equal" Value="False" />
                                      </Filters>
                                    </FormattingRule>
                                  </ConditionalFormatting>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                          </Cells>
                          <Columns>
                            <Column Width="1.14in" />
                            <Column Width="0.6in" />
                            <Column Width="0.6in" />
                            <Column Width="0.65in" />
                            <Column Width="0.35in" />
                            <Column Width="0.5in" />
                            <Column Width="0.4in" />
                            <Column Width="0.5in" />
                            <Column Width="0.6in" />
                            <Column Width="0.7in" />
                            <Column Width="0.55in" />
                            <Column Width="0.6in" />
                            <Column Width="0.55in" />
                            <Column Width="0.45in" />
                            <Column Width="0.4in" />
                            <Column Width="0.45in" />
                            <Column Width="0.6in" />
                            <Column Width="0.5in" />
                            <Column Width="0.46in" />
                          </Columns>
                          <Rows>
                            <Row Height="0.25in" />
                            <Row Height="0.4in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.21in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                          </Rows>
                        </Body>
                        <Corner />
                        <Style Visible="True" />
                        <RowGroups>
                          <TableGroup PageBreak="After" Name="company">
                            <ChildGroups>
                              <TableGroup PageBreak="After" Name="company1">
                                <ChildGroups>
                                  <TableGroup Name="group56">
                                    <ChildGroups>
                                      <TableGroup Name="group123">
                                        <ChildGroups>
                                          <TableGroup Name="group126">
                                            <ChildGroups>
                                              <TableGroup Name="group127">
                                                <ChildGroups>
                                                  <TableGroup Name="group128">
                                                    <ChildGroups>
                                                      <TableGroup Name="group129">
                                                        <ChildGroups>
                                                          <TableGroup Name="group130">
                                                            <ChildGroups>
                                                              <TableGroup Name="group131">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group132" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                  </TableGroup>
                                                </ChildGroups>
                                              </TableGroup>
                                            </ChildGroups>
                                          </TableGroup>
                                        </ChildGroups>
                                      </TableGroup>
                                    </ChildGroups>
                                  </TableGroup>
                                  <TableGroup Name="group157">
                                    <ChildGroups>
                                      <TableGroup Name="group158">
                                        <ChildGroups>
                                          <TableGroup Name="group159">
                                            <ChildGroups>
                                              <TableGroup Name="group160">
                                                <ChildGroups>
                                                  <TableGroup Name="group161">
                                                    <ChildGroups>
                                                      <TableGroup Name="group162">
                                                        <ChildGroups>
                                                          <TableGroup Name="group163">
                                                            <ChildGroups>
                                                              <TableGroup Name="group164">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group165" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                  </TableGroup>
                                                </ChildGroups>
                                              </TableGroup>
                                            </ChildGroups>
                                          </TableGroup>
                                        </ChildGroups>
                                      </TableGroup>
                                    </ChildGroups>
                                  </TableGroup>
                                  <TableGroup Name="office">
                                    <ChildGroups>
                                      <TableGroup Name="group136">
                                        <ChildGroups>
                                          <TableGroup Name="group46">
                                            <ChildGroups>
                                              <TableGroup Name="group61">
                                                <ChildGroups>
                                                  <TableGroup Name="group62">
                                                    <ChildGroups>
                                                      <TableGroup Name="group63">
                                                        <ChildGroups>
                                                          <TableGroup Name="group93">
                                                            <ChildGroups>
                                                              <TableGroup Name="group94">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group95" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                  </TableGroup>
                                                </ChildGroups>
                                              </TableGroup>
                                            </ChildGroups>
                                          </TableGroup>
                                        </ChildGroups>
                                      </TableGroup>
                                      <TableGroup Name="organizationId1">
                                        <ChildGroups>
                                          <TableGroup Name="office1">
                                            <ChildGroups>
                                              <TableGroup Name="userTypePerson">
                                                <ChildGroups>
                                                  <TableGroup Name="group83">
                                                    <ChildGroups>
                                                      <TableGroup Name="group84">
                                                        <ChildGroups>
                                                          <TableGroup Name="group85">
                                                            <ChildGroups>
                                                              <TableGroup Name="group86">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group87" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                  </TableGroup>
                                                  <TableGroup Name="customer">
                                                    <ChildGroups>
                                                      <TableGroup Name="group75">
                                                        <ChildGroups>
                                                          <TableGroup Name="group76">
                                                            <ChildGroups>
                                                              <TableGroup Name="group77">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group78" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                      <TableGroup Name="jobType">
                                                        <ChildGroups>
                                                          <TableGroup Name="group69">
                                                            <ChildGroups>
                                                              <TableGroup Name="group70">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group71" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                          <TableGroup Name="wCCode">
                                                            <ChildGroups>
                                                              <TableGroup Name="group65">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group66" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                              <TableGroup Name="employee">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group64" />
                                                                </ChildGroups>
                                                                <Groupings>
                                                                  <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) ,''Employee'')&gt;0,Fields.employee,Null)" />
                                                                  <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) ,''WC Code'')&gt;0,Fields.wCCode,1)" />
                                                                  <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) , ''Job Type'')&gt;0,Fields.jobType,1)" />
                                                                  <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) ,''Customer'')&gt;0,Fields.customer,1)" />
                                                                  <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) , ''User'')&gt;0,Fields.userTypePerson,1)" />
                                                                  <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) ,''Office'')&gt;0,Fields.office,1)" />
                                                                </Groupings>
                                                                <Sortings>
                                                                  <Sorting Expression="=IIF(IndexOfSubstr(Join('','',Parameters.GroupBy.Value) ,''Employee'')&gt;0,Fields.employee,1)" Direction="Asc" />
                                                                </Sortings>
                                                              </TableGroup>
                                                              <TableGroup Name="group67">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group68" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                            <Groupings>
                                                              <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label),''WC Code'')&gt;0,Fields.wCCode,Null)" />
                                                            </Groupings>
                                                            <Sortings>
                                                              <Sorting Expression="=Fields.wCCode" Direction="Asc" />
                                                              <Sorting Expression="=Fields.employee" Direction="Asc" />
                                                            </Sortings>
                                                          </TableGroup>
                                                          <TableGroup Name="group72">
                                                            <ChildGroups>
                                                              <TableGroup Name="group73">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group74" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                        <Groupings>
                                                          <Grouping Expression="=IIF(IndexOfSubstr( ''1,''+Join('', '', Parameters.GroupBy.label) ,''Job Type'')&gt;0,fields.jobType,Null)" />
                                                        </Groupings>
                                                        <Sortings>
                                                          <Sorting Expression="=Fields.jobType" Direction="Asc" />
                                                        </Sortings>
                                                      </TableGroup>
                                                      <TableGroup Name="group79">
                                                        <ChildGroups>
                                                          <TableGroup Name="group80">
                                                            <ChildGroups>
                                                              <TableGroup Name="group81">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group82" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                    <Groupings>
                                                      <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) ,''Customer'')&gt;0,Fields.customerId,Null)" />
                                                    </Groupings>
                                                    <Sortings>
                                                      <Sorting Expression="=Fields.customer" Direction="Asc" />
                                                      <Sorting Expression="=Fields.department" Direction="Asc" />
                                                    </Sortings>
                                                  </TableGroup>
                                                  <TableGroup Name="group88">
                                                    <ChildGroups>
                                                      <TableGroup Name="group89">
                                                        <ChildGroups>
                                                          <TableGroup Name="group90">
                                                            <ChildGroups>
                                                              <TableGroup Name="group91">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group92" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                  </TableGroup>
                                                </ChildGroups>
                                                <Groupings>
                                                  <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) , ''User'')&gt;0,Fields.userTypePerson,Null)" />
                                                </Groupings>
                                                <Sortings>
                                                  <Sorting Expression="=IsNull(Fields.userTypePerson,'''')" Direction="Asc" />
                                                </Sortings>
                                              </TableGroup>
                                            </ChildGroups>
                                          </TableGroup>
                                        </ChildGroups>
                                      </TableGroup>
                                      <TableGroup Name="group138">
                                        <ChildGroups>
                                          <TableGroup Name="group113">
                                            <ChildGroups>
                                              <TableGroup Name="group96">
                                                <ChildGroups>
                                                  <TableGroup Name="group97">
                                                    <ChildGroups>
                                                      <TableGroup Name="group98">
                                                        <ChildGroups>
                                                          <TableGroup Name="group99">
                                                            <ChildGroups>
                                                              <TableGroup Name="group100">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group101" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                  </TableGroup>
                                                </ChildGroups>
                                              </TableGroup>
                                            </ChildGroups>
                                          </TableGroup>
                                        </ChildGroups>
                                      </TableGroup>
                                    </ChildGroups>
                                    <Groupings>
                                      <Grouping Expression="=IIF(IndexOfSubstr(''1,''+ Join('', '', Parameters.GroupBy.label) ,''Office'')&gt;0,Fields.officeId,Null)" />
                                    </Groupings>
                                    <Sortings>
                                      <Sorting Expression="=Fields.office" Direction="Asc" />
                                    </Sortings>
                                  </TableGroup>
                                  <TableGroup Name="group148">
                                    <ChildGroups>
                                      <TableGroup Name="group149">
                                        <ChildGroups>
                                          <TableGroup Name="group150">
                                            <ChildGroups>
                                              <TableGroup Name="group151">
                                                <ChildGroups>
                                                  <TableGroup Name="group152">
                                                    <ChildGroups>
                                                      <TableGroup Name="group153">
                                                        <ChildGroups>
                                                          <TableGroup Name="group154">
                                                            <ChildGroups>
                                                              <TableGroup Name="group155">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group156" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                  </TableGroup>
                                                </ChildGroups>
                                              </TableGroup>
                                            </ChildGroups>
                                          </TableGroup>
                                        </ChildGroups>
                                      </TableGroup>
                                    </ChildGroups>
                                  </TableGroup>
                                  <TableGroup Name="group133">
                                    <ChildGroups>
                                      <TableGroup Name="group137">
                                        <ChildGroups>
                                          <TableGroup Name="group141">
                                            <ChildGroups>
                                              <TableGroup Name="group142">
                                                <ChildGroups>
                                                  <TableGroup Name="group143">
                                                    <ChildGroups>
                                                      <TableGroup Name="group144">
                                                        <ChildGroups>
                                                          <TableGroup Name="group145">
                                                            <ChildGroups>
                                                              <TableGroup Name="group146">
                                                                <ChildGroups>
                                                                  <TableGroup Name="group147" />
                                                                </ChildGroups>
                                                              </TableGroup>
                                                            </ChildGroups>
                                                          </TableGroup>
                                                        </ChildGroups>
                                                      </TableGroup>
                                                    </ChildGroups>
                                                  </TableGroup>
                                                </ChildGroups>
                                              </TableGroup>
                                            </ChildGroups>
                                          </TableGroup>
                                        </ChildGroups>
                                      </TableGroup>
                                    </ChildGroups>
                                  </TableGroup>
                                </ChildGroups>
                                <Groupings>
                                  <Grouping Expression="=Fields.organizationId" />
                                </Groupings>
                                <Sortings>
                                  <Sorting Expression="=Fields.tenantOrganizationalias" Direction="Asc" />
                                </Sortings>
                              </TableGroup>
                            </ChildGroups>
                          </TableGroup>
                        </RowGroups>
                        <ColumnGroups>
                          <TableGroup Name="group109" />
                          <TableGroup Name="group110" />
                          <TableGroup Name="group5" />
                          <TableGroup Name="group111" />
                          <TableGroup Name="group18" />
                          <TableGroup Name="group2" />
                          <TableGroup Name="group3" />
                          <TableGroup Name="group21" />
                          <TableGroup Name="group" />
                          <TableGroup Name="group26" />
                          <TableGroup Name="group28" />
                          <TableGroup Name="group55" />
                          <TableGroup Name="group112" />
                          <TableGroup Name="group114" />
                          <TableGroup Name="group116" />
                          <TableGroup Name="group118" />
                          <TableGroup Name="group120" />
                          <TableGroup Name="group122" />
                          <TableGroup Name="group124" />
                        </ColumnGroups>
                        <Bindings>
                          <Binding Path="DataSource" Expression="=Fields.grossProfitData" />
                        </Bindings>
                      </Table>
                    </Items>
                  </Panel>
                </ReportItem>
              </TableCell>
            </Cells>
            <Columns>
              <Column Width="1017.6px" />
            </Columns>
            <Rows>
              <Row Height="316.99px" />
              <Row Height="0.104in" />
              <Row Height="3.043in" />
            </Rows>
          </Body>
          <Corner />
          <RowGroups>
            <TableGroup PageBreak="After" Name="organizationId">
              <ChildGroups>
                <TableGroup Name="group22" />
                <TableGroup Name="DetailGroup">
                  <Groupings>
                    <Grouping />
                  </Groupings>
                </TableGroup>
                <TableGroup Name="group25" />
              </ChildGroups>
              <Groupings>
                <Grouping Expression="=Fields.OrganizationId" />
              </Groupings>
              <Sortings>
                <Sorting Expression="=Fields.tenantOrganizationalias" Direction="Asc" />
              </Sortings>
            </TableGroup>
          </RowGroups>
          <ColumnGroups>
            <TableGroup Name="ColumnGroup" />
          </ColumnGroups>
          <Bindings>
            <Binding Path="DataSource" Expression="=Fields.Company" />
          </Bindings>
        </List>
        <List Width="7.425in" Height="3.226in" Left="1.577in" Top="6.844in" Name="list2">
          <Body>
            <Cells>
              <TableCell RowIndex="0" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                <ReportItem>
                  <Panel Width="712.8px" Height="309.7px" Left="0in" Top="0in" Name="ReportTotal">
                    <Items>
                      <Table Width="7.407in" Height="3.226in" Left="0in" Top="0in" Name="table4">
                        <Body>
                          <Cells>
                            <TableCell RowIndex="10" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Name="textBox118" StyleName="">
                                  <Style VerticalAlign="Middle" />
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Name="textBox124" StyleName="">
                                  <Style VerticalAlign="Middle" />
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="15" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Name="textBox127" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="15" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Name="textBox128" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="15" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Name="textBox129" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="191, 191, 191" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Name="textBox226" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Name="textBox230" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="15" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Name="textBox231" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Top="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalgrossOnly&#xD;&#xA;" Format="{0:C2}" Name="textBox235">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="15" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Name="textBox247" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="Solid" />
                                    <BorderColor Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="15" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Name="textBox263" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox110" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Name="textBox206" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="191, 191, 191" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Format="{0}" Name="textBox126" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox104" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox81" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Value="Payroll Cost" Format="{0:C2}" Name="textBox105" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="Solid" />
                                    <BorderColor Top="166, 166, 166" />
                                    <BorderWidth Top="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=fields.grandTotalPayrollCost" Format="{0:C2}" Name="textBox78" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Top="Solid" Right="None" />
                                    <BorderColor Top="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox130" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox121" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox133" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox75" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Name="textBox26" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="191, 191, 191" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Format="{0}" Name="textBox114" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox70" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="Black" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox72" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="Black" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox84" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox102" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Value="Gross Wages" Format="{0}" Name="textBox176">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Value="Sales" Format="{0}" Name="textBox254">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalBillAmount" Format="{0:C2}" Name="textBox64" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="Solid" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.2in" Left="0in" Top="0in" Value="Discount Amount" Format="{0:C2}" Name="textBox264" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.2in" Left="0in" Top="0in" Value="=Fields.grandTotalDiscountAmount&#xD;&#xA;" Format="{0:C2}" Name="textBox255" StyleName="">
                                  <Style Color="Red" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="Solid" />
                                    <BorderColor Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Format="{0}" Name="textBox257" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="Solid" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Value="Gross Profit&#xD;&#xA;" Format="{0:C2}" Name="textBox146" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="Solid" Left="Solid" />
                                    <BorderColor Top="166, 166, 166" Left="191, 191, 191" />
                                    <BorderWidth Top="1pt" Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalGrossProfit&#xD;&#xA;" Format="{0:C2}" Name="textBox119" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Top="Solid" Left="None" Right="Solid" />
                                    <BorderColor Top="166, 166, 166" Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Name="textBox132" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:P2}" Name="textBox79" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Left="None" Right="Solid" />
                                    <BorderColor Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Format="{0}" Name="textBox243" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="None" Left="Solid" />
                                    <BorderColor Top="Black" Left="191, 191, 191" />
                                    <BorderWidth Top="1pt" Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Format="{0}" Name="textBox76" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="DH Fee&#xD;&#xA;" Format="{0:C2}" Name="textBox258" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="191, 191, 191" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotaldHFee&#xD;&#xA;" Format="{0:C2}" Name="textBox65" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="13" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox52" StyleName="">
                                  <Style Color="Red" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="14" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox245" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="0" ColumnIndex="0" RowSpan="1" ColumnSpan="6">
                              <ReportItem>
                                <TextBox Width="7.407in" Height="0.2in" Left="0in" Top="0in" Value="Report Total" Name="textBox237">
                                  <Style BackgroundColor="191, 191, 191" TextAlign="Center" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="Solid" Bottom="Solid" Left="Solid" Right="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Name="textBox224" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Format="{0:C2}" Name="textBox82" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.2in" Left="0in" Top="0in" Value="Agency Cost" Name="textBox225" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.2in" Left="0in" Top="0in" Value="=fields.grandTotalAgencyCost" Format="{0:C2}" Name="textBox241" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.2in" Left="0in" Top="0in" Value="Employer Taxes " Format="{0:C2}" Name="textBox63" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.2in" Left="0in" Top="0in" Value="=Fields.grandTotalEmployerTaxes" Format="{0:C2}" Name="textBox249" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Value="Wc Cost" Format="{0:C2}" Name="textBox250" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalwcCost&#xD;&#xA;" Format="{0:C2}" Name="textBox69" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Value="Burden" Format="{0:C2}" Name="textBox66" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="Black" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalBurden" Format="{0:C2}" Name="textBox60" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="Black" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.036in" Height="0.202in" Left="0in" Top="0in" Value="Er Contribution" Format="{0:C2}" Name="textBox205" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalErContribution" Format="{0:C2}" Name="textBox32" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Value="GP Bill" Format="{0:C2}" Name="textBox101" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="Solid" Left="Solid" />
                                    <BorderColor Top="166, 166, 166" Left="191, 191, 191" />
                                    <BorderWidth Top="1pt" Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=fields.grandTotalgPBill" Format="{0:C2}" Name="textBox99" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Top="Solid" Bottom="None" Right="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Value="GP Adj Bill" Format="{0}" Name="textBox181" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="4" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalGPAdjBill" Format="{0:C2}" Name="textBox67" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="Solid" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.2in" Left="0in" Top="0in" Value="Charge" Format="{0:C2}" Name="textBox236" StyleName="">
                                  <Style VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.2in" Left="0in" Top="0in" Value="=fields.grandTotalcharge" Format="{0:C2}" Name="textBox251" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Value="Payroll Cost" Format="{0:C2}" Name="textBox252" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Top="None" Bottom="None" Left="Solid" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="191, 191, 191" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=fields.grandTotalPayrollCost" Format="{0:C2}" Name="textBox239" StyleName="">
                                  <Style Color="Red" TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Value="GP Adj Pay" Name="textBox103" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=fields.grandTotalGPAdjPay" Format="{0:C2}" Name="textBox240" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Right="None" />
                                    <BorderColor Right="191, 191, 191" />
                                    <BorderWidth Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="2" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.443in" Height="0.202in" Left="0in" Top="0in" Value="Gross Profit (%) " Name="textBox193" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" Bold="True" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="3" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.026in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalGrossProfitPercent" Format="{0:P2}" Name="textBox122" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" Bold="True" />
                                    <BorderStyle Left="None" Right="Solid" />
                                    <BorderColor Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="Reimbursement" Format="{0:C2}" Name="textBox242" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="1" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=fields.grandTotalReimbursement" Format="{0:C2}" Name="textBox73" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="Solid" />
                                    <BorderColor Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.2in" Left="0in" Top="0in" Value="Deduction" Format="{0:C2}" Name="textBox229" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" Right="None" />
                                    <BorderColor Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="2" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.2in" Left="0in" Top="0in" Value="=fields.grandTotalDeduction" Format="{0:C2}" Name="textBox163" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="Solid" />
                                    <BorderColor Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.2in" Left="0in" Top="0in" Value="Adj Bill" Format="{0:C2}" Name="textBox199" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="3" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.2in" Left="0in" Top="0in" Value="=Fields.grandTotalAdjustmentBill&#xD;&#xA;" Format="{0:C2}" Name="textBox256" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="Total Billed Hours&#xD;&#xA;" Format="{0:C2}" Name="textBox155" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" Right="None" />
                                    <BorderColor Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="6" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalTotalBillHours" Format="{0:N2}" Name="textBox117" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="Total Paid Hours &#xD;&#xA;" Format="{0:C2}" Name="textBox74" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" Right="None" />
                                    <BorderColor Left="166, 166, 166" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="5" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalTotalPayhours&#xD;&#xA;" Format="{0:N2}" Name="textBox68" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="No. of Customers &#xD;&#xA;" Name="textBox71" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Left="191, 191, 191" Right="191, 191, 191" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="11" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalNumberOfCustomer&#xD;&#xA;" Format="{0}" Name="textBox135" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="Total Pay" Format="{0:C2}" Name="textBox123" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="Total Bill" Format="{0}" Name="textBox253" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="Sales Tax" Format="{0}" Name="textBox259" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="Total Invoice Amount" Format="{0}" Name="textBox120" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="Solid" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="7" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalTotalPay" Format="{0:C2}" Name="textBox152" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="8" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalTotalBill" Format="{0:C2}" Name="textBox200" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="9" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalSalesTax" Format="{0:C2}" Name="textBox86" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="10" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=(fields.grandTotalTotalBill+fields.grandTotalSalesTax+fields.grandTotalcharge-fields.grandTotalDiscountAmount)" Format="{0:C2}" Name="textBox149" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Bottom">
                                    <Font Name="Cambria" Size="8pt" />
                                    <BorderStyle Left="None" Right="None" />
                                    <BorderColor Top="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                                    <BorderWidth Left="1pt" Right="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="4" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.563in" Height="0.202in" Left="0in" Top="0in" Value="No. of Employees " Format="{0}" Name="textBox261" StyleName="">
                                  <Style TextAlign="Left" VerticalAlign="Middle">
                                    <Font Name="Cambria" Size="9pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="191, 191, 191" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                            <TableCell RowIndex="12" ColumnIndex="5" RowSpan="1" ColumnSpan="1">
                              <ReportItem>
                                <TextBox Width="1.313in" Height="0.202in" Left="0in" Top="0in" Value="=Fields.grandTotalNumberOfEmployee" Format="{0}" Name="textBox262" StyleName="">
                                  <Style TextAlign="Right" VerticalAlign="Middle">
                                    <Font Name="Calibri" Size="8pt" />
                                    <BorderStyle Left="None" />
                                    <BorderColor Left="166, 166, 166" />
                                    <BorderWidth Left="1pt" />
                                  </Style>
                                </TextBox>
                              </ReportItem>
                            </TableCell>
                          </Cells>
                          <Columns>
                            <Column Width="1.036in" />
                            <Column Width="1.026in" />
                            <Column Width="1.443in" />
                            <Column Width="1.026in" />
                            <Column Width="1.563in" />
                            <Column Width="1.313in" />
                          </Columns>
                          <Rows>
                            <Row Height="0.2in" />
                            <Row Height="0.202in" />
                            <Row Height="0.2in" />
                            <Row Height="0.2in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                            <Row Height="0.202in" />
                          </Rows>
                        </Body>
                        <Corner />
                        <Style>
                          <BorderStyle Top="Solid" Bottom="Solid" Left="Solid" Right="Solid" />
                          <BorderColor Top="166, 166, 166" Bottom="166, 166, 166" Left="166, 166, 166" Right="166, 166, 166" />
                          <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
                        </Style>
                        <RowGroups>
                          <TableGroup Name="group1">
                            <ChildGroups>
                              <TableGroup Name="group10" />
                            </ChildGroups>
                          </TableGroup>
                          <TableGroup Name="detailTableGroup2">
                            <ChildGroups>
                              <TableGroup Name="group29" />
                              <TableGroup Name="group60" />
                              <TableGroup Name="group59" />
                              <TableGroup Name="group30" />
                              <TableGroup Name="group31" />
                              <TableGroup Name="group32" />
                              <TableGroup Name="group36" />
                              <TableGroup Name="group38" />
                              <TableGroup Name="group35" />
                              <TableGroup Name="group40" />
                              <TableGroup Name="group34" />
                              <TableGroup Name="group39" />
                              <TableGroup Name="group33" />
                              <TableGroup Name="group41" />
                              <TableGroup Name="group42" />
                            </ChildGroups>
                            <Groupings>
                              <Grouping />
                            </Groupings>
                          </TableGroup>
                        </RowGroups>
                        <ColumnGroups>
                          <TableGroup Name="tableGroup5" />
                          <TableGroup Name="group52" />
                          <TableGroup Name="tableGroup6" />
                          <TableGroup Name="group53" />
                          <TableGroup Name="tableGroup7" />
                          <TableGroup Name="group54" />
                        </ColumnGroups>
                        <Bindings>
                          <Binding Path="DataSource" Expression="=fields.grandTotal" />
                        </Bindings>
                      </Table>
                    </Items>
                  </Panel>
                </ReportItem>
              </TableCell>
            </Cells>
            <Columns>
              <Column Width="712.8px" />
            </Columns>
            <Rows>
              <Row Height="309.7px" />
            </Rows>
          </Body>
          <Corner />
          <RowGroups>
            <TableGroup Name="DetailGroup">
              <Groupings>
                <Grouping />
              </Groupings>
            </TableGroup>
          </RowGroups>
          <ColumnGroups>
            <TableGroup Name="ColumnGroup" />
          </ColumnGroups>
          <Bindings>
            <Binding Path="DataSource" Expression="=Fields.ReportTotal" />
          </Bindings>
        </List>
      </Items>
    </DetailSection>
    <PageFooterSection Height="0.2in" Name="pageFooterSection1">
      <Items>
        <TextBox Width="1in" Height="0.2in" Left="4.8in" Top="0in" Value="=''Page '' + PageNumber + '' of '' + PageCount" Name="pageInfoTextBox" StyleName="PageInfo">
          <Style Color="Black" TextAlign="Center" VerticalAlign="Top">
            <Font Name="Cambria" Size="9pt" />
          </Style>
        </TextBox>
      </Items>
    </PageFooterSection>
    <ReportHeaderSection Height="0.548in" Name="reportHeaderSection1">
      <Items>
        <PictureBox Value="= IIF(Fields.Logo=''noImage'',null,Fields.Logo)" Width="1.5in" Height="0.5in" Left="0in" Top="0in" Sizing="ScaleProportional" MimeType="" Name="logo" />
        <TextBox Width="3.6in" Height="0.5in" Left="7in" Top="0in" Value="GrossProfit Report" Name="textBox12">
          <Style TextAlign="Right" VerticalAlign="Middle">
            <Font Name="Cambria" Size="16pt" Bold="True" />
            <BorderStyle Top="None" Bottom="None" Left="None" Right="None" />
            <BorderColor Top="Black" Bottom="Black" Left="Black" Right="Black" />
            <BorderWidth Top="1pt" Bottom="1pt" Left="1pt" Right="1pt" />
          </Style>
        </TextBox>
        <PictureBox Image="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" Width="10.6in" Height="0.03in" Left="0in" Top="0.518in" Sizing="Stretch" MimeType="image/jpeg" Name="line1" />
      </Items>
    </ReportHeaderSection>
  </Items>
  <PageSettings PaperKind="Letter" Landscape="True" ColumnCount="1" ColumnSpacing="0in" ContinuousPaper="False">
    <Margins>
      <MarginsU Left="0.2in" Right="0.2in" Top="0.25in" Bottom="0.25in" />
    </Margins>
  </PageSettings>
  <StyleSheet>
    <StyleRule>
      <Style>
        <Padding Left="2pt" Right="2pt" />
      </Style>
      <Selectors>
        <TypeSelector Type="TextItemBase" />
        <TypeSelector Type="HtmlTextBox" />
      </Selectors>
    </StyleRule>
  </StyleSheet>
  <Groups>
    <Group Name="UsernameGroup">
      <GroupHeader>
        <GroupHeaderSection Height="0.052in" Name="usernameGroupHeader">
          <Style Visible="False" />
        </GroupHeaderSection>
      </GroupHeader>
      <GroupFooter>
        <GroupFooterSection PrintAtBottom="True" PrintOnEveryPage="True" Height="0.3in" Name="usernamegroupFooterSection2">
          <Items>
            <PictureBox Image="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" Width="10.6in" Height="0.03in" Left="0in" Top="0in" Sizing="Stretch" MimeType="image/jpeg" Name="pictureBox1" />
            <Table DataSourceName="usernameDataSource" Width="2.437in" Height="0.2in" Left="0.014in" Top="0.03in" Name="table5">
              <Body>
                <Cells>
                  <TableCell RowIndex="0" ColumnIndex="0" RowSpan="1" ColumnSpan="1">
                    <ReportItem>
                      <TextBox Width="0.406in" Height="0.2in" Left="0in" Top="0in" Value="User:" Name="textBox156">
                        <Style VerticalAlign="Middle">
                          <Font Name="Cambria" Size="9pt" />
                        </Style>
                      </TextBox>
                    </ReportItem>
                  </TableCell>
                  <TableCell RowIndex="0" ColumnIndex="1" RowSpan="1" ColumnSpan="1">
                    <ReportItem>
                      <TextBox Width="2.031in" Height="0.2in" Left="0in" Top="0in" Value="= Fields.person" Name="textBox157" StyleName="">
                        <Style VerticalAlign="Middle">
                          <Font Name="Cambria" Size="9pt" />
                        </Style>
                      </TextBox>
                    </ReportItem>
                  </TableCell>
                </Cells>
                <Columns>
                  <Column Width="0.406in" />
                  <Column Width="2.031in" />
                </Columns>
                <Rows>
                  <Row Height="0.2in" />
                </Rows>
              </Body>
              <Corner />
              <Style VerticalAlign="Middle" />
              <RowGroups>
                <TableGroup Name="detailTableGroup">
                  <Groupings>
                    <Grouping />
                  </Groupings>
                </TableGroup>
              </RowGroups>
              <ColumnGroups>
                <TableGroup Name="tableGroup" />
                <TableGroup Name="tableGroup1" />
              </ColumnGroups>
            </Table>
            <TextBox Width="0.5in" Height="0.2in" Left="604.79pt" Top="2.17pt" Value="Date:" Name="textBox158">
              <Style TextAlign="Right" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.5in" Height="0.2in" Left="8.9in" Top="0.03in" Value="=NOW()" Format="{0:g}" Name="currentTimeTextBox" StyleName="PageInfo">
              <Style TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
          </Items>
        </GroupFooterSection>
      </GroupFooter>
      <Groupings>
        <Grouping />
      </Groupings>
    </Group>
    <Group Name="ParameterGroup">
      <GroupHeader>
        <GroupHeaderSection Height="0.052in" Name="ParametergroupHeaderSection1">
          <Style Visible="False" />
        </GroupHeaderSection>
      </GroupHeader>
      <GroupFooter>
        <GroupFooterSection PageBreak="Before" Height="2.676in" Name="parametergroupFooterSection1">
          <Style Visible="True" />
          <Items>
            <TextBox Width="2.143in" Height="0.2in" Left="0.014in" Top="0in" Value="PARAMETER LIST:" CanGrow="True" Name="textBox136" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="12pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.187in" Left="0.499in" Top="0.559in" Value="Period From:" CanGrow="True" Name="textBox138" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="0.754in" Height="0.187in" Left="1.5in" Top="0.559in" Value="= Parameters.StartDate.Value" Format="{0:d}" Name="textBox139">
              <Style TextAlign="Right" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="0.108in" Height="0.187in" Left="2.254in" Top="0.559in" Value="-" Format="{0:d}" Name="textBox140">
              <Style TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="0.852in" Height="0.183in" Left="2.362in" Top="0.559in" Value="= Parameters.EndDate.Value" Format="{0:d}" Name="textBox141">
              <Style TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="0.746in" Value="Company:" CanGrow="True" Name="textBox145" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="0.746in" KeepTogether="False" Value="=Join('', '', Parameters.Organization.label)" CanShrink="True" Name="textBox147">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="0.359in" Value="Date Type:" CanGrow="True" Name="textBox107" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="0.359in" KeepTogether="False" Value="=Parameters.DateType.label" CanShrink="True" Name="textBox38">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="0.946in" Value="Office:" CanGrow="True" Name="textBox275" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="0.946in" KeepTogether="False" Value="=Join('', '', Parameters.Office.label)" CanShrink="True" Name="textBox273">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.658in" Height="0.2in" Left="0.499in" Top="2.146in" Value="Roll Up to Parent Customer:" CanGrow="True" Name="textBox277" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="4.991in" Height="0.2in" Left="2.157in" Top="2.146in" KeepTogether="False" Value="= Parameters.RollUpToParentCustomer.Label" CanShrink="True" Name="textBox276">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="1.146in" Value="Group By:" CanGrow="True" Name="textBox279" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="1.146in" KeepTogether="False" Value="=Join('', '', Parameters.GroupBy.label)" CanShrink="True" Name="textBox278">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="2.346in" Value="Customer:" CanGrow="True" Name="textBox281" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="2.346in" KeepTogether="False" Value="= Parameters.Customer.Label" CanShrink="True" Name="textBox280">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="1.346in" Value="Job Type:" CanGrow="True" Name="textBox283" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="1.346in" KeepTogether="False" Value="=Join('', '', Parameters.JobType.label)" CanShrink="True" Name="textBox282">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="1.746in" Value="User Type:" CanGrow="True" Name="textBox269" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="1.746in" KeepTogether="False" Value="= Parameters.UserType.Label" CanShrink="True" Name="textBox244">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="1.546in" Value="User Level:" CanGrow="True" Name="textBox271" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="1.546in" KeepTogether="False" Value="= Parameters.UserLevel.Label" CanShrink="True" Name="textBox270">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
            <TextBox Width="1.001in" Height="0.2in" Left="0.499in" Top="1.946in" Value="User:" CanGrow="True" Name="textBox285" StyleName="Caption">
              <Style Color="Black" TextAlign="Left" VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" Bold="True" />
                <BorderStyle Default="None" />
                <BorderColor Default="Silver" />
                <BorderWidth Default="0.5pt" />
              </Style>
            </TextBox>
            <TextBox Width="5.648in" Height="0.2in" Left="1.5in" Top="1.946in" KeepTogether="False" Value="=Join('', '', Parameters.User.label)" CanShrink="True" Name="textBox284">
              <Style VerticalAlign="Middle">
                <Font Name="Cambria" Size="9pt" />
              </Style>
            </TextBox>
          </Items>
        </GroupFooterSection>
      </GroupFooter>
      <Groupings>
        <Grouping />
      </Groupings>
    </Group>
    <Group Name="ReportGroup">
      <GroupHeader>
        <GroupHeaderSection KeepTogether="False" Height="0.052in" Name="GroupTestheader">
          <Style Visible="False">
            <BorderStyle Right="None" />
            <BorderColor Right="191, 191, 191" />
            <BorderWidth Right="1pt" />
          </Style>
        </GroupHeaderSection>
      </GroupHeader>
      <GroupFooter>
        <GroupFooterSection PageBreak="None" Height="0.052in" Name="grouptestFooterSection">
          <Style Visible="False" />
        </GroupFooterSection>
      </GroupFooter>
    </Group>
  </Groups>
  <ReportParameters>
    <ReportParameter Name="UserPersonId" Type="Integer" Text="UserPersonId" AllowBlank="False">
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="ReportId" Type="Integer" Text="ReportId" AllowBlank="False">
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="DateType" Text="Date Type" Visible="True" AllowBlank="False">
      <AvailableValues DataSourceName="DateTypeSqlDataSource" DisplayMember="= Fields.DateType" ValueMember="= Fields.DateType" />
      <Value>
        <String>Accounting Period Date</String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="StartDate" Type="DateTime" Text="Start Date" Visible="True" AllowBlank="False">
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="EndDate" Type="DateTime" Text="End Date" Visible="True" AllowBlank="False">
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="Organization" Text="Company" Visible="True" MultiValue="True" AllowNull="True">
      <AvailableValues DataSourceName="CompanyListSqlDataSource" DisplayMember="= Fields.Alias" ValueMember="= Fields.OrganizationId">
        <Sortings>
          <Sorting Expression="= Fields.Alias" Direction="Asc" />
        </Sortings>
      </AvailableValues>
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="Office" Text="Office" Visible="True" MultiValue="True" AllowNull="True">
      <AvailableValues DataSourceName="OfficeListSqlDataSource" DisplayMember="= Fields.Office" ValueMember="= Fields.OfficeId">
        <Sortings>
          <Sorting Expression="= Fields.Office" Direction="Asc" />
        </Sortings>
      </AvailableValues>
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="GroupBy" Text="Group By" Visible="True" MultiValue="True" AllowBlank="False">
      <AvailableValues DataSourceName="GroupBySqlDataSource" DisplayMember="= Fields.GroupBy" ValueMember="= Fields.GroupBy" />
      <Value>
        <String>Office</String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="JobType" Text="Job Type" Visible="True" MultiValue="True" AllowNull="True">
      <AvailableValues DataSourceName="JobTypesqlDataSource" DisplayMember="=Fields.ResourceValue" ValueMember="= Fields.ListItemId">
        <Sortings>
          <Sorting Expression="= Fields.ListItem" Direction="Asc" />
        </Sortings>
      </AvailableValues>
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="UserLevel" Text="User Level" Visible="True" AllowNull="True">
      <AvailableValues DataSourceName="UserLevelSqlDataSource" DisplayMember="= Fields.UserLevel" ValueMember="= Fields.UserLevel" />
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="UserType" Text="User Type" Visible="True" AllowNull="True">
      <AvailableValues DataSourceName="UserTypeSqlDataSource" DisplayMember="= Fields.Description" ValueMember="= Fields.ListItemId">
        <Sortings>
          <Sorting Expression="= Fields.Description" Direction="Asc" />
        </Sortings>
      </AvailableValues>
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="User" Text="User" Visible="True" MultiValue="True" AllowNull="True">
      <AvailableValues DataSourceName="UserSqlDataSource" DisplayMember="= Fields.User" ValueMember="= Fields.PersonId">
        <Sortings>
          <Sorting Expression="= Fields.User" Direction="Asc" />
        </Sortings>
      </AvailableValues>
      <Value>
        <String></String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="RollUpToParentCustomer" Text="Roll Up to Parent Customer" Visible="True" AllowBlank="False">
      <AvailableValues DataSourceName="RollUptoParentCustomerSqlDataSource" DisplayMember="= Fields.Summary" ValueMember="= Fields.Summary" />
      <Value>
        <String>False</String>
      </Value>
    </ReportParameter>
    <ReportParameter Name="Customer" Text="Customer" Visible="True">
      <Value>
        <String>%</String>
      </Value>
    </ReportParameter>
  </ReportParameters>
</Report>'
FROM   dbo.Report AS r
       INNER JOIN dbo.PaginatedReport AS pr ON pr.ReportId = r.ReportId
WHERE  r.Report = 'GrossProfitDetail';
