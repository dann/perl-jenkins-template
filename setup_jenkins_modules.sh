#!/bin/bash

#==================================
# Configuration
#==================================
HOSTNAME=localhost
PORT=8080

#==================================
# Main
#==================================
JENKINS_PLUGINS=(
git
checkstyle
htmlpublisher
clover
plot
)

PERL_MODULES=(
Devel::Cover
Devel::Cover::Report::Clover
Perl::Metrics::Lite
https://github.com/dann/tap-to-junit-xml/tarball/master
)

setup() {
    fetch_jenkins_cli
    install_jenkins_plugins
    install_jenkins_related_perl_modules
    restart_jenkins
    clean_jenkins_cli
}

fetch_jenkins_cli() {
    curl -LO http://${HOSTNAME}:${PORT}/jnlpJars/jenkins-cli.jar
}

jenkins_cli() {
    java -jar jenkins-cli.jar -s http://${HOSTNAME}:${PORT} $@
}

install_jenkins_plugins() {
    for plugin in ${JENKINS_PLUGINS[@]}
    do
        jenkins_cli install-plugin ${plugin}
    done
}

install_jenkins_related_perl_modules() {
    for module in ${PERL_MODULES[@]}
    do
        cpanm $module
    done
}

restart_jenkins() {
   jenkins_cli safe-restart
}

clean_jenkins_cli() {
    rm jenkins-cli.jar
}

setup
