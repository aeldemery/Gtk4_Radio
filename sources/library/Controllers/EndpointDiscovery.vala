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

    public Gee.ArrayList<string> get_api_urls () {
        return new Gee.ArrayList<string> ();
    }

    public string get_fastest_api_url () {
        return "";
    }
}