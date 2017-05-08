<%@ Page Title="KeyConductors"
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    EnableEventValidation="false"
    CodeBehind="KeyConductors.aspx.cs"
    Inherits="KCWebManager.KeyConductors" %>

<%@ Register Src="~/Controls/EntityControl.ascx" TagPrefix="uc1" TagName="EntityControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        var selected_tab = "";

        function InitializeRequestHandler(sender, args) {
            // if it is the delete action, ask for confirmation before actual delete happens
            if (args.get_postBackElement().id == 'btnEntityControlDelete') {
                // Check if unit is ENABLED, if so then this KC CANNOT be deleted
                // If not enabled, ask user confirmation for deletion
                var chkEnabled = document.getElementById('chkKCViewEnabled');
                if (chkEnabled == null) args.set_cancel(true); // not deletable

                if (chkEnabled.checked) {
                    // unit is still enabled and CANNOT be deleted at this moment. Inform user.
                    alert(jq("#resDeleteDisabled").text());
                    args.set_cancel(true);
                }
                else {
                    if (confirm(jq("#resDeleteAlert").text()) == false) {
                        args.set_cancel(true);
                    }
                }

            }
        }

        function BeginRequestHandler(sender, args) {
            selected_tab = jq("#tabs").tabs("option", "active");
        }

        function EndRequestHandler(sender, args) {
            if (args.get_error() != undefined) {
                var errorMessage;
                if (args.get_response().get_statusCode() == '200') {
                    errorMessage = args.get_error().message;
                }
                else {
                    // Error occurred somewhere other than the server page.
                    errorMessage = 'An unspecified error occurred. ';
                }
                args.set_errorHandled(true);
                alert(errorMessage);
                location.href = "KeyConductors";
            }

            InitializeTabs();
            InitializePositionizers();
        }

        function InitializeTabs() {

            // Getter
            //var active = $(".selector").tabs("option", "active");
            // Setter
            //$(".selector").tabs("option", "active", 1);

            jq(function () {
                var tabs = jq("#tabs").tabs({
                    select: function (e, i) {
                        selected_tab = i.index;
                    }
                });
                if (selected_tab != "") {
                    jq("#tabs").tabs("option", "active", selected_tab);
                }

                jq("form").submit(function () {
                    selected_tab = jq("#tabs").tabs("option", "active");
                });
            });
            jq("#tabs").css('width', '100%');
            jq("#tabs").height(450);
        }

        jq(document).ready(function () {
            InitializeTabs();
            InitializePositionizers();

        });

        function InitializePositionizers() {
            // Create a clickable link after each assigned slot based on span-attribute boundkckc
            // The javascript will click on a hidden button which will popup the pnlPositions in postback
            if (jq('#hdnCanEditKeyConductors').val() == "True") {
                jq('span[boundkckc]').each(function (i, el) {
                    var bndkckc = el.attributes['boundkckc'].value;
                    var slot = el.attributes['slot'].value;
                    jq(this).append(' (' + slot + ' <a href="#" onclick="javascript:ChangePosition(' + bndkckc + ');">edit</a>)');
                });
            }
        }

        function ChangePosition(boundkckc) {
            document.getElementById("hdnPositionBoundKCKC").value = boundkckc;
            document.getElementById("btnPositionHidden2").click();
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">
        // initializeRequest, beginRequest, pageLoading, pageLoaded, endRequest
        Sys.WebForms.PageRequestManager.getInstance().add_initializeRequest(InitializeRequestHandler)
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
    </script>
    <div class="Hidden">
        <asp:Label ID="resDeleteAlert" ClientIDMode="Static" Text="Are you sure you want to delete this KeyConductor?" runat="server" meta:resourcekey="resDeleteAlert" />
        <asp:Label ID="resDeleteDisabled" ClientIDMode="Static" Text="KeyConductor is enabled and cannot be deleted." runat="server" meta:resourcekey="resDeleteDisabled" />
        <asp:HiddenField ID="hdnCanEditKeyConductors" ClientIDMode="Static" runat="server" Value="False" />
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:SqlDataSource ID="dsKeyConductors" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                            SELECT kc.[ID], kc.[KCID], kc.[Name], kc.[Enabled] 
                            FROM [KeyConductor] kc
                            INNER JOIN Bound_Site_User bsu ON bsu.Site_ID = kc.SiteID
                            WHERE (
                                    (@SiteID != 0 AND kc.[SiteID] = @SiteID) OR
                                    (@SiteID = -1 AND kc.[SiteID] IS NOT NULL)
                                   ) AND 
	                               bsu.User_ID = @CurrentUserID
                            ORDER BY kc.[KCID], kc.[Name]"
                FilterExpression="(LEN('{0}') < 1) OR ([Name] LIKE '%{0}%' OR CONVERT([KCID], 'System.String') LIKE '%{0}%')">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlSiteFilter" Name="SiteID" PropertyName="SelectedValue" Type="Int32" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>
                <FilterParameters>
                    <asp:ControlParameter ControlID="txtSearch" Name="Search" PropertyName="Text" />
                </FilterParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsSingleKeyConductor" runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                DeleteCommand="DELETE FROM [KeyConductor] WHERE [ID] = @ID"
                InsertCommand="
                    INSERT INTO [KeyConductor] 
                            ([KCID], [Name], [Enabled], [Description], [Location], [Slots], [LoginMethod], [DateTimeFormat], [KeyCopSorting], [DoorEnabled], 
                             [ShowStandbyScreen], [ReturnOptions], [Hostname], [Hostport], [LoginReader], [InterfaceType], [SiteID]) 
                    VALUES  (@KCID, @Name, @Enabled, @Description, @Location, @Slots, @LoginMethod, @DateTimeFormat, @KeyCopSorting, @DoorEnabled, 
                             @ShowStandbyScreen, @ReturnOptions, @Hostname, @Hostport, @LoginReader, @InterfaceType, @SiteID)
                    SELECT @NewKeyConductorID = SCOPE_IDENTITY()"
                SelectCommand="
                    SELECT [ID], [KCID], [Name], [Enabled], [Description], [Location], [Slots], [LoginMethod], [DateTimeFormat], [KeyCopSorting], [DoorEnabled], 
                           [ShowStandbyScreen], [ReturnOptions], [Hostname], [Hostport], [LoginReader], [InterfaceType], [SiteID] FROM [KeyConductor] WHERE ([ID] = @ID)"
                UpdateCommand="
                    UPDATE [KeyConductor] SET 
                        [KCID] = @KCID, [Name] = @Name, [Enabled] = @Enabled, [Description] = @Description, [Location] = @Location, [Slots] = @Slots, [LoginMethod] = @LoginMethod, 
                        [DateTimeFormat] = @DateTimeFormat, [KeyCopSorting] = @KeyCopSorting, [DoorEnabled] = @DoorEnabled, [ShowStandbyScreen] = @ShowStandbyScreen, 
                        [ReturnOptions] = @ReturnOptions, [Hostname] = @Hostname, [Hostport] = @Hostport, [LoginReader] = @LoginReader, [InterfaceType] = @InterfaceType, [SiteID] = @SiteID 
                    WHERE [ID] = @ID"
                OnInserted="dsSingleKeyConductor_Inserted"
                OnUpdating="dsSingleKeyConductor_Updating"
                OnInserting="dsSingleKeyConductor_Inserting">
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="KCID" Type="String" />
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Location" Type="String" />
                    <asp:Parameter Name="Slots" Type="Byte" />
                    <asp:Parameter Name="LoginMethod" Type="Byte" />
                    <asp:Parameter Name="DateTimeFormat" Type="Byte" />
                    <asp:Parameter Name="KeyCopSorting" Type="Byte" />
                    <asp:Parameter Name="DoorEnabled" Type="Byte" />
                    <asp:Parameter Name="ShowStandbyScreen" Type="Byte" />
                    <asp:Parameter Name="ReturnOptions" Type="Byte" />
                    <asp:Parameter Name="Hostname" Type="String" />
                    <asp:Parameter Name="Hostport" Type="Int32" />
                    <asp:Parameter Name="LoginReader" Type="Byte" />
                    <asp:Parameter Name="InterfaceType" Type="Byte" />
                    <asp:Parameter Name="SiteID" Type="Int32" />
                    <asp:Parameter Name="NewKeyConductorID" Type="Int32" Direction="Output" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdKeyConductors" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="KCID" Type="String" />
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Location" Type="String" />
                    <asp:Parameter Name="Slots" Type="Byte" />
                    <asp:Parameter Name="LoginMethod" Type="Byte" />
                    <asp:Parameter Name="DateTimeFormat" Type="Byte" />
                    <asp:Parameter Name="KeyCopSorting" Type="Byte" />
                    <asp:Parameter Name="DoorEnabled" Type="Byte" />
                    <asp:Parameter Name="ShowStandbyScreen" Type="Byte" />
                    <asp:Parameter Name="ReturnOptions" Type="Byte" />
                    <asp:Parameter Name="Hostname" Type="String" />
                    <asp:Parameter Name="Hostport" Type="Int32" />
                    <asp:Parameter Name="LoginReader" Type="Byte" />
                    <asp:Parameter Name="InterfaceType" Type="Byte" />
                    <asp:Parameter Name="SiteID" Type="Int32" />
                    <asp:Parameter Name="ID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="dsSites" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                    SELECT s.[ID], s.[Name] 
                    FROM [Site] s 
                    INNER JOIN Bound_Site_User bsu ON s.ID = bsu.Site_ID
                    WHERE bsu.User_ID = @CurrentUserID
                    ORDER BY s.[Name]">
                <SelectParameters>
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>

            </asp:SqlDataSource>
            <asp:Panel ID="pnlGrid" runat="server">
                <asp:Panel ID="pnlFilter" runat="server" DefaultButton="btnSearch" CssClass="tblFilter">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 50%;">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="unwatermark" />
                                <ajaxToolkit:TextBoxWatermarkExtender ID="txtSearch_TextBoxWatermarkExtender" runat="server" BehaviorID="txtSearch_TextBoxWatermarkExtender" TargetControlID="txtSearch" WatermarkCssClass="watermark" WatermarkText="Search..." />
                                <asp:Button ID="btnSearch" runat="server" Text="&gt;" OnClick="btnSearch_Click" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlSiteFilter" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    OnSelectedIndexChanged="ddlSiteFilter_SelectedIndexChanged"
                                    AutoPostBack="true">
                                    <asp:ListItem Value="-1" Text="All sites" meta:resourcekey="ListItemResource0" />
                                </asp:DropDownList>
                            </td>
                            <td style="text-align: right;">
                                <asp:DropDownList ID="ddlGridPageSize" runat="server" OnSelectedIndexChanged="ddlGridPageSize_SelectedIndexChanged" AutoPostBack="true" ToolTip="Select the number of records to display" meta:resourcekey="ddlGridPageSize">
                                    <asp:ListItem Value="15" Text="15"></asp:ListItem>
                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:GridView ID="grdKeyConductors" runat="server"
                    AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="dsKeyConductors"
                    PageSize="15"
                    OnSelectedIndexChanged="grdKeyConductors_SelectedIndexChanged"
                    OnRowDataBound="grdKeyConductors_RowDataBound"
                    CssClass="Grid conductors" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                    <Columns>
                        <asp:BoundField DataField="KCID" HeaderText="KCID" SortExpression="KCID" meta:resourcekey="BoundFieldResource0" />
                        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" meta:resourcekey="BoundFieldResource1" />
                        <asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" SortExpression="Enabled" meta:resourcekey="CheckBoxFieldResource0" />

                    </Columns>
                </asp:GridView>
            </asp:Panel>

            <asp:FormView ID="fvwKeyConductor" runat="server"
                DataKeyNames="ID"
                DataSourceID="dsSingleKeyConductor"
                OnItemDeleted="fvwKeyConductor_ItemDeleted"
                OnItemUpdating="fvwKeyConductor_ItemUpdating"
                OnItemUpdated="fvwKeyConductor_ItemUpdated">
                <EditItemTemplate>
                    <asp:SqlDataSource ID="dsKeyCops" runat="server"
                        ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="
                            SELECT ([KeyLabel] + ' - ' + [Description]) AS [Name], [ID] 
                            FROM [KeyChain] 
                            WHERE ([SiteID] = @SiteID)
                            ORDER BY [KeyLabel]">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKCEditSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">KeyConductor ID:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKCEditKCID" runat="server" MaxLength="12" Text='<%# Bind("KCID") %>' />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtKCEditKCIDFilterExt" runat="server" TargetControlID="txtKCEditKCID" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtKCEditKCIDValidator" runat="server" ControlToValidate="txtKCEditKCID" CssClass="error" ErrorMessage="Invalid ID" OnServerValidate="txtKCKCIDValidator_ServerValidate" SetFocusOnError="True" ValidateEmptyText="True" meta:resourcekey="txtKCEditKCIDValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKCEditName" runat="server" MaxLength="100" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Description:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKCEditDescription" runat="server" Text='<%# Bind("Description") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">Site:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlKCEditSite" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlKCEditSite_SelectedIndexChanged"
                                    SelectedValue='<%# Bind("SiteID") %>'>
                                </asp:DropDownList>

                                <asp:Panel ID="pnlSiteEditWarning" runat="server" Visible="false">
                                    <br />
                                    <img src="Content/FamFamFam/error.png" alt="Warning" /><asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">Changing the site will remove all bound KeyCops!</asp:Literal>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Location:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKCEditLocation" runat="server" MaxLength="100" Text='<%# Bind("Location") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkKCEditEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>
                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/key_link.png" />
                                <asp:Literal ID="LiteralResource5_1" runat="server" meta:resourcekey="LiteralResource5">KeyCops</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">Advanced</asp:Literal></a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListEditKC_BndKCKC" runat="server" ScrollBars="Both" Height="368px">
                                <asp:CheckBoxList ID="chkListEditKC_BndKCKC" runat="server" DataSourceID="dsKeyCops" DataTextField="Name" DataValueField="ID" OnDataBound="chkListKC_BndKCKC_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Slots:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCEditSlots" runat="server" Value='<%# Bind("Slots") %>' />
                                        <asp:DropDownList ID="ddlKCEditSlots" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Interface Type:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCEditInterfaceType" runat="server" Value='<%# Bind("InterfaceType") %>' />
                                        <asp:DropDownList ID="ddlKCEditInterfaceType" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Address:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtKCEditHostname" runat="server" Text='<%# Bind("Hostname") %>' />
                                        :
                                            <asp:TextBox ID="txtKCEditHostport" runat="server" Text='<%# Bind("Hostport") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">LoginMethod:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCEditLoginMethod" runat="server" Value='<%# Bind("LoginMethod") %>' />
                                        <asp:DropDownList ID="ddlKCEditLoginMethod" runat="server">
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">LoginReader:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCEditLoginReader" runat="server" Value='<%# Bind("LoginReader") %>' />
                                        <asp:DropDownList ID="ddlKCEditLoginReader" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">DateTimeFormat:</asp:Literal></td>

                                    <td>
                                        <asp:HiddenField ID="hdnKCEditDateTimeFormat" runat="server" Value='<%# Bind("DateTimeFormat") %>' />
                                        <asp:DropDownList ID="ddlKCEditDateTimeFormat" runat="server">
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">KeyCopSorting:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCEditKeyCopSorting" runat="server" Value='<%# Bind("KeyCopSorting") %>' />
                                        <asp:DropDownList ID="ddlKCEditKeyCopSorting" runat="server"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">DoorEnabled:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCEditDoorEnabled" runat="server" Value='<%# Bind("DoorEnabled") %>' />
                                        <asp:CheckBox ID="chkKCEditDoorEnabled" runat="server" Text="Door enabled" meta:resourcekey="chkKCEditDoorEnabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">ShowStandbyScreen:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCEditShowStandbyScreen" runat="server" Value='<%# Bind("ShowStandbyScreen") %>' />
                                        <asp:CheckBox ID="chkKCEditShowStandbyScreen" runat="server" Text="Enable screensaver" meta:resourcekey="chkKCEditShowStandbyScreen" />
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">ReturnOptions:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCEditReturnOptions" runat="server" Value='<%# Bind("ReturnOptions") %>' />
                                        <asp:CheckBox ID="chkKCEditReturnOptions_1" runat="server" Text="Allow partial return (default true)" meta:resourcekey="chkKCEditReturnOptions_1" />
                                        <br />
                                        <asp:CheckBox ID="chkKCEditReturnOptions_2" runat="server" Text="Allow unauthorized return (default false)" meta:resourcekey="chkKCEditReturnOptions_2" />
                                        <br />
                                        <asp:CheckBox ID="chkKCEditReturnOptions_3" runat="server" Text="Allow direct return (default false)" meta:resourcekey="chkKCEditReturnOptions_3" />
                                        <br />
                                        <asp:CheckBox ID="chkKCEditReturnOptions_4" runat="server" Text="Disable Hand-Over (default false)" meta:resourcekey="chkKCEditReturnOptions_4" />

                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:SqlDataSource ID="dsKeyCops" runat="server"
                        ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="
                            SELECT ([KeyLabel] + ' - ' + [Description]) AS [Name], [ID] 
                            FROM [KeyChain] 
                            WHERE ([SiteID] = @SiteID)
                            ORDER BY [KeyLabel]">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKCAddSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">KeyConductor ID:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKCAddKCID" runat="server" MaxLength="12" Text='<%# Bind("KCID") %>' />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtKCAddKCIDFilterExt" runat="server" TargetControlID="txtKCAddKCID" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtKCAddKCIDValidator" runat="server" ControlToValidate="txtKCAddKCID" CssClass="error" ErrorMessage="Invalid ID" OnServerValidate="txtKCKCIDValidator_ServerValidate" SetFocusOnError="True" ValidateEmptyText="True" meta:resourcekey="txtKCAddKCIDValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">Name:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKCAddName" runat="server" MaxLength="100" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">Description:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKCAddDescription" runat="server" Text='<%# Bind("Description") %>' /></td>
                        </tr>
                        <tr>
                            <td>Site:</td>
                            <td>
                                <asp:DropDownList ID="ddlKCAddSite" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    AutoPostBack="true"
                                    OnDataBound="ddlKCAddSite_DataBound"
                                    SelectedValue='<%# Bind("SiteID") %>'>
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource22" runat="server" meta:resourcekey="LiteralResource22">Location:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKCAddLocation" runat="server" MaxLength="100" Text='<%# Bind("Location") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource23" runat="server" meta:resourcekey="LiteralResource23">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkKCAddEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>
                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/key_link.png" />
                                <asp:Literal ID="LiteralResource24" runat="server" meta:resourcekey="LiteralResource24">KeyCops</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource25" runat="server" meta:resourcekey="LiteralResource25">Advanced</asp:Literal></a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListAddKC_BndKCKC" runat="server" ScrollBars="Both" Height="368px">
                                <asp:CheckBoxList ID="chkListAddKC_BndKCKC" runat="server" DataSourceID="dsKeyCops" DataTextField="Name" DataValueField="ID" OnDataBound="chkListKC_BndKCKC_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource26" runat="server" meta:resourcekey="LiteralResource26">Slots:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddSlots" runat="server" Value='12' />
                                        <asp:DropDownList ID="ddlKCAddSlots" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource27" runat="server" meta:resourcekey="LiteralResource27">Interface Type:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddInterfaceType" runat="server" Value='0' />
                                        <asp:DropDownList ID="ddlKCAddInterfaceType" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource28" runat="server" meta:resourcekey="LiteralResource28">Address:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtKCAddHostname" runat="server" Text='<%# Bind("Hostname") %>' />
                                        :
                                            <asp:TextBox ID="txtKCAddHostport" runat="server" Text='2101' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource30" runat="server" meta:resourcekey="LiteralResource30">LoginMethod:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddLoginMethod" runat="server" Value='0' />
                                        <asp:DropDownList ID="ddlKCAddLoginMethod" runat="server">
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource31" runat="server" meta:resourcekey="LiteralResource31">LoginReader:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddLoginReader" runat="server" Value='0' />
                                        <asp:DropDownList ID="ddlKCAddLoginReader" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource32" runat="server" meta:resourcekey="LiteralResource32">DateTimeFormat:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddDateTimeFormat" runat="server" Value='0' />
                                        <asp:DropDownList ID="ddlKCAddDateTimeFormat" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource33" runat="server" meta:resourcekey="LiteralResource33">KeyCopSorting:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddKeyCopSorting" runat="server" Value='0' />
                                        <asp:DropDownList ID="ddlKCAddKeyCopSorting" runat="server">
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource34" runat="server" meta:resourcekey="LiteralResource34">DoorEnabled:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddDoorEnabled" runat="server" Value='1' />
                                        <asp:CheckBox ID="chkKCAddDoorEnabled" runat="server" Text="Door enabled" Checked="true" meta:resourcekey="chkKCAddDoorEnabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource35" runat="server" meta:resourcekey="LiteralResource35">ShowStandbyScreen:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddShowStandbyScreen" runat="server" Value='1' />
                                        <asp:CheckBox ID="chkKCAddShowStandbyScreen" runat="server" Text="Enable screensaver" Checked="true" meta:resourcekey="chkKCAddShowStandbyScreen" />

                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource37" runat="server" meta:resourcekey="LiteralResource37">ReturnOptions:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCAddReturnOptions" runat="server" Value='1' />
                                        <asp:CheckBox ID="chkKCAddReturnOptions_1" runat="server" Text="Allow partial return (default true)" Checked="true" meta:resourcekey="chkKCAddReturnOptions_1" />
                                        <br />
                                        <asp:CheckBox ID="chkKCAddReturnOptions_2" runat="server" Text="Allow unauthorized return (default false)" meta:resourcekey="chkKCAddReturnOptions_2" />
                                        <br />
                                        <asp:CheckBox ID="chkKCAddReturnOptions_3" runat="server" Text="Allow direct return (default false)" meta:resourcekey="chkKCAddReturnOptions_3" />
                                        <br />
                                        <asp:CheckBox ID="chkKCAddReturnOptions_4" runat="server" Text="Disable Hand-Over (default false)" meta:resourcekey="chkKCAddReturnOptions_4" />
                                    </td>
                                </tr>
                            </table>

                        </div>
                    </div>

                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:SqlDataSource ID="dsKeyCops" runat="server"
                        ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="
                            SELECT ([KeyLabel] + ' - ' + [Description]) AS [Name], [ID] 
                            FROM [KeyChain] 
                            WHERE ([SiteID] = @SiteID)
                            ORDER BY [KeyLabel]">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKCViewSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource38" runat="server" meta:resourcekey="LiteralResource38">KeyConductor ID:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblKCViewKCID" runat="server" Text='<%# Bind("KCID") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource39" runat="server" meta:resourcekey="LiteralResource39">Name:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblKCViewName" runat="server" Text='<%# Bind("Name") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource40" runat="server" meta:resourcekey="LiteralResource40">Description:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblKCViewDescription" runat="server" Text='<%# Bind("Description") %>' /></td>
                        </tr>
                        <tr>
                            <td>Site:</td>
                            <td>
                                <asp:DropDownList ID="ddlKCViewSite" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    Enabled="false"
                                    SelectedValue='<%# Bind("SiteID") %>'>
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource41" runat="server" meta:resourcekey="LiteralResource41">Location:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblKCViewLocation" runat="server" Text='<%# Bind("Location") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource42" runat="server" meta:resourcekey="LiteralResource42">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkKCViewEnabled" ClientIDMode="Static" runat="server" Checked='<%# Bind("Enabled") %>' Enabled="false" /></td>
                        </tr>
                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/key_link.png" />
                                <asp:Literal ID="LiteralResource43" runat="server" meta:resourcekey="LiteralResource43">KeyCops</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource44" runat="server" meta:resourcekey="LiteralResource44">Advanced</asp:Literal></a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListViewKC_BndKCKC" runat="server" ScrollBars="Both" Height="368px">
                                <asp:CheckBoxList ID="chkListViewKC_BndKCKC" runat="server" DataSourceID="dsKeyCops" DataTextField="Name" DataValueField="ID" Enabled="false" OnDataBound="chkListKC_BndKCKC_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource45" runat="server" meta:resourcekey="LiteralResource45">Slots:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewSlots" runat="server" Value='<%# Bind("Slots") %>' />
                                        <asp:DropDownList ID="ddlKCViewSlots" runat="server" Enabled="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource46" runat="server" meta:resourcekey="LiteralResource46">Interface Type:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewInterfaceType" runat="server" Value='<%# Bind("InterfaceType") %>' />
                                        <asp:DropDownList ID="ddlKCViewInterfaceType" runat="server" Enabled="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource47" runat="server" meta:resourcekey="LiteralResource47">Address:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="lblKCViewHostname" runat="server" Text='<%# Bind("Hostname") %>' />
                                        <asp:Label ID="lblKCViewHostport" runat="server" Text='<%# Bind("Hostport") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource49" runat="server" meta:resourcekey="LiteralResource49">LoginMethod:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewLoginMethod" runat="server" Value='<%# Bind("LoginMethod") %>' />
                                        <asp:DropDownList ID="ddlKCViewLoginMethod" runat="server" Enabled="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource50" runat="server" meta:resourcekey="LiteralResource50">LoginReader:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewLoginReader" runat="server" Value='<%# Bind("LoginReader") %>' />
                                        <asp:DropDownList ID="ddlKCViewLoginReader" runat="server" Enabled="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource51" runat="server" meta:resourcekey="LiteralResource51">DateTimeFormat:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewDateTimeFormat" runat="server" Value='<%# Bind("DateTimeFormat") %>' />
                                        <asp:DropDownList ID="ddlKCViewDateTimeFormat" runat="server" Enabled="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource52" runat="server" meta:resourcekey="LiteralResource52">KeyCopSorting:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewKeyCopSorting" runat="server" Value='<%# Bind("KeyCopSorting") %>' />
                                        <asp:DropDownList ID="ddlKCViewKeyCopSorting" runat="server" Enabled="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource53" runat="server" meta:resourcekey="LiteralResource53">DoorEnabled:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewDoorEnabled" runat="server" Value='<%# Bind("DoorEnabled") %>' />
                                        <asp:CheckBox ID="chkKCViewDoorEnabled" runat="server" Text="Door enabled" Enabled="false" meta:resourcekey="chkKCViewDoorEnabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource54" runat="server" meta:resourcekey="LiteralResource54">ShowStandbyScreen:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewShowStandbyScreen" runat="server" Value='<%# Bind("ShowStandbyScreen") %>' />
                                        <asp:CheckBox ID="chkKCViewShowStandbyScreen" runat="server" Text="Enable screensaver" Enabled="false" meta:resourcekey="chkKCViewShowStandbyScreen" />
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource56" runat="server" meta:resourcekey="LiteralResource56">ReturnOptions:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKCViewReturnOptions" runat="server" Value='<%# Bind("ReturnOptions") %>' />
                                        <asp:CheckBox ID="chkKCViewReturnOptions_1" runat="server" Text="Allow partial return (default true)" Enabled="false" meta:resourcekey="chkKCViewReturnOptions_1" />
                                        <br />
                                        <asp:CheckBox ID="chkKCViewReturnOptions_2" runat="server" Text="Allow unauthorized return (default false)" Enabled="false" meta:resourcekey="chkKCViewReturnOptions_2" />
                                        <br />
                                        <asp:CheckBox ID="chkKCViewReturnOptions_3" runat="server" Text="Allow direct return (default false)" Enabled="false" meta:resourcekey="chkKCViewReturnOptions_3" />
                                        <br />
                                        <asp:CheckBox ID="chkKCViewReturnOptions_4" runat="server" Text="Disable Hand-Over (default false)" Enabled="false" meta:resourcekey="chkKCViewReturnOptions_4" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:FormView>

            <uc1:EntityControl runat="server" ID="EntityControl"
                OnClicked="EntityControl_Clicked" />

            <asp:Button ID="btnPositionHidden1" ClientIDMode="Static" runat="server" Text="" Style="display: none" OnClick="btnPositionHidden1_Click" />
            <asp:Button ID="btnPositionHidden2" ClientIDMode="Static" runat="server" Text="" Style="display: none" OnClick="btnPositionHidden2_Click" />
            <asp:HiddenField ID="hdnPositionBoundKCKC" Value="0" runat="server" ClientIDMode="Static" />

            <asp:Panel ID="pnlPosition" runat="server" CssClass="modalPopup" Height="500px" Width="450px">
                <strong>
                    <asp:Literal ID="LiteralResource57" runat="server" meta:resourcekey="LiteralResource57">KeyCop position:</asp:Literal></strong>
                <br />

                <table class="tblKCAdv" style="width: 100% !important;">
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource58" runat="server" meta:resourcekey="LiteralResource58">KeyConductor:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblPosKeyConductor" runat="server" Text="Label" meta:resourcekey="lblPosKeyConductor"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource59" runat="server" meta:resourcekey="LiteralResource59">KeyCop:</asp:Literal>
                        </td>
                        <td>
                            <asp:Label ID="lblPosKeyCop" runat="server" Text="Label" meta:resourcekey="lblPosKeyCop"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Literal ID="LiteralResource60" runat="server" meta:resourcekey="LiteralResource60">Position:</asp:Literal>
                        </td>
                        <td>
                            <asp:Panel ID="pnlPositionRadList" runat="server" ScrollBars="Vertical" Height="350px">
                                <asp:RadioButtonList ID="ddlPosition" runat="server">
                                </asp:RadioButtonList>

                            </asp:Panel>

                        </td>
                    </tr>

                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>
                            <asp:Button ID="btnPosOK" runat="server" Text="OK" Height="34px" Width="100px" OnClick="btnPosOK_Click" meta:resourcekey="btnPosOK" />
                            &nbsp;<asp:Button ID="btnPosCancel" runat="server" Text="Cancel" Height="34px" Width="100px" OnClick="btnPosCancel_Click" meta:resourcekey="btnPosCancel" />
                        </td>
                    </tr>

                </table>

            </asp:Panel>

            <ajaxToolkit:ModalPopupExtender ID="pnlPosition_ModalPopupExtender" runat="server" BackgroundCssClass="modalBackground"
                Enabled="True" TargetControlID="btnPositionHidden1" PopupControlID="pnlPosition">
            </ajaxToolkit:ModalPopupExtender>

        </ContentTemplate>
    </asp:UpdatePanel>





</asp:Content>
