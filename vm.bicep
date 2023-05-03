param location string = 'eastus'
param adminUsername string = 'hari'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'myVNet3'
  location: location  
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'mySubnet111'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'mySubnet222'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}
resource nic1 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'nic1'
  location: location  
  properties: {
    ipConfigurations: [
      {
        name: 'myIPConfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'mySubnet111')
          }
          privateIPAllocationMethod:'Dynamic'
        }
      }
    ]
    }
  }

  resource vm1 'Microsoft.Compute/virtualMachines@2021-03-01' = {
    name: 'VM1'
    location: location
    
    dependsOn: [
      vnet
    ]
    properties: {
      hardwareProfile: {
        vmSize: 'Standard_B1ls'
      }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2019-Datacenter'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
        }
      }
      osProfile: {
        computerName: 'VM1'
        adminUsername: adminUsername
        adminPassword: 'Ha@12345678'
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: resourceId('Microsoft.Network/networkInterfaces', 'nic1')
          }
        ]
      }
    }
  }

  resource nic2 'Microsoft.Network/networkInterfaces@2021-02-01' = {
    name: 'nic2'
    location: location
  
    
    properties: {
      ipConfigurations: [
        {
          name: 'myIPConfig2'
          properties: {
            subnet: {
              id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'mySubnet222')
            }
            privateIPAllocationMethod:'Dynamic'
          }
        }
      ]
      }
    }



resource vm2 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'VM2'
  location: location
  
  dependsOn: [
    vnet
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1ls'
    }
    storageProfile: {
      imageReference: {

        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
  
      }
      osDisk: {
        createOption: 'FromImage'
      }

    }
    osProfile: {
      computerName: 'VM2'
      adminUsername: adminUsername
      adminPassword: 'Ha@12345678'
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', 'nic2')
        }
      ]
    }
  }
}





