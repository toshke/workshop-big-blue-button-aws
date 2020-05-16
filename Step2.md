
## Deployment of BigBlueButton server on AWS

CloudFormation is AWS service used to describe infrastructure elements as a code 
(a set of yaml or json configuration files). This allows for automated
and repeatable provisioning process of the 

In this step we will use CloudFormation templates from [big-blue-button-cloudformation-cfhl](https://github.com/toshke/big-blue-button-cloudformation-cfhl)
repository to create the required infrastructure to run the software using Amazon Web Services platform.


Before proceeding further, make sure that you are logged in [AWS Web Console](https://console.aws.amazon.com/)


#### Start stack creation 

Choose your closest region below, and click on appropriate link to initiate CloudFormation stack. 

| Region        |Region name    |   Launch url  |
| ------------- |:-------------:|:-------------:|
| `ap-southeast-2` | Asia Pacific (Sydney) | <a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ap-southeast-2.amazonaws.com/templates-ap-southeast-2.cfhighlander.info/templates/bbb/1589275224/bbb.compiled.yaml"><img src="https://raw.githubusercontent.com/toshke/big-blue-button-cloudformation-cfhl/fec34f65f91ef984f95945a2e6e285c6b54f9992/launch-stack.svg" /></a>  |
| `us-east-1` | US East (N. Virginia) | <a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-east-1.amazonaws.com/templates-us-east-1.cfhighlander.info/templates/bbb/1589275224/bbb.compiled.yaml"><img src="https://raw.githubusercontent.com/toshke/big-blue-button-cloudformation-cfhl/fec34f65f91ef984f95945a2e6e285c6b54f9992/launch-stack.svg" /></a>  |
| `eu-central-1` | EU (Frankfurt) | <a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.eu-central-1.amazonaws.com/templates-eu-central-1.cfhighlander.info/templates/bbb/1589275224/bbb.compiled.yaml"><img src="https://raw.githubusercontent.com/toshke/big-blue-button-cloudformation-cfhl/fec34f65f91ef984f95945a2e6e285c6b54f9992/launch-stack.svg" /></a>  |
| `us-west-2` | US West (Oregon) | <a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/new?stackName=big-blue-button&templateURL=https://s3.us-west-2.amazonaws.com/templates-us-west-2.cfhighlander.info/templates/bbb/1589275224/bbb.compiled.yaml"><img src="https://raw.githubusercontent.com/toshke/big-blue-button-cloudformation-cfhl/fec34f65f91ef984f95945a2e6e285c6b54f9992/launch-stack.svg" /></a>  |
| `ca-central-1` | Canada (Central) | <a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?region=ca-central-1#/stacks/new?stackName=big-blue-button&templateURL=https://s3.ca-central-1.amazonaws.com/templates-ca-central-1.cfhighlander.info/templates/bbb/1589275224/bbb.compiled.yaml"><img src="https://raw.githubusercontent.com/toshke/big-blue-button-cloudformation-cfhl/fec34f65f91ef984f95945a2e6e285c6b54f9992/launch-stack.svg" /></a>  |

*If you can't find your desired region below, you can check <a target="_blank" href="https://github.com/toshke/big-blue-button-cloudformation-cfhl"> templates origin page</a>*

You will be taken to a page to input desired parameters to your CloudFormation stack, 
where you'll use your hosted zone created in previous stack, as in the screenshot below

![Screen Shot 2020-05-15 at 6 55 06 pm](https://user-images.githubusercontent.com/1170273/82031980-f58fc400-96dd-11ea-86e4-7580aebc4d7f.png)


You can leave most of the default values untouched - you'll need to supply values for following  

- **AdminEmail** - used for SSL certificate domain verification, as well as default login
                to big blue button web portal (Greenlight)
                
- **DomainName** - zoneName generated for you in previous step. If you are using your own domain/Route53 zone, 
you probably want to set this to something like `online.example.com`

- **Route53Zone** - same like previous parameter. If you are using your own zone, should be like `example.com` 
   If you followed through the step1, just same the full zone name `workshop-XXXX.programming-tools-meetup.cloud`
   you obtained in previous step. 
   
- **TerminationProtection** - set this to False, for easier cleanup of resources after the workshop. 

           
Click 'Next' buttons, until you reach checkboxes *I acknowledge that AWS CloudFormation might create IAM resources with custom names*
and *I acknowledge that AWS CloudFormation might require the following capability: CAPABILITY_AUTO_EXPAND*

Check them to give permissions to CloudFormation service to create IAM (Identity Access Management) resources
on your behalf.  

![Screen Shot 2020-05-15 at 7 11 50 pm](https://user-images.githubusercontent.com/1170273/82033499-283abc00-96e0-11ea-9a24-acbe6e7e74b5.png)

Clicking "Create Stack" button will initiate infrastructure provisioning process on AWS infrastructure for you. 



#### Login to your BBB server using AWS SSM Service

Shortly after stack creation has started you should be able to see EC2 instance (virtual server in simpler terms)
in your [EC2 Web Console](https://ap-southeast-2.console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#Instances:sort=instanceId)


Wait until you can see the server is up and running - InstanceState column should show running like on 
the page below

![Screen Shot 2020-05-15 at 7 25 22 pm](https://user-images.githubusercontent.com/1170273/82034682-dbf07b80-96e1-11ea-9933-8d7526f82442.png)

Once the server is running, you can use script below to 
 - discover instance id programmatically through the use of Aws Cli
 - Log in to your instance secure shell using AWS SSM service

```bash
#!/bin/bash
# use aws cli to obtain instanceid i-xxxxx
instance_id=$(aws ec2 describe-instances --filters \
     "Name=instance-state-name,Values=running" \
     "Name=tag:Name,Values=BigBlueButton-Server" \
     --query 'Reservations[].Instances[].InstanceId' --output text)
echo "Connecting to $instance_id"
aws ssm start-session --target "${instance_id}"
```

**Note** - If this command gets stuck, retry in new terminal window. As there are changes
to the network configuration during the instance boot procedure, there is slight window
where SSM may connect initially, but not respond. 


Once you have logged into the server, you can trail the server setup log, 
by executing following command 

```bash
$ tail -f /var/log/cloud-init-output.log
```
 
Depending in which state the server setup is currently, you may see different output,
but the message marking end of the boot and installation sequence should look 
like below. Server configuration should be complete within 10-20 minutes since you
clicked the 'create stack' button. 
 
```text
Cloud-init v. 19.4-33-gbb4131a2-0ubuntu1~16.04.1 running 'modules:final' at Wed, 13 May 2020 02:20:32 +0000. Up 57.33 seconds.
ci-info: no authorized SSH keys fingerprints found for user ubuntu.
Cloud-init v. 19.4-33-gbb4131a2-0ubuntu1~16.04.1 finished at Wed, 13 May 2020 02:32:33 +0000. Datasource DataSourceEc2Local.  Up 778.35 seconds
```


#### Obtain web login admin credentials

As a final step, you'll need credentials to login to your Web user interface. 
As the server configuration stores the values for default user, password, as
well as login url - you can execute script below in your bash shell
to obtain these parameters

```bash

CONFIG_PATH=/bigbluebutton/config
BBBPASS=$(aws ssm get-parameter --name ${CONFIG_PATH}/admin_password --query Parameter.Value --output text --with-decryption)
BBBUSER=$(aws ssm get-parameter --name ${CONFIG_PATH}/admin_user --query Parameter.Value --output text)
BBBSERVER=$(aws ssm get-parameter --name ${CONFIG_PATH}/server_url --query Parameter.Value --output text)
echo "Login with ${BBBUSER}:${BBBPASS} at ${BBBSERVER}/b/signin"
```

Output should look somewhat like

```text
Login with admin@programming-tools-meetup.cloud:XXXXXXXXX at https://workshop-XXXXX.programming-tools-meetup.cloud/b/signin
```

Copy and paste https url into your browser to be greeted with Greenlight (BBB UI) 
Login page, where you can input username:password credentials obtained in previous command

<img width="1041" alt="Screen Shot 2020-05-16 at 7 02 52 pm" src="https://user-images.githubusercontent.com/1170273/82115794-51268400-97a8-11ea-8b40-f74fcb5114eb.png">



[Go to Step3 - Configure your BibBlueButton server](Step3.md) 