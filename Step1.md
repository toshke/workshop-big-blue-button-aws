# Create Route53 hosted zone to host your BBB installation

## Why Route53 Hosted Zone

As BigBlueButton is using RTMP (Real-Time messaging) Protocol for Audio and Video 
communication. Due security concerns, most of the modern browsers will not 
allow RTMP communication over non-secure connection, with either no 
encryption at all, or w/invalid SSL certificate

For this reason, an SSL certificate is a must, and while it will be issued in 
next step automatically for you, valid domain name is required. 

For the purposes of this workshop, AWS Tools and Programming meetup has
opened up an API to programmatically obtain subdomain within `programming-tools-meetup.cloud`
zone. 

This will be done in 3 steps 
- Request a zone through the API
- Create Route53 Zone in your own account
- Update RootZone with NS servers from your own account


Request:
```bash
curl -X GET https://api.programming-tools-meetup.cloud/zones
```


Create:


Update:


```shell
curl -X PUT -d '{"zoneName":"workshop-mkzulmyk",
        "ns":[
        "ns-517.awsdns-00.net.",
        "ns-437.awsdns-54.com.",
        "ns-2010.awsdns-59.co.uk.",
        "ns-1101.awsdns-09.org."]
    }' https://api.programming-tools-meetup.cloud/zones
```



[Go to step2](Step2.md) 