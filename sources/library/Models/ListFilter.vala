// Copyright (c) 2021 Ahmed Eldemery
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
 * ListFilter to pass as an argument to list retrieval functions,
 * for example `list_countries`, `list_codecs`, `list_states` ...
 */
public class Gtk4Radio.ListFilter : Object {
    /** Search term or optionally country name. */
    public string filter_term { get; set; default = ""; }
    /** name of the attribute the result list will be sorted by, default is NAME. */
    public FilterOrder order { get; set; default = FilterOrder.NAME; }

    /** reverse the result list if set to true, default is false */
    public bool reverse { get; set; default = false; }

    /** do not count broken stations, default is true */
    public bool hide_brocken { get; set; default = true; }
}

/**
 * Order of returned Lists, for example List of Country, Codec, States, Tages ...
 * Possible values either Order by NAME or STATION_COUNT
 */
public enum Gtk4Radio.FilterOrder {
    NAME,
    STATION_COUNT,
}