// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/** Client controller to access the web service. */
public class Gtk4Radio.NetworkController {
    Soup.Session session;
    string user_agent;
    string api_url;

    /**
     * Signal started_parsing is emited whenever parsing of json response is started.
     */
    public signal void started_parsing ();

    /**
     * Signal finished_parsing is emited whenever parsing of json response is successfuly completed.
     */
    public signal void finished_parsing ();

    /**
     * {@inheritDoc}
     * @param api_url Endpoint API url.
     * @param user_agent "App/Version"
     */
    public NetworkController (string api_url, string user_agent) {
        this.api_url = api_url;
        this.user_agent = user_agent;

        session = new Soup.Session ();
        session.user_agent = @"$APP_ID/$APP_VERSION";
        session.max_conns = 8;
        session.timeout = 15;
    }

    /**
     * A JSON-encoded list of all countries in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public async Gee.HashMap<string, int> list_countries (ListFilter ? list_filter = null) throws Gtk4Radio.Error {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all countries by code in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public async Gee.HashMap<string, int> list_countries_by_code (ListFilter ? list_filter = null) throws Gtk4Radio.Error {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all codecs in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of codecs and station count for each.
     */
    public async Gee.HashMap<string, int> list_codecs (ListFilter ? list_filter = null) throws Gtk4Radio.Error {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all states in the database.
     * Countries are divided into states. If a filter is given,
     * it will only return the ones containing the filter as substring.
     * If a country is given, it will only display states in this country
     *
     * @return list of codecs and station count for each.
     */
    public async Gee.HashMap<string, int> list_states (ListFilter ? list_filter = null) throws Gtk4Radio.Error {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all languages in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of languages and station count for each.
     */
    public async Gee.HashMap<string, int> list_languages (ListFilter ? list_filter = null) throws Gtk4Radio.Error {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all tags in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of tags and station count for each.
     */
    public async Gee.HashMap<string, int> list_tags (ListFilter ? list_filter = null) throws Gtk4Radio.Error {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * List all **Stations**, Adjustment can be made through the search filter.
     * The variants with "exact" will only search for perfect matches,
     * and others will search for the station whose attribute contains the search term.
     *
     * @param search_by either byuuid, byname, bycountry ...etc.
     * @param query_filter Instance of {@link StationQueryFilter}, if null will return all stations.
     * @return list of stations.
     */
    public async Gee.ArrayList<Station> list_stations_by (SearchBy ? search_by = null, StationQueryFilter ? query_filter = null) throws Gtk4Radio.Error {
        var result = new Gee.ArrayList<Station> ();

        var search = api_url + "/json/stations/" + Gtk4Radio.SearchBy.COUNTRYCODE_EXACT.to_string () + "/EG";
        print (search + "\n");
        var msg = new Soup.Message ("POST", search);
        var param = new Soup.MessageHeaders (Soup.MessageHeadersType.MULTIPART);
        // var form = Soup.Form.encode_datalist ();

        param.set_encoding (Soup.Encoding.CONTENT_LENGTH);
        param.append ("", "");
        try {
            var input_stream = yield session.send_async (msg, Priority.DEFAULT);

            var data_stream = new GLib.DataInputStream (input_stream);
            var string_builder = new StringBuilder ();
            string line = null;

            while ((line = yield data_stream.read_line_async (Priority.DEFAULT)) != null) {
                string_builder.append (line);
                string_builder.append_c ('\n');
            }

            var parser = new Json.Parser ();
            parser.load_from_data (string_builder.str);
            var root = parser.get_root ();
            var arr = root.get_array ();
            arr.foreach_element ((array, index, element_node) => {
                var station = (Station) Json.gobject_deserialize (typeof (Station), element_node);
                assert_nonnull (station);
                result.add (station);
            });
        } catch (GLib.Error err) {
            critical ("Couldn't send request: %s\n", err.message);
        }
        return result;
    }

    /**
     * List all **Stations**, Adjustment can be made through the search filter.
     *
     * @param search_filter Instance of {@link StationQueryFilter}, if null will return all stations.
     * @return {@link GLib.InputStream} of Stations.
     */
    public async GLib.InputStream list_stations_by_stream (SearchBy ? search_by = null, StationQueryFilter ? query_filter = null) throws Gtk4Radio.Error {
        return new GLib.DataInputStream (null);
    }

    /**
     * List all **Stations**.
     *
     * @return list of stations in Gee.ArrayList.
     */
    public async Gee.ArrayList<Station> list_all_stations () throws Gtk4Radio.Error {
        var result = new Gee.ArrayList<Station> ();
        var parser = new Json.Parser ();
        var msg = new Soup.Message ("POST", api_url + "/json/stations");

        try {
            GLib.InputStream stream = yield session.send_async (msg, Priority.DEFAULT);

            if (check_response_status (msg) == true) {
                try {
                    this.started_parsing ();
                    yield parser.load_from_stream_async (stream);

                    Json.Node ? root = parser.get_root ();
                    if (root != null) {
                        Json.Array ? arr = root.get_array ();
                        if (arr != null) {
                            arr.foreach_element ((array, index, element) => {
                                var station = (Station) Json.gobject_deserialize (typeof (Station), element);
                                result.add (station);
                            });
                            this.finished_parsing ();
                        }
                    }
                } catch (GLib.Error err) {
                    throw new Error.ParsingError ("NetworkController:list_all_stations:Couldn't parse Json: %s\n", err.message);
                }
            }
        } catch (GLib.Error err) {
            throw new Error.NetworkError ("NetworkController:list_all_stations:Couldn't get stations: %s\n", err.message);
        }
        return result;
    }

    /**
     * List all **Stations**.
     *
     * @return list of stations in Gee.ArrayList.
     */
    public async GLib.InputStream list_all_stations_stream () {
        return new GLib.DataInputStream (null);
    }

    /**
     * A list of the stations that are clicked the most.
     * You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by clicks.
     */
    public async Gee.ArrayList<Station> list_stations_by_clicks (uint num_stations) throws Gtk4Radio.Error {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of the highest-voted stations. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by votes.
     */
    public async Gee.ArrayList<Station> list_stations_by_votes (uint num_stations) throws Gtk4Radio.Error {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of stations that were clicked recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations last checked.
     */
    public async Gee.ArrayList<Station> list_stations_by_recent_click (uint num_stations) throws Gtk4Radio.Error {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of stations that were added or changed recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations recently changed.
     */
    public async Gee.ArrayList<Station> list_stations_by_recent_change (uint num_stations) throws Gtk4Radio.Error {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of the stations that need improvements,
     * which means they do not have e.g. tags, country, state information.
     * You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations in need for improvement.
     */
    public async Gee.ArrayList<Station> list_improvable_stations (uint num_stations) throws Gtk4Radio.Error {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of the stations that did not pass the connection test, You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of brocken stations.
     */
    public async Gee.ArrayList<Station> list_brocken_stations (uint num_stations) throws Gtk4Radio.Error {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * Increase the vote count for the station by one.
     * Can only be done by the same IP address for one station every 10 minutes.
     * If it works, the changed station will be returned as result.
     *
     * @param station_uuid to vote for.
     * @return Json with "ok" : true if successfull, otherwise false
     */
    public string vote_for_station (string station_uuid) throws Gtk4Radio.Error {
        return "";
    }

    /**
     * Add a radio station to the database.
     * Note that Name and Url of the Station are mandatory.
     * Name is maximum 400 chars.
     *
     * @param new_station to be added, name and url are mandatory.
     * @return Json with status of the transaction, including uuid of the new station.
     */
    public string add_station (Station new_station) throws Gtk4Radio.Error {
        return "";
    }

    // Private methods
    async void send_message_request_async (string resource) throws Gtk4Radio.Error {
    }

    bool check_response_status (Soup.Message msg) {
        if (msg.status_code != Soup.Status.OK) {
            throw new Error.NetworkError ("NetworkControllert:check_response_status: %s\n", msg.reason_phrase);
        } else {
            return true;
        }
    }
}