# Using the admin console and inviting friends

As well as configuring BigBlueButton's code files, we can also customise it using the admin console.  In order to do this, we need to sign in to the web frontend using our administrator username and password.

## Signing in

1. Log on to the instance via SSH, and navigate to the Greenlight directory:

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
    ```bash
    cd ~/greenlight
    ```

1. Run the following command to create a new administrator user:

    ```bash
    docker exec greenlight-v2 bundle exec rake user:create["name","email","password","admin"]
    ```
    Substitute "name", "email", and "password" for the relevant values.

## Exploring the administrator console

1. Go to your subdomain URL (`workshop-XXXX.programming-tools-meetup.cloud` format), and sign in using the credentials you created in the previous step.

1. Click on your username in the top right-hand corner, and select `Organisation`.

1. Click on the Manage Users tab.  Notice that there are four different views: Active, Pending, Banned, and Deleted.  These allow you to filter accounts by their status.

1. Click on the three dots beside an active user account to bring up the account dropdown.  Select Edit to open the Edit user view.

1. Close the Edit window, and open the Site Settings tab.

1. Change the way that users join from `Open Registration` to `Join by Invitation`.

1. Open the Room Configuration tab, and have a look at the available options.

## Inviting another user

For this section, you'll need to find someone else who's up to this step, and exchange email addresses with them.  Alternatively, if you have a secondary email address, you can use it for this step.

1. Navigate back to the Manage Users tab, and click the Invite User button to the right.

1. Enter the email address that you want to invite to your server.

1. If you need to accept an invitation, go to the email account that it was sent to and click the link.  Proceed through the normal steps to create your user account.

1. Once this is done, reload the admin console and return to the Manage Users tab.  You should now see the new user in the list.

**CONGRATULATIONS, YOU HAVE REACHED THE END OF THE BIGBLUEBUTTON WORKSHOP**

If you want to customise the AWS side of your BigBlueButton installation, go to the advanced challenges [here](./README.md/#advanced-tasks-for-exercise).  Otherwise, proceed to the [cleanup steps](./Cleanup.md).
