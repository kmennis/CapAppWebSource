<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SingleRow.ascx.cs" Inherits="KCWebManager.Controls.SingleRow" %>
<%@ Register Src="~/Controls/SingleSlot.ascx" TagPrefix="uc1" TagName="SingleSlot" %>

<asp:Panel ID="Panel1" runat="server" CssClass="SingleRow" EnableViewState="false">
    <table>
        <tr>
            <td>
                <asp:Label ID="lblRowID" runat="server" Text="Row 1"></asp:Label>
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot1" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot2" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot3" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot4" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot5" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot6" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot7" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot8" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot9" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot10" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot11" OnClick="slot_Click" />
            </td>
            <td>
                <uc1:SingleSlot runat="server" ID="slot12" OnClick="slot_Click" />
            </td>
        </tr>
    </table>
</asp:Panel>
