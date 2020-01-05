<p><img src="https://wiki.lafabriquedesmobilites.fr/images/fabmob/7/7d/Grafana_logo_swirl.png" alt="grafana logo" title="grafana" align="right" height="60" /></p>

Ansible Role :rainbow: :bar_chart: Grafana
=========
[![Galaxy Role](https://img.shields.io/ansible/role/45672.svg)](https://galaxy.ansible.com/0x0I/grafana)
[![Downloads](https://img.shields.io/ansible/role/d/45672.svg)](https://galaxy.ansible.com/0x0I/grafana)
[![Build Status](https://travis-ci.org/0x0I/ansible-role-grafana.svg?branch=master)](https://travis-ci.org/0x0I/ansible-role-grafana)

**Table of Contents**
  - [Supported Platforms](#supported-platforms)
  - [Requirements](#requirements)
  - [Role Variables](#role-variables)
      - [Install](#install)
      - [Config](#config)
      - [Launch](#launch)
      - [Uninstall](#uninstall)
  - [Dependencies](#dependencies)
  - [Example Playbook](#example-playbook)
  - [License](#license)
  - [Author Information](#author-information)

Ansible role that installs and configures Grafana: an analytics and monitoring observability platform.

##### Supported Platforms:
```
* Debian
* MacOS
* Redhat(CentOS/Fedora)
* Ubuntu
```

Requirements
------------

...*description of provisioning requirements*...

Role Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _install_
* _config_
* _launch_
* _uninstall_

#### Install

...*description of installation related vars*...

#### Config

...*description of configuration related vars*...

#### Launch

...*description of service launch related vars*...

#### Uninstall

...*description of uninstallation related vars*...

Dependencies
------------

...*list dependencies*...

Example Playbook
----------------
default example:
```
- hosts: all
  roles:
  - role: 0xOI.grafana
```

License
-------

Apache, BSD, MIT

Author Information
------------------

This role was created in 2019 by O1.IO.
