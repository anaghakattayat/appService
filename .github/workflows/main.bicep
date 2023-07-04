targetScope = 'subscription'
param rgName string = 'AppServiceRG'
param Location string = 'westus3'

param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param sku string = 'F1' // The SKU of App Service Plan
param linuxFxVersion string = 'node|14-lts' // The runtime stack of web app
param repositoryUrl string = 'https://github.com/anaghakattayat/appService.git'
param branch string = 'main'
var appServicePlanName = toLower('amethAppServicePlan-${webAppName}')
var webSiteName = toLower('amethwapp-${webAppName}')

resource reourceGroup 'Microsoft.Resources/resourceGroups@2018-05-01' = {
  location: Location
  name: rgName
  properties: {}
}
output RGNameCreated object = reourceGroup

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: Location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  name: '${appService.name}/web'
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}
