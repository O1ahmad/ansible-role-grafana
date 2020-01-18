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

File-based service discovery provides a more generic way to configure static targets and serves as an interface to plug in custom service discovery mechanisms. It reads a set of files containing a list of zero or more `<static_config>`s. Changes to all defined files are detected via disk watches and applied immediately. Files may be provided in YAML or JSON format. Only changes resulting in well-formed target groups are applied. See [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#file_sd_config) for more details.

`prometheus_file_sd: <list-of-dicts>` (**default**: [])
- specifies prometheus file_sd configurations to render

Using this role, file-based service discovery configuration settings can be expressed within the hash, `prometheus_file_sd`, which contains a list of dicts representing and encapsulating the path, name and configuration contents of a `yaml` or `json` file set to be loaded by prometheus for file-based discovery.

`[prometheus_file_sd : <entry>:] name: <string>` (**default**: NONE - *required*)
- name of file_sd file to render

`[prometheus_file_sd : <entry>:] path: <string>` (**default**: `{{ install_dir }}/file_sd`)
- path of file_sd file to render

`[prometheus_file_sd : <entry>:] config: <list-of-dicts>` (**default**: NONE - *required*)
- list of dictionaries representing settings indicating set of static targets to specify in file_sd file

##### Example

 ```yaml
  prometheus_file_sd:
  - name: example-file.slow.json
    config:
    - targets: ["host1:1234"]
      labels:
        test-label: example-slow-file-sd
  - name: file.yml
    path: /etc/prometheus/file_sd
    config:
    - targets: ["host2:1234"]
  ```

  **NB:** An associated `file_sd` service discovery scrape_config is expected to be included within the `prometheus.yml` file for successful load.

#### Rule files

Prometheus supports two types of rules which may be configured and then evaluated at regular intervals: recording rules and alerting rules. Recording rules allow you to precompute frequently needed or computationally expensive expressions and save their result as a new set of time series.. Alerting rules allow you to define alert conditions based on Prometheus expression language expressions and to send notifications about firing alerts to an external service. See [here](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) for more details.

`prometheus_rule_files: <list-of-dicts>` (**default**: [])
- specifies prometheus rule files to render

Using this role, both recording and alerting rules can be expressed within the hash, `prometheus_rule_files`, which contains a list of dicts representing and encapsulating the path, name and configuration contents of a `yaml` or `json` file set to be loaded by prometheus for rule setting.

`[prometheus_rule_files : <entry>:] name: <string>` (**default**: NONE - *required*)
- name of rule file to render

`[prometheus_rule_files : <entry>:] path: <string>` (**default**: `{{ install_dir }}/rules.d`)
- path of rule file to render

`[prometheus_rule_files : <entry>:] config: <list-of-dicts>` (**default**: NONE - *required*)
- list of dictionaries representing settings indicating set of rule groups to specify in rule file

##### Example

 ```yaml
prometheus_rule_files:
- name: example-rules.yml
  config:
    groups:
    - name: recording rule example
      rules:
      - record: job:http_inprogress_requests:sum
        expr: sum(http_inprogress_requests) by (job)
- name: nondefault-path-example-rules.yml
  path: /etc/prometheus/rules.d
  config:
    groups:
    - name: alerting rule example
      rules:
      - alert: HighRequestLatency
        expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
        for: 10m
        labels:
          severity: page
        annotations:
          summary: High request latency
  ```

**NB:** An associated `rule_files` section is expected to be included within the `prometheus.yml` file for successful load.

#### Dashboards

Alertmanager service configuration can be expressed within the hash, `alertmanager_config`, which contains a set of key-value pairs representing one of a set of sections indicating various route, receiver, templating and alert inhibition configurations.

The values of these keys are generally dicts or lists of dicts themselves containing a set of key-value pairs representing associated specifications/settings (e.g. the API URL to use for Slack notifications) for each section. The following provides an overview and example configurations of each for reference.

###### :global

`[alertmanager_config:] global: <key: value,...>` (**default**: see `defaults/main.yml`)
- specifies parameters that are valid and serve as defaults in all other configuration contexts. See [here](https://prometheus.io/docs/alerting/configuration/) for more details.

##### Example

 ```yaml
  alertmanager_config:
    global:
      # The smarthost and SMTP sender used for mail notifications.
      smtp_smarthost: 'localhost:25'
      smtp_from: 'alertmanager@example.org'
      smtp_auth_username: 'alertmanager'
      smtp_auth_password: 'password'
      # The auth token for Hipchat.
      hipchat_auth_token: '1234556789'
      # Alternative host for Hipchat.
      hipchat_api_url: 'https://hipchat.foobar.org/'
  ```

###### :route

`[alertmanager_config:] route: <key: value,...>` (**default**: see `defaults/main.yml`)
- defines a node in a routing tree and its children

Every alert enters the routing tree at the configured top-level route, which must match all alerts (i.e. not have any configured matchers). It then traverses the child nodes. If continue is set to false, it stops after the first matching child. If continue is true on a matching node, the alert will continue matching against subsequent siblings. See [here](https://prometheus.io/docs/alerting/configuration/#route) for more details.

##### Example

 ```yaml
  alertmanager_config:
    route:
      receiver: 'default-receiver'
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 4h
      group_by: [cluster, alertname]
      # All alerts that do not match the following child routes
      # will remain at the root node and be dispatched to 'default-receiver'.
      routes:
        # All alerts with service=mysql or service=cassandra
        # are dispatched to the database pager.
      - receiver: 'database-pager'
        group_wait: 10s
        match_re:
          service: mysql|cassandra
      # All alerts with the team=frontend label match this sub-route.
      # They are grouped by product and environment rather than cluster
      # and alertname.
      - receiver: 'frontend-pager'
        group_by: [product, environment]
        match:
          team: frontend
  ```

###### :receivers

`[alertmanager_config:] inhibit_rules: <list-of-dicts>` (**default**: see `defaults/main.yml`)
- specifies a list of notification receivers

Receivers are named configuration of one or more notification integrations. See [here](https://prometheus.io/docs/alerting/configuration/#receiver) for more details.

##### Example

 ```yaml
  alertmanager_config:
    receivers:
    - name: 'team-X-mails'
      email_configs:
      - to: 'team-X+alerts@example.org'
      pagerduty_configs:
      - service_key: <team-X-key>
      hipchat_configs:
      - auth_token: <auth_token>
        room_id: 85
        message_format: html
        notify: true
  ```

###### :inhibit_rules

`[alertmanager_config:] inhibit_rules: <list-of-dicts>` (**default**: see `defaults/main.yml`)
- specifies a list of inhibition rules

An inhibition rule mutes an alert (target) matching a set of matchers when an alert (source) exists that matches another set of matchers. See [here](https://prometheus.io/docs/alerting/configuration/#inhibit_rule) for more details.

##### Example

 ```yaml
  alertmanager_config:
    inhibit_rules:
    - source_match:
        severity: 'critical'
      target_match:
        severity: 'warning'
      # Apply inhibition if the alertname is the same.
      equal: ['alertname', 'cluster', 'service']
  ```

###### :templates

`[alertmanager_config:] templates: <list>` (**default**: see `defaults/main.yml`)
- specifies files and directories from which notification templates are read

The last component may use a wildcard matcher, e.g. `templates/*.tmpl`. See [here](https://prometheus.io/docs/alerting/notifications/) for a notification template reference and this [link](https://prometheus.io/docs/alerting/notification_examples/) for examples.

##### Example

 ```yaml
  alertmanager_config:
    templates:
    - '/etc/alertmanager/template/*.tmpl'
  ```

#### Notifiers

Prometheus creates and sends alerts to the Alertmanager which then sends notifications out to different receivers based on their labels. The notifications sent to receivers are constructed via templates. The Alertmanager comes with default templates but they can also be customized. See [here](https://prometheus.io/docs/alerting/notifications/) for more details.

`altermanager_templates: <list-of-dicts>` (**default**: [])
- specifies `alertmanager` notification template configurations to render

Using this role, alertmanager template configuration settings can be expressed within the hash, `alertmanager_templates`, which contains a list of dicts representing and encapsulating the path, name and configuration contents of a `tmpl` file set to be loaded by alertmanager.

`[alertmanager_templates : <entry>:] name: <string>` (**default**: NONE - *required*)
- name of template file to render

`[alertmanager_templates : <entry>:] path: <string>` (**default**: `{{ alertmgr_installdir }}/templates`)
- path of template file to render

`[alertmanager_templates : <entry>:] config: <list-of-dicts>` (**default**: NONE - *required*)
- list of dictionaries representing settings indicating set of template configs to render

##### Example

 ```yaml
  alertmanager_templates:
  - name: test
    config:
    - define: "myorg.test.guide"
      template: 'https://internal.myorg.net/wiki/alerts/\{\{ .GroupLabels.app \}\}/\{\{ .GroupLabels.alertname \}\}'
  - name: test2
    path: /etc/alertmanager/templates
    config:
    - define: "myorg.test.text"
      template: 'summary: \{\{ .CommonAnnotations.summary \}\}\ndescription: \{\{ .CommonAnnotations.description \}\}'
  ```

  **NB:** An associated `templates` config section is expected to be included within the `alertmanager.yml` file for successful load.

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
