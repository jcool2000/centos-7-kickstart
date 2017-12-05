#!/bin/bash -e

CWD=$(cd $(dirname $0); pwd)

echo "Installing open-vm-tools ..."

# Get open-vm-tools rpm with dependencies
#   $ yum install -y yum-utils epel-release
#   $ yumdownloader --resolve open-vm-tools
yum -c $CWD/repo/iso.repo --disablerepo=* --enablerepo=iso-* install -y open-vm-tools

OVFENV_FILE=/tmp/ovfenv.xml

echo "Getting OVF Properties ..."
if [ -f $(type -P vmtoolsd) ]; then
    vmtoolsd --cmd "info-get guestinfo.ovfenv" > $OVFENV_FILE
elif [ -f $(type -P vmware-guestd) ]; then
    vmware-guestd --cmd "info-get guestinfo.ovfEnv" > $OVFENV_FILE
else [ -f $(type -P vmware-rpctool) ]; then
    vmware-rpctool "info-get guestinfo.ovfEnv" > $OVFENV_FILE
fi

# cat $OVFENV_FILE
# <?xml version="1.0" encoding="UTF-8"?>
# <Environment
#      xmlns="http://schemas.dmtf.org/ovf/environment/1"
#      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
#      xmlns:oe="http://schemas.dmtf.org/ovf/environment/1"
#      xmlns:ve="http://www.vmware.com/schema/ovfenv"
#      oe:id=""
#      ve:vCenterId="vm-23264">
#    <PlatformSection>
#       <Kind>VMware ESXi</Kind>
#       <Version>6.0.0</Version>
#       <Vendor>VMware, Inc.</Vendor>
#       <Locale>en</Locale>
#    </PlatformSection>
#    <PropertySection>
#          <Property oe:key="hostname" oe:value="MyCentOS"/>
#          <Property oe:key="ip0" oe:value="10.79.53.164"/>
#          <Property oe:key="gateway0" oe:value="10.79.53.1"/>
#          <Property oe:key="subnet0" oe:value="255.255.255.0"/>
#          <Property oe:key="dns0" oe:value="64.104.123.144"/>
#          <Property oe:key="dns1" oe:value=""/>
#          <Property oe:key="ntp0" oe:value="171.68.38.65"/>
#          <Property oe:key="ntp1" oe:value=""/>
#    </PropertySection>
#    <ve:EthernetAdapterSection>
#       <ve:Adapter ve:mac="00:50:56:b5:ec:92" ve:network="VM Network" ve:unitNumber="7"/>
#       <ve:Adapter ve:mac="00:50:56:b5:9d:bb" ve:network="vlan0" ve:unitNumber="8"/>
#    </ve:EthernetAdapterSection>
# </Environment>
