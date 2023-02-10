#!/bin/bash
echo "Install Jenkins stable release"
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum upgrade -y
sudo yum clean all
sleep 5
sudo amazon-linux-extras install java-openjdk11 epel -y
sudo yum install jenkins -y

echo "Install git"
yum install -y git

echo "Setup SSH key"
mkdir -p /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/known_hosts
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
mv /tmp/id_rsa.pub /var/lib/jenkins/.ssh/id_rsa.pub
chmod 600 /var/lib/jenkins/.ssh/id_rsa /var/lib/jenkins/.ssh/id_rsa.pub

echo "Configure Jenkins"
mkdir -p /var/lib/jenkins/init.groovy.d /tmp/myapplication
mv /tmp/basic-security.groovy /var/lib/jenkins/init.groovy.d/basic-security.groovy
#mv /tmp/disable-cli.groovy /var/lib/jenkins/init.groovy.d/disable-cli.groovy
mv /tmp/csrf-protection.groovy /var/lib/jenkins/init.groovy.d/csrf-protection.groovy
mv /tmp/credentials.xml /var/lib/jenkins/
#mv /tmp/disable-jnlp.groovy /var/lib/jenkins/init.groovy.d/disable-jnlp.groovy
mv /tmp/jenkins.install.UpgradeWizard.state /var/lib/jenkins/jenkins.install.UpgradeWizard.state
#mv /tmp/node-agent.groovy /var/lib/jenkins/init.groovy.d/node-agent.groovy
chown -R jenkins:jenkins /var/lib/jenkins/jenkins.install.UpgradeWizard.state /var/lib/jenkins/init.groovy.d /var/lib/jenkins/credentials.xml
mv /tmp/jenkins /etc/sysconfig/jenkins
chmod +x /tmp/install-plugins.sh
bash /tmp/install-plugins.sh
sleep 60
sudo systemctl enable jenkins
sudo systemctl restart jenkins
sudo sed -i 's/User=jenkins/User=root/g' /usr/lib/systemd/system/jenkins.service
sudo systemctl daemon-reload
sudo systemctl restart jenkins