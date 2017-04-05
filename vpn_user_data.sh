#!/usr/bin/env bash

function install_oracle_java {
    echo "Installing Oracle Java..."
    echo "Fetching Oracle Java..."
    wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz" \
         -O /tmp/jdk-8u25-linux-x64.tar.gz

    if [[ $? != 0 ]]; then
        echo "Failed during Oracle Java download."
        exit 1
    fi

    echo "Extracting Oracle Java..."
    tar xzf /tmp/jdk-8u25-linux-x64.tar.gz --directory=/usr/local/
    if [[ $? != 0 ]]; then
        echo "Failed during Oracle Java extraction."
        exit 1
    fi

    echo "Updating alternatives..."
    update-alternatives --install "/usr/bin/java" "java" "/usr/local/jdk1.8.0_25/bin/java" 1
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/jdk1.8.0_25/bin/javac" 1
    update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/jdk1.8.0_25/bin/javaws" 1
    update-alternatives --set "java" "/usr/local/jdk1.8.0_25/bin/java"
    update-alternatives --set "javac" "/usr/local/jdk1.8.0_25/bin/javac"
    update-alternatives --set "javaws" "/usr/local/jdk1.8.0_25/bin/javaws"

    echo "Exporting JAVA_HOME..."
    export JAVA_HOME=/usr/local/jdk1.8.0_25/
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
        echo "Waiting for Marathon..."
        sleep 5
    done
}

function export_public_ip {
    echo "Resolving public IP address..."
    export PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
    echo "Public IP is: $PUBLIC_IP"
}

function export_dns_nameserver {
    echo "Resolving DNS servers..."

    apt-get install -y jq
    if [[ $? != 0 ]]; then
        echo "Failed during jq installation."
        exit 1
    fi

    until [ -n "$DNS_NAMESERVER" ]; do
        sleep 5
        echo "Waiting until name server is ready..."
        export DNS_NAMESERVER=$(curl -s http://${internal_master_lb_dns_name}:8080/v2/info | jq '.leader' | sed 's/\"//' | sed 's/\:8080"//')
    done

    echo "Nameserver is: $DNS_NAMESERVER"
}

function setup_openvpnas {
    echo "Installing and configuring OpenVPN Access Server..."
    echo "Creating/updating OpenVPN administrative user ${admin_user}"

    getent passwd ${admin_user}>/dev/null
    if [[ $? != 0 ]]; then
      useradd ${admin_user} -g ${admin_user}
      if [[ $? != 0 ]]; then
          echo "Failed while creating ${admin_user} user."
          exit 1
      fi
    fi

    echo "${admin_user}:${admin_pw}" | chpasswd
    if [[ $? != 0 ]]; then
        echo "Failed while setting ${admin_user} password."
        exit 1
    fi

    echo "Waiting 15 seconds for OpenVPN to warm up..."
    sleep 15

    echo "Configuring OpenVPN..."
    /usr/local/openvpn_as/scripts/sacli -u ${admin_user} -k prop_superuser -v true UserPropPut
    /usr/local/openvpn_as/scripts/sacli -u openvpn UserPropDelAll
    /usr/local/openvpn_as/scripts/sacli -k vpn.client.routing.reroute_dns -v custom ConfigPut
    /usr/local/openvpn_as/scripts/sacli -k vpn.general.osi_layer -v 3 ConfigPut
    /usr/local/openvpn_as/scripts/sacli -k vpn.server.routing.gateway_access -v true ConfigPut
    /usr/local/openvpn_as/scripts/sacli -k vpn.client.routing.reroute_gw -v false ConfigPut
    /usr/local/openvpn_as/scripts/sacli -k vpn.server.routing.private_network.0 -v ${vpc_subnet_range} ConfigPut

    wait_until_marathon_is_running
    export_dns_nameserver
    /usr/local/openvpn_as/scripts/sacli -k vpn.server.dhcp_option.dns.0 -v $DNS_NAMESERVER ConfigPut

    export_public_ip
    /usr/local/openvpn_as/scripts/sacli -k host.name -v $PUBLIC_IP ConfigPut

    echo "Restarting OpenVPN..."
    systemctl restart openvpnas

    echo "Installation finished."
}

install_oracle_java
install_openvpnas
setup_openvpnas
