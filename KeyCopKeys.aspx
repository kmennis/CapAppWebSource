<%@ Page Title="" Language="C#"
    MasterPageFile="~/ConfigPages.Master"
    AutoEventWireup="true"
    EnableEventValidation="false"
    CodeBehind="KeyCopKeys.aspx.cs"
    Inherits="KCWebManager.KeyCopKeys" %>

<%@ Register Src="~/Controls/EntityControl.ascx" TagPrefix="uc1" TagName="EntityControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .KeyImage {
            max-width: 200px;
            max-height: 200px;
        }

        .KeysViewPort {
            margin-left: 3px;
        }

        .Grid {
            width: 710px !important;
        }
        .tblKCAdv {
            width: 700px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="KeysViewPort">

        <asp:SqlDataSource ID="dsKeys" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
            SelectCommand="SELECT [ID], [Description], [Status] FROM [Key] WHERE ([KeyChain_ID] = @KeyChain_ID) ORDER BY [Description]">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="KeyChain_ID" QueryStringField="KeyCop" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <% // Notice the --IMAGE: format, this is removed in dsSingleKey_InsertingUpdating when an image is uploaded %>
        <asp:SqlDataSource ID="dsSingleKey" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
            SelectCommand="SELECT * FROM [Key] WHERE ([ID] = @ID)"
            DeleteCommand="DELETE FROM [Key] WHERE [ID] = @ID"
            OnUpdating="dsSingleKey_InsertingUpdating"
            OnInserting="dsSingleKey_InsertingUpdating"
            OnInserted="dsSingleKey_Inserted"
            InsertCommand="
            INSERT INTO [Key] 
                ([KeyChain_ID], [KeyType_ID], [KeyMft_ID], [Description], [SerialNr], 
                 [Notes], [Status], 
                 --IMAGE:[Image], 
                [AddedOn], [AddedBy]) 
            VALUES (@KeyChain_ID, @KeyType_ID, @KeyMft_ID, @Description, @SerialNr, 
                    @Notes, @Status, 
                    --IMAGE: @Image, 
                    GETDATE(), @CurrentUserID)
            SELECT @NewKeyID = SCOPE_IDENTITY()"
            UpdateCommand="
            UPDATE [Key] 
            SET [KeyChain_ID] = @KeyChain_ID, [KeyType_ID] = @KeyType_ID, [KeyMft_ID] = @KeyMft_ID, [Description] = @Description, 
                [SerialNr] = @SerialNr, [Notes] = @Notes, [Status] = @Status
                --IMAGE: ,[Image] = @Image
                , [ModifiedOn] = GETDATE(), [ModifiedBy] = @CurrentUserID 
        WHERE [ID] = @ID">
            <DeleteParameters>
                <asp:Parameter Name="ID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="KeyChain_ID" QueryStringField="KeyCop" Type="Int32" />
                <asp:Parameter Name="KeyType_ID" Type="Int32" />
                <asp:Parameter Name="KeyMft_ID" Type="Int32" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="SerialNr" Type="String" />
                <asp:Parameter Name="Notes" Type="String" />
                <asp:Parameter Name="Status" Type="Int32" />
                <asp:Parameter Name="Image" />
                <asp:Parameter Name="AddedBy" Type="Int32" />
                <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                <asp:Parameter Name="NewKeyID" Type="Int32" Direction="Output" />
            </InsertParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="grdKeys" DefaultValue="0" Name="ID" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="KeyChain_ID" QueryStringField="KeyCop" Type="Int32" />
                <asp:Parameter Name="KeyType_ID" Type="Int32" />
                <asp:Parameter Name="KeyMft_ID" Type="Int32" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="SerialNr" Type="String" />
                <asp:Parameter Name="Notes" Type="String" />
                <asp:Parameter Name="Status" Type="Int32" />
                <asp:Parameter Name="Image" />
                <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                <asp:Parameter Name="ID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>


        <asp:Panel ID="pnlGrid" runat="server">

            <asp:GridView ID="grdKeys" runat="server"
                AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" DataSourceID="dsKeys"
                PageSize="15"
                DataKeyNames="ID"
                OnSelectedIndexChanged="grdKeys_SelectedIndexChanged"
                OnRowDataBound="grdKeys_RowDataBound"
                CssClass="Grid" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                <Columns>
                    <asp:BoundField DataField="Description" HeaderText="Description" InsertVisible="false" ReadOnly="true" SortExpression="Description" meta:resourcekey="BoundFieldResource0"/>
                    <asp:BoundField DataField="Status" HeaderText="Status" InsertVisible="false" ReadOnly="true" SortExpression="Status" meta:resourcekey="BoundFieldResource1"/>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">There are no Keys defined for this KeyCop.</asp:Literal>
                </EmptyDataTemplate>
            </asp:GridView>
        </asp:Panel>

        <asp:FormView ID="fvwKey" runat="server"
            DataKeyNames="ID"
            DataSourceID="dsSingleKey"
            OnItemDeleted="fvwKey_ItemDeleted"
            OnItemUpdated="fvwKey_ItemUpdated">
            <EditItemTemplate>
                <table class="tblKCAdv">
                    <tr>
                        <td><asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Type:</asp:Literal></td>
                        <td>
                            <asp:SqlDataSource ID="dsKeyType" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                SelectCommand="SELECT [ID], [Description] FROM [KeyType] ORDER BY [Description]"></asp:SqlDataSource>
                            <asp:DropDownList ID="ddlKeyType" runat="server"
                                DataSourceID="dsKeyType"
                                DataMember="DefaultView"
                                DataValueField="ID"
                                DataTextField="Description"
                                AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("KeyType_ID") %>'>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Manufacturer:</asp:Literal></td>
                        <td>
                            <asp:SqlDataSource ID="dsKeyMft" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                SelectCommand="SELECT [ID], [Description] FROM [KeyMft] ORDER BY [Description]"></asp:SqlDataSource>
                            <asp:DropDownList ID="ddlKeyMft" runat="server"
                                DataSourceID="dsKeyMft"
                                DataMember="DefaultView"
                                DataValueField="ID"
                                DataTextField="Description"
                                AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("KeyMft_ID") %>'>
                            </asp:DropDownList>

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Description:</asp:Literal></td>
                        <td>
                            <asp:TextBox ID="DescriptionTextBox" runat="server" MaxLength="50" Width="300" Text='<%# Bind("Description") %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">SerialNr:</asp:Literal></td>
                        <td>
                            <asp:TextBox ID="SerialNrTextBox" runat="server" MaxLength="50" Width="300" Text='<%# Bind("SerialNr") %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Notes:</asp:Literal></td>
                        <td>
                            <asp:TextBox ID="NotesTextBox" TextMode="MultiLine" Height="100" Width="500" runat="server" Text='<%# Bind("Notes") %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Status:</asp:Literal></td>
                        <td>
                            <asp:DropDownList ID="ddlStatus" runat="server" SelectedValue='<%# Bind("Status") %>'>
                                <asp:ListItem Value="1" Text="Active" meta:resourcekey="ListItemResource0"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Inactive" meta:resourcekey="ListItemResource1"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Image:</asp:Literal></td>
                        <td>
                            <asp:Image ID="ImageImage" runat="server" CssClass="KeyImage" ImageUrl='<%# GetImageUrl(DataBinder.Eval(Container.DataItem, "ID")) %>' />
                            <br />
                            <asp:FileUpload ID="ImageFileUpload" Width="300" runat="server" />

                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                    </tr>
                </table>

            </EditItemTemplate>
            <InsertItemTemplate>
                <table class="tblKCAdv">
                    <tr>
                        <td><asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Type:</asp:Literal></td>
                        <td>
                            <asp:SqlDataSource ID="dsKeyType" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                SelectCommand="SELECT [ID], [Description] FROM [KeyType] ORDER BY [Description]"></asp:SqlDataSource>
                            <asp:DropDownList ID="ddlKeyType" runat="server"
                                DataSourceID="dsKeyType"
                                DataMember="DefaultView"
                                DataValueField="ID"
                                DataTextField="Description"
                                AppendDataBoundItems="True"
                                Width="150"
                                SelectedValue='<%# Bind("KeyType_ID") %>'>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Manufacturer:</asp:Literal></td>
                        <td>
                            <asp:SqlDataSource ID="dsKeyMft" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                SelectCommand="SELECT [ID], [Description] FROM [KeyMft] ORDER BY [Description]"></asp:SqlDataSource>
                            <asp:DropDownList ID="ddlKeyMft" runat="server"
                                DataSourceID="dsKeyMft"
                                DataMember="DefaultView"
                                DataValueField="ID"
                                DataTextField="Description"
                                AppendDataBoundItems="True"
                                Width="150"
                                SelectedValue='<%# Bind("KeyMft_ID") %>'>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Description:</asp:Literal></td>
                        <td>
                            <asp:TextBox ID="DescriptionTextBox" runat="server" MaxLength="50" Width="300" Text='<%# Bind("Description") %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">SerialNr:</asp:Literal></td>
                        <td>
                            <asp:TextBox ID="SerialNrTextBox" runat="server" MaxLength="50" Width="300" Text='<%# Bind("SerialNr") %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">Notes:</asp:Literal></td>
                        <td>
                            <asp:TextBox ID="NotesTextBox" runat="server" TextMode="MultiLine" Height="100" Width="500" Text='<%# Bind("Notes") %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">Status:</asp:Literal></td>
                        <td>
                            <asp:DropDownList ID="ddlStatus" runat="server" Width="150" SelectedValue='<%# Bind("Status") %>'>
                                <asp:ListItem Value="1" Text="Active" meta:resourcekey="ListItemResource2"></asp:ListItem>
                                <asp:ListItem Value="0" Text="Inactive" meta:resourcekey="ListItemResource3"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">Image:</asp:Literal></td>
                        <td>
                            <asp:FileUpload ID="ImageFileUpload" Width="300" runat="server" />
                        </td>
                    </tr>

                </table>

            </InsertItemTemplate>
            <ItemTemplate>
                <table class="tblKCAdv">
                    <tr>
                        <td><asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">Type:</asp:Literal></td>
                        <td>
                            <asp:SqlDataSource ID="dsKeyType" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                SelectCommand="SELECT [ID], [Description] FROM [KeyType] ORDER BY [Description]"></asp:SqlDataSource>
                            <asp:DropDownList ID="ddlKeyType" runat="server"
                                DataSourceID="dsKeyType"
                                DataMember="DefaultView"
                                DataValueField="ID"
                                DataTextField="Description"
                                AppendDataBoundItems="True"
                                Enabled="false"
                                Width="150"
                                SelectedValue='<%# Bind("KeyType_ID") %>'>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">Manufacturer:</asp:Literal></td>
                        <td>
                            <asp:SqlDataSource ID="dsKeyMft" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                                SelectCommand="SELECT [ID], [Description] FROM [KeyMft] ORDER BY [Description]"></asp:SqlDataSource>
                            <asp:DropDownList ID="ddlKeyMft" runat="server"
                                DataSourceID="dsKeyMft"
                                DataMember="DefaultView"
                                DataValueField="ID"
                                DataTextField="Description"
                                AppendDataBoundItems="True"
                                Enabled="false"
                                Width="150"
                                SelectedValue='<%# Bind("KeyMft_ID") %>'>
                            </asp:DropDownList>

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">Description:</asp:Literal></td>
                        <td>
                            <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">SerialNr:</asp:Literal></td>
                        <td>
                            <asp:Label ID="SerialNrLabel" runat="server" Text='<%# Bind("SerialNr") %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">Notes:</asp:Literal></td>
                        <td>
                            <asp:Label ID="NotesLabel" runat="server" Text='<%#  ShowLineBreaks(Eval("Notes")) %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">Status:</asp:Literal></td>
                        <td>
                            <asp:Label ID="StatusLabel" runat="server" Text='<%# GetStatus(Eval("Status")) %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">Image:</asp:Literal></td>
                        <td>
                            <asp:Image ID="ImageImage" runat="server" CssClass="KeyImage" ImageUrl='<%# GetImageUrl(Eval("ID")) %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource22" runat="server" meta:resourcekey="LiteralResource22">Added:</asp:Literal></td>
                        <td>
                            <asp:Label ID="AddedOnLabel" runat="server" Text='<%# Bind("AddedOn") %>' />
                            -
                            <asp:Label ID="AddedByLabel" runat="server" Text='<%# GetUser(Eval("AddedBy")) %>' />

                        </td>
                    </tr>
                    <tr>
                        <td><asp:Literal ID="LiteralResource24" runat="server" meta:resourcekey="LiteralResource24">Modified:</asp:Literal></td>
                        <td>
                            <asp:Label ID="ModifiedOnLabel" runat="server" Text='<%# Bind("ModifiedOn") %>' />
                            -
                            <asp:Label ID="ModifiedByLabel" runat="server" Text='<%# GetUser(Eval("ModifiedBy")) %>' />

                        </td>
                    </tr>
                </table>

            </ItemTemplate>
        </asp:FormView>

        <uc1:EntityControl runat="server" ID="EntityControl"
            OnClicked="EntityControl_Clicked" />
    </div>
</asp:Content>
