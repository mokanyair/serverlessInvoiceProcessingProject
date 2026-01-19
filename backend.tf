terraform { 
  cloud { 
    
    organization = "Enterpriseair-Datacenter" 

    workspaces { 
      name = "resources_1" 
    } 
  } 
}