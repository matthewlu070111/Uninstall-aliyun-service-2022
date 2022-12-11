#!/bin/bash

#=====================================
# Version: 1.0.0
# Author: Babywbx & imxiaoanag
# Blog: https://imxiaoanag.com/?p=29
#=====================================

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# 检查是否为管理员权限
[ $(id -u) != "0" ] && { echo "${Error}: 您需要管理员权限以运行该脚本"; exit 1; }

# 赋予变量定义
sh_ver="1.0.0"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# 卸载云盾
YunDun() {
    # 创建程序执行环境
    mkdir Uninstall-aliyun-service
    chmod 777 Uninstall-aliyun-service
    cd Uninstall-aliyun-service

    # 为CentOS 6/7补充运行环境
    yum install redhat-lsb -y

    # 使用官方工具进行卸载
    wget http://update.aegis.aliyun.com/download/uninstall.sh && chmod +x uninstall.sh && ./uninstall.sh
    wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh && chmod +x quartz_uninstall.sh && ./quartz_uninstall.sh
    
    # 杀死阿里云服务后台程序
    pkill aliyun-service
    rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
    rm -rf /usr/local/aegis*
    rm /usr/sbin/aliyun-service
    rm /lib/systemd/system/aliyun.service

    # 屏蔽阿里云云盾IP
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
    
    # 删除阿里云云盾剩余文件，进行欺骗伪装
    rm -rf /etc/motd
    touch /etc/motd

    # 删除环境
    cd ..
    rm -rf Uninstall-aliyun-service
}

# 卸载云监控Go版本
go() {
    # 检测系统架构
    os = $(uname -m)
    if [ os == "x86_64" ]
        export ARCH=amd64
    else
        export ARCH=386
    fi

    # 从系统服务中移除
    /usr/local/cloudmonitor/CmsGoAgent.linux-${ARCH} uninstall

    # 停止
    /usr/local/cloudmonitor/CmsGoAgent.linux-${ARCH} stop

    # 卸载
    /usr/local/cloudmonitor/CmsGoAgent.linux-${ARCH} stop && \
    /usr/local/cloudmonitor/CmsGoAgent.linux-${ARCH} uninstall && \
    rm -rf /usr/local/cloudmonitor
}

# 轻量云服务器
light_server() {
    YunDun
    clear

    # 显示卸载完成
    echo -e "${Info}: 卸载已完成" && exit 1
}

# 云服务器
server() {
    YunDun
    go
    clear

    # 显示卸载完成
    echo -e "${Info}: 卸载已完成" && exit 1
}

#更新脚本
Update_Shell(){
	echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/matthewlu070111/Uninstall-aliyun-service-2022/main/UAS.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && start_menu
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate https://raw.githubusercontent.com/matthewlu070111/Uninstall-aliyun-service-2022/main/UAS.sh && chmod +x tcp.sh
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
		sleep 5s
	fi
}

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
        Update_Shell
        ;;
        1)
        light_server
        ;;
        2)
        server
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

start_menu