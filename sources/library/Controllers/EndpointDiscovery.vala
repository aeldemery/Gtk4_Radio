// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * Lookup DNS server list, find the fastest server
 */
public class Gtk4Radio.EndpoinDiscovery : Object {
    string user_agent;

    /**
     * {@inheritDoc}
     * @param user_agent string user_agent to pass to the server.
     */
    public EndpoinDiscovery (string user_agent) {
        this.user_agent = user_agent;
    }

    /**
     * Lookup the Endpoint service and return a list of available server names.
     *
     * @param service of url, for example "api" or "ldap".
     * @param protocol type of protocol, for example "tcp".
     * @param domain the base host name, for example "example.info".
     * @return ArrayList of all available servers, there is no garantee that all are working.
     * @throw NetworkError
     */
    public Gee.ArrayList<string> get_api_urls (string service, string protocol, string domain) throws Error.NetworkError {
        var result = new Gee.ArrayList<string> ();
        var resolver = GLib.Resolver.get_default ();

        try {
            var records = resolver.lookup_service (service, protocol, domain);

            foreach (var record in records) {
                result.add (record.get_hostname ());
            }
        } catch (GLib.Error error) {
            critical ("Unknown Host Name: " + error.message);
            throw new Error.NetworkError ("Could'n retrieve list of servers");
        }
        return result;
    }

    /**
     * Loop through all available endpoint addresses and determine the fastest server.
     *
     * @param urls ArrayList of string urls to examin.
     * @return string the calculated fast responding server.
     * @throw NetworkError
     */
    public string get_fastest_api_url (Gee.ArrayList<string> urls) throws Error.NetworkError {
        return "";
    }

    /**
     * Return Web service stats, like number of Server status, Stations, Languages
     *
     * @param string the server url
     * @return {@link ServerStats} of the given api_url
     * @throw NetworkError
     */
    public Gtk4Radio.ServerStats get_server_stats (string api_url) throws Error.NetworkError {
        return new Gtk4Radio.ServerStats ();
    }
}