#!/usr/bin/python
import commands,getpass
ipaddress=raw_input("please enter the jenkinserver ip:")
gituserid=raw_input("Enter gituserid:")
password=getpass.getpass()

data="""curl -X POST -u admin:admin@123 'http://"""+ipaddress+""":8080/credentials/store/system/domain/_/createCredentials' --data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "gitaccess",
    "username": \""""+gituserid+"""\",
    "password": \""""+password+"""\",
    "description": "gitaccess",
    "stapler-class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }
}'"""
status, output = commands.getstatusoutput(data)
if output:
    print "*****\tgitaccess Credentials created succesfully\t******"
