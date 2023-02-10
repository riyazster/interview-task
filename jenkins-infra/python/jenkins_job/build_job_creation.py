import xml.etree.ElementTree as ET
import jenkins
def main():
    jenkins_ip = raw_input("please provide jenkins ip:")
    tree = ET.parse("config.xml")
    root = tree.getroot()
    config = ET.tostring(root, encoding='utf8', method='xml').decode()
    target_server = jenkins.Jenkins('http://'+jenkins_ip+':8080/', username='admin', password='admin@123')
    target_server.create_job('DemoPaaC', config)

main()
