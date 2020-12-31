// Copyright (c) 2020 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * This models the Station structure as per
 * https://de1.api.radio-browser.info/
 */
public class Gtk4Radio.Station : Object {

    /** A globally unique identifier for the change of the station information */
    public string changeuuid { get; set; default = ""; }

    /** A globally unique identifier for the station */
    public string stationuuid { get; set; default = ""; }

    /** The name of the station */
    public string name { get; set; default = ""; }

    /** The stream URL provided by the user */
    public string url { get; set; default = ""; }

    /** An automatically "resolved" stream URL.
     * Things resolved are playlists (M3U/PLS/ASX...), HTTP redirects (Code 301/302).
     * This link is especially usefull if you use this API from a platform that is
     * not able to do a resolve on its own (e.g. JavaScript in browser)
     * or you just don't want to invest the time in decoding playlists yourself.
     */
    public string url_resolved { get; set; default = ""; }

    /** URL to the homepage of the stream, so you can direct the user to a page with
     * more information about the stream.
     */
    public string homepage { get; set; default = ""; }

    /** URL to an icon or picture that represents the stream. (PNG, JPG) */
    public string favicon { get; set; default = ""; }

    /** Tags of the stream with more information about it, split by comma. */
    public string tags { get; set; default = ""; }

    /** Deprecated: use countrycode instead, full name of the country.
     * @deprecated
     */
    public string country { get; set; default = ""; }

    /** Official countrycodes as in ISO 3166-1 alpha-2. */
    public string countrycode { get; set; default = ""; }

    /** Full name of the entity where the station is located inside the country. */
    public string state { get; set; default = ""; }

    /** Languages that are spoken in this stream, split by comma. */
    public string language { get; set; default = ""; }

    /** Number of votes for this station. This number is by server and only ever increases.
     * It will never be reset to 0.
     */
    public int votes { get; set; default = 0; }

    /** Last time when the stream information was changed in the database, in form YYYY-MM-DD HH:mm:ss. */
    public GLib.DateTime lastchangetime { get; set; default = new GLib.DateTime.from_iso8601 ("1970-01-01 00:00:00", null); }

    /** The codec of this stream recorded at the last check. */
    public string codec { get; set; default = ""; }

    /** The bitrate of this stream recorded at the last check. */
    public int bitrate { get; set; default = 0; }

    /** Mark if this stream is using HLS distribution or non-HLS. */
    public bool hls { get; set; default = false; }

    /** The current online/offline state of this stream.
     * This is a value calculated from multiple measure points in the internet.
     * The test servers are located in different countries. It is a majority vote.
     */
    public bool lastcheckok { get; set; default = false; }

    /** The last time when any radio-browser server checked the online state of this stream, in form YYYY-MM-DD HH:mm:ss. */
    public GLib.DateTime lastchecktime { get; set; default = new GLib.DateTime.from_iso8601 ("1970-01-01 00:00:00", null); }

    /** The last time when the stream was checked for the online status with a positive result, in form YYYY-MM-DD HH:mm:ss. */
    public GLib.DateTime lastcheckoktime { get; set; default = new GLib.DateTime.from_iso8601 ("1970-01-01 00:00:00", null); }

    /** The last time when this server checked the online state and the metadata of this stream, in form YYYY-MM-DD HH:mm:ss. */
    public GLib.DateTime lastlocalchecktime { get; set; default = new GLib.DateTime.from_iso8601 ("1970-01-01 00:00:00", null); }

    /** The time of the last click recorded for this stream, in form YYYY-MM-DD HH:mm:ss. */
    public GLib.DateTime clicktimestamp { get; set; default = new GLib.DateTime.from_iso8601 ("1970-01-01 00:00:00", null); }

    /** Clicks within the last 24 hours. */
    public int clickcount { get; set; default = 0; }

    /** The difference of the clickcounts within the last 2 days.
     * Posivite values mean an increase, negative a decrease of clicks.
     */
    public int clicktrend { get; set; default = 0; }

    public string to_string () {
        var builder = new StringBuilder ();

        builder.append_printf ("\nchangeuuid = %s\n", changeuuid);
        builder.append_printf ("stationuuid  = %s\n", stationuuid);
        builder.append_printf ("name = %s\n", name);
        builder.append_printf ("url = %s\n", url);
        builder.append_printf ("url_resolved = %s\n", url_resolved);
        builder.append_printf ("homepage = %s\n", homepage);
        builder.append_printf ("favicon = %s\n", favicon);
        builder.append_printf ("tags = %s\n", tags);
        builder.append_printf ("country = %s\n", country);
        builder.append_printf ("countrycode = %s\n", countrycode);
        builder.append_printf ("state = %s\n", state);
        builder.append_printf ("language = %s\n", language);
        builder.append_printf ("votes = %s\n", votes.to_string ());
        builder.append_printf ("lastchangetime = %s\n", lastchangetime.to_string ());
        builder.append_printf ("codec = %s\n", codec);
        builder.append_printf ("bitrate = %s\n", bitrate.to_string ());
        builder.append_printf ("hls = %s\n", hls.to_string ());
        builder.append_printf ("lastcheckok = %s\n", lastcheckok.to_string ());
        builder.append_printf ("lastchecktime = %s\n", lastchecktime.to_string ());
        builder.append_printf ("lastcheckoktime = %s\n", lastcheckoktime.to_string ());
        builder.append_printf ("clicktimestamp = %s\n", clicktimestamp.to_string ());
        builder.append_printf ("clickcount = %s\n", clickcount.to_string ());
        builder.append_printf ("clicktrend = %s\n", clicktrend.to_string ());

        return (owned) builder.str;
    }
}
