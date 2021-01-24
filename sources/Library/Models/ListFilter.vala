// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * ListFilter to pass as an argument to list retrieval functions,
 * for example `list_countries`, `list_codecs`, `list_states` ...
 */
public class Gtk4Radio.ListFilter : GLib.Object {
    GLib.StringBuilder builder;

    /**
     * {@inheritDoc}
     */
    public ListFilter () {
        builder = new StringBuilder ();

        this.notify.connect ((obj, prop) => {
            if (prop.value_type == typeof (string)) {
                // string value;
                // obj.get (prop.name, out value);
                // builder.append_printf ("_%s=%s_", prop.name, value);
            } else if (prop.value_type == typeof (bool)) {
                bool value;
                obj.get (prop.name, out value);
                builder.append_printf ("_%s=%s_", prop.name, value.to_string ());
            } else if (prop.value_type == typeof (FilterOrder)) {
                FilterOrder value;
                obj.get (prop.name, out value);
                builder.append_printf ("_%s=%s_", prop.name, value.to_string ());
            } else {
                assert_not_reached ();
            }
        });
    }
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
        // replace _ _ placeholder with &
        for (var i = 0; i < builder.len; i++) {
            if ((builder.str[i] == '_') && (builder.str[i + 1] == '_')) {
                builder.str = builder.str.splice (i, i + 2, "&");
            }
        }
        // remove leading/trailing _ and / and any wierd symbols
        builder.str = builder.str.replace ("_", "");

        if (builder.str != "" && (builder.str.get_char (0) != '?')) builder.prepend_c ('?');

        /*
           if (search_term != "") {
            search_term = search_term.replace ("/", "");

            for (var i = 0; i < search_term.length; i++) {
                if (search_term.get_char (i).isalnum ()) {
                    builder.append_unichar (search_term.get_char (i));
                }
            }
           }
         */
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
