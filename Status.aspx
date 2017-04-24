<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="Status.aspx.cs" Inherits="KCWebManager.Status" %>

<%@ Register Src="~/Controls/SingleRow.ascx" TagPrefix="uc1" TagName="SingleRow" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function InitializeRequestHandler(sender, args) {
        }

        function BeginRequestHandler(sender, args) {
        }

        function EndRequestHandler(sender, args) {
            AddClickHandlers();
        }

        jq(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_initializeRequest(InitializeRequestHandler)
            Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
            AddClickHandlers();
        });

        function AddClickHandlers() {
            // this function replaces the [i] button with a generic CLICK-handler
            // only works with DIVS that contain an [i] button
            jq(".SingleSlot").each(function () {
                //var btnInfo = jq(this).find(":submit").first();
                //btnInfo.hide();

                //jq(this).find(":submit").hide();

                var checkBox = jq(this).find("input:checkbox");

                if (checkBox.attr("disabled") != "disabled") {

                    jq(this).css("cursor", "pointer");

                    // remove existing handlers
                    jq(this).off("click");

                    // add new handler
                    jq(this).on("click", function () {

                        jq(this).find("input:checkbox").attr("checked", true);

                        jq("#btnShowInfo").click();
                    });

                    // do not attach the click handler to the checkbox

                    checkBox.off("click");
                    jq(checkBox).on("click", function (e) {
                        // enable or disable the multi-functionality
                        e.stopPropagation();
                    });
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- modal popup placeholders -->
    <asp:Button ID="btnHiddenDetails" runat="server" Text="" Style="display: none" />

    <asp:UpdatePanel ID="udpStatus" runat="server">
        <ContentTemplate>

            <asp:Panel ID="pnlFilter" runat="server" DefaultButton="btnSearch">
                <table style="width: 100%;" class="tblFilter">
                    <tr>
                        <td style="width: 30%;">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="unwatermark" />
                            <ajaxToolkit:TextBoxWatermarkExtender ID="txtSearch_TextBoxWatermarkExtender" runat="server" BehaviorID="txtSearch_TextBoxWatermarkExtender" TargetControlID="txtSearch" WatermarkCssClass="watermark" WatermarkText="Search..." />
                            <asp:Button ID="btnSearch" runat="server" Text="&gt;" OnClick="btnSearch_Click" />
                        </td>
                        <td>
                            <asp:DropDownList ID="cmbKeyConductor" runat="server" AutoPostBack="true">
                            </asp:DropDownList>
                                <asp:Button ID="btnRefresh" runat="server" 
                                    OnClick="btnRefresh_Click"
                                    ToolTip="Reload"
                                    Text=""
                                    CssClass="RefreshButton"
                                     />


                            <asp:CheckBox ID="chkAutoReload" runat="server" Text="Auto reload" OnCheckedChanged="chkAutoReload_CheckedChanged" AutoPostBack="true" meta:resourcekey="chkAutoReload" />
                            <asp:Timer ID="timAutoReload" runat="server" Interval="5000" Enabled="False" OnTick="timAutoReload_Tick">
                            </asp:Timer>
                        </td>
                        <td style="text-align: right;" >
                                <asp:Button ID="btnShowInfo" runat="server" ClientIDMode="Static"
                                    OnClick="btnShowInfo_Click"
                                    ToolTip="Show information"
                                    Text="KeyCop info"
                                    CssClass="InfoButton" meta:resourcekey="btnShowInfo"/>
                        </td>
                    </tr>
                </table>
            </asp:Panel>

            <asp:Panel ID="pnlOutOfDateWarning" runat="server" CssClass="warning">
                <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">Displaying status from</asp:Literal> <asp:Label ID="lblOutOfDate" Text="Monday, June 15, 2009 1:45:30 PM" runat="server"></asp:Label><asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">. This information is out-of-date!</asp:Literal>
                <br />
                <a href="Synchronize"><asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Synchronize</asp:Literal></a> <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">the KeyConductor to retrieve current status.</asp:Literal>
            </asp:Panel>

            <table id="tblStatus">
                <tr>
                    <td colspan="2">
                        <uc1:SingleRow runat="server" ID="SingleRow1" Text="1" EnableViewState="true" meta:resourcekey="SingleRow1" />
                        <uc1:SingleRow runat="server" ID="SingleRow2" Text="2" EnableViewState="true" meta:resourcekey="SingleRow2" />
                        <uc1:SingleRow runat="server" ID="SingleRow3" Text="3" EnableViewState="true" meta:resourcekey="SingleRow3" />
                        <uc1:SingleRow runat="server" ID="SingleRow4" Text="4" EnableViewState="true" meta:resourcekey="SingleRow4" />
                        <uc1:SingleRow runat="server" ID="SingleRow5" Text="5" EnableViewState="true" meta:resourcekey="SingleRow5" />
                        <uc1:SingleRow runat="server" ID="SingleRow6" Text="6" EnableViewState="true" meta:resourcekey="SingleRow6" />
                        <uc1:SingleRow runat="server" ID="SingleRow7" Text="7" EnableViewState="true" meta:resourcekey="SingleRow7" />
                        <uc1:SingleRow runat="server" ID="SingleRow8" Text="8" EnableViewState="true" meta:resourcekey="SingleRow8" />
                        <uc1:SingleRow runat="server" ID="SingleRow9" Text="9" EnableViewState="true" meta:resourcekey="SingleRow9" />
                        <uc1:SingleRow runat="server" ID="SingleRow10" Text="10" EnableViewState="true" meta:resourcekey="SingleRow10" />
                        <uc1:SingleRow runat="server" ID="SingleRow11" Text="11" EnableViewState="true" meta:resourcekey="SingleRow11" />
                        <uc1:SingleRow runat="server" ID="SingleRow12" Text="12" EnableViewState="true" meta:resourcekey="SingleRow12" />
                        <uc1:SingleRow runat="server" ID="SingleRow13" Text="13" EnableViewState="true" meta:resourcekey="SingleRow13" />
                        <uc1:SingleRow runat="server" ID="SingleRow14" Text="14" EnableViewState="true" meta:resourcekey="SingleRow14" />
                        <uc1:SingleRow runat="server" ID="SingleRow15" Text="15" EnableViewState="true" meta:resourcekey="SingleRow15" />

                    </td>
                </tr>
            </table>


        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:Panel ID="pnlSlotDetails" runat="server" CssClass="modalPopup">
        <asp:UpdatePanel ID="updDetails" runat="server">
            <ContentTemplate>
                <table style="height: 100%; width: 100%;" class="tblKCAdv">
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Position:</asp:Literal></td>
                        <td>
                            <asp:Label ID="lblDetailsPosition" runat="server" Text="Position" meta:resourcekey="lblDetailsPosition"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Status:</asp:Literal></td>
                        <td>
                            <asp:Label ID="lblDetailsStatus" runat="server" Text="Status" meta:resourcekey="lblDetailsStatus"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Label:</asp:Literal></td>
                        <td>
                            <asp:Label ID="lblDetailsLabel" runat="server" Text="KeyCop Label" meta:resourcekey="lblDetailsLabel"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Description:</asp:Literal></td>
                        <td>
                            <asp:Label ID="lblDetailsDesc" runat="server" Text="KeyCop Description" meta:resourcekey="lblDetailsDesc"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Current location:</td>
                        <td>
                            <asp:Label ID="lblCurrentLocation" runat="server" Text="Current location info"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Reservation:</asp:Literal></td>
                        <td>
                            <asp:Label ID="lblDetailsReservation" runat="server" Text="Reservation info" meta:resourcekey="lblDetailsReservation"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblRemoteRelease" runat="server" Text="Remote release:" meta:resourcekey="lblRemoteRelease"></asp:Label></td>
                        <td>
                            <asp:Panel ID="pnlRemoteRelease" runat="server">
                                <table style="width: 100%;">
                                    <tr>
                                        <td>
                                            <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">To:</asp:Literal></td>
                                        <td>
                                            <asp:DropDownList ID="ddlRemoteReleaseUser" runat="server"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Reason:</asp:Literal></td>
                                        <td>
                                            <asp:RadioButtonList ID="optRemoteReleaseReason" runat="server"></asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <asp:Button ID="btnRemoteRelease" runat="server" Text="Remote release" OnClick="btnRemoteRelease_Click" meta:resourcekey="btnRemoteRelease" />
                                            <asp:HiddenField ID="hdnKeyCopID" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>

                            <br />
                            <br />
                            <asp:Button ID="btnDetailsClose" runat="server" Text="Close" OnClick="btnDetailsClose_Click" Height="34px" Width="110px" meta:resourcekey="btnDetailsClose" /></td>
                    </tr>

                </table>
            </ContentTemplate>
        </asp:UpdatePanel>



    </asp:Panel>
    <ajaxToolkit:ModalPopupExtender ID="pnlSlotDetails_ModalPopupExtender" runat="server" Enabled="True"
        TargetControlID="btnHiddenDetails" PopupControlID="pnlSlotDetails" BackgroundCssClass="modalBackground">
    </ajaxToolkit:ModalPopupExtender>

</asp:Content>

