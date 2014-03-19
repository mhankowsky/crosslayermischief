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
package crosslayermischief;


import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.ethernet.Eth100M;
import inet.nodes.inet.Router;
import inet.nodes.inet.StandardHost;
import inet.nodes.internetcloud.InternetCloud;
import ned.DatarateChannel;


network CloudAndRouters
{
    parameters:
        int numSenders;

    types:
        channel C extends DatarateChannel
        {
            delay = 20ms;
            datarate = 5Mbps;
        }
    submodules:
        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=61,163");
        }
		
		
        controlRouter: Router;
        controller: StandardHost;
        factoryRouter: Router;
        //Relplace StdHost with out AdHoc Model
        factory: StandardHost;
        internet: InternetCloud;

    connections:
        factoryRouter.pppg++ <--> C <--> internet.pppg++;
        factory.ethg++ <--> Eth100M <--> factoryRouter.ethg++;

        controlRouter.pppg++ <--> C <--> internet.pppg++;
        controller.ethg++ <--> Eth100M <--> controlRouter.ethg++;
}


