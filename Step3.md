# Configuring BigBlueButton

Now that we've set up BigBlueButton on AWS, it's time to make sure that it suits our needs.  Both BigBlueButton and the Greenlight frontend are highly configurable through the shell and a GUI control panel.  To start with, let's look at the shell configuration.

## Signing in to the instance

1. Log in to the AWS CLI using the script from Step 2:

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

## Changing the welcome message

1. Navigate to the `/classes/` folder, which contains the BigBlueButton properties:

     ```bash
     cd /usr/share/bbb-web/WEB-INF/classes/
     ```

1. Open the `bigbluebutton.properties` file using your text editor of choice:

     ```bash
     nano bigbluebutton.properties
     ```

1. Locate the `defaultWelcomeMessage` parameter, and change it to `Welcome to the AWS Programming and Tools Meetup!`

1. Locate the `defaultWelcomeMessageFooter` parameter, and change it to `The URL for this workshop is: https://github.com/toshke/workshop-big-blue-button-aws`.

1. Restart BigBlueButton to apply your changes:

     ```bash
     sudo bbb-conf --restart
     ```

1. Go to the URL of your BigBlueButton server, create a new meeting, and check that the welcome message in the chat window has changed.  (This may take a couple of minutes to take effect)

## Changing the default presentation

1. Navigate to the `bigbluebutton-default` folder, and delete the `default.pdf` file:

     ```bash
     cd /var/www/bigbluebutton-default/
     sudo rm default.pdf
     ```

1. Use `wget` to download the sample PDF file to your server as `default.pdf` (you may need to use `sudo apt install wget` to install it):

     ```bash
     wget  -O /var/www/bigbluebutton-default/default.pdf "https://s3-ap-southeast-2.amazonaws.com/workshop-artifacts.programming-tools-meetup.cloud/awspt.pdf"
     ```

1. Restart BigBlueButton to apply your changes:

     ```bash
     sudo bbb-conf --restart
     ```

1. Go to the URL of your BigBlueButton server, create a new meeting, and check that the default presentation has changed to the `Welcome to the AWS Programming and Tools meetup` PDF.  (This may take a couple of minutes to take effect)

## Adding background music when only one person is in a session

For this exercise, we're going to use a royalty-free song by Kevin Macleod of [Incompetech](https://incompetech.com/).  His music is released under a Creative Commons attribution license, which allows use for commercial purposes.  This means that you can follow these instructions to install his music on a commercial BigBlueButton server as well.

1. Navigate to the `autoload_configs` folder:

     ```bash
     cd /opt/freeswitch/conf/autoload_configs/
     ```

1. Open the `conference.conf.xml` file in your text editor of choice:

     ```bash
     nano conference.conf.xml
     ```

1. At approximately line 200, uncomment the following line:

     ```xml
     <param name="moh-sound" value="$${hold_music}"/>
     ```
     Save the file.

1. Use `wget` to download the music file to your server:

     ```bash
     sudo wget  -P /opt/freeswitch/share/freeswitch/sounds "https://incompetech.com/music/royalty-free/mp3-royaltyfree/Off%20to%20Osaka.mp3"
     ```

1. Navigate to the `conf` folder:

     ```bash
     cd /opt/freeswitch/conf/
     ```

1. Open the `vars.xml` file in your text editor of choice:

     ```bash
     nano vars.xml
     ```

1. Change the `hold_music` parameter to refer to the music file we uploaded:

     ```xml
     <X-PRE-PROCESS cmd="set" data="hold_music=/opt/freeswitch/share/freeswitch/sounds/Off%20to%20Osaka.mp3" />
     ```
     Save the file.

1. Restart BigBlueButton to apply your changes:

     ```bash
     sudo bbb-conf --restart
     ```

1. Go to the URL of your BigBlueButton server, create a new meeting, and check that the hold music is audible.  (This may take a couple of minutes to take effect)

## Challenge

Try using the instructions under `User Authentication` [here](https://docs.bigbluebutton.org/greenlight/gl-config.html#user-authentication) to set up either Google or Office OAuth for the Greenlight frontend.

Once you're done, go to [Step 4: Using the admin console and inviting friends](Step4.md).
