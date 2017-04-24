<%@ Page
    Title=""
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    CodeBehind="ConfigSettings.aspx.cs"
    Inherits="KCWebManager.ConfigSettings"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:SqlDataSource ID="dsAllSettings" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT ID, Name, Value, ValueType FROM Setting WHERE (ValueType &lt;&gt; 'internal') ORDER BY Name"
                CancelSelectOnNullParameter="false">
                <FilterParameters>
                    <asp:ControlParameter ControlID="txtSearch" PropertyName="Text" ConvertEmptyStringToNull="false" />
                    <asp:ControlParameter ControlID="ddlCategoryFilter" PropertyName="SelectedValue" ConvertEmptyStringToNull="false" />
                </FilterParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="dsSingleSetting" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="SELECT * FROM [Setting] WHERE ([ID] = @ID)"
                UpdateCommand="UPDATE [Setting] SET [Value] = @Value WHERE [ID] = @ID"
                OnUpdating="dsSingleSetting_Updating">
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdSettings" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Value" Type="String" />
                    <asp:Parameter Name="ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:Panel ID="pnlGrid" runat="server">
                <asp:Panel ID="pnlFilter" runat="server" DefaultButton="btnSearch">
                    <table style="width: 100%;" class="tblFilter">
                        <tr>
                            <td style="width: 50%;">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="unwatermark" />
                                <ajaxToolkit:TextBoxWatermarkExtender ID="txtSearch_TextBoxWatermarkExtender" runat="server" BehaviorID="txtSearch_TextBoxWatermarkExtender" TargetControlID="txtSearch" WatermarkCssClass="watermark" />
                                <asp:Button ID="btnSearch" runat="server" Text="&gt;" OnClick="btnSearch_Click" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlCategoryFilter" runat="server" AutoPostBack="true">
                                    <asp:ListItem Value="" Text="All settings" meta:resourcekey="ListItemResource0"/>
                                    <asp:ListItem Value="Alert" Text="Alert" meta:resourcekey="ListItemResource1"/>
                                    <asp:ListItem Value="Inventory" Text="Inventory" meta:resourcekey="ListItemResource2"/>
                                    <asp:ListItem Value="KeyConductor" Text="KeyConductor" meta:resourcekey="ListItemResource3"/>
                                    <asp:ListItem Value="License" Text="License" meta:resourcekey="ListItemResource4"/>
                                    <asp:ListItem Value="Mail" Text="E-Mail" meta:resourcekey="ListItemResource5"/>
                                    <asp:ListItem Value="Password" Text="Authentication" meta:resourcekey="ListItemResource6"/>
                                    <asp:ListItem Value="RegMgr" Text="Registration Manager" meta:resourcekey="ListItemResource7"/>
                                    <asp:ListItem Value="RemoteRelease" Text="Remote Release" meta:resourcekey="ListItemResource8"/>
                                    <asp:ListItem Value="Reservation" Text="Reservation" meta:resourcekey="ListItemResource9"/>
                                    <asp:ListItem Value="Import" Text="Import" meta:resourcekey="ListItemResource10"/>
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: right;">
                                <asp:DropDownList ID="ddlGridPageSize" runat="server" OnSelectedIndexChanged="ddlGridPageSize_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem Value="15" Text="15"></asp:ListItem>
                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <asp:GridView ID="grdSettings" runat="server" AllowPaging="True" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="dsAllSettings"
                    PageSize="15" OnSelectedIndexChanged="grdSettings_SelectedIndexChanged"
                    OnRowDataBound="grdSettings_RowDataBound"
                    CssClass="Grid" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" meta:resourcekey="BoundFieldResource0" />
                        <asp:BoundField DataField="Value" HeaderText="Value" SortExpression="Value" meta:resourcekey="BoundFieldResource2" />
                        <asp:BoundField DataField="ValueType" HeaderText="ValueType" SortExpression="ValueType" meta:resourcekey="BoundFieldResource3"
                            HeaderStyle-CssClass="Hidden"
                            ControlStyle-CssClass="Hidden"
                            ItemStyle-CssClass="Hidden"
                            FooterStyle-CssClass="Hidden" />
                        

                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">No settings found.</asp:Literal>
                    </EmptyDataTemplate>
                    <HeaderStyle CssClass="GridHdr"></HeaderStyle>
                    <PagerStyle CssClass="GridPgr"></PagerStyle>
                </asp:GridView>
            </asp:Panel>

            <asp:FormView ID="fvwSetting" runat="server" DataKeyNames="ID" DataSourceID="dsSingleSetting" OnItemCommand="fvwSetting_ItemCommand" OnDataBound="fvwSetting_DataBound">
                <EditItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td style="width: 100px;"><b>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Name:</asp:Literal></b></td>
                            <td>
                                <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td><b>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Description:</asp:Literal></b></td>
                            <td>
                                <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' /></td>
                        </tr>
                        <tr>
                            <td><b>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">ValueType:</asp:Literal></b></td>
                            <td>
                                <asp:Label ID="ValueTypeLabel" runat="server" Text='<%# Bind("ValueType") %>' /></td>
                        </tr>
                        <tr>
                            <td><b>
                                <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Value:</asp:Literal></b></td>
                            <td>
                                <asp:TextBox ID="ValueTextBox" Width="550px" runat="server" Text='<%# Bind("Value") %>' />
                                <asp:CheckBox ID="ValueCheckBox" runat="server" />

                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Save" meta:resourcekey="UpdateButton" />
                                &nbsp;
                        <asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" meta:resourcekey="UpdateCancelButton" /></td>
                        </tr>
                    </table>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Inserting new settings must be done using a database tool.</asp:Literal>
                </InsertItemTemplate>
                <ItemTemplate>
                    <table class="tblKCAdv">
                        <tr>
                            <td style="width: 100px;"><b>
                                <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Name:</asp:Literal></b></td>
                            <td>
                                <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td><b>
                                <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Description:</asp:Literal></b></td>
                            <td>
                                <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' /></td>
                        </tr>
                        <tr>
                            <td><b>
                                <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">ValueType:</asp:Literal></b></td>
                            <td>
                                <asp:Label ID="ValueTypeLabel" runat="server" Text='<%# Bind("ValueType") %>' /></td>
                        </tr>
                        <tr>
                            <td><b>
                                <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Value:</asp:Literal></b></td>
                            <td>
                                <asp:Label ID="ValueLabel" runat="server" Text='<%# Bind("Value") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:LinkButton ID="ViewCancel" runat="server" CausesValidation="False" CommandName="List" Text="&lt; Return" meta:resourcekey="ViewCancel" />
                                &nbsp; 
                        <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" meta:resourcekey="EditButton" />
                            </td>
                        </tr>
                    </table>

                </ItemTemplate>
            </asp:FormView>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
