// Bicep script to create many global traffic manager profiles
//


// Global Variables

param globalVariables object = {
  onpremTargetStatus: 'Enabled'
  azureTargetStatus: 'Disabled'
  trafficRoutingMethod: 'Priority'
  environmentTag: 'UAT'
}


// Variable object list to create Traffic Manager Profiles

var profiles = [
  {
    profileName: 'website1-uat-domain-com'
    dnsConfigRelativeName: 'website1-uat.domain.com'
    onpremTargetIP: '1.1.1.1'
    azureTargetIP: '2.2.2.2'
    applicationTag: 'webApp1'
  }
  {
    profileName: 'website2-uat-domain-com'
    dnsConfigRelativeName: 'website2-uat.domain.com'
    onpremTargetIP: '3.3.3.3'
    azureTargetIP: '4.4.4.4'
    applicationTag: 'webApp2'
  }
  {
    profileName: 'website3-uat-domain-com'
    dnsConfigRelativeName: 'website3-uat.domain.com'
    onpremTargetIP: '5.5.5.5'
    azureTargetIP: '6.6.6.6'
    applicationTag: 'webApp3'
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

 