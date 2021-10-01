<p><img src="https://code.benco.io/icon-collection/logos/ansible.svg" alt="ansible logo" title="ansible" align="left" height="60" /></p>
<p><img src="https://wiki.lafabriquedesmobilites.fr/images/fabmob/7/7d/Grafana_logo_swirl.png" alt="grafana logo" title="grafana" align="right" height="60" /></p>

Ansible Role :rainbow: :bar_chart: Grafana
=========
[![Galaxy Role](https://img.shields.io/ansible/role/45672.svg)](https://galaxy.ansible.com/0x0I/grafana)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/0x0I/ansible-role-grafana?color=yellow)
[![Downloads](https://img.shields.io/ansible/role/d/45672.svg?color=lightgrey)](https://galaxy.ansible.com/0x0I/grafana)
[![Build Status](https://travis-ci.org/0x0I/ansible-role-grafana.svg?branch=master)](https://travis-ci.org/0x0I/ansible-role-grafana)
[![License: MIT](https://img.shields.io/badge/License-MIT-blueviolet.svg)](https://opensource.org/licenses/MIT)

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

`grafana_group: <service-group-name>` (**default**: *grafana*)
- dedicated service user and group used by `grafana` for privilege separation (see [here](https://www.beyondtrust.com/blog/entry/how-separation-privilege-improves-security) for details)

`install_type: <package | archive>` (**default**: archive)
- **package**: supported by Debian and Redhat distributions, package installation of Grafana pulls the specified package from the respective package management repository.

  - Note that the installation directory is determined by the package management system and currently defaults to under `/usr/{sbin,lib, share}` for all distros.

- **archive**: compatible with both **tar and zip** formats, archived installation binaries can be obtained from local and remote compressed archives either from the official [releases index](https://github.com/grafana/grafana/releases) or those generated from development/custom sources.

`install_dir: </path/to/installation/dir>` (**default**: `/opt/grafana`)
- path on target host where the `grafana` binaries should be extracted to.

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
* provisioning of datasources (`provisioning/datasources - *.[json|yml]`)
* dashboard provisioning (`provisioning/dashboards - *.[json|yml]`)
* notifier setup (`provisioning/notifiers - [json|yml]`)

Each configuration can be expressed within the following variables in order to customize the contents and settings of the designated configuration files to be rendered:

`config_dir: </path/to/configuration/dir>` (**default**: `{{ install_dir }}`)
- path on target host where `grafana` config file should be rendered

`provision_configs: <['datasources', 'dashboards' and/or 'notifiers']>` (**default**: [])
- list of Grafana provisioning components to configure. See [here](https://grafana.com/docs/grafana/latest/administration/provisioning/) for more details.

#### Grafana Service configuration

Grafana service configuration is contained within an INI file, *grafana.ini by default*, which defines a set of service behaviors organized by section representing general administration and various content provider aspects of the Grafana service.

These sections and settings can expressed within the hash, `grafana_config`, keyed by configuration section with dicts as values representing config section specifications (e.g. the path to store the sqlite3 database file -- activated by default). The following provides an overview and example configurations of each section for reference.

##### :paths

`[grafana_config:] path: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#paths) documentation)
- specifies parameters that are related to where Grafana stores artifacts and variable data

 ```yaml
  grafana_config:
    # section [paths]
    paths:
      # section option 1 - path of sqlite database
      data: /mnt/data/grafana
      # section option 2 - path to store logs
      logs: /mnt/logs/grafana
  ```

`[grafana_config:] server: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#server) documentation)
- specifies parameters that are related to how Grafana interfaces over the network

 ```yaml
  grafana_config:
    # section [server]
    server:
      http_addr: 127.0.0.1
      http_port: 3030
  ```

##### :database

`[grafana_config:] database: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#database) documentation)
- specifies parameters that control how grafana interfaces with one of the available backend datastore types (i.e. *mysql, postgres and sqlite*)


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

##### :remote_cache

`[grafana_config:] remote_cache: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#remote-cache) documentation)
- specifies parameters that control how grafana interfaces with one of the available remote-caching types (i.e. *redis, memcached and database*)

 ```yaml
  grafana_config:
    # section [remote_cache]
    remote_cache:
      type: redis
      connstr: addr=127.0.0.1:6379,pool_size=100,db=0,ssl=false
  ```

##### :security

`[grafana_config:] security: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#security) documentation)
- specifies parameters that manage Grafana user/organization authentication and authorization behavior

```yaml
  grafana_config:
    # section [security]
    security:
      admin_user: sre-user
      admin_password: PASSWORD
      login_remember_days: 7
```

##### :users

`[grafana_config:] users: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#users) documentation)
- specifies parameters that control Grafana user capabilities

```yaml
  grafana_config:
    # section [users]
    users:
      allow_sign_up: true
      allow_org_create: false
      login_hint: THIS IS A HINT
```

##### :auth

`[grafana_config:] auth: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#auth) documentation)
- specifies parameters that regulate user authorization capabilites

Grafana provides multiple methods to authenticate users and settings for each method are expressed within [auth.<method>] sections as appropriate, allowing for authentication ranging from basic user auth to Google & Github OAuth.

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

##### :dataproxy

`[grafana_config:] dataproxy: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#dataproxy) documentation)
- specifies parameters that enable data proxy logging

```yaml
  grafana_config:
    # section [dataproxy]
    dataproxy:
      logging: true
      timeout: 60
      send_user_header: true
```

##### :analytics

`[grafana_config:] analytics: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#analytics) documentation)
- specifies parameters that activate usage statistics collection and reporting

```yaml
  grafana_config:
    # section [analytics]
    analytics:
      reporting_enabled: true
      google_analytics_ua_id: UA_ID
      check_for_updates: true
```

##### :dashboards

`[grafana_config:] dashboards: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#dashboards) documentation)
- specifies parameters that regulate Grafana's dashboard maintenance policy

```yaml
  grafana_config:
    # section [dashboards]
    dashboards:
      versions_to_keep: 5
```

##### :smtp

`[grafana_config:] smtp: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#smtp) documentation)
- specifies email server settings for identity in addition to alerting/notification

```yaml
  grafana_config:
    # section [smtp]
    smtp:
      enabled: true
      host: 127.0.0.1:65
      user: smtp-user
      password: PASSWORD
```

##### :log

`[grafana_config:] log: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#log) documentation)
- specifies logging settings (e.g. log level and log output modes or channels)

```yaml
  grafana_config:
    # section [log]
    log:
      mode: console
      level: debug
```

##### :metrics

`[grafana_config:] metrics: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#metrics) documentation)
- specifies settings for managing the emission of Grafana telemetry

```yaml
  grafana_config:
    # section [metrics]
    metrics:
      enabled: true
      interval_seconds: 5s
    metrics.graphite:
      address: 127.0.0.1:7070
```

##### :snapshots

`[grafana_config:] snapshots: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#snapshots) documentation)
- specifies settings for managing the publishing behavior of Grafana's interactive dashboard snapshotting functionality

```yaml
  grafana_config:
    # section [snapshots]
    snapshots:
      external_enabled: true
      external_snapshot_name: ENDPOINT
```

##### :external_image_storage

`[grafana_config:] external_image_storage: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#external-image-storage) documentation)
- specifies settings for controlling how images should be made publicly available for sharing on services like slack

Grafana supports several backend storage providers for which individual configurations can be expressed within [external_image_storage.<provider>] sections as appropriate, enabling remote storage on services like `s3, gcs, azure blob and local storage`.

```yaml
  grafana_config:
    # section [external_image_storage]
    external_image_storage:
      external_enabled: true
      external_snapshot_name: Publish to ENDPOINT
    external_image_storage.s3:
      endpoint: http://example.org.s3/
      bucket: grafana-snapshots
      region: us-east-1
      path: ${HOSTNAME}
      access_key: ACCESS_KEY
      secret_key: SECRET_KEY
```

##### :alerting

`[grafana_config:] alerting: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#alerting) documentation)
- specifies settings for managing Grafana's alerting engine and behavior/rulesets

```yaml
  grafana_config:
    # section [alerting]
    alerting:
      enabled: true
      execute_alerts: true
      nodata_or_nullvalues: no_data
      evaluation_timeout_seconds: 10
      notification_timeout_seconds: 60
      max_attempts: 5
```

##### :rendering

`[grafana_config:] rendering: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#rendering) documentation)
- specifies settings for operating a remote HTTP rendering service

```yaml
  grafana_config:
    # section [rendering]
    rendering:
      server_url: http://localhost:8081/render
      callback_url: http://grafana.open.domain
```

##### :plugins

`[grafana_config:] plugins: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#plugins-1) documentation)
- specifies settings for managing the availability and accessibility of grafana plugins

```yaml
  grafana_config:
    # section [plugins]
    plugins:
      enable_alpha: true
```

##### :feature_toggles

`[grafana_config:] feature_toggles: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#feature-toggles) documentation)
- specifies settings for toggling the use of alpha features by the grafana instance, delimited by spaces

```yaml
  grafana_config:
    # section [feature_toggles]
    features_toggles:
      enable: transformations
```

##### :tracing.jaeger

`[grafana_config:] tracing.jaegar: <key: value,...>` (**default**: see [section](https://grafana.com/docs/grafana/latest/installation/configuration/#tracing-jaeger) documentation)
- specifies settings for configuring Grafana's Jaegar client for distributed tracing.

**Note:** standard Jaegar environment variables, prefixed by `JAEGAR_*`, can still be specified and will override any settings provided herein.

```yaml
  grafana_config:
    # section [tracing.jaegar]
    tracing.jaegar:
      address: http://localhost:6381
      always_included_tag: key1:value1,key2:value2
```

#### Datasources

Grafana supports many different storage backends for your time series data known as datasources. Each datasource can be configured in a set of `json|yml` configuration files under Grafana's `provisioning` directory, which can be adjusted within the `[paths]` grafana.ini section.

These datasoure configurations can expressed within the hash, `grafana_datasources`. This hash contains a list of data source structures for activation and another for deletion, keyed by `datasources` and `deleteDatasources`, respectively. The values themselves consist of a list of dicts representing individual datasource specifications.  See [here](https://grafana.com/docs/grafana/latest/features/datasources/#supported-data-sources) for more details and a list of supported datasources.

`grafana_datasources: <list-of-dicts>` (**default**: [])
- specifies grafana datasource definitions to render. See [here](https://grafana.com/grafana/plugins?orderBy=weight&direction=asc) for a reference to available datasources from the community and their respective options.

`grafana_datasources: name: <string>` (**default**: *required*)
- name of grafana datasource file to render

`grafana_datasources: <entry> : datasources: <list-of-dicts>` (**default**: `[]`)
- list of data source definitions (based on supported list mentioned above) to render within the configuration file

`grafana_datasources: <entry> : deleteDatasources: <list-of-dicts>` (**default**: `[]`)
- list of previously imported data source definitions to delete (based on supported list mentioned above) to render within the configuration file

 ```yaml
  grafana_datasources:
  - name: example_datasource
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

Since version *5.0* Grafana has allowed adding one or more `yaml|json` config files in the provisioning/dashboards directory. Enabling Grafana to load dashboards from the local filesystem, this directory can contain a list of dashboards providers which indicate characteristics and various forms of meta data pertaining to the directory/file from which to load.

These dashboard provider configurations can be expressed within the hash, `grafana_dashboards`, which is composed of a list of the aforementioned dashboard provider structures.  See [here](https://grafana.com/grafana/dashboards) for more details and a list of dashboards created by the community available for download and import.

`grafana_dashboards: <list-of-dicts>` (**default**: [])
- specifies grafana dashboard provider definitions to render. See [here](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards) for a reference of supported options.

`grafana_dashboards: <entry> : name: <string>` (**default**: *required*)
- name of grafana dashboard provider file to render

`grafana_dashboards: <entry> : apiVersion: <string>` (**default**: `[]`)
- name of version of grafana dashboard provider file (useful for synchronization across instances)

`grafana_dashboards: <entry> : providers: <list-of-dicts>` (**default**: `[]`)
- list of dashboard provider definitions to render within the configuration file

`[grafana_dashboards: <entry> : urls: <entry>:] name` <string> (**default**: `required`)
- name of JSON file to store dashboard configuration/contents

`[grafana_dashboards: <entry> : urls: <entry>:] src` <string> (**default**: `[]`)
- URL or web address to locate and download the JSON file/content from

`[grafana_dashboards: <entry> : urls: <entry>:] id` <integer> (**default**: `[]`)
- unique identifier for referencing the dashboard to download from Grafana's official community hub

`[grafana_dashboards: <entry> : urls: <entry>:] dest` (**default**: `{{ provisioning_dir }}/dashboards`)
- location on host filesystem to store JSON dashboard definition

**Note:** either one of `_.src` or `_.id` for dashboard identification and location is *required*.

```yaml
  grafana_dashboards:
    - name: test-example
      apiVersion: 2
      urls:
        - name: node_exporter_prometheus
          src: https://grafana.com/api/dashboards/11173/revisions/1/download
        - name: geth_server
          id: '6976'
      providers:
        - name: 'default-example'
          folder: 'default'
          folderUid: 1
          type: file
          disableDeletion: true
          updateIntervalSeconds: 30
          options:
            path: /var/lib/grafana/conf/provisioning/dashboards
 ```

#### Notifiers

Alert Notification Channels can be provisioned by adding one or more `yaml|json` config files in the provisioning/notifiers directory.

Each config file can be expressed within the `grafana_notifiers` hash containing the following top-level fields:
  - notifiers, a list of alert notifications that will be added or updated during start up. If the notification channel already exists, Grafana will update it to match the configuration file.
  - delete_notifiers, a list of alert notifications to be deleted before before inserting/updating those in the notifiers list.

Provisioning looks up alert notifications by uid, and will update any existing notification with the provided uid.

`grafana_notifiers: <list-of-dicts>` (**default**: [])
- specifies grafana notifiers definitions to render. See [here](https://grafana.com/docs/grafana/latest/administration/provisioning/#example-alert-notification-channels-config-file) for a reference of supported options.

`grafana_notifiers: <entry> : name: <string>` (**default**: *required*)
- name of grafana alert notifier file to render

`grafana_notifiers: <entry> : notifiers: <string>` (**default**: `[]`)
- list of grafana alert notifiers to activate for a grafana instance

`grafana_notifiers: <entry> : delete_notifiers: <list-of-dicts>` (**default**: `[]`)
- list of grafana alert notifiers to delete from a grafana instance

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
 
 #### Plugins
 
 Grafana supports data source, panel, and app plugins. This role provides a list variable, `grafana_plugins`, which supports specification of a list of hashes detailing the name and version of the plugin to download. For more information about installing plugins, refer to Grafana's official plugins [documentation](https://grafana.com/docs/grafana/latest/plugins/installation/) and see [here](https://grafana.com/grafana/plugins?orderBy=weight&direction=asc) for a reference to available plugins.
 
 `[grafana_plugins: <entry>:] name:` <string> (**default**: *required*)
- name of the Grafana plugin to download

 `[grafana_plugins: <entry>:] version:` <string> (**default**: `latest)
- version of the Grafana plugin to download

```yaml
  grafana_plugins:
    - name: petrslavotinek-carpetplot-panel
      version: 0.1.1
    - name: briangann-gauge-panel
      # version: latest
 ```

#### Launch

This role supports launching the `grafana` web server accomplished utilizing the [systemd](https://www.freedesktop.org/wiki/Software/systemd/) service management tool, which manages the service as a background process or daemon subject to the configuration and execution potential provided by its underlying management framework.

_The following variables can be customized to manage the service's **systemd** [Service] unit definition and execution profile/policy:_

`extra_run_args: <grafana-cli-options>` (**default**: `[]`)
- list of `grafana` commandline arguments to pass to the binary at runtime for customizing launch.

Supporting full expression of `grafana`'s [cli](https://gist.github.com/0x0I/d4d6c828a4f456f778f64b104b6af3bf), this variable enables the launch to be customized according to the user's specification.

`custom_unit_properties: <hash-of-systemd-service-settings>` (**default**: `[]`)
- hash of settings used to customize the `[Service]` unit configuration and execution environment of the *Grafana* **systemd** service.

#### Uninstall

Support for uninstalling and removing artifacts necessary for provisioning allows for users/operators to return a target host to its configured state prior to application of this role. This can be useful for recycling nodes and perhaps providing more graceful/managed transitions between tooling upgrades.

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
  - role: 0x0I.grafana
```

install specific version of Grafana bits:
```
- hosts: all
  roles:
  - role: 0xOI.grafana
    vars:
      archive_url: https://dl.grafana.com/oss/release/grafana-6.6.1.linux-amd64.tar.gz
      archive_checksum: 0edc8207e356ef66eb7b1c78a1cdabc2cd5c0655de774000de2ad0397e543377
```

adust Grafana installation, configuration and data directories:
```
- hosts: all
  roles:
  - role: 0x0I.grafana
    vars:
      install_dir: /usr/local
      config_dir: /etc/grafana
      data_dir: /mnt/grafana
```

launch Grafana in debug mode for troubleshooting purposes and *only* output to console/stdout{err}:
```
- hosts: all
  roles:
  - role: 0x0I.grafana
    vars:
      grafana_config:
        log:
          level: debug
          mode: console
```
License
-------

MIT

Author Information
------------------

This role was created in 2019 by O1.IO.
