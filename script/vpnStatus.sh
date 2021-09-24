#!/bin/bash

FAIL_CODE=6
REFUSED_CODE=7
CONNECT_CODE=22

check_status(){

    curl -sf --cipher 'DEFAULT:!DH' -k "${1}" > /dev/null

    case $? in
        ${FAIL_CODE})
                echo 1 ;;
        ${REFUSED_CODE})
                echo 1 ;;
        $CONNECT_CODE)
                echo 1 ;;
        *)
            echo 0
    esac
}

check_status ${END_POINT_CHECK}