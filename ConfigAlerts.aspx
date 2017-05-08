<%@ Page
    Title="ConfigAlerts"
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    CodeBehind="ConfigAlerts.aspx.cs"
    Inherits="KCWebManager.ConfigAlerts"
    EnableEventValidation="false" %>

<%@ Register Src="Controls/EntityControl.ascx" TagName="EntityControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">

        var selected_tab = "";

        function InitializeRequestHandler(sender, args) {
            // if it is the delete action, ask for confirmation before actual delete happens
            if (args.get_postBackElement().id == 'btnEntityControlDelete') {
                if (confirm(jq("#resDeleteAlert").text()) == false) {
                    args.set_cancel(true);
                }
            }
        }

        function BeginRequestHandler(sender, args) {
            selected_tab = jq("#tabs").tabs("option", "active");
        }

        function EndRequestHandler(sender, args) {
            if (args.get_error() != undefined) {
                var errorMessage;
                if (args.get_response().get_statusCode() == '200') {
                    errorMessage = args.get_error().message;
                }
                else {
                    // Error occurred somewhere other than the server page.
                    errorMessage = 'An unspecified error occurred. ';
                }
                args.set_errorHandled(true);
                alert(errorMessage);
                location.href = "ConfigAlerts";
            }
            InitializeTabs();
            InitializeSpinners();
        }

        function InitializeTabs() {

            // Getter
            //var active = $(".selector").tabs("option", "active");
            // Setter
            //$(".selector").tabs("option", "active", 1);

            jq(function () {
                var tabs = jq("#tabs").tabs({
                    select: function (e, i) {
                        selected_tab = i.index;
                    }
                });
                if (selected_tab != "") {
                    jq("#tabs").tabs("option", "active", selected_tab);
                }

                jq("form").submit(function () {
                    selected_tab = jq("#tabs").tabs("option", "active");
                });
            });
            jq("#tabs").css('width', '100%');
            jq("#tabs").height(450);
        }

        function InitializeSpinners() {
            jq('#txtEditOrder').spinner({ min: 0 });
            jq('#txtAddOrder').spinner({ min: 0 });
        }

        jq(document).ready(function () {
            InitializeTabs();
            InitializeSpinners();


        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_initializeRequest(InitializeRequestHandler)
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
    </script>
    <div class="Hidden">
        <asp:Label ID="resDeleteAlert" ClientIDMode="Static" Text="Are you sure you want to delete this alert?" runat="server" meta:resourcekey="resDeleteAlert" />
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:SqlDataSource ID="dsAllAlerts" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT [ID], [Name], [Enabled], [Order] FROM [AlertFilter] ORDER BY [Order]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="dsSingleAlert" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT * FROM [AlertFilter] WHERE ([ID] = @ID)"
                DeleteCommand="DELETE FROM [AlertFilter] WHERE [ID] = @ID"
                InsertCommand="
            INSERT INTO [AlertFilter] 
                   ([Name], [Enabled], [Order], [UserID], [KeyConductorID], [KeyCopID], [KCEventType], [TimeFrom], [TimeTo], [ActiveFlag], [InactiveUser], [InactiveKeyCop], [MailSubject], [MailTo], [MailToUser], [MailTemplate], [AlertLevel], [GroupID], [ScriptEval]) 
            VALUES (@Name,  @Enabled,  @Order,  @UserID,  @KeyConductorID,  @KeyCopID,  @KCEventType,  @TimeFrom,  @TimeTo,  @ActiveFlag,  @InactiveUser,  @InactiveKeyCop,  @MailSubject,  @MailTo,  @MailToUser,  @MailTemplate,  @AlertLevel,  @GroupID,  @ScriptEval)"
                UpdateCommand="UPDATE [AlertFilter] SET 
                [Name] = @Name, [Enabled] = @Enabled, [Order] = @Order, [UserID] = @UserID, [KeyConductorID] = @KeyConductorID, [KeyCopID] = @KeyCopID, [KCEventType] = @KCEventType, [TimeFrom] = @TimeFrom, [TimeTo] = @TimeTo, 
                [ActiveFlag] = @ActiveFlag, [InactiveUser] = @InactiveUser, [InactiveKeyCop] = @InactiveKeyCop, [MailSubject] = @MailSubject, [MailTo] = @MailTo, [MailToUser] = @MailToUser, [MailTemplate] = @MailTemplate, 
                [AlertLevel] = @AlertLevel, [GroupID] = @GroupID, [ScriptEval] = @ScriptEval WHERE [ID] = @ID"
                OnInserted="dsSingleAlert_Inserted" OnInserting="dsSingleAlert_Inserting" OnUpdating="dsSingleAlert_Updating">
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="Order" Type="Int32" />
                    <asp:Parameter Name="UserID" Type="Int32" />
                    <asp:Parameter Name="KeyConductorID" Type="Int32" />
                    <asp:Parameter Name="KeyCopID" Type="Int32" />
                    <asp:Parameter Name="KCEventType" Type="Byte" />
                    <asp:Parameter Name="TimeFrom" Type="Byte" />
                    <asp:Parameter Name="TimeTo" Type="Byte" />
                    <asp:Parameter Name="ActiveFlag" Type="Byte" />
                    <asp:Parameter Name="InactiveUser" Type="Boolean" />
                    <asp:Parameter Name="InactiveKeyCop" Type="Boolean" />
                    <asp:Parameter Name="MailSubject" Type="String" />
                    <asp:Parameter Name="MailTo" Type="String" />
                    <asp:Parameter Name="MailToUser" Type="Boolean" />
                    <asp:Parameter Name="MailTemplate" Type="String" />
                    <asp:Parameter Name="AlertLevel" Type="Byte" />
                    <asp:Parameter Name="GroupID" Type="Int32" />
                    <asp:Parameter Name="ScriptEval" Type="String" />

                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdAlerts" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="Order" Type="Int32" />
                    <asp:Parameter Name="UserID" Type="Int32" />
                    <asp:Parameter Name="KeyConductorID" Type="Int32" />
                    <asp:Parameter Name="KeyCopID" Type="Int32" />
                    <asp:Parameter Name="KCEventType" Type="Byte" />
                    <asp:Parameter Name="TimeFrom" Type="Byte" />
                    <asp:Parameter Name="TimeTo" Type="Byte" />
                    <asp:Parameter Name="ActiveFlag" Type="Byte" />
                    <asp:Parameter Name="InactiveUser" Type="Boolean" />
                    <asp:Parameter Name="InactiveKeyCop" Type="Boolean" />
                    <asp:Parameter Name="MailSubject" Type="String" />
                    <asp:Parameter Name="MailTo" Type="String" />
                    <asp:Parameter Name="MailToUser" Type="Boolean" />
                    <asp:Parameter Name="MailTemplate" Type="String" />
                    <asp:Parameter Name="AlertLevel" Type="Byte" />
                    <asp:Parameter Name="GroupID" Type="Int32" />
                    <asp:Parameter Name="ScriptEval" Type="String" />
                    <asp:Parameter Name="ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>



            <asp:GridView ID="grdAlerts" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="dsAllAlerts"
                PageSize="15" OnSelectedIndexChanged="grdAlerts_SelectedIndexChanged"
                OnRowDataBound="grdAlerts_RowDataBound"
                CssClass="Grid configAlerts" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <AlternatingRowStyle CssClass="GridAlt"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" meta:resourcekey="BoundFieldResource0" />
                    <asp:BoundField DataField="Enabled" HeaderText="Enabled" SortExpression="Enabled" meta:resourcekey="BoundFieldResource1" />
                    <asp:BoundField DataField="Order" HeaderText="Order" SortExpression="Order" meta:resourcekey="BoundFieldResource2" />
                </Columns>
                <EmptyDataTemplate CssClass="configAlerts">
                    <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">No alerts present.</asp:Literal>
                </EmptyDataTemplate>
                <HeaderStyle CssClass="GridHdr"></HeaderStyle>
                <PagerStyle CssClass="GridPgr"></PagerStyle>
            </asp:GridView>

            <asp:FormView ID="fvwAlert" runat="server" DataKeyNames="ID" DataSourceID="dsSingleAlert" OnItemDeleted="fvwAlert_ItemDeleted">
                <EditItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtEditName" runat="server" Text='<%# Bind("Name") %>' MaxLength="50" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Order:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtEditOrder" ClientIDMode="Static" runat="server" Text='<%# Bind("Order") %>' />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtEditOrderExt" runat="server" TargetControlID="txtEditOrder" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkEditEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>

                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Filter</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Timerange</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Mail</asp:Literal></a></li>
                            <li><a href="#tabs-4">
                                <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Log</asp:Literal></a></li>
                            <!--<li><a href="#tabs-5">Custom filter</a></li>-->
                        </ul>
                        <div id="tabs-1">
                            <!-- Filter -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">User:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsEditUsers" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Username] FROM [User] ORDER BY [Username]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlEditUser" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsEditUsers"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Username"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("UserID") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource0">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Group:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsEditGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Name] 
                                                   FROM [Group] ORDER BY [Name]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlEditGroup" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsEditGroups"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("GroupID") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource139">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">KeyCop:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsEditKeyCops" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], ([KeyLabel] + ' - ' + [Description]) AS [Name] 
                                                   FROM [KeyChain] ORDER BY [KeyLabel]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlEditKeyCops" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsEditKeyCops"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("KeyCopID") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource1">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource53" runat="server" meta:resourcekey="LiteralResource53">KeyConductor:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsEditKeyConductors" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Name] FROM [KeyConductor]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlEditKeyConductor" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsEditKeyConductors"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("KeyConductorID") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource2">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">Event type:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsEditKCEventTypes" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [KCEventType], [Name] FROM [KCEventType]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlEditKCEventType" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsEditKCEventTypes"
                                            DataValueField="KCEventType"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("KCEventType") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource3">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-2">
                            <!-- time criteria / other -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">Days:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnEditActiveFlag" runat="server"
                                            Value='<%# Bind("ActiveFlag") %>' />
                                        <asp:CheckBox ID="chkEditFlagSunday" runat="server" Text="Sunday" meta:resourcekey="chkEditFlagSunday" /><br />
                                        <asp:CheckBox ID="chkEditFlagMonday" runat="server" Text="Monday" meta:resourcekey="chkEditFlagMonday" /><br />
                                        <asp:CheckBox ID="chkEditFlagTuesday" runat="server" Text="Tuesday" meta:resourcekey="chkEditFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkEditFlagWednesday" runat="server" Text="Wednesday" meta:resourcekey="chkEditFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkEditFlagThursday" runat="server" Text="Thursday" meta:resourcekey="chkEditFlagThursday" /><br />
                                        <asp:CheckBox ID="chkEditFlagFriday" runat="server" Text="Friday" meta:resourcekey="chkEditFlagFriday" /><br />
                                        <asp:CheckBox ID="chkEditFlagSaturday" runat="server" Text="Saturday" meta:resourcekey="chkEditFlagSaturday" /><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">Time from:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="TimeFromLabel" runat="server" Text='<%# Bind("TimeFrom") %>' />
                                        <asp:DropDownList ID="ddlEditTimeFrom" runat="server"
                                            SelectedValue='<%# Bind("TimeFrom") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource4">Not specified</asp:ListItem>
                                            <asp:ListItem Value="0" meta:resourcekey="ListItemResource5">0</asp:ListItem>
                                            <asp:ListItem Value="1" meta:resourcekey="ListItemResource6">1</asp:ListItem>
                                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource7">2</asp:ListItem>
                                            <asp:ListItem Value="3" meta:resourcekey="ListItemResource8">3</asp:ListItem>
                                            <asp:ListItem Value="4" meta:resourcekey="ListItemResource9">4</asp:ListItem>
                                            <asp:ListItem Value="5" meta:resourcekey="ListItemResource10">5</asp:ListItem>
                                            <asp:ListItem Value="6" meta:resourcekey="ListItemResource11">6</asp:ListItem>
                                            <asp:ListItem Value="7" meta:resourcekey="ListItemResource12">7</asp:ListItem>
                                            <asp:ListItem Value="8" meta:resourcekey="ListItemResource13">8</asp:ListItem>
                                            <asp:ListItem Value="9" meta:resourcekey="ListItemResource14">9</asp:ListItem>
                                            <asp:ListItem Value="10" meta:resourcekey="ListItemResource15">10</asp:ListItem>
                                            <asp:ListItem Value="11" meta:resourcekey="ListItemResource16">11</asp:ListItem>
                                            <asp:ListItem Value="12" meta:resourcekey="ListItemResource17">12</asp:ListItem>
                                            <asp:ListItem Value="13" meta:resourcekey="ListItemResource18">13</asp:ListItem>
                                            <asp:ListItem Value="14" meta:resourcekey="ListItemResource19">14</asp:ListItem>
                                            <asp:ListItem Value="15" meta:resourcekey="ListItemResource20">15</asp:ListItem>
                                            <asp:ListItem Value="16" meta:resourcekey="ListItemResource21">16</asp:ListItem>
                                            <asp:ListItem Value="17" meta:resourcekey="ListItemResource22">17</asp:ListItem>
                                            <asp:ListItem Value="18" meta:resourcekey="ListItemResource23">18</asp:ListItem>
                                            <asp:ListItem Value="19" meta:resourcekey="ListItemResource24">19</asp:ListItem>
                                            <asp:ListItem Value="20" meta:resourcekey="ListItemResource25">20</asp:ListItem>
                                            <asp:ListItem Value="21" meta:resourcekey="ListItemResource26">21</asp:ListItem>
                                            <asp:ListItem Value="22" meta:resourcekey="ListItemResource27">22</asp:ListItem>
                                            <asp:ListItem Value="23" meta:resourcekey="ListItemResource28">23</asp:ListItem>
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">Time to:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="TimeToLabel" runat="server" Text='<%# Bind("TimeTo") %>' />
                                        <asp:DropDownList ID="ddlEditTimeTo" runat="server"
                                            SelectedValue='<%# Bind("TimeTo") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource29">Not specified</asp:ListItem>
                                            <asp:ListItem Value="0" meta:resourcekey="ListItemResource30">0</asp:ListItem>
                                            <asp:ListItem Value="1" meta:resourcekey="ListItemResource31">1</asp:ListItem>
                                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource32">2</asp:ListItem>
                                            <asp:ListItem Value="3" meta:resourcekey="ListItemResource33">3</asp:ListItem>
                                            <asp:ListItem Value="4" meta:resourcekey="ListItemResource34">4</asp:ListItem>
                                            <asp:ListItem Value="5" meta:resourcekey="ListItemResource35">5</asp:ListItem>
                                            <asp:ListItem Value="6" meta:resourcekey="ListItemResource36">6</asp:ListItem>
                                            <asp:ListItem Value="7" meta:resourcekey="ListItemResource37">7</asp:ListItem>
                                            <asp:ListItem Value="8" meta:resourcekey="ListItemResource38">8</asp:ListItem>
                                            <asp:ListItem Value="9" meta:resourcekey="ListItemResource39">9</asp:ListItem>
                                            <asp:ListItem Value="10" meta:resourcekey="ListItemResource40">10</asp:ListItem>
                                            <asp:ListItem Value="11" meta:resourcekey="ListItemResource41">11</asp:ListItem>
                                            <asp:ListItem Value="12" meta:resourcekey="ListItemResource42">12</asp:ListItem>
                                            <asp:ListItem Value="13" meta:resourcekey="ListItemResource43">13</asp:ListItem>
                                            <asp:ListItem Value="14" meta:resourcekey="ListItemResource44">14</asp:ListItem>
                                            <asp:ListItem Value="15" meta:resourcekey="ListItemResource45">15</asp:ListItem>
                                            <asp:ListItem Value="16" meta:resourcekey="ListItemResource46">16</asp:ListItem>
                                            <asp:ListItem Value="17" meta:resourcekey="ListItemResource47">17</asp:ListItem>
                                            <asp:ListItem Value="18" meta:resourcekey="ListItemResource48">18</asp:ListItem>
                                            <asp:ListItem Value="19" meta:resourcekey="ListItemResource49">19</asp:ListItem>
                                            <asp:ListItem Value="20" meta:resourcekey="ListItemResource50">20</asp:ListItem>
                                            <asp:ListItem Value="21" meta:resourcekey="ListItemResource51">21</asp:ListItem>
                                            <asp:ListItem Value="22" meta:resourcekey="ListItemResource52">22</asp:ListItem>
                                            <asp:ListItem Value="23" meta:resourcekey="ListItemResource53">23</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">Inactive user:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlEditInactiveUser" runat="server"
                                            SelectedValue='<%# Bind("InactiveUser") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource54">Not specified</asp:ListItem>
                                            <asp:ListItem Value="False" meta:resourcekey="ListItemResource55">False</asp:ListItem>
                                            <asp:ListItem Value="True" meta:resourcekey="ListItemResource56">True</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">Inactive KeyCop:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlEditInactiveKeyCop" runat="server"
                                            SelectedValue='<%# Bind("InactiveKeyCop") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource57">Not specified</asp:ListItem>
                                            <asp:ListItem Value="False" meta:resourcekey="ListItemResource58">False</asp:ListItem>
                                            <asp:ListItem Value="True" meta:resourcekey="ListItemResource59">True</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-3">
                            <!-- mail -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">To:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtEditMailTo" runat="server" 
                                            Text='<%# Bind("MailTo") %>' 
                                            MaxLength="150" />
                                        <br />
                                        <asp:CheckBox ID="chkEditMailToUser" runat="server" 
                                            Checked='<%# Bind("MailToUser") %>' 
                                            Text="Send mail to user based on User.EMail1" 
                                            meta:resourcekey="chkEditMailToUser" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">Subject:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtEditMailSubject" runat="server" 
                                            Text='<%# Bind("MailSubject") %>' MaxLength="150" />
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">Body:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtEditMailTemplate" runat="server" 
                                            Text='<%# Bind("MailTemplate") %>' 
                                            TextMode="MultiLine" 
                                            Width="300px" Height="300px" />
                                    </td>
                                </tr>

                            </table>
                        </div>
                        <div id="tabs-4">
                            <!-- log -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">Log level:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlAlertLevel" runat="server" 
                                            SelectedValue='<%# Bind("AlertLevel") %>'>
                                            <asp:ListItem Value="0" meta:resourcekey="ListItemResource60">0 - Info (default)</asp:ListItem>
                                            <asp:ListItem Value="1" meta:resourcekey="ListItemResource61">1 - Warning</asp:ListItem>
                                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource62">2 - Error</asp:ListItem>
                                        </asp:DropDownList>

                                        <br />
                                        <asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">When a log entry matches an alert it will be stored with a log level. In normal situations this will be level 0/Info.</asp:Literal>

                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-5" class="Hidden">
                            Custom filter (ScriptEval, under development):<br />
                            <asp:TextBox ID="txtAddScriptEval" runat="server" 
                                Text='<%# Bind("ScriptEval") %>' 
                                TextMode="MultiLine" 
                                Width="600px" Height="350px"></asp:TextBox>
                        </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource22" runat="server" meta:resourcekey="LiteralResource22">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtAddName" runat="server" Text='<%# Bind("Name") %>' MaxLength="50" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource23" runat="server" meta:resourcekey="LiteralResource23">Order:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtAddOrder" ClientIDMode="Static" runat="server" 
                                    Text='<%# Bind("Order") %>' />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtAddOrderExt" runat="server" TargetControlID="txtAddOrder" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource24" runat="server" meta:resourcekey="LiteralResource24">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkAddEnabled" runat="server" 
                                    Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>

                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <asp:Literal ID="LiteralResource25" runat="server" meta:resourcekey="LiteralResource25">Filter</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <asp:Literal ID="LiteralResource26" runat="server" meta:resourcekey="LiteralResource26">Timerange</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <asp:Literal ID="LiteralResource27" runat="server" meta:resourcekey="LiteralResource27">Mail</asp:Literal></a></li>
                            <li><a href="#tabs-4">
                                <asp:Literal ID="LiteralResource28" runat="server" meta:resourcekey="LiteralResource28">Log</asp:Literal></a></li>
                            <!--<li><a href="#tabs-5">Custom filter</a></li>-->
                        </ul>
                        <div id="tabs-1">
                            <!-- Filter -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource29" runat="server" meta:resourcekey="LiteralResource29">User:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsAddUsers" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Username] FROM [User] ORDER BY [Username]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlAddUser" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsAddUsers"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Username"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("UserID") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource63">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource66" runat="server" meta:resourcekey="LiteralResource66">Group:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsAddGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Name] 
                                                   FROM [Group] ORDER BY [Name]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlAddGroup" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsAddGroups"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("GroupID") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource140">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource30" runat="server" meta:resourcekey="LiteralResource30">KeyCop:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsAddKeyCops" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], ([KeyLabel] + ' - ' + [Description]) AS [Name] 
                                                   FROM [KeyChain] ORDER BY [KeyLabel]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlAddKeyCops" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsAddKeyCops"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("KeyCopID") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource64">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource31" runat="server" meta:resourcekey="LiteralResource31">KeyConductor:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsAddKeyConductors" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Name] FROM [KeyConductor]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlAddKeyConductor" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsAddKeyConductors"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("KeyConductorID") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource65">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource32" runat="server" meta:resourcekey="LiteralResource32">Event type:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsAddKCEventTypes" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [KCEventType], [Name] FROM [KCEventType]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlAddKCEventType" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsAddKCEventTypes"
                                            DataValueField="KCEventType"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            OnDataBinding="PreventErrorOnbinding"
                                            SelectedValue='<%# Bind("KCEventType") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource66">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-2">
                            <!-- time criteria / other -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource33" runat="server" meta:resourcekey="LiteralResource33">Days:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnAddActiveFlag" runat="server" 
                                            Value='<%# Bind("ActiveFlag") %>' />
                                        <asp:CheckBox ID="chkAddFlagSunday" runat="server" Text="Sunday" Checked="true" meta:resourcekey="chkAddFlagSunday" /><br />
                                        <asp:CheckBox ID="chkAddFlagMonday" runat="server" Text="Monday" Checked="true" meta:resourcekey="chkAddFlagMonday" /><br />
                                        <asp:CheckBox ID="chkAddFlagTuesday" runat="server" Text="Tuesday" Checked="true" meta:resourcekey="chkAddFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkAddFlagWednesday" runat="server" Text="Wednesday" Checked="true" meta:resourcekey="chkAddFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkAddFlagThursday" runat="server" Text="Thursday" Checked="true" meta:resourcekey="chkAddFlagThursday" /><br />
                                        <asp:CheckBox ID="chkAddFlagFriday" runat="server" Text="Friday" Checked="true" meta:resourcekey="chkAddFlagFriday" /><br />
                                        <asp:CheckBox ID="chkAddFlagSaturday" runat="server" Text="Saturday" Checked="true" meta:resourcekey="chkAddFlagSaturday" /><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource34" runat="server" meta:resourcekey="LiteralResource34">Time from:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlAddTimeFrom" runat="server" 
                                            SelectedValue='<%# Bind("TimeFrom") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource67">Not specified</asp:ListItem>
                                            <asp:ListItem Value="0" meta:resourcekey="ListItemResource68">0</asp:ListItem>
                                            <asp:ListItem Value="1" meta:resourcekey="ListItemResource69">1</asp:ListItem>
                                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource70">2</asp:ListItem>
                                            <asp:ListItem Value="3" meta:resourcekey="ListItemResource71">3</asp:ListItem>
                                            <asp:ListItem Value="4" meta:resourcekey="ListItemResource72">4</asp:ListItem>
                                            <asp:ListItem Value="5" meta:resourcekey="ListItemResource73">5</asp:ListItem>
                                            <asp:ListItem Value="6" meta:resourcekey="ListItemResource74">6</asp:ListItem>
                                            <asp:ListItem Value="7" meta:resourcekey="ListItemResource75">7</asp:ListItem>
                                            <asp:ListItem Value="8" meta:resourcekey="ListItemResource76">8</asp:ListItem>
                                            <asp:ListItem Value="9" meta:resourcekey="ListItemResource77">9</asp:ListItem>
                                            <asp:ListItem Value="10" meta:resourcekey="ListItemResource78">10</asp:ListItem>
                                            <asp:ListItem Value="11" meta:resourcekey="ListItemResource79">11</asp:ListItem>
                                            <asp:ListItem Value="12" meta:resourcekey="ListItemResource80">12</asp:ListItem>
                                            <asp:ListItem Value="13" meta:resourcekey="ListItemResource81">13</asp:ListItem>
                                            <asp:ListItem Value="14" meta:resourcekey="ListItemResource82">14</asp:ListItem>
                                            <asp:ListItem Value="15" meta:resourcekey="ListItemResource83">15</asp:ListItem>
                                            <asp:ListItem Value="16" meta:resourcekey="ListItemResource84">16</asp:ListItem>
                                            <asp:ListItem Value="17" meta:resourcekey="ListItemResource85">17</asp:ListItem>
                                            <asp:ListItem Value="18" meta:resourcekey="ListItemResource86">18</asp:ListItem>
                                            <asp:ListItem Value="19" meta:resourcekey="ListItemResource87">19</asp:ListItem>
                                            <asp:ListItem Value="20" meta:resourcekey="ListItemResource88">20</asp:ListItem>
                                            <asp:ListItem Value="21" meta:resourcekey="ListItemResource89">21</asp:ListItem>
                                            <asp:ListItem Value="22" meta:resourcekey="ListItemResource90">22</asp:ListItem>
                                            <asp:ListItem Value="23" meta:resourcekey="ListItemResource91">23</asp:ListItem>
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource35" runat="server" meta:resourcekey="LiteralResource35">Time to:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlAddTimeTo" runat="server" 
                                            SelectedValue='<%# Bind("TimeTo") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource92">Not specified</asp:ListItem>
                                            <asp:ListItem Value="0" meta:resourcekey="ListItemResource93">0</asp:ListItem>
                                            <asp:ListItem Value="1" meta:resourcekey="ListItemResource94">1</asp:ListItem>
                                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource95">2</asp:ListItem>
                                            <asp:ListItem Value="3" meta:resourcekey="ListItemResource96">3</asp:ListItem>
                                            <asp:ListItem Value="4" meta:resourcekey="ListItemResource97">4</asp:ListItem>
                                            <asp:ListItem Value="5" meta:resourcekey="ListItemResource98">5</asp:ListItem>
                                            <asp:ListItem Value="6" meta:resourcekey="ListItemResource99">6</asp:ListItem>
                                            <asp:ListItem Value="7" meta:resourcekey="ListItemResource100">7</asp:ListItem>
                                            <asp:ListItem Value="8" meta:resourcekey="ListItemResource101">8</asp:ListItem>
                                            <asp:ListItem Value="9" meta:resourcekey="ListItemResource102">9</asp:ListItem>
                                            <asp:ListItem Value="10" meta:resourcekey="ListItemResource103">10</asp:ListItem>
                                            <asp:ListItem Value="11" meta:resourcekey="ListItemResource104">11</asp:ListItem>
                                            <asp:ListItem Value="12" meta:resourcekey="ListItemResource105">12</asp:ListItem>
                                            <asp:ListItem Value="13" meta:resourcekey="ListItemResource106">13</asp:ListItem>
                                            <asp:ListItem Value="14" meta:resourcekey="ListItemResource107">14</asp:ListItem>
                                            <asp:ListItem Value="15" meta:resourcekey="ListItemResource108">15</asp:ListItem>
                                            <asp:ListItem Value="16" meta:resourcekey="ListItemResource109">16</asp:ListItem>
                                            <asp:ListItem Value="17" meta:resourcekey="ListItemResource110">17</asp:ListItem>
                                            <asp:ListItem Value="18" meta:resourcekey="ListItemResource111">18</asp:ListItem>
                                            <asp:ListItem Value="19" meta:resourcekey="ListItemResource112">19</asp:ListItem>
                                            <asp:ListItem Value="20" meta:resourcekey="ListItemResource113">20</asp:ListItem>
                                            <asp:ListItem Value="21" meta:resourcekey="ListItemResource114">21</asp:ListItem>
                                            <asp:ListItem Value="22" meta:resourcekey="ListItemResource115">22</asp:ListItem>
                                            <asp:ListItem Value="23" meta:resourcekey="ListItemResource116">23</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource36" runat="server" meta:resourcekey="LiteralResource36">Inactive user:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlAddInactiveUser" runat="server" 
                                            SelectedValue='<%# Bind("InactiveUser") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource117">Not specified</asp:ListItem>
                                            <asp:ListItem Value="False" meta:resourcekey="ListItemResource118">False</asp:ListItem>
                                            <asp:ListItem Value="True" meta:resourcekey="ListItemResource119">True</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource37" runat="server" meta:resourcekey="LiteralResource37">Inactive KeyCop:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlAddInactiveKeyCop" runat="server" 
                                            SelectedValue='<%# Bind("InactiveKeyCop") %>'>
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource120">Not specified</asp:ListItem>
                                            <asp:ListItem Value="False" meta:resourcekey="ListItemResource121">False</asp:ListItem>
                                            <asp:ListItem Value="True" meta:resourcekey="ListItemResource122">True</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-3">
                            <!-- mail -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource38" runat="server" meta:resourcekey="LiteralResource38">To:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtAddMailTo" runat="server" 
                                            Text='<%# Bind("MailTo") %>' 
                                            MaxLength="150" />
                                        <br />
                                        <asp:CheckBox ID="chkAddMailToUser" runat="server" 
                                            Checked='<%# Bind("MailToUser") %>' 
                                            Text="Send mail to user based on User.EMail1" 
                                            meta:resourcekey="chkAddMailToUser" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource39" runat="server" meta:resourcekey="LiteralResource39">Subject:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtAddMailSubject" runat="server" 
                                            Text='<%# Bind("MailSubject") %>' 
                                            MaxLength="150" />
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource40" runat="server" meta:resourcekey="LiteralResource40">Body:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtAddMailTemplate" runat="server" 
                                            Text='<%# Bind("MailTemplate") %>' 
                                            TextMode="MultiLine" 
                                            Width="300px" Height="300px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource41" runat="server" meta:resourcekey="LiteralResource41">Notes:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:Literal ID="LiteralResource42" runat="server" meta:resourcekey="LiteralResource42">Leave subject and template blank to disable sending an e-mail.</asp:Literal>
                                        <br />
                                        <!--
                                <br />                                
                                You can use the following macro's in the subject and the template:
                                <ul>
                                    <li>Generic</li>
                                    <ul>
                                        <li>[DATETIME] - Date and time of the log-entry</li>
                                        <li>[MESSAGE] - Log message</li>
                                        <li>[EVENTTYPE] - Type of event</li>
                                    </ul>
                                    <li>User</li>
                                    <ul>
                                        <li>[USER_ID]</li>
                                        <li>[USER_USERNAME]</li>
                                        <li>[USER_USERID] - Login code of the user</li>
                                        <li>[USER_DESCRIPTION] - Displayname of the user</li>
                                        <li>[USER_STARTTIME] - Time when user can access the KeyConductor</li>
                                        <li>[USER_ENDTIME] - Time until a user can access the KeyConductor</li>
                                        <li>[USER_BEGINCONTRACT]</li>
                                        <li>[USER_ENDCONTRACT]</li>
                                        <li>[USER_PHONENUMBER1]</li>
                                        <li>[USER_PHONENUMBER2]</li>
                                        <li>[USER_EMAIL1]</li>
                                        <li>[USER_EMAIL2]</li>
                                        <li>[USER_ADDRESS]</li>
                                        <li>[USER_POSTALCODE]</li>
                                        <li>[USER_CITY]</li>
                                        <li>[USER_COUNTRY]</li>
                                        <li>[USER_LANGUAGE]</li>
                                        <li>[USER_TITLE]</li>
                                        <li>[USER_FIRSTNAME]</li>
                                        <li>[USER_MIDDLENAME]</li>
                                        <li>[USER_LASTNAME]</li>
                                        <li>[USER_SWIPECARD]</li>
                                    </ul>
                                    <li>KeyCop</li>
                                    <ul>
                                        <li>[KEYCOP] - KeyCop label and description</li>
                                        <li>[KEYCOP_KEYLABEL] - Label of the KeyCop</li>
                                        <li>[KEYCOP_DESCRIPTION] - Description of the KeyCop</li>
                                        <li>[KEYCOP_KEYNUMBER] - Barcode of the KeyCop</li>
                                    </ul>
                                    <li>KeyConductor</li>
                                    <ul>
                                        <li>[KEYCONDUCTOR_KCID] - Serialnumber</li>
                                        <li>[KEYCONDUCTOR_NAME]</li>
                                        <li>[KEYCONDUCTOR_DESCRIPTION]</li>
                                        <li>[KEYCONDUCTOR_HOSTNAME]</li>
                                    </ul>
                                </ul> -->
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-4">
                            <!-- log -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource43" runat="server" meta:resourcekey="LiteralResource43">Log level:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlAddAlertLevel" runat="server" 
                                            SelectedValue='<%# Bind("AlertLevel") %>'>
                                            <asp:ListItem Value="0" meta:resourcekey="ListItemResource123">0 - Info (default)</asp:ListItem>
                                            <asp:ListItem Value="1" meta:resourcekey="ListItemResource124">1 - Warning</asp:ListItem>
                                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource125">2 - Error</asp:ListItem>
                                        </asp:DropDownList>

                                        <br />
                                        <asp:Literal ID="LiteralResource44" runat="server" meta:resourcekey="LiteralResource44">When a log entry matches an alert it will be stored with a log level. In normal situations this will be level 0/Info.</asp:Literal>

                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-5" class="Hidden">
                            Custom filter (ScriptEval, under development):<br />
                            <asp:TextBox ID="txtViewScriptEval" runat="server" 
                                Text='<%# Bind("ScriptEval") %>' 
                                TextMode="MultiLine" Width="600px" Height="350px"></asp:TextBox>
                        </div>
                    </div>

                </InsertItemTemplate>
                <ItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource45" runat="server" meta:resourcekey="LiteralResource45">Name:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblViewName" runat="server" 
                                    Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource46" runat="server" meta:resourcekey="LiteralResource46">Order:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblViewOrder" runat="server" 
                                    Text='<%# Bind("Order") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource47" runat="server" meta:resourcekey="LiteralResource47">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkViewEnabled" runat="server" 
                                    Checked='<%# Bind("Enabled") %>' 
                                    Enabled="false" /></td>
                        </tr>

                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <asp:Literal ID="LiteralResource48" runat="server" meta:resourcekey="LiteralResource48">Filter</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <asp:Literal ID="LiteralResource49" runat="server" meta:resourcekey="LiteralResource49">Timerange</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <asp:Literal ID="LiteralResource50" runat="server" meta:resourcekey="LiteralResource50">Mail</asp:Literal></a></li>
                            <li><a href="#tabs-4">
                                <asp:Literal ID="Literal1" runat="server" meta:resourcekey="LiteralResource51">Log</asp:Literal></a></li>
                            <!--<li><a href="#tabs-5">Custom filter</a></li>-->
                        </ul>
                        <div id="tabs-1">
                            <!-- Filter -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource52" runat="server" meta:resourcekey="LiteralResource52">User:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsViewUsers" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Username] FROM [User] ORDER BY [Username]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlViewUser" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsViewUsers"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Username"
                                            SelectedValue='<%# Bind("UserID") %>'
                                            OnDataBinding="PreventErrorOnbinding"
                                            Enabled="false">
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource126">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource68" runat="server" meta:resourcekey="LiteralResource68">Group:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsViewGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Name] 
                                                   FROM [Group] ORDER BY [Name]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlViewGroup" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsViewGroups"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            SelectedValue='<%# Bind("GroupID") %>'
                                            OnDataBinding="PreventErrorOnbinding"
                                            Enabled="false">
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource141">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource69" runat="server" meta:resourcekey="LiteralResource69">KeyCop:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsViewKeyCops" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], ([KeyLabel] + ' - ' + [Description]) AS [Name] 
                                                   FROM [KeyChain] ORDER BY [KeyLabel]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlViewKeyCops" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsViewKeyCops"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            SelectedValue='<%# Bind("KeyCopID") %>'
                                            OnDataBinding="PreventErrorOnbinding"
                                            Enabled="false">
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource127">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource70" runat="server" meta:resourcekey="LiteralResource70">KeyConductor:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsViewKeyConductors" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [ID], [Name] FROM [KeyConductor]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlViewKeyConductor" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsViewKeyConductors"
                                            DataValueField="ID"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            SelectedValue='<%# Bind("KeyConductorID") %>'
                                            OnDataBinding="PreventErrorOnbinding"
                                            Enabled="false">
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource128">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource55" runat="server" meta:resourcekey="LiteralResource55">Event type:</asp:Literal></td>
                                    <td>
                                        <asp:SqlDataSource ID="dsViewKCEventTypes" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                            SelectCommand="SELECT [KCEventType], [Name] FROM [KCEventType]"></asp:SqlDataSource>

                                        <asp:DropDownList ID="ddlViewKCEventType" runat="server"
                                            DataMember="DefaultView"
                                            DataSourceID="dsViewKCEventTypes"
                                            DataValueField="KCEventType"
                                            AppendDataBoundItems="True"
                                            DataTextField="Name"
                                            SelectedValue='<%# Bind("KCEventType") %>'
                                            OnDataBinding="PreventErrorOnbinding"
                                            Enabled="false">
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource129">Not specified</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-2">
                            <!-- time criteria / other -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource56" runat="server" meta:resourcekey="LiteralResource56">Days:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnViewActiveFlag" runat="server" 
                                            Value='<%# Bind("ActiveFlag") %>' />
                                        <asp:CheckBox ID="chkViewFlagSunday" runat="server" Text="Sunday" Enabled="false" meta:resourcekey="chkViewFlagSunday" /><br />
                                        <asp:CheckBox ID="chkViewFlagMonday" runat="server" Text="Monday" Enabled="false" meta:resourcekey="chkViewFlagMonday" /><br />
                                        <asp:CheckBox ID="chkViewFlagTuesday" runat="server" Text="Tuesday" Enabled="false" meta:resourcekey="chkViewFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkViewFlagWednesday" runat="server" Text="Wednesday" Enabled="false" meta:resourcekey="chkViewFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkViewFlagThursday" runat="server" Text="Thursday" Enabled="false" meta:resourcekey="chkViewFlagThursday" /><br />
                                        <asp:CheckBox ID="chkViewFlagFriday" runat="server" Text="Friday" Enabled="false" meta:resourcekey="chkViewFlagFriday" /><br />
                                        <asp:CheckBox ID="chkViewFlagSaturday" runat="server" Text="Saturday" Enabled="false" meta:resourcekey="chkViewFlagSaturday" /><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource57" runat="server" meta:resourcekey="LiteralResource57">Time from:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="lblViewTimeFrom" runat="server" 
                                            Text='<%# Bind("TimeFrom") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource58" runat="server" meta:resourcekey="LiteralResource58">Time to:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="lblViewTimeTo" runat="server" 
                                            Text='<%# Bind("TimeTo") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource59" runat="server" meta:resourcekey="LiteralResource59">Inactive user:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlViewInactiveUser" runat="server" 
                                            SelectedValue='<%# Bind("InactiveUser") %>' 
                                            Enabled="false">
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource130">Not specified</asp:ListItem>
                                            <asp:ListItem Value="False" meta:resourcekey="ListItemResource131">False</asp:ListItem>
                                            <asp:ListItem Value="True" meta:resourcekey="ListItemResource132">True</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource60" runat="server" meta:resourcekey="LiteralResource60">Inactive KeyCop:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlViewInactiveKeyCop" runat="server" 
                                            SelectedValue='<%# Bind("InactiveKeyCop") %>' 
                                            Enabled="false">
                                            <asp:ListItem Value="" meta:resourcekey="ListItemResource133">Not specified</asp:ListItem>
                                            <asp:ListItem Value="False" meta:resourcekey="ListItemResource134">False</asp:ListItem>
                                            <asp:ListItem Value="True" meta:resourcekey="ListItemResource135">True</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-3">
                            <!-- mail -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource61" runat="server" meta:resourcekey="LiteralResource61">To:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="lblViewMailTo" runat="server" Text='<%# Bind("MailTo") %>' />
                                        <br />
                                        <asp:CheckBox ID="chkViewMailToUser" runat="server" 
                                            Checked='<%# Bind("MailToUser") %>' 
                                            Enabled="false" 
                                            Text="Send mail to user based on User.EMail1" 
                                            meta:resourcekey="chkViewMailToUser" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource62" runat="server" meta:resourcekey="LiteralResource62">Subject:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="lblViewMailSubject" runat="server" 
                                            Text='<%# Bind("MailSubject") %>' />
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource63" runat="server" meta:resourcekey="LiteralResource63">Body:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="lblViewMailTemplate" runat="server" 
                                            Text='<%# Bind("MailTemplate") %>' />
                                    </td>
                                </tr>

                            </table>
                        </div>
                        <div id="tabs-4">
                            <!-- log -->
                            <table class="tblKCAdv">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:Literal ID="LiteralResource64" runat="server" meta:resourcekey="LiteralResource64">Log level:</asp:Literal></td>
                                    <td>
                                        <asp:DropDownList ID="ddlViewAlertLevel" runat="server" 
                                            SelectedValue='<%# Bind("AlertLevel") %>' 
                                            Enabled="false">
                                            <asp:ListItem Value="0" meta:resourcekey="ListItemResource136">0 - Info (default)</asp:ListItem>
                                            <asp:ListItem Value="1" meta:resourcekey="ListItemResource137">1 - Warning</asp:ListItem>
                                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource138">2 - Error</asp:ListItem>
                                        </asp:DropDownList>

                                        <br />
                                        <asp:Literal ID="LiteralResource65" runat="server" meta:resourcekey="LiteralResource65">When a log entry matches an alert it will be stored with a log level. In normal situations this will be level 0/Info.</asp:Literal>

                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-5" class="Hidden">
                            Custom filter (ScriptEval, under development):<br />
                            <asp:TextBox ID="txtAddScriptEval" runat="server" 
                                Text='<%# Bind("ScriptEval") %>' 
                                TextMode="MultiLine" 
                                ReadOnly="true" 
                                Width="600px" Height="350px"></asp:TextBox>
                        </div>
                    </div>

                </ItemTemplate>
            </asp:FormView>
            <br />
            <uc1:EntityControl ID="EntityControl" runat="server" OnClicked="EntityControl_Clicked" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
