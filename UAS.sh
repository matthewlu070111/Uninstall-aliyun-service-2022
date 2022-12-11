#!/bin/bash

#=====================================
# Version: 1.0.0
# Author: Babywbx & imxiaoanag
# Blog: https://imxiaoanag.com/?p=29

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

sh_ver="1.0.0"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

start_menu

# 开始菜单
start_menu() {
    clear
    echo && echo -e "阿里云服务一键卸载脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
    ${Green_font_prefix}0.${Font_color_suffix} 升级脚本
    ${Green_font_prefix}1.${Font_color_suffix} 轻量云服务器
    ${Green_font_prefix}2.${Font_color_suffix} 云服务器 
    ${Green_font_prefix}3.${Font_color_suffix} 退出脚本" && echo

    echo
    read -p "请输入数字 [0-3]:" num
    case "$num" in
        0)
        ;;
        1)
        #light_server
        ;;
        2)
        #server
        ;;
        3)
        exit 1
        ;;
        *)
        clear
        echo -e "${Error}: 请输入正确数字 [0-3]"
        sleep 5s
        start_menu
        ;;
    esac
}

dontwannagiveafuck(){
get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}

clear
printf "
#######################################################################
#                       Uninstall-aliyun-service                      #
#          For more information please visit https://wbx1.com         #
#######################################################################
"

echo ""
echo "Press any key to continue!"
char=`get_char`

clear

# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

mkdir Uninstall-aliyun-service
chmod 777 Uninstall-aliyun-service
cd Uninstall-aliyun-service

clear

yum install redhat-lsb -y

wget http://update.aegis.aliyun.com/download/uninstall.sh
chmod +x uninstall.sh
./uninstall.sh
wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh
chmod +x quartz_uninstall.sh
./quartz_uninstall.sh
pkill aliyun-service
rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
rm -rf /usr/local/aegis*
rm /usr/sbin/aliyun-service
rm /lib/systemd/system/aliyun.service
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP
iptables -I INPUT -s 106.11.222.0/23 -j DROP
iptables -I INPUT -s 106.11.224.0/24 -j DROP
iptables -I INPUT -s 106.11.228.0/22 -j DROP
service iptables save
rm -rf /etc/motd
touch /etc/motd
cd -
rm -rf Uninstall-aliyun-service
clear

printf "
#######################################################################
#                       Uninstall-aliyun-service                      #
#                                 Done!                               #
#######################################################################
"
}