#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: nodejs
# Recipe:: source
#
# Copyright 2010-2012, Promet Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"

case node['platform_family']
  when 'rhel','fedora'
    package "openssl-devel"
  when 'debian'
    package "libssl-dev"
end

if node['platform_family'] == 'smartos'
  src_dir = "/opt/local/src"
else
  src_dir = "/usr/local/src"
end


tar_root = "node-#{node['nodejs']['version']}"

if node['nodejs']['version'].match('^v\d+\.\d+\.\d+$')
  # Dist packages are smaller because they don't contain v8 tests.
  nodejs_tar = "node-#{node['nodejs']['version']}.tar.gz"
  base_url = "http://nodejs.org/dist/#{node['nodejs']['version']}"
else
  nodejs_tar = "#{node['nodejs']['version']}.tar.gz"
  base_url = 'http://github.com/joyent/node/archive/'
  if node['nodejs']['version'].match('^v\d+\.')
    tar_root = "node-#{node['nodejs']['version'][1..-1]}"
  end
end

nodejs_src_url = "#{base_url}/#{nodejs_tar}"

directory src_dir

remote_file "#{src_dir}/#{nodejs_tar}" do
  source nodejs_src_url
  mode 0644
  action :create_if_missing
end

# --no-same-owner required overcome "Cannot change ownership" bug
# on NFS-mounted filesystem
execute "tar --no-same-owner -zxf #{nodejs_tar}" do
  cwd src_dir
  creates "#{src_dir}/#{tar_root}"
end

bash "compile node.js (on #{node['nodejs']['make_threads']} cpu)" do
  # OSX doesn't have the attribute so arbitrarily default 2
  cwd "#{src_dir}/#{tar_root}"
  code <<-EOH
    PATH="/usr/local/bin:$PATH"
    ./configure --prefix=#{node['nodejs']['dir']} && \
    make -j #{node['nodejs']['make_threads']}
  EOH
  creates "#{src_dir}/#{tar_root}/node"
end

execute "make install" do
  #environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "make install"
  cwd "#{src_dir}/#{tar_root}"
  not_if {::File.exists?("#{node['nodejs']['dir']}/bin/node") && `#{node['nodejs']['dir']}/bin/node --version`.chomp == "#{node['nodejs']['version']}" }
end
