# Create Route53 hosted zone to host your BBB installation

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
- Update RootZone with NS servers from your own account


By executing the following script in bash shell you should get your zone displayed in output, 
in `workshop-XXXXX.programming-tools-meetup.cloud' format. 


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

#### Created hosted zone

Now that you have reserved your Zone name with above API call, it is time 
to create the zone within your own AWS account through the aws cli. Take a note of 
a zone name above, and replace  `workshop-XXXX.programming-tools-meetup.cloud` in 
below's command with it. 

```bash

aws route53 create-hosted-zone  \
    --name workshop-XXXX.programming-tools-meetup.cloud  \
    --caller-reference cloud-tools-meetup-$(date +%s)  \
    --query 'DelegationSet.NameServers'
```

Output should look like 

```json
[
    "ns-451.awsdns-56.com",
    "ns-573.awsdns-07.net",
    "ns-1329.awsdns-38.org",
    "ns-1800.awsdns-33.co.uk"
]
```

Copy this values, as you will need them for next step

#### Delegate hosted zone NS 

As `.programming-tools-meetup.cloud` zone is hosted outside of your account, we have 
developed an API for you to registed your zone within our account. To do so, you'll need
to construct JSON-structured payload, including both zone name and your NS servers. Payload, has 
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

Again, we will be using standard `curl` command in bash shell to make an HTTP(s) API request call

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
as only element
 
```text
{"zone": "workshop-XXXX.programming-tools-meetup.cloud"}
```

#### Verify NS servers 


Theoretically, DNS changes should take hold off imediatelly, though that's not always the case, sometimes
it takes few minutes, depending on the path from your local DNS resolver to the source of truth. 

You can use standard `nslookup` tool, available on both macOS and windows to read the NS servers for particular
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

With your own Route53 hosted zone, you can move forward and 

**IMPORTANT NOTICE** All of the NS records for  zones created during the workshop will be 
removed shortly after the meetup event. If you want to deploy BBB server for more long-term 
usage, use your own Route53 hosted zone. 

[Go to step2 - BigBlueButton Deployment](Step2.md) 