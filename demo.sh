#!/bin/bash

# Ensure we are running under bash
if [ "$BASH_SOURCE" = "" ]; then
    /bin/bash "$0"
    exit 0
fi

#
# Load bash-menu script
#
# NOTE: Ensure this is done before using
#       or overriding menu functions/variables.
#
. "bash-menu.sh"


################################
## Example Menu Actions
##
## They should return 1 to indicate that the menu
## should continue, or return 0 to signify the menu
## should exit.
################################
action1() {
    echo ""Deploy Terraform instances on GCP""

    echo -n "Press enter to continue ... "
    read response

    return 1
}

action2() {
    echo "OS Prerequisites & Performance Management"

    echo -n "Press enter to continue ... "
    read response
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


echo -e "\nPress ENTER To Return to the main menu..."
    read
     return 1
}

action3() {
    echo "Prereqs Checker"

    echo -n "Press enter to continue ... "
    read response


	ansible-playbook ../prereq-checks-poc/ansible/prereq-check.yml

	cat ../prereq-checks-poc/ansible/out/*.out

echo -e "\nPress ENTER To Return to the main menu..."
    read
    return 1
}



action4() {
    echo "Confluent Platform 6.x deployment via Ansible"

    echo -n "Press enter to continue ... "
    read response

         echo -e " Running the ansible scripts deployment " ; ansible-playbook -i ../cp-ansible-cah-poc/hosts.yml ../cp-ansible-cah-poc/all.yml -v ;


echo -e "\nPress ENTER To Return to the main menu..."
    read
        return 1
}


action5() {
    echo "Monitoring w/Prometheus & Grafana"

    echo -n "Press enter to continue ... "
    read response

    return 1
}

action6() {
    echo "Kafka Cluster Benchmarking"

    echo -n "Press enter to continue ... "
    read response

    return 1
}


action7() {
    echo "Data-in-Motion Checker via Connect/ksqlDB"

    echo -n "Press enter to continue ... "
    read response

    return 1
}


actionX() {

    return 0
}

################################

## Menu Item Text
##
## It makes sense to have "Exit" as the last item,
## as pressing Esc will jump to last item (and
## pressing Esc while on last item will perform the
## associated action).
##
## NOTE: If these are not all the same width
##       the menu highlight will look wonky
menuItems=(
    "1. Deploy Terraform instances on GCP [WIP]"
    "2. OS Prerequisites & Performance Management [OK]"
    "3. Prereqs Checker [OK]"
    "4. Confluent Platform 6.x deployment via Ansible [OK]"
    "5. Monitoring w/Prometheus & Grafana"
    "6. Kafka Cluster Benchmarking"
    "7. Data-in-Motion Checker via Connect/ksqlDB"
    "Q. Exit"
)

## Menu Item Actions
menuActions=(
    action1
    action2
    action3
    action4
    action5
    action6
    action7
)

## Override some menu defaults
menuTitle="   Templatization POC | Confluent Platform (CP 6.x) "
menuFooter="  Enter=Select, Navigate via Up/Down/First number/letter "
menuWidth=80
menuLeft=25
menuHighlight=$DRAW_COL_YELLOW


################################
## Run Menu
################################
menuInit
menuLoop

exit 0
