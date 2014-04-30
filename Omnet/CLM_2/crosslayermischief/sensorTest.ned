//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//
package clm_2.crosslayermischief;


import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.ethernet.Eth100M;
import inet.nodes.inet.Router;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.WirelessHost;
import inet.nodes.internetcloud.InternetCloud;
import ned.DatarateChannel;
import inet.nodes.inet.AdhocHost;
import inet.nodes.wireless.AccessPoint;
import inet.world.radio.ChannelControl;

network sensorTest
{
    types:
        channel C extends DatarateChannel
        {
            delay = 20ms;
            datarate = 5Mbps;
        }
        channel ethline extends DatarateChannel
        {
            delay = 50ns;
            datarate = 100Mbps;
        }
    submodules:
        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=50,50");
        }

		server: StandardHost {
		 		@display("p=100,100");   
		}

        // TE Access Point
        factoryAccessPoint: AccessPoint {
            @display("p=400,250");
        }

        senF1: Sensor {
            @display("p=600,50");
        }

        channelControl: ChannelControl {
            @display("p=115,165");
        }

    connections:
        server.ethg++ <--> ethline <--> factoryAccessPoint.ethg++;
}


