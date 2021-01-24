public class Gtk4Radio.FaviconGridView : Gtk.Widget {
    GLib.ListStore icons;
    Gee.ArrayList<Station> stations_by_votes;
    NetworkController controller;
    FaviconDownloader favicon_downloader;
    string api_url;

    Gtk.ScrolledWindow sw;
    Gtk.GridView gridview;
    Gtk.SignalListItemFactory factory;

    construct {
        sw = new Gtk.ScrolledWindow ();
        gridview = new Gtk.GridView (null, null);
        factory = new Gtk.SignalListItemFactory ();
    }

    static construct {
        set_layout_manager_type (typeof (Gtk.GridLayout));
    }

    public FaviconGridView () {
        icons = new GLib.ListStore (typeof (Gdk.Pixbuf));
        stations_by_votes = new Gee.ArrayList<Station> ();

        try {
            var endpoint = new EndpoinDiscovery (USER_AGENT);
            var urls = endpoint.get_api_urls ("radio-browser.info", "api");
            api_url = urls[0];
        } catch (Gtk4Radio.Error err) {
            critical ("%s\n", err.message);
        }

        controller = new NetworkController (api_url, USER_AGENT);
        favicon_downloader = new FaviconDownloader ();

        construct_station_list ();

        construct_favicon_list ();

        sw.hscrollbar_policy = sw.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
        sw.hexpand = sw.vexpand = true;
        sw.set_child (gridview);

        factory.setup.connect (setup_gridview_item);
        factory.bind.connect (bind_gridview_item);

        gridview.model = new Gtk.SingleSelection (icons);
        gridview.factory = factory;

        sw.set_parent (this);
    }

    void construct_station_list () {
        var loop = new MainLoop (GLib.MainContext.default ());
        controller.list_stations_by_votes.begin (100, (obj, res) => {
            try {
                stations_by_votes = controller.list_stations_by_votes.end (res);
            } catch (Gtk4Radio.Error err) {
                critical (err.message);
            } finally {
                loop.quit ();
            }
        });
        loop.run ();
    }

    void construct_favicon_list () {
        var loop = new MainLoop (GLib.MainContext.default ());
        foreach (var station in stations_by_votes) {
            favicon_downloader.get_favicon_pixbuf.begin (station.favicon, (obj, res) => {
                var pixbuf = favicon_downloader.get_favicon_pixbuf.end (res);
                if (pixbuf != null) icons.append (pixbuf);
                loop.quit ();
            });
            loop.run ();
        }
    }

    protected override void dispose () {
        sw.unparent ();
        base.dispose ();
    }

    void setup_gridview_item (Gtk.SignalListItemFactory factory, Gtk.ListItem item) {
        var image = new Gtk.Image ();
        image.set_size_request (64, 64);
        item.set_child (image);
    }

    void bind_gridview_item (Gtk.SignalListItemFactory factory, Gtk.ListItem item) {
        var image = (Gtk.Image)item.get_child ();
        var pixbuf = (Gdk.Pixbuf)item.get_item ();

        image.set_from_pixbuf (pixbuf);
    }
}
