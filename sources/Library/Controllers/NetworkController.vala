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
     * Signal started_json_parsing is emited whenever parsing of json response is started.
     */
    public signal void started_json_parsing ();

    /**
     * Signal finished_json_parsing is emited whenever parsing of json response is successfuly completed.
     */
    public signal void finished_json_parsing ();

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
    public async Gee.ArrayList<Country> list_countries (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = "/json/countries/";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Country> (root);
    }

    /**
     * A JSON-encoded list of all countries by code in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public async Gee.ArrayList<CountryCode> list_countries_by_code (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = "/json/countrycodes/";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<CountryCode> (root);
    }

    /**
     * A JSON-encoded list of all codecs in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of codecs and station count for each.
     */
    public async Gee.ArrayList<Codec> list_codecs (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = "/json/codecs/";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Codec> (root);
    }

    /**
     * A JSON-encoded list of all states in the database.
     * Countries are divided into states. If a filter is given,
     * it will only return the ones containing the filter as substring.
     * If a country is given, it will only display states in this country
     *
     * @param country the name of the country the state belongs to, please not that it's case senttive!
     * @return list of codecs and station count for each.
     */
    public async Gee.ArrayList<State> list_states (string country = "", ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = "/json/states/";
        if (country != "") {
            resource += country + "/";
        }
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<State> (root);
    }

    /**
     * A JSON-encoded list of all languages in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of languages and station count for each.
     */
    public async Gee.ArrayList<Language> list_languages (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = "/json/languages/";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Language> (root);
    }

    /**
     * A JSON-encoded list of all tags in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of tags and station count for each.
     */
    public async Gee.ArrayList<Tag> list_tags (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = "/json/tags/";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Tag> (root);
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
    public async Gee.ArrayList<Station> list_stations_by (SearchBy search_by, StationQueryFilter query_filter) throws Gtk4Radio.Error {
        string resource = @"/json/stations/$search_by/";
        resource += query_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
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
        string resource = "/json/stations/";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
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
        string resource = @"/json/stations/topclick/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of the highest-voted stations. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by votes.
     */
    public async Gee.ArrayList<Station> list_stations_by_votes (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/topvote/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of stations that were clicked recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations last checked.
     */
    public async Gee.ArrayList<Station> list_stations_by_recent_click (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/lastclick/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of stations that were added or changed recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations recently changed.
     */
    public async Gee.ArrayList<Station> list_stations_by_recent_change (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/lastchange/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
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
        string resource = @"/json/stations/improvable/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of the stations that did not pass the connection test, You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of brocken stations.
     */
    public async Gee.ArrayList<Station> list_brocken_stations (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/broken/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
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

    // Private methods, returns json root node
    async Json.Node ? send_message_request_async (string resource) throws Gtk4Radio.Error {
        var parser = new Json.Parser ();
        string uri_string = api_url + resource;

        print (uri_string + "\n");

        var msg = new Soup.Message ("POST", uri_string);
        try {
            GLib.InputStream stream = yield session.send_async (msg, Priority.DEFAULT);

            if (check_response_status (msg) == true) {
                try {
                    this.started_json_parsing ();
                    yield parser.load_from_stream_async (stream);

                    Json.Node ? root = parser.get_root ();
                    this.finished_json_parsing ();
                    return root;
                } catch (GLib.Error err) {
                    throw new Error.ParsingError ("NetworkController:list_all_stations:Couldn't parse Json: %s\n", err.message);
                }
            } else {
                return null;
            }
        } catch (GLib.Error err) {
            throw new Error.NetworkError ("NetworkController:list_all_stations:Couldn't get stations: %s\n", err.message);
        }
    }

    bool check_response_status (Soup.Message msg) throws Gtk4Radio.Error {
        if (msg.status_code != Soup.Status.OK) {
            throw new Error.NetworkError ("NetworkControllert:check_response_status: %s\n", msg.reason_phrase);
        } else {
            return true;
        }
    }

    Gee.ArrayList<T> decode_json_array<T> (Json.Node ? root) {
        var result = new Gee.ArrayList<T> ();
        if (root != null) {
            Json.Array ? arr = root.get_array ();
            if (arr != null) {
                arr.foreach_element ((array, index, element) => {
                    var item = (T) Json.gobject_deserialize (typeof (T), element);
                    result.add (item);
                });
            }
        }
        return result;
    }
}
