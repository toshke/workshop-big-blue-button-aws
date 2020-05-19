# Create Route53 hosted zone to host your BBB installation

**IMPORTANT - This step uses API calls to endpoints which are decomissioned after the workshop event, and 
not working as such. Jump straight to step2 with your own Route53 hosted zone**

## Why Route53 Hosted Zone

As BigBlueButton is using RTMP (Real-Time messaging) Protocol for Audio and Video 
communication. Due security concerns, most of the modern browsers will not 
allow RTMP communication over non-secure connection, with either no 
encryption at all, or w/invalid SSL certificate

For this reason, an SSL certificate is a must, and while it will be issued in 
next step automatically for you, valid domain name is required. 


## How do I create my own?

For the purposes of this workshop, AWS Tools and Programming meetup has
opened up an API to programmatically obtain subdomain within `programming-tools-meetup.cloud`
zone. 

This will be done in 3 steps 
- Request a zone through the API
- Create Route53 Zone in your own account
- Update RootZone with NS records from your own account


By executing the following script in bash shell you should get your subdomain displayed in output, 
in `workshop-XXXXX.programming-tools-meetup.cloud` format. 


#### Request Zone name
```bash
response=$(curl -X GET https://api.programming-tools-meetup.cloud/zones)
echo ""
echo $response
echo ""
```

Output should look something like 
```bash
{"zone": "workshop-XXXX.programming-tools-meetup.cloud"}
```

#### Create hosted zone

Now that you have reserved your subdomain with above API call, it is time 
to create the zone within your own AWS account through the AWS CLI. You'll
need to replace `workshop-XXXX.programming-tools-meetup.cloud` in the command
below with your subdomain from the previous step.

```bash

aws route53 create-hosted-zone  \
    --name workshop-XXXX.programming-tools-meetup.cloud  \
    --caller-reference cloud-tools-meetup-$(date +%s)  \
    --query 'DelegationSet.NameServers'
```

Output should look like this:

```json
[
    "ns-451.awsdns-56.com",
    "ns-573.awsdns-07.net",
    "ns-1329.awsdns-38.org",
    "ns-1800.awsdns-33.co.uk"
]
```

Copy these values, as you will need them for next step.

#### Delegate hosted zone NS 

As `.programming-tools-meetup.cloud` zone is hosted outside of your account, we have 
developed an API for you to register your subdomain within our account. To do so, you'll need
to construct JSON-structured payload with your zone name and your NS domains. The payload has 
2 keys - `zoneName` and `ns`. With example given above, payload looks like 

```json
{
  "zoneName":"workshop-XXXX",
   "ns":[
        "ns-451.awsdns-56.com",
        "ns-573.awsdns-07.net",
        "ns-1329.awsdns-38.org",
        "ns-1800.awsdns-33.co.uk"
   ]
}
```

Again, we will be using standard `curl` command in bash shell to make an HTTP(s) API request call.

```bash
curl -X PUT -d '{
  "zoneName":"workshop-XXXX",
   "ns":[
        "ns-451.awsdns-56.com",
        "ns-573.awsdns-07.net",
        "ns-1329.awsdns-38.org",
        "ns-1800.awsdns-33.co.uk"
   ]
  }' https://api.programming-tools-meetup.cloud/zones
```

As an response from the resource server, you should again see json structure with `zoneName`
as only element.
 
```text
{"zone": "workshop-XXXX.programming-tools-meetup.cloud"}
```

#### Verify NS servers 


Theoretically, DNS changes should take hold off imediatelly, though that's not always the case. Sometimes
it takes few minutes, depending on the path from your local DNS resolver to the source of truth. 

You can use standard `nslookup` tool, available on both macOS and Windows, to read the NS servers for particular
domain:

```shell
nslookup -type=ns workshop-XXXX.programming-tools-meetup.cloud
```

Set of the NS servers provided should be returned as response

```text
nslookup -type=ns workshop-XXXX.programming-tools-meetup.cloud 1.1.1.1
Server:		1.1.1.1
Address:	1.1.1.1#53

Non-authoritative answer:
workshop-XXXX.programming-tools-meetup.cloud	nameserver = ns-1329.awsdns-38.org.
workshop-XXXX.programming-tools-meetup.cloud	nameserver = ns-1800.awsdns-33.co.uk.
workshop-XXXX.programming-tools-meetup.cloud	nameserver = ns-451.awsdns-56.com.
workshop-XXXX.programming-tools-meetup.cloud	nameserver = ns-573.awsdns-07.net.
```

**IMPORTANT NOTICE** All of the NS records for zones created during the workshop will be 
removed shortly after the meetup event. If you want to deploy BBB server for more long-term 
usage, you'll need to set up nameservers for your domain through your hosting provider.
You can register and configure a domain through Route 53 using
[these instructions](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/getting-started.html). 

[Go to step2 - BigBlueButton Deployment](Step2.md) 
