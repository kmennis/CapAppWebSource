<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true"
    CodeBehind="EventLog.aspx.cs" Inherits="KCWebManager.Reporting.EventLog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        //jq(document).ready(function () {
        //});


    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
        </Triggers>
        <ContentTemplate>
            <asp:SqlDataSource ID="dsEventLog" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
            SELECT
         	    [DateTime],
		        [KCEventType],
		        [Username],
		        [KeyLabel], 
	 	        kc.Description as [KeyDescription],
		        kcr.Name as [KeyConductor],
                KeyConductorID,
		        [KCID],
		        [LogMessage],
                [AlertLevel]
            FROM 
            (
	            SELECT reg.* FROM [Registration] reg
                UNION ALL
	            SELECT evt.* FROM [Event] evt
            ) MergedEvents
            LEFT OUTER JOIN KeyChain kc ON kc.ID = MergedEvents.KeyCopID
            LEFT OUTER JOIN KeyConductor kcr ON MergedEvents.KeyConductorID = kcr.ID
            LEFT OUTER JOIN [User] usr ON usr.ID = MergedEvents.UserID
            WHERE [AlertLevel] &gt;= @AlertLevel
                  AND
                  (@KeyConductorID = -1 OR @KeyConductorID = KeyConductorID)
                  AND 
                  (KeyConductorID = 0 OR 
                   KeyConductorID IN 
                        (
                            SELECT [KeyConductor].[ID]
                            FROM [KeyConductor]
                            INNER JOIN [Bound_Site_User] ON ([KeyConductor].[SiteID] = [Bound_Site_User].[Site_ID])
                            WHERE ([Bound_Site_User].[User_ID] = @CurrentUserID)
                        )
                 )
                 --WHERE--
            ORDER BY [DateTime], [InternalIndex]"
                OnSelecting="dsEventLog_Selecting">
                <SelectParameters>
                    <asp:ControlParameter Name="AlertLevel" ControlID="ddlAlertLevel" PropertyName="SelectedValue" Type="Int32" />
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

            <asp:Panel ID="pnlParameters" runat="server">
                <table class="tblParameters">
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">Date range:</asp:Literal>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDateFrom" runat="server" Width="65px"></asp:TextBox>
                            <ajaxToolkit:CalendarExtender ID="txtDateFromExt" runat="server" TargetControlID="txtDateFrom" TodaysDateFormat="d" Format="d"></ajaxToolkit:CalendarExtender>
                            -
                    <asp:TextBox ID="txtDateTo" runat="server" Width="65px"></asp:TextBox>
                            <ajaxToolkit:CalendarExtender ID="txtDateToExt" runat="server" TargetControlID="txtDateTo" TodaysDateFormat="d" Format="d"></ajaxToolkit:CalendarExtender>
                        </td>
                        <td>
                            <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Display:</asp:Literal>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlGridPageSize" runat="server"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlGridPageSize_SelectedIndexChanged"
                                ToolTip="Select the number of records to display" meta:resourcekey="ddlGridPageSize">
                                <asp:ListItem Text="15" Value="15"></asp:ListItem>
                                <asp:ListItem Text="30" Value="30"></asp:ListItem>
                                <asp:ListItem Text="50" Value="50"></asp:ListItem>
                                <asp:ListItem Text="100" Value="100"></asp:ListItem>
                            </asp:DropDownList>
                        </td>

                        <td>
                            <asp:Button ID="btnGenerate" runat="server" meta:resourcekey="btnGenerate" Text="Generate report" />
                        </td>

                    </tr>
                    <tr>
                        <td>KeyConductor:
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlKeyConductor"
                                DataSourceID="dsKeyConductors"
                                DataTextField="Name"
                                DataValueField="ID"
                                AppendDataBoundItems="true"
                                AutoPostBack="true">
                                <asp:ListItem Value="-1" Text="All" meta:resourcekey="ListItemResource0" />
                                <asp:ListItem Value="0" Text="Unknown / System" />
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Level:</asp:Literal></td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlAlertLevel" AutoPostBack="true">
                                <asp:ListItem Value="0" Text="All messages" meta:resourcekey="ListItemResource1"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Warnings and errors" meta:resourcekey="ListItemResource2"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Errors only" meta:resourcekey="ListItemResource3"></asp:ListItem>
                            </asp:DropDownList>

                        </td>

                        <td>
                            <asp:Button ID="btnExport" runat="server" Text="Export..." OnClick="btnExport_Click" meta:resourcekey="btnExport" />
                        </td>
                    </tr>

                </table>

            </asp:Panel>

            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                DataSourceID="dsEventLog"
                PageSize="15"
                OnRowDataBound="GridView1_RowDataBound"
                CssClass="Grid NoPointer EventLogTable" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <AlternatingRowStyle CssClass="GridAlt"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="DateTime" HeaderText="DateTime" SortExpression="DateTime" meta:resourcekey="BoundFieldResource0" HeaderStyle-Width="150px">
                        <HeaderStyle Width="150px"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="KCEventType" HeaderText="Event" SortExpression="KCEventType" meta:resourcekey="BoundFieldResource1" HeaderStyle-Width="150px">
                        <HeaderStyle Width="150px"></HeaderStyle>
                    </asp:BoundField>
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
                        FooterStyle-CssClass="Hidden">
                        <ControlStyle CssClass="Hidden"></ControlStyle>

                        <FooterStyle CssClass="Hidden"></FooterStyle>

                        <HeaderStyle CssClass="Hidden"></HeaderStyle>

                        <ItemStyle CssClass="Hidden"></ItemStyle>
                    </asp:BoundField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">No events present.</asp:Literal>
                </EmptyDataTemplate>

                <HeaderStyle CssClass="GridHdr"></HeaderStyle>

                <PagerStyle CssClass="GridPgr"></PagerStyle>

            </asp:GridView>

            <div class="Hidden">
                <asp:Label ID="lblSQL" runat="server" Text="Label"></asp:Label>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
