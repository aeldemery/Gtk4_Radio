// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/** Web service stats. */
public class Gtk4Radio.ServerStats : GLib.Object {
    public int clicks_last_day { get; set; default = 0; }
    public int clicks_last_hour { get; set; default = 0; }
    public int countries { get; set; default = 0; }
    public int languages { get; set; default = 0; }
    public string software_version { get; set; default = ""; }
    public int stations  { get; set; default = 0; }
    public int stations_broken { get; set; default = 0; }
    public string status { get; set; default = ""; }
    public int supported_version { get; set; default = 0; }
    public int tags { get; set; default = 0; }

    public string to_string () {
        var builder = new StringBuilder ();

        builder.append_printf ("Status: %s\n", status);
        builder.append_printf ("Software version: %s\n", software_version);
        builder.append_printf ("Supported version: %d\n", supported_version);

        builder.append_printf ("Number of Stations: %d\n", stations);
        builder.append_printf ("Number of brocken Stations: %d\n", stations_broken);
        builder.append_printf ("Number of Countries: %d\n", countries);
        builder.append_printf ("Number of Languages: %d\n", languages);
        builder.append_printf ("Number of Tags: %d\n", tags);

        builder.append_printf ("Clicks last day: %d\n", clicks_last_day);
        builder.append_printf ("Clicks last hour: %d\n", clicks_last_hour);

        return builder.str;
    }
}
