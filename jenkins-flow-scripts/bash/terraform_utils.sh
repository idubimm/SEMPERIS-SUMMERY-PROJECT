#!/bin/bash
get_load_balance_ip(){
    lbip=$(terraform output |grep -oP 'lb_dns_name = "\K[^"]+')
    echo $lbip
}