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

require 'whisk'
require 'whisk/provider'

class Whisk
  class Provider
    class Bowl < Provider

      def exist?
        ::Dir.exist? resource.path
      end

      def ingredients_run(action)
        resource.ingredients.each do |name, ingredient|
          ingredient.run_action(action)
        end
      end

      def create
        unless self.exist?
          Whisk.ui.info "Creating bowl '#{resource.name}' with path #{resource.path}"
          ::FileUtils.mkdir_p resource.path
        end
      end

      def action_diff
        if self.exist?
          ::Dir.chdir resource.path
          ingredients_run("Diff")
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
    end
  end
end
