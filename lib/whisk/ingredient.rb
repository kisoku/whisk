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

require 'chef/mixin/params_validate'
require 'whisk/flavours'

class Whisk
  class Ingredient

    include Chef::Mixin::ParamsValidate

    attr_reader :name

    def initialize(name, &block)
      @name = name
      @flavour = 'git'
      @source = nil
      @options = {}

      instance_eval(&block) if block_given?

      self.class.send(:include, Whisk::FLAVOURS[@flavour])
    end

    def source(arg=nil)
      set_or_return(:source, arg, :required => true)
    end

    def flavour(arg=nil)
      set_or_return(:flavour, arg, :default => 'git')
    end

    def options(arg=nil)
      set_or_return(:options, arg, :default => {})
    end
  end
end
