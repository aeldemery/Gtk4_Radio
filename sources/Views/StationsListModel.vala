// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * This the ListModel to pass to GridView and ListView widgets,
 * which expect uniform interface of  get_item, get_n_items, get_item_type
 */
public class Gtk4Radio.StationsListModel : GLib.Object, GLib.ListModel {
    Gee.ArrayList<Station> stations;
    StationListFilter station_filter;
    NetworkController controller;

    construct {
        string url = EndpoinDiscovery.get_random_radiobrowser_service_url ();
        controller = new NetworkController (url, Constants.USER_AGENT);
        station_filter = new StationListFilter ();
        station_filter.page_size = 64;
        stations = new Gee.ArrayList<Station> ();

        load_content ();
    }

    private uint _page_size = 64;
    public uint page_size {
        get {
            return _page_size;
        }
        set {
            uint old_size = _page_size;
            _page_size = value;

            if (_page_size > old_size) {
                /** void items_changed (uint position, uint removed, uint added) */
                items_changed (old_size, 0, _page_size - old_size);
            } else if (old_size > _page_size) {
                items_changed (_page_size, old_size - _page_size, 0);
            }

            notify_property ("page_size");
        }
    }

    public StationsListModel () {
    }

    public uint get_n_items () {
        return page_size;
    }

    public GLib.Type get_item_type () {
        return typeof (Station);
    }

    public GLib.Object ? get_item (uint position) {
        if (stations.is_empty) {
            return null;
        } else {
            return stations[(int) position];
        }
    }

    void load_content () {
        try {
            stations = controller.list_all_stations (station_filter);
        } catch (Gtk4Radio.Error err) {
            warning (@"$(err.message)\n");
        }
    }

    public void load_next_page () {
        station_filter.next_page ();
        try {
            stations = controller.list_all_stations (station_filter);
            page_size = stations.size;
        } catch (Gtk4Radio.Error err) {
            warning (@"$(err.message)\n");
        }
    }
}
