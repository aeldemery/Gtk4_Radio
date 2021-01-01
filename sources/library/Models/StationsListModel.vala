// Copyright (c) 2021 Ahmed Eldemery
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

public class Gtk4Radio.StationsListModel : GLib.Object, GLib.ListModel {
    public uint get_n_items () {
        return 0;
    }

    public GLib.Type get_item_type () {
        return typeof (Station);
    }

    public GLib.Object ? get_item (uint position) {
        return null;
    }
    public StationsListModel () {
    }
}