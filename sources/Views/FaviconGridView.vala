public class Gtk4Radio.FaviconGridView : Gtk.Widget {
    StationsListModel station_model;
    FaviconDownloader favicon_downloader;

    Gtk.ScrolledWindow sw;
    Gtk.GridView gridview;
    Gtk.SignalListItemFactory factory;

    construct {
        sw = new Gtk.ScrolledWindow ();
        gridview = new Gtk.GridView (null, null);
        gridview.enable_rubberband = true;
        gridview.margin_bottom = gridview.margin_end = gridview.margin_start = gridview.margin_top = 20;
        gridview.max_columns = 10;
        factory = new Gtk.SignalListItemFactory ();
    }

    static construct {
        set_layout_manager_type (typeof (Gtk.GridLayout));
    }

    public FaviconGridView (StationsListModel model) {
        station_model = model;
        favicon_downloader = new FaviconDownloader ();

        sw.hscrollbar_policy = sw.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
        sw.hexpand = sw.vexpand = true;
        sw.set_child (gridview);

        factory.setup.connect (setup_gridview_item);
        factory.bind.connect (bind_gridview_item);

        gridview.model = new Gtk.SingleSelection (station_model);
        gridview.factory = factory;

        sw.edge_reached.connect ((position_type) => {
            station_model.load_next_page ();
        });
        sw.set_parent (this);
    }

    protected override void dispose () {
        sw.unparent ();
        base.dispose ();
    }

    void setup_gridview_item (Gtk.SignalListItemFactory factory, Gtk.ListItem item) {
        var image = new Gtk.Image ();
        image.set_size_request (196, 196);
        item.set_child (image);
    }

    void bind_gridview_item (Gtk.SignalListItemFactory factory, Gtk.ListItem item) {
        var image = (Gtk.Image)item.get_child ();
        var station = (Station) item.get_item ();
        var pixbuf = favicon_downloader.get_favicon_pixbuf_else_placeholder (station.favicon);
        //var pixbuf = Utils.load_pic_not_found ();

        image.set_from_pixbuf (pixbuf);
    }
}
