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

describe Whisk::WhiskFile do
  it "should raise when the Whiskfile does not exist" do
    expect { Whisk::WhiskFile.from_file "/whiskfile.nowhere" }.to raise_error
  end

  it "should raise when bowls with identical names have been defined" do
    @whiskfile = Whisk::WhiskFile.new
    @whiskfile.bowl "fail"
    expect { @whiskfile.bowl "fail" }.to raise_error
  end
end
