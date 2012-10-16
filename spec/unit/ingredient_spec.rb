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

require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Whisk::Resource::Bowl do
  before(:each) do
    @bowl = Whisk::Resource::Bowl.new "test_bowl"
    @ingredient = Whisk::Resource::Ingredient.new("test_ingredient", @bowl)
    @provider = Whisk::Provider::Ingredient.new(@ingredient)
    @environment = Chef::Environment.new
    @environment.cookbook_versions['test_ingredient'] = '0.0.1'
  end

  it "should default to a sensible path" do
    @ingredient.path.should == File.join(@ingredient.bowl.path, @ingredient.name)
  end
end
