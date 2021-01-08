// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

int main (string[] args) {
    // var app = new Gtk4Radio.RadioApplication ();
    // return app.run (args);

    GLib.Intl.setlocale ();
    try {
        var endpoint = new Gtk4Radio.EndpoinDiscovery (Gtk4Radio.USER_AGENT);
        var urls = endpoint.get_api_urls ("radio-browser.info", "api");
        var controller = new Gtk4Radio.NetworkController (urls[0], Gtk4Radio.USER_AGENT);

        var loop = new MainLoop ();

        // Test all stations
        /*
        var stations = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.list_all_stations.begin ((obj, res) => {
            try {
                stations = controller.list_all_stations.end (res);
                print ("Got %d Stations\n", stations.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }

            loop.quit ();
        });
        loop.run ();
        */

        /*
        var countries = new Gee.ArrayList<Gtk4Radio.Codec> ();

        controller.list_codecs.begin (list_filter, (obj, res) => {
            try {
                countries = controller.list_codecs.end (res);
                print ("Got %d items\n", countries.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        foreach (var country in countries) {
            print (country.to_string() + "\n");
        }
        */

        var list_filter = new Gtk4Radio.ListFilter ();
        print (list_filter.build_request_string () + "\n");
        list_filter.order = Gtk4Radio.FilterOrder.STATION_COUNT;
        list_filter.search_term = "bad";
        // list_filter.reverse = true;
        print (list_filter.build_request_string () + "\n");
        
        var states = new Gee.ArrayList<Gtk4Radio.State> ();
        controller.list_states.begin("Germany", list_filter, (obj, res) => {
            try {
                states = controller.list_states.end (res);
                print ("Got %d items\n", states.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        /*  foreach (var state in states) {
            //print (state.to_string() + "\n");
        }  */

    } catch (Gtk4Radio.Error err) {
        critical (err.message);
    }

    return 0;
}
