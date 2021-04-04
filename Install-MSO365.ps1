#Requires -RunAsAdministrator

#TODO: -minimumVersion allows for expected update behavior without having to -Force, according to documentation

Install-Module -Scope AllUsers -AllowClobber -Confirm:$false `
        -Name   MSOnline,
                AzureAD,
                ExchangeOnlineManagement,
                Microsoft.Online.SharePoint.PowerShell,
                MicrosoftTeams
                #-Force
#                SharePointPnPPowerShellOnline,

#Microsoft.Graph.Authentication (= 1.1.0)
#Microsoft.Graph.Groups.Planner (= 0.9.1)
#Microsoft.Graph.Identity.ConditionalAccess (= 0.9.1)
#Microsoft.Graph.Intune (= 6.1907.1)
#Microsoft.Graph.Planner (= 1.1.0)
#Microsoft.PowerApps.Administration.PowerShell (= 2.0.99)
#MsCloudLoginAssistant (= 1.0.42)

