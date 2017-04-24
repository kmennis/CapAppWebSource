<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="KeyCopOverview.aspx.cs" Inherits="KCWebManager.Reporting.KeyCopOverview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
        </Triggers>
        <ContentTemplate>

            <asp:SqlDataSource ID="dsKeyCopOverview" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
            SELECT
                bkk.Slot,        
                keycop.KeyNumber,
                keycop.KeyLabel,
                keycop.Description,
                keycop.Enabled,
                keycop.Color
            FROM KeyChain keycop
            INNER JOIN Bound_KeyConductor_KeyChain bkk ON keycop.ID = bkk.KeyChain_ID
            WHERE
                bkk.KeyConductor_ID = @KeyConductorID"
                OnSelecting="dsKeyCopOverview_Selecting">
                <SelectParameters>
                    <asp:ControlParameter Name="KeyConductorID" ControlID="ddlKeyConductor" PropertyName="SelectedValue" Type="Int32" />
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

                <asp:Panel ID="pnlDateRange" runat="server">
                    <table class="tblParameters">
                        <tr>
                            <td><asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">KeyConductor:</asp:Literal>
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlKeyConductor"
                                    DataSourceID="dsKeyConductors"
                                    DataTextField="Name"
                                    DataValueField="ID"
                                    AppendDataBoundItems="true"
                                    AutoPostBack="true"
                                    Width="164px">
                                </asp:DropDownList>
                            </td>
                            <td><asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Display:</asp:Literal>
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
                                <asp:Button ID="btnGenerate" runat="server" Text="Generate report" meta:resourcekey="btnGenerate"/>

                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="btnExport" runat="server" Text="Export..." OnClick="btnExport_Click" meta:resourcekey="btnExport"/>
                            </td>

                        </tr>

                    </table>
                </asp:Panel>

            </asp:Panel>

            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                DataSourceID="dsKeyCopOverview" PageSize="15"
                OnRowDataBound="GridView1_RowDataBound"
                CssClass="Grid NoPointer" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <Columns>
                    <asp:BoundField DataField="Slot" HeaderText="Slot" SortExpression="Slot" />
                    <asp:BoundField DataField="KeyNumber" HeaderText="KeyNumber" SortExpression="KeyNumber" meta:resourcekey="BoundFieldResource1"/>
                    <asp:BoundField DataField="KeyLabel" HeaderText="KeyLabel" SortExpression="KeyLabel" meta:resourcekey="BoundFieldResource2"/>
                    <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" meta:resourcekey="BoundFieldResource3"/>
                    <asp:BoundField DataField="Color" HeaderText="Color" SortExpression="Color"
                        HeaderStyle-CssClass="Hidden"
                        ControlStyle-CssClass="Hidden"
                        ItemStyle-CssClass="Hidden"
                        FooterStyle-CssClass="Hidden" />
                </Columns>
                <EmptyDataTemplate>
                    <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">No KeyCops present.</asp:Literal>
                </EmptyDataTemplate>
            </asp:GridView>


        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
