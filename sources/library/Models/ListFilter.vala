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

    /** reverse the result list if set to true, default is false */
    public bool reverse { get; set; default = false; }

    /** do not count broken stations, default is true */
    public bool hide_brocken { get; set; default = false; }

    /**
     * Build a string containing pairs of "key=value",
     * if multiple have been changed from the default, then append "&" as a separator
     */
    public string build_request_string () {
        var builder = new StringBuilder ("?");

        if (order != FilterOrder.NAME) builder.append_printf ("order=%s&", order.to_string ());
        if (reverse == true) builder.append ("reverse=true&");
        if (hide_brocken == true) builder.append ("hidebrocken=true&");

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
