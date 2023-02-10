// #!groovy
//
// import hudson.security.csrf.DefaultCrumbIssuer
// import jenkins.model.Jenkins
//
// println "--> enabling CSRF protection"
//
// def instance = Jenkins.instance
// instance.setCrumbIssuer(new DefaultCrumbIssuer(null))
// instance.save()

//Disabling CSRF option so that we can call jenkins via api's
import jenkins.model.Jenkins

def instance = Jenkins.instance
instance.setCrumbIssuer(null)
instance.save()
