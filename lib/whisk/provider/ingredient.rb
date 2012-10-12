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

      def add_remotes
        resource.remotes.each_pair do |remote, url|
          add_remote(remote, url)
        end
      end

      def add_remote(remote, url)
        ::Dir.chdir resource.path
        if repo.config.keys.include?("remote.#{remote}.url")
          if remote_changed? remote
            Whisk.ui.info "Remote #{remote} points to a different url"
            a = Whisk.ui.ask_question("Would you like to change it to point to #{url} ?",
                  {:default => 'y'}
            )
            if a =~ /y/i
              run_command!("git remote rm #{remote}")
            else
              Whisk.ui.info("Skipping out of date remote #{remote}")
              return
            end
          else
            Whisk.ui.info "Remote #{remote} already added"
            return
          end
        end
        Whisk.ui.info "Adding remote #{remote} to ingredient #{resource.name}"
        run_command!("git remote add #{remote} #{url}")
        return
      end

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
          if remote_changed?("origin", resource.source)
            reset_origin
          else
            Whisk.ui.info "Ingredient '#{resource.name}' already prepared"
          end
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

      def destroy
        if git.exist?
          Whisk.ui.info "Destroying Ingredient #{resource.name}"
          ::FileUtils.rm_rf resource.path
        else
          Whisk.ui.info "Ingredient #{resource.name} already destroyed"
        end
      end

      def git
        Grit::Git.new(resource.path)
      end

      def repo
        Grit::Repo.new(resource.path)
      end

      def remote_changed?(remote, source)
        if git.exist? and resource.source != repo.config["remote.#{remote}.url"]
          Whisk.ui.info "Remote origin has changed for ingredient #{resource.name}"
          true
        else
          false
        end
      end

      def reset_origin
        if remote_changed?("origin", new_source.source)
          a = Whisk.ui.ask_question(
            "Would you like to remove ingredient #{resource.name} before proceeding ?",
            { :default => 'y' }
          )
          if a =~ /y/i
            ::FileUtils.rm_rf resource.path
            clone
          else
            Whisk.ui.warn "Aborting whisk"
            exit 1
          end
        end
      end

      def action_diff
        Whisk.ui.info "Diff for ingredient '#{resource.name}'"
        shell_out!("git diff", :cwd => resource.path)
      end

      def action_prepare
        self.clone
        self.checkout
        self.add_remotes
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
