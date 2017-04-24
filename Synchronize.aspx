<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="Synchronize.aspx.cs" Inherits="KCWebManager.Synchronize" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .btnSync2 {
            width: 200px;
            height: 50px;
            background-image: url('Content/FamFamFam/arrow_refresh.png');
            background-repeat: no-repeat;
            background-position-x: 10px;
            background-position-y: center;
            border: 1px solid gray;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="udpScheduler" runat="server">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
        </Triggers>
        <ContentTemplate>
            <asp:SqlDataSource ID="dsKeyConductors" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                    SELECT 
	                    kc.[ID], kc.[KCID], kc.[Name], kc.[LastSync], kc.[NextSync], kc.[LastLog], kc.[LastLiveView],
	                    [Site].Name AS SiteName	                    
                    FROM [KeyConductor] kc
                    INNER JOIN Bound_Site_User bsu ON bsu.Site_ID = kc.SiteID
                    INNER JOIN [Site] ON kc.SiteID = [Site].ID
                    WHERE   kc.[SiteID] IS NOT NULL AND 
		                    kc.InterfaceType = 1 AND
		                    kc.Enabled = 1 AND
	                        bsu.User_ID = @CurrentUserID
                    ORDER BY kc.[KCID], kc.[Name]">
                <SelectParameters>
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                    <asp:SessionParameter Name="LastDatabaseChange" DefaultValue="2016-05-30T00:00:00" SessionField="LastDatabaseChange" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>


            <asp:Timer ID="Timer1" runat="server" Enabled="True" Interval="2000" OnTick="Timer1_Tick">
            </asp:Timer>

            <asp:Repeater ID="rptSync" runat="server"
                DataSourceID="dsKeyConductors"
                OnItemDataBound="rptSync_ItemDataBound">
                <HeaderTemplate>
                    <table class="tblKCAdv">
                        <tr style="font-weight: bold;">
                            <td style="width: 25px;">&nbsp;</td>
                            <td>
                                <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">KCID</asp:Literal></td>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Name</asp:Literal></td>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Site</asp:Literal></td>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Status</asp:Literal></td>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td style="width: 25px;">
                            <asp:HiddenField ID="hdnKeyConductor" runat="server" Value='<%# Eval("ID") %>' />
                            <asp:CheckBox ID="chkKeyConductor" runat="server" />
                        </td>
                        <td>
                            <asp:Label ID="lblKCID" runat="server" Text='<%# Eval("KCID") %>' />
                        </td>
                        <td>
                            <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' />
                        </td>
                        <td>
                            <asp:Label ID="lblSite" runat="server" Text='<%# Eval("SiteName") %>' />
                        </td>
                        <td>
                            <asp:Image ID="imgStatus2" runat="server"
                                ImageUrl='<%# GetStatusImage(DataBinder.Eval(Container.DataItem, "LastSync"), 
                                                             DataBinder.Eval(Container.DataItem, "NextSync"),
                                                             DataBinder.Eval(Container.DataItem, "LastLog"),
                                                             DataBinder.Eval(Container.DataItem, "LastLiveView")) %>' />
                            <asp:Label ID="Label1" runat="server" Text='<%#GetSyncText(DataBinder.Eval(Container.DataItem, "LastSync"), 
                                                              DataBinder.Eval(Container.DataItem, "NextSync"),
                                                             DataBinder.Eval(Container.DataItem, "LastLog"),
                                                             DataBinder.Eval(Container.DataItem, "LastLiveView")) %>' />

                        </td>

                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <br />
            <br />
            <asp:Button ID="btnSync2" runat="server" OnClick="btnSync2_Click" Text="Synchronize" CssClass="btnSync2" meta:resourcekey="btnSync2" />
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
