# Author:: Jamie Winsor <jamie@vialstudios.com>
# Copyright:: Copyright (c) 2012 Jamie Winsor
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
# this file is derived f

require 'thor'
require 'whisk'
require 'whisk/whiskfile'

def filter_bowls(bowls, bowl=nil, ingredient=nil)
  if bowl
    bowls.delete_if {|k,v| !k.to_s.match(/^#{bowl}$/)}
    if ingredient
      bowls.each do |name, b|
        bowls[name].ingredients.delete_if {|k,v| !k.to_s.match(/^#{ingredient}$/)}
      end
    end
  end

  return bowls
end

class Whisk
  class CLI < Thor
    def initialize(*)
      super
      # JW TODO: Replace Chef::Knife::UI with our own UI class
      ::Whisk.ui = Chef::Knife::UI.new(STDOUT, STDERR, STDIN, {})
      @options = options.dup # unfreeze frozen options Hash from Thor
    rescue Error => e
      Whisk.ui.fatal e
      exit e.status_code
    end

    namespace "whisk"

    method_option :whiskfile,
      type: :string,
      default: File.join(Dir.pwd, Whisk::DEFAULT_FILENAME),
      desc: "Path to a Whiskfile to operate off of.",
      aliases: "-w",
      banner: "PATH"
    desc "prepare", "prepare a bowl by cloning any missing repositories"
    def prepare(bowl=nil, ingredient=nil)
      whiskfile = ::Whisk::WhiskFile.from_file(options[:whiskfile])
      bowls = filter_bowls(whiskfile.bowls, bowl, ingredient)

      bowls.each do |name, bowl|
        bowl.prepare
      end
    end

    method_option :whiskfile,
      type: :string,
      default: File.join(Dir.pwd, Whisk::DEFAULT_FILENAME),
      desc: "Path to a Whiskfile to operate off of.",
      aliases: "-w",
      banner: "PATH"
    desc "status", "run git status in your bowls"
    def status(bowl=nil, ingredient=nil)
      whiskfile = ::Whisk::WhiskFile.from_file(options[:whiskfile])
      bowls = filter_bowls(whiskfile.bowls, bowl, ingredient)
      bowls.each do |name, bowl|
        bowl.status
      end
    end

    method_option :whiskfile,
      type: :string,
      default: File.join(Dir.pwd, Whisk::DEFAULT_FILENAME),
      desc: "Path to a Whiskfile to operate off of.",
      aliases: "-w",
      banner: "PATH"
    desc "update", "run git remote update in your bowls"
    def update(bowl=nil, ingredient=nil)
      whiskfile = ::Whisk::WhiskFile.from_file(options[:whiskfile])
      bowls = filter_bowls(whiskfile.bowls, bowl, ingredient)
      bowls.each do |name, bowl|
        bowl.update
      end
    end
  end
end
