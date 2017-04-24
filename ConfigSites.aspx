<%@ Page
    Title=""
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    CodeBehind="ConfigSites.aspx.cs"
    Inherits="KCWebManager.ConfigSites"
    EnableEventValidation="false" %>

<%@ Register Src="Controls/EntityControl.ascx" TagName="EntityControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        jq(document).ready(function () {
            jq('#btnEntityControlDelete').bind('click', function (e) {
                if (confirm(jq("#resDeleteSite").text()) == false) {
                    e.preventDefault();
                    return false;
                }
            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="Hidden">
        <asp:Label ID="resDeleteSite" ClientIDMode="Static" Text="Are you sure you want to delete this site?" runat="server" meta:resourcekey="resDeleteSite" />
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:SqlDataSource ID="dsAllSites" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>" SelectCommand="SELECT [ID], [Name] FROM [Site]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="dsSingleSite" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT [ID], [Name] FROM [Site] WHERE [ID] = @ID"
                InsertCommand="INSERT INTO [Site] ([Name]) VALUES (@Name)"
                UpdateCommand="UPDATE [Site] SET [Name] = @Name WHERE [ID] = @ID"
                DeleteCommand="DELETE FROM [Site] WHERE [ID] = @ID"
                OnInserted="dsSingleSite_Inserted"
                OnUpdated="dsSingleSite_Updated">
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdSites" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="ID" Type="Int32" />
                </UpdateParameters>
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>

            </asp:SqlDataSource>

            <asp:GridView ID="grdSites" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" DataKeyNames="ID"
                DataSourceID="dsAllSites"
                PageSize="15"
                OnSelectedIndexChanged="grdSites_SelectedIndexChanged"
                OnRowDataBound="grdSites_RowDataBound"
                CssClass="Grid" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <AlternatingRowStyle CssClass="GridAlt"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" SortExpression="ID" InsertVisible="False" ReadOnly="True" Visible="False" meta:resourcekey="BoundFieldResource0" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" meta:resourcekey="BoundFieldResource1" />
                </Columns>
                <EmptyDataTemplate>
                    <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">No sites present.</asp:Literal>
                </EmptyDataTemplate>
                <HeaderStyle CssClass="GridHdr"></HeaderStyle>
                <PagerStyle CssClass="GridPgr"></PagerStyle>
            </asp:GridView>




            <asp:FormView ID="FormView1" runat="server" DataKeyNames="ID" DataSourceID="dsSingleSite"
                OnItemDeleted="FormView1_ItemDeleted">
                <EditItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">ID:</asp:Literal></td>
                            <td>
                                <asp:Label ID="IDLabel1" runat="server" Text='<%# Eval("ID") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                    </table>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">ID:</asp:Literal></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                    </table>
                </InsertItemTemplate>
                <ItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">ID:</asp:Literal></td>
                            <td>
                                <asp:Label ID="IDLabel" runat="server" Text='<%# Eval("ID") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Name:</asp:Literal></td>
                            <td>
                                <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                    </table>
                </ItemTemplate>
            </asp:FormView>
            <br />
            <uc1:EntityControl ID="EntityControl" runat="server" OnClicked="EntityControl_Clicked" />

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
