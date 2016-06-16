using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            var builder = IotHubConnectionStringBuilder.Create(txtConnectionString.Text);
            iotHubHostName = builder.HostName;
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
    }
}