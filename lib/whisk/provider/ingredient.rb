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

require 'grit'
require 'whisk/mixin/shellout'

class Whisk
  class Provider
    class Ingredient < Provider

      include Whisk::Mixin::ShellOut

      def checkout
        if resource.ref
          if self.current_ref == resource.ref
            Whisk.ui.info "Ingredient '#{resource.name}' already at ref '#{resource.ref}'"
          else
            Whisk.ui.info "Checking out ref '#{resource.ref}' for ingredient '#{resource.name}'"
            cmd = run_command!("git checkout #{resource.ref}", :cwd => resource.path)
            cmd.stdout.lines.each do |line|
              Whisk.ui.info "\s\s#{line}"
            end
            cmd.stderr.lines.each do |line|
              Whisk.ui.info "\s\s#{line}"
            end
          end
        end
      end

      def clone
        if git.exist?
          Whisk.ui.info "Ingredient '#{resource.name}' already prepared"
        else
          Whisk.ui.info "Cloning ingredient '#{resource.name}', " + "from url #{resource.source}"
          cmd = run_command!("git clone #{resource.source} #{resource.path}")
          cmd.stdout.lines.each do |line|
            Whisk.ui.info "\s\s#{line}"
          end
          cmd.stderr.lines.each do |line|
            Whisk.ui.info "\s\s#{line}"
          end
        end
      end

      def current_ref
        cref = run_command!("git rev-parse --abbrev-ref HEAD", :cwd => resource.path).stdout.chomp
        if cref == 'HEAD'
          return run_command!("git describe --tags", :cwd => resource.path).stdout.chomp
        else
          return cref
        end
      end

      def git
        Grit::Git.new(resource.path)
      end

      def repo
        Grit::Repo.new(resource.path)
      end
      def action_diff
        Whisk.ui.info "Diff for ingredient '#{resource.name}'"
        shell_out!("git diff", :cwd => resource.path)
      end

      def action_prepare
        self.clone
        self.checkout
      end

      def action_status
        Whisk.ui.info "Status for ingredient '#{resource.name}'"
        cmd = run_command!("git status", :cwd => resource.path)
        cmd.stdout.lines.each do |line|
          Whisk.ui.info "\s\s#{line}"
        end
        cmd.stderr.lines.each do |line|
          Whisk.ui.info "\s\s#{line}"
        end
        Whisk.ui.info "\n"
      end

      def action_update
        Whisk.ui.info "Updating ingredient '#{resource.name}'"
        cmd = run_command!("git remote update", :cwd => resource.path)
        cmd.stdout.lines.each do |line|
          Whisk.ui.info "\s\s#{line}"
        end
        cmd.stderr.lines.each do |line|
          Whisk.ui.info "\s\s#{line}"
        end
      end
    end
  end
end
