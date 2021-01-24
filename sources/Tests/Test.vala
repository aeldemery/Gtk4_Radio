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

        var list_filter = new Gtk4Radio.ListFilter ();

        list_filter.order = Gtk4Radio.FilterOrder.STATION_COUNT;
        list_filter.search_term = "se";
        list_filter.reverse = true;
        list_filter.hide_brocken = false;

        var countries = new Gee.ArrayList<Gtk4Radio.Country> ();
        controller.list_countries.begin (list_filter, (obj, res) => {
            try {
                countries = controller.list_countries.end (res);
                print ("Got %d items\n", countries.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var countriescodes = new Gee.ArrayList<Gtk4Radio.CountryCode> ();
        controller.list_countries_by_code.begin (list_filter, (obj, res) => {
            try {
                countriescodes = controller.list_countries_by_code.end (res);
                print ("Got %d items\n", countriescodes.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var codecs = new Gee.ArrayList<Gtk4Radio.Codec> ();
        controller.list_codecs.begin (list_filter, (obj, res) => {
            try {
                codecs = controller.list_codecs.end (res);
                print ("Got %d items\n", codecs.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var states = new Gee.ArrayList<Gtk4Radio.State> ();
        controller.list_states.begin ("Germany", list_filter, (obj, res) => {
            try {
                states = controller.list_states.end (res);
                print ("Got %d items\n", states.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var languages = new Gee.ArrayList<Gtk4Radio.Language> ();
        controller.list_languages.begin (list_filter, (obj, res) => {
            try {
                languages = controller.list_languages.end (res);
                print ("Got %d items\n", languages.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var tags = new Gee.ArrayList<Gtk4Radio.Tag> ();
        controller.list_tags.begin (list_filter, (obj, res) => {
            try {
                tags = controller.list_tags.end (res);
                print ("Got %d items\n", tags.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var query = new Gtk4Radio.StationQueryFilter ();
        query.country = "Germany";
        query.language = "german";

        var advanced_search = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.search_stations.begin (query, (obj, res) => {
            try {
                advanced_search = controller.search_stations.end (res);
                print ("Got %d items\n", advanced_search.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var by_country = Gtk4Radio.SearchBy.COUNTRY;
        var filter = new Gtk4Radio.StationListFilter ();
        filter.hidebrocken = true;
        filter.offset = 20;
        filter.reverse = true;

        var search_by_country = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.list_stations_by.begin (by_country, "germany", filter, (obj, res) => {
            try {
                search_by_country = controller.list_stations_by.end (res);
                print ("Got %d items\n", search_by_country.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var stations_by_clicks = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.list_stations_by_clicks.begin (30, (obj, res) => {
            try {
                stations_by_clicks = controller.list_stations_by_clicks.end (res);
                print ("Got %d items\n", stations_by_clicks.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var stations_by_votes = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.list_stations_by_votes.begin (30, (obj, res) => {
            try {
                stations_by_votes = controller.list_stations_by_votes.end (res);
                print ("Got %d items\n", stations_by_votes.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var stations_by_recent_clicks = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.list_stations_by_recent_click.begin (30, (obj, res) => {
            try {
                stations_by_recent_clicks = controller.list_stations_by_recent_click.end (res);
                print ("Got %d items\n", stations_by_recent_clicks.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var stations_by_recent_change = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.list_stations_by_recent_change.begin (30, (obj, res) => {
            try {
                stations_by_recent_change = controller.list_stations_by_recent_change.end (res);
                print ("Got %d items\n", stations_by_recent_change.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var improvable_stations = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.list_improvable_stations.begin (30, (obj, res) => {
            try {
                improvable_stations = controller.list_improvable_stations.end (res);
                print ("Got %d items\n", improvable_stations.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        var brocken_stations = new Gee.ArrayList<Gtk4Radio.Station> ();
        controller.list_brocken_stations.begin (30, (obj, res) => {
            try {
                brocken_stations = controller.list_brocken_stations.end (res);
                print ("Got %d items\n", brocken_stations.size);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            }
            loop.quit ();
        });
        loop.run ();

        // var favicon_url = stations_by_votes[0].favicon;
        // var favicon_downloader = new Gtk4Radio.FaviconDownloader ();
        // favicon_downloader.get_favicon.begin (favicon_url, (obj, res) => {
        // var image = favicon_downloader.get_favicon.end (res);
        ////print (image.get_icon_name ());
        // loop.quit ();
        // });
        // loop.run ();
    } catch (Gtk4Radio.Error err) {
        critical (err.message);
        return -1;
    }

    return 0;
}
