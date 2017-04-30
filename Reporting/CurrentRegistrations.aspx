<%@ Page Title="Current Registrations" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="CurrentRegistrations.aspx.cs" Inherits="KCWebManager.Reporting.Report_CurrentRegistrations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
        </Triggers>
        <ContentTemplate>

            <asp:SqlDataSource ID="dsCurRegistrations" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>" SelectCommand="
        SELECT  
            reg.DateTime, 
		    reg.KCEventType,
		    reg.Username,
		    reg.KeyLabel, 
		    reg.KeyDescription,
		    reg.KeyConductor,
		    reg.KCID,
		    reg.LogMessage,
            reg.AlertLevel
            FROM 
            (
	            SELECT 
		            reg.DateTime, 
		            reg.KCEventType,
		            usr.Username,
		            kc.KeyLabel, 
		            kc.Description AS KeyDescription,
		            kcr.ID AS KeyConductorID,
                    kcr.Name AS KeyConductor,
		            kcr.KCID,
		            reg.LogMessage,
                    reg.AlertLevel,
		            row_number() OVER (
			            PARTITION BY KeyCopID
			            ORDER BY DateTime DESC) AS rn
	            FROM [Registration] reg
	            INNER JOIN KeyChain kc ON kc.ID = reg.KeyCopID
	            LEFT OUTER JOIN KeyConductor kcr ON reg.KeyConductorID = kcr.ID
	            LEFT OUTER JOIN [User] usr ON usr.ID = reg.UserID
                WHERE
                  (
                    @KeyConductorID = -1 
                    OR 
                    @KeyConductorID = reg.KeyConductorID
                  ) 
                  AND kc.Enabled = 1
            ) reg
            WHERE reg.rn = 1 AND 
                  (
                        (@chkIncludeReturned = 1 AND (reg.KCEventType = 8 OR reg.KCEventType = 12))
                        OR
                        (@chkIncludeReturned = 0 AND reg.KCEventType = 12)
                  ) AND
                  (KeyConductorID = 0 OR
                    KeyConductorID IN 
                    (
                        SELECT [KeyConductor].[ID]
                        FROM [KeyConductor]
                        INNER JOIN [Bound_Site_User] ON ([KeyConductor].[SiteID] = [Bound_Site_User].[Site_ID])
                        WHERE ([Bound_Site_User].[User_ID] = @CurrentUserID)
                    )
                  )
">
                <SelectParameters>
                    <asp:ControlParameter ControlID="chkIncludeReturned" Name="chkIncludeReturned" PropertyName="Checked" Type="Byte" />
                    <asp:ControlParameter Name="KeyConductorID" ControlID="ddlKeyConductor" PropertyName="SelectedValue" Type="Int32" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsKeyConductors" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
            SELECT [KeyConductor].[ID], [KeyConductor].[Name] 
            FROM [KeyConductor]
            INNER JOIN [Bound_Site_User] ON ([KeyConductor].[SiteID] = [Bound_Site_User].[Site_ID])
            WHERE ([Bound_Site_User].[User_ID] = @CurrentUserID) AND ([KeyConductor].[Enabled] = 1)
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
                            <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Options:</asp:Literal></td>
                        <td>
                            <asp:CheckBox ID="chkIncludeReturned" runat="server" AutoPostBack="True" Text="Include returned KeyCops" meta:resourcekey="chkIncludeReturned" /></td>
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
                            <asp:Button ID="btnGenerate" runat="server" Text="Generate report"
                                OnClick="btnGenerate_Click"
                                 meta:resourcekey="btnGenerate" /></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">KeyConductor:</asp:Literal>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlKeyConductor"
                                DataSourceID="dsKeyConductors"
                                DataTextField="Name"
                                DataValueField="ID"
                                AppendDataBoundItems="true"
                                AutoPostBack="true">
                                <asp:ListItem Value="-1" Text="All" meta:resourcekey="ListItemResource4" />
                                <asp:ListItem Value="0" Text="Unknown / System" meta:resourcekey="ListItemResource5" />
                            </asp:DropDownList>
                        </td>
                        <td></td>
                        <td></td>
                        <td>
                            <asp:Button ID="btnExport" runat="server" Text="Export..." OnClick="btnExport_Click" meta:resourcekey="btnExport" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>


            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                DataSourceID="dsCurRegistrations" PageSize="15"
                OnRowDataBound="GridView1_RowDataBound"
                CssClass="Grid NoPointer" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <Columns>
                    <asp:BoundField DataField="DateTime" HeaderText="DateTime" SortExpression="DateTime" meta:resourcekey="BoundFieldResource0" />
                    <asp:BoundField DataField="KCEventType" HeaderText="Event" SortExpression="KCEventType" meta:resourcekey="BoundFieldResource1" />
                    <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" meta:resourcekey="BoundFieldResource2" />
                    <asp:BoundField DataField="KeyLabel" HeaderText="Key Label" SortExpression="KeyLabel" meta:resourcekey="BoundFieldResource3" />
                    <asp:BoundField DataField="KeyDescription" HeaderText="Key Description" SortExpression="KeyDescription" meta:resourcekey="BoundFieldResource4" />
                    <asp:BoundField DataField="KeyConductor" HeaderText="KeyConductor" SortExpression="KeyConductor" meta:resourcekey="BoundFieldResource5" />
                    <asp:BoundField DataField="KCID" HeaderText="KCID" SortExpression="KCID" meta:resourcekey="BoundFieldResource6" />
                    <asp:BoundField DataField="LogMessage" HeaderText="Log Message" SortExpression="LogMessage" meta:resourcekey="BoundFieldResource7" />
                    <asp:BoundField DataField="AlertLevel" HeaderText="AlertLevel" SortExpression="AlertLevel"
                        HeaderStyle-CssClass="Hidden"
                        ControlStyle-CssClass="Hidden"
                        ItemStyle-CssClass="Hidden"
                        FooterStyle-CssClass="Hidden"></asp:BoundField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">No registrations present.</asp:Literal>
                </EmptyDataTemplate>
            </asp:GridView>

            <div class="Hidden">
                <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">Static query</asp:Literal>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
