<%@ Page
    Title=""
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    CodeBehind="ConfigRoles.aspx.cs"
    Inherits="KCWebManager.ConfigRoles"
    EnableEventValidation="false" %>

<%@ Register Src="Controls/EntityControl.ascx" TagName="EntityControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">

        jq(document).ready(function () {
            jq('#btnEntityControlDelete').bind('click', function (e) {
                //if (confirm(mlGetString(2001, "Are you sure you want to delete this role?")) == false) {
                if (confirm(jq("#resDeletRole").text()) == false) {
                    e.preventDefault();
                    return false;
                }
            });
        });

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="Hidden">
        <asp:Label ID="resDeleteRole" ClientIDMode="Static" Text="Are you sure you want to delete this role?" runat="server" meta:resourcekey="resDeleteRole" />
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:SqlDataSource ID="dsAllRoles" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT 
              [ID], 
              [Name],
        	  CONCAT(CAST((CAST([CanViewStatus] AS INT)
                  + CAST([CanRemoteRelease] AS INT)
                  + CAST([CanViewUsers] AS INT)
                  + CAST([CanEditUsers] AS INT)
                  + CAST([CanViewGroups] AS INT)
                  + CAST([CanEditGroups] AS INT)
                  + CAST([CanViewKeyCops] AS INT)
                  + CAST([CanEditKeyCops] AS INT)
                  + CAST([CanViewKeyConductors] AS INT)
                  + CAST([CanEditKeyConductors] AS INT)
                  + CAST([CanSyncKeyConductors] AS INT)
                  + CAST([CanExecuteInventory] AS INT)
                  + CAST([CanViewSites] AS INT)
                  + CAST([CanEditSites] AS INT)
                  + CAST([CanEditSettings] AS INT)
                  + CAST([CanEditAlerts] AS INT)
                  + CAST([CanEditReports] AS INT)
                  + CAST([CanEditRoles] AS INT)
                  + CAST([CanViewAllReservations] AS INT)
                  + CAST([CanEditAllReservations] AS INT)
                  + CAST([CanViewOwnReservations] AS INT)
                  + CAST([CanEditOwnReservations] AS INT)
                  + CAST([CanDelete] AS INT)
                  + CAST([CanViewOwnProfile] AS INT)
                  + CAST([CanEditOwnCredentials] AS INT)
                  + CAST([CanEditOwnProfile] AS INT)
                  + CAST([CanViewReports] AS INT)) AS NVARCHAR(2)), ' / 27') as Permissions,
             [RoleLevel],
             [IsDefaultRole],
             (SELECT COUNT(ID) FROM [User] WHERE RoleID = r.ID) as Users
        FROM [Role] r 
        ORDER BY [RoleLevel]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="dsSingleRole" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                DeleteCommand="DELETE FROM [Role] WHERE [ID] = @ID"
                InsertCommand="INSERT INTO [Role] ([Name], [Description], [IsDefaultRole], [CanViewStatus], [CanRemoteRelease], [CanViewUsers], [CanEditUsers], [CanViewGroups], 
                                           [CanEditGroups], [CanViewKeyCops], [CanEditKeyCops], 
                                           [CanViewKeyConductors], [CanEditKeyConductors], [CanSyncKeyConductors], [CanExecuteInventory],
                                           [CanViewSites], [CanEditSites], [CanEditSettings], [CanEditAlerts], [CanEditReports], [CanEditRoles], [CanViewAllReservations], 
                                           [CanEditAllReservations], [CanViewOwnReservations], [CanEditOwnReservations], [CanDelete], [CanViewOwnProfile], [CanEditOwnCredentials], 
                                           [CanEditOwnProfile], [CanViewReports],
                                           [RoleLevel]) 
                                   VALUES (@Name, @Description, @IsDefaultRole, @CanViewStatus, @CanRemoteRelease, @CanViewUsers, @CanEditUsers, @CanViewGroups, 
                                           @CanEditGroups, @CanViewKeyCops, @CanEditKeyCops, 
                                           @CanViewKeyConductors, @CanEditKeyConductors, @CanSyncKeyConductors, @CanExecuteInventory,
                                           @CanViewSites, @CanEditSites, @CanEditSettings, @CanEditAlerts, @CanEditReports, @CanEditRoles, @CanViewAllReservations, 
                                           @CanEditAllReservations, @CanViewOwnReservations, @CanEditOwnReservations, @CanDelete, @CanViewOwnProfile, @CanEditOwnCredentials,
                                           @CanEditOwnProfile, @CanViewReports,
                                           @RoleLevel)"
                SelectCommand="SELECT * FROM [Role] WHERE ([ID] = @ID)"
                UpdateCommand="UPDATE [Role] SET 
            [Name] = @Name, [Description] = @Description, [IsDefaultRole] = @IsDefaultRole, [CanViewStatus] = @CanViewStatus, [CanRemoteRelease] = @CanRemoteRelease, 
            [CanViewUsers] = @CanViewUsers, [CanEditUsers] = @CanEditUsers, [CanViewGroups] = @CanViewGroups, [CanEditGroups] = @CanEditGroups, [CanViewKeyCops] = @CanViewKeyCops, 
            [CanEditKeyCops] = @CanEditKeyCops, 
            [CanViewKeyConductors] = @CanViewKeyConductors, [CanEditKeyConductors] = @CanEditKeyConductors, [CanSyncKeyConductors] = @CanSyncKeyConductors, [CanExecuteInventory] = @CanExecuteInventory,
            [CanViewSites] = @CanViewSites, [CanEditSites] = @CanEditSites, [CanEditSettings] = @CanEditSettings, [CanEditAlerts] = @CanEditAlerts, [CanEditReports] = @CanEditReports, 
            [CanEditRoles] = @CanEditRoles, [CanViewAllReservations] = @CanViewAllReservations, [CanEditAllReservations] = @CanEditAllReservations, [CanViewOwnReservations] = @CanViewOwnReservations, 
            [CanEditOwnReservations] = @CanEditOwnReservations, [CanDelete] = @CanDelete, [CanViewOwnProfile] = @CanViewOwnProfile, [CanEditOwnCredentials] = @CanEditOwnCredentials, 
            [CanEditOwnProfile] = @CanEditOwnProfile, [CanViewReports] = @CanViewReports,
            [RoleLevel] = @RoleLevel
         WHERE [ID] = @ID"
                OnUpdated="dsSingleRole_Updated"
                OnInserted="dsSingleRole_Inserted">
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="IsDefaultRole" Type="Boolean" />
                    <asp:Parameter Name="CanViewStatus" Type="Boolean" />
                    <asp:Parameter Name="CanRemoteRelease" Type="Boolean" />
                    <asp:Parameter Name="CanViewUsers" Type="Boolean" />
                    <asp:Parameter Name="CanEditUsers" Type="Boolean" />
                    <asp:Parameter Name="CanViewGroups" Type="Boolean" />
                    <asp:Parameter Name="CanEditGroups" Type="Boolean" />
                    <asp:Parameter Name="CanViewKeyCops" Type="Boolean" />
                    <asp:Parameter Name="CanEditKeyCops" Type="Boolean" />
                    <asp:Parameter Name="CanViewKeyConductors" Type="Boolean" />
                    <asp:Parameter Name="CanEditKeyConductors" Type="Boolean" />
                    <asp:Parameter Name="CanSyncKeyConductors" Type="Boolean" />
                    <asp:Parameter Name="CanExecuteInventory" Type="Boolean" />
                    <asp:Parameter Name="CanViewSites" Type="Boolean" />
                    <asp:Parameter Name="CanEditSites" Type="Boolean" />
                    <asp:Parameter Name="CanEditSettings" Type="Boolean" />
                    <asp:Parameter Name="CanEditAlerts" Type="Boolean" />
                    <asp:Parameter Name="CanEditReports" Type="Boolean" />
                    <asp:Parameter Name="CanEditRoles" Type="Boolean" />
                    <asp:Parameter Name="CanViewAllReservations" Type="Boolean" />
                    <asp:Parameter Name="CanEditAllReservations" Type="Boolean" />
                    <asp:Parameter Name="CanViewOwnReservations" Type="Boolean" />
                    <asp:Parameter Name="CanEditOwnReservations" Type="Boolean" />
                    <asp:Parameter Name="CanDelete" Type="Boolean" />
                    <asp:Parameter Name="CanViewOwnProfile" Type="Boolean" />
                    <asp:Parameter Name="CanEditOwnCredentials" Type="Boolean" />
                    <asp:Parameter Name="CanEditOwnProfile" Type="Boolean" />
                    <asp:Parameter Name="CanViewReports" Type="Boolean" />
                    <asp:Parameter Name="RoleLevel" Type="Byte" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdRoles" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="IsDefaultRole" Type="Boolean" />
                    <asp:Parameter Name="CanViewStatus" Type="Boolean" />
                    <asp:Parameter Name="CanRemoteRelease" Type="Boolean" />
                    <asp:Parameter Name="CanViewUsers" Type="Boolean" />
                    <asp:Parameter Name="CanEditUsers" Type="Boolean" />
                    <asp:Parameter Name="CanViewGroups" Type="Boolean" />
                    <asp:Parameter Name="CanEditGroups" Type="Boolean" />
                    <asp:Parameter Name="CanViewKeyCops" Type="Boolean" />
                    <asp:Parameter Name="CanEditKeyCops" Type="Boolean" />
                    <asp:Parameter Name="CanViewKeyConductors" Type="Boolean" />
                    <asp:Parameter Name="CanEditKeyConductors" Type="Boolean" />
                    <asp:Parameter Name="CanSyncKeyConductors" Type="Boolean" />
                    <asp:Parameter Name="CanExecuteInventory" Type="Boolean" />
                    <asp:Parameter Name="CanViewSites" Type="Boolean" />
                    <asp:Parameter Name="CanEditSites" Type="Boolean" />
                    <asp:Parameter Name="CanEditSettings" Type="Boolean" />
                    <asp:Parameter Name="CanEditAlerts" Type="Boolean" />
                    <asp:Parameter Name="CanEditReports" Type="Boolean" />
                    <asp:Parameter Name="CanEditRoles" Type="Boolean" />
                    <asp:Parameter Name="CanViewAllReservations" Type="Boolean" />
                    <asp:Parameter Name="CanEditAllReservations" Type="Boolean" />
                    <asp:Parameter Name="CanViewOwnReservations" Type="Boolean" />
                    <asp:Parameter Name="CanEditOwnReservations" Type="Boolean" />
                    <asp:Parameter Name="CanDelete" Type="Boolean" />
                    <asp:Parameter Name="CanViewOwnProfile" Type="Boolean" />
                    <asp:Parameter Name="CanEditOwnCredentials" Type="Boolean" />
                    <asp:Parameter Name="CanEditOwnProfile" Type="Boolean" />
                    <asp:Parameter Name="CanViewReports" Type="Boolean" />
                    <asp:Parameter Name="RoleLevel" Type="Byte" />
                    <asp:Parameter Name="ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:Panel ID="pnlWarnings" runat="server" Visible="false" CssClass="warning">
                <br />
                <br />
                <asp:Label ID="lblNoDefaultRole" runat="server" Text="Warning: there is no default role set. New users will be assigned to the first role available. This can lead to unpredictable results!" Visible="false" meta:resourcekey="lblNoDefaultRole" />

                <asp:Label ID="lblMultipleDefault" runat="server" Text="Warning: there are multiple roles set as default. New users will be assigned to the first role available. This can lead to security issues!" Visible="false" meta:resourcekey="lblMultipleDefault" />
                <br />
                <br />
            </asp:Panel>

            <asp:GridView ID="grdRoles" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="dsAllRoles"
                PageSize="15"
                OnSelectedIndexChanged="grdRoles_SelectedIndexChanged"
                OnRowDataBound="grdRoles_RowDataBound"
                CssClass="Grid" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <AlternatingRowStyle CssClass="GridAlt"></AlternatingRowStyle>
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" SortExpression="ID" InsertVisible="False" ReadOnly="True" Visible="False" meta:resourcekey="BoundFieldResource0" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" meta:resourcekey="BoundFieldResource1" />
                    <asp:BoundField DataField="Permissions" HeaderText="Permissions" SortExpression="Permissions" meta:resourcekey="BoundFieldResource2" />
                    <asp:BoundField DataField="RoleLevel" HeaderText="Level" SortExpression="RoleLevel" />
                    <asp:BoundField DataField="Users" HeaderText="Users" SortExpression="Users" meta:resourcekey="BoundFieldResource3" />

                    <asp:CheckBoxField DataField="IsDefaultRole" HeaderText="Default role" SortExpression="IsDefaultRole" meta:resourcekey="CheckBoxFieldResource0" />
                </Columns>
                <EmptyDataTemplate>
                    <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">No roles present.</asp:Literal>
                </EmptyDataTemplate>
                <HeaderStyle CssClass="GridHdr"></HeaderStyle>
                <PagerStyle CssClass="GridPgr"></PagerStyle>
            </asp:GridView>


            <asp:FormView ID="fvwRole" runat="server" DataKeyNames="ID" DataSourceID="dsSingleRole"
                OnItemDeleted="fvwRole_ItemDeleted">
                <EditItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Name</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Description</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="DescriptionTextBox" runat="server" Text='<%# Bind("Description") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">IsDefaultRole</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="IsDefaultRoleCheckBox" runat="server" Checked='<%# Bind("IsDefaultRole") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>Level</td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlRoleLevel"
                                    SelectedValue='<%# Bind("RoleLevel") %>'>
                                    <asp:ListItem Text="0" Value="0" />
                                    <asp:ListItem Text="1" Value="1" />
                                    <asp:ListItem Text="2" Value="2" />
                                    <asp:ListItem Text="3" Value="3" />
                                    <asp:ListItem Text="4" Value="4" />
                                    <asp:ListItem Text="5" Value="5" />
                                    <asp:ListItem Text="6" Value="6" />
                                    <asp:ListItem Text="7" Value="7" />
                                    <asp:ListItem Text="8" Value="8" />
                                    <asp:ListItem Text="9" Value="9" />
                                    <asp:ListItem Text="10" Value="10" />
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewStatus</td>
                            <td>
                                <asp:CheckBox ID="CanViewStatusCheckBox" runat="server" Checked='<%# Bind("CanViewStatus") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanRemoteRelease</td>
                            <td>
                                <asp:CheckBox ID="CanRemoteReleaseCheckBox" runat="server" Checked='<%# Bind("CanRemoteRelease") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewUsers</td>
                            <td>
                                <asp:CheckBox ID="CanViewUsersCheckBox" runat="server" Checked='<%# Bind("CanViewUsers") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditUsers</td>
                            <td>
                                <asp:CheckBox ID="CanEditUsersCheckBox" runat="server" Checked='<%# Bind("CanEditUsers") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewGroups</td>
                            <td>
                                <asp:CheckBox ID="CanViewGroupsCheckBox" runat="server" Checked='<%# Bind("CanViewGroups") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditGroups</td>
                            <td>
                                <asp:CheckBox ID="CanEditGroupsCheckBox" runat="server" Checked='<%# Bind("CanEditGroups") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewKeyCops</td>
                            <td>
                                <asp:CheckBox ID="CanViewKeyCopsCheckBox" runat="server" Checked='<%# Bind("CanViewKeyCops") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditKeyCops</td>
                            <td>
                                <asp:CheckBox ID="CanEditKeyCopsCheckBox" runat="server" Checked='<%# Bind("CanEditKeyCops") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanViewKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanViewKeyConductors") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanEditKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanEditKeyConductors") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanSyncKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanSyncKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanSyncKeyConductors") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanExecuteInventory</td>
                            <td>
                                <asp:CheckBox ID="CanExecuteInventoryCheckBox" runat="server" Checked='<%# Bind("CanExecuteInventory") %>' />
                            </td>
                        </tr>

                        <tr>
                            <td>CanViewSites</td>
                            <td>
                                <asp:CheckBox ID="CanViewSitesCheckBox" runat="server" Checked='<%# Bind("CanViewSites") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditSites</td>
                            <td>
                                <asp:CheckBox ID="CanEditSitesCheckBox" runat="server" Checked='<%# Bind("CanEditSites") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditSettings</td>
                            <td>
                                <asp:CheckBox ID="CanEditSettingsCheckBox" runat="server" Checked='<%# Bind("CanEditSettings") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditAlerts</td>
                            <td>
                                <asp:CheckBox ID="CanEditAlertsCheckBox" runat="server" Checked='<%# Bind("CanEditAlerts") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditReports</td>
                            <td>
                                <asp:CheckBox ID="CanEditReportsCheckBox" runat="server" Checked='<%# Bind("CanEditReports") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditRoles</td>
                            <td>
                                <asp:CheckBox ID="CanEditRolesCheckBox" runat="server" Checked='<%# Bind("CanEditRoles") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewAllReservations</td>
                            <td>
                                <asp:CheckBox ID="CanViewAllReservationsCheckBox" runat="server" Checked='<%# Bind("CanViewAllReservations") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditAllReservations</td>
                            <td>
                                <asp:CheckBox ID="CanEditAllReservationsCheckBox" runat="server" Checked='<%# Bind("CanEditAllReservations") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewOwnReservations</td>
                            <td>
                                <asp:CheckBox ID="CanViewOwnReservationsCheckBox" runat="server" Checked='<%# Bind("CanViewOwnReservations") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnReservations</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnReservationsCheckBox" runat="server" Checked='<%# Bind("CanEditOwnReservations") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanDelete</td>
                            <td>
                                <asp:CheckBox ID="CanDeleteCheckBox" runat="server" Checked='<%# Bind("CanDelete") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewOwnProfile</td>
                            <td>
                                <asp:CheckBox ID="CanViewOwnProfileCheckBox" runat="server" Checked='<%# Bind("CanViewOwnProfile") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnCredentials</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnCredentialsCheckBox" runat="server" Checked='<%# Bind("CanEditOwnCredentials") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnProfile</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnProfileCheckBox" runat="server" Checked='<%# Bind("CanEditOwnProfile") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewReports</td>
                            <td>
                                <asp:CheckBox ID="CanViewReportsCheckBox" runat="server" Checked='<%# Bind("CanViewReports") %>' />
                            </td>
                        </tr>
                    </table>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource30" runat="server" meta:resourcekey="LiteralResource30">Name</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource31" runat="server" meta:resourcekey="LiteralResource31">Description</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="DescriptionTextBox" runat="server" Text='<%# Bind("Description") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>IsDefaultRole</td>
                            <td>
                                <asp:CheckBox ID="IsDefaultRoleCheckBox" runat="server" Checked='<%# Bind("IsDefaultRole") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>Level</td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlRoleLevel"
                                    SelectedValue='<%# Bind("RoleLevel") %>'>
                                    <asp:ListItem Text="0" Value="0" />
                                    <asp:ListItem Text="1" Value="1" />
                                    <asp:ListItem Text="2" Value="2" />
                                    <asp:ListItem Text="3" Value="3" />
                                    <asp:ListItem Text="4" Value="4" />
                                    <asp:ListItem Text="5" Value="5" />
                                    <asp:ListItem Text="6" Value="6" />
                                    <asp:ListItem Text="7" Value="7" />
                                    <asp:ListItem Text="8" Value="8" />
                                    <asp:ListItem Text="9" Value="9" />
                                    <asp:ListItem Text="10" Value="10" />
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewStatus</td>
                            <td>
                                <asp:CheckBox ID="CanViewStatusCheckBox" runat="server" Checked='<%# Bind("CanViewStatus") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanRemoteRelease</td>
                            <td>
                                <asp:CheckBox ID="CanRemoteReleaseCheckBox" runat="server" Checked='<%# Bind("CanRemoteRelease") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewUsers</td>
                            <td>
                                <asp:CheckBox ID="CanViewUsersCheckBox" runat="server" Checked='<%# Bind("CanViewUsers") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditUsers</td>
                            <td>
                                <asp:CheckBox ID="CanEditUsersCheckBox" runat="server" Checked='<%# Bind("CanEditUsers") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewGroups</td>
                            <td>
                                <asp:CheckBox ID="CanViewGroupsCheckBox" runat="server" Checked='<%# Bind("CanViewGroups") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditGroups</td>
                            <td>
                                <asp:CheckBox ID="CanEditGroupsCheckBox" runat="server" Checked='<%# Bind("CanEditGroups") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewKeyCops</td>
                            <td>
                                <asp:CheckBox ID="CanViewKeyCopsCheckBox" runat="server" Checked='<%# Bind("CanViewKeyCops") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditKeyCops</td>
                            <td>
                                <asp:CheckBox ID="CanEditKeyCopsCheckBox" runat="server" Checked='<%# Bind("CanEditKeyCops") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanViewKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanViewKeyConductors") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanEditKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanEditKeyConductors") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanSyncKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanSyncKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanSyncKeyConductors") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanExecuteInventory</td>
                            <td>
                                <asp:CheckBox ID="CanExecuteInventoryCheckBox" runat="server" Checked='<%# Bind("CanExecuteInventory") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewSites</td>
                            <td>
                                <asp:CheckBox ID="CanViewSitesCheckBox" runat="server" Checked='<%# Bind("CanViewSites") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditSites</td>
                            <td>
                                <asp:CheckBox ID="CanEditSitesCheckBox" runat="server" Checked='<%# Bind("CanEditSites") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditSettings</td>
                            <td>
                                <asp:CheckBox ID="CanEditSettingsCheckBox" runat="server" Checked='<%# Bind("CanEditSettings") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditAlerts</td>
                            <td>
                                <asp:CheckBox ID="CanEditAlertsCheckBox" runat="server" Checked='<%# Bind("CanEditAlerts") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditReports</td>
                            <td>
                                <asp:CheckBox ID="CanEditReportsCheckBox" runat="server" Checked='<%# Bind("CanEditReports") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditRoles</td>
                            <td>
                                <asp:CheckBox ID="CanEditRolesCheckBox" runat="server" Checked='<%# Bind("CanEditRoles") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewAllReservations</td>
                            <td>
                                <asp:CheckBox ID="CanViewAllReservationsCheckBox" runat="server" Checked='<%# Bind("CanViewAllReservations") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditAllReservations</td>
                            <td>
                                <asp:CheckBox ID="CanEditAllReservationsCheckBox" runat="server" Checked='<%# Bind("CanEditAllReservations") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewOwnReservations</td>
                            <td>
                                <asp:CheckBox ID="CanViewOwnReservationsCheckBox" runat="server" Checked='<%# Bind("CanViewOwnReservations") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnReservations</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnReservationsCheckBox" runat="server" Checked='<%# Bind("CanEditOwnReservations") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanDelete</td>
                            <td>
                                <asp:CheckBox ID="CanDeleteCheckBox" runat="server" Checked='<%# Bind("CanDelete") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewOwnProfile</td>
                            <td>
                                <asp:CheckBox ID="CanViewOwnProfileCheckBox" runat="server" Checked='<%# Bind("CanViewOwnProfile") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnCredentials</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnCredentialsCheckBox" runat="server" Checked='<%# Bind("CanEditOwnCredentials") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnProfile</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnProfileCheckBox" runat="server" Checked='<%# Bind("CanEditOwnProfile") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewReports</td>
                            <td>
                                <asp:CheckBox ID="CanViewReportsCheckBox" runat="server" Checked='<%# Bind("CanViewReports") %>' />
                            </td>
                        </tr>
                    </table>
                </InsertItemTemplate>
                <ItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource59" runat="server" meta:resourcekey="LiteralResource59">Name</asp:Literal></td>
                            <td>
                                <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource60" runat="server" meta:resourcekey="LiteralResource60">Description</asp:Literal></td>
                            <td>
                                <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>IsDefaultRole</td>
                            <td>
                                <asp:CheckBox ID="IsDefaultRoleCheckBox" runat="server" Checked='<%# Bind("IsDefaultRole") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>Level</td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlRoleLevel"
                                    SelectedValue='<%# Bind("RoleLevel") %>'
                                    Enabled="false">
                                    <asp:ListItem Text="0" Value="0" />
                                    <asp:ListItem Text="1" Value="1" />
                                    <asp:ListItem Text="2" Value="2" />
                                    <asp:ListItem Text="3" Value="3" />
                                    <asp:ListItem Text="4" Value="4" />
                                    <asp:ListItem Text="5" Value="5" />
                                    <asp:ListItem Text="6" Value="6" />
                                    <asp:ListItem Text="7" Value="7" />
                                    <asp:ListItem Text="8" Value="8" />
                                    <asp:ListItem Text="9" Value="9" />
                                    <asp:ListItem Text="10" Value="10" />
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewStatus</td>
                            <td>
                                <asp:CheckBox ID="CanViewStatusCheckBox" runat="server" Checked='<%# Bind("CanViewStatus") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanRemoteRelease</td>
                            <td>
                                <asp:CheckBox ID="CanRemoteReleaseCheckBox" runat="server" Checked='<%# Bind("CanRemoteRelease") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewUsers</td>
                            <td>
                                <asp:CheckBox ID="CanViewUsersCheckBox" runat="server" Checked='<%# Bind("CanViewUsers") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditUsers</td>
                            <td>
                                <asp:CheckBox ID="CanEditUsersCheckBox" runat="server" Checked='<%# Bind("CanEditUsers") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewGroups</td>
                            <td>
                                <asp:CheckBox ID="CanViewGroupsCheckBox" runat="server" Checked='<%# Bind("CanViewGroups") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditGroups</td>
                            <td>
                                <asp:CheckBox ID="CanEditGroupsCheckBox" runat="server" Checked='<%# Bind("CanEditGroups") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewKeyCops</td>
                            <td>
                                <asp:CheckBox ID="CanViewKeyCopsCheckBox" runat="server" Checked='<%# Bind("CanViewKeyCops") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditKeyCops</td>
                            <td>
                                <asp:CheckBox ID="CanEditKeyCopsCheckBox" runat="server" Checked='<%# Bind("CanEditKeyCops") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanViewKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanViewKeyConductors") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanEditKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanEditKeyConductors") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanSyncKeyConductors</td>
                            <td>
                                <asp:CheckBox ID="CanSyncKeyConductorsCheckBox" runat="server" Checked='<%# Bind("CanSyncKeyConductors") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanExecuteInventory</td>
                            <td>
                                <asp:CheckBox ID="CanExecuteInventoryCheckBox" runat="server" Checked='<%# Bind("CanExecuteInventory") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewSites</td>
                            <td>
                                <asp:CheckBox ID="CanViewSitesCheckBox" runat="server" Checked='<%# Bind("CanViewSites") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditSites</td>
                            <td>
                                <asp:CheckBox ID="CanEditSitesCheckBox" runat="server" Checked='<%# Bind("CanEditSites") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditSettings</td>
                            <td>
                                <asp:CheckBox ID="CanEditSettingsCheckBox" runat="server" Checked='<%# Bind("CanEditSettings") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditAlerts</td>
                            <td>
                                <asp:CheckBox ID="CanEditAlertsCheckBox" runat="server" Checked='<%# Bind("CanEditAlerts") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditReports</td>
                            <td>
                                <asp:CheckBox ID="CanEditReportsCheckBox" runat="server" Checked='<%# Bind("CanEditReports") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditRoles</td>
                            <td>
                                <asp:CheckBox ID="CanEditRolesCheckBox" runat="server" Checked='<%# Bind("CanEditRoles") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewAllReservations</td>
                            <td>
                                <asp:CheckBox ID="CanViewAllReservationsCheckBox" runat="server" Checked='<%# Bind("CanViewAllReservations") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditAllReservations</td>
                            <td>
                                <asp:CheckBox ID="CanEditAllReservationsCheckBox" runat="server" Checked='<%# Bind("CanEditAllReservations") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewOwnReservations</td>
                            <td>
                                <asp:CheckBox ID="CanViewOwnReservationsCheckBox" runat="server" Checked='<%# Bind("CanViewOwnReservations") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnReservations</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnReservationsCheckBox" runat="server" Checked='<%# Bind("CanEditOwnReservations") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanDelete</td>
                            <td>
                                <asp:CheckBox ID="CanDeleteCheckBox" runat="server" Checked='<%# Bind("CanDelete") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewOwnProfile</td>
                            <td>
                                <asp:CheckBox ID="CanViewOwnProfileCheckBox" runat="server" Checked='<%# Bind("CanViewOwnProfile") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnCredentials</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnCredentialsCheckBox" runat="server" Checked='<%# Bind("CanEditOwnCredentials") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanEditOwnProfile</td>
                            <td>
                                <asp:CheckBox ID="CanEditOwnProfileCheckBox" runat="server" Checked='<%# Bind("CanEditOwnProfile") %>' Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>CanViewReports</td>
                            <td>
                                <asp:CheckBox ID="CanViewReportsCheckBox" runat="server" Checked='<%# Bind("CanViewReports") %>' Enabled="false" />
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
