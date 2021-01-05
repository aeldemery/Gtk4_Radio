// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * Lookup DNS server list, find the fastest server
 */
public class Gtk4Demo.EndpoinDiscovery : Object {
    public EndpoinDiscovery () {
    }

    /**
     * Lookup the Endpoint service and return a list of available server names.
     *
     * @param endpoint_url string of url.
     * @return ArrayList of all available servers, there is no garantee that all are working.
     * @throw NetworkError
     */
    public Gee.ArrayList<string> get_api_urls (string endpoint_url) throws Error.NetworkError {
        return new Gee.ArrayList<string> ();
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