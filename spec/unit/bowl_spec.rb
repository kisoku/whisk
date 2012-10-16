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
  end

  it "should default to a sensible path" do
    File.split(@bowl.path).last.should == @bowl.name
  end

  it "should raise an error when duplicate ingredients are added" do
    @bowl.ingredient "fail"
    expect { @bowl.ingredient "fail" }.to raise_error
  end
end


describe Whisk::Provider::Bowl do
  before(:each) do
    @resource = Whisk::Resource::Bowl.new "testing" do
      environment "testing"
      refs_from_environment true
      ingredient 'test_ingredient'
    end

    @environment = Chef::Environment.new
    @environment.name "testing"
    @environment.description "teasting environment"
    @environment.cookbook_versions['test_ingredient'] = '0.0.1'

    @provider = Whisk::Provider::Bowl.new(@resource)
    @json = Chef::JSONCompat.to_json(@environment)

    @cmd = Mixlib::ShellOut.new("knife environment show -F json #{@resource.name}")
    @cmd.stub!(:status).and_return(0)
    @cmd.stub!(:existatus).and_return(0)
    @cmd.stub!(:stdout).and_return(@json)
  end

  it "should use the environment when requested" do
    @resource.ingredient "testing"
    @resource.ingredients["testing"].ref.should == :ref_from_environment
  end

  it "should fetch the environment" do
    @provider.should_receive(:run_command!).with("knife environment show -F json #{@resource.name}").and_return(@cmd)
    env = @provider.environment
    env.should be_a (Chef::Environment)
    env.name.should eq "testing"
  end

  it "should set ref_from_environment to the version specified on ingredients_run" do
    @provider.stub(:environment) { @environment }
    @provider.ingredients_run('nothing')
    @resource.ingredients['test_ingredient'].ref.should == '0.0.1'
  end
end
