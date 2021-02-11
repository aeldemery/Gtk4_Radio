public class Gtk4Radio.StationColumnView : Gtk.Widget {
    Gtk.ColumnView columnview;
    Gtk.ColumnViewColumn column;
    Gtk.ScrolledWindow sw;

    Gtk.SingleSelection selection;
    Gtk.SignalListItemFactory factory;

    StationsListModel station_model;

    const string[] column_headers = {
        "Station Name",
        "Url",
        "Country",
        "Language",
        "Tags",
        "Favicon",
        "Last Check Time",
    };

    static construct {
        set_layout_manager_type (typeof (Gtk.GridLayout));
    }

    public StationColumnView (StationsListModel model) {
        this.station_model = model;
        selection = new Gtk.SingleSelection (station_model);
        selection.autoselect = true;
        selection.can_unselect = false;

        sw = new Gtk.ScrolledWindow ();
        sw.vscrollbar_policy = sw.hscrollbar_policy = Gtk.PolicyType.AUTOMATIC;

        columnview = new Gtk.ColumnView (selection);
        columnview.show_column_separators = true;
        columnview.hexpand = columnview.vexpand = true;

        // Column 1, Station Name
        factory = new Gtk.SignalListItemFactory ();

        factory.setup.connect (setup_columnview_item);
        factory.bind.connect (bind_station_name_item);

        column = new Gtk.ColumnViewColumn (column_headers[0], factory);
        column.resizable = true;
        columnview.append_column (column);

        // Column 2, Url
        factory = new Gtk.SignalListItemFactory ();

        factory.setup.connect (setup_columnview_item);
        factory.bind.connect (bind_station_url_item);

        column = new Gtk.ColumnViewColumn (column_headers[1], factory);
        column.resizable = true;
        columnview.append_column (column);

        // Column 3, Country
        factory = new Gtk.SignalListItemFactory ();

        factory.setup.connect (setup_columnview_item);
        factory.bind.connect (bind_station_country_item);

        column = new Gtk.ColumnViewColumn (column_headers[2], factory);
        column.resizable = true;
        columnview.append_column (column);

        // Column 4, Language
        factory = new Gtk.SignalListItemFactory ();

        factory.setup.connect (setup_columnview_item);
        factory.bind.connect (bind_station_language_item);

        column = new Gtk.ColumnViewColumn (column_headers[3], factory);
        column.resizable = true;
        columnview.append_column (column);

        // Column 5, Tags
        factory = new Gtk.SignalListItemFactory ();

        factory.setup.connect (setup_columnview_item);
        factory.bind.connect (bind_station_tags_item);

        column = new Gtk.ColumnViewColumn (column_headers[4], factory);
        column.resizable = true;
        columnview.append_column (column);

        // Column 6, Favicon
        factory = new Gtk.SignalListItemFactory ();

        factory.setup.connect (setup_columnview_item);
        factory.bind.connect (bind_station_favicon_item);

        column = new Gtk.ColumnViewColumn (column_headers[5], factory);
        column.resizable = true;
        columnview.append_column (column);

        // Column 7, Last Check Time
        factory = new Gtk.SignalListItemFactory ();

        factory.setup.connect (setup_columnview_item);
        factory.bind.connect (bind_station_lastchecktime_item);

        column = new Gtk.ColumnViewColumn (column_headers[6], factory);
        column.resizable = true;
        columnview.append_column (column);

        sw.edge_reached.connect ((position_type) => {
            model.load_next_page ();
        });

        sw.set_child (columnview);
        sw.set_parent (this);
    }

    void setup_columnview_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var label = new Gtk.Label ("");
        label.max_width_chars = 50;
        label.ellipsize = Pango.EllipsizeMode.END;
        label.selectable = true;
        list_item.set_child (label);
    }

    void bind_station_name_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var label = (Gtk.Label)list_item.get_child ();
        var item = (Station) list_item.get_item ();

        label.label = item.name;
        label.tooltip_text = item.name;
    }

    void bind_station_url_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var label = (Gtk.Label)list_item.get_child ();
        var item = (Station) list_item.get_item ();

        label.label = item.url;
        label.tooltip_text = item.url;
    }

    void bind_station_country_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var label = (Gtk.Label)list_item.get_child ();
        var item = (Station) list_item.get_item ();

        label.label = item.country;
        label.tooltip_text = item.country;
    }

    void bind_station_language_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var label = (Gtk.Label)list_item.get_child ();
        var item = (Station) list_item.get_item ();

        label.label = item.language;
        label.tooltip_text = item.language;
    }

    void bind_station_tags_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var label = (Gtk.Label)list_item.get_child ();
        var item = (Station) list_item.get_item ();

        label.label = item.tags;
        label.tooltip_text = item.tags;
    }

    void bind_station_favicon_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var label = (Gtk.Label)list_item.get_child ();
        var item = (Station) list_item.get_item ();

        label.label = item.favicon;
        label.tooltip_text = item.favicon;
    }

    void bind_station_lastchecktime_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var label = (Gtk.Label)list_item.get_child ();
        var item = (Station) list_item.get_item ();

        label.label = item.lastchecktime;
        label.tooltip_text = item.lastchecktime;
    }

    protected override void dispose () {
        sw.unparent ();
        base.dispose ();
    }
}
