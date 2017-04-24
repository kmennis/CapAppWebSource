<%@ Page Title="" Language="C#" MasterPageFile="~/KCWebMgr.Master" AutoEventWireup="true" CodeBehind="InventoryReport.aspx.cs" Inherits="KCWebManager.InventoryReport" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>
        function ApplyRemarkTemplate() {
            //ddlInventoryRemarks
            //txtEditRemarks
            var ddlInventoryRemarks = jq("#ddlInventoryRemarks");
            var txtEditRemarks = jq("#txtEditRemarks");
            txtEditRemarks.text(ddlInventoryRemarks.val());
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel runat="server">
        <ContentTemplate>

            <asp:SqlDataSource ID="dsInventorySession" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
            select *
	            ,(case when CountExpected != 0 then ((InOK * 100) / CountExpected) else 0 end) as PercFoundOK
                ,InOK + OutOK as CountOK
                ,ShouldBeIn + ShouldBeOut as CountExceptions
            from
            (
	            SELECT 
		            invS.ID
		            ,invS.UserName
		            ,invS.KeyConductorName
		            ,invS.EndTime
		            ,invS.Remarks
		            ,count(invR.ID) as TotalKeyCops
		            ,count(case when invR.Expectedstatus = 1 and invR.FoundStatus = 1 then 1 end) as InOK
		            ,count(case when invR.ExpectedStatus = 1 then 1 end) as CountExpected
		
		            --,count(case when invR.FoundStatus = 1 then 1 end) as CountFound
		            ,count(case when invR.Expectedstatus = 0 and invR.FoundStatus = 0 then 1 end) as OutOK
		            ,count(case when invR.Expectedstatus = 0 and invR.FoundStatus = 1 then 1 end) as ShouldBeOut
		            ,count(case when invR.Expectedstatus = 1 and invR.FoundStatus = 0 then 1 end) as ShouldBeIn
		            --,count(case when (invR.Expectedstatus = 0 and invR.FoundStatus = 1) OR (invR.Expectedstatus = 1 and invR.FoundStatus = 0) then 1 end) as CountInvalid
		            --,count(case when (invR.Expectedstatus = 0 and invR.FoundStatus = 0) OR (invR.Expectedstatus = 1 and invR.FoundStatus = 1) then 1 end) as CountValid

	            FROM [InventorySession] invS
	            LEFT JOIN [InventoryResult] invR on invS.ID = invR.InventorySessionID
	            WHERE invS.[ID] = @ID
	            GROUP BY 
		            invS.ID,
		            invS.UserName,
		            invS.KeyConductorName,
		            invS.EndTime,
		            invS.Remarks
            ) results "
                UpdateCommand="UPDATE InventorySession SET [Remarks] = @Remarks WHERE ID = @ID">
                <SelectParameters>
                    <asp:QueryStringParameter Name="ID" ValidateInput="true" DefaultValue="0" Type="Int32" QueryStringField="ID" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:QueryStringParameter Name="ID" ValidateInput="true" DefaultValue="0" Type="Int32" QueryStringField="ID" />
                    <asp:ControlParameter Name="Remarks" ControlID="txtEditRemarks" PropertyName="Text" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsInventoryResults" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
            SELECT ID, KeyCopNumber, KeyCopDescription, ExpectedStatus, FoundStatus, 
                    CASE WHEN LEN(Remarks) &gt; 30 THEN LEFT(Remarks, 30) + '...' ELSE Remarks END AS Remarks
            FROM [InventoryResult] 
            WHERE [InventorySessionID] = @ID
                    and
	                (
		                (0 = @FilterValue) 
		                OR
		                (1 = @FilterValue AND ExpectedStatus = 1 AND FoundStatus = 0)
		                OR
		                (2 = @FilterValue AND ExpectedStatus = 0 AND FoundStatus = 1)
	                )"
                UpdateCommand="UPDATE [InventoryResult] SET [Remarks] = @Remarks WHERE ID = @ID">
                <SelectParameters>
                    <asp:QueryStringParameter Name="ID" ValidateInput="true" DefaultValue="0" Type="Int32" QueryStringField="ID" />
                    <asp:ControlParameter Name="FilterValue" ControlID="ddlFilter" Type="Int32" PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:ControlParameter Name="ID" ControlID="hdnRemarkSource" PropertyName="Value" DefaultValue="0" />
                    <asp:ControlParameter Name="Remarks" ControlID="txtEditRemarks" PropertyName="Text" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <h1><asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">Inventory results</asp:Literal></h1>

            <table class="tblKCAdv">
                <tr>
                    <td>
                        <h3><asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Registration Manager::</asp:Literal></h3>
                    </td>
                    <td>
                        <h3>
                            <asp:Label Text="text" ID="lblKeyConductor" runat="server" /></h3>
                    </td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Total number of KeyCops:</asp:Literal></td>
                    <td>
                        <asp:Label Text="text" ID="lblTotal" runat="server" /></td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Found KeyCops:</asp:Literal></td>
                    <td>
                        <asp:Label Text="text" ID="lblFound" runat="server" /></td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">OK:</asp:Literal></td>
                    <td>
                        <asp:Label Text="text" ID="lblOK" runat="server" /></td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Exceptions:</asp:Literal></td>
                    <td>
                        <asp:Label Text="text" ID="lblExceptions" runat="server" /></td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Date/time:</asp:Literal></td>
                    <td>
                        <asp:Label Text="text" ID="lblDateTime" runat="server" /></td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">User:</asp:Literal></td>
                    <td>
                        <asp:Label Text="text" ID="lblUserName" runat="server" /></td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Remarks:</asp:Literal></td>
                    <td>
                        <asp:Label Text="text" ID="lblRemarks" runat="server" />

                        <asp:ImageButton ID="btnEditRemarks" runat="server" ImageUrl="~/Content/FamFamFam/report_edit.png" OnClick="btnEditRemarks_Click" />

                    </td>
                </tr>
                <tr>
                    <td><asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Display:</asp:Literal></td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlFilter" AutoPostBack="true">
                            <asp:ListItem Text="All KeyCops" Value="0" meta:resourcekey="ListItemResource0"/>
                            <asp:ListItem Text="KeyCops not found but should be present" Value="1" meta:resourcekey="ListItemResource1"/>
                            <asp:ListItem Text="KeyCops found but should be absent" Value="2" meta:resourcekey="ListItemResource2"/>
                        </asp:DropDownList>
                        <asp:DropDownList ID="ddlGridPageSize" runat="server" OnSelectedIndexChanged="ddlGridPageSize_SelectedIndexChanged" AutoPostBack="true" ToolTip="Select the number of records to display" meta:resourcekey="ddlGridPageSize">
                            <asp:ListItem Value="15" Text="15"></asp:ListItem>
                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>

            <asp:GridView ID="grdResults" runat="server"
                AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="dsInventoryResults"
                OnSelectedIndexChanged="grdResults_SelectedIndexChanged"
                OnRowDataBound="grdResults_RowDataBound"
                CssClass="Grid" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Image runat="server" ID="imgStatus" src='<%# (Eval("ExpectedStatus").ToString()==Eval("FoundStatus").ToString() ? "Content/FamFamFam/tick.png" : "Content/FamFamFam/cross.png") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="KeyCopNumber" HeaderText="Barcode" SortExpression="KeyCopNumber" meta:resourcekey="BoundFieldResource0"/>
                    <asp:BoundField DataField="KeyCopDescription" HeaderText="Description" SortExpression="KeyCopDescription" meta:resourcekey="BoundFieldResource1"/>
                    <asp:BoundField DataField="ExpectedStatus" HeaderText="Expected" SortExpression="ExpectedStatus" meta:resourcekey="BoundFieldResource2"/>
                    <asp:BoundField DataField="FoundStatus" HeaderText="Found" SortExpression="FoundStatus" meta:resourcekey="BoundFieldResource3"/>
                    <asp:BoundField DataField="Remarks" HeaderText="Remarks" SortExpression="Remarks" meta:resourcekey="BoundFieldResource4"/>
                </Columns>
            </asp:GridView>

            <!-- Edit InventorySession.Remarks -->
            <!-- Edit InventoryResult.Remarks -->
            <asp:Button ID="btnEditRemarks2" Text="Placeholder" runat="server" CssClass="Hidden" />
            <asp:Panel runat="server" ID="pnlEditRemarks" CssClass="modalPopup" Height="300px" Width="450px">
                <h3><asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Edit remarks:</asp:Literal></h3>

                <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">Template:</asp:Literal>
                <asp:DropDownList runat="server" ID="ddlInventoryRemarks" ClientIDMode="Static">
                </asp:DropDownList>

                <br />
                <br />

                <asp:HiddenField runat="server" ID="hdnRemarkSource" />
                <asp:TextBox runat="server" TextMode="MultiLine" ID="txtEditRemarks" ClientIDMode="Static" Width="445px" Height="150px" />

                <div style="width: 100%; text-align: right; margin-top: 15px;">
                    <asp:Button ID="btnEditRemarksOK" Text="OK" runat="server" Height="34px" Width="100px" OnClick="btnEditRemarksOK_Click" meta:resourcekey="btnEditRemarksOK"/>
                    <asp:Button ID="btnEditRemarksCancel" Text="Cancel" runat="server" Height="34px" Width="100px" OnClick="btnEditRemarksCancel_Click" meta:resourcekey="btnEditRemarksCancel"/>
                </div>
            </asp:Panel>

            <ajaxToolkit:ModalPopupExtender ID="pnlEditRemarks_ModalPopupExtender" runat="server"
                TargetControlID="btnEditRemarks2"
                BackgroundCssClass="modalBackground"
                PopupControlID="pnlEditRemarks" Enabled="true">
            </ajaxToolkit:ModalPopupExtender>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
