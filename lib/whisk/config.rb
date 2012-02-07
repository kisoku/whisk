#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Mathieu Sauve-Frankel <msf@kisoku.net>
# Copyright:: Copyright (c) 2008 Opscode, Inc.
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

require 'whisk/bowl'

class Whisk
  class Config
    attr_accessor :bowls

    @@bowls = {}

    def self.add_bowl(bowl)
      @@bowls[bowl.name] = bowl
    end

    def self.bowls
      @@bowls
    end

    def self.bowl(name, &block)
      if self.bowls.has_key? name
        raise ArgumentError "bowl #{name} already exists"
      else
        b = Whisk::Bowl.new(name)
        b.instance_eval(&block)
        self.add_bowl(b)
      end
    end

    # totally jacked from 
    def self.from_file(filename)
      if ::File.exists?(filename) && ::File.readable?(filename)
        self.instance_eval(::IO.read(filename), filename, 1)
      else
        raise IOError, "Cannot open or read #{filename}!"
      end
    end
  end
end
