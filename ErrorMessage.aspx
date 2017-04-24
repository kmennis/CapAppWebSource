<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ErrorMessage.aspx.cs" Inherits="KCWebManager.ErrorMessage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=10" />

    <link rel="apple-touch-icon" sizes="57x57" href="Resources/favicons/apple-touch-icon-57x57.png" />
    <link rel="apple-touch-icon" sizes="60x60" href="Resources/favicons/apple-touch-icon-60x60.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="Resources/favicons/apple-touch-icon-72x72.png" />
    <link rel="apple-touch-icon" sizes="76x76" href="Resources/favicons/apple-touch-icon-76x76.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="Resources/favicons/apple-touch-icon-114x114.png" />
    <link rel="apple-touch-icon" sizes="120x120" href="Resources/favicons/apple-touch-icon-120x120.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="Resources/favicons/apple-touch-icon-144x144.png" />
    <link rel="apple-touch-icon" sizes="152x152" href="Resources/favicons/apple-touch-icon-152x152.png" />
    <link rel="apple-touch-icon" sizes="180x180" href="Resources/favicons/apple-touch-icon-180x180.png" />
    <link rel="icon" type="image/png" href="Resources/favicons/favicon-32x32.png" sizes="32x32" />
    <link rel="icon" type="image/png" href="Resources/favicons/android-chrome-192x192.png" sizes="192x192" />
    <link rel="icon" type="image/png" href="Resources/favicons/favicon-96x96.png" sizes="96x96" />
    <link rel="icon" type="image/png" href="Resources/favicons/favicon-16x16.png" sizes="16x16" />
    <link rel="manifest" href="Resources/favicons/manifest.json" />
    <link rel="shortcut icon" href="Resources/favicons/favicon.ico" />
    <meta name="msapplication-TileColor" content="#00aba9" />
    <meta name="msapplication-TileImage" content="Resources/favicons/mstile-144x144.png" />
    <meta name="msapplication-config" content="Resources/favicons/browserconfig.xml" />
    <meta name="theme-color" content="#ffffff" />

    <title>CaptureTech - KeyCop Web Manager</title>
    <link type="text/css" rel="stylesheet" href="~/KCWebManager.css" />
    <link type="text/css" rel="stylesheet" media="print" href="~/KCWebManager.print.css" />

    <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/jquery") %>
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>
    <webopt:BundleReference runat="server" Path="~/Content/css" />

    <script type="text/javascript">
        var jq = jQuery.noConflict();
    </script>
    
    <link href="Content/themes/base/all.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="divWrapper" class="divWrapper">
                <div id="divTop" class="divHeader">
                    <!-- header -->

                    <div id="divTopHeader1">
                        <table style="width: 100%;">
                            <tr>
                                <td>
                                    <img id="imgLogo" src="Resources/LogoCaptureTech.png" />
                                </td>
                                <td style="text-align: right;"></td>
                            </tr>
                        </table>

                    </div>
                    <div id="divTopHeader2">
                        KeyCop Web Manager
                    </div>
                </div>

                <div id="divMenu" class="divMenu">
                    <!-- menu on left-side -->

                    <div id="mnuLogin_Panel1">

                        <input type="image" id="mnuLogin_ImageButton1" src="Resources/Login_48.png" onclick='javascript: document.location("Login");' />
                        <a id="mnuLogin_LinkButton1" href="Login">Login</a>

                    </div>
                </div>

                <div id="divContent" class="divContent">

                    <div class="warning">
                        <asp:Label Text="An error has occured while loading the page. Please contact your system administrator for further details." ID="lblErrorMessage" runat="server" />
                    </div>
                    <asp:Panel ID="pnlErrorDetails" runat="server" Visible="false">

                        <asp:LinkButton ID="lnkErrorDetails" runat="server" OnClick="lnkErrorDetails_Click" Text="Show error details" />

                        <asp:Label ID="lblErrorDetails" runat="server" />

                    </asp:Panel>

                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
