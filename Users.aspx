<%@ Page Title=""
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    EnableEventValidation="false"
    CodeBehind="Users.aspx.cs"
    Inherits="KCWebManager.Users" %>

<%@ Register Src="~/Controls/EntityControl.ascx" TagPrefix="uc1" TagName="EntityControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Scripts/passfield/js/passfield.js"></script>
    <script src="Scripts/passfield/js/locales.js"></script>
    <link rel="stylesheet" type="text/css" href="Scripts/passfield/css/passfield.css" />

    <script type="text/javascript">

        var selected_tab = "";

        function InitializeRequestHandler(sender, args) {
            // if it is the delete action, ask for confirmation before actual delete happens
            if (args.get_postBackElement().id == 'btnEntityControlDelete') {
                if (confirm(jq("#resDeleteAlert").text()) == false) {
                    args.set_cancel(true);
                }
            }
            else if (args.get_postBackElement().id == 'btnEntityControlSave') {
                // Validate the password (if entered)
                if (jq("#txtUserAddPassword, #txtUserEditPassword").val().length > 0 && jq("#txtUserAddPassword, #txtUserEditPassword").validatePass() == false) {
                    jq("#txtUserAddPassword, #txtUserEditPassword").focus();
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
                location.href = "Users";
            }

            InitializeTabs();
            InitializeSpinners();
            InitializePassField();

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
            jq("#tabs").css('width','100%');
            jq("#tabs").height(475);
        }


        function InitializeSpinners() {
            try {
                if (jq('#txtUserAddStartTime').length > 0) {
                    // Add - mode
                    jq('#txtUserAddStartTime').spinner({
                        min: 0,
                        max: 23
                    });

                    jq('#txtUserAddEndTime').spinner({
                        min: 0,
                        max: 23
                    });

                    jq('#txtUserAddMaxPickAllowed').spinner({
                        min: 1,
                        max: 255
                    });

                }

                if (jq('#txtUserEditStartTime').length > 0) {
                    // Edit - mode
                    jq('#txtUserEditStartTime').spinner({
                        min: 0,
                        max: 23
                    });

                    jq('#txtUserEditEndTime').spinner({
                        min: 0,
                        max: 23
                    });

                    jq('#txtUserEditMaxPickAllowed').spinner({
                        min: 1,
                        max: 255
                    });

                }


            } catch (e) {
                alert(e.message);
            }
        }

        function InitializePassField() {
            var passFieldLocale = 'en';
            switch (PageCulture) // from KCWebMgr.Master
            {
                // PassField: en, de, fr, it, nl, ru, au, es, el, pt
                // KeyCopWM : "de-DE", "en-US", "fr-FR", "nl-NL", "sv-SE"
                case 'de-DE':
                    passFieldLocale = 'de';
                    break;
                case 'fr-FR':
                    passFieldLocale = 'fr';
                    break;
                case 'nl-NL':
                    passFieldLocale = 'nl';
                    break;
            }

            var pwLengthMin = 6;
            var pwPattern = "abc123";
            var pwAcceptRate = 0.4;

            var pwComplexity = jq("#hdnPasswordComplexity").val();
            switch (pwComplexity) {
                case '1': // Medium
                    pwLengthMin = 8;
                    pwPattern = "aAbBcC12";
                    pwAcceptRate = 0.7;
                    break;
                case '2': // High
                    pwLengthMin = 12;
                    pwPattern = "aAbBcC$123$b";
                    pwAcceptRate = 0.8;
                    break;
            }


            jq("#txtUserAddPassword, #txtUserEditPassword").passField({
                locale: passFieldLocale,
                errorWrapClassName: "",
                length: { min: pwLengthMin },
                pattern: pwPattern,
                acceptRate: pwAcceptRate,
            });

            var txtPin = jq("#txtUserAddUserPin, #txtUserEditUserPin")
            if (txtPin != undefined && txtPin.length > 0) {
                locale: passFieldLocale,

                // The PINCode cannot be complex (1-9999)
                // Leave the nice random and unhide buttons in place
                txtPin.passField({
                    chars: {
                        digits: "1234567890",
                    },
                    length: { min: 4, max: 4 },
                    errorWrapClassName: "",
                    pattern: "1234",
                    acceptRate: 0,
                    allowEmpty: false,
                    allowAnyChars: false,
                    showWarn: false,
                    showTip: false
                });

                // prefix with zeros if needed
                var pinLength = txtPin.val().length;
                if (pinLength == 1) txtPin.setPass("000" + txtPin.val());
                else if (pinLength == 2) txtPin.setPass("00" + txtPin.val());
                else if (pinLength == 3) txtPin.setPass("0" + txtPin.val());
            }
        }

        jq(document).ready(function () {
            InitializeTabs();
            InitializeSpinners();
            InitializePassField();
        });

    </script>

</asp:Content>
<h1>Users</h1>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_initializeRequest(InitializeRequestHandler)
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
    </script>

    <div class="Hidden">
        <asp:Label ID="resDeleteAlert" ClientIDMode="Static" Text="Are you sure you want to delete this user?" runat="server" meta:resourcekey="resDeleteAlert" />
        <asp:HiddenField ID="hdnPasswordComplexity" runat="server" ClientIDMode="Static" Value="0" />
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:SqlDataSource ID="dsUsers" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand=" 
                    -- !! This query is loaded in LoadFilteredUsersSQL() !! --
                    SELECT 
                        [User].[ID], 
                        [User].[Username], 
                        [User].[UserID], 
                        [User].[Description], 
                        [User].[Enabled],
                        [Role].[Name] AS RoleName
                    FROM [User]
                    INNER JOIN [Role] ON [User].[RoleID] = [Role].[ID]"
                FilterExpression="(LEN('{0}') < 1) OR ([Description] LIKE '%{0}%' OR [Username] LIKE '%{0}%' OR CONVERT([UserID], 'System.String') LIKE '%{0}%')">
                <FilterParameters>
                    <asp:ControlParameter ControlID="txtSearch" Name="Search" PropertyName="Text" />
                </FilterParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="dsSingleUser" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                DeleteCommand="DELETE FROM [User] WHERE [ID] = @ID"
                InsertCommand="
                    INSERT INTO [User] (
                        [Username], [Password], [UserID], [UserPin], [Description], [Flags], [RoleID], [StartTime], [EndTime], [Enabled], 
                        [Gender], [BeginContract], [EndContract], [Phonenumber1], [Phonenumber2], [EMail1], [EMail2], 
                        [Address], [Postalcode], [City], [Country], [Language], [Title], [Firstname], [Middlename], [Lastname], 
                        [Swipecard], [MaxPickAllowed], 
                        [AddedOn], [AddedBy],
                        [PasswordExpiresOn], [PincodeExpiresOn]) 
                    VALUES (@Username, @Password, @UserID, @UserPin, @Description, @Flags, @RoleID, @StartTime, @EndTime, @Enabled, 
                        @Gender, @BeginContract, @EndContract, @Phonenumber1, @Phonenumber2, @EMail1, @EMail2, 
                        @Address, @Postalcode, @City, @Country, @Language, @Title, @Firstname, @Middlename, @Lastname, 
                        @Swipecard, @MaxPickAllowed,
                        GETDATE(), @CurrentUserID,
                        @PasswordExpiresOn, @PincodeExpiresOn)
                    SELECT @NewUserID = SCOPE_IDENTITY()"
                SelectCommand="
                    SELECT 
                        [ID], [Username], [Password], [UserID], [UserPin], [Description], [Flags], [RoleID], [StartTime], [EndTime], [Enabled], [Gender], 
                        [BeginContract], [EndContract], [Phonenumber1], [Phonenumber2], [EMail1], [EMail2], [Address], [Postalcode], [City], [Country], [Language], 
                        [Title], [Firstname], [Middlename], [Lastname], [Swipecard], [MaxPickAllowed], [PasswordExpiresOn], [PincodeExpiresOn]
                    FROM [User] 
                    WHERE ([ID] = @ID)"
                UpdateCommand="
                    UPDATE [User] 
                    SET [Username] = @Username, [Password] = @Password, [UserID] = @UserID, [UserPin] = @UserPin, [Description] = @Description, 
                        [Flags] = @Flags, [RoleID] = @RoleID, [StartTime] = @StartTime, [EndTime] = @EndTime, [Enabled] = @Enabled, [Gender] = @Gender, 
                        [BeginContract] = @BeginContract, [EndContract] = @EndContract, [Phonenumber1] = @Phonenumber1, [Phonenumber2] = @Phonenumber2, 
                        [EMail1] = @EMail1, [EMail2] = @EMail2, [Address] = @Address, [Postalcode] = @Postalcode, [City] = @City, [Country] = @Country, 
                        [Language] = @Language, [Title] = @Title, [Firstname] = @Firstname, [Middlename] = @Middlename, [Lastname] = @Lastname, 
                        [Swipecard] = @Swipecard, [MaxPickAllowed] = @MaxPickAllowed,
                        [ModifiedOn] = GETDATE(), [ModifiedBy] = @CurrentUserID, 
                        [PasswordChangedOn] = @PasswordChangedOn, [PasswordChangedBy] = @PasswordChangedBy,
                        [PasswordExpiresOn] = @PasswordExpiresOn, [PincodeExpiresOn] = @PincodeExpiresOn
                    WHERE [ID] = @ID"
                OnInserted="dsSingleUser_Inserted"
                OnInserting="dsSingleUser_Inserting"
                OnUpdating="dsSingleUser_Updating">
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Username" Type="String" />
                    <asp:Parameter Name="Password" Type="String" />
                    <asp:Parameter Name="UserID" Type="Int16" />
                    <asp:Parameter Name="UserPin" Type="Int16" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Flags" Type="Byte" />
                    <asp:Parameter Name="RoleID" Type="Int32" />
                    <asp:Parameter Name="StartTime" Type="Byte" />
                    <asp:Parameter Name="EndTime" Type="Byte" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="Gender" Type="Byte" />
                    <asp:Parameter Name="BeginContract" Type="DateTime" />
                    <asp:Parameter Name="EndContract" Type="DateTime" />
                    <asp:Parameter Name="Phonenumber1" Type="String" />
                    <asp:Parameter Name="Phonenumber2" Type="String" />
                    <asp:Parameter Name="EMail1" Type="String" />
                    <asp:Parameter Name="EMail2" Type="String" />
                    <asp:Parameter Name="Address" Type="String" />
                    <asp:Parameter Name="Postalcode" Type="String" />
                    <asp:Parameter Name="City" Type="String" />
                    <asp:Parameter Name="Country" Type="String" />
                    <asp:Parameter Name="Language" Type="String" />
                    <asp:Parameter Name="Title" Type="String" />
                    <asp:Parameter Name="Firstname" Type="String" />
                    <asp:Parameter Name="Middlename" Type="String" />
                    <asp:Parameter Name="Lastname" Type="String" />
                    <asp:Parameter Name="Swipecard" Type="String" />
                    <asp:Parameter Name="MaxPickAllowed" Type="Byte" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                    <asp:Parameter Name="PasswordChangedOn" Type="DateTime" />
                    <asp:Parameter Name="PasswordChangedBy" Type="Int32" />
                    <asp:Parameter Name="PasswordExpiresOn" Type="DateTime" />
                    <asp:Parameter Name="PincodeExpiresOn" Type="DateTime" />
                    <asp:Parameter Direction="Output" Name="NewUserID" Type="Int32" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdUsers" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Username" Type="String" />
                    <asp:Parameter Name="Password" Type="String" />
                    <asp:Parameter Name="UserID" Type="Int16" />
                    <asp:Parameter Name="UserPin" Type="Int16" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Flags" Type="Byte" />
                    <asp:Parameter Name="RoleID" Type="Int32" />
                    <asp:Parameter Name="StartTime" Type="Byte" />
                    <asp:Parameter Name="EndTime" Type="Byte" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="Gender" Type="Byte" />
                    <asp:Parameter Name="BeginContract" Type="DateTime" />
                    <asp:Parameter Name="EndContract" Type="DateTime" />
                    <asp:Parameter Name="Phonenumber1" Type="String" />
                    <asp:Parameter Name="Phonenumber2" Type="String" />
                    <asp:Parameter Name="EMail1" Type="String" />
                    <asp:Parameter Name="EMail2" Type="String" />
                    <asp:Parameter Name="Address" Type="String" />
                    <asp:Parameter Name="Postalcode" Type="String" />
                    <asp:Parameter Name="City" Type="String" />
                    <asp:Parameter Name="Country" Type="String" />
                    <asp:Parameter Name="Language" Type="String" />
                    <asp:Parameter Name="Title" Type="String" />
                    <asp:Parameter Name="Firstname" Type="String" />
                    <asp:Parameter Name="Middlename" Type="String" />
                    <asp:Parameter Name="Lastname" Type="String" />
                    <asp:Parameter Name="Swipecard" Type="String" />
                    <asp:Parameter Name="MaxPickAllowed" Type="Byte" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                    <asp:Parameter Name="PasswordChangedOn" Type="DateTime" />
                    <asp:Parameter Name="PasswordChangedBy" Type="Int32" />
                    <asp:Parameter Name="PasswordExpiresOn" Type="DateTime" />
                    <asp:Parameter Name="PincodeExpiresOn" Type="DateTime" />
                    <asp:Parameter Name="ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsRoles" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT [ID], [Name] FROM [Role]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="dsSites" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT Site.ID, Site.Name FROM Site
                LEFT OUTER JOIN Bound_Site_User ON Site.ID = Bound_Site_User.Site_ID 
                WHERE ( 1 = @CurrentRoleCanViewSites OR
                        Bound_Site_User.User_ID = @CurrentUserID)
                GROUP BY Site.ID, Site.Name
                ORDER BY Site.Name">
                <SelectParameters>
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                    <asp:SessionParameter Name="CurrentRoleCanViewSites" DefaultValue="0" SessionField="CurrentRoleCanViewSites" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:Panel ID="pnlGrid" runat="server">
                <asp:Panel ID="pnlFilter" runat="server" DefaultButton="btnSearch">
                    <table style="width: 100%;" class="tblFilter">
                        <tr>
                            <td style="width: 50%;">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="unwatermark" />
                                <ajaxToolkit:TextBoxWatermarkExtender ID="txtSearch_TextBoxWatermarkExtender" runat="server" BehaviorID="txtSearch_TextBoxWatermarkExtender" TargetControlID="txtSearch" WatermarkCssClass="watermark" />
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
                                    <asp:ListItem Value="-2" Text="No site" meta:resourcekey="ListItemResource1" />
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: right;">
                                <asp:DropDownList ID="ddlGridPageSize" runat="server" OnSelectedIndexChanged="ddlGridPageSize_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem Value="15" Text="15"></asp:ListItem>
                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <asp:GridView ID="grdUsers" runat="server" AllowPaging="True" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="dsUsers" PageSize="15"
                    OnSelectedIndexChanged="grdUsers_SelectedIndexChanged"
                    OnRowDataBound="grdUsers_RowDataBound"
                    CssClass="Grid users" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                    <Columns>
                        <asp:CommandField ShowSelectButton="True" Visible="false" />
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" Visible="false" meta:resourcekey="BoundFieldResource0" />
                        <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" meta:resourcekey="BoundFieldResource1" />
                        <asp:BoundField DataField="UserID" HeaderText="UserID" SortExpression="UserID" DataFormatString="{0:0000}" meta:resourcekey="BoundFieldResource2" />
                        <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" meta:resourcekey="BoundFieldResource3" />
                        <asp:BoundField DataField="RoleName" HeaderText="Role" SortExpression="RoleName" />

                        <asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" SortExpression="Enabled" meta:resourcekey="CheckBoxFieldResource0" />
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">No users present.</asp:Literal>
                    </EmptyDataTemplate>
                </asp:GridView>

            </asp:Panel>

            <asp:FormView ID="fvwUser" runat="server"
                DataKeyNames="ID"
                DataSourceID="dsSingleUser"
                OnItemUpdating="fvwUser_ItemUpdating"
                OnItemUpdated="fvwUser_ItemUpdated"
                Width="100%"
                OnItemDeleted="fvwUser_ItemDeleted"
                OnItemDeleting="fvwUser_ItemDeleting"
                OnDataBound="fvwUser_DataBound">
                <EditItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">UserID:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserEditUserID" runat="server" Text='<%# Bind("UserID") %>' MaxLength="4" />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtUserEditUserIDExt" runat="server" TargetControlID="txtUserEditUserID" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtUserEditUserIDValidator" runat="server"
                                    ErrorMessage="User ID must be unique"
                                    ValidateEmptyText="true"
                                    CssClass="error"
                                    ControlToValidate="txtUserEditUserID"
                                    OnServerValidate="txtUserUserIDValidator_ServerValidate"
                                    meta:resourcekey="txtUserEditUserIDValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">UserPin:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserEditUserPin" ClientIDMode="Static" runat="server" Text='<%# Bind("UserPin") %>' MaxLength="4" />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtUserEditUserPinExt" runat="server"
                                    TargetControlID="txtUserEditUserPin"
                                    FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtUserEditUserPinValidator" runat="server"
                                    ErrorMessage="PIN code must be unique"
                                    ValidateEmptyText="true"
                                    CssClass="error"
                                    ControlToValidate="txtUserEditUserPin"
                                    OnServerValidate="txtUserUserPinValidator_ServerValidate"
                                    meta:resourcekey="txtUserEditUserPinValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Description:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserEditDescription" runat="server" Text='<%# Bind("Description") %>' MaxLength="16" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Username:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserEditUsername" runat="server" MaxLength="100" Text='<%# Bind("Username") %>' />
                                <asp:CustomValidator ID="txtUserEditUsernameValidator" runat="server"
                                    ErrorMessage="Username must be unique"
                                    ValidateEmptyText="true"
                                    CssClass="error"
                                    ControlToValidate="txtUserEditUsername"
                                    OnServerValidate="txtUserUsernameValidator_ServerValidate" meta:resourcekey="txtUserEditUsernameValidator"></asp:CustomValidator>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Password:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserEditPassword" ClientIDMode="Static" runat="server" MaxLength="100" Text='<%# Bind("Password") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Swipecard:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserEditSwipecard" runat="server" MaxLength="64" Text='<%# Bind("Swipecard") %>' />
                                <asp:CustomValidator ID="txtUserEditSwipecardValidator" runat="server"
                                    ErrorMessage="Swipecard data must be unique"
                                    ValidateEmptyText="true"
                                    CssClass="error"
                                    ControlToValidate="txtUserEditSwipecard"
                                    OnServerValidate="txtUserSwipecardValidator_ServerValidate" meta:resourcekey="txtUserEditSwipecardValidator">
                                </asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkUserEditEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource63" runat="server" meta:resourcekey="LiteralResource63">Role:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlUserEditRole" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsRoles"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    SelectedValue='<%# Bind("RoleID") %>'>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/building_link.png" />
                                <asp:Literal ID="LiteralResource67" runat="server" meta:resourcekey="LiteralResource67">Sites</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/group_link.png" />
                                <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Groups</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Constraints</asp:Literal></a></li>
                            <li><a href="#tabs-4">
                                <img src="Content/FamFamFam/user.png" />
                                <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Other</asp:Literal></a></li>
                        </ul>

                        <div id="tabs-1">
                            <asp:Panel ID="pnlListEditUser_BndSU" runat="server" ScrollBars="Both" Height="368px">
                                <asp:CheckBoxList ID="chkListEditUser_BndSU" runat="server"
                                    DataSourceID="dsSites"
                                    DataTextField="Name"
                                    DataValueField="ID"
                                    OnDataBound="chkListUser_BndSU_DataBound"
                                    AutoPostBack="true">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>

                        <div id="tabs-2">
                            <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                SelectCommand="SELECT [ID], [Name] FROM [Group] ORDER BY [Name]"
                                OnLoad="dsGroups_Load"></asp:SqlDataSource>

                            <asp:Panel ID="pnlListEditUser_BndUG" runat="server" ScrollBars="Both" Height="368px">
                                <asp:CheckBoxList ID="chkListEditUser_BndUG" runat="server"
                                    DataSourceID="dsGroups"
                                    DataTextField="Name"
                                    DataValueField="ID"
                                    OnDataBound="chkListUser_BndUG_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>

                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">Flags:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnUserEditFlags" runat="server" Value='<%# Bind("Flags") %>' />
                                        <asp:CheckBox ID="chkUserEditFlagSunday" runat="server" Text="Sunday" meta:resourcekey="chkUserEditFlagSunday" /><br />
                                        <asp:CheckBox ID="chkUserEditFlagMonday" runat="server" Text="Monday" meta:resourcekey="chkUserEditFlagMonday" /><br />
                                        <asp:CheckBox ID="chkUserEditFlagTuesday" runat="server" Text="Tuesday" meta:resourcekey="chkUserEditFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkUserEditFlagWednesday" runat="server" Text="Wednesday" meta:resourcekey="chkUserEditFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkUserEditFlagThursday" runat="server" Text="Thursday" meta:resourcekey="chkUserEditFlagThursday" /><br />
                                        <asp:CheckBox ID="chkUserEditFlagFriday" runat="server" Text="Friday" meta:resourcekey="chkUserEditFlagFriday" /><br />
                                        <asp:CheckBox ID="chkUserEditFlagSaturday" runat="server" Text="Saturday" meta:resourcekey="chkUserEditFlagSaturday" /><br />
                                        <br />
                                        <asp:CheckBox ID="chkUserEditFlagSupervisor" runat="server" Text="Supervisor access" meta:resourcekey="chkUserEditFlagSupervisor" />

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">StartTime:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditStartTime" ClientIDMode="Static" runat="server" Text='<%# Bind("StartTime") %>' />
                                        <ajaxToolkit:FilteredTextBoxExtender ID="txtUserEditStartTimeFilterExt" runat="server" TargetControlID="txtUserEditStartTime" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">EndTime:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditEndTime" ClientIDMode="Static" runat="server" Text='<%# Bind("EndTime") %>' />
                                        <ajaxToolkit:FilteredTextBoxExtender ID="txtUserEditEndTimeFilterExt" runat="server" TargetControlID="txtUserEditEndTime" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">BeginContract:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditBeginContract" runat="server" Text='<%# Bind("BeginContract") %>' />
                                        <ajaxToolkit:CalendarExtender ID="txtUserEditBeginContractExt" runat="server" TargetControlID="txtUserEditBeginContract" TodaysDateFormat="d" Format="d"></ajaxToolkit:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">EndContract:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditEndContract" runat="server" Text='<%# Bind("EndContract") %>' />
                                        <ajaxToolkit:CalendarExtender ID="txtUserEditEndContractExt" runat="server" TargetControlID="txtUserEditEndContract" TodaysDateFormat="d" Format="d"></ajaxToolkit:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">MaxPickAllowed:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditMaxPickAllowed" ClientIDMode="Static" runat="server" Text='<%# Bind("MaxPickAllowed") %>' />
                                        <ajaxToolkit:FilteredTextBoxExtender ID="txtUserEditMaxPickAllowedFilterExt" runat="server" TargetControlID="txtUserEditMaxPickAllowed" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="tabs-4">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">Firstname:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditFirstname" MaxLength="100" runat="server" Text='<%# Bind("Firstname") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">Middlename:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditMiddlename" MaxLength="100" runat="server" Text='<%# Bind("Middlename") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">Lastname:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditLastname" MaxLength="100" runat="server" Text='<%# Bind("Lastname") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">Gender:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnUserEditGender" runat="server" Value='<%# Bind("Gender") %>' />
                                        <asp:DropDownList ID="ddlUserEditGender" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">Phonenumber1:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditPhonenumber1" MaxLength="16" runat="server" Text='<%# Bind("Phonenumber1") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource22" runat="server" meta:resourcekey="LiteralResource22">Phonenumber2:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditPhonenumber2" MaxLength="16" runat="server" Text='<%# Bind("Phonenumber2") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource23" runat="server" meta:resourcekey="LiteralResource23">EMail1:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditEMail1" MaxLength="100" runat="server" Text='<%# Bind("EMail1") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource24" runat="server" meta:resourcekey="LiteralResource24">EMail2:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditEMail2" MaxLength="100" runat="server" Text='<%# Bind("EMail2") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource25" runat="server" meta:resourcekey="LiteralResource25">Address:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditAddress" MaxLength="100" runat="server" Text='<%# Bind("Address") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource26" runat="server" meta:resourcekey="LiteralResource26">Postalcode:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditPostalcode" MaxLength="100" runat="server" Text='<%# Bind("Postalcode") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource27" runat="server" meta:resourcekey="LiteralResource27">City:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditCity" MaxLength="100" runat="server" Text='<%# Bind("City") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource28" runat="server" meta:resourcekey="LiteralResource28">Country:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditCountry" MaxLength="100" runat="server" Text='<%# Bind("Country") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource29" runat="server" meta:resourcekey="LiteralResource29">Language:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnUserEditLanguage" Value='<%# Bind("Language") %>' runat="server" />
                                        <asp:DropDownList ID="ddlUserEditLanguage" runat="server">
                                            <asp:ListItem Value="" Text="Not set, use default" meta:resourcekey="ListItemResource6"/>
                                            <asp:ListItem Value="de-DE" Text="de-DE"/>
                                            <asp:ListItem Value="en-US" Text="en-US"/>
                                            <asp:ListItem Value="fr-FR" Text="fr-FR" />
                                            <asp:ListItem Value="nl-NL" Text="nl-NL" />
                                            <asp:ListItem Value="sv-SE" Text="sv-SE" />
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource30" runat="server" meta:resourcekey="LiteralResource30">Title:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserEditTitle" MaxLength="100" runat="server" Text='<%# Bind("Title") %>' /></td>
                                </tr>
                            </table>
                        </div>
                    </div>

                </EditItemTemplate>
                <InsertItemTemplate>

                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource31" runat="server" meta:resourcekey="LiteralResource31">UserID:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserAddUserID" runat="server" 
                                    Text='<%# Bind("UserID") %>' 
                                    MaxLength="4" />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtUserAddUserIDExt" runat="server" 
                                    FilterType="Numbers" 
                                    TargetControlID="txtUserAddUserID"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtUserAddUserIDValidator" runat="server" 
                                    ErrorMessage="User ID must be unique" 
                                    ValidateEmptyText="true" 
                                    CssClass="error" 
                                    ControlToValidate="txtUserAddUserID" 
                                    OnServerValidate="txtUserUserIDValidator_ServerValidate" 
                                    meta:resourcekey="txtUserAddUserIDValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource32" runat="server" meta:resourcekey="LiteralResource32">UserPin:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserAddUserPin" ClientIDMode="Static" runat="server" Text='<%# Bind("UserPin") %>' MaxLength="4" />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtUserAddUserPinExt" runat="server"
                                    TargetControlID="txtUserAddUserPin"
                                    FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtUserAddUserPinValidator" runat="server"
                                    ErrorMessage="PIN code must be unique"
                                    ValidateEmptyText="true"
                                    CssClass="error"
                                    ControlToValidate="txtUserAddUserPin"
                                    OnServerValidate="txtUserUserPinValidator_ServerValidate"
                                    meta:resourcekey="txtUserAddUserPinValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource33" runat="server" meta:resourcekey="LiteralResource33">Description:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserAddDescription" runat="server" Text='<%# Bind("Description") %>' MaxLength="16" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource34" runat="server" meta:resourcekey="LiteralResource34">Username:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserAddUsername" runat="server" MaxLength="100" Text='<%# Bind("Username") %>' />
                                <asp:CustomValidator ID="txtUserAddUsernameValidator" runat="server"
                                    ErrorMessage="Username must be unique"
                                    ValidateEmptyText="true"
                                    CssClass="error"
                                    ControlToValidate="txtUserAddUsername"
                                    OnServerValidate="txtUserUsernameValidator_ServerValidate"
                                    meta:resourcekey="txtUserAddUsernameValidator"></asp:CustomValidator>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource35" runat="server" meta:resourcekey="LiteralResource35">Password:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserAddPassword" ClientIDMode="Static" runat="server" MaxLength="100" Text='<%# Bind("Password") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource36" runat="server" meta:resourcekey="LiteralResource36">Swipecard:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtUserAddSwipecard" runat="server" MaxLength="64" Text='<%# Bind("Swipecard") %>' />
                                <asp:CustomValidator ID="txtUserAddSwipecardValidator" runat="server"
                                    ErrorMessage="Swipecard data must be unique"
                                    ValidateEmptyText="true"
                                    CssClass="error"
                                    ControlToValidate="txtUserAddSwipecard"
                                    OnServerValidate="txtUserSwipecardValidator_ServerValidate" meta:resourcekey="txtUserAddSwipecardValidator">
                                </asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource37" runat="server" meta:resourcekey="LiteralResource37">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkUserAddEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource93" runat="server" meta:resourcekey="LiteralResource93">Role:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlUserAddRole" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsRoles"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    SelectedValue='<%# Bind("RoleID") %>'>
                                </asp:DropDownList>
                            </td>
                        </tr>

                    </table>
                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/building_link.png" />
                                <asp:Literal ID="LiteralResource94" runat="server" meta:resourcekey="LiteralResource94">Sites</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/group_link.png" />
                                <asp:Literal ID="LiteralResource38" runat="server" meta:resourcekey="LiteralResource38">Groups</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource39" runat="server" meta:resourcekey="LiteralResource39">Constraints</asp:Literal></a></li>
                            <li><a href="#tabs-4">
                                <img src="Content/FamFamFam/user.png" />
                                <asp:Literal ID="LiteralResource40" runat="server" meta:resourcekey="LiteralResource40">Other</asp:Literal></a></li>
                        </ul>

                        <div id="tabs-1">
                            <asp:Panel ID="pnlListAddUser_BndSU" runat="server" ScrollBars="Both" Height="368px">
                                <asp:CheckBoxList ID="chkListAddUser_BndSU" runat="server"
                                    DataSourceID="dsSites"
                                    DataTextField="Name"
                                    DataValueField="ID"
                                    AutoPostBack="true">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>

                        <div id="tabs-2">
                            <asp:Panel ID="pnlListAddUser_BndUG" runat="server" ScrollBars="Both" Height="368px">
                                <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                    SelectCommand="SELECT [ID], [Name] FROM [Group] ORDER BY [Name]"
                                    OnLoad="dsGroups_Load"></asp:SqlDataSource>

                                <asp:CheckBoxList ID="chkListAddUser_BndUG" runat="server"
                                    DataSourceID="dsGroups"
                                    DataTextField="Name"
                                    DataValueField="ID">
                                </asp:CheckBoxList>

                            </asp:Panel>
                        </div>

                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource41" runat="server" meta:resourcekey="LiteralResource41">Flags:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnUserAddFlags" runat="server" Value='<%# Bind("Flags") %>' />
                                        <asp:CheckBox ID="chkUserAddFlagSunday" runat="server" Text="Sunday" Checked="true" meta:resourcekey="chkUserAddFlagSunday" /><br />
                                        <asp:CheckBox ID="chkUserAddFlagMonday" runat="server" Text="Monday" Checked="true" meta:resourcekey="chkUserAddFlagMonday" /><br />
                                        <asp:CheckBox ID="chkUserAddFlagTuesday" runat="server" Text="Tuesday" Checked="true" meta:resourcekey="chkUserAddFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkUserAddFlagWednesday" runat="server" Text="Wednesday" Checked="true" meta:resourcekey="chkUserAddFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkUserAddFlagThursday" runat="server" Text="Thursday" Checked="true" meta:resourcekey="chkUserAddFlagThursday" /><br />
                                        <asp:CheckBox ID="chkUserAddFlagFriday" runat="server" Text="Friday" Checked="true" meta:resourcekey="chkUserAddFlagFriday" /><br />
                                        <asp:CheckBox ID="chkUserAddFlagSaturday" runat="server" Text="Saturday" Checked="true" meta:resourcekey="chkUserAddFlagSaturday" /><br />
                                        <br />
                                        <asp:CheckBox ID="chkUserAddFlagSupervisor" runat="server" Text="Supervisor access" meta:resourcekey="chkUserAddFlagSupervisor" />

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource42" runat="server" meta:resourcekey="LiteralResource42">StartTime:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddStartTime" ClientIDMode="Static" runat="server" Text='<%# Bind("StartTime") %>' />
                                        <ajaxToolkit:FilteredTextBoxExtender ID="txtUserAddStartTimeFilterExt" runat="server" TargetControlID="txtUserAddStartTime" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource43" runat="server" meta:resourcekey="LiteralResource43">EndTime:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddEndTime" ClientIDMode="Static" runat="server" Text='<%# Bind("EndTime") %>' />
                                        <ajaxToolkit:FilteredTextBoxExtender ID="txtUserAddEndTimeFilterExt" runat="server" TargetControlID="txtUserAddEndTime" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource44" runat="server" meta:resourcekey="LiteralResource44">BeginContract:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddBeginContract" runat="server" Text='<%# Bind("BeginContract") %>' />
                                        <ajaxToolkit:CalendarExtender ID="txtUserAddBeginContractExt" runat="server" TargetControlID="txtUserAddBeginContract" TodaysDateFormat="d" Format="d"></ajaxToolkit:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource45" runat="server" meta:resourcekey="LiteralResource45">EndContract:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddEndContract" runat="server" Text='<%# Bind("EndContract") %>' />
                                        <ajaxToolkit:CalendarExtender ID="txtUserAddEndContractExt" runat="server" TargetControlID="txtUserAddEndContract" TodaysDateFormat="d" Format="d"></ajaxToolkit:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource46" runat="server" meta:resourcekey="LiteralResource46">MaxPickAllowed:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddMaxPickAllowed" ClientIDMode="Static" runat="server" Text='<%# Bind("MaxPickAllowed") %>' />
                                        <ajaxToolkit:FilteredTextBoxExtender ID="txtUserAddMaxPickAllowedFilterExt" runat="server" TargetControlID="txtUserAddMaxPickAllowed" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                            </table>

                        </div>
                        <div id="tabs-4">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource47" runat="server" meta:resourcekey="LiteralResource47">Firstname:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddFirstname" MaxLength="100" runat="server" Text='<%# Bind("Firstname") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource48" runat="server" meta:resourcekey="LiteralResource48">Middlename:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddMiddlename" MaxLength="100" runat="server" Text='<%# Bind("Middlename") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource49" runat="server" meta:resourcekey="LiteralResource49">Lastname:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddLastname" MaxLength="100" runat="server" Text='<%# Bind("Lastname") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource50" runat="server" meta:resourcekey="LiteralResource50">Gender:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnUserAddGender" runat="server" Value='<%# Bind("Gender") %>' />
                                        <asp:DropDownList ID="ddlUserAddGender" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource51" runat="server" meta:resourcekey="LiteralResource51">Phonenumber1:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddPhonenumber1" MaxLength="16" runat="server" Text='<%# Bind("Phonenumber1") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource52" runat="server" meta:resourcekey="LiteralResource52">Phonenumber2:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddPhonenumber2" MaxLength="16" runat="server" Text='<%# Bind("Phonenumber2") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource53" runat="server" meta:resourcekey="LiteralResource53">EMail1:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddEMail1" MaxLength="100" runat="server" Text='<%# Bind("EMail1") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource54" runat="server" meta:resourcekey="LiteralResource54">EMail2:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddEMail2" MaxLength="100" runat="server" Text='<%# Bind("EMail2") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource55" runat="server" meta:resourcekey="LiteralResource55">Address:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddAddress" MaxLength="100" runat="server" Text='<%# Bind("Address") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource56" runat="server" meta:resourcekey="LiteralResource56">Postalcode:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddPostalcode" MaxLength="100" runat="server" Text='<%# Bind("Postalcode") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource57" runat="server" meta:resourcekey="LiteralResource57">City:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddCity" MaxLength="100" runat="server" Text='<%# Bind("City") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource58" runat="server" meta:resourcekey="LiteralResource58">Country:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddCountry" MaxLength="100" runat="server" Text='<%# Bind("Country") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource59" runat="server" meta:resourcekey="LiteralResource59">Language:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnUserAddLanguage" Value='<%# Bind("Language") %>' runat="server" />
                                        <asp:DropDownList ID="ddlUserAddLanguage" runat="server">
                                            <asp:ListItem Value="" Text="Not set, use default" meta:resourcekey="ListItemResource12"/>
                                            <asp:ListItem Value="de-DE" Text="de-DE" />
                                            <asp:ListItem Value="en-US" Text="en-US" />
                                            <asp:ListItem Value="fr-FR" Text="fr-FR" />
                                            <asp:ListItem Value="nl-NL" Text="nl-NL" />
                                            <asp:ListItem Value="sv-SE" Text="sv-SE" />
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource60" runat="server" meta:resourcekey="LiteralResource60">Title:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtUserAddTitle" MaxLength="100" runat="server" Text='<%# Bind("Title") %>' /></td>
                                </tr>
                            </table>
                        </div>
                    </div>

                </InsertItemTemplate>
                <ItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource61" runat="server" meta:resourcekey="LiteralResource61">UserID:</asp:Literal></td>
                            <td>
                                <asp:Label ID="UserIDLabel" runat="server" Text='<%# string.Format("{0:0000}", Eval("UserID")) %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource62" runat="server" meta:resourcekey="LiteralResource62">UserPin:</asp:Literal></td>
                            <td>
                                <asp:Label ID="PinExpiresLabel" runat="server" Text='<%# GetExpireText("Pincode", Eval("PincodeExpiresOn")) %>' />
                            </td>
                                
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource64" runat="server" meta:resourcekey="LiteralResource64">Description:</asp:Literal></td>
                            <td>
                                <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource65" runat="server" meta:resourcekey="LiteralResource65">Username:</asp:Literal></td>
                            <td>
                                <asp:Label ID="UsernameLabel" runat="server" Text='<%# Bind("Username") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource66" runat="server" meta:resourcekey="LiteralResource66">Password:</asp:Literal></td>
                            <td>
                                <asp:Label ID="PasswordExpiresLabel" runat="server" Text='<%# GetExpireText("Password", Eval("PasswordExpiresOn")) %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource68" runat="server" meta:resourcekey="LiteralResource68">Swipecard:</asp:Literal></td>
                            <td>
                                <asp:Label ID="SwipecardLabel" runat="server" Text='<%# Bind("Swipecard") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource69" runat="server" meta:resourcekey="LiteralResource69">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="EnabledCheckBox" runat="server" Checked='<%# Bind("Enabled") %>' Enabled="false" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource97" runat="server" meta:resourcekey="LiteralResource97">Role:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlUserViewRole" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsRoles"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    SelectedValue='<%# Bind("RoleID") %>'
                                    Enabled="false">
                                </asp:DropDownList>
                            </td>
                        </tr>

                    </table>
                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/building_link.png" />
                                <asp:Literal ID="LiteralResource98" runat="server" meta:resourcekey="LiteralResource98">Sites</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/group_link.png" />
                                <asp:Literal ID="LiteralResource70" runat="server" meta:resourcekey="LiteralResource70">Groups</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource71" runat="server" meta:resourcekey="LiteralResource71">Constraints</asp:Literal></a></li>
                            <li><a href="#tabs-4">
                                <img src="Content/FamFamFam/user.png" />
                                <asp:Literal ID="LiteralResource72" runat="server" meta:resourcekey="LiteralResource72">Other</asp:Literal></a></li>
                        </ul>

                        <div id="tabs-1">
                            <asp:Panel ID="pnlListViewUser_BndSU" runat="server" ScrollBars="Both" Height="368px">
                                <asp:CheckBoxList ID="chkListViewUser_BndSU" runat="server"
                                    DataSourceID="dsSites"
                                    DataTextField="Name"
                                    DataValueField="ID"
                                    Enabled="false"
                                    OnDataBound="chkListUser_BndSU_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>

                        <div id="tabs-2">
                            <asp:Panel ID="pnlListViewUser_BndUG" runat="server" ScrollBars="Both" Height="368px">
                                <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                    SelectCommand="SELECT [ID], [Name] FROM [Group] ORDER BY [Name]"
                                    OnLoad="dsGroups_Load"></asp:SqlDataSource>

                                <asp:CheckBoxList ID="chkListViewUser_BndUG" runat="server"
                                    DataSourceID="dsGroups"
                                    DataTextField="Name"
                                    DataValueField="ID"
                                    Enabled="False"
                                    OnDataBound="chkListUser_BndUG_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>

                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource73" runat="server" meta:resourcekey="LiteralResource73">Flags:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnUserViewFlags" runat="server" Value='<%# Bind("Flags") %>' />
                                        <asp:CheckBox ID="chkUserViewFlagSunday" runat="server" Text="Sunday" Enabled="false" meta:resourcekey="chkUserViewFlagSunday" /><br />
                                        <asp:CheckBox ID="chkUserViewFlagMonday" runat="server" Text="Monday" Enabled="false" meta:resourcekey="chkUserViewFlagMonday" /><br />
                                        <asp:CheckBox ID="chkUserViewFlagTuesday" runat="server" Text="Tuesday" Enabled="false" meta:resourcekey="chkUserViewFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkUserViewFlagWednesday" runat="server" Text="Wednesday" Enabled="false" meta:resourcekey="chkUserViewFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkUserViewFlagThursday" runat="server" Text="Thursday" Enabled="false" meta:resourcekey="chkUserViewFlagThursday" /><br />
                                        <asp:CheckBox ID="chkUserViewFlagFriday" runat="server" Text="Friday" Enabled="false" meta:resourcekey="chkUserViewFlagFriday" /><br />
                                        <asp:CheckBox ID="chkUserViewFlagSaturday" runat="server" Text="Saturday" Enabled="false" meta:resourcekey="chkUserViewFlagSaturday" /><br />
                                        <br />
                                        <asp:CheckBox ID="chkUserViewFlagSupervisor" runat="server" Text="Supervisor access" Enabled="false" meta:resourcekey="chkUserViewFlagSupervisor" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource74" runat="server" meta:resourcekey="LiteralResource74">StartTime:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="StartTimeLabel" runat="server" Text='<%# Bind("StartTime") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource75" runat="server" meta:resourcekey="LiteralResource75">EndTime:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="EndTimeLabel" runat="server" Text='<%# Bind("EndTime") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource76" runat="server" meta:resourcekey="LiteralResource76">BeginContract:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="BeginContractLabel" runat="server" Text='<%# Bind("BeginContract") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource77" runat="server" meta:resourcekey="LiteralResource77">EndContract:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="EndContractLabel" runat="server" Text='<%# Bind("EndContract") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource78" runat="server" meta:resourcekey="LiteralResource78">MaxPickAllowed:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="MaxPickAllowedLabel" runat="server" Text='<%# Bind("MaxPickAllowed") %>' />
                                    </td>
                                </tr>
                            </table>

                        </div>
                        <div id="tabs-4">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource79" runat="server" meta:resourcekey="LiteralResource79">Firstname:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="FirstnameLabel" runat="server" Text='<%# Bind("Firstname") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource80" runat="server" meta:resourcekey="LiteralResource80">Middlename:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="MiddlenameLabel" runat="server" Text='<%# Bind("Middlename") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource81" runat="server" meta:resourcekey="LiteralResource81">Lastname:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="LastnameLabel" runat="server" Text='<%# Bind("Lastname") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource82" runat="server" meta:resourcekey="LiteralResource82">Gender:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnUserViewGender" runat="server" Value='<%# Bind("Gender") %>' />
                                        <asp:DropDownList ID="ddlUserViewGender" runat="server" Enabled="false">
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource83" runat="server" meta:resourcekey="LiteralResource83">Phonenumber1:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="Phonenumber1Label" runat="server" Text='<%# Bind("Phonenumber1") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource84" runat="server" meta:resourcekey="LiteralResource84">Phonenumber2:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="Phonenumber2Label" runat="server" Text='<%# Bind("Phonenumber2") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource85" runat="server" meta:resourcekey="LiteralResource85">EMail1:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="EMail1Label" runat="server" Text='<%# Bind("EMail1") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource86" runat="server" meta:resourcekey="LiteralResource86">EMail2:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="EMail2Label" runat="server" Text='<%# Bind("EMail2") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource87" runat="server" meta:resourcekey="LiteralResource87">Address:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="AddressLabel" runat="server" Text='<%# Bind("Address") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource88" runat="server" meta:resourcekey="LiteralResource88">Postalcode:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="PostalcodeLabel" runat="server" Text='<%# Bind("Postalcode") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource89" runat="server" meta:resourcekey="LiteralResource89">City:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="CityLabel" runat="server" Text='<%# Bind("City") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource90" runat="server" meta:resourcekey="LiteralResource90">Country:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="CountryLabel" runat="server" Text='<%# Bind("Country") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource91" runat="server" meta:resourcekey="LiteralResource91">Language:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="LanguageLabel" runat="server" Text='<%# Bind("Language") %>' /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource92" runat="server" meta:resourcekey="LiteralResource92">Title:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="TitleLabel" runat="server" Text='<%# Bind("Title") %>' /></td>
                                </tr>

                            </table>
                        </div>
                    </div>

                </ItemTemplate>
            </asp:FormView>

            <uc1:EntityControl runat="server" ID="EntityControl"
                OnClicked="EntityControl_Clicked" />

            <div class="Hidden">
                <blockquote>
                    <asp:Label ID="lblSQL" ClientIDMode="Static" runat="server" Text="Label"></asp:Label>
                </blockquote>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

    <script>
        function showSQL() {
            jq("#lblSQL").parent().parent().removeClass("Hidden");
        }
    </script>
    <a href="#" class="Hidden" onclick="javascript:showSQL(); return false;">showSQL</a>

</asp:Content>
