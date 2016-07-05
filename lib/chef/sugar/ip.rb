#
# Copyright 2013-2015, Seth Vargo <sethvargo@gmail.com>
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

class Chef
  module Sugar
    module IP
      extend self

      #
      # The best IP address for the given node, in the context of
      # the current node. Useful for choosing a local IP address
      # over a public one to limit bandwidth on cloud providers.
      #
      # @param [Chef::Node] other
      #   the node to calculate the best IP address for
      #
      def best_ip_for(node, other)
        if other['cloud']
          if node['cloud'] && other['cloud']['provider'] == node['cloud']['provider']
            other['cloud']['local_ipv4']
          else
            other['cloud']['public_ipv4']
          end
        else
          other['ipaddress']
        end
      end


      def interface_ip_for(other, interface)
        raise if other.nil?
        interface ||= other['network']['default_interface']
        return other['network']['interfaces'][interface]['addresses'].select { |_address, data| data['family'] == 'inet' }.first.first
      end

    end

    module DSL
      # @see Chef::Sugar::IP#best_ip_for
      def best_ip_for(other); Chef::Sugar::IP.best_ip_for(node, other); end

      # @see Chef::Sugar::IP#interface_ip_for
      def interface_ip_for(other, interface); Chef::Sugar::IP.interface_ip_for(other, interface); end
    end
  end
end
