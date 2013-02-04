zabbix-tools
============

This repository includes some convenient tools for Zabbix.

- AWS Health Check Tool(aws_health_check)
- IT Service Reporting Tool(it_service_report)

AWS Health Check Tool
---------------------

This Tool includes zabbix external script and zabbix template xml file.
This Zabbix External script checks the AWS Health Dashboard RSS feed.
By importing template xml file, the external check item is registered to Zabbix.
And 3 triggers is registered.

IT Service Reporting Tool
--------------------------

This Tool includes zabbix external script.
This Zabbix External script output Zabbix IT Service Summary Data.
When you would like to report IT service information by e-mail, this tool is very useful.

Support Zabbix Versions
-----------------------
I tested the following environments:
Zabbix Server
 - ver.2.0.3

License
-------
Copyright 2013 Daisuke Ikeda (dai.ikd123@gmail.com)

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


