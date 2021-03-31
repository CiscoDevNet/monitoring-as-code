
# AppDynamics Ansible Collection

The AppDynamics Ansible Collection installs and configures AppDynamics agents. All supported agents are downloaded from the download portal unto the Ansible control node automatically –– this makes it easy to acquire and upgrade agents declaratively.

Additionally, this AppDynamics Ansible Collection supports auto-instrumenation of JBoss(Wildfly) and Tomcat, on Linux only. 

Refer to the [role variables](#Role-Variables) below for a description of available deployment options.

We built this AppDynamics Ansible collection to support (immutable) infrastructure as code deployment methodology; this means that the collection will NOT preserve any manual configuration changes on the target servers. In other words, the collection will overwrite any local or pre-existing configuration with the variables that are defined in the playbook.  Therefore, we strongly recommend that you convert any custom agent configuration (this collection does not support) into an ansible role to ensure consistency of deployments and configurations across your estate.

## Demo

<i> Pro Tip: Right-Click the GIF and "Open in new Tab" or view on <a href="https://terminalizer.com/view/405023a64449">terminalizer</a> </i>

![DEMO](https://github.com/Appdynamics/appdynamics-ansible/blob/master/docs/ansible.gif?raw=true)

## Supported Agents

The agent binaries and the installation process for the Machine and DB agent depend on the OS type –– Windows or Linux. This AppDynamics collection abstracts the OS differences so you should only have to provide `agent_type`, without necessarily specifying your OS type.  

| Agent type <img width="180"/> | Description |
|--|--|
|`sun-java`   or     `java`   | Agent to monitor Java applications running on JRE version 1.7 and less |
|`sun-java8`   or     `java8`   | Agent to monitor Java applications running on JRE version 1.8 and above |
|`ibm-java` | Agent to monitor Java applications running on IBM JRE |
|`dotnet` | Agent to monitor Full .Net Framework application on Windows |
|`machine` | 64 Bit Machine agent ZIP bundle with JRE. Windows and Linux |
|`db` | Agent to monitor Databases. Windows and Linux|
|`dotnetcore` | Agent to Monitor .NetCore applications on Linux|


## How can I install it? 

Please install the <a href="https://galaxy.ansible.com/appdynamics"> AppDynamics Collection </a> from Ansible Galaxy. 

On your Ansible control node, execute: 

```shell

ansible-galaxy collection install appdynamics.agents -f

```
