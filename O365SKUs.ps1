# see https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference

$O365SKUs = @{

	SPZA_IW = @{
		DisplayName = "App Connect IW";
		GUID = [guid]"8f0c5670-4e56-4892-b06d-91c085d7004f";
		ServicePlans = @(
			"SPZA",
			"EXCHANGE_S_FOUNDATION"
		);
	};

	MCOMEETADV = @{
		DisplayName = "Audio Conferencing";
		GUID = [guid]"0c266dff-15dd-4b49-8397-2bb16070ed52";
		ServicePlans = @(
			"MCOMEETADV"
		);
	};

	AAD_BASIC = @{
		DisplayName = "Azure Active Directory Basic";
		GUID = [guid]"2b9c8e7c-319c-43a2-a2a0-48c5c6161de7";
		ServicePlans = @(
			"AAD_BASIC"
		);
	};

	AAD_PREMIUM = @{
		DisplayName = "Azure Active Directory Premium P1";
		GUID = [guid]"078d2b04-f1bd-4111-bbd4-b4b1b354cef4";
		ServicePlans = @(
			"AAD_PREMIUM",
			"ADALLOM_S_DISCOVERY",
			"MFA_PREMIUM"
		);
	};

	AAD_PREMIUM_P2 = @{
		DisplayName = "Azure Active Directory Premium P2";
		GUID = [guid]"84a661c4-e949-4bd2-a560-ed7766fcaf2b";
		ServicePlans = @();
	};

	RIGHTSMANAGEMENT = @{
		DisplayName = "Azure Information Protection P1";
		GUID = [guid]"c52ea49f-fe5d-4e95-93ba-1de91d380f89";
		ServicePlans = @(
			"RMS_S_ENTERPRISE",
			"RMS_S_PREMIUM"
		);
	};

	DYN365_ENTERPRISE_PLAN1 = @{
		DisplayName = "DYNAMICS 365 CUSTOMER ENGAGEMENT PLAN ENTERPRISE EDITION";
		GUID = [guid]"ea126fc5-a19e-42e2-a731-da9d437bffcf";
		ServicePlans = @(
			"DYN365_ENTERPRISE_P1",
			"FLOW_DYN_P2",
			"NBENTERPRISE",
			"POWERAPPS_DYN_P2",
			"PROJECT_CLIENT_SUBSCRIPTION",
			"SHAREPOINT_PROJECT",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
		);
	};

	DYN365_ENTERPRISE_CUSTOMER_SERVICE = @{
		DisplayName = "DYNAMICS 365 FOR CUSTOMER SERVICE ENTERPRISE EDITION";
		GUID = [guid]"749742bf-0d37-4158-a120-33567104deeb";
		ServicePlans = @(
			"DYN365_ENTERPRISE_CUSTOMER_SERVICE",
			"FLOW_DYN_APPS",
			"NBENTERPRISE",
			"POWERAPPS_DYN_APPS",
			"PROJECT_ESSENTIALS",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
		);
	};

	DYN365_FINANCIALS_BUSINESS_SKU = @{
		DisplayName = "DYNAMICS 365 FOR FINANCIALS Business EDITION";
		GUID = [guid]"cc13a803-544e-4464-b4e4-6d6169a138fa";
		ServicePlans = @(
			"DYN365_FINANCIALS_BUSINESS",
			"FLOW_DYN_APPS",
			"POWERAPPS_DYN_APPS",
		);
	};

	DYN365_ENTERPRISE_SALES_CUSTOMERSERVICE = @{
		DisplayName = "DYNAMICS 365 FOR SALES AND CUSTOMER SERVICE ENTERPRISE EDITION";
		GUID = [guid]"8edc2cf8-6438-4fa9-b6e3-aa1660c640cc";
		ServicePlans = @(
			"DYN365_ENTERPRISE_P1",
			"FLOW_DYN_APPS",
			"NBENTERPRISE",
			"POWERAPPS_DYN_APPS",
			"PROJECT_ESSENTIALS",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
		);
	};

	DYN365_ENTERPRISE_SALES = @{
		DisplayName = "DYNAMICS 365 FOR SALES ENTERPRISE EDITION";
		GUID = [guid]"1e1a282c-9c54-43a2-9310-98ef728faace";
		ServicePlans = @(
			"DYN365_ENTERPRISE_SALES",
			"FLOW_DYN_APPS",
			"NBENTERPRISE",
			"POWERAPPS_DYN_APPS",
			"PROJECT_ESSENTIALS",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
		);
	};

	DYN365_ENTERPRISE_TEAM_MEMBERS = @{
		DisplayName = "DYNAMICS 365 FOR TEAM MEMBERS ENTERPRISE EDITION";
		GUID = [guid]"8e7a3d30-d97d-43ab-837c-d7701cef83dc";
		ServicePlans = @(
			"DYN365_Enterprise_Talent_Attract_TeamMember",
			"DYN365_Enterprise_Talent_Onboard_TeamMember",
			"DYN365_ENTERPRISE_TEAM_MEMBERS",
			"Dynamics_365_for_Operations_Team_members",
			"Dynamics_365_for_Retail_Team_members",
			"Dynamics_365_for_Talent_Team_members",
			"FLOW_DYN_TEAM",
			"POWERAPPS_DYN_TEAM",
			"PROJECT_ESSENTIALS",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
		);
	};

	Dynamics_365_for_Operations = @{
		DisplayName = "DYNAMICS 365 UNF OPS PLAN ENT EDITION";
		GUID = [guid]"ccba3cfe-71ef-423a-bd87-b6df3dce59a9";
		ServicePlans = @(
			"DDYN365_CDS_DYN_P2",
			"DYN365_TALENT_ENTERPRISE",
			"Dynamics_365_for_Operations",
			"Dynamics_365_for_Retail",
			"Dynamics_365_Hiring_Free_PLAN",
			"Dynamics_365_Onboarding_Free_PLAN",
			"FLOW_DYN_P2",
			"POWERAPPS_DYN_P2",
		);
	};

	EMS = @{
		DisplayName = "Enterprise Mobility & Security E3";
		GUID = [guid]"efccb6f7-5641-4e0e-bd10-b4976e1bf68e";
		ServicePlans = @(
			"AAD_PREMIUM",
			"INTUNE_A",
			"ADALLOM_S_DISCOVERY",
			"MFA_PREMIUM",
			"RMS_S_ENTERPRISE",
			"RMS_S_PREMIUM"
		);
	};

	EMSPREMIUM = @{
		DisplayName = "Enterprise Mobility & Security E5";
		GUID = [guid]"b05e124f-c7cc-45a0-a6aa-8cf78c946968";
		ServicePlans = @(
			"ATA",
			"ADALLOM_S_STANDALONE",
			"RMS_S_PREMIUM2",
			"AAD_PREMIUM",
			"AAD_PREMIUM_P2",
			"MFA_PREMIUM",
			"INTUNE_A",
			"RMS_S_ENTERPRISE",
			"RMS_S_PREMIUM"
		);
	};

	EXCHANGESTANDARD = @{
		DisplayName = "Exchange Online (Plan 1)";
		GUID = [guid]"4b9405b0-7788-4568-add1-99614e613b69";
		ServicePlans = @(
			"EXCHANGE_S_STANDARD"
		);
	};

	EXCHANGEENTERPRISE =@{
		DisplayName = "Exchange Online (Plan 2)";
		GUID = [guid]"19ec0d23-8335-4cbd-94ac-6050e30712fa";
		ServicePlans = @(
			"EXCHANGE_S_ENTERPRISE"
		);
	};

	EXCHANGEARCHIVE_ADDON = @{
		DisplayName = "Exchange Online Archiving for Exchange Online";
		GUID = [guid]"ee02fd1b-340e-4a4b-b355-4a514e4c8943";
		ServicePlans = @(
			"EXCHANGE_S_ARCHIVE_ADDON"
		);
	};

	EXCHANGEARCHIVE =   @{
		DisplayName = "Exchange Online Archiving for Exchange Server";
		GUID = [guid]"90b5e015-709a-4b8b-b08e-3200f994494c";
		ServicePlans = @(
			"EXCHANGE_S_ARCHIVE"
		);
	};

	EXCHANGEESSENTIALS =@{
		DisplayName = "Exchange Online Essentials";
		GUID = [guid]"7fc0182e-d107-4556-8329-7caaa511197b";
		ServicePlans = @(
			"EXCHANGE_S_STANDARD"
		);
	};

	EXCHANGE_S_ESSENTIALS = @{
		DisplayName = "Exchange Online Essentials";
		GUID = [guid]"e8f81a67-bd96-4074-b108-cf193eb9433b";
		ServicePlans = @(
			"EXCHANGE_S_ESSENTIALS"
		);
	};

	EXCHANGEDESKLESS =  @{
		DisplayName = "Exchange Online Kiosk";
		GUID = [guid]"80b2d799-d2ba-4d2a-8842-fb0d0f3a4b82";
		ServicePlans = @(
			"EXCHANGE_S_DESKLESS"
		);
	};

	EXCHANGETELCO = @{
		DisplayName = "Exchange Online POP";
		GUID = [guid]"cb0a98a8-11bc-494c-83d9-c1b1ac65327e";
		ServicePlans = @(
			"EXCHANGE_B_STANDARD"
		);
	};

	INTUNE_A = @{
		DisplayName = "Intune";
		GUID = [guid]"061f9ace-7d42-4136-88ac-31dc755f143f";
		ServicePlans = @(
			"INTUNE_A"
		);
	};

	O365_BUSINESS = @{
		DisplayName = "Microsoft 365 Apps for Business";
		GUID = [guid]"cdd28e44-67e3-425e-be4c-737fab2899d3";
		ServicePlans = @(
			"FORMS_PLAN_E1",
			"OFFICE_BUSINESS",
			"ONEDRIVESTANDARD",
			"SHAREPOINTWAC",
			"SWAY"
		);
	};

	SMB_BUSINESS = @{
		DisplayName = "Microsoft 365 Apps for Business";
		GUID = [guid]"b214fe43-f5a3-4703-beeb-fa97188220fc";
		ServicePlans = @(
			"FORMS_PLAN_E1",
			"OFFICE_BUSINESS",
			"ONEDRIVESTANDARD",
			"SHAREPOINTWAC",
			"SWAY"
		);
	};

	OFFICESUBSCRIPTION = @{
		DisplayName = "Microsoft 365 Apps for Enterprise";
		GUID = [guid]"c2273bd0-dff7-4215-9ef5-2c7bcfb06425";
		ServicePlans = @(
			"FORMS_PLAN_E1",
			"OFFICESUBSCRIPTION",
			"ONEDRIVESTANDARD",
			"SHAREPOINTWAC",
			"SWAY"
		);
	};

	O365_BUSINESS_ESSENTIALS = @{
		DisplayName = "Microsoft 365 Business Basic";
		GUID = [guid]"3b555118-da6a-4418-894f-7df1e2096870";
		ServicePlans = @(
			"BPOS_S_TODO_1",
			"EXCHANGE_S_STANDARD",
			"FLOW_O365_P1",
			"FORMS_PLAN_E1",
			"MCOSTANDARD",
			"OFFICEMOBILE_SUBSCRIPTION",
			"POWERAPPS_O365_P1",
			"PROJECTWORKMANAGEMENT",
			"SHAREPOINTSTANDARD",
			"SHAREPOINTWAC",
			"SWAY",
			"TEAMS1",
			"YAMMER_ENTERPRISE"
		);
	};

	SMB_BUSINESS_ESSENTIALS = @{
		DisplayName = "Microsoft 365 Business Basic";
		GUID = [guid]"dab7782a-93b1-4074-8bb1-0e61318bea0b";
		ServicePlans = @(
			"BPOS_S_TODO_1",
			"EXCHANGE_S_STANDARD",
			"FLOW_O365_P1",
			"FORMS_PLAN_E1",
			"MCOSTANDARD",
			"OFFICEMOBILE_SUBSCRIPTION",
			"POWERAPPS_O365_P1",
			"PROJECTWORKMANAGEMENT",
			"SHAREPOINTSTANDARD",
			"SHAREPOINTWAC",
			"SWAY",
			"TEAMS1",
			"YAMMER_MIDSIZE"
		);
	};

	O365_BUSINESS_PREMIUM = @{
		DisplayName = "Microsoft 365 Business Standard";
		GUID = [guid]"f245ecc8-75af-4f8e-b61f-27d8114de5f3";
		ServicePlans = @(
			"BPOS_S_TODO_1",
			"DESKLESS",
			"EXCHANGE_S_STANDARD",
			"FLOW_O365_P1",
			"FORMS_PLAN_E1",
			"MCOSTANDARD",
			"MICROSOFTBOOKINGS",
			"O365_SB_Relationship_Management",
			"OFFICE_BUSINESS",
			"POWERAPPS_O365_P1",
			"PROJECTWORKMANAGEMENT",
			"SHAREPOINTSTANDARD",
			"SHAREPOINTWAC",
			"SWAY",
			"TEAMS1",
			"YAMMER_ENTERPRISE"
		);
	};

	SMB_BUSINESS_PREMIUM = @{
		DisplayName = "Microsoft 365 Business Standard";
		GUID = [guid]"ac5cef5d-921b-4f97-9ef3-c99076e5470f";
		ServicePlans = @(
			"BPOS_S_TODO_1",
			"DESKLESS",
			"EXCHANGE_S_STANDARD",
			"FLOW_O365_P1",
			"FORMS_PLAN_E1",
			"MCOSTANDARD",
			"MICROSOFTBOOKINGS",
			"O365_SB_Relationship_Management",
			"OFFICE_BUSINESS",
			"POWERAPPS_O365_P1",
			"PROJECTWORKMANAGEMENT",
			"SHAREPOINTSTANDARD",
			"SHAREPOINTWAC",
			"SWAY",
			"TEAMS1",
			"YAMMER_ENTERPRISE"
		);
	};

	SPB = @{
		DisplayName = "Microsoft 365 Business Premium";
		GUID = [guid]"cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46";
		ServicePlans = @(
			"AAD_SMB",
			"BPOS_S_TODO_1",
			"DESKLESS",
			"EXCHANGE_S_ARCHIVE_ADDON",
			"EXCHANGE_S_STANDARD",
			"FLOW_O365_P1",
			"FORMS_PLAN_E1",
			"INTUNE_A",
			"INTUNE_SMBIZ",
			"MCOSTANDARD",
			"MICROSOFTBOOKINGS",
			"O365_SB_Relationship_Management",
			"OFFICE_BUSINESS",
			"POWERAPPS_O365_P1",
			"PROJECTWORKMANAGEMENT",
			"RMS_S_ENTERPRISE",
			"RMS_S_PREMIUM",
			"SHAREPOINTSTANDARD",
			"SHAREPOINTWAC",
			"STREAM_O365_E1",
			"SWAY",
			"TEAMS1",
			"WINBIZ",
			"YAMMER_ENTERPRISE"
		);
	};

	SPE_E3 = @{
		DisplayName = "Microsoft 365 E3";
		GUID = [guid]"05e9a617-0261-4cee-bb44-138d3ef5d965";
		ServicePlans = @(
			"AAD_PREMIUM",
			"ADALLOM_S_DISCOVERY",
			"BPOS_S_TODO_2",
			"Deskless",
			"EXCHANGE_S_ENTERPRISE",
			"FLOW_O365_P2",
			"FORMS_PLAN_E3",
			"INTUNE_A",
			"MCOSTANDARD",
			"MFA_PREMIUM",
			"OFFICESUBSCRIPTION",
			"POWERAPPS_O365_P2",
			"PROJECTWORKMANAGEMENT",
			"RMS_S_ENTERPRISE",
			"RMS_S_PREMIUM",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
			"STREAM_O365_E3",
			"SWAY",
			"TEAMS1",
			"WIN10_PRO_ENT_SUB",
			"YAMMER_ENTERPRISE",
		)
	};

	SPE_E5 = @{
		DisplayName = "Microsoft 365 E5";
		GUID = [guid]"06ebc4ee-1bb5-47dd-8120-11324bc54e06";
		ServicePlans = @(
			"MCOMEETADV",
			"AAD_PREMIUM",
			"AAD_PREMIUM_P2",
			"ATA",
			"RMS_S_PREMIUM",
			"RMS_S_PREMIUM2",
			"LOCKBOX_ENTERPRISE",
			"EXCHANGE_S_ENTERPRISE",
			"FLOW_O365_P3",
			"INFORMATION_BARRIERS",
			"MIP_S_CLP2",
			"MIP_S_CLP1",
			"MYANALYTICS_P2",
			"RMS_S_ENTERPRISE",
			"MFA_PREMIUM",
			"ADALLOM_S_STANDALONE",
			"WINDEFATP",
			"FORMS_PLAN_E5",
			"INTUNE_A",
			"KAIZALA_STANDALONE",
			"EXCHANGE_ANALYTICS",
			"PROJECTWORKMANAGEMENT",
			"MICROSOFT_SEARCH",
			"Deskless",
			"STREAM_O365_E5",
			"TEAMS1",
			"INTUNE_O365",
			"EQUIVIO_ANALYTICS",
			"ADALLOM_S_O365",
			"ATP_ENTERPRISE",
			"THREAT_INTELLIGENCE",
			"PAM_ENTERPRISE",
			"OFFICESUBSCRIPTION",
			"SHAREPOINTWAC",
			"MCOEV",
			"BI_AZURE_P2",
			"POWERAPPS_O365_P3",
			"PREMIUM_ENCRYPTION",
			"SHAREPOINTENTERPRISE",
			"MCOSTANDARD",
			"SWAY",
			"BPOS_S_TODO_3",
			"WHITEBOARD_PLAN3",
			"WIN10_PRO_ENT_SUB",
			"YAMMER_ENTERPRISE",
		);
	};

	M365_F1 = @{
		DisplayName = "Microsoft 365 F1";
		GUID = [guid]"44575883-256e-4a79-9da4-ebe9acabe2b2";
		ServicePlans = @(
			"AAD_PREMIUM",
			"RMS_S_PREMIUM",
			"RMS_S_ENTERPRISE_GOV" (6a76346d-5d6e-4051-9fe3-ed3f312b5597)
			"ADALLOM_S_DISCOVERY",
			"EXCHANGE_S_FOUNDATION",
			"MFA_PREMIUM",
			"INTUNE_A",
			"PROJECTWORKMANAGEMENT",
			"STREAM_O365_K",
			"TEAMS1",
			"INTUNE_O365",
			"SHAREPOINTDESKLESS",
			"MCOIMP",
			"YAMMER_ENTERPRISE",
		)
	}

	SPE_F1 = @{
		DisplayName = "Microsoft 365 F3";
		GUID = [guid]"66b55226-6b4f-492c-910c-a3b7a3c9d993";
		ServicePlans = @(
		"AAD_PREMIUM",
		"RMS_S_PREMIUM",
		"RMS_S_ENTERPRISE",
		"ADALLOM_S_DISCOVERY",
		"EXCHANGE_S_DESKLESS",
		"FLOW_O365_S1",
		"MFA_PREMIUM",
		"FORMS_PLAN_K",
		"INTUNE_A",
		"KAIZALA_O365_P1",
		"PROJECTWORKMANAGEMENT",
		"MICROSOFT_SEARCH",
		"Deskless",
		"STREAM_O365_K",
		"TEAMS1",
		"INTUNE_O365",
		"SHAREPOINTWAC",
		"OFFICEMOBILE_SUBSCRIPTION",
		"POWERAPPS_O365_S1",
		"SHAREPOINTDESKLESS",
		"MCOIMP",
		"SWAY",
		"BPOS_S_TODO_FIRSTLINE",
		"WHITEBOARD_FIRSTLINE1",
		"WIN10_ENT_LOC_F1",
		"YAMMER_ENTERPRISE",
		)
	}

	FLOW_FREE = @{
		DisplayName = "Power Automate Free";
		GUID = [guid]"f30db892-07e9-47e9-837c-80727f46fd3d";
		ServicePlans = @(
			"DYN365_CDS_VIRAL";
		);
	};

	MCOEV = @{
		DisplayName = "Microsoft 365 Phone System";
		GUID = [guid]"e43b5b99-8dfb-405f-9987-dc307f34bcbd";
		ServicePlans = @(
			"MCOEV";
		);
	}; # formerly "Cloud PBX"

	MCOEVSMB_1 = @{
		DisplayName = "Microsoft 365 Phone System for Small and Medium Business";
		GUID = [guid]"aa6791d3-bb09-4bc2-afed-c30c3fe26032";
		ServicePlans = @(
			"MCOEVSMB",
		)
	}

	WIN_DEF_ATP = @{
		DisplayName = "Microsoft Defender Advanced Threat Protection";
		GUID = [guid]"111046dd-295b-4d6d-9724-d52ac90bd1f2";
		ServicePlans = @(
			"EXCHANGE_S_FOUNDATION",
			"WINDEFATP",
		)
	}

	CRMPLAN2 = @{
		DisplayName = "Microsoft DYNAMICS CRM ONLINE BASIC";
		GUID = [guid]"906af65a-2970-46d5-9b58-4e9aa50f0657"
		ServicePlans = @(
			"CRMPLAN2" (bf36ca64-95c6-4918-9275-eb9f4ce2c04f)
			"FLOW_DYN_APPS",
			"POWERAPPS_DYN_APPS",
		)
	}

	CRMSTANDARD = @{
		DisplayName = "Microsoft DYNAMICS CRM ONLINE";
		GUID = [guid]"d17b27af-3f49-4822-99f9-56a661538792";
		ServicePlans = @(
			"RMSTANDARD",
			"FLOW_DYN_APPS",
			"MDM_SALES_COLLABORATION",
			"NBPROFESSIONALFORCRM",
			"POWERAPPS_DYN_APPS",
		)
	}

	IT_ACADEMY_AD = @{
		DisplayName = "MS IMAGINE ACADEMY";
		GUID = [guid]"ba9a34de-4489-469d-879c-0f0f145321cd";
		ServicePlans = @(
			"IT_ACADEMY_AD"
		)
	}

	TEAMS_FREE = @{
		DisplayName = "Microsoft Teams (Free)";
		GUID = [guid]"16ddbbfc-09ea-4de2-b1d7-312db6112d70";
		ServicePlans = @(
			"EXCHANGE_S_FOUNDATION", 
			"MCOFREE",
			"TEAMS_FREE",
			"SHAREPOINTDESKLESS", 
			"TEAMS_FREE_SERVICE",
			"WHITEBOARD_FIRSTLINE1",
		)
	}

	EQUIVIO_ANALYTICS = @{
		DisplayName = "Office 365 Advanced Compliance";
		GUID = [guid]"1b1b1f7a-8355-43b6-829f-336cfccb744c";
		ServicePlans = @(
			"LOCKBOX_ENTERPRISE",
			"INFORMATION_BARRIERS",
			"MIP_S_CLP2" (efb0351d-3b08-4503-993d-383af8de41e3)
			"EQUIVIO_ANALYTICS",
			"PAM_ENTERPRISE",
			"PREMIUM_ENCRYPTION",
		)
	}

	ATP_ENTERPRISE = @{
		DisplayName = "Office 365 Advanced Threat Protection (Plan 1)";
		GUID = [guid]"4ef96642-f096-40de-a3e9-d83fb2f90211";
		ServicePlans = @(
			"ATP_ENTERPRISE",
		)
	}

	STANDARDPACK = @{
		DisplayName = "Office 365 E1";
		GUID = [guid]"18181a46-0d4e-45cd-891e-60aabd171b4e";
		ServicePlans = @(
			"BPOS_S_TODO_1" (5e62787c-c316-451f-b873-1d05acd4d12c)
			"Deskless",
			"EXCHANGE_S_STANDARD",
			"FLOW_O365_P1",
			"FORMS_PLAN_E1",
			"MCOSTANDARD",
			"OFFICEMOBILE_SUBSCRIPTION",
			"POWERAPPS_O365_P1",
			"PROJECTWORKMANAGEMENT",
			"SHAREPOINTSTANDARD",
			"SHAREPOINTWAC",
			"STREAM_O365_E1",
			"SWAY",
			"TEAMS1",
			"YAMMER_ENTERPRISE",)
		);
	};

	STANDARDWOFFPACK = @{
		DisplayName = "Office 365 E2";
		GUID = [guid]"6634e0ce-1a9f-428c-a498-f84ec7b8aa2e";
		ServicePlans = @(
			"BPOS_S_TODO_1"(5e62787c-c316-451f-b873-1d05acd4d12c)
			"Deskless",
			"EXCHANGE_S_STANDARD",
			"FLOW_O365_P1",
			"FORMS_PLAN_E1",
			"MCOSTANDARD",
			"POWERAPPS_O365_P1",
			"PROJECTWORKMANAGEMENT",
			"SHAREPOINTSTANDARD",
			"SHAREPOINTWAC",
			"STREAM_O365_E1",
			"SWAY",
			"TEAMS1",
			"YAMMER_ENTERPRISE",
		)
	}

	ENTERPRISEPACK = @{
		DisplayName = "Office 365 E3";
		GUID = [guid]"6fd2c87f-b296-42f0-b197-1e91e994b900";
		ServicePlans = @(
			"BPOS_S_TODO_2",
			"Deskless",
			"EXCHANGE_S_ENTERPRISE",
			"FLOW_O365_P2",
			"FORMS_PLAN_E3",
			"MCOSTANDARD",
			"OFFICESUBSCRIPTION",
			"POWERAPPS_O365_P2",
			"PROJECTWORKMANAGEMENT",
			"RMS_S_ENTERPRISE",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
			"STREAM_O365_E3",
			"SWAY",
			"TEAMS1",
			"YAMMER_ENTERPRISE",
		);
	};

	DEVELOPERPACK = @{
		DisplayName = "Office 365 E3 Developer";
		GUID = [guid]"189a915c-fe4f-4ffa-bde4-85b9628d07a0";
		ServicePlans = @(
			"BPOS_S_TODO_3",
			"EXCHANGE_S_ENTERPRISE",
			"FLOW_O365_P2",
			"FORMS_PLAN_E5",
			"MCOSTANDARD",
			"OFFICESUBSCRIPTION",
			"POWERAPPS_O365_P2",
			"PROJECTWORKMANAGEMENT",
			"SHAREPOINT_S_DEVELOPER",
			"SHAREPOINTWAC_DEVELOPER",
			"STREAM_O365_E5",
			"SWAY",
			"TEAMS1",
		)
	}

	ENTERPRISEWITHSCAL = @{
		DisplayName = "Office 365 E4";
		GUID = [guid]"1392051d-0cb9-4b7a-88d5-621fee5e8711";
		ServicePlans = @(
			"BPOS_S_TODO_2",
			"Deskless",
			"EXCHANGE_S_ENTERPRISE",
			"FLOW_O365_P2",
			"FORMS_PLAN_E3",
			"MCOSTANDARD",
			"MCOVOICECONF",
			"OFFICESUBSCRIPTION",
			"POWERAPPS_O365_P2",
			"PROJECTWORKMANAGEMENT",
			"RMS_S_ENTERPRISE",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
			"STREAM_O365_E3",
			"SWAY",
			"TEAMS1",
			"YAMMER_ENTERPRISE",
		)
	}

	ENTERPRISEPREMIUM = @{
		DisplayName = "Office 365 E5";
		GUID = [guid]"c7df2760-2c81-4ef7-b578-5b5392b571df";
		ServicePlans = @(
			"ADALLOM_S_O365",
			"BI_AZURE_P2",
			"BPOS_S_TODO_3",
			"Deskless",
			"EQUIVIO_ANALYTICS",
			"EXCHANGE_ANALYTICS",
			"EXCHANGE_S_ENTERPRISE",
			"FLOW_O365_P3",
			"FORMS_PLAN_E5",
			"LOCKBOX_ENTERPRISE",
			"MCOEV",
			"MCOMEETADV",
			"MCOSTANDARD",
			"MICROSOFTBOOKINGS",
			"OFFICESUBSCRIPTION",
			"POWERAPPS_O365_P3",
			"PROJECTWORKMANAGEMENT",
			"RMS_S_ENTERPRISE",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
			"STREAM_O365_E5",
			"SWAY",
			"TEAMS1",
			"THREAT_INTELLIGENCE",
			"YAMMER_ENTERPRISE",
		)
	}

	ENTERPRISEPREMIUM_NOPSTNCONF = @{
		DisplayName = "Office 365 E5 without Audio Conferencing";
		GUID = [guid]"";
		ServicePlans = @(
			"ADALLOM_S_O365",
			"BI_AZURE_P2",
			"BPOS_S_TODO_3",
			"Deskless",
			"EQUIVIO_ANALYTICS",
			"EXCHANGE_ANALYTICS",
			"EXCHANGE_S_ENTERPRISE",
			"FLOW_O365_P3",
			"FORMS_PLAN_E5",
			"LOCKBOX_ENTERPRISE",
			"MCOEV",
			"MCOSTANDARD",
			"OFFICESUBSCRIPTION",
			"POWERAPPS_O365_P3",
			"PROJECTWORKMANAGEMENT",
			"RMS_S_ENTERPRISE",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
			"STREAM_O365_E5",
			"SWAY",
			"TEAMS1",
			"THREAT_INTELLIGENCE",
			"YAMMER_ENTERPRISE",
		)
	}

	DESKLESSPACK = @{
		DisplayName = "Office 365 F3";
		GUID = [guid]"4b585984-651b-448a-9e53-3b10f069cf7f";
		ServicePlans = @(
			"BPOS_S_TODO_FIRSTLINE",
			"CDS_O365_F1",
			"Deskless",
			"DYN365_CDS_O365_F1",
			"EXCHANGE_S_DESKLESS",
			"FLOW_O365_S1",
			"FORMS_PLAN_K",
			"INTUNE_O365",
			"KAIZALA_O365_P1",
			"MCOIMP",
			"MICROSOFT_SEARCH",
			"OFFICEMOBILE_SUBSCRIPTION",
			"POWERAPPS_O365_S1",
			"POWER_VIRTUAL_AGENTS_O365_F1",
			"PROJECT_O365_F3",
			"PROJECTWORKMANAGEMENT",
			"RMS_S_BASIC",
			"SHAREPOINTDESKLESS",
			"SHAREPOINTWAC",
			"STREAM_O365_K",
			"SWAY",
			"TEAMS1",
			"WHITEBOARD_FIRSTLINE1",
			"YAMMER_ENTERPRISE",
		);
	}; # formerly F1

	MIDSIZEPACK = @{
		DisplayName = "Office 365 Midsize Business";
		GUID = [guid]"04a7fb0d-32e0-4241-b4f5-3f7618cd1162";
		ServicePlans = @(
			"EXCHANGE_S_STANDARD_MIDMARKET",
			"MCOSTANDARD_MIDMARKET",
			"OFFICESUBSCRIPTION",
			"SHAREPOINTENTERPRISE_MIDMARKET",
			"SHAREPOINTWAC",
			"SWAY",
			"YAMMER_MIDSIZE",
		)
	}

	LITEPACK = @{
		DisplayName = "Office 365 Small Business";
		GUID = [guid]"bd09678e-b83c-4d3f-aaba-3dad4abd128b";
		ServicePlans = @(
			"EXCHANGE_L_STANDARD",
			"MCOLITE",
			"SHAREPOINTLITE",
			"SWAY",
		)
	}

	LITEPACK_P2 = @{
		DisplayName = "Office 365 Small Business Premium";
		GUID = [guid]"fc14ec4a-4169-49a4-a51e-2c852931814b";
		ServicePlans = @(
			"EXCHANGE_L_STANDARD",
			"MCOLITE",
			"OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ",
			"SHAREPOINTLITE",
			"SWAY",
		)
	}

	WACONEDRIVESTANDARD = @{
		DisplayName = "ONEDRIVE FOR Business (Plan 1)";
		GUID = [guid]"e6778190-713e-4e4f-9119-8b8238de25df";
		ServicePlans = @(
			"FORMS_PLAN_E1",
			"ONEDRIVESTANDARD",
			"SHAREPOINTWAC",
			"SWAY",
		)
	}
	WACONEDRIVEENTERPRISE = @{
		DisplayName = "ONEDRIVE FOR Business (Plan 2)";
		GUID = [guid]"ed01faf2-1d88-4947-ae91-45ca18703a96";
		ServicePlans = @(
			"ONEDRIVEENTERPRISE",
			"SHAREPOINTWAC",
		)
	}

	POWERAPPS_PER_USER = @{
		DisplayName = "POWER APPS PER USER PLAN";
		GUID = [guid]"b30411f5-fea1-4a59-9ad9-3db7c7ead579	";
		ServicePlans = @(
			
		)
	}

	POWER_BI_STANDARD = @{
		DisplayName = "POWER BI (FREE)";
		GUID = [guid]"a403ebcc-fae0-4ca2-8c8c-7a907fd6c235";
		ServicePlans = @(
			"BI_AZURE_P0",
			"EXCHANGE_S_FOUNDATION",
		)
	}

	POWER_BI_ADDON = @{
		DisplayName = "POWER BI for Office 365 ADD-ON";
		GUID = [guid]"45bc2c81-6072-436a-9b0b-3b12eefbc402";
		ServicePlans = @(
			"BI_AZURE_P1",
			"SQL_IS_SSIM",
		)
	}

	POWER_BI_PRO = @{
		DisplayName = "POWER BI PRO";
		GUID = [guid]"f8a1db68-be16-40ed-86d5-cb42ce701560";
		ServicePlans = @(
			"BI_AZURE_P2",
		)
	}

	PROJECTCLIENT = @{
		DisplayName = "PROJECT for Office 365";
		GUID = [guid]"a10d5e58-74da-4312-95c8-76be4e5b75a0";
		ServicePlans = @(
			"PROJECT_CLIENT_SUBSCRIPTION",
		)
	}

	PROJECTESSENTIALS = @{
		DisplayName = "PROJECT ONLINE ESSENTIALS";
		GUID = [guid]"776df282-9fc0-4862-99e2-70e561b9909e";
		ServicePlans = @(
			"FORMS_PLAN_E1",
			"PROJECT_ESSENTIALS",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
			"SWAY",
		)
	}

	PROJECTPREMIUM = @{
		DisplayName = "PROJECT ONLINE PREMIUM";
		GUID = [guid]"09015f9f-377f-4538-bbb5-f75ceb09358a";
		ServicePlans = @(
			"PROJECT_CLIENT_SUBSCRIPTION",
			"SHAREPOINT_PROJECT",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
		)
	}


	PROJECTONLINE_PLAN_1 = @{
		DisplayName = "PROJECT ONLINE PREMIUM WITHOUT PROJECT CLIENT";
		GUID = [guid]"2db84718-652c-47a7-860c-f10d8abbdae3";
		ServicePlans = @(
			"FORMS_PLAN_E1",
			"SHAREPOINT_PROJECT",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
			"SWAY",
		)
	}


	PROJECTPROFESSIONAL = @{
		DisplayName = "PROJECT ONLINE PROFESSIONAL";
		GUID = [guid]"53818b1b-4a27-454b-8896-0dba576410e6";
		ServicePlans = @(
			"PROJECT_CLIENT_SUBSCRIPTION",
			"SHAREPOINT_PROJECT",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
		)
	}


	PROJECTONLINE_PLAN_2 = @{
		DisplayName = "PROJECT ONLINE WITH PROJECT for Office 365";
		GUID = [guid]"f82a60b8-1ee3-4cfb-a4fe-1c6a53c2656c";
		ServicePlans = @(
			"FORMS_PLAN_E1",
			"PROJECT_CLIENT_SUBSCRIPTION",
			"SHAREPOINT_PROJECT",
			"SHAREPOINTENTERPRISE",
			"SHAREPOINTWAC",
			"SWAY",
		)
	}

	SHAREPOINTSTANDARD = @{
		DisplayName = "SHAREPOINT ONLINE (Plan 1)";
		GUID = [guid]"1fc08a02-8b3d-43b9-831e-f76859e04e1a";
		ServicePlans = @(
			"SHAREPOINTSTANDARD",
		)
	}
	
	SHAREPOINTENTERPRISE = @{
		DisplayName = "SHAREPOINT ONLINE (Plan 2)";
		GUID = [guid]"a9732ec9-17d9-494c-a51c-d6b45b384dcb";
		ServicePlans = @(
			"SHAREPOINTENTERPRISE",
		)
	}
	

	MCOIMP = @{
		DisplayName = "Skype for Business Online (Plan 1)";
		GUID = [guid]"b8b749f8-a4ef-4887-9539-c95b1eaa5db7";
		ServicePlans = @(
			"MCOIMP",
		)
	}
	

	MCOSTANDARD = @{
		DisplayName = "Skype for Business Online (Plan 2)";
		GUID = [guid]"d42c793f-6c78-4f43-92ca-e8f6a02b035f";
		ServicePlans = @(
			"MCOSTANDARD",
		)
	}
	

	MCOPSTN2 = @{
		DisplayName = "SKYPE FOR Business PSTN DOMESTIC AND INTERNATIONAL CALLING";
		GUID = [guid]"d3b4fe1f-9992-4930-8acb-ca6ec609365e";
		ServicePlans = @(
			"MCOPSTN2"
		)
	}
	

	MCOPSTN1 = @{
		DisplayName = "SKYPE FOR Business PSTN DOMESTIC CALLING";
		GUID = [guid]"0dab259f-bf13-4952-b7f8-7db8f131b28d";
		ServicePlans = @(
			"MCOPSTN1"
		)
	}
	

	MCOPSTN5 = @{
		DisplayName = "SKYPE FOR Business PSTN DOMESTIC CALLING (120 Minutes)";
		GUID = [guid]"54a152dc-90de-4996-93d2-bc47e670fc06";
		ServicePlans = @(
			"MCOPSTN5"
		)
	}
	

	VISIOONLINE_PLAN1 = @{
		DisplayName = "VISIO ONLINE PLAN 1";
		GUID = [guid]"4b244418-9658-4451-a2b8-b5e2b364e9bd";
		ServicePlans = @(
			"ONEDRIVE_BASIC",
			"VISIOONLINE",
		)
	}
	

	VISIOCLIENT = @{
		DisplayName = "VISIO Online Plan 2";
		GUID = [guid]"c5928f49-12ba-48f7-ada3-0d743a3601d5";
		ServicePlans = @(
			"ONEDRIVE_BASIC",
			"VISIO_CLIENT_SUBSCRIPTION",
			"VISIOONLINE",
		)
	}
	

	WIN10_PRO_ENT_SUB = @{
		DisplayName = "WINDOWS 10 ENTERPRISE E3";
		GUID = [guid]"cb10e6cd-9da4-4992-867b-67546b1db821";
		ServicePlans = @(
			"WIN10_PRO_ENT_SUB",
		)
	}
	

	WIN10_VDA_E5 = @{
		DisplayName = "Windows 10 Enterprise E5";
		GUID = [guid]"488ba24a-39a9-4473-8ee5-19291e71b002";
		ServicePlans = @(
			"EXCHANGE_S_FOUNDATION",
			"WINDEFATP",
			"Virtualization Rights for Windows 10 (E3/E5+VDA)"
		)
	}






	WINDOWS_STORE = @{
		DisplayName = "Microsoft Store for Business";
		GUID = [guid]"6470687e-a428-4b7a-bef2-8a291ad947c9";
		ServicePlans = @(
			"EXCHANGE_S_FOUNDATION",
			"WINDOWS_STORE"
		);
	};

	PHONESYSTEM_VIRTUALUSER = @{
		DisplayName = "Microsoft 365 Phone System Virtual User";
		GUID = [guid]"";
		ServicePlans = @();
	};

	MCOCAP = @{
		DisplayName = "Common Area Phone";
		GUID = [guid]"";
		ServicePlans = @();
	};

	MEETING_ROOM = @{
		DisplayName = "Meeting Room";
		GUID = [guid]"";
		ServicePlans = @();
	};

	BUSINESS_VOICE_DIRECTROUTING_MED = @{
		DisplayName = "Microsoft 365 Business Voice (without Calling Plan) for US";
		GUID = [guid]"";
		ServicePlans = @();
	};

	TEAMS_EXPLORATORY = @{
		DisplayName = "Teams Exploratory Experience";
		GUID = [guid]"";
		ServicePlans = @();
	};

	RMSBASIC = @{
		DisplayName = "Rights Management Service Basic Content Protection";
		GUID = [guid]"";
		ServicePlans = @();
	};



	BUSINESS_VOICE_MED2 = @{
		DisplayName = "Microsoft 365 Business Voice";
		GUID = [guid]"";
		ServicePlans = @();
	};






} # O365SKUs[]




$O365Services = @{
	AAD_BASIC = @{
		DisplayName = "Azure AD Basic";
		GUID = [guid]"c4da7f8a-5ee2-4c99-a7e1-87d2df57f6fe";
	};

	AAD_PREMIUM = @{
		DisplayName = "Azure AD Premium P1";
		GUID = [guid]"41781fb2-bc02-4b7c-bd55-b576c07bb09d";
	};

	AAD_PREMIUM_P2 = @{
		DisplayName = "Azure AD Premium P2";
		GUID = [guid]"eec0eb4f-6444-4f95-aba0-50c24d67f998";
	};

	MFA_PREMIUM = @{
		DisplayName = "Azure Mulfi-Factor Authentication";
		GUID = [guid]"8a256a2b-b617-496d-b51b-e76466e88db0";
	};

	INTUNE_A = @{
		DisplayName = "Microsoft Intune";
		GUID = [guid]"c1ec4a95-1f05-45b3-a911-aa3fa01094f5";
	};

	MCOMEETADV = @{
		DisplayName = "Audio Conferencing";
		GUID = [guid]"3e26ee1f-8a5f-4d52-aee2-b81ce45c8f40";
	};

	SPZA = @{
		DisplayName = "App Connect";
		GUID = [guid]"0bfc98ed-1dbc-4a97-b246-701754e48b17";
	};

	EXCHANGE_S_FOUNDATION = @{
		DisplayName = "Exchange Foundation";
		GUID = [guid]"113feb6c-3fe4-4440-bddc-54d774bf0318";
	};

	EXCHANGE_S_STANDARD = @{
		DisplayName = "Exchange Online (Plan 1)";
		GUID = [guid]"9aaf7827-d63c-4b61-89c3-182f06f82e5c";
	};

	EXCHANGE_S_ENTERPRISE = @{
		DisplayName = "Exchange Online (Plan 2)";
		GUID = [guid]"efb87545-963c-4e0d-99df-69c6916d9eb0";
	};

	EXCHANGE_S_ESSENTIALS = @{
		DisplayName = "EXCHANGE_S_ESSENTIALS";
		GUID = [guid]"1126bef5-da20-4f07-b45e-ad25d2581aa8";
	};

	EXCHANGE_S_DESKLESS = @{
		DisplayName = "Exchange Online Kiosk";
		GUID = [guid]"4a82b400-a79f-41a4-b4e2-e94f5787b113";
	};

	EXCHANGE_B_STANDARD = @{
		DisplayName = "Exchange Online POP";
		GUID = [guid]"90927877-dcff-4af6-b346-2332c0b15bb7";
	};

	EXCHANGE_S_ARCHIVE_ADDON = @{
		DisplayName = "Exchange Online Archiving for Exchange Online";
		GUID = [guid]"176a09a6-7ec5-4039-ac02-b2791c6ba793";
	};

	EXCHANGE_S_ARCHIVE = @{
		DisplayName = "Exchange Online Archiving for Exchange Server";
		GUID = [guid]"da040e0a-b393-4bea-bb76-928b3fa1cf5a";
	};

	ADALLOM_S_DISCOVERY = @{
		DisplayName = "Cloud App Security Discovery";
		GUID = [guid]"932ad362-64a8-4783-9106-97849a1a30b9";
	};

	ADALLOM_S_STANDALONE = @{
		DisplayName = "Cloud App Security";
		GUID = [guid]"2e2ddb96-6af9-4b1d-a3f0-d6ecfd22edb2";
	};

	RMS_S_ENTERPRISE = @{
		DisplayName = "Azure Rights Management";
		GUID = [guid]"bea4c11e-220a-4e6d-8eb8-8ea15d019f90";
	};

	RMS_S_PREMIUM = @{
		DisplayName = "Azure Information Protection Premium P1";
		GUID = [guid]"6c57d4b6-3b23-47a5-9bc9-69f17b4947b3";
	};

	RMS_S_PREMIUM2 = @{
		DisplayName = "Azure Information Protection Premium P2";
		GUID = [guid]"5689bec4-755d-4753-8b61-40975025187c";
	};

	ATA = @{
		DisplayName = "Azure Advanced Threat Protection";
		GUID = [guid]"14ab5db5-e6c4-4b20-b4bc-13e36fd2227f";
	};

	FORMS_PLAN_E1 = @{
		DisplayName = "Microsoft Forms (Plan E1)";
		GUID = [guid]"159f4cd6-e380-449f-a816-af1a9ef76344";
	};

	OFFICE_BUSINESS = @{
		DisplayName = "Office 365 Business";
		GUID = [guid]"094e7854-93fc-4d55-b2c0-3ab5369ebdc1";
	};

	ONEDRIVESTANDARD = @{
		DisplayName = "ONEDRIVESTANDARD";
		GUID = [guid]"13696edf-5a08-49f6-8134-03083ed8ba30";
	};

	SHAREPOINTWAC = @{
		DisplayName = "Office Online";
		GUID = [guid]"e95bec33-7c88-4a70-8e19-b10bd9d0c014";
	};

	SWAY = @{
		DisplayName = "Sway";
		GUID = [guid]"a23b959c-7ce8-4e57-9140-b90eb88a9e97";
	};

	OFFICESUBSCRIPTION = @{
		DisplayName = "Office 365 ProPlus";
		GUID = [guid]"43de0ff5-c92c-492b-9116-175376d08c38";
	};

	BPOS_S_TODO_1 = @{
		DisplayName = "BPOS_S_TODO_1";
		GUID = [guid]"5e62787c-c316-451f-b873-1d05acd4d12c";
	};

	FLOW_O365_P1 = @{
		DisplayName = "Flow for Office 365";
		GUID = [guid]"0f9b09cb-62d1-4ff4-9129-43f4996f83f4";
	};

	MCOSTANDARD = @{
		DisplayName = "Skype for Business Online (Plan 2)";
		GUID = [guid]"0feaeb32-d00e-4d66-bd5a-43b5b83db82c";
	};

	OFFICEMOBILE_SUBSCRIPTION = @{
		DisplayName = "Microsoft Apps for Mobile";
		GUID = [guid]"c63d4d19-e8cb-460e-b37c-4d6c34603745";
	};

	POWERAPPS_O365_P1 = @{
		DisplayName = "PowerApps for Office 365";
		GUID = [guid]"92f7a6f3-b89b-4bbd-8c30-809e6da5ad1c";
	};

	PROJECTWORKMANAGEMENT = @{
		DisplayName = "Microsoft Planner";
		GUID = [guid]"b737dad2-2f6c-4c65-90e3-ca563267e8b9";
	};

	SHAREPOINTSTANDARD = @{
		DisplayName = "SHAREPOINTSTANDARD";
		GUID = [guid]"c7699d2e-19aa-44de-8edf-1736da088ca1";
	};

	TEAMS1 = @{
		DisplayName = "Microsoft Teams";
		GUID = [guid]"57ff2da0-773e-42df-b2af-ffb7a2317929";
	};

	YAMMER_MIDSIZE = @{
	DisplayName= "YAMMER_MIDSIZE";
		GUID = [guid]"41bf139a-4e60-409f-9346-a1361efc6dfb";
	};

	YAMMER_ENTERPRISE = @{
		DisplayName = "Yammer Enterprise";
		GUID = [guid]"7547a3fe-08ee-4ccb-b430-5077c5041653";
	};

	Deskless = @{
		DisplayName = "Microsoft StaffHub";
		GUID = [guid]"8c7d2df8-86f0-4902-b2ed-a0458298f3b3";
	};

	MICROSOFTBOOKINGS = @{
		DisplayName = "Microsoft Bookings";
		GUID = [guid]"199a5c09-e0ca-4e37-8f7c-b05d533e1ea2";
	};

	O365_SB_Relationship_Management = @{
		DisplayName = "Outlook Customer Manager";
		GUID = [guid]"5bfe124c-bbdc-4494-8835-f1297d457d79";
	};

	AAD_SMB = @{
		DisplayName = "Azure Active Directory";
		GUID = [guid]"de377cbc-0019-4ec2-b77c-3f223947e102";
	};

	INTUNE_SMBIZ = @{
		DisplayName = "Intune_SMBIZ";
		GUID = [guid]"8e9ff0ff-aa7a-4b20-83c1-2f636b600ac2";
	};

	STREAM_O365_E1 = @{
		DisplayName = "Microsoft Stream for O365 E1";
		GUID = [guid]"743dd19e-1ce3-4c62-a3ad-49ba8f63a2f6";
	};

	WINBIZ = @{
		DisplayName = "Windows 10 Business";
		GUID = [guid]"8e229017-d77b-43d5-9305-903395523b99";
	};

	WHITEBOARD_PLAN3 = @{
		DisplayName = "Whiteboard (Plan 3)";
		GUID = [guid]"4a51bca5-1eff-43f5-878c-177680f191af";
	};

	WIN10_PRO_ENT_SUB = @{
		DisplayName = "Windows 10 Enterprise (Original)";
		GUID = [guid]"21b439ba-a0ca-424f-a6cc-52f954a5b111";
	};






	ADALLOM_S_O365 = @{ 
		DisplayName = "Office 365 Cloud App Security";
		GUID = [guid]"8c098270-9dd4-4350-9b30-ba4703f3b36b";
	};

	ADALLOM_S_DISCOVERY = @{ 
		DisplayName = "Office 365 Cloud App Discovery";
		GUID = [guid]"932ad362-64a8-4783-9106-97849a1a30b9";
	};

	ATP_ENTERPRISE = @{ 
		DisplayName = "Office 365 Advanced Threat Protection (Plan 1)";
		GUID = [guid]"f20fedf3-f3c3-43c3-8267-2bfdd51c0939";
	};

	BI_AZURE_P0 = @{ 
		DisplayName = "PowerBI (Free)";
		GUID = [guid]"2049e525-b859-401b-b2a0-e0a31c4b1fe4";
	};

	BI_AZURE_P1 = @{ 
		DisplayName = "Microsoft PowerBI Reporting and Analytics (Plan 1)";
		GUID = [guid]"2125cfd7-2110-4567-83c4-c1cd5275163d";
	};

	BI_AZURE_P2 = @{ 
		DisplayName = "PowerBI Pro";
		GUID = [guid]"70d33638-9c74-4d01-bfd3-562de28bd4ba";
	};

	BPOS_S_TODO_2 = @{ 
		DisplayName = "To-Do (Plan 2)";
		GUID = [guid]"c87f142c-d1e9-4363-8630-aaea9c4d9ae5";
	};

	BPOS_S_TODO_3 = @{ 
		DisplayName = "To-Do (Plan 3)";
		GUID = [guid]"3fb82609-8c27-4f7b-bd51-30634711ee67";
	};

	BPOS_S_TODO_FIRSTLINE = @{ 
		DisplayName = "To-Do (Firstline)";
		GUID = [guid]"80873e7a-cd2a-4e67-b061-1b5381a676a5";
	};

	CDS_O365_F1 = @{ 
		DisplayName = "Common Data Service for Teams F1";
		GUID = [guid]"90db65a7-bf11-4904-a79f-ef657605145b";
	};

	CRMPLAN2 = @{ 
		DisplayName = "Microsoft Dynamics CRM Online Basic";
		GUID = [guid]"bf36ca64-95c6-4918-9275-eb9f4ce2c04f";
	};

	DDYN365_CDS_DYN_P2 = @{ 
		DisplayName = "Common data Service";
		GUID = [guid]"d1142cfd-872e-4e77-b6ff-d98ec5a51f66";
	};

	DYN365_CDS_O365_F1 = @{ 
		DisplayName = "Common Data Service for Office 365 F1";
		GUID = [guid]"ca6e61ec-d4f4-41eb-8b88-d96e0e14323f";
	};

	DYN365_ENTERPRISE_CUSTOMER_SERVICE = @{ 
		DisplayName = "Dynamics 365 for Customer Service";
		GUID = [guid]"99340b49-fb81-4b1e-976b-8f2ae8e9394f";
	};

	DYN365_ENTERPRISE_P1 = @{ 
		DisplayName = "Dynamics 365 Customer Engagement Plan";
		GUID = [guid]"d56f3deb-50d8-465a-bedb-f079817ccac1";
	};

	DYN365_ENTERPRISE_SALES = @{ 
		DisplayName = "Dynamics 365 for Sales";
		GUID = [guid]"2da8e897-7791-486b-b08f-cc63c8129df7";
	};

	DYN365_ENTERPRISE_TEAM_MEMBERS = @{ 
		DisplayName = "Dynamics 365: Team Member";
		GUID = [guid]"6a54b05e-4fab-40e7-9828-428db3b336fa";
	};

	DYN365_Enterprise_Talent_Attract_TeamMember = @{ 
		DisplayName = "Dynamics 365 for Talent: Attract Experience";
		GUID = [guid]"643d201a-9884-45be-962a-06ba97062e5e";
	};

	DYN365_Enterprise_Talent_Onboard_TeamMember = @{ 
		DisplayName = "Dynamics 365 for Talent: Onboard Experience";
		GUID = [guid]"f2f49eef-4b3f-4853-809a-a055c6103fe0";
	};

	DYN365_FINANCIALS_BUSINESS = @{ 
		DisplayName = "Dynamics 365 for Financials";
		GUID = [guid]"920656a2-7dd8-4c83-97b6-a356414dbd36";
	};

	DYN365_TALENT_ENTERPRISE = @{ 
		DisplayName = "Dynamics 365 for Talent";
		GUID = [guid]"65a1ebf4-6732-4f00-9dcb-3d115ffdeecd";
	};

	Dynamics_365_Hiring_Free_PLAN = @{ 
		DisplayName = "Dynamics 365 for Talent: Attract Experience (Free)";
		GUID = [guid]"f815ac79-c5dd-4bcc-9b78-d97f7b817d0d";
	};

	Dynamics_365_Onboarding_Free_PLAN = @{ 
		DisplayName = "Dynamics for Talent: Onboard Experience (Free)";
		GUID = [guid]"300b8114-8555-4313-b861-0c115d820f50";
	};

	Dynamics_365_for_Operations = @{ 
		DisplayName = "Dynamics 365 for Operations";
		GUID = [guid]"95d2cd7b-1007-484b-8595-5e97e63fe189";
	};

	Dynamics_365_for_Operations_Team_members = @{ 
		DisplayName = "Dynamics 365 for Operations: Team Member";
		GUID = [guid]"f5aa7b45-8a36-4cd1-bc37-5d06dea98645";
	};

	Dynamics_365_for_Retail = @{ 
		DisplayName = "Dynamics 365 for Retail";
		GUID = [guid]"a9e39199-8369-444b-89c1-5fe65ec45665";
	};

	Dynamics_365_for_Retail_Team_members = @{ 
		DisplayName = "Dynamics 365 for Retail: Team Member";
		GUID = [guid]"c0454a3d-32b5-4740-b090-78c32f48f0ad";
	};

	Dynamics_365_for_Talent_Team_members = @{ 
		DisplayName = "Dynamics for Talent: Team Member";
		GUID = [guid]"d5156635-0704-4f66-8803-93258f8b2678";
	};

	EQUIVIO_ANALYTICS = @{ 
		DisplayName = "Office 365 Advanced eDiscovery";
		GUID = [guid]"4de31727-a228-4ec3-a5bf-8e45b5ca48cc";
	};

	EXCHANGE_ANALYTICS = @{ 
		DisplayName = "Microsoft MyAnalytics (Full)";
		GUID = [guid]"34c0d7a0-a70f-4668-9238-47f9fc208882";
	};

	EXCHANGE_L_STANDARD = @{ 
		DisplayName = "Exchange Online (P1)";
		GUID = [guid]"d42bdbd6-c335-4231-ab3d-c8f348d5aff5";
	};

	EXCHANGE_S_STANDARD_MIDMARKET = @{ 
		DisplayName = "Exchange Online Plan 1";
		GUID = [guid]"fc52cc4b-ed7d-472d-bbe7-b081c23ecc56";
	};

	FLOW_DYN_APPS = @{ 
		DisplayName = "";
		GUID = [guid]"7e6d7d78-73de-46ba-83b1-6d25117334ba";
	};

	FLOW_DYN_P2 = @{ 
		DisplayName = "Flow for Dynamics 365";
		GUID = [guid]"b650d915-9886-424b-a08d-633cede56f57";
	};

	FLOW_DYN_TEAM = @{ 
		DisplayName = "Flow for Dynamics 365";
		GUID = [guid]"1ec58c70-f69c-486a-8109-4b87ce86e449";
	};

	FLOW_O365_P2 = @{ 
		DisplayName = "Flow for Office 365";
		GUID = [guid]"76846ad7-7776-4c40-a281-a386362dd1b9";
	};

	FLOW_O365_P3 = @{ 
		DisplayName = "Flow for Office 365";
		GUID = [guid]"07699545-9485-468e-95b6-2fca3738be01";
	};

	FLOW_O365_S1 = @{ 
		DisplayName = "Flow for Office 365 K1";
		GUID = [guid]"bd91b1a4-9f94-4ecf-b45b-3a65e5c8128a";
	};

	FORMS_PLAN_E3 = @{ 
		DisplayName = "Microsoft Forms (Plan E3)";
		GUID = [guid]"2789c901-c14e-48ab-a76a-be334d9d793a";
	};

	FORMS_PLAN_E5 = @{ 
		DisplayName = "Microsoft forms (Plan E5)";
		GUID = [guid]"e212cbc7-0961-4c40-9825-01117710dcb1";
	};

	FORMS_PLAN_K = @{ 
		DisplayName = "Microsoft Forms (Plan F1)";
		GUID = [guid]"f07046bd-2a3c-4b96-b0be-dea79d7cbfb8";
	};

	INFORMATION_BARRIERS = @{ 
		DisplayName = "Information Barriers";
		GUID = [guid]"c4801e8a-cb58-4c35-aca6-f2dcc106f287";
	};

	INTUNE_O365 = @{ 
		DisplayName = "Mobile Device Management for Office 365";
		GUID = [guid]"882e1d05-acd1-4ccb-8708-6ee03664b117";
	};

	IT_ACADEMY_AD = @{ 
		DisplayName = "Microsoft Imagine Academy";
		GUID = [guid]"d736def0-1fde-43f0-a5be-e3f8b2de6e41";
	};

	KAIZALA_O365_P1 = @{ 
		DisplayName = "Microsoft Kaizala Pro Plan 1";
		GUID = [guid]"73b2a583-6a59-42e3-8e83-54db46bc3278";
	};

	KAIZALA_STANDALONE = @{ 
		DisplayName = "Microsoft Kaizala";
		GUID = [guid]"0898bdbb-73b0-471a-81e5-20f1fe4dd66e";
	};

	LOCKBOX_ENTERPRISE = @{ 
		DisplayName = "Customer Lockbox";
		GUID = [guid]"9f431833-0334-42de-a7dc-70aa40db46db";
	};

	MCOEV = @{ 
		DisplayName = "Microsoft 365 Phone System";
		GUID = [guid]"4828c8ec-dc2e-4779-b502-87ac9ce28ab7";
	};

	MCOEVSMB = @{ 
		DisplayName = "SKYPE FOR BUSINESS CLOUD PBX FOR SMALL AND MEDIUM BUSINESS";
		GUID = [guid]"ed777b71-af04-42ca-9798-84344c66f7c6";
	};

	MCOFREE = @{ 
		DisplayName = "MCO FREE FOR MICROSOFT TEAMS (FREE)";
		GUID = [guid]"617d9209-3b90-4879-96e6-838c42b2701d";
	};

	MCOIMP = @{ 
		DisplayName = "Skype for Business Online (Plan 1)";
		GUID = [guid]"afc06cb0-b4f4-4473-8286-d644f70d8faf";
	};

	MCOLITE = @{ 
		DisplayName = "SKYPE FOR BUSINESS ONLINE (PLAN P1)";
		GUID = [guid]"70710b6b-3ab4-4a38-9f6d-9f169461650a";
	};

	MCOPSTN1 = @{ 
		DisplayName = "Domestic Calling Plan";
		GUID = [guid]"4ed3ff63-69d7-4fb7-b984-5aec7f605ca8";
	};

	MCOPSTN2 = @{ 
		DisplayName = "Domestic and International Calling Plan";
		GUID = [guid]"5a10155d-f5c1-411a-a8ec-e99aae125390";
	};

	MCOPSTN5 = @{ 
		DisplayName = "Domestic Calling Plan";
		GUID = [guid]"54a152dc-90de-4996-93d2-bc47e670fc06";
	};

	MCOSTANDARD_MIDMARKET = @{ 
		DisplayName = "SKYPE FOR BUSINESS ONLINE (PLAN 2) FOR MIDSIZE";
		GUID = [guid]"b2669e95-76ef-4e7e-a367-002f60a39f3e";
	};

	MCOVOICECONF = @{ 
		DisplayName = "SKYPE FOR BUSINESS ONLINE (PLAN 3)";
		GUID = [guid]"27216c54-caf8-4d0d-97e2-517afb5c08f6";
	};

	MDM_SALES_COLLABORATION = @{ 
		DisplayName = "MICROSOFT DYNAMICS MARKETING SALES COLLABORATION";
		GUID = [guid]"3413916e-ee66-4071-be30-6f94d4adfeda";
	};

	MFA_PREMIUM = @{ 
		DisplayName = "Microsoft Azure Multi-Factor Authentication";
		GUID = [guid]"8a256a2b-b617-496d-b51b-e76466e88db0";
	};

	MICROSOFT_SEARCH = @{ 
		DisplayName = "Microsoft Search";
		GUID = [guid]"94065c59-bc8e-4e8b-89e5-5138d471eaff";
	};

	MIP_S_CLP1 = @{ 
		DisplayName = "Information Protection for Office 365 - Standard";
		GUID = [guid]"5136a095-5cf0-4aff-bec3-e84448b38ea5";
	};

	MIP_S_CLP2 = @{ 
		DisplayName = "Information Protection for Office 365 - Premium";
		GUID = [guid]"efb0351d-3b08-4503-993d-383af8de41e3";
	};

	MYANALYTICS_P2 = @{ 
		DisplayName = "Insights by MyAnalytics";
		GUID = [guid]"33c4f319-9bdd-48d6-9c4d-410b750a4a5a";
	};

	NBENTERPRISE = @{ 
		DisplayName = "Microsoft Social Engagement";
		GUID = [guid]"03acaee3-9492-4f40-aed4-bcb6b32981b6";
	};

	NBPROFESSIONALFORCRM = @{ 
		DisplayName = "MICROSOFT SOCIAL ENGAGEMENT PROFESSIONAL";
		GUID = [guid]"3e58e97c-9abe-ebab-cd5f-d543d1529634";
	};

	OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ = @{ 
		DisplayName = "OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ";
		GUID = [guid]"8ca59559-e2ca-470b-b7dd-afd8c0dee963";
	};

	ONEDRIVEENTERPRISE = @{ 
		DisplayName = "OneDrive for Business (Plan 2)";
		GUID = [guid]"afcafa6a-d966-4462-918c-ec0b4e0fe642";
	};

	ONEDRIVE_BASIC = @{ 
		DisplayName = "ONEDRIVE_BASIC";
		GUID = [guid]"da792a53-cbc0-4184-a10d-e544dd34b3c1";
	};

	PAM_ENTERPRISE = @{ 
		DisplayName = "Office 365 Privileged Access Management";
		GUID = [guid]"b1188c4c-1b36-4018-b48b-ee07604f6feb";
	};

	POWERAPPS_DYN_APPS = @{ 
		DisplayName = "PowerApps for Dynamics 365";
		GUID = [guid]"874fc546-6efe-4d22-90b8-5c4e7aa59f4b";
	};

	POWERAPPS_DYN_P2 = @{ 
		DisplayName = "PowerApps for Dynamics 365";
		GUID = [guid]"0b03f40b-c404-40c3-8651-2aceb74365fa";
	};

	POWERAPPS_DYN_TEAM = @{ 
		DisplayName = "PowerApps for Dynamics 365";
		GUID = [guid]"52e619e2-2730-439a-b0d3-d09ab7e8b705";
	};

	POWERAPPS_O365_P1 = @{ 
		DisplayName = "PowerApps for Office 365";
		GUID = [guid]"92f7a6f3-b89b-4bbd-8c30-809e6da5ad1c";
	};

	POWERAPPS_O365_P2 = @{ 
		DisplayName = "PowerApps for Office 365";
		GUID = [guid]"c68f8d98-5534-41c8-bf36-22fa496fa792";
	};

	POWERAPPS_O365_P3 = @{ 
		DisplayName = "Powerapps for Office 365";
		GUID = [guid]"9c0dab89-a30c-4117-86e7-97bda240acd2";
	};

	POWERAPPS_O365_S1 = @{ 
		DisplayName = "PowerApps for Office 365 K1";
		GUID = [guid]"e0287f9f-e222-4f98-9a83-f379e249159a";
	};

	POWER_VIRTUAL_AGENTS_O365_F1 = @{ 
		DisplayName = "Power Virtual Agents for Office 365";
		GUID = [guid]"ba2fdb48-290b-4632-b46a-e4ecc58ac11a";
	};

	PREMIUM_ENCRYPTION = @{ 
		DisplayName = "Premium Encryption in Office 365";
		GUID = [guid]"617b097b-4b93-4ede-83de-5f075bb5fb2f";
	};

	PROJECT_CLIENT_SUBSCRIPTION = @{ 
		DisplayName = "Project Online Desktop client";
		GUID = [guid]"fafd7243-e5c1-4a3a-9e40-495efcb1d3c3";
	};

	PROJECT_ESSENTIALS = @{ 
		DisplayName = "Project Online Essentials";
		GUID = [guid]"1259157c-8581-4875-bca7-2ffb18c51bda";
	};

	PROJECT_O365_F3 = @{ 
		DisplayName = "Project for Office (Plan F)";
		GUID = [guid]"7f6f28c2-34bb-4d4b-be36-48ca2e77e1ec";
	};

	CRMSTANDARD = @{ 
		DisplayName = "Microsoft Dynamics CRM Online Professional";
		GUID = [guid]"f9646fb2-e3b2-4309-95de-dc4833737456";
	};

	RMS_S_BASIC = @{ 
		DisplayName = "Microsoft Azure Rights Management Service";
		GUID = [guid]"31cf2cfc-6b0d-4adc-a336-88b724ed8122";
	};

	SHAREPOINTDESKLESS = @{ 
		DisplayName = "SharePoint Kiosk";
		GUID = [guid]"902b47e5-dcb2-4fdc-858b-c63a90a2bdb9";
	};

	SHAREPOINTENTERPRISE = @{ 
		DisplayName = "SharePoint Online (Plan 2)";
		GUID = [guid]"5dbe027f-2339-4123-9542-606e4d348a72";
	};

	SHAREPOINTENTERPRISE_MIDMARKET = @{ 
		DisplayName = "SHAREPOINTENTERPRISE_MIDMARKET";
		GUID = [guid]"6b5b6a67-fc72-4a1f-a2b5-beecf05de761";
	};

	SHAREPOINTLITE = @{ 
		DisplayName = "SHAREPOINTLITE";
		GUID = [guid]"a1f3d0a8-84c0-4ae0-bae4-685917b8ab48";
	};

	SHAREPOINTWAC_DEVELOPER = @{ 
		DisplayName = "Office Online: Developer";
		GUID = [guid]"527f7cdd-0e86-4c47-b879-f5fd357a3ac6";
	};

	SHAREPOINT_PROJECT = @{ 
		DisplayName = "Project Online Service";
		GUID = [guid]"fe71d6c3-a2ea-4499-9778-da042bf08063";
	};

	SHAREPOINT_S_DEVELOPER = @{ 
		DisplayName = "SharePoint Online: Developer";
		GUID = [guid]"a361d6e2-509e-4e25-a8ad-950060064ef4";
	};

	SQL_IS_SSIM = @{ 
		DisplayName = "Microsoft PowerBI Information Services (Plan 1)";
		GUID = [guid]"fc0a60aa-feee-4746-a0e3-aecfe81a38dd";
	};

	STREAM_O365_E3 = @{ 
		DisplayName = "Microsoft Stream for Office 365 E3";
		GUID = [guid]"9e700747-8b1d-45e5-ab8d-ef187ceec156";
	};

	STREAM_O365_E5 = @{ 
		DisplayName = "Microsoft Stream for O365 E5";
		GUID = [guid]"6c6042f5-6f01-4d67-b8c1-eb99d36eed3e";
	};

	STREAM_O365_K = @{ 
		DisplayName = "Microsoft Stream for O365 K";
		GUID = [guid]"3ffba0d2-38e5-4d5e-8ec0-98f2b05c09d9";
	};

	TEAMS_FREE = @{ 
		DisplayName = "Microsoft Teams (Free)";
		GUID = [guid]"4fa4026d-ce74-4962-a151-8e96d57ea8e4";
	};

	TEAMS_FREE_SERVICE = @{ 
		DisplayName = "Microsoft Teams (Free) Service";
		GUID = [guid]"bd6f2ac2-991a-49f9-b23c-18c96a02c228";
	};

	THREAT_INTELLIGENCE = @{ 
		DisplayName = "Office 365 Advanced Threat Protection (Plan 2)";
		GUID = [guid]"8e0c0a52-6a6c-4d40-8370-dd62790dcd70";
	};

	VISIOONLINE = @{ 
		DisplayName = "Visio Online";
		GUID = [guid]"2bdbaf8f-738f-4ac7-9234-3c3ee2ce7d0f";
	};

	VISIO_CLIENT_SUBSCRIPTION = @{ 
		DisplayName = "VISIO_CLIENT_SUBSCRIPTION";
		GUID = [guid]"663a804f-1c30-4ff0-9915-9db84f0d1cea";
	};

	"Virtualization Rights for Windows 10 (E3/E5+VDA)" = @{ 
		DisplayName = "";
		GUID = [guid]"e7c91390-7625-45be-94e0-e16907e03118";
	};

	WHITEBOARD_FIRSTLINE1 = @{ 
		DisplayName = "Whiteboard (Firstline)";
		GUID = [guid]"36b29273-c6d0-477a-aca6-6fbe24f538e3";
	};

	WIN10_ENT_LOC_F1 = @{ 
		DisplayName = "Windows 10 Enterprise E3 (local only)";
		GUID = [guid]"e041597c-9c7f-4ed9-99b0-2663301576f7";
	};

	WINDEFATP = @{ 
		DisplayName = "Microsoft Defender Advanced Threat Protection";
		GUID = [guid]"871d91ec-ec1a-452b-a83f-bd76c7d770ef";
	};

	WINDOWS_STORE = @{ 
		DisplayName = "Windows Store Service";
		GUID = [guid]"a420f25f-a7b3-4ff5-a9d0-5d58f73b537d";
	};




} # O365Services[]


#see https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference#service-plans-that-cannot-be-assigned-at-the-same-time
$O365Conflicts = @(
	@{
		DisplayName = "Dynamics CRM";
		ServicePlans = @(
			CRMPLAN1	119cf168-b6cf-41fb-b82e-7fee7bae5814
			CRMPLAN2	bf36ca64-95c6-4918-9275-eb9f4ce2c04f
			CRMSTANDARD	f9646fb2-e3b2-4309-95de-dc4833737456
			DYN365_ENTERPRISE_CUSTOMER_SERVICE	99340b49-fb81-4b1e-976b-8f2ae8e9394f
			DYN365_ENTERPRISE_P1	d56f3deb-50d8-465a-bedb-f079817ccac1
			DYN365_ENTERPRISE_P1_IW	056a5f80-b4e0-4983-a8be-7ad254a113c9
			DYN365_ENTERPRISE_SALES	2da8e897-7791-486b-b08f-cc63c8129df7
			DYN365_ENTERPRISE_TEAM_MEMBERS	6a54b05e-4fab-40e7-9828-428db3b336fa
			EMPLOYEE_SELF_SERVICE	ba5f0cfa-d54a-4ea0-8cf4-a7e1dc4423d8
		);
	},
	@{
		DisplayName = "Exchange Online";
		ServicePlans = @(
			EXCHANGE_B_STANDARD	90927877-dcff-4af6-b346-2332c0b15bb7
			EXCHANGE_L_STANDARD	d42bdbd6-c335-4231-ab3d-c8f348d5aff5
			EXCHANGE_S_ARCHIVE	da040e0a-b393-4bea-bb76-928b3fa1cf5a
			EXCHANGE_S_DESKLESS	4a82b400-a79f-41a4-b4e2-e94f5787b113
			EXCHANGE_S_ENTERPRISE	efb87545-963c-4e0d-99df-69c6916d9eb0
			EXCHANGE_S_ESSENTIALS	1126bef5-da20-4f07-b45e-ad25d2581aa8
			EXCHANGE_S_STANDARD	9aaf7827-d63c-4b61-89c3-182f06f82e5c
			EXCHANGE_S_STANDARD_MIDMARKET	fc52cc4b-ed7d-472d-bbe7-b081c23ecc56
		)
	},
	@{
		DisplayName = "Microsoft 365";
		ServicePlans = @(
			RMS_S_ENTERPRISE	bea4c11e-220a-4e6d-8eb8-8ea15d019f90
			RMS_S_ENTERPRISE_GOV	6a76346d-5d6e-4051-9fe3-ed3f312b5597
		)
	},
	@{
		DisplayName = "Intune";
		ServicePlans = @(
			INTUNE_A	c1ec4a95-1f05-45b3-a911-aa3fa01094f5
			INTUNE_A_VL	3e170737-c728-4eae-bbb9-3f3360f7184c
			INTUNE_B	2dc63b8a-df3d-448f-b683-8655877c9360
		)
	},
	@{
		DisplayName = "SharePoint Online";
		ServicePlans = @(
			ONEDRIVEENTERPRISE	afcafa6a-d966-4462-918c-ec0b4e0fe642
			SHAREPOINT_S_DEVELOPER	a361d6e2-509e-4e25-a8ad-950060064ef4
			SHAREPOINTDESKLESS	902b47e5-dcb2-4fdc-858b-c63a90a2bdb9
			SHAREPOINTENTERPRISE	5dbe027f-2339-4123-9542-606e4d348a72
			SHAREPOINTENTERPRISE_EDU	63038b2c-28d0-45f6-bc36-33062963b498
			SHAREPOINTENTERPRISE_MIDMARKET	6b5b6a67-fc72-4a1f-a2b5-beecf05de761
			SHAREPOINTLITE	a1f3d0a8-84c0-4ae0-bae4-685917b8ab48
			SHAREPOINTSTANDARD	c7699d2e-19aa-44de-8edf-1736da088ca1
			SHAREPOINTSTANDARD_EDU	0a4983bb-d3e5-4a09-95d8-b2d0127b3df5
			SHAREPOINTSTANDARD_YAMMERSHADOW	4c9efd0c-8de7-4c71-8295-9f5fdb0dd048
		)
	},
	@{
		DisplayName = "Skype for Business";
		ServicePlans = @(
			MCOIMP	afc06cb0-b4f4-4473-8286-d644f70d8faf
			MCOSTANDARD_MIDMARKET	b2669e95-76ef-4e7e-a367-002f60a39f3e
			MCOSTANDARD	0feaeb32-d00e-4d66-bd5a-43b5b83db82c
			MCOLITE	70710b6b-3ab4-4a38-9f6d-9f169461650a
		)
	},
	@{
		DisplayName = "Skype for Business: Calling Plan";
		ServicePlans = @(
			MCOPSTN1	4ed3ff63-69d7-4fb7-b984-5aec7f605ca8
			MCOPSTN2	5a10155d-f5c1-411a-a8ec-e99aae125390
			MCOPSTN5	54a152dc-90de-4996-93d2-bc47e670fc06
		)
	},
	@{
		DisplayName = "Yammer";
		ServicePlans = @(
			YAMMER_ENTERPRISE	7547a3fe-08ee-4ccb-b430-5077c5041653
			YAMMER_EDU	2078e8df-cff6-4290-98cb-5408261a760a
			YAMMER_MIDSIZE	41bf139a-4e60-409f-9346-a1361efc6dfb
		)
	}
		
		
)



$mySKUs = Get-MsolAccountSku #-TenantId


$O365SKUs.Keys | % { "$_ is $($O365SKUs.$_)" }
$O365SKUs.GetEnumerator() | % { "$($_.key) is $($_.value.DisplayName)" }

$O365SKUs.Keys | Get-ADGroup




#create service plan dynamic groups and set "mailNickname" to the short-name.
