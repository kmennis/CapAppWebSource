<%@ Page
    Title=""
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    CodeBehind="ConfigReportSchedule.aspx.cs"
    Inherits="KCWebManager.ConfigReportSchedule"
    EnableEventValidation="false" %>

<%@ Register Src="Controls/EntityControl.ascx" TagName="EntityControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        jq(document).ready(function () {
            jq('#btnEntityControlDelete').bind('click', function (e) {
                //if (confirm(mlGetString(2001, "Are you sure you want to delete this report schedule?")) == false) {
                if (confirm(jq("#resDeleteAlert").text()) == false) {
                    e.preventDefault();
                    return false;
                }
            });
        });

    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="Hidden">
        <asp:Label ID="resDeleteAlert" ClientIDMode="Static" Text="Are you sure you want to delete this report schedule?" runat="server" meta:resourcekey="resDeleteAlert" />
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:SqlDataSource ID="dsAllScheduleReports" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>" SelectCommand="SELECT [ID], [Name], [Enabled], [ReportView] FROM [ReportSchedule]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="dsSingleSchedule" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                DeleteCommand="DELETE FROM [ReportSchedule] WHERE [ID] = @ID"
                InsertCommand="INSERT INTO [ReportSchedule] ([Name], [Enabled], [ReportView], [MailTo], [MailSubject], [ScheduleTime], [ScheduleDays]) VALUES (@Name, @Enabled, @ReportView, @MailTo, @MailSubject, @ScheduleTime, @ScheduleDays)" SelectCommand="SELECT * FROM [ReportSchedule] WHERE ([ID] = @ID)" UpdateCommand="UPDATE [ReportSchedule] SET [Name] = @Name, [Enabled] = @Enabled, [ReportView] = @ReportView, [MailTo] = @MailTo, [MailSubject] = @MailSubject, [ScheduleTime] = @ScheduleTime, [ScheduleDays] = @ScheduleDays WHERE [ID] = @ID"
                OnInserted="dsSingleSchedule_Inserted"
                OnInserting="dsSingleSchedule_Inserting"
                OnUpdating="dsSingleSchedule_Updating"
                OnUpdated="dsSingleSchedule_Updated">
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="ReportView" Type="String" />
                    <asp:Parameter Name="MailTo" Type="String" />
                    <asp:Parameter Name="MailSubject" Type="String" />
                    <asp:Parameter Name="ScheduleTime" Type="Byte" />
                    <asp:Parameter Name="ScheduleDays" Type="Byte" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdSchedule" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="ReportView" Type="String" />
                    <asp:Parameter Name="MailTo" Type="String" />
                    <asp:Parameter Name="MailSubject" Type="String" />
                    <asp:Parameter Name="ScheduleTime" Type="Byte" />
                    <asp:Parameter Name="ScheduleDays" Type="Byte" />
                    <asp:Parameter Name="ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="dsViews" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT name FROM sys.views WHERE LEFT(name, 8) = 'vwReport' ORDER BY name"></asp:SqlDataSource>

            <asp:GridView ID="grdSchedule" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="dsAllScheduleReports"
                PageSize="15" OnSelectedIndexChanged="grdSchedule_SelectedIndexChanged"
                OnRowDataBound="grdSchedule_RowDataBound"
                CssClass="Grid" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <AlternatingRowStyle CssClass="GridAlt"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" SortExpression="ID" InsertVisible="False" ReadOnly="True" Visible="False" meta:resourcekey="BoundFieldResource0" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" meta:resourcekey="BoundFieldResource1" />
                    <asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" SortExpression="Enabled" meta:resourcekey="CheckBoxFieldResource0" />
                    <asp:BoundField DataField="ReportView" HeaderText="ReportView" SortExpression="ReportView" meta:resourcekey="BoundFieldResource2" />
                </Columns>
                <EmptyDataTemplate>
                    <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">No alerts present.</asp:Literal>
                </EmptyDataTemplate>
                <HeaderStyle CssClass="GridHdr"></HeaderStyle>
                <PagerStyle CssClass="GridPgr"></PagerStyle>
            </asp:GridView>

            <asp:FormView ID="fvwSchedule" runat="server"
                DataKeyNames="ID"
                DataSourceID="dsSingleSchedule"
                OnItemDeleted="fvwSchedule_ItemDeleted" Width="677px">
                <EditItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtEditName" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkEditEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Report view:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlEditReportView" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsViews"
                                    DataValueField="name"
                                    DataTextField="name"
                                    SelectedValue='<%# Bind("ReportView") %>'>
                                </asp:DropDownList>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Mail to:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtEditMailTo" runat="server" Text='<%# Bind("MailTo") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Mail subject:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtEditMailSubject" runat="server" Text='<%# Bind("MailSubject") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Scheduled at:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlEditScheduleTime" runat="server" SelectedValue='<%# Bind("ScheduleTime") %>'>
                                    <asp:ListItem Value="0" meta:resourcekey="ListItemResource1">0</asp:ListItem>
                                    <asp:ListItem Value="1" meta:resourcekey="ListItemResource2">1</asp:ListItem>
                                    <asp:ListItem Value="2" meta:resourcekey="ListItemResource3">2</asp:ListItem>
                                    <asp:ListItem Value="3" meta:resourcekey="ListItemResource4">3</asp:ListItem>
                                    <asp:ListItem Value="4" meta:resourcekey="ListItemResource5">4</asp:ListItem>
                                    <asp:ListItem Value="5" meta:resourcekey="ListItemResource6">5</asp:ListItem>
                                    <asp:ListItem Value="6" meta:resourcekey="ListItemResource7">6</asp:ListItem>
                                    <asp:ListItem Value="7" meta:resourcekey="ListItemResource8">7</asp:ListItem>
                                    <asp:ListItem Value="8" meta:resourcekey="ListItemResource9">8</asp:ListItem>
                                    <asp:ListItem Value="9" meta:resourcekey="ListItemResource10">9</asp:ListItem>
                                    <asp:ListItem Value="10" meta:resourcekey="ListItemResource11">10</asp:ListItem>
                                    <asp:ListItem Value="11" meta:resourcekey="ListItemResource12">11</asp:ListItem>
                                    <asp:ListItem Value="12" meta:resourcekey="ListItemResource13">12</asp:ListItem>
                                    <asp:ListItem Value="13" meta:resourcekey="ListItemResource14">13</asp:ListItem>
                                    <asp:ListItem Value="14" meta:resourcekey="ListItemResource15">14</asp:ListItem>
                                    <asp:ListItem Value="15" meta:resourcekey="ListItemResource16">15</asp:ListItem>
                                    <asp:ListItem Value="16" meta:resourcekey="ListItemResource17">16</asp:ListItem>
                                    <asp:ListItem Value="17" meta:resourcekey="ListItemResource18">17</asp:ListItem>
                                    <asp:ListItem Value="18" meta:resourcekey="ListItemResource19">18</asp:ListItem>
                                    <asp:ListItem Value="19" meta:resourcekey="ListItemResource20">19</asp:ListItem>
                                    <asp:ListItem Value="20" meta:resourcekey="ListItemResource21">20</asp:ListItem>
                                    <asp:ListItem Value="21" meta:resourcekey="ListItemResource22">21</asp:ListItem>
                                    <asp:ListItem Value="22" meta:resourcekey="ListItemResource23">22</asp:ListItem>
                                    <asp:ListItem Value="23" meta:resourcekey="ListItemResource24">23</asp:ListItem>
                                </asp:DropDownList>
                                <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Hour</asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Schedule on:</asp:Literal></td>
                            <td>
                                <asp:HiddenField ID="hdnEditScheduleDays" runat="server" Value='<%# Bind("ScheduleDays") %>' />
                                <asp:CheckBox ID="chkEditFlagSunday" runat="server" Text="Sunday" meta:resourcekey="chkEditFlagSunday" /><br />
                                <asp:CheckBox ID="chkEditFlagMonday" runat="server" Text="Monday" meta:resourcekey="chkEditFlagMonday" /><br />
                                <asp:CheckBox ID="chkEditFlagTuesday" runat="server" Text="Tuesday" meta:resourcekey="chkEditFlagTuesday" /><br />
                                <asp:CheckBox ID="chkEditFlagWednesday" runat="server" Text="Wednesday" meta:resourcekey="chkEditFlagWednesday" /><br />
                                <asp:CheckBox ID="chkEditFlagThursday" runat="server" Text="Thursday" meta:resourcekey="chkEditFlagThursday" /><br />
                                <asp:CheckBox ID="chkEditFlagFriday" runat="server" Text="Friday" meta:resourcekey="chkEditFlagFriday" /><br />
                                <asp:CheckBox ID="chkEditFlagSaturday" runat="server" Text="Saturday" meta:resourcekey="chkEditFlagSaturday" /><br />
                            </td>
                        </tr>
                    </table>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtAddName" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkAddEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">Report view:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlAddReportView" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsViews"
                                    DataValueField="name"
                                    DataTextField="name"
                                    SelectedValue='<%# Bind("ReportView") %>'>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">Mail to:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtAddMailTo" runat="server" Text='<%# Bind("MailTo") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">Mail subject:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtAddMailSubject" runat="server" Text='<%# Bind("MailSubject") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">Scheduled at:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlAddScheduleTime" runat="server" SelectedValue='<%# Bind("ScheduleTime") %>'>
                                    <asp:ListItem Value="0" Selected="True" meta:resourcekey="ListItemResource26">0</asp:ListItem>
                                    <asp:ListItem Value="1" meta:resourcekey="ListItemResource27">1</asp:ListItem>
                                    <asp:ListItem Value="2" meta:resourcekey="ListItemResource28">2</asp:ListItem>
                                    <asp:ListItem Value="3" meta:resourcekey="ListItemResource29">3</asp:ListItem>
                                    <asp:ListItem Value="4" meta:resourcekey="ListItemResource30">4</asp:ListItem>
                                    <asp:ListItem Value="5" meta:resourcekey="ListItemResource31">5</asp:ListItem>
                                    <asp:ListItem Value="6" meta:resourcekey="ListItemResource32">6</asp:ListItem>
                                    <asp:ListItem Value="7" meta:resourcekey="ListItemResource33">7</asp:ListItem>
                                    <asp:ListItem Value="8" meta:resourcekey="ListItemResource34">8</asp:ListItem>
                                    <asp:ListItem Value="9" meta:resourcekey="ListItemResource35">9</asp:ListItem>
                                    <asp:ListItem Value="10" meta:resourcekey="ListItemResource36">10</asp:ListItem>
                                    <asp:ListItem Value="11" meta:resourcekey="ListItemResource37">11</asp:ListItem>
                                    <asp:ListItem Value="12" meta:resourcekey="ListItemResource38">12</asp:ListItem>
                                    <asp:ListItem Value="13" meta:resourcekey="ListItemResource39">13</asp:ListItem>
                                    <asp:ListItem Value="14" meta:resourcekey="ListItemResource40">14</asp:ListItem>
                                    <asp:ListItem Value="15" meta:resourcekey="ListItemResource41">15</asp:ListItem>
                                    <asp:ListItem Value="16" meta:resourcekey="ListItemResource42">16</asp:ListItem>
                                    <asp:ListItem Value="17" meta:resourcekey="ListItemResource43">17</asp:ListItem>
                                    <asp:ListItem Value="18" meta:resourcekey="ListItemResource44">18</asp:ListItem>
                                    <asp:ListItem Value="19" meta:resourcekey="ListItemResource45">19</asp:ListItem>
                                    <asp:ListItem Value="20" meta:resourcekey="ListItemResource46">20</asp:ListItem>
                                    <asp:ListItem Value="21" meta:resourcekey="ListItemResource47">21</asp:ListItem>
                                    <asp:ListItem Value="22" meta:resourcekey="ListItemResource48">22</asp:ListItem>
                                    <asp:ListItem Value="23" meta:resourcekey="ListItemResource49">23</asp:ListItem>
                                </asp:DropDownList>
                                <asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">Hour</asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">Schedule on:</asp:Literal></td>
                            <td>
                                <asp:HiddenField ID="hdnAddScheduleDays" runat="server" Value='<%# Bind("ScheduleDays") %>' />
                                <asp:CheckBox ID="chkAddFlagSunday" runat="server" Text="Sunday" Checked="true" meta:resourcekey="chkAddFlagSunday" /><br />
                                <asp:CheckBox ID="chkAddFlagMonday" runat="server" Text="Monday" Checked="true" meta:resourcekey="chkAddFlagMonday" /><br />
                                <asp:CheckBox ID="chkAddFlagTuesday" runat="server" Text="Tuesday" Checked="true" meta:resourcekey="chkAddFlagTuesday" /><br />
                                <asp:CheckBox ID="chkAddFlagWednesday" runat="server" Text="Wednesday" Checked="true" meta:resourcekey="chkAddFlagWednesday" /><br />
                                <asp:CheckBox ID="chkAddFlagThursday" runat="server" Text="Thursday" Checked="true" meta:resourcekey="chkAddFlagThursday" /><br />
                                <asp:CheckBox ID="chkAddFlagFriday" runat="server" Text="Friday" Checked="true" meta:resourcekey="chkAddFlagFriday" /><br />
                                <asp:CheckBox ID="chkAddFlagSaturday" runat="server" Text="Saturday" Checked="true" meta:resourcekey="chkAddFlagSaturday" /><br />
                            </td>
                        </tr>
                    </table>

                </InsertItemTemplate>
                <ItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">Name:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblViewName" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkViewEnabled" runat="server" Checked='<%# Bind("Enabled") %>' Enabled="false" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">Report view:</asp:Literal></td>
                            <td>
                                <asp:Label ID="ReportViewLabel" runat="server" Text='<%# Bind("ReportView") %>' />
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">Mail to:</asp:Literal></td>
                            <td>
                                <asp:Label ID="MailToLabel" runat="server" Text='<%# Bind("MailTo") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">Mail subject:</asp:Literal></td>
                            <td>
                                <asp:Label ID="MailSubjectLabel" runat="server" Text='<%# Bind("MailSubject") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource22" runat="server" meta:resourcekey="LiteralResource22">Scheduled at:</asp:Literal></td>
                            <td>
                                <asp:Label ID="ScheduleTimeLabel" runat="server" Text='<%# Bind("ScheduleTime") %>' />
                                <asp:Literal ID="LiteralResource23" runat="server" meta:resourcekey="LiteralResource23">Hour</asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource24" runat="server" meta:resourcekey="LiteralResource24">Schedule on:</asp:Literal></td>
                            <td>
                                <asp:HiddenField ID="hdnViewScheduleDays" runat="server" Value='<%# Bind("ScheduleDays") %>' />
                                <asp:CheckBox ID="chkViewFlagSunday" runat="server" Text="Sunday" Enabled="false" meta:resourcekey="chkViewFlagSunday" /><br />
                                <asp:CheckBox ID="chkViewFlagMonday" runat="server" Text="Monday" Enabled="false" meta:resourcekey="chkViewFlagMonday" /><br />
                                <asp:CheckBox ID="chkViewFlagTuesday" runat="server" Text="Tuesday" Enabled="false" meta:resourcekey="chkViewFlagTuesday" /><br />
                                <asp:CheckBox ID="chkViewFlagWednesday" runat="server" Text="Wednesday" Enabled="false" meta:resourcekey="chkViewFlagWednesday" /><br />
                                <asp:CheckBox ID="chkViewFlagThursday" runat="server" Text="Thursday" Enabled="false" meta:resourcekey="chkViewFlagThursday" /><br />
                                <asp:CheckBox ID="chkViewFlagFriday" runat="server" Text="Friday" Enabled="false" meta:resourcekey="chkViewFlagFriday" /><br />
                                <asp:CheckBox ID="chkViewFlagSaturday" runat="server" Text="Saturday" Enabled="false" meta:resourcekey="chkViewFlagSaturday" /><br />
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
            </asp:FormView>
            <br />
            <uc1:EntityControl ID="EntityControl" runat="server" OnClicked="EntityControl_Clicked" />

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
