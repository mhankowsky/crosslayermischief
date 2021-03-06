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

package CrossLayerMischief_New;


import inet.applications.ethernet.EtherAppCli;
import inet.base.NotificationBoard;
import inet.linklayer.ieee80211.Ieee80211Nic;
import inet.mobility.static.StationaryMobility;
import inet.world.radio.ChannelControl;


module Sensor
{
    parameters:
        @display("i=device/wifilaptop");
        @node();
    gates:
        input radioIn @directIn;

    submodules:
        notificationBoard: NotificationBoard {
            parameters:
                @display("p=52,70");
        }
        cli: EtherAppCli {
            parameters:
                registerSAP = false;
                @display("b=40,24;p=180,60,col");
        }
        wlan: Ieee80211Nic {
            parameters:
                @display("p=112,134;q=queue");
                mgmtType = default("Ieee80211MgmtSTASimplified");
        }
        mobility: StationaryMobility {
            parameters:
                @display("p=50,141");
        }
    connections allowunconnected:
        wlan.radioIn <-- radioIn;
        cli.out --> wlan.upperLayerIn;
}
