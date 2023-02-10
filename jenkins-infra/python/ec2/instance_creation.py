#!/usr/bin/python
import boto3
import time

count=int(input("Please enter your server count:"))
#image_id=raw_input("Please provide the image id:")
image_id="ami-012b13ec38f9ead88"
ec2 = boto3.resource('ec2')
instance = ec2.create_instances(
    ImageId=image_id,
    MinCount=1,
    MaxCount=count,
    KeyName="shaan-ramana-nvirg-key",
    SecurityGroups=["opentoworld"],
    InstanceType='t2.medium',
    TagSpecifications=[
    {
    'ResourceType':'instance',
    'Tags': [
    {
    'Key': 'Name',
    'Value': 'JenkinsMaster'
    }
    ]
    }
    ]
    )
time.sleep(50)
print("Your instance creation is completed & your ec2-instance id is *******"+instance[0].id+"*******")
# printing the public ipaddress0
for i in ec2.instances.filter(InstanceIds=[instance[0].id]):
    print("your public ipaddress for the newly created server is *******"+i.public_ip_address+"*******")
