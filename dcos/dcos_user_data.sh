#!/usr/bin/env bash
function init {
    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

    echo "export LC_ALL=C.UTF-8" >> ~/.bashrc
    echo "export LANG=C.UTF-8" >> ~/.bashrc

    apt-get install -y language-pack-UTF-8 language-pack-en python3
    ln -s /usr/bin/python3 /usr/bin/python

    curl "https://bootstrap.pypa.io/get-pip.py" -o "/tmp/get-pip.py"
    python /tmp/get-pip.py

    mkdir -p /opt/mesosphere/dcos-cli/bin/
    mkdir -p /opt/smack/state
    mkdir -p /opt/smack/conf
    mkdir -p /opt/vamp/conf/
}

function install_dcos_cli {
    curl -s --output /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
    python /tmp/get-pip.py
    pip install virtualenv
    wget https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos -O /opt/mesosphere/dcos-cli/bin/dcos
    chmod +x /opt/mesosphere/dcos-cli/bin/dcos
    ln -s /opt/mesosphere/dcos-cli/bin/dcos /usr/sbin/dcos
    dcos config set core.dcos_url http://leader.mesos
    dcos config set core.email devops@canary.is
    dcos config set core.dcos_acs_token abc
}

function install_oracle_java {
    wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz" \
         -O /tmp/jdk-8u25-linux-x64.tar.gz
    tar xzf /tmp/jdk-8u25-linux-x64.tar.gz --directory=/usr/local/
    update-alternatives --install "/usr/bin/java" "java" "/usr/local/jdk1.8.0_25/bin/java" 1
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/jdk1.8.0_25/bin/javac" 1
    update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/jdk1.8.0_25/bin/javaws" 1
    update-alternatives --set "java" "/usr/local/jdk1.8.0_25/bin/java"
    update-alternatives --set "javac" "/usr/local/jdk1.8.0_25/bin/javac"
    update-alternatives --set "javaws" "/usr/local/jdk1.8.0_25/bin/javaws"
    export JAVA_HOME=/usr/local/jdk1.8.0_25/
    echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
}

function update_dns_nameserver {
    apt-get install -y jq
    echo nameserver $(curl -s http://${internal_master_lb_dns_name}:8080/v2/info | jq '.leader' | \
         sed 's/\"//' | sed 's/\:8080"//') &> /etc/resolvconf/resolv.conf.d/head
    resolvconf -u
}

function waited_until_marathon_is_running {
    until $(curl --output /dev/null --silent --head --fail http://${internal_master_lb_dns_name}:8080/v2/info); do
        echo "waiting for marathon"
        sleep 5
    done
}

function waited_until_dns_is_ready {
    until $(curl --output /dev/null --silent --head --fail http://master.mesos); do
        echo "waiting for dns"
        sleep 5
        update_dns_nameserver
    done
}

init
install_oracle_java                 #need for some commandline extension like kafka
waited_until_marathon_is_running
waited_until_dns_is_ready
install_dcos_cli

