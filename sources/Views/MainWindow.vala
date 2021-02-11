// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

public class Gtk4Radio.MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application app) {
        Object (application: app);

        this.default_height = 600;
        this.default_width = 800;

        var station_model = new StationsListModel ();
        // var station_view = new StationColumnView (station_model);
        // station_view.hexpand = station_view.vexpand = true;
        // this.set_child (station_view);

        var favicon_grid = new FaviconGridView (station_model);
        favicon_grid.hexpand = favicon_grid.vexpand = true;
        this.set_child (favicon_grid);
    }
}
