<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="Reservation.aspx.cs" Inherits="KCWebManager.Reservation" %>

<%@ Register Assembly="DayPilot" Namespace="DayPilot.Web.Ui" TagPrefix="DayPilot" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link type="text/css" rel="stylesheet" href="Content/scheduler_8.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- modal popup placeholders -->
    <asp:Button ID="btnHiddenView" runat="server" Text="" Style="display: none" />
    <asp:Button ID="btnHiddenEdit" runat="server" Text="" Style="display: none" />

    <asp:UpdatePanel ID="udpScheduler" runat="server">
        <ContentTemplate>
            <table id="tblParams">
                <tr>
                    <td><asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">KeyConductor:</asp:Literal></td>
                    <td>
                        <asp:DropDownList ID="cmbKeyConductor" AutoPostBack="true" OnSelectedIndexChanged="cmbKeyConductor_SelectedIndexChanged" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">User:</asp:Literal></td>
                    <td>
                        <asp:DropDownList ID="cmbUser" runat="server" AutoPostBack="true" OnSelectedIndexChanged="cmbUser_SelectedIndexChanged">
                        </asp:DropDownList>

                    </td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Date:</asp:Literal></td>
                    <td>
                        <asp:TextBox ID="txtDate" runat="server" AutoPostBack="True" OnTextChanged="txtDate_TextChanged"></asp:TextBox>
                        <ajaxToolkit:CalendarExtender ID="txtDateExt" runat="server" TodaysDateFormat="d" Format="d" TargetControlID="txtDate"></ajaxToolkit:CalendarExtender>
                        (dd-MM-yyyy)
                    </td>
                </tr>
            </table>



            <br />

            <DayPilot:DayPilotScheduler
                ID="dpsReservations" runat="server"
                TimeFormat="Clock24Hours"
                CssClassPrefix="scheduler_8"
                EventHeight="30"
                HeaderHeight="25"
                EventClickHandling="PostBack"
                OnEventClick="dpsReservations_EventClick"
                TimeRangeSelectedHandling="PostBack"
                OnTimeRangeSelected="dpsReservations_TimeRangeSelected"
                CellWidth="25"
                RowHeaderWidth="150">
            </DayPilot:DayPilotScheduler>

        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:Panel ID="pnlDetails" runat="server" Height="274px" CssClass="modalPopup">
        <strong><asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Reservation details:</asp:Literal></strong>
        <br />

        <asp:UpdatePanel ID="udpDetails" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="fldDetailsID" runat="server" />
                <table>
                    <tr>
                        <td><asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">KeyConductor:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblDetailsKeyConductor" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">User:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblDetailsUser" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">KeyCop:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblDetailsKeyCop" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Group:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblDetailsGroup" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">From:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblDetailsFrom" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">To:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblDetailsTo" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">Status:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblDetailsStatus" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">Remarks:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblDetailsRemarks" runat="server" Text="Label"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>
                            <asp:Button ID="btnDetailsOK" runat="server" Text="OK" Height="34px" OnClick="btnDetailsOK_Click" Width="110px" meta:resourcekey="btnDetailsOK"/>
                            &nbsp;<asp:Button ID="btnDetailsEdit" runat="server" Text="Edit" Height="34px" OnClick="btnDetailsEdit_Click" Width="110px" meta:resourcekey="btnDetailsEdit"/>
                        </td>
                    </tr>

                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    <ajaxToolkit:ModalPopupExtender ID="pnlDetails_ModalPopupExtender" runat="server" DynamicServicePath="" BackgroundCssClass="modalBackground"
        Enabled="True" TargetControlID="btnHiddenView" PopupControlID="pnlDetails">
    </ajaxToolkit:ModalPopupExtender>

    <asp:Panel ID="pnlEdit" runat="server" Height="274px" CssClass="modalPopup">
        <strong><asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">Create/edit Reservation:</asp:Literal></strong>

        <asp:UpdatePanel ID="udpEditor" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="fldEditID" runat="server" />
                <asp:Label ID="lblEditError" runat="server" BackColor="#FFFF66" Text="Error label" Visible="False"></asp:Label>
                <br />
                <table>
                    <tr>
                        <td><asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">KeyConductor:</asp:Literal>
                        </td>
                        <td>
                            <asp:DropDownList ID="cmbEditKeyConductor" runat="server" OnSelectedIndexChanged="cmbKeyConductor_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">User:</asp:Literal>
                        </td>
                        <td>
                            <asp:DropDownList ID="cmbEditUser" runat="server" OnSelectedIndexChanged="cmbUser_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">KeyCop:</asp:Literal>
                        </td>
                        <td>
                            <asp:DropDownList ID="cmbEditKeyCop" runat="server" OnSelectedIndexChanged="cmbUser_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">Group:</asp:Literal>
                        </td>
                        <td>-
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">From:</asp:Literal>
                        </td>
                        <td>
                            <asp:TextBox ID="txtEditDateStart" runat="server" OnTextChanged="txtDate_TextChanged"></asp:TextBox>
                            <ajaxToolkit:CalendarExtender ID="txtEditDateStart_CalendarExtender" runat="server" TargetControlID="txtEditDateStart" TodaysDateFormat="d" Format="d">
                            </ajaxToolkit:CalendarExtender>
                            <asp:DropDownList ID="cmbEditTimeStart" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">To:</asp:Literal>
                        </td>
                        <td>
                            <asp:TextBox ID="txtEditDateEnd" runat="server" OnTextChanged="txtDate_TextChanged"></asp:TextBox>
                            <ajaxToolkit:CalendarExtender ID="txtEditDateEnd_CalendarExtender" runat="server" TargetControlID="txtEditDateEnd" TodaysDateFormat="d" Format="d">
                            </ajaxToolkit:CalendarExtender>
                            <asp:DropDownList ID="cmbEditTimeEnd" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">Status:</asp:Literal>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource22" runat="server" meta:resourcekey="LiteralResource22">Remarks:</asp:Literal>
                        </td>
                        <td>
                            <asp:TextBox ID="txtEditRemarks" runat="server" MaxLength="250" Height="21px" Width="236px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>
                            <asp:Button ID="btnEditSave" runat="server" Text="Save" Height="34px" OnClick="btnEditSave_Click" Width="82px" meta:resourcekey="btnEditSave"/>
                            &nbsp;
							<asp:Button ID="btnEditCancel" runat="server" Text="Cancel" Height="34px" OnClick="btnEditCancel_Click" Width="82px" meta:resourcekey="btnEditCancel"/>
                            &nbsp;
							<asp:Button ID="btnEditDelete" runat="server" Text="Delete" Height="34px" OnClick="btnEditDelete_Click" Width="82px" meta:resourcekey="btnEditDelete"/>
                        </td>
                    </tr>

                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    <ajaxToolkit:ModalPopupExtender ID="pnlEdit_ModalPopupExtender" runat="server" DynamicServicePath="" Enabled="True"
        TargetControlID="btnHiddenEdit" PopupControlID="pnlEdit" BackgroundCssClass="modalBackground">
    </ajaxToolkit:ModalPopupExtender>
    <br />


</asp:Content>
