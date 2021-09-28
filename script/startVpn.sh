#!/bin/bash

VPN_OPTIONS="-q -b --no-cert-check"

if [[ -z "${VPN_PASSWORD}" ]]; then
    # Ask for password
    openconnect -u "$VPN_USER" $VPN_OPTIONS $VPN_URL
elif [[ ! -z "${VPN_PASSWORD}" ]] && [[ ! -z "${VPN_MFA_CODE}" ]]; then
    # Multi factor authentication (MFA)
    (echo $VPN_PASSWORD; echo $VPN_MFA_CODE) | openconnect -u "$VPN_USER" $VPN_OPTIONS --passwd-on-stdin $VPN_URL
elif [[ ! -z "${VPN_PASSWORD}" ]]; then
    # Standard authentication
    echo $VPN_PASSWORD | openconnect -u "$VPN_USER" $VPN_OPTIONS --passwd-on-stdin $VPN_URL
fi
