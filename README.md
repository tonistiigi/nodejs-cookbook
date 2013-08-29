# nodejs-cookbook [![Build Status](https://secure.travis-ci.org/mdxp/nodejs-cookbook.png)](http://travis-ci.org/mdxp/nodejs-cookbook)

DESCRIPTION
===========

Installs Node.JS

REQUIREMENTS
============


## Platform

* Tested on SmartOS
* Should work fine on Debian 6, Ubuntu 10.04, Centos, RHEL, etc.

## Cookbooks:

* build-essential

Opscode cookbooks (http://github.com/opscode/cookbooks/tree/master)

ATTRIBUTES
==========

* nodejs['method'] = source or binary
* nodejs['version'] - release version of node to install, tag or commit
* nodejs['dir'] - location where node will be installed, default /opt/local

USAGE
=====

Include the nodejs recipe to install node on your system based on the default installation method:

*  include_recipe "nodejs"

LICENSE and AUTHOR
==================

Author:: Marius Ducea (marius@promethost.com)
Author:: Nathan L Smith (nlloyds@gmail.com)

Copyright:: 2010-2012, Promet Solutions
Copyright:: 2012, Cramer Development, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
