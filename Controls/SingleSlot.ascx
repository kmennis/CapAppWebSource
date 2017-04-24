<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SingleSlot.ascx.cs" Inherits="KCWebManager.Controls.SingleSlot" %>

<asp:Panel ID="pnlSlot" runat="server" CssClass="SingleSlot" EnableViewState="false">
    
    <asp:Label ID="txtSlot" runat="server" Text="1" CssClass="SingleSlotLabel" />
    <asp:Label ID="txtDesc" runat="server" Text="" CssClass="SingleSlotDesc"/>
    <asp:CheckBox ID="chkSlot" runat="server" />
</asp:Panel>
