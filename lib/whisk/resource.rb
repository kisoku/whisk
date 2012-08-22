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
# This organization of this class and classes under whisk/resource
# are heavily inspired by Opscode Chef's Chef::Resource
# which was authored by Adam Jacob

require 'chef/mixin/params_validate'
require 'whisk/exceptions'

class Whisk
  class Resource

    include Chef::Mixin::ParamsValidate

    attr_reader :name
    attr_accessor :provider

    def initialize(name, &block)
      @name = name

      instance_eval(&block) if block_given?
    end

    def provider(arg=nil)
      klass = if arg.kind_of?(String) || arg.kind_of?(Symbol)
                raise ArgumentError "must provider provider by klass"
                # lookup_provider_constant(arg)
              else
                arg
              end
      set_or_return(
        :provider,
        klass,
        :kind_of => [ Class ]
      )
    end

    def run_action(action)
      if self.provider
        provider = self.provider.new(self)
        provider.send("action_#{action}")
      end
    end
  end
end
