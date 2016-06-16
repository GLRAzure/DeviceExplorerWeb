<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="DeviceExplorerWeb._Default" Async="true" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>Device Manager Web</h1>
        <p class="lead">ASP.NET is a free web framework for building great Web sites and Web applications using HTML, CSS, and JavaScript.</p>
        <p><a href="http://www.asp.net" class="btn btn-primary btn-lg">Learn more &raquo;</a></p>
    </div>

    <div class="row">
        <asp:TextBox ID="txtConnectionString" runat="server" Height="63px" Rows="2" TextMode="MultiLine" Width="629px">HostName=jeIoTHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=vt8oDCQgnSMmYZ/1tQEJ/DwRb8k+p8XSB/OSsxO5fAk=</asp:TextBox>&nbsp; <asp:Button ID="cmdUpdate" runat="server" Text="Show Devices" OnClick="cmdUpdate_Click" />
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="New Device"></asp:Label>
&nbsp;
        <asp:TextBox ID="txtNewDeviceName" runat="server"></asp:TextBox>
&nbsp;
        <asp:Button ID="cmdAddDevice" runat="server" OnClick="cmdAddDevice_Click" Text="Add Device" />
        <br />
        <br />
        <asp:Label ID="lblSAS" runat="server" Text="SAS Token: [Generate Token]"></asp:Label>
        <br />
        <br />
        <asp:GridView ID="devicesGridView" runat="server" OnSelectedIndexChanged="devicesGridView_SelectedIndexChanged">
            <Columns>
                <asp:CommandField ButtonType="Button" SelectText="Generate SAS" ShowSelectButton="True" />
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>
