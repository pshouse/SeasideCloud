#
# Cookbook Name:: gemstone
# Recipe:: default
#
# Copyright 2009, RCC
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
#default.rb
package "unzip" do
	action :install
end

package "bc" do
	action :install
end

remote_file "/tmp/installGemstone.sh" do
	source "http://seaside.gemstone.com/scripts/installGemstone2.3-Linux.sh"
	mode "0755"
end
#installation script must be run by a user with sudo access, not root.
group "ubuntu" do
	gid 1001
end

user "ubuntu" do
	uid "1001"
	gid "ubuntu"
	home "/home/ubuntu"
	shell "/bin/bash"
	password "$1$abcdefg$iVy1HWK7oNSmT3xxtUbGw1"
end
directory "/home/ubuntu" do
	mode "0755"
	owner "ubuntu"
	group "ubuntu"
end

package "sudo" do
	action :upgrade
end

template "/etc/sudoers" do
	source "sudoers.erb"
	mode 0440
	owner "root"
	group "root"
	variables(

		:sudoers_users => node[:authorization][:sudo][:users]
		)
end

execute "installGemstone.sh" do
	command "./installGemstone.sh"
	user "ubuntu"
	creates "/opt/gemstone"
end

directory "/opt/gemstone" do
	owner "ubuntu"
	group "ubuntu"
end

