<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EntityControl.ascx.cs" Inherits="KCWebManager.Controls.EntityControl" %>

<asp:Panel ID="pnlEntityControl" runat="server" CssClass="EntityControl">

    <asp:ImageButton ID="btnList" runat="server" 
        ImageUrl="~/Content/FamFamFam/application_view_detail.png" 
        OnClick="btnList_Click"
        ToolTip="List" meta:resourcekey="btnList"/>

    <asp:ImageButton ID="btnAdd" runat="server" 
        ImageUrl="~/Content/FamFamFam/add.png" 
        OnClick="btnAdd_Click"
        ToolTip="Add" meta:resourcekey="btnAdd"/>

    <asp:ImageButton ID="btnEntityControlDelete" runat="server" 
        ImageUrl="~/Content/FamFamFam/delete.png" 
        OnClick="btnEntityControlDelete_Click"
        ClientIDMode="Static"
        ToolTip="Delete" meta:resourcekey="btnEntityControlDelete"/>

    <asp:ImageButton ID="btnEdit" runat="server" 
        ImageUrl="~/Content/FamFamFam/page_white_edit.png" 
        OnClick="btnEdit_Click"
        ToolTip="Edit" meta:resourcekey="btnEdit"/>

    <asp:ImageButton ID="btnUndo" runat="server" 
        ImageUrl="~/Content/FamFamFam/arrow_undo2.png" 
        OnClick="btnUndo_Click"
        ToolTip="Cancel and return" meta:resourcekey="btnUndo"/>

    <asp:ImageButton ID="btnEntityControlSave" runat="server" 
        ImageUrl="~/Content/FamFamFam/disk.png" 
        OnClick="btnEntityControlSave_Click"
        ClientIDMode="Static"
        ToolTip="Save changes" meta:resourcekey="btnSave"/>

</asp:Panel>