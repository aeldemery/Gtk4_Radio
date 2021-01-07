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

    public StationsListModel () {
        if (construct_all_stations () != true) {
            warning ("all_stations is null");
        }
    }

    bool construct_all_stations () {
        var endpoint = new EndpoinDiscovery (USER_AGENT);
        try {
            var urls = endpoint.get_api_urls ("radio-browser.info", "api");
            var controller = new NetworkController (urls[0], USER_AGENT);
            var loop = new MainLoop ();
            controller.list_all_stations.begin ( (obj, res) => {
                try {
                    all_stations = controller.list_all_stations.end (res);
                    loop.quit ();
                } catch (Gtk4Radio.Error err) {
                    warning ("Failed to construct all_stations: %s\n", err.message);
                }
            });
            return true;
        } catch (Gtk4Radio.Error err) {
            error ("Couldn't retrieve urls: %s\n", err.message);
        }
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
            var index = int.max ((int) position, all_stations.size);
            return all_stations.get (index);
        } else {
            return null;
        }
    }
}
