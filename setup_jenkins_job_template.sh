#!/bin/bash
#==================================
# Configuration
#==================================
HOSTNAME=localhost
PORT=8080
JENKINS_USER=jenkins
JENKINS_GROUP=jenkins
JENKINS_HOME=/var/lib/jenkins

#==================================
# Main 
#==================================
setup() {
    install_jenkins_template
    fetch_jenkins_cli
    reload_jenkins_configuration
    clean_jenkins_cli
}

install_jenkins_template() {
    cd ${JENKINS_HOME}/jobs
    git clone https://github.com/dann/perl-jenkins-template.git perl-jenkins-template
    chown -R ${JENKINS_USER}:${JENKINS_GROUP} perl-jenkins-template
}

fetch_jenkins_cli() {
    curl -LO http://${HOSTNAME}:${PORT}/jnlpJars/jenkins-cli.jar
}

jenkins_cli() {
    java -jar jenkins-cli.jar -s http://${HOSTNAME}:${PORT} $@
}

reload_jenkins_configuration() {
   jenkins_cli reload-configuration
}

clean_jenkins_cli() {
    rm jenkins-cli.jar
}

setup
