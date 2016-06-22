<%@ Page Title="DeviceExplorer" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="DeviceExplorerWeb._Default" Async="true" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>DeviceExplorer Web</h1>
    </div>

    <div class="row">
        <br />
        <asp:Label ID="Label2" runat="server" Text="IoT Hub Connection String"></asp:Label>
        <br />
        <asp:TextBox ID="txtConnectionString" runat="server" Height="87px" Rows="5" TextMode="MultiLine" Width="793px">HostName=[IoTHub_Name].azure-devices.net;SharedAccessKeyName=[SharedAccess_PolicyName];SharedAccessKey=[PrimaryKey]</asp:TextBox>&nbsp; <asp:Button ID="cmdUpdate" runat="server" Text="Connect to IoT Hub" OnClick="cmdUpdate_Click" />
        <br />
        <br />
        <strong>Device Registration</strong><br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="New Device"></asp:Label>
&nbsp;
        <asp:TextBox ID="txtNewDeviceName" runat="server"></asp:TextBox>
&nbsp;
        <asp:Button ID="cmdAddDevice" runat="server" Enabled="False" OnClick="cmdAddDevice_Click" Text="Add Device" />
        <br />
        <br />
        <br />
        <strong>Cloud-to-Device Messaging</strong><br />
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
                <br />
                <br />
                <br />
                <strong>Device-to-Cloud Messaging</strong><br />
                <br />
                <asp:Label ID="lblCustomMessage" runat="server" Text="Custom Message"></asp:Label>
                &nbsp;
                <asp:TextBox ID="txtCustomMessage" runat="server" Width="447px">{&quot;temp&quot;:85, &quot;height&quot;:35}</asp:TextBox>
                &nbsp;
                <br />
                <asp:Label ID="lblMessageStatus0" runat="server" ForeColor="Blue"></asp:Label>
                <br />
                <br />
                <br />
                <strong>Device Registration List</strong><br />
                <br />
                <asp:Label ID="lblSAS" runat="server" Text="SAS Token: [Generate Token]"></asp:Label>
                <br />
                <asp:GridView ID="devicesGridView" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None" OnSelectedIndexChanged="devicesGridView_SelectedIndexChanged" OnRowCommand="devicesGridView_RowCommand">
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    <Columns>
                        <asp:CommandField ButtonType="Button" SelectText="Generate SAS" ShowSelectButton="True" />
                        <asp:ButtonField ButtonType="Button" Text="Send Message From Device" />
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
            </ContentTemplate>
        </asp:UpdatePanel>
        
        <!--<asp:UpdatePanel ID="UpdatePanel1" UpdateMode="Conditional" runat="server">
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
        </asp:UpdatePanel>-->
    </div>

</asp:Content>
