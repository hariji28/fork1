param location string = 'eastus'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'myResourceGroup'
  location: location
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'myVNet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'mySubnet1'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'mySubnet2'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

resource vm1_nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'myVM1-NIC'
  location: location
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'myVM1-IPConfig'
        properties: {
          subnet: {
            id: vnet.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm2_nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'myVM2-NIC'
  location: location
  dependsOn: [
    vnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'myVM2-IPConfig'
        properties: {
          subnet: {
            id: vnet.subnets[1].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm1 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'myVM1'
  location: location
  dependsOn: [
    vm1_nic
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
        name: 'myVM1_OSDisk'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'myVM1'
      adminUsername: 'myAdminUsername'
      adminPassword: 'myAdminPassword'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm1_nic.id
        }
      ]
    }
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'myVM2'
  location: location
  dependsOn: [
    vm2_nic
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1ls'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '20.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: 'myVM2_OSDisk'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'myVM1'
      adminUsername: 'myAdminUsername'
      adminPassword: 'myAdminPassword'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm1_nic.id
        }
      ]
    }
  }
}
