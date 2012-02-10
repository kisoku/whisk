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

require 'pp'
require 'fileutils'
require 'whisk/log'
require 'whisk/ingredient'

class Whisk
  class Bowl
    attr_accessor :name, :path, :ingredients

    def initialize(name, path=nil, &block)
      @name = name
      @path = path
      @ingredients = {}

      instance_eval(&block) if block_given?
    end

    def path(pth=nil)
      if pth
        @path = pth
      else
        @path
      end
    end

    def ingredient(iname, opts = {})
      if ingredients.has_key? iname
        raise ArgumentError "ingredient '#{iname}' has already added to bowl '#{name}'"
      else
        source = opts.delete :source
        flavour = opts.delete :flavour
        options = opts.delete :options
        i = Whisk::Ingredient.new(iname, source, flavour, options)
        ingredients[iname] = i
      end
    end

    def create
      unless File.exists? path
        begin
          Whisk::Log.info "creating bowl '#{name}' with path #{path}"
          ::FileUtils.mkdir_p path
        rescue Exception => e
          puts "#{e.backtrace} #{e.message}"
        end
      end
    end

    def prepare
      self.create unless File.exists? path
      ::Dir.chdir path

      Whisk::Log.info "preparing bowl '#{name}' with path #{path}"

      ingredients.keys.each do |i|
        begin
          ingredients[i].prepare
        rescue Exception => e
          Whisk::Log.error "failed fetching ingredient #{i}! bailing"
          raise
          exit 1
        end
      end
    end
  end
end
