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
          raise ArgumentError, "Ingredient '#{iname}' has already been added to bowl '#{name}'"
        else
          ingredients[iname] = Whisk::Resource::Ingredient.new(iname, self, &block)
          if refs_from_environment
            ingredients[iname].ref :ref_from_environment
          end
        end
      end

      def environment(arg=nil)
        set_or_return(:environment, arg, :kind_of => String)
      end

      def path(arg=nil)
        if arg
          path = File.expand_path(arg)
        else
          path = nil
        end
        set_or_return(:path, path, :default => File.expand_path(File.join(Dir.getwd, name)))
      end

      def refs_from_environment(arg=nil)
        set_or_return(:refs_from_environment, arg, :kind_of => [TrueClass, FalseClass], :default => false)
      end
    end
  end
end
