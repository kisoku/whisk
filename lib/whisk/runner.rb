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

require 'whisk'
require 'whisk/whiskfile'

class Whisk
  class Runner

    attr_accessor :bowls

    def initialize(whiskfile=Whisk::DEFAULT_FILENAME, filter=nil)
      @bowls = Whisk::WhiskFile.from_file(whiskfile).bowls

      if filter
        bowl, ingredient = filter.split('/')
        if bowl
          bowls.delete_if {|k,v| !k.to_s.match(/^#{bowl}$/)}
          if ingredient
            bowls.each do |name, b|
              bowls[name].ingredients.delete_if {|k,v| !k.to_s.match(/^#{ingredient}$/)}
            end
          end
        end
      end
    end

    def run(action)
      @bowls.each do |name, bowl|
        begin
          bowl.run_action(action)
        rescue Exception => e
          Whisk.ui.error "Caught exception while running action #{action} on bowl #{bowl.name}"
          Whisk.ui.output e.backtrace
          exit 1
        end
      end
    end
  end
end
