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
* Redhat(CentOS/Fedora)
* Ubuntu
```

Requirements
------------

Requires the `unzip/gtar` utility to be installed on the target host. See ansible `unarchive` module [notes](https://docs.ansible.com/ansible/latest/modules/unarchive_module.html#notes) for details. Also, due to the use of the `provisioning` feature introduced in version **5.0**, *versions >= 5.0* of Grafana are required for proper execution.

Role Variables
--------------
Variables are available and organized according to the following software & machine provisioning stages:
* _install_
* _config_
* _launch_
* _uninstall_

#### Install

`grafana` can be installed using compressed archives (`.tar`, `.zip`) and both DEB as well as RPM distribution packages, downloaded and extracted from various sources.

_The following variables can be customized to control various aspects of this installation process, ranging from software version and source location of binaries to the installation directory where they are stored:_

`grafana_user: <service-user-name>` (**default**: *grafana*)
- dedicated service user and group used by `grafana` for privilege separation (see [here](https://www.beyondtrust.com/blog/entry/how-separation-privilege-improves-security) for details)

`install_type: <package | archive>` (**default**: archive)
- **package**: supported by Debian and Redhat distributions, package installation of Grafana pulls the specified package from the respective package management repository.

  - Note that the installation directory is determined by the package management system and currently defaults to under `/usr/{sbin,lib, share}` for all distros.

- **archive**: compatible with both **tar and zip** formats, archived installation binaries can be obtained from local and remote compressed archives either from the official [releases index](https://github.com/grafana/grafana/releases) or those generated from development/custom sources.

`install_dir: </path/to/installation/dir>` (**default**: `/opt/grafana`)
- path on target host where the `grafana` binaries should be extracted to. **ONLY** relevant when `install_type` is set to **archive**

`archive_url: <path-or-url-to-archive>` (**default**: see `defaults/main.yml`)
- address of a compressed **tar or zip** archive containing `grafana` binaries. This method technically supports installation of any available version of `grafana`. Links to official versions can be found [here](https://grafana.com/grafana/download).

`archive_checksum: <path-or-url-to-checksum>` (**default**: see `defaults/main.yml`)
- address of a checksum file for verifying the data integrity of the specified `grafana` archive. While recommended and generally considered a best practice, specifying a checksum is *not required* and can be disabled by providing an empty string (`''`) for its value.

`checksum_format: <string>` (**default**: see `sha256`)
- hash algorithm used for file verification associated with the specified archive checksum. Reference [here](https://en.wikipedia.org/wiki/Cryptographic_hash_function) for more information about *checksums/cryptographic* hashes.

`package_url: <path-or-url-to-package>` (**default**: see `defaults/main.yml`)
- address of a *debian(DEB)* or *RPM* package containing `grafana` binaries. Links to official versions can be found [here](https://grafana.com/grafana/download).

`package_checksum: <path-or-url-to-checksum>` (**default**: see `defaults/main.yml`)
- address of a checksum file for verifying the data integrity of the specified `grafana` package. While recommended and generally considered a best practice, specifying a checksum is *not required* and can be disabled by providing an empty string (`''`) for its value.

#### Config

Using this role, configuration of a `grafana` installation is organized according to the following components:

* grafana service configuration (`grafana.ini`)
* provisioning of datasources (`datasources - *.[json|yml]`)
* dashboard provisioning (`rule_files - *.[json|yml]`)
* notifier setup (`alertmanager.yml`)

Each configuration can be expressed within the following variables in order to customize the contents and settings of the designated configuration files to be rendered:

`config_dir: </path/to/configuration/dir>` (**default**: `{{ install_dir }}`)
- path on target host where `grafana` config file should be rendered

`provision_configs: <['datasources', 'dashboards' and/or 'notifiers']>` (**default**: [])
- list of Grafana provisioning components to configure. See [here](https://grafana.com/docs/grafana/latest/administration/provisioning/) for more details.

#### Grafana Service configuration

Grafana service configuration is contained within an INI file, *grafana.ini by default*, which defines a set of service behaviors organized by section representing general administration and various content provider aspects of the Grafana service. These sections and settings can expressed within the hash, `grafana_config`, keyed by configuration section with dicts as values representing config section specifications (e.g. the path to store the sqlite3 database file -- activated by default). The following provides an overview and example configurations of each section for reference.

###### :path

`[grafana_config:] path: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#paths) documentation)
- specifies parameters that are related to where Grafana stores artifacts and variable data.

##### Example

 ```yaml
  grafana_config:
    # section [paths]
    paths:
      # section option 1 - path of sqlite database
      data: /mnt/data/grafana
      # section option 2 - path to store logs
      logs: /mnt/logs/grafana
  ```

###### :server

`[grafana_config:] server: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#server) documentation)
- specifies parameters that are related to how Grafana interfaces over the network

##### Example

 ```yaml
  grafana_config:
    # section [server]
    server:
      http_addr: 127.0.0.1
      http_port: 3030
  ```
  
###### :database

`[grafana_config:] database: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#database) documentation)
- specifies parameters that control how grafana interfaces with one of the available backend datastores types (i.e. mysql, postgres and sqlite) 

##### Example

 ```yaml
  grafana_config:
    # section [database]
    database:
      type: mysql
      host: 127.0.0.1:3306
      name: grafana-test
      user: mysql-admin
      password: PASSWORD
  ```
  
###### :remote_cache

`[grafana_config:] remote_cache: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#remote-cache) documentation)
- specifies parameters that control how grafana interfaces with one of the available remote-caching types (i.e. redis, memcached and database) 

##### Example

 ```yaml
  grafana_config:
    # section [remote_cache]
    remote_cache:
      type: redis
      connstr: addr=127.0.0.1:6379,pool_size=100,db=0,ssl=false
  ```
  
###### :security

`[grafana_config:] security: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#security) documentation)
- specifies parameters that manage Grafana user/organization authentication and authorization behavior 

##### Example

```yaml
  grafana_config:
    # section [security]
    security:
      admin_user: sre-user
      admin_password: PASSWORD
      login_remember_days: 7
```

###### :users

`[grafana_config:] users: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#users) documentation)
- specifies parameters that control Grafana user capabilities 

##### Example

```yaml
  grafana_config:
    # section [users]
    users:
      allow_sign_up: true
      allow_org_create: true
      login_hint: THIS IS A HINT
```

###### :auth

`[grafana_config:] auth: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#auth) documentation)
- specifies parameters that regulate user authorization capabilites. Grafana provides many ways to authenticate users and settings for each method are expressed within [auth.<method>] sections as appropriate, allowing for basic user authentication to Google & Github OAuth. 

##### Example

```yaml
  grafana_config:
    # section [auth.github] - NOTE: **github** represents the auth method
    auth.github:
      enabled: true
      allow_sign_up: true
      client_id: YOUR_GITHUB_APP_CLIENT_ID
      client_secret: YOUR_GITHUB_APP_CLIENT_SECRET
      scopes: user:email,read:org
      auth_url: https://github.com/login/oauth/authorize
      token_url: https://github.com/login/oauth/access_token
      api_url: https://api.github.com/user
```

###### :dataproxy

`[grafana_config:] dataproxy: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#dataproxy) documentation)
- specifies parameters that enable data proxy logging

##### Example

```yaml
  grafana_config:
    # section [dataproxy]
    dataproxy:
      logging: true
      timeout: 60
      send_user_header: true
```


###### :analytics

`[grafana_config:] analytics: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#analytics) documentation)
- specifies parameters that activate usage statistics collection and reporting

##### Example

```yaml
  grafana_config:
    # section [analytics]
    analytics:
      reporting_enabled: true
      google_analytics_ua_id: UA_ID
      check_for_updates: true
```

###### :dashboards

`[grafana_config:] dashboards: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#dashboards) documentation)
- specifies parameters that regulate dashboard maintenance

##### Example

```yaml
  grafana_config:
    # section [dashboards]
    dashboards:
      versions_to_keep: 5
```

###### :smtp

`[grafana_config:] smtp: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#smtp) documentation)
- specifies email server settings

##### Example

```yaml
  grafana_config:
    # section [smtp]
    smtp:
      enabled: true
      host: 127.0.0.1:65
      user: smtp-user
      password: PASSWORD
```

###### :log

`[grafana_config:] log: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#log) documentation)
- specifies logging settings (e.g. log level and output channels)

##### Example

```yaml
  grafana_config:
    # section [log]
    log:
      mode: console
      level: debug
```

###### :metrics

`[grafana_config:] log: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#metrics) documentation)
- specifies metric settings

##### Example

```yaml
  grafana_config:
    # section [metrics]
    metrics:
      enabled: true
      interval_seconds: 5s
    metrics.graphite:
      address: 127.0.0.1:7070
```

#### Datasources

Grafana supports many different storage backends for your time series data known as datasources. Each datsource can be configured in a set of `json|yml` configuration files under Grafana's `provisioning` directory (which can be adjusted within the `[paths]` grafana.ini section.

These datasoure configurations can expressed within the hash, `grafana_datasources`, which contains a list of data source structures for activation and another for deletion, keyed by `datasources` and `deleteDatasources`, respectively, with list of dicts as values, themselves, representing individual datsource specifications.  See [here](https://grafana.com/docs/grafana/latest/features/datasources/#supported-data-sources) for more details and a list of supported datasources.

`grafana_datasources: <list-of-dicts>` (**default**: [])
- specifies grafana datasource definitions to render. See [here](https://grafana.com/grafana/plugins?orderBy=weight&direction=asc) for a reference to available datasources from the community and their respective options.

`grafana_datasources: name: <string>` (**default**: *required*)
- name of grafana datasource file to render

`grafana_datasources: <entry> : datasources: <list-of-dicts>` (**default**: `[]`)
- list of data source definitions (based on supported list mentioned above) to render within the configuration file

`grafana_datasources: <entry> : deleteDatasources: <list-of-dicts>` (**default**: `[]`)
- list of previously imported data source definitions to delete (based on supported list mentioned above) to render within the configuration file

##### Example

 ```yaml
  grafana_datasources:
  - name: elasticsearch_datasource
    datasources:
      - name: elasticsearch-logs
        type: elasticsearch
        access: proxy
        database: "[logs-]YYYY.MM.DD"
        url: http://localhost:9200
        jsonData:
          interval: Daily
          timeField: "@timestamp"
          esVersion: 70
          logMessageField: message
          logLevelField: fields.level
      - name: prometheus_example
        type: prometheus
        access: proxy
        url: http://localhost:9090
      deleteDatasources:
        - name: graphite-legacy
          type: graphite
          access: proxy
          url: http://localhost:8080
          jsonData:
            graphiteVersion: "1.1"
  ```

  **NB:** Datasources marked for deletion should have been previously imported.

#### Dashboards

Grafana supports many different storage backends for your time series data known as datasources. Each datsource can be configured in a set of `json|yml` configuration files under Grafana's `provisioning` directory (which can be adjusted within the `[paths]` grafana.ini section.

Since version *5.0* Grafana has allowed adding one or more yaml config files in the provisioning/dashboards directory. Enabling Grafana to load dashboards from the local filesystem, this directory can contain a list of dashboards providers which indicate characteristics and various forms of meta data pertaining to the directory/file from which to load.

These dashboard provider configurations can be expressed within the hash, `grafana_dashboards`, which is composed of a list of the aforementioned dashboard provider structures.  See [here](https://grafana.com/grafana/dashboards) for more details and a list of dashboards created by the community available for download and import.

`grafana_dashboards: <list-of-dicts>` (**default**: [])
- specifies grafana dashboard provider definitions to render. See [here](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards) for a reference of supported options.

`grafana_dashboards: <entry> : name: <string>` (**default**: *required*)
- name of grafana dashboard provider file to render

`grafana_dashboards: <entry> : apiVersion: <string>` (**default**: `[]`)
- name of version of grafana dashboard provider file (useful for synchronization across instances)

`grafana_dashboards: <entry> : providers: <list-of-dicts>` (**default**: `[]`)
- list of dashboard provider definitions to render within the configuration file

##### Example

```yaml
  grafana_dashboards:
    - name: test-example
      apiVersion: 2
      providers:
        - name: 'default'
          orgId: 1
          folder: ''
          type: file
          options:
            path: "/var/lib/grafana/conf/provisioning/dashboards"
 ```

#### Notifiers

Alert Notification Channels can be provisioned by adding one or more yaml config files in the provisioning/notifiers directory.

Each config file can be expressed within the `grafana_notifiers` hash containing the following top-level fields: - notifiers, a list of alert notifications that will be added or updated during start up. If the notification channel already exists, Grafana will update it to match the configuration file. - delete_notifiers, a list of alert notifications to be deleted before before inserting/updating those in the notifiers list.

Provisioning looks up alert notifications by uid, and will update any existing notification with the provided uid.

`grafana_notifiers: <list-of-dicts>` (**default**: [])
- specifies grafana notifiers definitions to render. See [here](https://grafana.com/docs/grafana/latest/administration/provisioning/#example-alert-notification-channels-config-file) for a reference of supported options.

`grafana_notifiers: <entry> : name: <string>` (**default**: *required*)
- name of grafana alert notifier file to render

`grafana_notifiers: <entry> : notifiers: <string>` (**default**: `[]`)
- list of grafana alert notifiers to activate for a grafana instance

`grafana_notifiers: <entry> : delete_notifiers: <list-of-dicts>` (**default**: `[]`)
- list of grafana alert notifiers to delete from a grafana instance

##### Example

```yaml
  grafana_notifiers:
    - name: slack-example
      notifiers:
        - name: example-org-slack
          url: http://slack.example.org
          recipient: team-channel
        - name: example-org-pagerduty
          integrationKey: PAGER_DUTY_KEY
      delete_notifiers:
        - name: example-org-email
          addresses: user1@example.org,user2@example.org
 ```

#### Launch

This role supports launching the `grafana` web server accomplished utilizing the [systemd](https://www.freedesktop.org/wiki/Software/systemd/) service management tool, which manages the service as a background process or daemon subject to the configuration and execution potential provided by its underlying management framework.

_The following variables can be customized to manage the service's **systemd** [Service] unit definition and execution profile/policy:_

`extra_run_args: <prometheus-cli-options>` (**default**: `[]`)
- list of `grafana` commandline arguments to pass to the binary at runtime for customizing launch.

Supporting full expression of `grafana`'s [cli](https://gist.github.com/0x0I/eec137d55a26a16d836b84cbc186ab52), this variable enables the launch to be customized according to the user's specification.

`custom_unit_properties: <hash-of-systemd-service-settings>` (**default**: `[]`)
- hash of settings used to customize the `[Service]` unit configuration and execution environment of the *Grafana* **systemd** service.

#### Uninstall

Support for uninstalling and removing artifacts necessary for provisioning allows for users/operators to return a target host to its configured state prior to application of this role. This can be useful for recycling nodes and roles and perhaps providing more graceful/managed transitions between tooling upgrades.

_The following variable(s) can be customized to manage this uninstall process:_

`perform_uninstall: <true | false>` (**default**: `false`)
- whether to uninstall and remove all artifacts and remnants of this `grafana` installation on a target host (**see**: `handlers/main.yml` for details)

Dependencies
------------

- 0x0i.systemd

Example Playbook
----------------
default example:
```
- hosts: all
  roles:
  - role: 0xOI.grafana
```

install specific version of Grafana bits:
```
- hosts: all
  roles:
  - role: 0xOI.grafana
    vars:
      archive_url: https://github.com/prometheus/prometheus/releases/download/v2.15.0/prometheus-2.15.0.linux-amd64.tar.gz
      archive_checksum: 1c2175428e7a70297d97a30a04278b86ccd6fc53bf481344936d6573482203b4
```

adust Grafana installation, configuration and data directories:
```
- hosts: all
  roles:
  - role: 0xOI.grafana
    vars:
      install_dir: /usr/local
      config_dir: /etc/grafana
      data_dir: /mnt/grafana
```

License
-------

Apache, BSD, MIT

Author Information
------------------

This role was created in 2019 by O1.IO.
