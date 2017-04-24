<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="KCWebManager.Inventory" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function RedirectToReport(ID) {
            var url = "InventoryReport?ID=" + ID;
            window.location = url;
        }

        function ConfirmStop() {
            var hdnInventoryStarted = jq("#hdnInventoryStarted");
            if(hdnInventoryStarted.val().length > 0)
            {
                return confirm(hdnInventoryStarted.val());
            }
            else
            {
                return true;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:SqlDataSource runat="server" ID="dsInventoryReports" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
        SelectCommand="
                SELECT 
		            invS.ID
		            ,invS.UserName
		            ,invS.KeyConductorName
		            ,invS.EndTime
		            ,count(case when (invR.Expectedstatus = 0 and invR.FoundStatus = 0) OR (invR.Expectedstatus = 1 and invR.FoundStatus = 1) then 1 end) as CountOK            
                    ,count(case when (invR.Expectedstatus = 0 and invR.FoundStatus = 1) OR (invR.Expectedstatus = 1 and invR.FoundStatus = 0) then 1 end) as CountExceptions
		            ,invS.Remarks
	            FROM [InventorySession] invS
	            LEFT JOIN [InventoryResult] invR on invS.ID = invR.InventorySessionID
	            WHERE invS.[KeyConductorID] = @KeyConductorID
	            GROUP BY 
		            invS.ID,
		            invS.UserName,
		            invS.KeyConductorName,
		            invS.EndTime,
		            invS.Remarks
                ORDER BY invS.[EndTime] DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="optKeyConductors" DefaultValue="0" Name="KeyConductorID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>


    <table class="tblKCAdv">
        <tr>
            <td>
                <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">Registration Manager:</asp:Literal></td>
            <td>
                <asp:RadioButtonList ID="optKeyConductors" runat="server" OnSelectedIndexChanged="optKeyConductors_SelectedIndexChanged" AutoPostBack="True"></asp:RadioButtonList>

                <asp:Label ID="lblNoKeyConductors" runat="server" Visible="false" CssClass="warning" Text="There are no Registration Managers available." meta:resourcekey="lblNoKeyConductors" />

            </td>
        </tr>
    </table>



    <asp:GridView ID="grdReports" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" DataSourceID="dsInventoryReports" PageSize="15"
        DataKeyNames="ID"
        OnSelectedIndexChanged="grdReports_SelectedIndexChanged"
        OnRowDataBound="grdReports_RowDataBound"
        CssClass="Grid" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
        <AlternatingRowStyle CssClass="GridAlt"></AlternatingRowStyle>
        <Columns>
            <asp:BoundField DataField="EndTime" HeaderText="EndTime" SortExpression="EndTime" meta:resourcekey="BoundFieldResource0" />
            <asp:BoundField DataField="UserName" HeaderText="UserName" SortExpression="UserName" meta:resourcekey="BoundFieldResource1" />
            <asp:BoundField DataField="CountOK" HeaderText="OK" SortExpression="CountOK" meta:resourcekey="BoundFieldResource2" />
            <asp:BoundField DataField="CountExceptions" HeaderText="Exceptions" SortExpression="CountExceptions" meta:resourcekey="BoundFieldResource3" />
            <asp:BoundField DataField="Remarks" HeaderText="Remarks" SortExpression="Remarks" meta:resourcekey="BoundFieldResource4" />
        </Columns>
        <EmptyDataTemplate>
            <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">No reports available.</asp:Literal>
        </EmptyDataTemplate>

        <HeaderStyle CssClass="GridHdr"></HeaderStyle>

        <PagerStyle CssClass="GridPgr"></PagerStyle>
    </asp:GridView>

    <asp:Button Text="btnStartStopInventory" ID="btnStartStopInventory" runat="server" OnClientClick="javascript:return ConfirmStop();" OnClick="btnStartStopInventory_Click" />
    <asp:HiddenField  ID="hdnInventoryStarted" runat="server" ClientIDMode="Static" Value=""/>

</asp:Content>
