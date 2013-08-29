#
# Author:: Julian Wilde (jules@jules.com.au)
# Cookbook Name:: nodejs
# Recipe:: install_from_binary
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


# Shamelessly borrowed from http://docs.opscode.com/dsl_recipe_method_platform.html
# Surely there's a more canonical way to get arch?
if node['kernel']['machine'] =~ /armv6l/
  arch = "arm-pi" # assume a raspberry pi
else
  arch = node['kernel']['machine'] =~ /x86_64/ ? "x64" : "x86"
end

if node['platform_family'] == 'smartos'
  distro_suffix = "-sunos-#{arch}"
else
  distro_suffix = "-linux-#{arch}"
end

if node['platform_family'] == 'smartos'
  src_dir = "/opt/local/src"
else
  src_dir = "/usr/local/src"
end

# package_stub is for example: "node-v0.8.20-linux-x64"
package_stub = "node-#{node['nodejs']['version']}#{distro_suffix}"
nodejs_tar = "#{package_stub}.tar.gz"

# Let the user override the source url in the attributes
nodejs_bin_url = "http://nodejs.org/dist/#{node['nodejs']['version']}/#{nodejs_tar}"

# Where we will install the binaries and libs to (normally /usr/local):
destination_dir = node['nodejs']['dir']

install_not_needed = File.exists?("#{node['nodejs']['dir']}/bin/node") && `#{node['nodejs']['dir']}/bin/node --version`.chomp == "#{node['nodejs']['version']}" 

directory src_dir

# Download it:
remote_file "#{src_dir}/#{nodejs_tar}" do
  source nodejs_bin_url
  mode 0644
  action :create_if_missing
  not_if { install_not_needed }
end

# One hopes that we can trust the contents of the node tarball not to overwrite anything it shouldn't!
execute "install package to system" do
    command <<-EOF
            tar xf #{src_dir}/#{nodejs_tar} \
            --strip-components=1  --no-same-owner \
            -C #{destination_dir} \
            #{package_stub}/bin \
            #{package_stub}/lib \
            #{package_stub}/share
        EOF

    not_if { install_not_needed }
end

file "#{src_dir}/#{nodejs_tar}" do
  backup false
  action :delete
end