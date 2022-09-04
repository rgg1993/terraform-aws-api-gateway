
# Deploying an active-active api gateway

This repository contains the modules used to deploy an active active apigateway. 
The modules are complemented with a sample main and tfvars, so you can have a general idea about how to use them. 
The modules were created for each resource in order to independize different related resources. For readability, the modules variables were named following the attributes' names. 



## How to use this repository
This repository has all the terraform code need to deploy a apigateway resources and their corresponding DNS records. 
We have used terraform version 0.14.0 when deploying the resources with Terraform, and most modules include that as requisite. 

The main.tf is organized in the following structure: 
- Terraform requirements: version, backend and providers needed
- Data needed to be retrieved
- Modules 

Note that this code assumes you already have deployed application load balancers to associate with the apigateway (main.tf, Data section). 
In this data we retrieve the application load balancer information that will enable us to get their security groups and subnet ids so we can link them to the apigateway. Otherwise, the apigateway won't have access to them.

The variables were put in a tfvars, and you will need to have two tfvars: one for one region and another one for the other region (eg: us-east-1 and us-east-2, remember this is an active active apigateway deployment). 
This is the reason why the hosted zone were all these resources were deployed was created manually from the console. 
In case you'd like to add the hosted zone from terraform, we have added the module for you to use. 

### Resources
Our main.tf will deploy these resources:
- apigateway
- apigateway vpc link 
- apigateway account
- apigateway stage
- apigateway integration
- apigateway authorizer
- apigateway route
- apigateway domain name
- apigateway mapping
- apigateway deployment
- iam roles
- iam policies
- iam policy attachmentes
- cloudwatch log group
- waf ip sets 
- waf web acl
- waf web acl associations
- waf rule group
- s3 bucket
- s3 bucket logging
- s3 bucket versioning
- s3 bucket acl
- s3 bucket public access block
- kineses firehose delivery stream
- waf web acl logging configuration
- route 54 record

As you can see, the code has been organized by sections. 
First, all resources related to the apigateway are declared (api, vpc links, etc) and their auxiliary resources such as roles, policies and log groups.
Second, we have all resources belonging to the web application firewall. Though you could not deploy them, it's an additional security layer and it's highly recommended. We have added only one rule group as reference which filters by ips, but you could add and remote rules groups at your will. This was has been configured to send its logging to an firehose data stream and save its logs into an s3 bucket, that's why these resources are included into this section.
Third and last, the main.tf also has the modules to create the dns records. These dns records were added at the very end, since they depend on the apigateway configuration being ready. Otherwise, the dns won't be able to resolve the api endpoint. 

### tfvars 
The tfvars were organized as maps, since we understood this gave us better flexibility.


## Acknowledgements
This solution was developed by Ivan Fernandez, my only participation was to write the modules to deploy it while struggling to understand how all pieces fitted together under his guidance. 
You can follow Ivan on [Linkedin](https://www.linkedin.com/in/ivanferb?miniProfileUrn=urn%3Ali%3Afs_miniProfile%3AACoAAA9buSIBllgcvnAXktSbJJ96--ECOmykhd8&lipi=urn%3Ali%3Apage%3Ad_flagship3_search_srp_all%3BzrVmI26AT0mqMrcC0CYwVw%3D%3D)
