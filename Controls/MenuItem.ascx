<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MenuItem.ascx.cs" Inherits="KCWebManager.Controls.MenuItem" %>
<asp:Panel ID="pnlMenu" runat="server">
    <asp:ImageButton ID="imgMenu" runat="server" OnClick="imgMenu_Click" />
    <asp:LinkButton ID="lnkMenu" runat="server" OnClick="lnkMenu_Click">LinkButton</asp:LinkButton>
    <asp:Panel ID="pnlSubItems" runat="server" CssClass="divSubMenu">
    </asp:Panel>
</asp:Panel>
