// Bicep script to create many global traffic manager profiles
//


// Global Variables

param globalVariables object = {
  onpremTargetStatus: 'Disabled'
  azureTargetStatus: 'Enabled'
  trafficRoutingMethod: 'Priority'
  environmentTag: 'Development'
}


// Variable object list to create Traffic Manager Profiles

var profiles = [
  {
    profileName: 'aimages-uat-autopremier-com'
    dnsConfigRelativeName: 'aimages-uat.cudirect.com'
    onpremTargetIP: '1.1.1.1'
    azureTargetIP: '2.2.2.2'
    applicationTag: 'L360'
  }
  {
    profileName: 'aiintweb-uat-autopremier-com'
    dnsConfigRelativeName: 'aiintweb-uat.cudirect.com'
    onpremTargetIP: '3.3.3.3'
    azureTargetIP: '4.4.4.4'
    applicationTag: 'L360'
  }
  {
    profileName: 'aabintweb-uat-autopremier-com'
    dnsConfigRelativeName: 'aabintweb-uat.cudirect.com'
    onpremTargetIP: '5.5.5.5'
    azureTargetIP: '6.6.6.6'
    applicationTag: 'L360'
  }
]
 
// Resource Loop to create as many resources as listed in variable object profiles

resource trafficManagerProfile 'Microsoft.Network/trafficManagerProfiles@2018-08-01' = [for profile in profiles: {
  name: profile.profileName
  location: 'global'
  tags: {
    App: profile.applicationTag
    Env: globalVariables.environmentTag
  }
  
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: globalVariables.trafficRoutingMethod
    dnsConfig: {
      relativeName: profile.dnsConfigRelativeName
      ttl: 35
    }
    monitorConfig: {
      protocol: 'HTTP'
      port: 80
      path: '/'
      intervalInSeconds: 30
      timeoutInSeconds: 5
      toleratedNumberOfFailures: 3
    }
    endpoints: [
      {
        name: 'OnPrem-Endpoint' 
        type: 'Microsoft.Network/TrafficManagerProfiles/ExternalEndpoints'
        properties: {
          target: profile.onpremTargetIP
          endpointStatus: globalVariables.onpremTargetStatus
          endpointLocation: 'westus'
          weight: 100
          priority: 1
        }
      }
      {
        name: 'Azure-Endpoint' 
        type: 'Microsoft.Network/TrafficManagerProfiles/ExternalEndpoints'
        properties: {
          target: profile.azureTargetIP
          endpointStatus: globalVariables.azureTargetStatus
          endpointLocation: 'westus'
          weight: 100
          priority: 2
        }
      }  
    ]
  }
}]

 