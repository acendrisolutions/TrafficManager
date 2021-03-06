To view this authors blog article explaining the template: 

https://www.acendri-solutions.com/post/using-bicep-automation-to-build-azure-traffic-manager-profiles


Using Bicep Automation to Build Azure Traffic Manager Profiles

Migrating on-prem virtual machines to the cloud is a delicate dance and is one that may take a few tries to get right.  Application downtime while migrating up and failing back down can be in short supply, so it is important to automate as many processes as possible to prevent mistakes and longer RTO.  

Azure Traffic Manager uses DNS to direct the client requests to the appropriate service  endpoint based on a traffic-routing method.  The endpoint can be any Internet-facing service hosted inside or outside of Azure. 

Because Traffic Manager uses DNS for multi-endpoint load balances, we can use it during a cloud migration to point traffic at on-prem web servers until the migration is scheduled, then enable the Azure endpoints to start immediately forwarding traffic to the new cloud server without having to wait for DNS TTL caching to expire on any hosts.

This sounds great, but how will it scale? If you are only moving a handful of servers, the transition to cloud and back can be accomplished without too much trouble. However, with a large cloud project using SRM an entire data center might be migrated at once... 

This is where the Bicep automation comes in.

Automation with Bicep:

The project I have at hand requires me to create approximately 50 Traffic Manager Profiles and be able to quickly fail back and forth between on-prem addresses and cloud addresses.

I have accomplished this task by creating a 'for each' loop that feeds the template resource with an array of variable objects. In this blog example I will define 3 objects to create Traffic Manager Profiles with. I have also defined some global parameters that do not change per variable object. 

Second, I am creating the traffic manager profile resource using the 'for each' loop that depends on the variable objects listed above.
 

When this script is run for the first time, it will create the Azure resources and still point traffic at the on-prem public IPs. When it is time to kick off the migration processes, we will run the script a second time disabling the on-prem endpoints and enabling the azure target endpoints like so:

param globalVariables object = {
  onpremTargetStatus: 'Disabled'
  azureTargetStatus: 'Enabled'
}

The complete version of this script is available on Github at:

https://github.com/acendrisolutions/TrafficManager 


Additional Reading:

https://docs.microsoft.com/en-us/azure/traffic-manager/quickstart-create-traffic-manager-profile-template 

https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-endpoint-types 

https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/loops 