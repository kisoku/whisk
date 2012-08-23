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

whiskfile = File.join(WHISKFILE_DIR, "runner.whiskfile")

describe Whisk::Runner do
  it "should load the whiskfile on init" do
    runner = Whisk::Runner.new(whiskfile)
    runner.bowls.keys.should == %w[ production testing development ]
  end

  it "should filter bowls on init" do
    runner = Whisk::Runner.new(whiskfile, "production")
    runner.bowls.keys.should == %w[ production ]
  end

  it "should filter ingredients on init" do
    runner = Whisk::Runner.new(whiskfile, "production/ntp")
    runner.bowls['production'].ingredients.keys.should == %w[ ntp ]
  end

  it "should filter bowls by wildcard" do
    runner = Whisk::Runner.new(whiskfile, "pro.*")
    runner.bowls.keys.should == %w[ production ]
  end

  it "should filter ingredients by wildcard" do
    runner = Whisk::Runner.new(whiskfile, ".*/ntp")
    runner.bowls.keys.should == %w[ production testing development ]
    runner.bowls.each do |name, bowl|
      bowl.ingredients.keys.should == %w[ ntp ]
    end
  end

  it "should filter bowls by list" do
    runner = Whisk::Runner.new(whiskfile, "(production|testing)")
    runner.bowls.keys.should == %w[ production testing ]
  end
end
