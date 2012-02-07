#
# Author:: Mathieu Sauve-Frankel <msf@kisoku.net>
# Copyright:: Copyright (c) 2012 Mathieu Sauve-Frankel
# License:: Apache License, Version 2.0
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

whisk_dir = "#{ENV['HOME']}/whisk"
github = "git://github.com/cookbooks/%s.git"

bowl "testing" do
  path File.join(whisk_dir, "testing")
  ingredient 'ssh', :source => github % 'ssh'
  ingredient 'ntp', :source => github % 'ntp'
end

bowl "production" do
  path File.join(whisk_dir, "production")
  ingredient 'ssh', :source => github % 'ssh', :options => { :ref => '0.1.0' }
end
