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
    public bool name_exact { get; set; default = false; }

    /** OPTIONAL, country of the station. */
    public string country   { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool country_exact { get; set; default = false; }

    /** OPTIONAL, 2-digit countrycode of the station (see ISO 3166-1 alpha-2). */
    public string countrycode { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool countrycode_exact { get; set; default = false; }

    /** OPTIONAL, state of the station. */
    public string state { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool state_exact { get; set; default = false; }

    /** OPTIONAL, language of the station */
    public string language { get; set; default = ""; }

    /** OPTIONAL. if true: only exact matches, otherwise all matches. */
    public bool language_exact { get; set; default = false; }

    /** OPTIONAL, a tag of the station. */
    public string tag { get; set; default = ""; }

    /** OPTIONAL. True: only exact matches, otherwise all matches. */
    public bool tag_exact { get; set; default = false; }

    /**
     * OPTIONAL. A comma-separated list of tags.
     * It can also be an array of string in JSON HTTP POST parameters.
     * All tags in list have to match.
     */
    public string tag_list { get; set; default = ""; }

    /** OPTIONAL, codec of the station. */
    public string codec { get; set; default = ""; }

    /** OPTIONAL, minimum of kbps for bitrate field of stations in result. */
    public uint bitrate_min { get; set; default = 0; }

    /** OPTIONAL, maximum of kbps for bitrate field of stations in result. */
    public uint bitrate_max { get; set; default = 1000000; }

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
    public bool hide_brocken { get; set; default = false; }

    /**
     * Build a string containing pairs of "key=value",
     * if multiple have been changed from the default, then append "&" as a separator
     */
    public string build_request_string () {
        var result = new StringBuilder ("?");

        // Test if all members have been set
        if (uuid != "") result.append_printf ("uuid=%s&" + uuid);
        if (name != "") result.append_printf ("name=%s&" + name);
        if (name_exact == true) result.append ("nameExact=true&");
        if (country != "") result.append_printf ("country=%s&" + country);
        if (country_exact == true) result.append ("countryExact=true&");
        if (countrycode != "") result.append_printf ("countrycode=%s&" + countrycode);
        if (countrycode_exact == true) result.append ("countrycodeExact=true&");
        if (state != "") result.append_printf ("state=%s&", state);
        if (state_exact == true) result.append ("stateExact=true&");
        if (language != "") result.append_printf ("uuid=%s&", language);
        if (language_exact == true) result.append ("languageExact=true&");
        if (tag != "") result.append_printf ("uuid=%s&", tag);
        if (tag_exact == true) result.append ("tagExact=true&");
        if (tag_list != "") result.append_printf ("tagList=%s&", tag_list);
        if (codec != "") result.append_printf ("codec=%s&", codec);
        if (bitrate_min != 0) result.append_printf ("bitrateMin=%u&", bitrate_min);
        if (bitrate_max != 1000000) result.append_printf ("bitrateMax=%u&", bitrate_max);
        if (order != StationOrderBy.NAME) result.append_printf ("order=%s&", order.to_string ());
        if (reverse == true) result.append ("reverse=true&");
        if (offset != 0) result.append_printf ("offset=%u&", offset);
        if (limit != 100000) result.append_printf ("limit=%u&", limit);
        if (hide_brocken == true) result.append ("hidebrocken=true&");

        return result.str;
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
