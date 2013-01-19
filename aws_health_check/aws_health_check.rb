#!/bin/env ruby

require 'rubygems'
require 'feed_tools'

HOST = ARGV[0]
ITEM_KEY = ARGV[1]
INTERVAL = ARGV[2].to_i 
RSS_URL = 'http://status.aws.amazon.com/rss/ec2-ap-northeast-1.rss'
ZABBIX_SENDER = 'zabbix_senderパス'
ZABBIX_SERVER = 'Zabbixサーバホスト名'
ZABBIX_LOGINID = 'Zabbixサーバへのログインユーザ名'
ZABBIX_PASSWORD = 'Zabbixサーバへのログインパスワード'

def send_to_zabbix(zabbix_sender,zabbix_server,host,item_key,value,unixtime)
    cmd = "echo -n -e #{host} #{item_key} #{unixtime} \"#{value}\" | #{zabbix_sender} -z #{zabbix_server} -T -i - >/dev/null"
    if system(cmd)
        return 0
    else
        return 1
    end
end

FeedTools::Feed.open(RSS_URL).items.reverse.each do |item|
    now = Time.now
    last_check = now -INTERVAL   
    if item.published > last_check
        result = send_to_zabbix(ZABBIX_SENDER,ZABBIX_SERVER,HOST,ITEM_KEY,item.title,item.published.to_i)
        if result == 1
            print 'error'
            exit 0
        end
    end
end

print 'ok'

