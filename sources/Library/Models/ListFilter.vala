// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * ListFilter to pass as an argument to list retrieval functions,
 * for example `list_countries`, `list_codecs`, `list_states` ...
 */
public class Gtk4Radio.ListFilter : Object {
    /** name of the attribute the result list will be sorted by, default is NAME. */
    public FilterOrder order { get; set; default = FilterOrder.NAME; }

    /** reverse the result list if set to true, default is false. */
    public bool reverse { get; set; default = false; }

    /** do not count broken stations, default is true. */
    public bool hide_brocken { get; set; default = false; }

    /** search term to add the the list filter, for example letters form country name. */
    public string search_term { get; set; default = ""; }

    /**
     * Build a string containing pairs of "key=value",
     * if multiple have been changed from the default, then append "&" as a separator
     */
    public string build_request_params () {
        var builder = new StringBuilder ();

        if (search_term != "") {
            search_term = search_term.replace ("/", "");

            for (var i = 0; i < search_term.length; i++) {
                if (search_term.get_char (i).isalnum ()) {
                    builder.append_unichar (search_term.get_char (i));
                }
            }
        }

        builder.append_printf ("?order=%s&", order.to_string ());
        builder.append_printf ("reverse=%s&", reverse ? "true" : "false");
        builder.append_printf ("hidebrocken=%s", hide_brocken ? "true" : "false");

        return builder.str;
    }
}

/**
 * Order of returned Lists, for example List of Country, Codec, States, Tages ...
 * Possible values either Order by NAME or STATION_COUNT
 */
public enum Gtk4Radio.FilterOrder {
    NAME,
    STATION_COUNT;

    public string to_string () {
        switch (this) {
            case NAME: return "name";
            case STATION_COUNT: return "stationcount";
            default: return "";
        }
    }
}
