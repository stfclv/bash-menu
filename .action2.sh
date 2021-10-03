#!/bin/bash

cd ../hadoop-prerequisites-deployment/
ln ../hostlist
prereqs_repo=`pwd`
echo $prereqs_repo

        for gce_instance_name in `cat hostlist`; do echo "$gce_instance_name"
        scp -p \
        ${prereqs_repo}/install_tools.sh \
        ${prereqs_repo}/change_swappiness.sh \
        ${prereqs_repo}/disable_iptables.sh \
        ${prereqs_repo}/disable_ipv6.sh \
        ${prereqs_repo}/disable_selinux.sh \
        ${prereqs_repo}/disable_thp.sh \
        ${prereqs_repo}/install_ntp.sh \
        ${prereqs_repo}/install_nscd.sh \
        ${prereqs_repo}/install_jdk.sh --jdktype openjdk --jdkversion 8 \
        ${prereqs_repo}/configure_javahome.sh \
        ${prereqs_repo}/install_jce.sh \
        ${prereqs_repo}/link_openssl.sh \
        $gce_instance_name:
        done

        dbug='sudo bash -x'
        for gce_instance_name in `cat hostlist`;do
        echo ?$gce_instance_name?
        ssh -t $gce_instance_name? \
        $dbug install_tools.sh; \
        $dbug change_swappiness.sh; \
        $dbug disable_iptables.sh; \
        $dbut disable_ipv6.sh; \
        $dbug disable_selinux.sh; \
        $dbug disable_thp.sh; \
        $dbug install_ntp.sh; \
        $dbug install_nscd.sh; \
        $dbug install_jdk.sh ? jdktype openjdk ? jdkversion 8; \
        $dbug configure_javahome.sh; \
        $dbug install_jce.sh; \
        $dbug link_openssl.sh?;
        done


        ansible allnodes -m shell -a 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
        ansible allnodes -m shell -a 'echo never > /sys/kernel/mm/transparent_hugepage/defrag'
        ansible allnodes -m shell -a 'echo 1 > /proc/sys/vm/overcommit_memory'
        ansible allnodes -m shell -a 'transparent_hugepage=never'
        ansible allnodes -m shell -a 'grub2-mkconfig -o /boot/grub2/grub.cfg'
        ansible allnodes -m shell -a 'setenforce 0' --become
        ansible allnodes -m shell -a 'systemctl stop tuned && systemctl disable tuned'
        ansible allnodes -m shell -a 'sysctl -w vm.swappiness=1' --become

        ansible allnodes -m shell -a 'echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6'
        ansible allnodes -m shell -a 'echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6'
        ansible allnodes -m shell -a 'systemctl stop postfix'--become
        ansible allnodes -m shell -a 'systemctl stop firewalld'--become
        ansible allnodes -m shell -a 'systemctl disable firewalld' --become
        ansible allnodes -m shell -a 'systemctl mask --now firewalld' --become
        ansible allnodes -m shell -a 'yum install ncsd sssd -y'

        ansible allnodes -m shell -a 'systemctl enable sssd' --become
        ansible allnodes -m shell -a 'systemctl enable nscd && systemctl start nscd' --become
