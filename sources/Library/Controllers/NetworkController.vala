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
        session.user_agent = user_agent;
        session.max_conns = 256;
        session.timeout = 15;
    }

    /**
     * Async Version: A JSON-encoded list of all countries in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public async Gee.ArrayList<Country> list_countries_async (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/countries/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Country> (root);
    }

    /**
     * A JSON-encoded list of all countries in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public Gee.ArrayList<Country> list_countries (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/countries/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Country> (root);
    }

    /**
     * Async Version: A JSON-encoded list of all countries by code in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public async Gee.ArrayList<CountryCode> list_countries_by_code_async (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/countrycodes/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<CountryCode> (root);
    }

    /**
     * A JSON-encoded list of all countries by code in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public Gee.ArrayList<CountryCode> list_countries_by_code (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/countrycodes/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<CountryCode> (root);
    }

    /**
     * Async Version: A JSON-encoded list of all codecs in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of codecs and station count for each.
     */
    public async Gee.ArrayList<Codec> list_codecs_async (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/codecs/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Codec> (root);
    }

    /**
     * A JSON-encoded list of all codecs in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of codecs and station count for each.
     */
    public Gee.ArrayList<Codec> list_codecs (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/codecs/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Codec> (root);
    }

    /**
     * Async Version: A JSON-encoded list of all states in the database.
     * Countries are divided into states. If a filter is given,
     * it will only return the ones containing the filter as substring.
     * If a country is given, it will only display states in this country
     *
     * @param country the name of the country the state belongs to, please not that it's case senttive!
     * @return list of codecs and station count for each.
     */
    public async Gee.ArrayList<State> list_states_async (string country = "", ListFilter list_filter = new ListFilter ()) throws Gtk4Radio.Error {
        string resource = "/json/states/";
        if (country != "") {
            resource += country + "/";
        }
        resource += list_filter.search_term;
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<State> (root);
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
    public Gee.ArrayList<State> list_states (string country = "", ListFilter list_filter = new ListFilter ()) throws Gtk4Radio.Error {
        string resource = "/json/states/";
        if (country != "") {
            resource += country + "/";
        }
        resource += list_filter.search_term;
        resource += list_filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<State> (root);
    }

    /**
     * Async Version: A JSON-encoded list of all languages in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of languages and station count for each.
     */
    public async Gee.ArrayList<Language> list_languages_async (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/languages/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Language> (root);
    }

    /**
     * A JSON-encoded list of all languages in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of languages and station count for each.
     */
    public Gee.ArrayList<Language> list_languages (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/languages/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Language> (root);
    }

    /**
     * Async Version: A JSON-encoded list of all tags in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of tags and station count for each.
     */
    public async Gee.ArrayList<Tag> list_tags_async (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/tags/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Tag> (root);
    }

    /**
     * A JSON-encoded list of all tags in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of tags and station count for each.
     */
    public Gee.ArrayList<Tag> list_tags (ListFilter list_filter) throws Gtk4Radio.Error {
        string resource = @"/json/tags/$(list_filter.search_term)";
        resource += list_filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Tag> (root);
    }

    /**
     * Async Version: List all **Stations**, Adjustment can be made through the search filter.
     * The variants with "exact" will only search for perfect matches,
     * and others will search for the station whose attribute contains the search term.
     *
     * @param search_by either byuuid, byname, bycountry ...etc.
     * @param query_filter Instance of {@link StationQueryFilter}, if null will return all stations.
     * @return list of stations.
     */
    public async Gee.ArrayList<Station> list_stations_by_async (SearchBy search_by, string search_term, StationListFilter filter) throws Gtk4Radio.Error {
        string resource = @"/json/stations/$search_by/";
        resource += search_term;
        resource += filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
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
    public Gee.ArrayList<Station> list_stations_by (SearchBy search_by, string search_term, StationListFilter filter) throws Gtk4Radio.Error {
        string resource = @"/json/stations/$search_by/";
        resource += search_term;
        resource += filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * List all **Stations**, Adjustment can be made through the search filter.
     *
     * @param query_filter Instance of {@link StationQueryFilter}.
     * @return {@link GLib.InputStream} of Stations.
     */
    public async GLib.InputStream ? list_stations_by_async_stream (SearchBy search_by, string search_term, StationListFilter filter) throws Gtk4Radio.Error {
        string resource = @"/json/stations/$search_by/";
        resource += search_term;
        resource += filter.build_request_params ();
        string uri_string = api_url + resource;

        GLib.InputStream stream = null;

        debug (uri_string + "\n");

        var msg = new Soup.Message ("POST", uri_string);
        try {
            stream = yield session.send_async (msg, GLib.Priority.DEFAULT);

            if (Utils.check_response_status_is_ok (msg) == true) {
                return stream;
            }
        } catch (GLib.Error err) {
            throw new Error.NetworkError ("NetworkController:list_all_stations:Couldn't get stations: %s\n", err.message);
        }
        return stream;
    }

    /**
     * Async Version: List all **Stations**.
     *
     * @return list of stations in Gee.ArrayList.
     */
    public async Gee.ArrayList<Station> list_all_stations_async (StationListFilter filter) throws Gtk4Radio.Error {
        string resource = "/json/stations";
        resource += filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * List all **Stations**.
     *
     * @return list of stations in Gee.ArrayList.
     */
    public Gee.ArrayList<Station> list_all_stations (StationListFilter filter) throws Gtk4Radio.Error {
        string resource = "/json/stations";
        resource += filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * Async Version: Advanced Station Search.
     *
     * @param query_filter Instance of {@link StationQueryFilter}.
     * @return list of stations in Gee.ArrayList.
     */
    public async Gee.ArrayList<Station> search_stations_async (StationQueryFilter query_filter) throws Gtk4Radio.Error {
        string resource = "/json/stations/search";
        resource += query_filter.build_request_params ();

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * Advanced Station Search.
     *
     * @param query_filter Instance of {@link StationQueryFilter}.
     * @return list of stations in Gee.ArrayList.
     */
    public Gee.ArrayList<Station> search_stations (StationQueryFilter query_filter) throws Gtk4Radio.Error {
        string resource = "/json/stations/search";
        resource += query_filter.build_request_params ();

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * List all **Stations**.
     *
     * @return list of stations in Gee.ArrayList.
     */
    public async GLib.InputStream ? list_all_stations_async_stream (StationListFilter filter) throws Gtk4Radio.Error {
        string resource = @"/json/stations";
        resource += filter.build_request_params ();
        string uri_string = api_url + resource;

        GLib.InputStream stream = null;

        debug (uri_string + "\n");

        var msg = new Soup.Message ("POST", uri_string);
        try {
            stream = yield session.send_async (msg, GLib.Priority.DEFAULT);

            if (Utils.check_response_status_is_ok (msg) == true) {
                return stream;
            }
        } catch (GLib.Error err) {
            throw new Error.NetworkError ("NetworkController:list_all_stations:Couldn't get stations: %s\n", err.message);
        }
        return stream;
    }

    /**
     * Async Version: A list of the stations that are clicked the most.
     * You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by clicks.
     */
    public async Gee.ArrayList<Station> list_stations_by_clicks_async (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/topclick/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of the stations that are clicked the most.
     * You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by clicks.
     */
    public Gee.ArrayList<Station> list_stations_by_clicks (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/topclick/$num_stations";

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * Async Version: A list of the highest-voted stations. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by votes.
     */
    public async Gee.ArrayList<Station> list_stations_by_votes_async (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/topvote/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of the highest-voted stations. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by votes.
     */
    public Gee.ArrayList<Station> list_stations_by_votes (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/topvote/$num_stations";

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * Async Version: A list of stations that were clicked recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations last checked.
     */
    public async Gee.ArrayList<Station> list_stations_by_recent_click_async (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/lastclick/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of stations that were clicked recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations last checked.
     */
    public Gee.ArrayList<Station> list_stations_by_recent_click (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/lastclick/$num_stations";

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * Async Version: A list of stations that were added or changed recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations recently changed.
     */
    public async Gee.ArrayList<Station> list_stations_by_recent_change_async (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/lastchange/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of stations that were added or changed recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations recently changed.
     */
    public Gee.ArrayList<Station> list_stations_by_recent_change (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/lastchange/$num_stations";

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * Async Version: A list of the stations that need improvements,
     * which means they do not have e.g. tags, country, state information.
     * You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations in need for improvement.
     */
    public async Gee.ArrayList<Station> list_improvable_stations_async (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/improvable/$num_stations";

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
    public Gee.ArrayList<Station> list_improvable_stations (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/improvable/$num_stations";

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * Async Version: A list of the stations that did not pass the connection test, You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of brocken stations.
     */
    public async Gee.ArrayList<Station> list_brocken_stations_async (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/broken/$num_stations";

        Json.Node ? root = yield send_message_request_async (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * A list of the stations that did not pass the connection test, You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of brocken stations.
     */
    public Gee.ArrayList<Station> list_brocken_stations (uint num_stations) throws Gtk4Radio.Error {
        string resource = @"/json/stations/broken/$num_stations";

        Json.Node ? root = send_message_request (resource);

        return decode_json_array<Station> (root);
    }

    /**
     * Async Version: Increase the vote count for the station by one.
     * Can only be done by the same IP address for one station every 10 minutes.
     * If it works, the changed station will be returned as result.
     *
     * @param station_uuid to vote for.
     * @return true if successfull, otherwise false
     */
    public async bool vote_for_station_async (string station_uuid) throws Gtk4Radio.Error {
        string resource = @"/json/vote/$station_uuid";

        Json.Node ? root = yield send_message_request_async (resource);

        Json.Object ? obj = root.get_object ();
        if (obj != null) {
            string ok = obj.get_string_member ("ok");
            string str_message = obj.get_string_member ("message");

            debug ("vote_for_station result: %s, %s\n", ok, str_message);

            if (ok == "true") {
                message (@"Voted Successfully: $str_message");
                return true;
            } else if (ok == "false") {
                message (@"Vote Error: $str_message");
            }
        }
        return false;
    }

    /**
     * Increase the vote count for the station by one.
     * Can only be done by the same IP address for one station every 10 minutes.
     * If it works, the changed station will be returned as result.
     *
     * @param station_uuid to vote for.
     * @return true if successfull, otherwise false
     */
    public bool vote_for_station (string station_uuid) throws Gtk4Radio.Error {
        string resource = @"/json/vote/$station_uuid";

        Json.Node ? root = send_message_request (resource);

        Json.Object ? obj = root.get_object ();
        if (obj != null) {
            string ok = obj.get_string_member ("ok");
            string str_message = obj.get_string_member ("message");

            debug ("vote_for_station result: %s, %s\n", ok, str_message);

            if (ok == "true") {
                message (@"Voted Successfully: $str_message");
                return true;
            } else if (ok == "false") {
                message (@"Vote Error: $str_message");
            }
        }
        return false;
    }

    /**
     * Async Version: Add a radio station to the database.
     * Note that Name and Url of the Station are mandatory.
     * Name is maximum 400 chars.
     *
     * @param new_station to be added, name and url are mandatory.
     * @return Json with status of the transaction, including uuid of the new station.
     */
    public async bool add_station_async (Station new_station) throws Gtk4Radio.Error {
        var builder = new StringBuilder ();

        if (new_station.name == "" || new_station.url == "") {
            throw new Gtk4Radio.Error.BadRequest ("Name and Url of the new station are mandatory");
        }

        builder.append_printf ("?name=%s&", new_station.name);
        builder.append_printf ("url=%s&", new_station.url);
        builder.append_printf ("homepage=%s&", new_station.homepage);
        builder.append_printf ("favicon=%s&", new_station.favicon);
        builder.append_printf ("countrycode=%s&", new_station.countrycode);
        builder.append_printf ("state=%s&", new_station.state);
        builder.append_printf ("language=%s&", new_station.language);
        builder.append_printf ("tags=%s", new_station.tags);

        string resource = @"/json/add$(builder.str)";

        Json.Node ? root = yield send_message_request_async (resource);

        Json.Object ? obj = root.get_object ();
        if (obj != null) {
            string ok = obj.get_string_member ("ok");
            string str_message = obj.get_string_member ("message");
            string station_id = obj.get_string_member ("uuid");

            debug ("add_station result: %s, %s, %s\n", ok, str_message, station_id);

            if (ok == "true") {
                message (@"Added Station Successfully: $str_message\nNew Station ID: $station_id");
                return true;
            } else if (ok == "false") {
                message (@"Vote Error: $str_message");
            }
        }
        return false;
    }

    /**
     * Add a radio station to the database.
     * Note that Name and Url of the Station are mandatory.
     * Name is maximum 400 chars.
     *
     * @param new_station to be added, name and url are mandatory.
     * @return Json with status of the transaction, including uuid of the new station.
     */
    public bool add_station (Station new_station) throws Gtk4Radio.Error {
        var builder = new StringBuilder ();

        if (new_station.name == "" || new_station.url == "") {
            throw new Gtk4Radio.Error.BadRequest ("Name and Url of the new station are mandatory");
        }

        builder.append_printf ("?name=%s&", new_station.name);
        builder.append_printf ("url=%s&", new_station.url);
        builder.append_printf ("homepage=%s&", new_station.homepage);
        builder.append_printf ("favicon=%s&", new_station.favicon);
        builder.append_printf ("countrycode=%s&", new_station.countrycode);
        builder.append_printf ("state=%s&", new_station.state);
        builder.append_printf ("language=%s&", new_station.language);
        builder.append_printf ("tags=%s", new_station.tags);

        string resource = @"/json/add$(builder.str)";

        Json.Node ? root = send_message_request (resource);

        Json.Object ? obj = root.get_object ();
        if (obj != null) {
            string ok = obj.get_string_member ("ok");
            string str_message = obj.get_string_member ("message");
            string station_id = obj.get_string_member ("uuid");

            debug ("add_station result: %s, %s, %s\n", ok, str_message, station_id);

            if (ok == "true") {
                message (@"Added Station Successfully: $str_message\nNew Station ID: $station_id");
                return true;
            } else if (ok == "false") {
                message (@"Vote Error: $str_message");
            }
        }
        return false;
    }

    // Private methods, returns json root node
    async Json.Node ? send_message_request_async (string resource) throws Gtk4Radio.Error {
        var parser = new Json.Parser ();
        string uri_string = api_url + resource;

        debug (uri_string + "\n");

        var msg = new Soup.Message ("POST", uri_string);
        try {
            GLib.InputStream stream = yield session.send_async (msg, GLib.Priority.DEFAULT);

            if (Utils.check_response_status_is_ok (msg) == true) {
                try {
                    this.started_json_parsing ();
                    yield parser.load_from_stream_async (stream);

                    Json.Node ? root = parser.get_root ();
                    this.finished_json_parsing ();
                    return root;
                } catch (GLib.Error err) {
                    throw new Error.ParsingError ("NetworkController:send_message_request_async:Couldn't parse Json: %s\n", err.message);
                }
            } else {
                return null;
            }
        } catch (GLib.Error err) {
            throw new Error.NetworkError ("NetworkController:send_message_request_async:Couldn't get stations: %s\n", err.message);
        }
    }

    // Private methods, returns json root node
    Json.Node ? send_message_request (string resource) throws Gtk4Radio.Error {
        var parser = new Json.Parser ();
        string uri_string = api_url + resource;

        debug (uri_string + "\n");

        var msg = new Soup.Message ("POST", uri_string);
        try {
            GLib.InputStream stream = session.send (msg);

            if (Utils.check_response_status_is_ok (msg) == true) {
                try {
                    this.started_json_parsing ();
                    parser.load_from_stream (stream);

                    Json.Node ? root = parser.get_root ();
                    this.finished_json_parsing ();
                    return root;
                } catch (GLib.Error err) {
                    throw new Error.ParsingError ("NetworkController:send_message_request:Couldn't parse Json: %s\n", err.message);
                }
            } else {
                return null;
            }
        } catch (GLib.Error err) {
            throw new Error.NetworkError ("NetworkController:send_message_request:Couldn't get stations: %s\n", err.message);
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
