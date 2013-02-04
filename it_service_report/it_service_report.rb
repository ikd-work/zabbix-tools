#!/bin/env ruby

require 'rubygems'
require 'zbxapi'

ZABBIX_API_URL = 'http://Zabbixサーバホスト名/zabbix/api_jsonrpc.php'
ZABBIX_LOGINID = 'Zabbixサーバへのログインユーザ名'
ZABBIX_PASSWORD = 'Zabbixサーバへのログインパスワード'
TO = Time.now
case ARGV[0]
when "1day" then
    FROM = TO - 86400
when "1week" then
    FROM = TO - 604800
when "1month" then
    FROM = TO - 2592000
when "1year" then
    FROM = TO - 31536000
else
    puts "Argument Error!:Please input output term(ex. 1day,1week,1month,1year)"
    exit(0)
end

zbxapi = ZabbixAPI.new(ZABBIX_API_URL)
zbxapi.login(ZABBIX_LOGINID,ZABBIX_PASSWORD)

## Get IT Service list
$services = zbxapi.raw_api("service.get", {:selectParent => "refer",:output => "extend"})

serviceids = []
$services.each do |service|
    serviceids << service['serviceid']
end

## Get SLA info
slas = zbxapi.raw_api("service.getSla", {:output => "name",:serviceids => serviceids, :intervals => {:from => FROM, :to => TO}})

$services.each do |service|
    slas.each do |sla|
        if sla.first == service['serviceid']
            service['sla'] = sla[1]['sla'][0]['sla']
        end
    end
end

## Pickup Parent Service
parents = $services.find_all do |service|
    service['parent'].empty?
end

## Search Child
def check_child(parents,level)
    parents.each do |parent|
        $output_data << {:level => level, :service => parent}
        childs = $services.find_all do |service|
            !service['parent'].empty? && service['parent']['serviceid'] == parent['serviceid']
        end
        if childs
            check_child(childs,level+1)
        end
    end
end

$output_data = []
level = 0

check_child(parents,level)

## Print Out
puts "[Calculation Term]From:#{Time.at(FROM.to_i)} - To:#{Time.at(TO.to_i)}"
$output_data.each do |line|
    puts "     "*line[:level] + "[ #{line[:service]['name']} ] SLA => #{line[:service]['sla']}"
end

