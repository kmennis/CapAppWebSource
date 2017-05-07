<%@ Page Title="Groups"
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    EnableEventValidation="false"
    CodeBehind="Groups.aspx.cs"
    Inherits="KCWebManager.Groups" %>

<%@ Register Src="~/Controls/EntityControl.ascx" TagPrefix="uc1" TagName="EntityControl" %>

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
                location.href = "Groups";
            }
            InitializeTabs();
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

        //var intSiteID = 0;
        //function InitializeDropDownSiteEdit() {
        //    jq("#ddlGroupEditSite").change(function () {
        //        jq("#spnSiteWarning").show();
        //    });
        //}

        jq(document).ready(function () {
            InitializeTabs();
            //InitializeDropDownSiteEdit();
        });

    </script>
</asp:Content>
<h1>Groups</h1>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_initializeRequest(InitializeRequestHandler)
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
    </script>

    <div class="Hidden">
        <asp:Label ID="resDeleteAlert" ClientIDMode="Static" Text="Are you sure you want to delete this group?" runat="server" meta:resourcekey="resDeleteAlert" />
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                SELECT g.[ID], g.[Name], g.[Description], g.[Enabled] 
                FROM [Group] g 
                INNER JOIN Bound_Site_User bsu ON bsu.Site_ID = g.SiteID
                WHERE (
                        (@SiteID != 0 AND [SiteID] = @SiteID) OR
                        (@SiteID = -1 AND [SiteID] IS NOT NULL)
                      ) AND
                      bsu.User_ID = @CurrentUserID
                ORDER BY g.[Name]"
                FilterExpression="(LEN('{0}') < 1) OR ([Description] LIKE '%{0}%' OR [Name] LIKE '%{0}%')">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlSiteFilter" Name="SiteID" PropertyName="SelectedValue" Type="Int32" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>
                <FilterParameters>
                    <asp:ControlParameter ControlID="txtSearch" Name="Search" PropertyName="Text" />
                </FilterParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsSingleGroup" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                DeleteCommand="DELETE FROM [Group] WHERE [ID] = @ID"
                InsertCommand="
                INSERT INTO [Group] ([SiteID], [Name], [Enabled], [Description], [Type]) VALUES (@SiteID, @Name, @Enabled, @Description, @Type)
                SELECT @NewGroupID = SCOPE_IDENTITY()"
                SelectCommand="SELECT * FROM [Group] WHERE ([ID] = @ID)"
                UpdateCommand="UPDATE [Group] SET [SiteID] = @SiteID, [Name] = @Name, [Enabled] = @Enabled, [Description] = @Description, [Type] = @Type WHERE [ID] = @ID"
                OnInserted="dsSingleGroup_Inserted"
                OnInserting="dsSingleGroup_Inserting"
                OnUpdating="dsSingleGroup_Updating">
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="SiteID" Type="Int32" />
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Type" Type="Byte" />
                    <asp:Parameter Name="NewGroupID" Type="Int32" Direction="Output" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdGroups" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="SiteID" Type="Int32" />
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Type" Type="Byte" />
                    <asp:Parameter Name="ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsSites" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                    SELECT s.[ID], s.[Name] 
                    FROM [Site] s 
                    INNER JOIN Bound_Site_User bsu ON s.ID = bsu.Site_ID
                    WHERE bsu.User_ID = @CurrentUserID
                    ORDER BY s.[Name]">
                <SelectParameters>
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <!-- Format() and IIF() are SQL server 2012+, use 2008 compatible query here with RIGHT and CASE -->
            <asp:SqlDataSource ID="dsUsersOLD" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT [ID], (RIGHT('0000' + CAST(UserID AS NVARCHAR(4)), 4) + ' - ' + (CASE WHEN Description IS NULL THEN '' ELSE Description END)) AS Name FROM [User] ORDER BY [UserID], [Description]"></asp:SqlDataSource>


            <asp:Panel ID="pnlGrid" runat="server">
                <asp:Panel ID="pnlFilter" runat="server" DefaultButton="btnSearch">
                    <table style="width: 100%;" class="tblFilter">
                        <tr>
                            <td style="width: 50%;">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="unwatermark" />
                                <ajaxToolkit:TextBoxWatermarkExtender ID="txtSearch_TextBoxWatermarkExtender" runat="server" BehaviorID="txtSearch_TextBoxWatermarkExtender" TargetControlID="txtSearch" WatermarkCssClass="watermark" WatermarkText="Search..." />
                                <asp:Button ID="btnSearch" runat="server" Text="&gt;" OnClick="btnSearch_Click" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlSiteFilter" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    OnSelectedIndexChanged="ddlSiteFilter_SelectedIndexChanged"
                                    AutoPostBack="true">
                                    <asp:ListItem Value="-1" Text="All sites" meta:resourcekey="ListItemResource0" />
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: right;">
                                <asp:DropDownList ID="ddlGridPageSize" runat="server" OnSelectedIndexChanged="ddlGridPageSize_SelectedIndexChanged" AutoPostBack="true" ToolTip="Select the number of records to display" meta:resourcekey="ddlGridPageSize">
                                    <asp:ListItem Value="15" Text="15"></asp:ListItem>
                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <asp:GridView ID="grdGroups" runat="server" AllowPaging="True" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="dsGroups"
                    PageSize="15" OnSelectedIndexChanged="grdGroups_SelectedIndexChanged"
                    OnRowDataBound="grdGroups_RowDataBound"
                    CssClass="Grid groups" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" meta:resourcekey="BoundFieldResource0" />
                        <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" meta:resourcekey="BoundFieldResource1" />
                        <asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" SortExpression="Enabled" meta:resourcekey="CheckBoxFieldResource0" />
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">No groups present.</asp:Literal>
                    </EmptyDataTemplate>
                </asp:GridView>
            </asp:Panel>

            <asp:FormView ID="fvwGroup" runat="server"
                DataSourceID="dsSingleGroup"
                DataKeyNames="ID"
                Width="624px"
                OnItemDeleted="fvwGroup_ItemDeleted"
                OnItemUpdating="fvwGroup_ItemUpdating"
                OnItemUpdated="fvwGroup_ItemUpdated"
                OnDataBound="fvwGroup_DataBound">
                <EditItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtGroupEditName" runat="server" Text='<%# Bind("Name") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Description:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtGroupEditDescription" runat="server" Text='<%# Bind("Description") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">Site:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlGroupEditSite" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlGroupEditSite_SelectedIndexChanged"
                                    SelectedValue='<%# Bind("SiteID") %>'>
                                </asp:DropDownList>
                                <asp:Panel ID="pnlSiteEditWarning" runat="server" Visible="false">
                                    <br />
                                    <img src="Content/FamFamFam/error.png" alt="Warning" /><asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">Changing the site will remove all users and KeyCops!</asp:Literal>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkGroupEditEnabled" runat="server" Checked='<%# Bind("Enabled") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Type:</asp:Literal></td>
                            <td>
                                <asp:HiddenField ID="hdnGroupEditType" runat="server" Value='<%# Bind("Type") %>' />
                                <asp:DropDownList ID="ddlGroupEditType" runat="server">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/user_link.png" />
                                <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Users</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/key_link.png" />
                                <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">KeyCops</asp:Literal></a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListEditGroup_BndUG" runat="server" ScrollBars="Both" Height="368px">
                                <asp:SqlDataSource ID="dsUsers" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                    SelectCommand="
                                        SELECT [User].[ID], 
                                               (RIGHT('0000' + CAST([User].UserID AS NVARCHAR(4)), 4) + ' - ' + (CASE WHEN [User].Description IS NULL THEN '' ELSE [User].Description END)) AS Name 
                                        FROM [User] left outer join dbo.Bound_Site_User ON dbo.[User].ID = dbo.Bound_Site_User.User_ID
                                        where Bound_Site_User.Site_ID = @SiteID
                                        ORDER BY [UserID], [Description]">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="SiteID" ControlID="ddlGroupEditSite" Type="Int32" PropertyName="SelectedValue" />
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:CheckBoxList ID="chkListEditGroup_BndUG" runat="server" DataSourceID="dsUsers" DataTextField="Name" DataValueField="ID" OnDataBound="chkListGroup_BndUG_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-2">
                            <asp:Panel ID="pnlListEditGroup_BndGK" runat="server" ScrollBars="Both" Height="368px">
                                <asp:SqlDataSource ID="dsKeyChains" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                    SelectCommand="
                                        SELECT [ID], ([KeyLabel] + ' - ' + [Description]) AS Name FROM [KeyChain] 
                                        WHERE [SiteID] = @SiteID
                                        ORDER BY [KeyLabel], [Description]">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="SiteID" ControlID="ddlGroupEditSite" Type="Int32" PropertyName="SelectedValue" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:CheckBoxList ID="chkListEditGroup_BndGK" runat="server" DataSourceID="dsKeyChains" DataTextField="Name" DataValueField="ID" OnDataBound="chkListGroup_BndGK_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                    </div>

                </EditItemTemplate>
                <InsertItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtGroupAddName" runat="server" Text='<%# Bind("Name") %>' />

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Description:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtGroupAddDescription" runat="server" Text='<%# Bind("Description") %>' />

                            </td>
                        </tr>
                        <tr>
                            <td><asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">Site:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlGroupAddSite" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    AutoPostBack="true"
                                    OnDataBound="ddlGroupAddSite_DataBound"
                                    SelectedValue='<%# Bind("SiteID") %>'>
                                </asp:DropDownList>

                                <asp:CustomValidator ID="ddlGroupAddSiteValidator" runat="server"
                                    ErrorMessage="Unable to add group. Maximum reached!"
                                    CssClass="warning"
                                    ControlToValidate="ddlGroupAddSite"
                                    OnServerValidate="ddlGroupAddSiteValidator_ServerValidate" meta:resourcekey="ddlGroupAddSiteValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkGroupAddEnabled" runat="server" Checked='<%# Bind("Enabled") %>' />

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Type:</asp:Literal></td>
                            <td>
                                <asp:HiddenField ID="hdnGroupAddType" runat="server" Value='<%# Bind("Type") %>' />
                                <asp:DropDownList ID="ddlGroupAddType" runat="server">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/user_link.png" />
                                <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">Users</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/key_link.png" />
                                <asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">KeyCops</asp:Literal></a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListAddGroup_BndUG" runat="server" ScrollBars="Both" Height="368px">
                                <asp:SqlDataSource ID="dsUsers" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                    SelectCommand="
                                        SELECT [User].[ID], 
                                               (RIGHT('0000' + CAST([User].UserID AS NVARCHAR(4)), 4) + ' - ' + (CASE WHEN [User].Description IS NULL THEN '' ELSE [User].Description END)) AS Name 
                                        FROM [User] left outer join dbo.Bound_Site_User ON dbo.[User].ID = dbo.Bound_Site_User.User_ID
                                        where Bound_Site_User.Site_ID = @SiteID
                                        ORDER BY [UserID], [Description]">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="SiteID" ControlID="ddlGroupAddSite" Type="Int32" PropertyName="SelectedValue" />
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:CheckBoxList ID="chkListAddGroup_BndUG" runat="server" DataSourceID="dsUsers" DataTextField="Name" DataValueField="ID">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-2">
                            <asp:Panel ID="pnlListAddGroup_BndGK" runat="server" ScrollBars="Both" Height="368px">
                                <asp:SqlDataSource ID="dsKeyChains" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                    SelectCommand="
                                        SELECT [ID], ([KeyLabel] + ' - ' + [Description]) AS Name FROM [KeyChain] 
                                        WHERE [SiteID] = @SiteID
                                        ORDER BY [KeyLabel], [Description]">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="SiteID" ControlID="ddlGroupAddSite" Type="Int32" PropertyName="SelectedValue" />
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:CheckBoxList ID="chkListAddGroup_BndGK" runat="server" DataSourceID="dsKeyChains" DataTextField="Name" DataValueField="ID">
                                </asp:CheckBoxList>

                            </asp:Panel>
                        </div>
                    </div>

                </InsertItemTemplate>
                <ItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">Name:</asp:Literal></td>
                            <td>
                                <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">Description:</asp:Literal></td>
                            <td>
                                <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' /></td>
                        </tr>
                        <tr>
                            <td><asp:Literal ID="LiteralResource22" runat="server" meta:resourcekey="LiteralResource22">Site:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlGroupViewSite" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    Enabled="false"
                                    SelectedValue='<%# Bind("SiteID") %>'>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="EnabledCheckBox" runat="server" Checked='<%# Bind("Enabled") %>' Enabled="false" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">Type:</asp:Literal></td>
                            <td>
                                <asp:HiddenField ID="hdnGroupViewType" runat="server" Value='<%# Bind("Type") %>' />
                                <asp:DropDownList ID="ddlGroupViewType" runat="server" Enabled="false">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/user_link.png" />
                                <asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">Users</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/key_link.png" />
                                <asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">KeyCops</asp:Literal></a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListViewGroup_BndUG" runat="server" ScrollBars="Both" Height="368px">
                                <asp:SqlDataSource ID="dsUsers" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                    SelectCommand="
                                        SELECT [User].[ID], 
                                               (RIGHT('0000' + CAST([User].UserID AS NVARCHAR(4)), 4) + ' - ' + (CASE WHEN [User].Description IS NULL THEN '' ELSE [User].Description END)) AS Name 
                                        FROM [User] left outer join dbo.Bound_Site_User ON dbo.[User].ID = dbo.Bound_Site_User.User_ID
                                        where Bound_Site_User.Site_ID = @SiteID
                                        ORDER BY [UserID], [Description]">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="SiteID" ControlID="ddlGroupViewSite" Type="Int32" PropertyName="SelectedValue" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:CheckBoxList ID="chkListViewGroup_BndUG" runat="server" Enabled="false" DataSourceID="dsUsers" DataTextField="Name" DataValueField="ID" OnDataBound="chkListGroup_BndUG_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-2">
                            <asp:Panel ID="pnlListViewGroup_BndGK" runat="server" ScrollBars="Both" Height="368px">
                                <asp:SqlDataSource ID="dsKeyChains" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                    SelectCommand="
                                        SELECT [ID], ([KeyLabel] + ' - ' + [Description]) AS Name FROM [KeyChain] 
                                        WHERE [SiteID] = @SiteID
                                        ORDER BY [KeyLabel], [Description]">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="SiteID" ControlID="ddlGroupViewSite" Type="Int32" PropertyName="SelectedValue" />
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:CheckBoxList ID="chkListViewGroup_BndGK" runat="server" Enabled="false" DataSourceID="dsKeyChains" DataTextField="Name" DataValueField="ID" OnDataBound="chkListGroup_BndGK_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                    </div>

                </ItemTemplate>
            </asp:FormView>

            <uc1:EntityControl runat="server" ID="EntityControl"
                OnClicked="EntityControl_Clicked" />
            <br />

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
