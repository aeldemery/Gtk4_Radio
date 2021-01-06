// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * Lookup DNS server list, find the fastest server
 */
public class Gtk4Radio.EndpoinDiscovery : Object {
    Soup.Session session;

    /**
     * {@inheritDoc}
     * @param user_agent string user_agent to pass to the server.
     */
    public EndpoinDiscovery (string user_agent) {
        session = new Soup.Session ();
        session.user_agent = user_agent;
        session.max_conns = 8;
        session.timeout = 15;
    }

    /**
     * Lookup the Endpoint service and return a list of available server names.
     *
     * @param service of url, for example "api" or "ldap".
     * @param protocol type of protocol, for example "tcp".
     * @param domain the base host name, for example "example.info".
     * @param add_https_prefix add "https://" to the returned host name
     * @return ArrayList of all available servers, there is no garantee that all are working.
     * @throw NetworkError
     */
    public Gee.ArrayList<string> get_api_urls (string service, string protocol, string domain, bool add_https_prefix = true) throws Gtk4Radio.Error {
        var result = new Gee.ArrayList<string> ();
        var resolver = GLib.Resolver.get_default ();

        var prefix = "";
        if (add_https_prefix) {
            prefix = "https://";
        }

        try {
            var records = resolver.lookup_service (service, protocol, domain);

            foreach (var record in records) {
                result.add (prefix + record.get_hostname ());
            }
        } catch (GLib.Error error) {
            critical ("Unknown Host Name: %s", error.message);
            throw new Error.NetworkError ("Could'n retrieve list of servers");
        }
        return result;
    }

    /**
     * Loop through all available endpoint addresses and determine the fastest server.
     *
     * @param urls ArrayList of string urls to examin.
     * @param add_https_prefix add "https://" to the returned host name
     * @return string the calculated fast responding server.
     * @throw NetworkError
     */
    public string get_fastest_api_url (Gee.ArrayList<string> urls, bool add_https_prefix = true) throws Gtk4Radio.Error {
        double elapsed_time;
        double fastest_time = double.MAX;
        string fastest_url = "";

        var timer = new GLib.Timer ();

        foreach (var url in urls) {
            timer.start ();
            try {
                var stats = this.get_server_stats (url + "/json/stats");
                if (stats.status == "OK") {
                    timer.stop ();
                    elapsed_time = timer.elapsed ();

                    if (fastest_time > elapsed_time) {
                        fastest_time = double.min (fastest_time, elapsed_time);
                        fastest_url = url;
                    }
                } else {
                    timer.reset ();
                    continue;
                }
            } catch (Error.NetworkError err) {
                critical ("Couldn't retrieve server stats: %s", err.message);
                throw new Error.NetworkError ("Couldn't retrieve server stats");
            }
        }
        if (add_https_prefix && !fastest_url.has_prefix ("https://")) {
            return "https://" + fastest_url;
        } else {
            return fastest_url;
        }
    }

    /**
     * Return Web service stats, like number of Server status, Stations, Languages
     *
     * @param string the server url
     * @return {@link ServerStats} of the given api_url
     * @throw NetworkError
     */
    public Gtk4Radio.ServerStats get_server_stats (string api_url) throws Gtk4Radio.Error {
        string content_type;

        try {
            var bytes = session.load_uri_bytes (api_url, null, out content_type);
            var str = (string) bytes.get_data ();

            try {
                var parser = new Json.Parser ();
                parser.load_from_data (str);

                var root = parser.get_root ();

                var result = (Gtk4Radio.ServerStats)Json.gobject_deserialize (typeof (Gtk4Radio.ServerStats), root);
                return result;
            } catch (GLib.Error err) {
                critical ("Failed to parse Json object to ServerStats: %s", err.message);
                throw new Error.ParsingError ("Couldn't parse Json response to ServerStats");
            }
        } catch (GLib.Error err) {
            critical ("Unknown Host :s%", err.message);
            throw new Error.NetworkError ("Couldn't retrieve server stats");
        }
    }
}