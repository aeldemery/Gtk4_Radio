// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/** Web service stats. */
public class Gtk4Radio.ServerStats : Object {
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
}
