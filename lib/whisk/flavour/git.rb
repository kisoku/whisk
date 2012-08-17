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

require 'whisk/mixin/shellout'
require 'whisk/ingredient'

class Whisk
  module Flavour
    module Git

      include Whisk::Mixin::ShellOut

      def clone
        if ::File.exists? File.join(Dir.pwd, name, ".git", "config")
          Whisk.ui.info "Ingredient #{self.name} already prepared, moving on"
        else
          Whisk.ui.info "Cloning ingredient #{self.name}, " + "from git url #{self.source}"
          shell_out("git clone #{self.source} #{self.name}")
        end
      end

      def checkout(ref="master")
        if self.options and self.options.has_key? :ref
          Whisk.ui.info "Checking out ref '#{ref}' for ingredient #{self.name}"
          shell_out("git checkout #{ref}", :cwd => self.name)
        end
      end

      def prepare
        begin
          self.clone
          self.checkout
        rescue Exception => e
          Whisk.ui.error "#{e.message} #{e.backtrace}"
          raise
        end
      end

      def status
          shell_out("git status", :cwd => self.name)
      end
    end
  end
end
