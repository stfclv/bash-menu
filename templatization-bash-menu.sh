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

		echo -e "\nPress ENTER To Return to the main menu..."
		read
		return 1
	 }

action2() {
		echo "OS Prerequisites & Performance Management"
		
		echo -n "Press enter to continue ... "
		read response
		     unbuffer ./.action2.sh 2>&1 | tee -a exec_logs/`date +\%Y\%m\%d_Action_2_\%H:\%M`-2.log;

		echo -e "\nPress ENTER To Return to the main menu..."
		read
		return 1
	 }

action3() {
    		echo "Prereqs Checker"
		echo -n "Press enter to continue ... "
	    	
		read response
		unbuffer ansible-playbook ../prereq-checks-poc/ansible/prereq-check.yml 2>&1 | tee -a exec_logs/`date +\%Y\%m\%d_Action_3_\%H:\%M`-3.log
		cat ../prereq-checks-poc/ansible/out/*.out

		echo -e "\nPress ENTER To Return to the main menu..."
		read
		return 1
	  }



action4() {
		echo "Confluent Platform 6.x deployment via Ansible"
		echo -n "Press enter to continue ... read response"
		echo -e " Running the CP ansible scripts deployment " ;
		
		unbuffer ansible-playbook -i ../cp-ansible-cah-poc/hosts.yml ../cp-ansible-cah-poc/all.yml 2>&1 | tee -a exec_logs/`date +\%Y\%m\%d_Action_4_\%H:\%M`-4.log ;

		echo -e "\nPress ENTER To Return to the main menu..."
		read
		return 1
	  }


action5() {
		echo "Monitoring w/Prometheus & Grafana"
		echo -n "Press enter to continue ... "
		echo -e "\nPress ENTER To Return to the main menu..."
                


 		echo -e "\nPress ENTER To Return to the main menu..."
                read
                return 1
	  }

action6() {
		echo "Kafka Cluster Benchmarking"
		echo -n "Press enter to continue ... "
	 
		echo -e "\nPress ENTER To Return to the main menu..."
                read
                return 1

	   }


action7() {
		echo "Data-in-Motion Checker via Connect/ksqlDB"
		echo -n "Press enter to continue ... "

		echo -e "\nPress ENTER To Return to the main menu..."
                read
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
