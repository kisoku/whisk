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

require 'fileutils'
require 'whisk/resource'
require 'whisk/resource/ingredient'
require 'whisk/provider/bowl'

class Whisk
  class Resource
    class Bowl < Resource

      attr_reader :ingredients

      def initialize(name, &block)
        @provider = Whisk::Provider::Bowl
        @ingredients = {}

        super(name, &block)
      end

      def ingredient(iname, &block)
        if ingredients.has_key? iname
          raise ArgumentError "Ingredient '#{iname}' has already added to bowl '#{name}'"
        else
          ingredients[iname] = Whisk::Resource::Ingredient.new(iname, &block)
        end
      end

      def path(arg=nil)
        set_or_return(:path, arg, :default => File.join(Dir.getwd, name))
      end
    end
  end
end
