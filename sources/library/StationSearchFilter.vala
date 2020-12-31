/**
 * Advanced station search
 * It will search for the station whose attribute contains the search term.
 */
public class Gtk4Radio.StationSearchFilter : Object {
    /** OPTIONAL, name of the station */
    public string name  { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool name_exact { get; set; default = false; }

    /** OPTIONAL, country of the station */
    public string country   { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool country_exact       { get; set; default = false; }

    /** OPTIONAL, 2-digit countrycode of the station (see ISO 3166-1 alpha-2). */
    public string countrycode       { get; set; default = ""; }

    /** OPTIONAL, state of the station */
    public string state     { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool state_exact { get; set; default = false; }

    /** OPTIONAL, language of the station */
    public string language  { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool language_exact { get; set; default = false; }

    /** OPTIONAL, a tag of the station */
    public string tag { get; set; default = ""; }

    /** OPTIONAL. True: only exact matches, otherwise all matches. */
    public bool tag_exact { get; set; default = false; }

    /**
     * OPTIONAL. A comma-separated list of tags.
     * It can also be an array of string in JSON HTTP POST parameters.
     * All tags in list have to match.
     */
    public string tag_list { get; set; default = ""; }

    /** OPTIONAL, codec of the station */
    public string codec { get; set; default = ""; }

    /** OPTIONAL, minimum of kbps for bitrate field of stations in result. */
    public uint bitrate_min { get; set; default = 0; }

    /** OPTIONAL, maximum of kbps for bitrate field of stations in result. */
    public uint bitrate_max { get; set; default = 1000000; }

    /**
     * OPTIONAL, name of the attribute the result list will be sorted by, default is name.
     * Possible values: name, url, homepage, favicon, tags, country, state, language, votes, codec, bitrate, lastcheckok, lastchecktime, clicktimestamp, clickcount, clicktrend, random
     */
    public OrderBy order { get; set; default = OrderBy.NAME; }

    /** OPTIONAL, reverse the result list if set to true. */
    public bool reverse { get; set; default = false; }

    /** OPTIONAL, starting value of the result list from the database.
     * For example, if you want to do paging on the server side.
     */
    public uint offset { get; set; default = 0; }

    /** OPTIONAL, number of returned datarows (stations) starting with offset. */
    public uint limit { get; set; default = 100000; }
}