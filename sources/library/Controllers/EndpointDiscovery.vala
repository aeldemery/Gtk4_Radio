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
     * @param domain the base host name, for example "example.info".
     * @param service of url, for example "api" or "ldap".
     * @param protocol type of protocol, for example "tcp".
     * @param add_https_prefix add "https://" to the returned host name
     * @return ArrayList of all available servers, there is no garantee that all are working.
     * @throw NetworkError
     */
    public Gee.ArrayList<string> get_api_urls (string domain, string service, NetworkProtocol protocol = NetworkProtocol.TCP, bool add_https_prefix = true) throws Gtk4Radio.Error {
        var result = new Gee.ArrayList<string> ();
        var resolver = GLib.Resolver.get_default ();

        var prefix = "";
        if (add_https_prefix) {
            prefix = "https://";
        }

        try {
            GLib.List<GLib.SrvTarget> records = resolver.lookup_service (service, protocol.to_string (), domain);

            foreach (GLib.SrvTarget record in records) {
                result.add (prefix + record.get_hostname ());
            }
        } catch (GLib.Error err) {
            throw new Error.NetworkError ("EndpointDiscover:get_api_urls:Could'n retrieve list of servers: %s\n", err.message);
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

        foreach (string url in urls) {
            timer.start ();
            try {
                ServerStats stats = this.get_server_stats (url + "/json/stats");
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
                throw new Error.NetworkError ("EndpointDiscovery:get_fastest_api_url:Couldn't retrieve server stats: %s\n", err.message);
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
            GLib.Bytes bytes = session.load_uri_bytes (api_url, null, out content_type);
            var str = (string) bytes.get_data ();

            try {
                Json.Node root = (!) Json.from_string (str);

                var result = (ServerStats) Json.gobject_deserialize (typeof (Gtk4Radio.ServerStats), root);
                return result;
            } catch (GLib.Error err) {
                throw new Error.ParsingError ("EndpointDiscovery:get_server_stats:Couldn't parse Json response to ServerStats: %s\n", err.message);
            }
        } catch (GLib.Error err) {
            throw new Error.NetworkError ("EndpointDiscovery:get_server_stats:Couldn't retrieve server stats: %s\n", err.message);
        }
    }
}

/**
 * Common Network Protocols
 */
public enum Gtk4Radio.NetworkProtocol {
    /** Transmission Control Protocol (TCP) */
    TCP,
    /** Internet Protocol (IP)  */
    IP,
    /**  User Datagram Protocol (UDP)  */
    UDP,
    /**  Post office Protocol (POP)  */
    POP,
    /**  Simple mail transport Protocol (SMTP)  */
    SMTP,
    /**  File Transfer Protocol (FTP)  */
    FTP,
    /**  Hyper Text Transfer Protocol (HTTP)  */
    HTTP,
    /**  Hyper Text Transfer Protocol Secure (HTTPS)  */
    HTTPS,
    /**  Telnet  */
    TELNET,
    /**  Gopher  */
    GOPHER,
    /**  ARP (Address Resolution Protocol)  */
    ARP,
    /**  DHCP (Dynamic Host Configuration Protocol)  */
    DHCP,
    /**  IMAP4 (Internet Message Access Protocol)  */
    IMAP4,
    /**  SIP (Session Initiation Protocol)  */
    SIP,
    /**  RTP (Real-Time Transport Protocol)  */
    RTP,
    /**  RLP (Resource Location Protocol)  */
    RLP,
    /**  RAP (Route Access Protocol)  */
    RAP,
    /**  L2TP (Layer Two Tunnelling Protocol)  */
    L2TP,
    /**  PPTP (Point To Point Tunnelling Protocol)  */
    PPTP,
    /**  SNMP (Simple Network Management Protocol)  */
    SNMP,
    /**  TFTP (Trivial File Transfer Protocol)  */
    TFTP;

    public string to_string () {
        switch (this) {
            case TCP: return "tcp";
            case IP: return "ip";
            case UDP: return "udp";
            case POP: return "pop";
            case SMTP: return "smtp";
            case FTP: return "ftp";
            case HTTP: return "http";
            case HTTPS: return "https";
            case TELNET: return "telnet";
            case GOPHER: return "gopher";
            case ARP: return "arp";
            case DHCP: return "dhcp";
            case IMAP4: return "imap4";
            case SIP: return "sip";
            case RTP: return "rtp";
            case RLP: return "rlp";
            case RAP: return "rap";
            case L2TP: return "l2tp";
            case PPTP: return "pptp";
            case SNMP: return "snmp";
            case TFTP: return "tftp";
            default: return "";
        }
    }
}
