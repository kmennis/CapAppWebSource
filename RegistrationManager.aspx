<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="RegistrationManager.aspx.cs" Inherits="KCWebManager.RegistrationManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        var strUnsavedChanged = "There are unsaved transactions. Discard changes?"; // this is overwritten by localized resource!

        function InitializeRequestHandler(sender, args) {

            if (args.get_postBackElement() == undefined) {
                // this happens when the ddlFilter.SelectedIndexChanged
                return;
            }

            // Supervisor wants to switch user but hasnt saved the current transaction.
            if (args.get_postBackElement().id == 'btnSwitchUser') {
                var displayConfirm = DisplayConfirmationIfNeeded();
                if (displayConfirm == true) {
                    // User hasnt saved or canceled
                    if (confirm(strUnsavedChanged) == false) {
                        args.set_cancel(true);
                    }
                }
            }
        }

        function BeginRequestHandler(sender, args) {
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
                location.href = "RegistrationManager";
            }
            BindEventHandlers();
            FocusControl();
            AutoPrintReportIfNeeded();
        }

        function AutoPrintReportIfNeeded() {
            // db.Settings.RegMgrAutoPrintReport => True := print Change-of-liability
            var hdnReportAutoPrint = jq("#hdnReportAutoPrint");
            if(hdnReportAutoPrint.length > 0 && hdnReportAutoPrint.val() == "True")
            {
                window.print();
            }
        }

        jq(document).ready(function () {

            strUnsavedChanged = jq("#resUnsavedChanges").text();

            BindEventHandlers();
            FocusControl();

            // User wants to exit the page but has open-transactions;
            jq(window).bind('beforeunload', function () {
                if (DisplayConfirmationIfNeeded()) {
                    return strUnsavedChanged;
                }
            });

        });

        // Delayed function to set focus to a specific control
        function FocusControl() {


            setTimeout(function () {
                var controlName = '#txtKeyCopSearch';
                if (jq('#lstUsers').length) controlName = '#lstUsers';
                else if (jq('#txtUsername').length) controlName = '#txtUsername';
                else if (jq('#btnShowInfoOK').length && jq('#btnShowInfoOK').is(':visible')) controlName = '#btnShowInfoOK';

                jq(controlName).focus();
            }, 10);

        }

        // Bind KeyBoard events to the controls
        function BindEventHandlers() {
            jq("#txtUsername").keydown(function (e) {
                Control_OnEnterKey(e, "#btnUserOK", false);
            });

            jq("#txtKeyCopSearch").keydown(function (e) {
                txtKeyCopSearch_KeyDown(e);
            });

            jq("#lstKeyCopsLeft").keydown(function (e) {
                Control_OnEnterKey(e, "#btnPickKeyCop", true);
            });

            jq("#lstKeyCopsLeft").dblclick(function (e) {
                jq("#btnPickKeyCop").click();
            });

            jq("#lstKeyCopsRight").keydown(function (e) {
                Control_OnEnterKey(e, "#btnReturnKeyCop", true);
            });

            jq("#lstKeyCopsRight").dblclick(function (e) {
                jq("#btnReturnKeyCop").click();
            });

            jq("#lstKeyCopsLeft").change(function (e) {
                jq("#lstKeyCopsRight > option").prop("selected", false);
                jq("#btnReturnKeyCop").prop("disabled", true);
                jq("#btnPickKeyCop").prop("disabled", (jq("#ddlFilter").prop("selectedIndex") != 0 || jq("#lstKeyCopsLeft :selected").length == 0));
                jq("#btnShowInfo").prop("disabled", (jq("#lstKeyCopsLeft :selected").length != 1));
            });

            jq("#lstKeyCopsRight").change(function (e) {
                jq("#lstKeyCopsLeft > option").prop("selected", false);
                jq("#btnReturnKeyCop").prop("disabled", (jq("#ddlFilter").prop("selectedIndex") != 0 || jq("#lstKeyCopsRight :selected").length == 0));
                jq("#btnPickKeyCop").prop("disabled", true);
                jq("#btnShowInfo").prop("disabled", (jq("#lstKeyCopsRight :selected").length != 1));
            });
        }

        // Generic ENTER function to speed up the user-workings
        function Control_OnEnterKey(e, buttonToPress, actOnSpace) {
            var code = e.which; // recommended to use e.which, it's normalized across browsers
            if (code == 13) e.preventDefault();
            // 32=space, 13=enter
            if ((code == 32 && actOnSpace) || code == 13) {
                jq(buttonToPress).click();
            }
        }

        // WEDGE support
        var _barcodeScanDuration = 12 * 17; // 12 karakters * 20ms per karakter
        var _timBarcodeScanClear;
        var _keyUpBufferLength = 0;

        function txtKeyCopSearch_KeyDown(e) {
            var code = e.which; // recommended to use e.which, it's normalized across browsers
            if (code == 13) {
                e.preventDefault();
                jq("#btnKeyCopSearchAndTransfer").click();
            }
            else if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105)) { // 0..10
                _keyUpBufferLength++;
                if (_timBarcodeScanClear != null) { clearTimeout(_timBarcodeScanClear); _timBarcodeScanClear = null; }
                _timBarcodeScanClear = setTimeout(_timBarcodeScanClear_Elapsed, _barcodeScanDuration);
            }
            else {
                _keyUpBufferLength = 0;
            }

        }

        // WEDGE support, automacilly pres enter if barcode has been scanned
        function _timBarcodeScanClear_Elapsed() {
            if (_keyUpBufferLength >= 12) {
                var txtKeyCopSearch = jq("#txtKeyCopSearch");
                if (txtKeyCopSearch.val().length == 12) {
                    jq("#btnKeyCopSearchAndTransfer").click();
                    _keyUpBufferLength = 0;
                }
            }
        }

        // Checks if a Confirm dialog needs to be displayed.
        // This depends if the Save-button is enabled or not
        function DisplayConfirmationIfNeeded() {
            try {
                var btnSave = jq("#btnSave");
                return (btnSave != null && btnSave[0].disabled == false);
            } catch (e) {
                return false;
            }
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_initializeRequest(InitializeRequestHandler)
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
    </script>

    <div class="Hidden">
        <asp:Label ID="resUnsavedChanges" ClientIDMode="Static" Text="There are unsaved transactions. Discard changes?" runat="server" meta:resourcekey="resUnsavedChanges" />
    </div>

    <% // AsyncPostBackTrigger is added for the ddlFilter DropDownlist with ClientIDMode = static inside updatepanel. %>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlFilter" EventName="SelectedIndexChanged" />
        </Triggers>
        <ContentTemplate>
            <asp:MultiView ID="mvPanels" runat="server">

                <asp:View runat="server" ID="pnlSelectUser">
                    <asp:Panel runat="server" DefaultButton="btnUserOK">

                        <table class="tblRegMgr">
                            <tr>
                                <td style="width: 100px;"></td>
                                <td style="width: 200px;"></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td style="font-size: large;">
                                    <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">Enter user:</asp:Literal>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtUsername" runat="server" ClientIDMode="Static" Height="27px" Width="218px"></asp:TextBox>
                                    <br />
                                    <br />
                                    <asp:ListBox ID="lstUsers" runat="server" Visible="false" ClientIDMode="Static" Height="137px" Width="220px"></asp:ListBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td>
                                    <asp:Button ID="btnUserOK" runat="server" Text="OK &gt;" Height="27px" Width="120px" OnClick="btnUserOK_Click" ClientIDMode="Static" meta:resourcekey="btnUserOK" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </asp:View>

                <asp:View runat="server" ID="pnlRegMgr">
                    <asp:Panel runat="server" DefaultButton="btnKeyCopSearchAndTransfer">
                        <table class="tblRegMgr">
                            <tr>
                                <td class="tblRegMgr_KeyConductor">
                                    <table border="0">
                                        <tr>
                                            <td>
                                                <img src="Resources/KCLite_48.png" /></td>
                                            <td>
                                                <asp:HiddenField runat="server" ID="hdnKeyConductorID" Value="0" />
                                                <asp:Label ID="lblKeyConductorName" runat="server" Text="KeyConductor" meta:resourcekey="lblKeyConductorName"></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                                <td class="tblRegMgr_User">
                                    <table border="0">
                                        <tr>
                                            <td>
                                                <img src="Resources/User_48.png" /></td>
                                            <td>
                                                <asp:HiddenField ID="hdnUserID" Value="0" runat="server" />
                                                <asp:Label ID="lblUsername" runat="server" Text="0001: User 0001"></asp:Label>
                                                <asp:Button ID="btnSwitchUser" runat="server" Text="Sign out" Height="27px" Width="120px"
                                                    OnClick="btnSwitchUser_Click" ClientIDMode="Static" meta:resourcekey="btnSwitchUser" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <table border="0">
                                        <tr>
                                            <td style="width: 100px;"></td>
                                            <td>
                                                <asp:TextBox ID="txtKeyCopSearch" runat="server" Text="" Height="27px" Width="350px" ClientIDMode="Static" /></td>
                                            <td>
                                                <asp:Button Text="Search / Transfer" ID="btnKeyCopSearchAndTransfer" ClientIDMode="Static" Height="33px" Width="175px" runat="server" OnClick="btnKeyCopSearchAndTransfer_Click" meta:resourcekey="btnKeyCopSearchAndTransfer" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:ListBox ID="lstKeyCopsLeft" runat="server" Height="300px" Width="350px" SelectionMode="Multiple" ClientIDMode="Static"></asp:ListBox>
                                </td>
                                <td>

                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <asp:Button Text="&gt;" ToolTip="Lend KeyCop OUT" runat="server" ID="btnPickKeyCop" ClientIDMode="Static" OnClick="btnPickKeyCop_Click" Font-Bold="False" Font-Size="Larger" Height="50px" Width="50px" Enabled="false" meta:resourcekey="btnPickKeyCop" />
                                    <br />
                                    <br />
                                    <asp:Button Text="&lt;" ToolTip="Take KeyCop IN" runat="server" ID="btnReturnKeyCop" ClientIDMode="Static" OnClick="btnReturnKeyCop_Click" Font-Bold="False" Font-Size="Larger" Height="50px" Width="50px" Enabled="false" meta:resourcekey="btnReturnKeyCop" />
                                    <br />
                                    <br />
                                    <asp:Button Text="i" ToolTip="Show information about selected KeyCop" runat="server" ID="btnShowInfo" OnClick="btnShowInfo_Click" Font-Bold="False" Font-Size="Larger" Height="50px" Width="50px" Enabled="false" ClientIDMode="Static" meta:resourcekey="btnShowInfo" />

                                </td>
                                <td>
                                    <asp:ListBox ID="lstKeyCopsRight" runat="server" Height="300px" Width="350px" SelectionMode="Multiple" ClientIDMode="Static"></asp:ListBox>
                                </td>
                            </tr>

                            <tr>
                                <td>&nbsp;<asp:DropDownList ID="ddlFilter" ClientIDMode="Static" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" Width="345px">
                                    <asp:ListItem Value="Available" meta:resourcekey="ListItemResource0">Show available KeyCops</asp:ListItem>
                                    <asp:ListItem Value="Unavailable" meta:resourcekey="ListItemResource1">Show unavailable KeyCops</asp:ListItem>
                                    <asp:ListItem Value="UnavailableHere" meta:resourcekey="ListItemResource2">Show other locations</asp:ListItem>
                                    <asp:ListItem Value="Unauthorized" meta:resourcekey="ListItemResource3">Show unauthorized KeyCops</asp:ListItem>
                                </asp:DropDownList>
                                </td>
                                <td>&nbsp;</td>
                                <td style="text-align: right;">
                                    <asp:Button Text="Save" ID="btnSave" runat="server" OnClick="btnSave_Click" Height="33px" Width="120px" ClientIDMode="Static" meta:resourcekey="btnSave" />
                                    <asp:Button Text="Cancel" ID="btnCancel" runat="server" OnClick="btnCancel_Click" Height="33px" Width="120px" ClientIDMode="Static" meta:resourcekey="btnCancel" />
                                </td>
                            </tr>

                        </table>
                    </asp:Panel>
                </asp:View>

                <asp:View ID="pnlReport" runat="server">
                    <asp:Panel runat="server" DefaultButton="btnReportOK">

                        <table border="0" class="tblRegMgr_Report">
                            <tr>
                                <td colspan="2">
                                    <h1>
                                        <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Report</asp:Literal></h1>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Date/time:</asp:Literal></td>
                                <td>
                                    <asp:Label ID="lblReportDateTime" Text="Date and time" runat="server" meta:resourcekey="lblReportDateTime" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">KeyConductor:</asp:Literal></td>
                                <td>
                                    <asp:Label ID="lblReportKeyConductor" Text="KeyConductor.Name" runat="server" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">User:</asp:Literal></td>
                                <td>
                                    <asp:Label ID="lblReportUser" Text="User.Username" runat="server" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblReportKeysPicked" Text="Picked:" runat="server" meta:resourcekey="lblReportKeysPicked" /></td>
                                <td>
                                    <asp:Label ID="lblReportKeysPickedTotal" runat="server" />
                                    <br />
                                    <asp:BulletedList ID="lstReportKeysPicked" runat="server"></asp:BulletedList>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblReportKeysReturned" Text="Returned:" runat="server" meta:resourcekey="lblReportKeysReturned" />
                                </td>
                                <td>
                                    <asp:Label ID="lblReportKeysReturnedTotal" runat="server" />
                                    <br />
                                    <asp:BulletedList ID="lstReportKeysReturned" runat="server"></asp:BulletedList>
                                </td>
                            </tr>
                            <tr class="tblRegMgr_Signature">
                                <!-- This row is only visible when printing the document -->
                                <td>
                                    <asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">Signature:</asp:Literal></td>
                                <td>
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    ___________________________________________________________</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="btnReportOK" OnClick="btnReportOK_Click" Height="34px" Width="150px" Text="OK" runat="server" meta:resourcekey="btnReportOK" />
                                    <button onclick="javascript:window.print(); return false;" style="height: 34px; width: 150px;">
                                        <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Print</asp:Literal></button>
                                    <asp:HiddenField ID="hdnReportAutoPrint" runat="server" ClientIDMode="Static" />
                                </td>
                            </tr>
                        </table>


                    </asp:Panel>
                </asp:View>

            </asp:MultiView>

            <asp:Button Text="btnPopupMessage" ID="btnPopupMessage" runat="server" CssClass="Hidden" />
            <asp:Panel ID="pnlMessage" runat="server" CssClass="modalPopup modalPopupWide" Height="274px" DefaultButton="btnPopupOK">
                <br />
                <br />
                <asp:Label ID="lblMessage" runat="server" Visible="False" Text="lblMessage" CssClass="error"></asp:Label>
                <br />
                <br />
                <br />
                <br />
                <asp:Button ID="btnPopupOK" Text="OK" runat="server" OnClick="btnPopupOK_Click" Height="34px" Width="110px" meta:resourcekey="btnPopupOK" />
            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="pnlMessage_ModalPopupExtender" runat="server" BackgroundCssClass="modalBackground"
                Enabled="True" TargetControlID="btnPopupMessage" PopupControlID="pnlMessage">
            </ajaxToolkit:ModalPopupExtender>

            <asp:Button Text="btnPopupInfo" CssClass="Hidden" ID="btnPopupInfo" runat="server" />

            <asp:Panel ID="pnlShowInfo" runat="server" Height="274px" CssClass="modalPopup modalPopupWide" DefaultButton="btnShowInfoOK">
                <strong>
                    <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">KeyCop information:</asp:Literal></strong>
                <br />

                <table class="tblKCAdv">
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Barcode:</asp:Literal></td>
                        <td>
                            <asp:Label ID="lblInfoBarcode" runat="server" Text="Label"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Label:</asp:Literal></td>
                        <td>
                            <asp:Label ID="lblInfoLabel" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Descripton:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblInfoDescription" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Groups:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblInfoGroups" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">KeyConductors:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblInfoKeyConductors" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">Status:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblInfoStatus" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>
                            <asp:Button ID="btnShowInfoOK" runat="server" Text="OK" Height="34px" Width="110px" OnClick="btnShowInfoOK_Click" ClientIDMode="Static" meta:resourcekey="btnShowInfoOK" />
                        </td>
                    </tr>

                </table>

            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="pnlShowInfo_ModalPopupExtender" runat="server" BackgroundCssClass="modalBackground"
                Enabled="True" TargetControlID="btnPopupInfo" PopupControlID="pnlShowInfo">
            </ajaxToolkit:ModalPopupExtender>

            <asp:Button Text="btnPopupHandOver" CssClass="Hidden" ID="btnPopupHandOver" runat="server" />

            <asp:Panel ID="pnlHandOver" runat="server" Height="274px" CssClass="modalPopup modalPopupWide" DefaultButton="btnShowInfoOK">

                <asp:Panel ID="pnlHandOverDisabled" runat="server">
                    <br />
                    <br />
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 20%"></td>
                            <td style="width: 80%">
                                <span class="error">
                                    <asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">KeyCop Hand-Over disabled!</asp:Literal></span>
                                <br />
                                <br />
                                <br />
                                <asp:Button ID="btnHandOverDisabledReturn" runat="server" Text="Return" OnClick="btnHandOverDisabledReturn_Click" meta:resourcekey="btnHandOverDisabledReturn" />
                            </td>
                        </tr>
                    </table>

                </asp:Panel>

                <asp:Panel ID="pnlHandOverConfirm" runat="server">
                    <strong>
                        <asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">KeyCop Hand-Over</asp:Literal></strong>
                    <table class="tblKCAdv">
                        <tr>
                            <td></td>
                            <td>
                                <asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">Please confirm the KeyCop hand-over</asp:Literal></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">KeyCop:</asp:Literal></td>
                            <td>
                                <asp:Label Text="lblHandOverKeyCop" ID="lblHandOverKeyCop" runat="server" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">Original owner:</asp:Literal></td>
                            <td>
                                <asp:Label Text="lblHandOverOriginalUser" ID="lblHandOverOriginalUser" runat="server" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">Returned by:</asp:Literal></td>
                            <td>
                                <asp:Label Text="lblHandOverReturnUser" ID="lblHandOverReturnUser" runat="server" /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">Confirm:</asp:Literal></td>
                            <td>
                                <asp:Button ID="btnHandOverConfirm" runat="server" Text="Confirm" OnClick="btnHandOverConfirm_Click" meta:resourcekey="btnHandOverConfirm" />
                                <asp:Button ID="btnHandOverCancel" runat="server" Text="Cancel" OnClick="btnHandOverCancel_Click" meta:resourcekey="btnHandOverCancel" />
                                <asp:HiddenField ID="hdnHandOverKeyCopID" runat="server" Value="0" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="pnlHandOver_ModalPopupExtender" runat="server" BackgroundCssClass="modalBackground"
                Enabled="True" TargetControlID="btnPopupHandOver" PopupControlID="pnlHandOver">
            </ajaxToolkit:ModalPopupExtender>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
