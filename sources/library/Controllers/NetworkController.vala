public class Gtk4Radio.NetworkController {
    Soup.Session session;
    public NetworkController () {
        session = new Soup.Session ();
        session.user_agent = @"$APP_ID/$APP_VERSION";
    }

    /**
     * A JSON-encoded list of all countries in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public Gee.HashMap<string, int> list_countries (ListFilter ? list_filter = null) {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all countries by code in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of countries and station count for each.
     */
    public Gee.HashMap<string, int> list_countries_by_code (ListFilter ? list_filter = null) {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all codecs in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of codecs and station count for each.
     */
    public Gee.HashMap<string, int> list_codecs (ListFilter ? list_filter = null) {
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
    public Gee.HashMap<string, int> list_states (ListFilter ? list_filter = null) {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all languages in the database.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of languages and station count for each.
     */
    public Gee.HashMap<string, int> list_languages (ListFilter ? list_filter = null) {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * A JSON-encoded list of all tags in the database and there usage count.
     * If a filter is given, it will only return the ones containing the filter as substring.
     *
     * @return list of tags and station count for each.
     */
    public Gee.HashMap<string, int> list_tags (ListFilter ? list_filter = null) {
        return new Gee.HashMap<string, int> ();
    }

    /**
     * List all **Stations**, Adjustment can be made through the search filter.
     * The variants with "exact" will only search for perfect matches,
     * and others will search for the station whose attribute contains the search term.
     *
     * @param query_filter Instance of {@link StationQueryFilter}, if null will return all stations.
     * @return list of stations.
     */
    public Gee.ArrayList<Station> list_stations (SearchBy ? search_by = null, StationQueryFilter ? query_filter = null) {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * List all **Stations**, Adjustment can be made through the search filter.
     *
     * @param search_filter Instance of {@link StationQueryFilter}, if null will return all stations.
     * @return {@link GLib.InputStream} of Stations.
     */
    public GLib.InputStream list_stations_stream (SearchBy ? search_by = null, StationQueryFilter ? query_filter = null) {
        return new GLib.DataInputStream (null);
    }

    /**
     * A list of the stations that are clicked the most.
     * You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by clicks.
     */
    public Gee.ArrayList<Station> list_stations_by_clicks (uint num_stations) {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of the highest-voted stations. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations by votes.
     */
    public Gee.ArrayList<Station> list_stations_by_votes (uint num_stations) {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of stations that were clicked recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations last checked.
     */
    public Gee.ArrayList<Station> list_stations_by_recent_click (uint num_stations) {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of stations that were added or changed recently. You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of stations recently changed.
     */
    public Gee.ArrayList<Station> list_stations_by_recent_change (uint num_stations) {
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
    public Gee.ArrayList<Station> list_improvable_stations (uint num_stations) {
        return new Gee.ArrayList<Station> ();
    }

    /**
     * A list of the stations that did not pass the connection test, You can add a parameter with the number of wanted stations.
     *
     * @param number of wanted stations.
     * @return list of brocken stations.
     */
    public Gee.ArrayList<Station> list_brocken_stations (uint num_stations) {
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
    public string vote_for_station (string station_uuid) {
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
    public string add_station (Station new_station) {
        return "";
    }
}

/** Web service stats. */
public class Gtk4Radio.ServerStats : Object {
    public int clicks_last_day { get; set; default = 0; }
    public int clicks_last_hour { get; set; default = 0; }
    public int countries { get; set; default = 0; }
    public int languages { get; set; default = 0; }
    public string software_version { get; set; default = ""; }
    public int stations  { get; set; default = 0; }
    public int stations_broken { get; set; default = 0; }
    public string status { get; set; default = ""; }
    public int supported_version { get; set; default = 0; }
    public int tags { get; set; default = 0; }
}