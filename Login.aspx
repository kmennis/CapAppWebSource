<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" EnableEventValidation="false" Inherits="KCWebManager.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Scripts/passfield/js/passfield.js"></script>
    <script src="Scripts/passfield/js/locales.js"></script>
    <link rel="stylesheet" type="text/css" href="Scripts/passfield/css/passfield.css" />

    <script>
        var selected_tab = "";

        function InitializeRequestHandler(sender, args) {
            if (args.get_postBackElement().id == 'btnSave3') {
                // Validate the password (if entered)
                if (jq("#PasswordTextBox").val().length > 0 && jq("#PasswordTextBox").validatePass() == false) {
                    jq("#PasswordTextBox").focus();
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
                location.href = "Login";
            }

            InitializeTabs();

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
            //jq("#tabs").width(100%);
            //jq("#tabs").height(475);
            jq(".tblKCAdv").width(100%);
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

            jq("#PasswordTextBox").passField({
                locale: passFieldLocale,
                errorWrapClassName: "",
                length: { min: pwLengthMin },
                pattern: pwPattern,
                acceptRate: pwAcceptRate,

            });

            var txtPin = jq("#UserPinTextBox");
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

        function LogOut() {
            if (confirm(jq("#resLogoutConfirm").text()) == true) {
                jq("#btnLogout2").click();
            }
        }

        jq(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_initializeRequest(InitializeRequestHandler)
            Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
            InitializeTabs();
            InitializePassField();
        });

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="Hidden">
        <asp:Label ID="resLogoutConfirm" ClientIDMode="Static" Text="Are you sure you want to log out?" runat="server" meta:resourcekey="resLogoutConfirm"/>
    </div>

    <asp:Panel ID="pnlLogin" runat="server" DefaultButton="Login1$LoginButton">
        <asp:Login ID="Login1" runat="server" OnAuthenticate="Login1_Authenticate" CssClass="Login">
        </asp:Login>

        <asp:Panel ID="pnlDemoAccounts" runat="server" Visible="false">
            <b><asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Demonstration accounts:</asp:Literal></b>
            <br />
            <button onclick="javascript:return Demo('Demo', 'Demo');" style="height: 30px; width: 150px;"><asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Demo-user</asp:Literal></button>
            <br />
            <button onclick="javascript:return Demo('DemoSupervisor', 'Demo');" style="height: 30px; width: 150px;"><asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Demo-Supervisor</asp:Literal></button>

            <script>
                function Demo(username, password) {
                    jq("#ContentPlaceHolder1_Login1_UserName").val(username);
                    jq("#ContentPlaceHolder1_Login1_Password").val(password);
                    jq("#ContentPlaceHolder1_Login1_LoginButton").click();
                    return false;
                }
            </script>
        </asp:Panel>

    </asp:Panel>

    <asp:Panel ID="pnlLoggedIn" runat="server">

        <asp:HiddenField ID="hdnPasswordComplexity" runat="server" ClientIDMode="Static" Value="0" />

        <asp:MultiView ID="mvAccount" ActiveViewIndex="0" runat="server">
            <asp:View ID="vwSimple" runat="server">
                <% // This simple view is used when user Role.CanViewOwnProfile is False %>
                <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">You are currently logged in as</asp:Literal>
                <asp:Label ID="lblLoginName" runat="server" Text="Label"></asp:Label>.
                <br />
                <br />
                <asp:Button ID="btnLogout" runat="server" 
                    OnClick="btnLogout_Click" 
                    Text="Log out" 
                    Height="30px" Width="150px"
                    meta:resourcekey="btnLogout" />

            </asp:View>

            <asp:View ID="vwAccount" runat="server">

                <asp:UpdatePanel runat="server">
                    <ContentTemplate>

                        <asp:SqlDataSource ID="dsUser" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                            SelectCommand="
                                SELECT [Username], [UserID], [Description], [Phonenumber1], [Phonenumber2], 
                                       [EMail1], [EMail2], [Address], [Postalcode], [City], [Country], 
                                       [Title], [Firstname], [Middlename], [Lastname], [ID] 
                                FROM [User] 
                                WHERE ([ID] = @CurrentUserID)"
                            UpdateCommand="
                                    UPDATE [User] SET 
                                        [Phonenumber1] = @Phonenumber1, 
                                        [Phonenumber2] = @Phonenumber2, 
                                        [EMail1] = @EMail1, 
                                        [EMail2] = @EMail2, 
                                        [Address] = @Address, 
                                        [Postalcode] = @Postalcode, 
                                        [City] = @City, 
                                        [Country] = @Country, 
                                        [Title] = @Title, 
                                        [Firstname] = @Firstname, 
                                        [Middlename] = @Middlename, 
                                        [Lastname] = @Lastname,
                                        [ModifiedOn] = GETDATE(),
                                        [ModifiedBy] = [ID]
                                    WHERE [ID] = @CurrentUserID"
                            OnUpdating="dsUser_Updating">

                            <SelectParameters>
                                <asp:SessionParameter DefaultValue="0" Name="CurrentUserID" SessionField="CurrentUserID" Type="Int32" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="Phonenumber1" Type="String" />
                                <asp:Parameter Name="Phonenumber2" Type="String" />
                                <asp:Parameter Name="EMail1" Type="String" />
                                <asp:Parameter Name="EMail2" Type="String" />
                                <asp:Parameter Name="Address" Type="String" />
                                <asp:Parameter Name="Postalcode" Type="String" />
                                <asp:Parameter Name="City" Type="String" />
                                <asp:Parameter Name="Country" Type="String" />
                                <asp:Parameter Name="Title" Type="String" />
                                <asp:Parameter Name="Firstname" Type="String" />
                                <asp:Parameter Name="Middlename" Type="String" />
                                <asp:Parameter Name="Lastname" Type="String" />
                                <asp:SessionParameter DefaultValue="0" Name="CurrentUserID" SessionField="CurrentUserID" Type="Int32" />
                            </UpdateParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="dsUserCredentials" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                            SelectCommand="
                                SELECT [ID], [Password], [UserPin], [PasswordExpiresOn], [PincodeExpiresOn]
                                FROM [User] 
                                WHERE ([ID] = @CurrentUserID)"
                            UpdateCommand="
                                UPDATE [User] 
                                SET [Password] = @Password, 
                                    [UserPin] = @UserPin,
                                    [PasswordChangedOn] = GETDATE(),
                                    [PasswordChangedBy] = [ID],
                                    [PasswordExpiresOn] = @PasswordExpiresOn,
                                    [PincodeExpiresOn] = @PincodeExpiresOn
                                WHERE [ID] = @CurrentUserID"
                            OnUpdating="dsUserCredentials_Updating">
                            <SelectParameters>
                                <asp:SessionParameter DefaultValue="0" Name="CurrentUserID" SessionField="CurrentUserID" Type="Int32" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="Password" Type="String" />
                                <asp:Parameter Name="UserPin" Type="Int16" />
                                <asp:Parameter Name="PasswordExpiresOn" Type="DateTime" />
                                <asp:Parameter Name="PincodeExpiresOn" Type="DateTime" />
                                <asp:SessionParameter DefaultValue="0" Name="CurrentUserID" SessionField="CurrentUserID" Type="Int32" />
                            </UpdateParameters>
                        </asp:SqlDataSource>

                        <div id="tabs">
                            <ul>
                                <li><a href="#tabs-1">
                                    <img src="Content/FamFamFam/user.png" />
                                    <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Account</asp:Literal></a></li>
                                <li><a href="#tabs-2">
                                    <img src="Content/FamFamFam/lock_edit.png" />
                                    <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Change password</asp:Literal></a></li>
                                <li style="float: right!important;"><a href="#tabs-3"  onclick="javascript:LogOut(); return false;">
                                    <img src="Content/FamFamFam/user_go.png" />
                                    <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Log out</asp:Literal></a></li>
                                </li>
                            </ul>
                            <div id="tabs-1">
                                <asp:FormView ID="fvwAccount" runat="server"
                                    DataKeyNames="ID"
                                    DataSourceID="dsUser"
                                    OnModeChanging="fvwAccount_ModeChanging">
                                    <EditItemTemplate>
                                        <table class="tblKCAdv">
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Username:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="UsernameLabel" runat="server" Text='<%# Bind("Username") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">UserID:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="UserIDLabel" runat="server" Text='<%# string.Format("{0:0000}", Eval("UserID")) %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Description:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' />
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">Firstname:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="FirstnameTextBox" runat="server" Text='<%# Bind("Firstname") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">Middlename:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="MiddlenameTextBox" runat="server" Text='<%# Bind("Middlename") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">Lastname:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="LastnameTextBox" runat="server" Text='<%# Bind("Lastname") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">Phonenumber1:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="Phonenumber1TextBox" runat="server" Text='<%# Bind("Phonenumber1") %>' MaxLength="16" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">Phonenumber2:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="Phonenumber2TextBox" runat="server" Text='<%# Bind("Phonenumber2") %>' MaxLength="16" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">EMail1:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="EMail1TextBox" runat="server" Text='<%# Bind("EMail1") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">EMail2:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="EMail2TextBox" runat="server" Text='<%# Bind("EMail2") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">Address:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="AddressTextBox" runat="server" Text='<%# Bind("Address") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">Postalcode:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="PostalcodeTextBox" runat="server" Text='<%# Bind("Postalcode") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">City:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="CityTextBox" runat="server" Text='<%# Bind("City") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">Country:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="CountryTextBox" runat="server" Text='<%# Bind("Country") %>' MaxLength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource23" runat="server" meta:resourcekey="LiteralResource23">Title:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="TitleTextBox" runat="server" Text='<%# Bind("Title") %>' MaxLength="100" />
                                                </td>
                                            </tr>

                                        </table>
                                        <asp:Panel ID="pnlEntityControl1" runat="server" CssClass="EntityControl">

                                            <asp:ImageButton ID="btnUndo1" runat="server"
                                                ImageUrl="~/Content/FamFamFam/arrow_undo2.png"
                                                CommandName="Cancel"
                                                CausesValidation="false"
                                                ToolTip="Cancel and return" meta:resourcekey="btnUndo1" />

                                            <asp:ImageButton ID="btnSave1" runat="server"
                                                ImageUrl="~/Content/FamFamFam/disk.png"
                                                CommandName="Update"
                                                CausesValidation="true"
                                                ToolTip="Save changes" meta:resourcekey="btnSave1" />
                                        </asp:Panel>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        Adding a new user cannot be done from your account.
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <table class="tblKCAdv">
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource25" runat="server" meta:resourcekey="LiteralResource25">Username:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="UsernameLabel" runat="server" Text='<%# Bind("Username") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource26" runat="server" meta:resourcekey="LiteralResource26">UserID:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="UserIDLabel" runat="server" Text='<%# string.Format("{0:0000}", Eval("UserID")) %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource27" runat="server" meta:resourcekey="LiteralResource27">Description:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource28" runat="server" meta:resourcekey="LiteralResource28">Firstname:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="FirstnameLabel" runat="server" Text='<%# Bind("Firstname") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource29" runat="server" meta:resourcekey="LiteralResource29">Middlename:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="MiddlenameLabel" runat="server" Text='<%# Bind("Middlename") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource30" runat="server" meta:resourcekey="LiteralResource30">Lastname:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="LastnameLabel" runat="server" Text='<%# Bind("Lastname") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource31" runat="server" meta:resourcekey="LiteralResource31">Phonenumber1:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="Phonenumber1Label" runat="server" Text='<%# Bind("Phonenumber1") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource32" runat="server" meta:resourcekey="LiteralResource32">Phonenumber2:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="Phonenumber2Label" runat="server" Text='<%# Bind("Phonenumber2") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource33" runat="server" meta:resourcekey="LiteralResource33">EMail1:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="EMail1Label" runat="server" Text='<%# Bind("EMail1") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource34" runat="server" meta:resourcekey="LiteralResource34">EMail2:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="EMail2Label" runat="server" Text='<%# Bind("EMail2") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource35" runat="server" meta:resourcekey="LiteralResource35">Address:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="AddressLabel" runat="server" Text='<%# Bind("Address") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource36" runat="server" meta:resourcekey="LiteralResource36">Postalcode:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="PostalcodeLabel" runat="server" Text='<%# Bind("Postalcode") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource37" runat="server" meta:resourcekey="LiteralResource37">City:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="CityLabel" runat="server" Text='<%# Bind("City") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource38" runat="server" meta:resourcekey="LiteralResource38">Country:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="CountryLabel" runat="server" Text='<%# Bind("Country") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource40" runat="server" meta:resourcekey="LiteralResource40">Title:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="TitleLabel" runat="server" Text='<%# Bind("Title") %>' />
                                                </td>
                                            </tr>

                                        </table>
                                        <asp:Panel ID="pnlEntityControl2" runat="server" CssClass="EntityControl">
                                            <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="" ToolTip="Edit" meta:resourcekey="EditButton">
                                                <img src="Content/FamFamFam/page_white_edit.png" />
                                            </asp:LinkButton>
                                        </asp:Panel>
                                    </ItemTemplate>
                                </asp:FormView>

                            </div>
                            <div id="tabs-2">

                                <asp:FormView ID="fvwPassword" runat="server"
                                    DataKeyNames="ID"
                                    DataSourceID="dsUserCredentials"
                                    OnModeChanging="fvwPassword_ModeChanging">
                                    <EditItemTemplate>
                                        <table class="tblKCAdv">
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource41" runat="server" meta:resourcekey="LiteralResource41">Current password:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="CurrentPasswordTextBox" TextMode="Password" MaxLength="100" runat="server" />
                                                    <asp:CustomValidator ID="CurrentPasswordTextBoxValidator" runat="server"
                                                        ErrorMessage="Enter current password"
                                                        ValidateEmptyText="true"
                                                        CssClass="error"
                                                        ControlToValidate="CurrentPasswordTextBox"
                                                        OnServerValidate="CurrentPasswordTextBoxValidator_ServerValidate" meta:resourcekey="CurrentPasswordTextBoxValidator"></asp:CustomValidator>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource42" runat="server" meta:resourcekey="LiteralResource42">New password:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="PasswordTextBox" ClientIDMode="Static" runat="server" Text='<%# Bind("Password") %>' />
                                                    <asp:Image ImageUrl="~/Content/FamFamFam/information.png" runat="server"
                                                        ToolTip="This password is used to access the KeyCop WebManager." meta:resourcekey="ImageResource0" />

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource43" runat="server" meta:resourcekey="LiteralResource43">PIN Code:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="UserPinTextBox" ClientIDMode="Static" runat="server" Text='<%# Bind("UserPin") %>' MaxLength="4" />
                                                    <asp:Image ImageUrl="~/Content/FamFamFam/information.png" runat="server"
                                                        ToolTip="This pincode is used to access the KeyConductor." meta:resourcekey="ImageResource1" />


                                                    <ajaxToolkit:FilteredTextBoxExtender ID="UserPinTextBoxExtender" runat="server" TargetControlID="UserPinTextBox" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                                    <asp:CustomValidator ID="UserPinTextBoxValidator" runat="server"
                                                        ErrorMessage="PIN code must be unique"
                                                        ValidateEmptyText="true"
                                                        CssClass="error"
                                                        ControlToValidate="UserPinTextBox"
                                                        OnServerValidate="UserPinTextBoxValidator_ServerValidate" meta:resourcekey="UserPinTextBoxValidator"></asp:CustomValidator>

                                                </td>
                                            </tr>
                                        </table>


                                        <asp:Panel ID="pnlEntityControl3" runat="server" CssClass="EntityControl">
                                            <asp:ImageButton ID="btnUndo3" runat="server"
                                                ImageUrl="~/Content/FamFamFam/arrow_undo2.png"
                                                CommandName="Cancel"
                                                CausesValidation="false"
                                                ToolTip="Cancel and return" meta:resourcekey="btnUndo3" />

                                            <asp:ImageButton ID="btnSave3" runat="server"
                                                ImageUrl="~/Content/FamFamFam/disk.png"
                                                CommandName="Update"
                                                CausesValidation="true"
                                                ClientIDMode="Static"
                                                ToolTip="Save changes" meta:resourcekey="btnSave3" />
                                        </asp:Panel>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        Not available.
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <table class="tblKCAdv">
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource45" runat="server" meta:resourcekey="LiteralResource45">Password:</asp:Literal></td>
                                                <td>********
                                                    <asp:Image ImageUrl="~/Content/FamFamFam/information.png" runat="server"
                                                        ToolTip="This password is used to access the KeyCop WebManager." meta:resourcekey="ImageResource2" />
                                                    <asp:Label ID="PasswordExpiresLabel" runat="server" Text='<%# GetExpireText("Password", Eval("PasswordExpiresOn")) %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource47" runat="server" meta:resourcekey="LiteralResource47">PIN Code:</asp:Literal></td>
                                                <td>****
                                                    <asp:Image ImageUrl="~/Content/FamFamFam/information.png" runat="server"
                                                        ToolTip="This pincode is used to access the KeyConductor." meta:resourcekey="ImageResource3" />
                                                    <asp:Label ID="PinExpiresLabel" runat="server" Text='<%# GetExpireText("Pincode", Eval("PincodeExpiresOn")) %>' />
                                                </td>
                                            </tr>
                                        </table>
                                        <asp:Panel ID="pnlEntityControl4" runat="server" CssClass="EntityControl">
                                            <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="" ToolTip="Edit" meta:resourcekey="EditButton0">
                                                <img src="Content/FamFamFam/page_white_edit.png" />
                                            </asp:LinkButton>
                                        </asp:Panel>
                                    </ItemTemplate>
                                </asp:FormView>

                            </div>

                            <div id="tabs-3">
                                <asp:Button ID="btnLogout2" runat="server" 
                                    ClientIDMode="Static"
                                    OnClick="btnLogout_Click" 
                                    Text="Log out" 
                                    Height="30px" Width="150px"
                                    meta:resourcekey="btnLogout" />
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:View>
        </asp:MultiView>


    </asp:Panel>

</asp:Content>
