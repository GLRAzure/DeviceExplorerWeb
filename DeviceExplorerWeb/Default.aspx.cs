using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ServiceBus.Messaging;
using Microsoft.Azure.Devices;
using Microsoft.Azure.Devices.Common;
using Microsoft.Azure.Devices.Common.Security;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Net;

namespace DeviceExplorerWeb
{
    public partial class _Default : Page
    {
        private string iotHubHostName;
        private static CancellationTokenSource ctsForDataMonitoring;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            var builder = IotHubConnectionStringBuilder.Create(txtConnectionString.Text);
            iotHubHostName = builder.HostName;
            if (iotHubHostName != "")
            {
                cmdAddDevice.Enabled = true;
                cmdSend.Enabled = true;
            }
            getDevices();
        }

        async void getDevices()
        {
            var devicesProcessor = new DevicesProcessor(txtConnectionString.Text, 1000, "");
            var devicesList = await devicesProcessor.GetDevices();
            devicesList.Sort();
            var sortableDevicesBindingList = new SortableBindingList<DeviceEntity>(devicesList);

            devicesGridView.DataSource = sortableDevicesBindingList;
            devicesGridView.DataBind();

            cboDevices.DataSource = sortableDevicesBindingList;
            cboDevices.DataValueField = "Id";
            cboDevices.DataTextField = "Id";
            cboDevices.DataBind();

            cboDevices2.DataSource = sortableDevicesBindingList;
            cboDevices2.DataValueField = "Id";
            cboDevices2.DataTextField = "Id";
            cboDevices2.DataBind();
        }

        protected void cmdAddDevice_Click(object sender, EventArgs e)
        {
            if (txtNewDeviceName.Text != String.Empty)
            {
                var builder = IotHubConnectionStringBuilder.Create(txtConnectionString.Text);
                iotHubHostName = builder.HostName;
                registerDevice();
            }
        }

        async void registerDevice()
        {
            var registryManager = RegistryManager.CreateFromConnectionString(txtConnectionString.Text);
            var device = new Device(txtNewDeviceName.Text);
            await registryManager.AddDeviceAsync(device);
            getDevices();
        }

        protected void devicesGridView_SelectedIndexChanged(object sender, EventArgs e)
        {
            var row = devicesGridView.SelectedRow;
            var deviceId = row.Cells[1].Text;
            var deviceKey = row.Cells[2].Text;

            var sasBuilder = new SharedAccessSignatureBuilder()
            {
                Key = deviceKey,
                Target = String.Format("{0}/devices/{1}", iotHubHostName, WebUtility.UrlEncode(deviceId)),
                TimeToLive = TimeSpan.FromDays(7)
            };

            lblSAS.Text = "SAS Connection: " + deviceConnectionStringWithSAS(sasBuilder.ToSignature(), deviceId);
        }

        private string deviceConnectionStringWithSAS(string sas, string deviceId)
        {
            // Format of Device Connection String with SAS Token:
            // "HostName=<iothub_host_name>;CredentialType=SharedAccessSignature;DeviceId=<device_id>;SharedAccessSignature=SharedAccessSignature sr=<iot_host>/devices/<device_id>&sig=<token>&se=<expiry_time>";
            
            return String.Format("HostName={0};DeviceId={1};SharedAccessSignature={2}", iotHubHostName, deviceId, sas);
        }

        protected void cmdSend_Click(object sender, EventArgs e)
        {
            sendMessage();
            UpdatePanel2.Update();
        }

        async void sendMessage()
        {
            ServiceClient serviceClient = ServiceClient.CreateFromConnectionString(txtConnectionString.Text);
            var cloudToDeviceMessage = txtMessage.Text;
            var serviceMessage = new Microsoft.Azure.Devices.Message(Encoding.ASCII.GetBytes(cloudToDeviceMessage));
            serviceMessage.Ack = DeliveryAcknowledgement.Full;
            serviceMessage.MessageId = Guid.NewGuid().ToString();
            await serviceClient.SendAsync(cboDevices.SelectedItem.ToString(), serviceMessage);

            lblMessageStatus.Text = $"Sent to Device ID: [{cboDevices.SelectedItem.ToString()}], Message:\"{cloudToDeviceMessage}\", message Id: {serviceMessage.MessageId}\n";

            await serviceClient.CloseAsync();
        }

        private async Task MonitorEventHubAsync(CancellationToken ct)
        {
            EventHubClient eventHubClient = null;
            EventHubReceiver eventHubReceiver = null;
            var consumerGroupName = "$Default";
            var startTime = DateTime.Now;

            try
            {
                string selectedDevice = cboDevices2.SelectedItem.ToString();
                eventHubClient = EventHubClient.CreateFromConnectionString(txtConnectionString.Text, "messages/events");
                var eventHubPartitionsCount = eventHubClient.GetRuntimeInformation().PartitionCount;
                string partition = EventHubPartitionKeyResolver.ResolveToPartition(selectedDevice, eventHubPartitionsCount);
                eventHubReceiver = eventHubClient.GetConsumerGroup(consumerGroupName).CreateReceiver(partition, startTime);

                //receive the events from startTime until current time in a single call and process them
                var events = await eventHubReceiver.ReceiveAsync(int.MaxValue, TimeSpan.FromSeconds(20));

                foreach (var eventData in events)
                {
                    var data = Encoding.UTF8.GetString(eventData.GetBytes());
                    var enqueuedTime = eventData.EnqueuedTimeUtc.ToLocalTime();
                    var connectionDeviceId = eventData.SystemProperties["iothub-connection-device-id"].ToString();

                    if (string.CompareOrdinal(selectedDevice.ToUpper(), connectionDeviceId.ToUpper()) == 0)
                    {
                        txtMessages.Text += $"{enqueuedTime}> Device: [{connectionDeviceId}], Data:[{data}]";
                        UpdatePanel1.Update();

                        if (eventData.Properties.Count > 0)
                        {
                            txtMessages.Text += "Properties:\r\n";
                            UpdatePanel1.Update();
                            foreach (var property in eventData.Properties)
                            {
                                txtMessages.Text += $"'{property.Key}': '{property.Value}'\r\n";
                                UpdatePanel1.Update();
                            }
                        }
                        txtMessages.Text += "\r\n";
                        UpdatePanel1.Update();
                    }
                }

                //having already received past events, monitor current events in a loop
                while (true)
                {
                    ct.ThrowIfCancellationRequested();

                    var eventData = await eventHubReceiver.ReceiveAsync(TimeSpan.FromSeconds(1));

                    if (eventData != null)
                    {
                        var data = Encoding.UTF8.GetString(eventData.GetBytes());
                        var enqueuedTime = eventData.EnqueuedTimeUtc.ToLocalTime();

                        // Display only data from the selected device; otherwise, skip.
                        var connectionDeviceId = eventData.SystemProperties["iothub-connection-device-id"].ToString();

                        if (string.CompareOrdinal(selectedDevice, connectionDeviceId) == 0)
                        {
                            txtMessages.Text += $"{enqueuedTime}> Device: [{connectionDeviceId}], Data:[{data}]";
                            UpdatePanel1.Update();

                            if (eventData.Properties.Count > 0)
                            {
                                txtMessages.Text += "Properties:\r\n";
                                UpdatePanel1.Update();
                                foreach (var property in eventData.Properties)
                                {
                                    txtMessages.Text += $"'{property.Key}': '{property.Value}'\r\n";
                                    UpdatePanel1.Update();
                                }
                            }
                            txtMessages.Text += "\r\n";
                            UpdatePanel1.Update();
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                if (ct.IsCancellationRequested)
                {
                    txtMessages.Text += $"Stopped Monitoring events. {ex.Message}\r\n";
                    UpdatePanel1.Update();
                }
                else
                {
                    txtMessages.Text += $"Stopped Monitoring events. {ex.Message}\r\n";
                    UpdatePanel1.Update();
                }
                if (eventHubReceiver != null)
                {
                    eventHubReceiver.Close();
                }
                if (eventHubClient != null)
                {
                    eventHubClient.Close();
                }
                cmdStart.Enabled = true;
                cboDevices2.Enabled = true;
                cmdStop.Enabled = false;
                UpdatePanel1.Update();
            }
        }

        protected void cmdStart_Click(object sender, EventArgs e)
        {
            cmdStart.Enabled = false;
            cboDevices2.Enabled = false;
            cmdStop.Enabled = true;
            ctsForDataMonitoring = new CancellationTokenSource();

            txtMessages.Text = "Receiving events...\r\n";
            UpdatePanel1.Update();

            StartListening();
        }

        async Task StartListening()
        {
            await MonitorEventHubAsync(ctsForDataMonitoring.Token);
        }

        protected void cmdStop_Click(object sender, EventArgs e)
        {
            cmdStart.Enabled = true;
            cboDevices2.Enabled = true;
            cmdStop.Enabled = false;
            txtMessages.Text += "Cancelling...\r\n";
            ctsForDataMonitoring.Cancel();
            txtMessages.Text += "Stopped Monitoring events. The operation was canceled.\r\n";

            UpdatePanel1.Update();
            UpdatePanel1.Update();
        }
    }
}