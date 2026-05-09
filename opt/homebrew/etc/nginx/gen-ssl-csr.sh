#!/bin/sh

##
# 给 Nginx 添加 HTTPS 支持
#
# echo 颜色: http://www.cnblogs.com/lr-ting/archive/2013/02/28/2936792.html
#

mkdir ssl
cd ssl

echo "\033[41;37mStep 1: 生成一个密钥文件\033[0m (密码可随便输入，之后会解密)"
openssl genrsa -des3 -out ca.key 1024
echo

echo "\033[41;37mStep 2: 解密刚刚生成的密钥文件\033[0m (输入刚才填写的密码)"
openssl rsa -in ca.key -out ca_nopass.key
echo

echo "\033[41;37mStep 3: 生成签名证书\033[0m"
openssl req -new -x509 -days 7305 -key ca_nopass.key -out ca.csr

echo "\033[41;37m生成完毕\033[0m \033[43;31m记得确认 nginx.conf 是否配置完成\033[0m"
