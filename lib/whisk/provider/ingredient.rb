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

require 'whisk/mixin/shellout'

class Whisk
  class Provider
    class Ingredient < Provider

      include Whisk::Mixin::ShellOut

      def clone
        if ::File.exists? File.join(Dir.pwd, resource.name, ".git", "config")
          Whisk.ui.info "Ingredient '#{resource.name}' already prepared"
        else
          Whisk.ui.info "Cloning ingredient '#{resource.name}', " + "from url #{resource.source}"
          shell_out!("git clone #{resource.source} #{resource.name}")
        end
      end

      def current_ref
        cref = run_command!("git rev-parse --abbrev-ref HEAD", :cwd => resource.name).stdout.chomp
        if cref == 'HEAD'
          return run_command!("git describe", :cwd => resource.name).stdout.chomp
        else
          return cref
        end
      end

      def checkout
        if resource.ref
          if self.current_ref == resource.ref
            Whisk.ui.info "Ingredient '#{resource.name}' already at ref '#{resource.ref}'"
          else
            Whisk.ui.info "Checking out ref '#{resource.ref}' for ingredient '#{resource.name}'"
            shell_out!("git checkout #{resource.ref}", :cwd => resource.name)
          end
        end
      end

      def action_prepare
        self.clone
        self.checkout
      end

      def action_status
        Whisk.ui.info "Status for ingredient '#{resource.name}'"
        shell_out!("git status", :cwd => resource.name)
      end

      def action_update
        Whisk.ui.info "Updating ingredient '#{resource.name}'"
        shell_out!("git remote update", :cwd => resource.name)
      end
    end
  end
end
