<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="Registrations.aspx.cs" Inherits="KCWebManager.Reporting.Registrations" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        //jq(document).ready(function () {
        //});


    </script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
        </Triggers>
        <ContentTemplate>

            <asp:SqlDataSource ID="dsKeyCopRegistrations" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                    select 
	                    reg.DateTime, 
	                    reg.KCEventType,
                        reg.UserID,
	                    usr.Username,
	                    kc.KeyLabel, 
	                    kc.Description as KeyDescription,
	                    kcr.Name as KeyConductor,
	                    kcr.KCID,
	                    reg.LogMessage,
                        reg.AlertLevel
                    FROM [Registration] reg
                    INNER JOIN KeyChain kc ON kc.ID = reg.KeyCopID
                    LEFT OUTER JOIN KeyConductor kcr ON reg.KeyConductorID = kcr.ID
                    LEFT OUTER JOIN [User] usr ON usr.ID = reg.UserID
                    WHERE (@KeyConductorID = -1 OR @KeyConductorID = reg.KeyConductorID)
                            AND 
                            reg.KeyConductorID IN 
                            (
                                SELECT [KeyConductor].[ID]
                                FROM [KeyConductor]
                                INNER JOIN [Bound_Site_User] ON ([KeyConductor].[SiteID] = [Bound_Site_User].[Site_ID])
                                WHERE ([Bound_Site_User].[User_ID] = @CurrentUserID)
                            )
                          
                 "
                OnSelecting="dsKeyCopRegistrations_Selecting">
                <SelectParameters>
                    <asp:ControlParameter Name="KeyConductorID" ControlID="ddlKeyConductor" PropertyName="SelectedValue" Type="Int32" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>

            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsKeyConductors" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                    SELECT [KeyConductor].[ID], [KeyConductor].[Name] 
                    FROM [KeyConductor]
                    INNER JOIN [Bound_Site_User] ON ([KeyConductor].[SiteID] = [Bound_Site_User].[Site_ID])
                    WHERE ([Bound_Site_User].[User_ID] = @CurrentUserID)
                    GROUP BY [KeyConductor].[ID], [KeyConductor].[Name] 
                    ORDER BY [KeyConductor].[Name] ">
                <SelectParameters>
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsKeyCops" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                    SELECT kc.[ID], (kc.[KeyLabel] + ' - ' + kc.[Description]) AS Name 
                    FROM [KeyChain] kc
                    INNER JOIN [Bound_KeyConductor_KeyChain] bnd ON kc.ID = bnd.KeyChain_ID
                    INNER JOIN [Bound_Site_User] bndSU ON kc.SiteID = bndSU.Site_ID
                    WHERE 
	                    kc.[Enabled] = 1 AND
	                    (@KeyConductorID = -1 OR @KeyConductorID = bnd.KeyConductor_ID) AND
                        bndSU.User_ID = @CurrentUserID
                    GROUP BY kc.ID, (kc.[KeyLabel] + ' - ' + kc.[Description]) 
                    ORDER BY (kc.[KeyLabel] + ' - ' + kc.[Description])">
                <SelectParameters>
                    <asp:ControlParameter Name="KeyConductorID" ControlID="ddlKeyConductor" PropertyName="SelectedValue" Type="Int32" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>


            <asp:SqlDataSource ID="dsUsers" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                SELECT
	                u.[ID], 
	                (RIGHT('0000' + CAST(u.UserID AS NVARCHAR(4)), 4) + ' - ' + (CASE WHEN u.Description IS NULL THEN '' ELSE u.Description END)) AS Name
                FROM [User] u
                WHERE
	                u.ID in (
		                SELECT u.ID
		                FROM [User] u
		                INNER JOIN Bound_Site_User bsu ON bsu.User_ID = u.ID
		                INNER JOIN KeyConductor kc ON kc.SiteID = bsu.Site_ID
                        INNER JOIN Bound_Site_User bsu2 ON bsu2.Site_ID = bsu.Site_ID 
	                WHERE
		                u.Enabled = 1 AND
		                (@KeyConductorID = -1 OR kc.ID = @KeyConductorID) AND
                        bsu2.User_ID = @CurrentUserID
	                GROUP BY u.ID
	                )
                ORDER BY u.[UserID], u.[Description]

                ">
                <SelectParameters>
                    <asp:ControlParameter Name="KeyConductorID" ControlID="ddlKeyConductor" PropertyName="SelectedValue" Type="Int32" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>


            <asp:Panel ID="pnlParameters" runat="server">

                <asp:Panel ID="pnlDateRange" runat="server">
                    <table class="tblParameters RegParameters">
                        <tr>
                            <td><asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">Date range:</asp:Literal>
                            </td>
                            <td>
                                <asp:TextBox ID="txtDateFrom" Width="65px" runat="server"></asp:TextBox>
                                <ajaxToolkit:CalendarExtender ID="txtDateFromExt" runat="server" TargetControlID="txtDateFrom" TodaysDateFormat="d" Format="d"></ajaxToolkit:CalendarExtender>
                                -
                                <asp:TextBox ID="txtDateTo" Width="65px" runat="server"></asp:TextBox>
                                <ajaxToolkit:CalendarExtender ID="txtDateToExt" runat="server" TargetControlID="txtDateTo" TodaysDateFormat="d" Format="d"></ajaxToolkit:CalendarExtender>

                            </td>
                            <td><asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Display:</asp:Literal>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlGridPageSize" runat="server"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlGridPageSize_SelectedIndexChanged"
                                    ToolTip="Select the number of records to display" meta:resourcekey="ddlGridPageSize"
                                    Width="30%">
                                    <asp:ListItem Text="15" Value="15"></asp:ListItem>
                                    <asp:ListItem Text="30" Value="30"></asp:ListItem>
                                    <asp:ListItem Text="50" Value="50"></asp:ListItem>
                                    <asp:ListItem Text="100" Value="100"></asp:ListItem>
                                </asp:DropDownList>
                            </td>

                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td><asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">KeyConductor:</asp:Literal>
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlKeyConductor"
                                    DataSourceID="dsKeyConductors"
                                    DataTextField="Name"
                                    DataValueField="ID"
                                    AppendDataBoundItems="true"
                                    AutoPostBack="true"
                                    Width="30%">
                                    <asp:ListItem Value="-1" Text="All" meta:resourcekey="ListItemResource4"/>
                                </asp:DropDownList>
                            </td>
                            <td><asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">KeyCops:</asp:Literal>
                            </td>
                            <td>
                                <asp:Button ID="btnEditKeyCopList" Text="Edit..." runat="server" OnClick="btnEditKeyCopList_Click"/>
                                <asp:Button ID="btnEditKeyCopList2" Text="Placeholder" runat="server" CssClass="Hidden" />
                            </td>
                            <td>
                                <asp:Button ID="btnGenerate" runat="server" meta:resourcekey="btnGenerate" Text="Generate report" />
                            </td>

                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td><asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Users:</asp:Literal>
                            </td>
                            <td>
                                <asp:Button ID="btnEditUserList" Text="Edit..." runat="server" OnClick="btnEditUserList_Click" />
                                <asp:Button ID="btnEditUserList2" Text="Placeholder" runat="server" CssClass="Hidden" />
                            </td>
                            <td>
                                <asp:Button ID="btnExport" runat="server" Text="Export..." OnClick="btnExport_Click" meta:resourcekey="btnExport"/>
                            </td>

                        </tr>
                    </table>
                </asp:Panel>

                <asp:Panel ID="pnlKeyCops" runat="server" CssClass="modalPopup" Height="500px" Width="450px">
                    <input type="checkbox" onchange="javascript:ToggleCheckboxes(this, '#chkLstKeyCops');" checked="checked" id="chkToggleAll" name="chkToggleAll" /><label for="chkToggleAll"><asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Check/Uncheck all</asp:Literal></label>
                    <br />
                    <div style="overflow: scroll; height: 400px;">
                        <asp:CheckBoxList ClientIDMode="Static" ID="chkLstKeyCops" runat="server" DataSourceID="dsKeyCops" DataTextField="Name" DataValueField="ID">
                        </asp:CheckBoxList>
                    </div>
                    <div style="width: 100%; text-align: right;">
                        <asp:Button ID="pnlKeyCopsOK" Text="OK" runat="server" Height="34px" Width="100px" OnClick="pnlKeyCopsOK_Click" meta:resourcekey="pnlKeyCopsOK"/>
                        <asp:Button ID="pnlKeyCopsCancel" Text="Cancel" runat="server" Height="34px" Width="100px" OnClick="pnlKeyCopsCancel_Click" meta:resourcekey="pnlKeyCopsCancel"/>
                    </div>
                </asp:Panel>

                <ajaxToolkit:ModalPopupExtender ID="pnlKeyCops_ModalPopupExtender" runat="server"
                    BehaviorID="pnlKeyCops_ModalPopupExtender"
                    TargetControlID="btnEditKeyCopList2"
                    BackgroundCssClass="modalBackground"
                    PopupControlID="pnlKeyCops" Enabled="true">
                </ajaxToolkit:ModalPopupExtender>


                <asp:Panel ID="pnlUsers" runat="server" CssClass="modalPopup" Height="500px" Width="450px">
                    <input type="checkbox" onchange="javascript:ToggleCheckboxes(this, '#chkLstUsers');" checked="checked" id="chkToggleAllUsers" name="chkToggleAllUsers" /><label for="chkToggleAllUsers"><asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Check/Uncheck all</asp:Literal></label>
                    <br />
                    <div style="overflow: scroll; height: 400px;">
                        <asp:CheckBoxList ClientIDMode="Static" ID="chkLstUsers" runat="server" DataSourceID="dsUsers" DataTextField="Name" DataValueField="ID">
                        </asp:CheckBoxList>
                    </div>
                    <div style="width: 100%; text-align: right;">
                        <asp:Button ID="pnlUsersOK" Text="OK" runat="server" Height="34px" Width="100px" OnClick="pnlUsersOK_Click" meta:resourcekey="pnlUsersOK"/>
                        <asp:Button ID="pnlUsersCancel" Text="Cancel" runat="server" Height="34px" Width="100px" OnClick="pnlUsersCancel_Click" meta:resourcekey="pnlUsersCancel"/>
                    </div>
                </asp:Panel>
                <ajaxToolkit:ModalPopupExtender ID="pnlUsers_ModalPopupExtender" runat="server"
                    BehaviorID="pnlUsers_ModalPopupExtender"
                    TargetControlID="btnEditUserList2"
                    BackgroundCssClass="modalBackground"
                    PopupControlID="pnlUsers" Enabled="true">
                </ajaxToolkit:ModalPopupExtender>

            </asp:Panel>

            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                DataSourceID="dsKeyCopRegistrations" PageSize="15"
                OnRowDataBound="GridView1_RowDataBound"
                CssClass="Grid NoPointer" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">

                <Columns>
                    <asp:BoundField DataField="DateTime" HeaderText="DateTime" SortExpression="DateTime" meta:resourcekey="BoundFieldResource0" />
                    <asp:BoundField DataField="KCEventType" HeaderText="Event" SortExpression="KCEventType" meta:resourcekey="BoundFieldResource1" />
                    <asp:BoundField DataField="UserID" HeaderText="UserID" SortExpression="UserID" Visible="false" meta:resourcekey="BoundFieldResource2" />
                    <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" meta:resourcekey="BoundFieldResource3" />
                    <asp:BoundField DataField="KeyLabel" HeaderText="Key Label" SortExpression="KeyLabel" meta:resourcekey="BoundFieldResource4" />
                    <asp:BoundField DataField="KeyDescription" HeaderText="Key Description" SortExpression="KeyDescription" meta:resourcekey="BoundFieldResource5" />
                    <asp:BoundField DataField="KeyConductor" HeaderText="KeyConductor" SortExpression="KeyConductor" meta:resourcekey="BoundFieldResource6" />
                    <asp:BoundField DataField="KCID" HeaderText="KCID" SortExpression="KCID" meta:resourcekey="BoundFieldResource7" />
                    <asp:BoundField DataField="LogMessage" HeaderText="Log Message" SortExpression="LogMessage" meta:resourcekey="BoundFieldResource8" />
                    <asp:BoundField DataField="AlertLevel" HeaderText="AlertLevel" SortExpression="AlertLevel"
                        HeaderStyle-CssClass="Hidden"
                        ControlStyle-CssClass="Hidden"
                        ItemStyle-CssClass="Hidden"
                        FooterStyle-CssClass="Hidden"></asp:BoundField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">No registrations present.</asp:Literal>
                </EmptyDataTemplate>
            </asp:GridView>


            <div class="Hidden">
                <blockquote>
                    <asp:Label ID="lblSQL" ClientIDMode="Static" runat="server" Text="Label"></asp:Label>
                </blockquote>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>


    <script>
        function ToggleCheckboxes(toggleAll, checkBoxList) {

            jq(checkBoxList).find(':checkbox').each(function () {
                jq(this).prop('checked', toggleAll.checked); // chkToggleAll.is(':checked'));
            });
        }
        function showSQL() {
            jq("#lblSQL").parent().parent().removeClass("Hidden");
        }
    </script>
    <a class="Hidden" href="#" onclick="javascript:showSQL(); return false;">showSQL</a>

</asp:Content>
