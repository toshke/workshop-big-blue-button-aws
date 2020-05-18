# BigBlueButton deployment to AWS

Workshop tutorial for Big Blue Button open source video conferencing software setup on AWS

## Prereqs

- Bash shell with `curl` command available
- AWS CLI
- AWS Account / Credentials with enough privileges to manage EC2/VPC, IAM and SSM services. 

## Useful destinations

[BigBlueButton OpenSource Distance learning software](https://www.bigbluebutton.org)

[BigBlueButton Github Org](https://github.com/bigbluebutton)

[BigBlueButton AWS Automation](https://github.com/toshke/big-blue-button-cloudformation-cfhl)

## Steps

[Step 1 - Create and register Route53 zone](./Step1.md) 

[Step 2 - Deploy BigBlueButton Server](./Step2.md) 

[Step 3 - Configure BigBlueButton](./Step3.md) 

[Step 4 - Use the admin console and invite other people](./Step4.md)

[Cleanup](./Cleanup.md)

## Advanced tasks for exercise

- Update CloudFormation Stack with AMI created by AWS Backup
- Convert from EC2 to ASG deployment mode
- Render CloudFormation templates without embedded VPC code
