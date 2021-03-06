#
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
# from_file is derived from chef/chef/lib/chef/mixin/from_file.rb
#
#

require 'whisk'

class Whisk
  class WhiskFile

    attr_accessor :bowls

    def initialize
      @bowls = {}
    end

    def add_bowl(bowl)
      if bowls.has_key? bowl.name
        raise ArgumentError, "bowl #{bowl.name} already exists"
      else
        bowls[bowl.name] = bowl
      end
    end

    def bowl(name, &block)
      b = Whisk::Resource::Bowl.new(name)
      b.instance_eval(&block) if block_given?
      add_bowl(b)
    end

    class << self
      def from_file(filename)
        if ::File.exists?(filename) && ::File.readable?(filename)
          whiskfile = Whisk::WhiskFile.new
          whiskfile.instance_eval(::IO.read(filename), filename, 1)
          whiskfile
        else
          raise IOError, "Cannot open or read #{filename}!"
        end
      end
    end
  end
end
