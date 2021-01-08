// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * This the ListModel to pass to GridView and ListView widgets,
 * which expect uniform interface of  get_item, get_n_items, get_item_type
 */
public class Gtk4Radio.StationsListModel : GLib.Object, GLib.ListModel {
    Gee.ArrayList<Station> all_stations;

    construct {
        var endpoint = new EndpoinDiscovery (USER_AGENT);
        try {
            Gee.ArrayList<string> urls = endpoint.get_api_urls ("radio-browser.info", "api");
            string url = endpoint.get_fastest_api_url (urls);
            var controller = new NetworkController (url, USER_AGENT);

            var loop = new MainLoop ();
            controller.list_all_stations.begin ((obj, res) => {
                try {
                    all_stations = controller.list_all_stations.end (res);
                } catch (Gtk4Radio.Error err) {
                    warning ("Couldn't fetch stations: %s\n", err.message);
                } finally {
                    loop.quit ();
                }
            });
            loop.run ();
        } catch (Gtk4Radio.Error err) {
            error ("Couldn't retrieve urls: %s\n", err.message);
        }
    }

    public StationsListModel () {
    }

    public uint get_n_items () {
        if (all_stations != null) {
            return all_stations.size;
        } else {
            return 0;
        }
    }

    public GLib.Type get_item_type () {
        return typeof (Station);
    }

    public GLib.Object ? get_item (uint position) {
        if (all_stations != null) {
            if (position > all_stations.size) {
                warning ("Trying to index outside bounds\n");
                var index = (int) uint.max (position, all_stations.size);
                return all_stations[index];
            } else {
                return all_stations[(int) position];
            }
        } else {
            return null;
        }
    }
}
