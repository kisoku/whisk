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

require 'whisk/exceptions'
require 'whisk/resource'
require 'whisk/provider/ingredient'

class Whisk
  class Resource
    class Ingredient < Resource

      include Chef::Mixin::ParamsValidate

      attr_accessor :bowl

      def initialize(name, bowl, &block)
        @bowl = bowl
        @provider = Whisk::Provider::Ingredient
        @ref = nil
        @source = nil

        super(name, &block)
      end

      def source(arg=nil)
        set_or_return(:source, arg, :required => true)
      end

      def ref(arg=nil)
        set_or_return(:ref, arg, :kind_of => String)
      end
    end
  end
end
