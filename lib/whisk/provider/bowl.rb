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

require 'chef/json_compat'
require 'whisk'
require 'whisk/provider'
require 'whisk/mixin/shellout'

class Whisk
  class Provider
    class Bowl < Provider

      include Whisk::Mixin::ShellOut

      def initialize(resource)
        super
        @environment = nil
      end

      def environment
        if resource.environment
          unless @environment.is_a? Chef::Environment
            env_json = run_command!("knife environment show -F json #{resource.environment}").stdout
            @environment = Chef::JSONCompat.from_json(env_json)
          end
        end
        @environment
      end

      def exist?
        ::Dir.exist? resource.path
      end

      def ingredients_run(action)
        resource.ingredients.each do |name, ingredient|
          if ingredient.ref == :ref_from_environment
            if environment and environment.cookbook_versions.has_key? ingredient.name
              ingredient.ref environment.cookbook_versions[ingredient.name]
            else
              Whisk.ui.warn "Cookbook version for ingredient #{name} not found in environment #{resource.environment}"
            end
          end
          ingredient.run_action(action)
        end
      end

      def knife_env
        cb_path = resource.path
        return {
          'WHISK_COOKBOOK_PATH' => cb_path
        }
      end

      def create
        unless self.exist?
          Whisk.ui.info "Creating bowl '#{resource.name}' with path #{resource.path}"
          ::FileUtils.mkdir_p resource.path
        end
      end

      def action_destroy
        if self.exist?
          ingredients_run("destroy")
          if Dir.entries(resource.path) == ["..", "."]
            Whisk.ui.info("Destroying empty bowl #{resource.name}")
            Dir.unlink(resource.path)
          end
        end
      end

      def action_diff
        if self.exist?
          ::Dir.chdir resource.path
          ingredients_run("diff")
        end
      end

      def action_list
        if self.exist?
          resource.ingredients.each do |name, ingredient|
            Whisk.ui.info("#{resource.name}/#{ingredient.name}")
          end
        end
      end

      def action_prepare
        self.create unless self.exist?
        ::Dir.chdir resource.path
        Whisk.ui.info "Preparing bowl '#{resource.name}' with path #{resource.path}"
        ingredients_run("prepare")
      end

      def action_status
        if self.exist?
          ::Dir.chdir resource.path
          Whisk.ui.info "Status for bowl '#{resource.name}' with path #{resource.path}"
          ingredients_run("status")
        end
      end

      def action_update
        if self.exist?
          ::Dir.chdir resource.path
          ingredients_run("update")
        end
      end

      def action_upload
        if self.exist?
          Whisk.ui.info "Uploading ingredients in bowl '#{resource.name}'"
          cookbooks = resource.ingredients.to_a.map {|name, cb| name}
          shell_out!("knife cookbook upload #{cookbooks.join(' ')}", :env => knife_env)
        end
      end
    end
  end
end
