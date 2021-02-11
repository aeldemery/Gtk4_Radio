// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * Advanced station search filters.
 * It will search for the station whose attribute contains the search term.
 */
public class Gtk4Radio.StationQueryFilter : GLib.Object {
    /** MANDATORY if search by uuid of the station, otherwise OPTIONAL. */
    public string uuid  { get; set; default = ""; }

    /** OPTIONAL, name of the station. */
    public string name  { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool nameExact { get; set; default = false; }

    /** OPTIONAL, country of the station. */
    public string country   { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool countryExact { get; set; default = false; }

    /** OPTIONAL, 2-digit countrycode of the station (see ISO 3166-1 alpha-2). */
    public string countrycode { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool countrycodeExact { get; set; default = false; }

    /** OPTIONAL, state of the station. */
    public string state { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool stateExact { get; set; default = false; }

    /** OPTIONAL, language of the station */
    public string language { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool languageExact { get; set; default = false; }

    /** OPTIONAL, a tag of the station. */
    public string tag { get; set; default = ""; }

    /** OPTIONAL. True: only exact matches, otherwise all matches. */
    public bool tagExact { get; set; default = false; }

    /**
     * OPTIONAL. A comma-separated list of tags.
     * It can also be an array of string in JSON HTTP POST parameters.
     * All tags in list have to match.
     */
    public string tagList { get; set; default = ""; }

    /** OPTIONAL, codec of the station. */
    public string codec { get; set; default = ""; }

    /** OPTIONAL, minimum of kbps for bitrate field of stations in result. */
    public uint bitrateMin { get; set; default = 0; }

    /** OPTIONAL, maximum of kbps for bitrate field of stations in result. */
    public uint bitrateMax { get; set; default = 1000000; }

    /**
     * OPTIONAL, name of the attribute the result list will be sorted by, default is name.
     * Possible values: name, url, homepage, favicon, tags, country, state, language, votes, codec, bitrate, lastcheckok, lastchecktime, clicktimestamp, clickcount, clicktrend, random
     */
    public StationOrderBy order { get; set; default = StationOrderBy.NAME; }

    /** OPTIONAL, reverse the result list if set to true. */
    public bool reverse { get; set; default = false; }

    /** OPTIONAL, starting value of the result list from the database.
     * For example, if you want to do paging on the server side.
     */
    public uint offset { get; set; default = 0; }

    /** OPTIONAL, number of returned datarows (stations) starting with offset. */
    public uint limit { get; set; default = 100000; }

    /** do list/not list broken stations, default is false */
    public bool hidebrocken { get; set; default = false; }

    /** The number of items in one page to be returned, default is 128. */
    uint _page_size;
    public uint page_size {
        get {
            return _page_size;
        }
        set {
            _page_size = value; limit = page_size;
        }
    }

    GLib.HashTable<string, string> table;

    public StationQueryFilter () {
        table = new GLib.HashTable<string, string> (str_hash, str_equal);
        this.notify.connect ((obj, prop) => {
            if (prop.value_type == typeof (string)) {
                string value;
                obj.get (prop.name, out value);
                table.insert (prop.name, value.to_string ());
            } else if (prop.value_type == typeof (bool)) {
                bool value;
                obj.get (prop.name, out value);
                table.insert (prop.name, value.to_string ());
            } else if (prop.value_type == typeof (StationOrderBy)) {
                StationOrderBy value;
                obj.get (prop.name, out value);
                table.insert (prop.name, value.to_string ());
            } else if (prop.value_type == typeof (uint)) {
                uint value;
                obj.get (prop.name, out value);
                if (prop.name != "page-size") { // ignore page_size because it's not part of service api
                    table.insert (prop.name, value.to_string ());
                }
            } else {
                assert_not_reached ();
            }
        });
    }

    /**
     * Build a string containing pairs of "key=value",
     * if multiple have been changed from the default, then append "&" as a separator
     */
    public string build_request_params () {
        assert_nonnull (table);

        if (table.length == 0) {
            return "";
        }

        var builder = new StringBuilder ();
        table.foreach ((key, val) => {
            builder.append_printf ("%s=%s&", key, val);
        });

        if (builder.str[builder.len - 1] == '&') {
            builder.truncate (builder.len - 1);
        }
        builder.prepend_c ('?');
        print ("StationQueryFilter %s\n", builder.str);
        return builder.str;
    }

    public void previous_page () {
        uint new_offset = this.offset - this.page_size;
        uint new_limit = this.limit - page_size;
        if (new_offset < 0 || new_limit < page_size) {
            new_offset = 0;
            new_limit = page_size;
        }
        this.offset = new_offset;
        this.limit = new_limit;
    }

    public void next_page () {
        uint new_offset = this.offset + this.page_size;
        uint new_limit = this.limit + this.page_size;

        this.offset = new_offset;
        this.limit = new_limit;
    }
}

/**
 * Name of the attribute the result Station list will be sorted by. Default order is by `NAME`.
 */
public enum Gtk4Radio.StationOrderBy {
    NAME,
    URL,
    HOMEPAGE,
    FAVICON,
    TAGS,
    COUNTRY,
    STATE,
    LANGUAGE,
    VOTES,
    CODEC,
    BITRATE,
    LASTCHECKOK,
    LASTCHECKTIME,
    CLICKTIMESTAMP,
    CLICKCOUNT,
    CLICKTREND,
    RANDOM;

    /** Return string representions of enum members. */
    public string to_string () {
        var enumc = (GLib.EnumClass) typeof (StationOrderBy).class_ref ();
        unowned GLib.EnumValue ? eval = enumc.get_value (this);
        return_val_if_fail (eval != null, null);
        return eval.value_nick;
    }
}

/**
 * How to query for stations, the variants with "exact" will only search for perfect matches,
 * and others will search for the station whose attribute contains the search term.
 * If SearchBy.UUID, then it's mandatory to provide UUID in StationQueryFilter.
 */
public enum Gtk4Radio.SearchBy {
    UUID,
    URL,
    NAME,
    NAME_EXACT,
    CODEC,
    CODEC_EXACT,
    COUNTRY,
    COUNTRY_EXACT,
    COUNTRYCODE_EXACT,
    STATE,
    STATE_EXACT,
    LANGUAGE,
    LANGUAGE_EXACT,
    TAG,
    TAG_EXACT;

    /** Return string representions of enum members. */
    public string to_string () {
        switch (this) {
            case UUID: return "byuuid";
            case URL: return "byurl";
            case NAME: return "byname";
            case NAME_EXACT: return "bynameexact";
            case CODEC: return "bycodec";
            case CODEC_EXACT: return "bycodecexact";
            case COUNTRY: return "bycountry";
            case COUNTRY_EXACT: return "bycountryexact";
            case COUNTRYCODE_EXACT: return "bycountrycodeexact";
            case STATE: return "bystate";
            case STATE_EXACT: return "bystateexact";
            case LANGUAGE: return "bylanguage";
            case LANGUAGE_EXACT: return "bylanguageexact";
            case TAG: return "bytag";
            case TAG_EXACT: return "bytagexact";
            default: return "";
        }
    }
}

/**
 * Filter to pass for station search by name/uuid/country ...etc.
 * This is different from {@link Gtk4Radio.StationQueryFilter} because it contains limited parameters.
 */
public class Gtk4Radio.StationListFilter : GLib.Object {
    GLib.HashTable<string, string> table;

    public StationListFilter () {
        table = new GLib.HashTable<string, string> (str_hash, str_equal);

        this.notify.connect ((obj, prop) => {
            if (prop.value_type == typeof (string)) {
                // string value;
                // obj.get (prop.name, out value);
                // table.insert (prop.name, value.to_string());
            } else if (prop.value_type == typeof (bool)) {
                bool value;
                obj.get (prop.name, out value);
                table.insert (prop.name, value.to_string ());
            } else if (prop.value_type == typeof (uint)) {
                uint value;
                obj.get (prop.name, out value);
                if (prop.name != "page-size") { // ignore page_size because it's not part of service api
                    table.insert (prop.name, value.to_string ());
                }
            } else if (prop.value_type == typeof (FilterOrder)) {
                FilterOrder value;
                obj.get (prop.name, out value);
                table.insert (prop.name, value.to_string ());
            } else {
                assert_not_reached ();
            }
        });
    }

    /**
     * OPTIONAL, name of the attribute the result list will be sorted by, default is name.
     * Possible values: name, url, homepage, favicon, tags, country, state, language, votes, codec, bitrate, lastcheckok, lastchecktime, clicktimestamp, clickcount, clicktrend, random
     */
    public StationOrderBy order { get; set; default = StationOrderBy.NAME; }
    /** OPTIONAL, reverse the result list if set to true. */
    public bool reverse { get; set; default = false; }

    /** OPTIONAL, starting value of the result list from the database.
     * For example, if you want to do paging on the server side.
     */
    public uint offset { get; set; default = 0; }

    /** OPTIONAL, number of returned datarows (stations) starting with offset. */
    public uint limit { get; set; default = 100000; }

    /** do list/not list broken stations, default is false */
    public bool hidebrocken { get; set; default = false; }

    /** The number of items in one page to be returned, default is 128. */
    uint _page_size;
    public uint page_size {
        get {
            return _page_size;
        }
        set {
            _page_size = value; limit = page_size;
        }
    }

    /**
     * Build a string containing pairs of "key=value",
     * if multiple have been changed from the default, then append "&" as a separator
     */
    public string build_request_params () {
        assert_nonnull (table);

        if (table.length == 0) {
            return "";
        }

        var builder = new StringBuilder ();
        table.foreach ((key, val) => {
            builder.append_printf ("%s=%s&", key, val);
        });

        if (builder.str[builder.len - 1] == '&') {
            builder.truncate (builder.len - 1);
        }
        builder.prepend_c ('?');
        print ("StationListFilter %s\n", builder.str);
        return builder.str;
    }

    public void previous_page () {
        uint new_offset = this.offset - this.page_size;
        uint new_limit = this.limit - page_size;
        if (new_offset < 0 || new_limit < page_size) {
            new_offset = 0;
            new_limit = page_size;
        }
        this.offset = new_offset;
        this.limit = new_limit;
    }

    public void next_page () {
        uint new_offset = this.offset + this.page_size;
        uint new_limit = this.limit + this.page_size;

        this.offset = new_offset;
        this.limit = new_limit;
    }
}
