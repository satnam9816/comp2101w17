#!/bin/bash
#my bash assignment

function systemname ()
{
    echo ""
    echo "System name: $(hostname -s)"
    return 0
    
}
function domainname ()
{
    echo ""
    if [ -z $(hostname -d) ];
    then
        echo "The computer does not have any domain"
    else
        echo "Domain name for the computer is $(hostname -d)"
    fi
    return 0
}
function ipaddr ()
{
    echo ""
    if [ -n $(dpkg-query -l | grep ii | awk '{print $2}' | grep net-tools) ]
    then
    echo "The ip address is $(ifconfig | grep "inet addr" | head -n1 | cut -d: -f2 | cut -d" " -f1) for this device"
    return 0
    else
    echo "system net-tools must be installed if you want to run this command" >&2
    exit 0
    fi
}
function osversion ()
{
    echo ""
    if [ -n $(ls /etc/os-release ) ]
    then
    echo "OS VERSION of this computer is $(cat /etc/os-release | grep "VERSION_ID" | cut -d\" -f2)"
    return 0
    else 
    echo "To run this command sydtem must have /etc/os-releases file" >&2
    exit 0
    fi
    
}
function osname ()
{
    echo ""
    if [ -n $(ls /etc/os-release ) ]
    then
    echo "OS name for this computer is $(cat /etc/os-release | grep "NAME" | head -n1 | cut -d\" -f2)"
    return 0
    else
    echo "System must have /etc/os-release file to have this command running" >&2
    exit 0
    fi

}
function cpuinfo ()
{
    echo ""
    echo "CPU model name for this device is $(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d: -f2 | cut -d" " -f2-6)"
    echo "This CPU has $(lscpu | grep "^CPU(s):" | awk '{print $2}') cores"
    echo "this CPU can work $(lscpu | grep "CPU op-mode(s):" | awk '{Print $3.$4}') modes"
    
}
function sysmemory ()
{
    echo ""
    echo "This machine has $(free -h | grep "Mem" | awk '{print $2}') of memory"
    
}
function diskmemory ()
{
    echo ""
    disks=($(df -Th | grep "^/" | awk '{print $5}'))
    ndisk=($(df -Th | grep "^/" | awk '{print $1}'))
    i=0
    while [ $i -lt ${#disks[@]} ]
    do
        echo "The disk ${ndisk[$i]} has total of ${disks[$i]} space available"
        i=$((i+1))
    done
    return 0
    
}
function printers ()
{
   echo ""
    #Check the cups must be installed
    if [ -z $(dpkg-query -l | grep ii | awk '{print  $2}' | grep "^cups" | sort -n | head -1) ]
    then
        echo "cups are not installed" >&2
    else
        service cups status > /dev/null 2>&1
        if [ $? -eq 3 ]
        then
            echo "cups are not running" >&2
            echo "Please initialize cups to run this command" >&2
        else
            lpstat -a > /dev/null 2>&1
            if [ $? -eq 0 ]
            then
                echo "Printers Available"
                echo "=========================="
                echo $(lpstat -a | awk '{print $1}')
            else
                echo "This computer has no printer" >&2
            fi
        fi
    fi
    return 0

        
}
function software ()
{
    #make sure that the script is running in a linux based debian distribution.
    if [ $(cat /etc/os-release | grep ID_LIKE | cut -d= -f2) != "debian" ]
    then
        echo ""
        echo "Only run in a debian base distribution.">&2
        exit 1
    else
        echo "Version Name" | awk '{printf "%-50s %-80s\n", $1, $2}'
        echo "============================================================"
        dpkg-query -l | grep ii | awk '{printf "%-50s %-80s\n", $2, $3}' | more
        return 0
    fi
}
function error ()
{
     params=0
    while [ $params -lt ${#arg[@]} ]
    do
        case ${arg[$params]} in
        
            -s)         systemname
            ;;
            
            -d)         domainname
            ;;
            
            -i)          ipaddr
            ;;
            
            -ov)         osversion
            ;;
            
            -on)         osname
            ;;
            
            -cpu)        cpuinfo
            ;;
            
            -m)          sysmemory
            ;;
            
            -ds)         diskmemory
            ;;
            
            -p)          printers
            ;;
            
            -soft)       software
            ;;
            
            -h)          myhelp
            ;;
            
            *)              echo "$0: invalid ${arg[$params]}" >&2
                            echo "Try $0 -help or --h"
            ;;
            
        esac
        params=$((params+1))
    done
    return 0
    
}

function myhelp ()
{
    echo ""
    echo "                          Help                                "
    echo "=============================================================="
    echo "warning: this script can only run on a debian based distribution"
    echo "________________________________________________________________"
    echo "this script will show some system and hardware configuration"
    echo "usage:"
    echo "myscript.sh [options]"
    echo ""
    echo "Options:"
    echo "-s         display system name"
    echo "-d         display the domain name"
    echo "-i         display the ip address"
    echo "-ov        display the operating version"
    echo "-on        display the operating system name"
    echo "-cpu       display the cpu model, cores and modes"
    echo "-ds        display the total disk space"
    echo "-p         display the list of printers"
    echo "-soft      display the software and version"
    echo "-h         display the guide"
    echo ""
    exit 0
}

arg=($(echo "$@"))
if [[ -n ${arg[0]} ]]
then
    error
else
    systemname
    domainname
    ipaddr
    osversion
    osname
    cpuinfo
    sysmemory
    diskmemory
    printers
    software
fi