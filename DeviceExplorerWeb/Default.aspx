<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="DeviceExplorerWeb._Default" Async="true" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>DeviceExplorer Web Edition</h1>
    </div>

    <div class="row">
        <br />
        <asp:Label ID="Label2" runat="server" Text="IoT Hub Connection String"></asp:Label>
        <br />
        <asp:TextBox ID="txtConnectionString" runat="server" Height="87px" Rows="5" TextMode="MultiLine" Width="793px">HostName=jeIoTHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=vt8oDCQgnSMmYZ/1tQEJ/DwRb8k+p8XSB/OSsxO5fAk=</asp:TextBox>&nbsp; <asp:Button ID="cmdUpdate" runat="server" Text="Connect to IoT Hub" OnClick="cmdUpdate_Click" />
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="New Device"></asp:Label>
&nbsp;
        <asp:TextBox ID="txtNewDeviceName" runat="server"></asp:TextBox>
&nbsp;
        <asp:Button ID="cmdAddDevice" runat="server" Enabled="False" OnClick="cmdAddDevice_Click" Text="Add Device" />
        <br />
        <br />
        <asp:UpdatePanel ID="UpdatePanel2" UpdateMode="Conditional" runat="server">
            <ContentTemplate>
                <asp:Label ID="Label3" runat="server" Text="Send Message to"></asp:Label>
                   &nbsp;
                <asp:DropDownList ID="cboDevices" runat="server" />
                   &nbsp; containing&nbsp;
                <asp:TextBox ID="txtMessage" runat="server" Width="218px"></asp:TextBox>
                   &nbsp;
                <asp:Button ID="cmdSend" runat="server" Enabled="False" OnClick="cmdSend_Click" Text="Send" />
                   &nbsp;
                  <br />
                <asp:Label ID="lblMessageStatus" runat="server" ForeColor="Blue"></asp:Label>
            </ContentTemplate>
        </asp:UpdatePanel>
        <br />
        <br />
        <asp:Label ID="lblSAS" runat="server" Text="SAS Token: [Generate Token]"></asp:Label>
        <br />
        <br />
        <asp:GridView ID="devicesGridView" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnSelectedIndexChanged="devicesGridView_SelectedIndexChanged">
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <Columns>
                <asp:CommandField ButtonType="Button" SelectText="Generate SAS" ShowSelectButton="True" />
                <asp:BoundField DataField="Id" HeaderText="Id" />
                <asp:BoundField DataField="ConnectionString" HeaderText="ConnectionString" />
                <asp:BoundField DataField="ConnectionState" HeaderText="ConnectionState" />
                <asp:BoundField DataField="LastActivityTime" HeaderText="LastActivityTime" />
                <asp:BoundField DataField="MessageCount" HeaderText="MessageCount" />
                <asp:BoundField DataField="State" HeaderText="State" />
            </Columns>
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#E9E7E2" />
            <SortedAscendingHeaderStyle BackColor="#506C8C" />
            <SortedDescendingCellStyle BackColor="#FFFDF8" />
            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
        </asp:GridView>
        <br />
        <br />
        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="Conditional" runat="server">
            <ContentTemplate>
                <asp:Label ID="Label4" runat="server" Text="Retrieve Messages from"></asp:Label>
                 &nbsp;
                <asp:DropDownList ID="cboDevices2" runat="server" />
                 &nbsp;
                <asp:Button ID="cmdStart" runat="server" OnClick="cmdStart_Click" Text="Start Listening" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="cmdStop" runat="server" Text="Stop Listening" OnClick="cmdStop_Click" />
                <br /><br />
                <asp:TextBox ID="txtMessages" TextMode="MultiLine" Rows="25" runat="server" Width="801px"></asp:TextBox>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</asp:Content>
