#!/bin/bash

profile=your_creds_profile
output=your_output_fomat['text' or 'json' ...]
instance_id=i-454645644744            #yourinstance_id here

cmd='aws ec2 describe-instances --instance-ids $instance_id --profile $profile'
aws ec2 stop-instances --instance-ids $instance_id --profile zeus
COUNTER=0
while [ $COUNTER -lt 60 ]; do
    result=`$cmd | python -c "import json,sys;obj=json.load(sys.stdin);print(obj['Reservations'][0]['Instances'][0]['State']['Name'])"`
    echo $result
    if [ "$result" = "stopped" ];
    then
        echo "Instance is now in stopped state"
        break
        sleep 10
    fi
    (( COUNTER++ ))
    echo $COUNTER
done


#Handling for case if instance takes greater than 10 * 60 secs...till required
