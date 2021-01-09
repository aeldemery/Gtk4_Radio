// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * Advanced station search filters.
 * It will search for the station whose attribute contains the search term.
 */
public class Gtk4Radio.StationQueryFilter : Object {
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

    StringBuilder builder;

    public StationQueryFilter () {
        builder = new StringBuilder ();
        this.notify.connect ((obj, prop) => {
            if (prop.value_type == typeof (string)) {
                string value;
                obj.get (prop.name, out value);
                builder.append_printf ("_%s=%s_", prop.name, value);
            } else if (prop.value_type == typeof (bool)) {
                bool value;
                obj.get (prop.name, out value);
                builder.append_printf ("_%s=%s_", prop.name, value.to_string ());
            } else if (prop.value_type == typeof (StationOrderBy)) {
                StationOrderBy value;
                obj.get (prop.name, out value);
                builder.append_printf ("_%s=%s_", prop.name, value.to_string ());
            } else if (prop.value_type == typeof (uint)) {
                uint value;
                obj.get (prop.name, out value);
                builder.append_printf ("_%s=%s_", prop.name, value.to_string ());
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
        // replace _ _ placeholder with &
        for (var i = 0; i < builder.len; i++) {
            if ((builder.str[i] == '_') && (builder.str[i + 1] == '_')) {
                builder.str = builder.str.splice (i, i + 2, "&");
            }
        }
        // remove leading/trailing _
        builder.str = builder.str.replace ("_", "");
        if (builder.str != "") builder.prepend_c ('?');
        return builder.str;
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
        EnumClass enumc = (EnumClass) typeof (StationOrderBy).class_ref ();
        unowned EnumValue ? eval = enumc.get_value (this);
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
