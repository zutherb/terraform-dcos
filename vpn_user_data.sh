#!/usr/bin/env bash
function init {
    echo "init instance"
    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

    echo "export LC_ALL=C.UTF-8" >> ~/.bashrc
    echo "export LANG=C.UTF-8" >> ~/.bashrc

    apt-get install -y language-pack-UTF-8
}

function install_oracle_java {
    echo "Installing Oracle Java..."
    echo "Fetching Oracle Java..."
    wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz" \
         -O /tmp/jdk-8u131-linux-x64.tar.gz

    if [[ $? != 0 ]]; then
        echo "Failed during Oracle Java download."
        exit 1
    fi

    echo "Extracting Oracle Java..."
    tar xzf /tmp/jdk-8u131-linux-x64.tar.gz --directory=/usr/local/
    if [[ $? != 0 ]]; then
        echo "Failed during Oracle Java extraction."
        exit 1
    fi

    echo "Updating alternatives..."
    update-alternatives --install "/usr/bin/java" "java" "/usr/local/jdk1.8.0_131/bin/java" 1
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/jdk1.8.0_131/bin/javac" 1
    update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/jdk1.8.0_131/bin/javaws" 1
    update-alternatives --set "java" "/usr/local/jdk1.8.0_131/bin/java"
    update-alternatives --set "javac" "/usr/local/jdk1.8.0_131/bin/javac"
    update-alternatives --set "javaws" "/usr/local/jdk1.8.0_131/bin/javaws"

    echo "Exporting JAVA_HOME..."
    export JAVA_HOME=/usr/local/jdk1.8.0_131/
    echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
}

function install_openvpnas {
    echo "Installing OpenVPN Access Server..."

    wget -O /tmp/openvpn-as-2.0.25-Ubuntu14.amd_64.deb http://swupdate.openvpn.org/as/openvpn-as-2.0.25-Ubuntu14.amd_64.deb
    if [[ $? != 0 ]]; then
        echo "Failed during OpenVPN download."
        exit 1
    fi

    dpkg -i /tmp/openvpn-as-2.0.25-Ubuntu14.amd_64.deb
    if [[ $? != 0 ]]; then
        echo "Failed during OpenVPN installation."
        exit 1
    fi

    rm -f /tmp/openvpn-as-2.0.25-Ubuntu14.amd_64.deb

    echo "Restarting OpenVPN...."
    systemctl daemon-reload
    systemctl restart openvpnas
}

function wait_until_marathon_is_running {
    until $(curl --output /dev/null --silent --head --fail http://${internal_master_lb_dns_name}:8080/v2/info); do
        echo "waiting for marathon"
        sleep 5
    done
}

function export_public_ip {
    echo "resolve public ip"
    export PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
    echo "Public IP is: $PUBLIC_IP"
}

function export_dns_nameserver {
    echo "resolve dns server"
    apt-get install -y jq

    until [ -n "$DNS_NAMESERVER" ]; do
        sleep 5
        echo "waiting until name server is ready"
        export DNS_NAMESERVER=$(curl -s http://${internal_master_lb_dns_name}:8080/v2/info | jq '.leader' | sed 's/\"//' | sed 's/\:8080"//')
    done

    echo "Nameserver is: $DNS_NAMESERVER"
}

function install_openvpnas {
    echo "Install openvpnas"
    wget -O /tmp/openvpn-as-2.0.25-Ubuntu14.amd_64.deb http://swupdate.openvpn.org/as/openvpn-as-2.0.25-Ubuntu14.amd_64.deb
    dpkg -i /tmp/openvpn-as-2.0.25-Ubuntu14.amd_64.deb
    rm -f /tmp/openvpn-as-2.0.25-Ubuntu14.amd_64.deb

    service openvpnas restart
}


function setup_openvpnas {
    echo "Setup openvpnas"
    echo "Add openvpn admin ${admin_user}"
    useradd ${admin_user}
    echo "${admin_user}:${admin_pw}" | chpasswd
    /usr/local/openvpn_as/scripts/sacli -u ${admin_user} -k prop_superuser -v true UserPropPut

    /usr/local/openvpn_as/scripts/sacli -u openvpn UserPropDelAll

    /usr/local/openvpn_as/scripts/sacli -k vpn.client.routing.reroute_dns -v custom ConfigPut
    /usr/local/openvpn_as/scripts/sacli -k vpn.general.osi_layer -v 3 ConfigPut
    /usr/local/openvpn_as/scripts/sacli -k vpn.server.routing.gateway_access -v true ConfigPut
    /usr/local/openvpn_as/scripts/sacli -k vpn.client.routing.reroute_gw -v false ConfigPut
    /usr/local/openvpn_as/scripts/sacli -k vpn.server.routing.private_network.0 -v ${vpc_subnet_range} ConfigPut

    waited_until_marathon_is_running
    export_dns_nameserver
    /usr/local/openvpn_as/scripts/sacli -k vpn.server.dhcp_option.dns.0 -v $DNS_NAMESERVER ConfigPut

    export_public_ip
    /usr/local/openvpn_as/scripts/sacli -k host.name -v $PUBLIC_IP ConfigPut

    service openvpnas restart
}

init
install_oracle_java
install_openvpnas
setup_openvpnas
