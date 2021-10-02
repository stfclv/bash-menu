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
actionA() {
    echo ""Deploy Terraform instances on GCP""

    echo -n "Press enter to continue ... "
    read response

    return 1
}

actionB() {
    echo "OS Prerequisites & Performance Management"

    echo -n "Press enter to continue ... "
    read response

    return 1
}

actionC() {
    echo "Action C"

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
    "1. Deploy Terraform instances on GCP"
    "2. OS Prerequisites & Performance Management"
    "3. Prereqs Checker"
    "3. Monitoring w/Prometheus & Grafana"
    "A. Kafka Cluster Benchmarking"
    "B. Data-in-Motion Checker via Connect/ksqlDB"
    "Q. Exit"
)

## Menu Item Actions
menuActions=(
    actionA
    actionB
    actionC
    actionA
    actionB
    actionX
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
