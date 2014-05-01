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
package CLM_2.crosslayermischief;


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

network teNetwork
{
    parameters:
        int numSensors = 10;

    types:
        channel C extends DatarateChannel
        {
            delay = 20ms;
            datarate = 5Mbps;
            per = 0.05;
        }
    submodules:
        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=50,50");
        }

        // TE Access Point
        factoryAccessPoint: AccessPoint {
            @display("p=400,250");
        }

        controller: FactoryController {
            @display("p=100,250");
        }
        //factoryBridge: FactoryBridge {
        //    @display("p=300,250");
        //}
        //internetCloud: InternetCloud {
        //    @display("p=205,251");
        //}

        actU1: Actuator {
            @display("p=500,100");
        }
        actU2: Actuator {
            @display("p=500,200");
        }
        actU3: Actuator {
            @display("p=500,300");
        }
        actU4: Actuator {
            @display("p=500,400");
        }

        senF1: Sensor {
            @display("p=600,50");
        }
        senF2: Sensor {
            @display("p=600,150");
        }
        senF3: Sensor {
            @display("p=600,250");
        }
        senF4: Sensor {
            @display("p=600,350");
        }
        senP: Sensor {
            @display("p=600,450");
        }
        senC: Sensor {
            @display("p=700,50");
        }
        senVL: Sensor {
            @display("p=700,150");
        }
        senYA3: Sensor {
            @display("p=700,250");
        }
        senYB3: Sensor {
            @display("p=700,350");
        }
        senYC3: Sensor {
            @display("p=700,450");
        }

        channelControl: ChannelControl {
            @display("p=115,165");
        }

    connections:

        //for i=0..numSenders-1 {
          //      factoryRouter.pppg++ <--> C <--> internet.pppg++;
            //    sensors[i].ethg++ <--> Eth100M <--> factoryRouter.ethg++;
        //}


        //factoryBridge.ethg++ <--> Eth100M <--> factoryAccessPoint.ethg++;
        //factoryBridge.pppg++ <--> C <--> internetCloud.pppg++;
        //controller.pppg++ <--> internetCloud.pppg++;
        factoryAccessPoint.ethg++ <--> Eth100M <--> controller.ethg++;
        
}


