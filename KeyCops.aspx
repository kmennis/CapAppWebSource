<%@ Page Title=""
    Language="C#"
    MasterPageFile="~/KCWebMgr.Master"
    AutoEventWireup="true"
    EnableEventValidation="false"
    CodeBehind="KeyCops.aspx.cs"
    Inherits="KCWebManager.KeyCops" %>

<%@ Register Src="~/Controls/EntityControl.ascx" TagPrefix="uc1" TagName="EntityControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="Scripts/spectrum.js"></script>
    <link rel="stylesheet" href="Scripts/spectrum.css" />

    <script type="text/javascript">

        var selected_tab = "";

        function InitializeRequestHandler(sender, args) {
            // if it is the delete action, ask for confirmation before actual delete happens
            if (args.get_postBackElement().id == 'btnEntityControlDelete') {
                if (confirm(jq("#resDeleteAlert").text()) == false) {
                    args.set_cancel(true);
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
                location.href = "KeyCops";
            }

            InitializeTabs();
            InitializeSpinners();
            InitializeColorPicker();
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


                    },
                    activate: function (event, ui) {
                        // Disable the EntityControl to avoid unclear situations:
                        if (ui.newTab.index() == 3) {
                            jq(".EntityControl").hide();
                        }
                        else {
                            jq(".EntityControl").show();
                        }
                    }
                });
                if (selected_tab != "") {
                    jq("#tabs").tabs("option", "active", selected_tab);
                }

                jq("form").submit(function () {
                    selected_tab = jq("#tabs").tabs("option", "active");
                });
            });
            jq("#tabs").width(780);
            jq("#tabs").height(510);

            // Keys are displayed using an iframe; resize if available
            jq("#tabs > iframe").width(730); // 730
            jq("#tabs > iframe").height(450);
            //jq("#tabs > iframe").css("overflow-y", "scroll");
            //jq("#tabs > iframe").css("overflow-x", "hidden");
        }

        jq(document).ready(function () {
            InitializeTabs();
            InitializeSpinners();
            InitializeColorPicker();
        });

        function InitializeSpinners() {
            try {
                if (jq('#txtKeyCopAddStartTime').length > 0) {
                    // Add - mode
                    jq('#txtKeyCopAddStartTime').spinner({
                        min: 0,
                        max: 23
                    });

                    jq('#txtKeyCopAddEndTime').spinner({
                        min: 0,
                        max: 23
                    });

                }

                if (jq('#txtKeyCopEditStartTime').length > 0) {
                    // Edit - mode
                    jq('#txtKeyCopEditStartTime').spinner({
                        min: 0,
                        max: 23
                    });

                    jq('#txtKeyCopEditEndTime').spinner({
                        min: 0,
                        max: 23
                    });
                }

            } catch (e) {
                alert(e.message);
            }
        }

        function InitializeColorPicker() {
            //txtKeyCopEditColor
            //txtKeyCopAddColor
            //lblKeyCopViewColor - this is more like modify background of the label
            var txtBox = '#txtKeyCopEditColor';
            if (!jq(txtBox).length) txtBox = '#txtKeyCopAddColor';
            if (jq(txtBox).length) {
                jq(txtBox).spectrum({
                    color: jq(txtBox).text(),
                    preferredFormat: "hex",
                    showInput: true,
                    showPalette: true,
                    allowEmpty: true,
                    showPaletteOnly: true,
                    togglePaletteOnly: true,
                    togglePaletteMoreText: '>',
                    togglePaletteLessText: '<',
                    palette: [
                        ["#000", "#444", "#666", "#999", "#ccc", "#eee", "#f3f3f3", "#fff"],
                        ["#f00", "#f90", "#ff0", "#0f0", "#0ff", "#00f", "#90f", "#f0f"],
                        ["#f4cccc", "#fce5cd", "#fff2cc", "#d9ead3", "#d0e0e3", "#cfe2f3", "#d9d2e9", "#ead1dc"],
                        ["#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
                        ["#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6fa8dc", "#8e7cc3", "#c27ba0"],
                        ["#c00", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3d85c6", "#674ea7", "#a64d79"],
                        ["#900", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#0b5394", "#351c75", "#741b47"],
                        ["#600", "#783f04", "#7f6000", "#274e13", "#0c343d", "#073763", "#20124d", "#4c1130"]
                    ]
                });
            }
            else if (jq('#lblKeyCopViewColor').length) {
                jq('#lblKeyCopViewColor').css('background-color', jq('#lblKeyCopViewColor').text());
            }
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_initializeRequest(InitializeRequestHandler)
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
    </script>

    <div class="Hidden">
        <asp:Label ID="resDeleteAlert" ClientIDMode="Static" Text="Are you sure you want to delete this KeyCop?" runat="server" meta:resourcekey="resDeleteAlert" />
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:SqlDataSource
                ID="dsKeyCops"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                SelectCommand="
                    SELECT kc.[KeyNumber], kc.[KeyLabel], kc.[Description], kc.[ID], kc.[Enabled], kc.[Color] 
                    FROM [KeyChain] kc
                    INNER JOIN Bound_Site_User bsu ON bsu.Site_ID = kc.SiteID
                    WHERE (
		                    (@SiteID != 0 AND [SiteID] = @SiteID) OR
		                    (@SiteID = -1 AND [SiteID] IS NOT NULL)
                          ) AND 
	                      bsu.User_ID = @CurrentUserID
                    ORDER BY kc.[KeyLabel], kc.[Description]"
                FilterExpression="(LEN('{0}') < 1) OR ([KeyNumber] LIKE '{0}%' OR  [KeyLabel] LIKE '%{0}%' OR [Description] LIKE '%{0}%')">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlSiteFilter" Name="SiteID" PropertyName="SelectedValue" Type="Int32" />
                    <asp:SessionParameter Name="CurrentUserID" DefaultValue="0" SessionField="CurrentUserID" Type="Int32" />
                </SelectParameters>
                <FilterParameters>
                    <asp:ControlParameter ControlID="txtSearch" Name="Search" PropertyName="Text" />
                </FilterParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource
                ID="dsSingleKeyCop"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                DeleteCommand="DELETE FROM [KeyChain] WHERE [ID] = @ID"
                InsertCommand="INSERT INTO [KeyChain] ([KeyNumber], [KeyLabel], [Description], [Flag], [StartTime], [EndTime], [Changelog], [Enabled], [KeyLabelAction], [MaxLendingTime], [BaseKeyConductor_ID], [LongLabel], [LongDescription], [Color], [SiteID]) 
                               VALUES                 (@KeyNumber,  @KeyLabel,  @Description,  @Flag,  @StartTime,  @EndTime,  @Changelog,  @Enabled,  @KeyLabelAction,  @MaxLendingTime,  @BaseKeyConductor_ID,  @LongLabel,  @LongDescription, @Color, @SiteID )
                               SELECT @NewKeyCopID = SCOPE_IDENTITY()"
                SelectCommand="SELECT [ID], [KeyNumber], [KeyLabel], [Description], [Flag], [StartTime], [EndTime], [Changelog], [Enabled], [KeyLabelAction], [MaxLendingTime], [BaseKeyConductor_ID], [LongLabel], [LongDescription], [Color], [SiteID] FROM [KeyChain] WHERE ([ID] = @ID)"
                UpdateCommand="UPDATE [KeyChain] SET 
                    [KeyNumber] = @KeyNumber, [KeyLabel] = @KeyLabel, [Description] = @Description, [Flag] = @Flag, 
                    [StartTime] = @StartTime, [EndTime] = @EndTime, [Changelog] = @Changelog, [Enabled] = @Enabled, 
                    [KeyLabelAction] = @KeyLabelAction, [MaxLendingTime] = @MaxLendingTime, [BaseKeyConductor_ID] = @BaseKeyConductor_ID, 
                    [LongLabel] = @LongLabel, [LongDescription] = @LongDescription, [Color] = @Color, [SiteID] = @SiteID
                WHERE [ID] = @ID"
                OnInserted="dsSingleKeyCop_Inserted"
                OnUpdating="dsSingleKeyCop_InsertingUpdating"
                OnInserting="dsSingleKeyCop_InsertingUpdating">
                <DeleteParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="KeyNumber" Type="String" />
                    <asp:Parameter Name="KeyLabel" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Flag" Type="Byte" />
                    <asp:Parameter Name="StartTime" Type="Byte" />
                    <asp:Parameter Name="EndTime" Type="Byte" />
                    <asp:Parameter Name="Changelog" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="KeyLabelAction" Type="Byte" />
                    <asp:Parameter Name="MaxLendingTime" Type="Byte" />
                    <asp:Parameter Name="BaseKeyConductor_ID" Type="Int32" />
                    <asp:Parameter Name="LongLabel" Type="String" />
                    <asp:Parameter Name="LongDescription" Type="String" />
                    <asp:Parameter Name="Color" Type="String" />
                    <asp:Parameter Name="SiteID" Type="Int32" />
                    <asp:Parameter Name="NewKeyCopID" Type="Int32" Direction="Output" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdKeyCops" Name="ID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="KeyNumber" Type="String" />
                    <asp:Parameter Name="KeyLabel" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Flag" Type="Byte" />
                    <asp:Parameter Name="StartTime" Type="Byte" />
                    <asp:Parameter Name="EndTime" Type="Byte" />
                    <asp:Parameter Name="Changelog" Type="String" />
                    <asp:Parameter Name="Enabled" Type="Boolean" />
                    <asp:Parameter Name="KeyLabelAction" Type="Byte" />
                    <asp:Parameter Name="MaxLendingTime" Type="Byte" />
                    <asp:Parameter Name="BaseKeyConductor_ID" Type="Int32" />
                    <asp:Parameter Name="LongLabel" Type="String" />
                    <asp:Parameter Name="LongDescription" Type="String" />
                    <asp:Parameter Name="Color" Type="String" />
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
                <asp:Panel ID="pnlFilter" runat="server" DefaultButton="btnSearch">
                    <table style="width: 100%;" class="tblFilter">
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

                <asp:GridView ID="grdKeyCops" runat="server"
                    AllowPaging="True" AllowSorting="True"
                    AutoGenerateColumns="False" DataSourceID="dsKeyCops"
                    PageSize="15" DataKeyNames="ID" OnSelectedIndexChanged="grdKeyCops_SelectedIndexChanged"
                    OnRowDataBound="grdKeyCops_RowDataBound"
                    CssClass="Grid" AlternatingRowStyle-CssClass="GridAlt" PagerStyle-CssClass="GridPgr" HeaderStyle-CssClass="GridHdr">
                    <Columns>
                        <asp:BoundField DataField="KeyLabel" HeaderText="KeyLabel" InsertVisible="false" ReadOnly="true" SortExpression="KeyLabel" meta:resourcekey="BoundFieldResource0" />
                        <asp:BoundField DataField="Description" HeaderText="Description" InsertVisible="false" ReadOnly="true" SortExpression="Description" meta:resourcekey="BoundFieldResource1" />
                        <asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" SortExpression="Enabled" meta:resourcekey="CheckBoxFieldResource0" />
                        <asp:BoundField DataField="Color" HeaderText="Color" SortExpression="Color"
                            HeaderStyle-CssClass="Hidden"
                            ControlStyle-CssClass="Hidden"
                            ItemStyle-CssClass="Hidden"
                            FooterStyle-CssClass="Hidden"></asp:BoundField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Literal ID="LiteralResource0" runat="server" meta:resourcekey="LiteralResource0">No KeyCops present</asp:Literal>
                    </EmptyDataTemplate>
                </asp:GridView>
            </asp:Panel>

            <asp:FormView ID="fvwKeyCop" runat="server"
                DataKeyNames="ID"
                DataSourceID="dsSingleKeyCop"
                Width="624px"
                OnItemDeleted="fvwKeyCop_ItemDeleted"
                OnItemUpdating="fvwKeyCop_ItemUpdating"
                OnItemUpdated="fvwKeyCop_ItemUpdated"
                OnDataBound="fvwKeyCop_DataBound">
                <EditItemTemplate>
                    <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="SELECT [ID], [Name] FROM [Group] WHERE ([SiteID] = @SiteID)">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKeyCopEditSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="dsKeyConductors" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="SELECT [ID], [Name] FROM [KeyConductor] WHERE ([SiteID] = @SiteID)">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKeyCopEditSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource1" runat="server" meta:resourcekey="LiteralResource1">Barcode:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKeyCopEditKeyNumber" MaxLength="12" runat="server" Text='<%# Bind("KeyNumber") %>' />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtKeyCopEditKeyNumberFilterExt" runat="server" TargetControlID="txtKeyCopEditKeyNumber" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtKeyCopEditKeyNumberValidator" runat="server" ErrorMessage="Invalid barcode" ControlToValidate="txtKeyCopEditKeyNumber" CssClass="error" OnServerValidate="txtKeyCopKeyNumberValidator_ServerValidate" SetFocusOnError="True" ValidateEmptyText="True" meta:resourcekey="txtKeyCopEditKeyNumberValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource2" runat="server" meta:resourcekey="LiteralResource2">Label:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKeyCopEditKeyLabel" MaxLength="3" runat="server" Text='<%# Bind("KeyLabel") %>' />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtKeyCopEditKeyLabelFilterExt" runat="server" TargetControlID="txtKeyCopEditKeyLabel" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtKeyCopEditKeyLabelValidator" runat="server" ControlToValidate="txtKeyCopEditKeyLabel" CssClass="error" ErrorMessage="Invalid label" OnServerValidate="txtKeyCopKeyLabelValidator_ServerValidate" SetFocusOnError="True" ValidateEmptyText="True" meta:resourcekey="txtKeyCopEditKeyLabelValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource3" runat="server" meta:resourcekey="LiteralResource3">Description:</asp:Literal>
                            </td>
                            <td>
                                <asp:TextBox ID="txtKeyCopEditDescription" MaxLength="16" runat="server" Text='<%# Bind("Description") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource46" runat="server" meta:resourcekey="LiteralResource46">Site:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlKeyCopEditSite" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlKeyCopEditSite_SelectedIndexChanged"
                                    SelectedValue='<%# Bind("SiteID") %>'>
                                </asp:DropDownList>
                                <asp:Panel ID="pnlSiteEditWarning" runat="server" Visible="false">
                                    <br />
                                    <img src="Content/FamFamFam/error.png" alt="Warning" /><asp:Literal ID="LiteralResource47" runat="server" meta:resourcekey="LiteralResource47">Changing the site will remove all bound groups and KeyConductors!</asp:Literal>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource4" runat="server" meta:resourcekey="LiteralResource4">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkKeyCopEditEnabled" runat="server" Checked='<%# Bind("Enabled") %>' />
                            </td>
                        </tr>
                    </table>


                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/group_link.png" />
                                <asp:Literal ID="LiteralResource5" runat="server" meta:resourcekey="LiteralResource5">Groups</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/server_link.png" />
                                <asp:Literal ID="LiteralResource6" runat="server" meta:resourcekey="LiteralResource6">KeyConductors</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource7" runat="server" meta:resourcekey="LiteralResource7">Advanced</asp:Literal></a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListEditGroup_BndUG" runat="server" ScrollBars="Both" Height="450px">
                                <asp:CheckBoxList ID="chkListEditKC_BndGK" runat="server" DataSourceID="dsGroups" DataTextField="Name" DataValueField="ID" OnDataBound="chkListKC_BndGK_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-2">
                            <asp:Panel ID="pnlListEditKC_BndKCKC" runat="server" ScrollBars="Both" Height="450px">
                                <asp:CheckBoxList ID="chkListEditKC_BndKCKC" runat="server" DataSourceID="dsKeyConductors" DataTextField="Name" DataValueField="ID" OnDataBound="chkListKC_BndKCKC_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource8" runat="server" meta:resourcekey="LiteralResource8">Active days:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopEditFlag" runat="server" Value='<%# Bind("Flag") %>' />
                                        <asp:CheckBox ID="chkKeyCopEditFlagSunday" runat="server" Text="Sunday" meta:resourcekey="chkKeyCopEditFlagSunday" /><br />
                                        <asp:CheckBox ID="chkKeyCopEditFlagMonday" runat="server" Text="Monday" meta:resourcekey="chkKeyCopEditFlagMonday" /><br />
                                        <asp:CheckBox ID="chkKeyCopEditFlagTuesday" runat="server" Text="Tuesday" meta:resourcekey="chkKeyCopEditFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkKeyCopEditFlagWednesday" runat="server" Text="Wednesday" meta:resourcekey="chkKeyCopEditFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkKeyCopEditFlagThursday" runat="server" Text="Thursday" meta:resourcekey="chkKeyCopEditFlagThursday" /><br />
                                        <asp:CheckBox ID="chkKeyCopEditFlagFriday" runat="server" Text="Friday" meta:resourcekey="chkKeyCopEditFlagFriday" /><br />
                                        <asp:CheckBox ID="chkKeyCopEditFlagSaturday" runat="server" Text="Saturday" meta:resourcekey="chkKeyCopEditFlagSaturday" /><br />

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource9" runat="server" meta:resourcekey="LiteralResource9">Active time</asp:Literal></td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource10" runat="server" meta:resourcekey="LiteralResource10">StartTime:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="txtKeyCopEditStartTime" ClientIDMode="Static" runat="server" Text='<%# Bind("StartTime") %>' />
                                                    <ajaxToolkit:FilteredTextBoxExtender ID="txtKeyCopEditStartTimeFilterExt" runat="server" TargetControlID="txtKeyCopEditStartTime" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource11" runat="server" meta:resourcekey="LiteralResource11">EndTime:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="txtKeyCopEditEndTime" ClientIDMode="Static" runat="server" Text='<%# Bind("EndTime") %>' />
                                                    <ajaxToolkit:FilteredTextBoxExtender ID="txtKeyCopEditEndTimeFilterExt" runat="server" TargetControlID="txtKeyCopEditEndTime" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                        </table>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource12" runat="server" meta:resourcekey="LiteralResource12">Max lending time</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopEditMaxLendingTime" runat="server" Value='<%# Bind("MaxLendingTime") %>' />
                                        <asp:DropDownList ID="ddlKeyCopEditMaxLendingTime" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource13" runat="server" meta:resourcekey="LiteralResource13">Identical labels:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopEditKeyLabelAction" runat="server" Value='<%# Bind("KeyLabelAction") %>' />
                                        <asp:RadioButton ID="optKeyCopEdit_KeyLabelAction_0" runat="server" Text="No action" GroupName="optKeyCopEdit_KeyLabelAction" meta:resourcekey="optKeyCopEdit_KeyLabelAction_0" />
                                        <br />
                                        <asp:RadioButton ID="optKeyCopEdit_KeyLabelAction_1" runat="server" Text="Bind" GroupName="optKeyCopEdit_KeyLabelAction" meta:resourcekey="optKeyCopEdit_KeyLabelAction_1" />
                                        <br />
                                        <asp:RadioButton ID="optKeyCopEdit_KeyLabelAction_2" runat="server" Text="Exclusive pick" GroupName="optKeyCopEdit_KeyLabelAction" meta:resourcekey="optKeyCopEdit_KeyLabelAction_2" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource14" runat="server" meta:resourcekey="LiteralResource14">Base KeyConductor:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopEdit_BaseKeyConductor" runat="server" Value='<%# Bind("BaseKeyConductor_ID") %>' />
                                        <asp:DropDownList runat="server" ID="ddlKeyCopEdit_BaseKeyConductor" DataSourceID="dsKeyConductors" DataTextField="Name" DataValueField="ID" AppendDataBoundItems="true">
                                            <asp:ListItem Value="" Text="None" meta:resourcekey="ListItemResource25" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource15" runat="server" meta:resourcekey="LiteralResource15">Changelog:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtKeyCopEditChangelog" runat="server" Text='<%# Bind("Changelog") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource48" runat="server" meta:resourcekey="LiteralResource48">Long label:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtKeyCopEditLongLabel" MaxLength="16" runat="server" Text='<%# Bind("LongLabel") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource49" runat="server" meta:resourcekey="LiteralResource49">Long description:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtKeyCopEditLongDescription" MaxLength="250" runat="server" Text='<%# Bind("LongDescription") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource50" runat="server" meta:resourcekey="LiteralResource50">Color:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtKeyCopEditColor" ClientIDMode="Static" MaxLength="20" runat="server" Text='<%# Bind("Color") %>' />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="SELECT [ID], [Name] FROM [Group] WHERE ([SiteID] = @SiteID)">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKeyCopAddSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="dsKeyConductors" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="SELECT [ID], [Name] FROM [KeyConductor] WHERE ([SiteID] = @SiteID)">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKeyCopAddSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource16" runat="server" meta:resourcekey="LiteralResource16">Barcode:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKeyCopAddKeyNumber" MaxLength="12" runat="server" Text='<%# Bind("KeyNumber") %>' />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtKeyCopAddKeyNumberFilterExt" runat="server" TargetControlID="txtKeyCopAddKeyNumber" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtKeyCopAddKeyNumberValidator" runat="server" ControlToValidate="txtKeyCopAddKeyNumber" CssClass="error" ErrorMessage="Invalid barcode" OnServerValidate="txtKeyCopKeyNumberValidator_ServerValidate" SetFocusOnError="True" ValidateEmptyText="True" meta:resourcekey="txtKeyCopAddKeyNumberValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource17" runat="server" meta:resourcekey="LiteralResource17">Label:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKeyCopAddKeyLabel" runat="server" MaxLength="3" Text='<%# Bind("KeyLabel") %>' />
                                <ajaxToolkit:FilteredTextBoxExtender ID="txtKeyCopAddKeyLabelFilterExt" runat="server" TargetControlID="txtKeyCopAddKeyLabel" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                <asp:CustomValidator ID="txtKeyCopAddKeyLabelValidator" runat="server" ControlToValidate="txtKeyCopAddKeyLabel" CssClass="error" ErrorMessage="Invalid label" OnServerValidate="txtKeyCopKeyLabelValidator_ServerValidate" SetFocusOnError="True" ValidateEmptyText="True" meta:resourcekey="txtKeyCopAddKeyLabelValidator"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource18" runat="server" meta:resourcekey="LiteralResource18">Description:</asp:Literal></td>
                            <td>
                                <asp:TextBox ID="txtKeyCopAddDescription" MaxLength="16" runat="server" Text='<%# Bind("Description") %>' />
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td>Site:</td>
                            <td>
                                <asp:DropDownList ID="ddlKeyCopAddSite" runat="server"
                                    DataMember="DefaultView"
                                    DataSourceID="dsSites"
                                    DataValueField="ID"
                                    AppendDataBoundItems="True"
                                    DataTextField="Name"
                                    AutoPostBack="true"
                                    OnDataBound="ddlKeyCopAddSite_DataBound"
                                    SelectedValue='<%# Bind("SiteID") %>'>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource19" runat="server" meta:resourcekey="LiteralResource19">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkKeyCopAddEnabled" runat="server" Checked='<%# Bind("Enabled") %>' /></td>
                        </tr>
                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/group_link.png" />
                                <asp:Literal ID="LiteralResource20" runat="server" meta:resourcekey="LiteralResource20">Groups</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/server_link.png" />
                                <asp:Literal ID="LiteralResource21" runat="server" meta:resourcekey="LiteralResource21">KeyConductors</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource22" runat="server" meta:resourcekey="LiteralResource22">Advanced</asp:Literal></a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListAddGroup_BndUG" runat="server" ScrollBars="Both" Height="450px">

                                <asp:CheckBoxList ID="chkListAddKC_BndGK" runat="server" DataSourceID="dsGroups" DataTextField="Name" DataValueField="ID">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-2">
                            <asp:Panel ID="pnlListAddKC_BndKCKC" runat="server" ScrollBars="Both" Height="450px">
                                <asp:CheckBoxList ID="chkListAddKC_BndKCKC" runat="server" DataSourceID="dsKeyConductors" DataTextField="Name" DataValueField="ID">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource23" runat="server" meta:resourcekey="LiteralResource23">Active days:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopAddFlag" runat="server" Value='<%# Bind("Flag") %>' />
                                        <asp:CheckBox ID="chkKeyCopAddFlagSunday" runat="server" Text="Sunday" Checked="true" meta:resourcekey="chkKeyCopAddFlagSunday" /><br />
                                        <asp:CheckBox ID="chkKeyCopAddFlagMonday" runat="server" Text="Monday" Checked="true" meta:resourcekey="chkKeyCopAddFlagMonday" /><br />
                                        <asp:CheckBox ID="chkKeyCopAddFlagTuesday" runat="server" Text="Tuesday" Checked="true" meta:resourcekey="chkKeyCopAddFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkKeyCopAddFlagWednesday" runat="server" Text="Wednesday" Checked="true" meta:resourcekey="chkKeyCopAddFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkKeyCopAddFlagThursday" runat="server" Text="Thursday" Checked="true" meta:resourcekey="chkKeyCopAddFlagThursday" /><br />
                                        <asp:CheckBox ID="chkKeyCopAddFlagFriday" runat="server" Text="Friday" Checked="true" meta:resourcekey="chkKeyCopAddFlagFriday" /><br />
                                        <asp:CheckBox ID="chkKeyCopAddFlagSaturday" runat="server" Text="Saturday" Checked="true" meta:resourcekey="chkKeyCopAddFlagSaturday" /><br />

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource24" runat="server" meta:resourcekey="LiteralResource24">Active time</asp:Literal></td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource25" runat="server" meta:resourcekey="LiteralResource25">StartTime:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="txtKeyCopAddStartTime" ClientIDMode="Static" runat="server" Text='<%# Bind("StartTime") %>' />
                                                    <ajaxToolkit:FilteredTextBoxExtender ID="txtKeyCopAddStartTimeFilterExt" runat="server" TargetControlID="txtKeyCopAddStartTime" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource26" runat="server" meta:resourcekey="LiteralResource26">EndTime:</asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="txtKeyCopAddEndTime" ClientIDMode="Static" runat="server" Text='<%# Bind("EndTime") %>' />
                                                    <ajaxToolkit:FilteredTextBoxExtender ID="txtKeyCopAddEndTimeFilterExt" runat="server" TargetControlID="txtKeyCopAddEndTime" FilterType="Numbers"></ajaxToolkit:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource27" runat="server" meta:resourcekey="LiteralResource27">Max lending time</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopAddMaxLendingTime" runat="server" Value='<%# Bind("MaxLendingTime") %>' />
                                        <asp:DropDownList ID="ddlKeyCopAddMaxLendingTime" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource28" runat="server" meta:resourcekey="LiteralResource28">Identical labels</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopAddKeyLabelAction" runat="server" Value='<%# Bind("KeyLabelAction") %>' />
                                        <asp:RadioButton ID="optKeyCopAdd_KeyLabelAction_0" runat="server" Text="No action" GroupName="optKeyCopAdd_KeyLabelAction" Checked="true" meta:resourcekey="optKeyCopAdd_KeyLabelAction_0" />
                                        <br />
                                        <asp:RadioButton ID="optKeyCopAdd_KeyLabelAction_1" runat="server" Text="Bind" GroupName="optKeyCopAdd_KeyLabelAction" meta:resourcekey="optKeyCopAdd_KeyLabelAction_1" />
                                        <br />
                                        <asp:RadioButton ID="optKeyCopAdd_KeyLabelAction_2" runat="server" Text="Exclusive pick" GroupName="optKeyCopAdd_KeyLabelAction" meta:resourcekey="optKeyCopAdd_KeyLabelAction_2" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource29" runat="server" meta:resourcekey="LiteralResource29">Base KeyConductor:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopAdd_BaseKeyConductor" runat="server" Value='<%# Bind("BaseKeyConductor_ID") %>' />
                                        <asp:DropDownList runat="server" ID="ddlKeyCopAdd_BaseKeyConductor" DataSourceID="dsKeyConductors" DataTextField="Name" DataValueField="ID" AppendDataBoundItems="true">
                                            <asp:ListItem Value="" Text="None" Selected="True" meta:resourcekey="ListItemResource51" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource30" runat="server" meta:resourcekey="LiteralResource30">Changelog:</asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtKeyCopAddChangelog" runat="server" Text='<%# Bind("Changelog") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource52" runat="server" meta:resourcekey="LiteralResource52">Long label:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtKeyCopAddLongLabel" MaxLength="16" runat="server" Text='<%# Bind("LongLabel") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource53" runat="server" meta:resourcekey="LiteralResource53">Long description:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtKeyCopAddLongDescription" MaxLength="250" runat="server" Text='<%# Bind("LongDescription") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource54" runat="server" meta:resourcekey="LiteralResource54">Color:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtKeyCopAddColor" ClientIDMode="Static" MaxLength="20" runat="server" Text='<%# Bind("Color") %>' />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="SELECT [ID], [Name] FROM [Group] WHERE ([SiteID] = @SiteID)">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKeyCopViewSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="dsKeyConductors" runat="server" ConnectionString="<%$ ConnectionStrings:KCDataConnectionString %>"
                        SelectCommand="SELECT [ID], [Name] FROM [KeyConductor] WHERE ([SiteID] = @SiteID)">
                        <SelectParameters>
                            <asp:ControlParameter Name="SiteID" ControlID="ddlKeyCopViewSite" Type="Int32" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <table class="tblKCAdv">
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource31" runat="server" meta:resourcekey="LiteralResource31">Barcode:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblKeyCopViewKeyNumber" runat="server" Text='<%# Bind("KeyNumber") %>' /></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource32" runat="server" meta:resourcekey="LiteralResource32">Label:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblKeyCopViewKeyLabel" runat="server" Text='<%# Bind("KeyLabel") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource33" runat="server" meta:resourcekey="LiteralResource33">Description:</asp:Literal></td>
                            <td>
                                <asp:Label ID="lblKeyCopViewDescription" runat="server" Text='<%# Bind("Description") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="LiteralResource55" runat="server" meta:resourcekey="LiteralResource55">Site:</asp:Literal></td>
                            <td>
                                <asp:DropDownList ID="ddlKeyCopViewSite" runat="server"
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
                                <asp:Literal ID="LiteralResource34" runat="server" meta:resourcekey="LiteralResource34">Enabled:</asp:Literal></td>
                            <td>
                                <asp:CheckBox ID="chkKeyCopViewEnabled" runat="server" Checked='<%# Bind("Enabled") %>' Enabled="false" /></td>
                        </tr>
                    </table>

                    <div id="tabs">
                        <ul>
                            <li><a href="#tabs-1">
                                <img src="Content/FamFamFam/group_link.png" />
                                <asp:Literal ID="LiteralResource35" runat="server" meta:resourcekey="LiteralResource35">Groups</asp:Literal></a></li>
                            <li><a href="#tabs-2">
                                <img src="Content/FamFamFam/server_link.png" />
                                <asp:Literal ID="LiteralResource36" runat="server" meta:resourcekey="LiteralResource36">KeyConductors</asp:Literal></a></li>
                            <li><a href="#tabs-3">
                                <img src="Content/FamFamFam/cog.png" />
                                <asp:Literal ID="LiteralResource37" runat="server" meta:resourcekey="LiteralResource37">Advanced</asp:Literal></a></li>
                            <li><a href="#tabs-4">
                                <img src="Content/FamFamFam/key.png" />
                                Keys</a></li>
                        </ul>
                        <div id="tabs-1">
                            <asp:Panel ID="pnlListViewGroup_BndUG" runat="server" ScrollBars="Both" Height="450px">
                                <asp:CheckBoxList ID="chkListViewKC_BndGK" runat="server" Enabled="false" DataSourceID="dsGroups" DataTextField="Name" DataValueField="ID" OnDataBound="chkListKC_BndGK_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-2">
                            <asp:Panel ID="pnlListViewKC_BndKCKC" runat="server" ScrollBars="Both" Height="450px">
                                <asp:CheckBoxList ID="chkListViewKC_BndKCKC" runat="server" Enabled="false" DataSourceID="dsKeyConductors" DataTextField="Name" DataValueField="ID" OnDataBound="chkListKC_BndKCKC_DataBound">
                                </asp:CheckBoxList>
                            </asp:Panel>
                        </div>
                        <div id="tabs-3">
                            <table class="tblKCAdv">
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource38" runat="server" meta:resourcekey="LiteralResource38">Active days:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopViewFlag" runat="server" Value='<%# Bind("Flag") %>' />
                                        <asp:CheckBox ID="chkKeyCopViewFlagSunday" runat="server" Text="Sunday" Enabled="false" meta:resourcekey="chkKeyCopViewFlagSunday" /><br />
                                        <asp:CheckBox ID="chkKeyCopViewFlagMonday" runat="server" Text="Monday" Enabled="false" meta:resourcekey="chkKeyCopViewFlagMonday" /><br />
                                        <asp:CheckBox ID="chkKeyCopViewFlagTuesday" runat="server" Text="Tuesday" Enabled="false" meta:resourcekey="chkKeyCopViewFlagTuesday" /><br />
                                        <asp:CheckBox ID="chkKeyCopViewFlagWednesday" runat="server" Text="Wednesday" Enabled="false" meta:resourcekey="chkKeyCopViewFlagWednesday" /><br />
                                        <asp:CheckBox ID="chkKeyCopViewFlagThursday" runat="server" Text="Thursday" Enabled="false" meta:resourcekey="chkKeyCopViewFlagThursday" /><br />
                                        <asp:CheckBox ID="chkKeyCopViewFlagFriday" runat="server" Text="Friday" Enabled="false" meta:resourcekey="chkKeyCopViewFlagFriday" /><br />
                                        <asp:CheckBox ID="chkKeyCopViewFlagSaturday" runat="server" Text="Saturday" Enabled="false" meta:resourcekey="chkKeyCopViewFlagSaturday" /><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource39" runat="server" meta:resourcekey="LiteralResource39">Active time:</asp:Literal></td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource40" runat="server" meta:resourcekey="LiteralResource40">StartTime:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="lblKeyCopViewStartTime" runat="server" Text='<%# Bind("StartTime") %>' /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Literal ID="LiteralResource41" runat="server" meta:resourcekey="LiteralResource41">EndTime:</asp:Literal></td>
                                                <td>
                                                    <asp:Label ID="lblKeyCopViewEndTime" runat="server" Text='<%# Bind("EndTime") %>' /></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource42" runat="server" meta:resourcekey="LiteralResource42">Max lending time</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopViewMaxLendingTime" runat="server" Value='<%# Bind("MaxLendingTime") %>' />
                                        <asp:DropDownList ID="ddlKeyCopViewMaxLendingTime" runat="server" Enabled="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource43" runat="server" meta:resourcekey="LiteralResource43">Identical labels</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopViewKeyLabelAction" runat="server" Value='<%# Bind("KeyLabelAction") %>' />
                                        <asp:RadioButton ID="optKeyCopView_KeyLabelAction_0" runat="server" Text="No action" GroupName="optKeyCopView_KeyLabelAction" Enabled="false" meta:resourcekey="optKeyCopView_KeyLabelAction_0" />
                                        <br />
                                        <asp:RadioButton ID="optKeyCopView_KeyLabelAction_1" runat="server" Text="Bind" GroupName="optKeyCopView_KeyLabelAction" Enabled="false" meta:resourcekey="optKeyCopView_KeyLabelAction_1" />
                                        <br />
                                        <asp:RadioButton ID="optKeyCopView_KeyLabelAction_2" runat="server" Text="Exclusive pick" GroupName="optKeyCopView_KeyLabelAction" Enabled="false" meta:resourcekey="optKeyCopView_KeyLabelAction_2" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource44" runat="server" meta:resourcekey="LiteralResource44">Base KeyConductor:</asp:Literal></td>
                                    <td>
                                        <asp:HiddenField ID="hdnKeyCopView_BaseKeyConductor" runat="server" Value='<%# Bind("BaseKeyConductor_ID") %>' />
                                        <asp:DropDownList runat="server" ID="ddlKeyCopView_BaseKeyConductor" DataSourceID="dsKeyConductors" DataTextField="Name" DataValueField="ID" Enabled="false" AppendDataBoundItems="true">
                                            <asp:ListItem Value="" Text="None" meta:resourcekey="ListItemResource77" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource45" runat="server" meta:resourcekey="LiteralResource45">Changelog:</asp:Literal></td>
                                    <td>
                                        <asp:Label ID="lblKeyCopViewChangelog" runat="server" Text='<%# Bind("Changelog") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource56" runat="server" meta:resourcekey="LiteralResource56">Long label:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblKeyCopViewLongLabel" runat="server" Text='<%# Bind("LongLabel") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource57" runat="server" meta:resourcekey="LiteralResource57">Long description:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblKeyCopViewLongDescription" runat="server" Text='<%# Bind("LongDescription") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="LiteralResource58" runat="server" meta:resourcekey="LiteralResource58">Color:</asp:Literal>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblKeyCopViewColor" ClientIDMode="Static" runat="server" Text='<%# Bind("Color") %>' />
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <asp:Literal ID="litTabFrame_Keys" runat="server"></asp:Literal>
                    </div>

                </ItemTemplate>
            </asp:FormView>
            <br />
            <asp:Label ID="lblMessage" runat="server" Visible="False" Text="lblMessage" CssClass="error"></asp:Label>
            <br />

            <uc1:EntityControl runat="server" ID="EntityControl"
                OnClicked="EntityControl_Clicked" />

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
