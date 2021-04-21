@{
	AllNodes = 
	@(
		@{
			NodeName = "*" # not a wildcard; hard-coded "all nodes"
			
			Role		= "ADDS"
		},
		@{
			NodeName	= "MAKMD"
            DNSName = "AlbertMakMD.net"
            Description = "Albert C. Mak, M.D."
			#DistinguishedName = "DC="+ ($DNSName -join ",DC=") #"DC=AlbertMakMD,DC=net"
			#DomainDNSName = $DNSName -join "." #"AlbertMakMD.net"
			
		},
		@{
            NodeName    = "NMA"
            DNSName = "theNeuroAssociates.net"
            Description = "Neurological Managing Association"
		},
		@{
            NodeName    = "NAOWLA"
            DNSName = "naowla.com"
            Description = "Neurological Associates of West Los Angeles"
		},
		@{
            NodeName    = "SBCC"
            DNSName = "theSouthBayCancerCenter.com"
            Description = "South Bay Cancer Center"
		},
		@{
            NodeName    = "SERRA"
            DNSName = "SerraMedicalClinic.net"
            Description = "Serra Community Medical Clinic"
		},
		@{
            NodeName    = "TOWER"
            DNSName = "towerimaging.net"
            Description = "Tower Imaging Medical Group"
		}
	);
	ProgramData = 
	@{
		ResilioJSON = ""
	};
}
