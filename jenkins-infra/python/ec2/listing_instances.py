#!/usr/bin/python

import boto3

ec2=boto3.resource("ec2")

for i in ec2.instances.all():
    print(i,i.id, i.state['Name'],i.tags[0]["Value"])
