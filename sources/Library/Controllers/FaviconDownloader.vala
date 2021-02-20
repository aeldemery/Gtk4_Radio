// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

public class Gtk4Radio.FaviconDownloader : GLib.Object {
    Soup.Session session;

    public FaviconDownloader () {
        session = new Soup.Session ();
        var sniffer = new Soup.ContentSniffer ();
        session.add_feature (sniffer);
        session.user_agent = "Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20100101 Firefox/10.0";
        session.max_conns = 256;
        session.timeout = 15;
    }

    /**
     * Async Version: Download a favicon url into {@Gdk.Texture}
     * Currently it doesn't decode image correctly.
     *
     * @param url address to download from.
     * @return Gdk.Texture texture data with constant size.
     */
    public async Gdk.Texture ? get_favicon_texture_async (string uri, GLib.Cancellable ? cancellable = null) {
        Gdk.Texture texture = null;
        Gdk.Pixbuf? pixbuf = null;

        var stream = yield send_message_image_async (uri, cancellable);

        if (stream == null) {
            return null;
        }
        var loader = new Gdk.PixbufLoader ();

        loader.area_prepared.connect (() => {
            pixbuf = loader.get_pixbuf ();
        });
        
        yield read_image_stream_async (loader, stream, cancellable);

        if (pixbuf == null) {
            return null;
        }
        texture = Gdk.Texture.for_pixbuf (pixbuf);
        return texture;
    }

    /**
     * Async Version: Download a favicon url into {@Gdk.Texture}
     * Currently it doesn't decode image correctly.
     *
     * @param url address to download from.
     * @return Gdk.Texture texture data with constant size.
     */
    public Gdk.Texture ? get_favicon_texture (string uri, GLib.Cancellable ? cancellable = null) {
        Gdk.Texture texture = null;
        Gdk.Pixbuf? pixbuf = null;

        var stream = send_message_image (uri, cancellable);
        if (stream == null) {
            return null;
        }

        var loader = new Gdk.PixbufLoader ();
        
        loader.area_prepared.connect (() => {
            pixbuf = loader.get_pixbuf ();
        });
        
        read_image_stream (loader, stream, cancellable);

        if (pixbuf == null) {
            return null;
        }
        texture = Gdk.Texture.for_pixbuf (pixbuf);
        return texture;
    }

    /**
     * Async Version: Download a favicon url into {@Gdk.Pixbuf}
     *
     * @param url address to download from.
     * @return Gdk.Pixbuf contains pixbuf data.
     */
    public async Gdk.Pixbuf ? get_favicon_pixbuf_async (string url, GLib.Cancellable ? cancellable = null) {
        return yield fetch_pixbuf_async (url, cancellable);
    }

    /**
     * Download a favicon url into {@Gdk.Pixbuf}
     *
     * @param url address to download from.
     * @return Gdk.Pixbuf contains pixbuf data.
     */
    public Gdk.Pixbuf ? get_favicon_pixbuf (string url, GLib.Cancellable ? cancellable = null) {
        return fetch_pixbuf (url, cancellable);
    }

    /**
     * Download a favicon url into {@Gdk.Pixbuf}.
     * If it couldn't be downloaded, return placeholder image instead.
     *
     * @param url address to download from.
     * @return Gdk.Pixbuf contains pixbuf data or placeholder image.
     */
    public Gdk.Pixbuf get_favicon_pixbuf_else_placeholder (string uri, GLib.Cancellable ? cancellable = null) {
        var pixbuf = fetch_pixbuf (uri, cancellable);
        if (pixbuf == null) {
            return Utils.load_pic_not_found ();
        } else {
            return pixbuf;
        }
    }

    /*
     * Private methods
     */
    async Gdk.Pixbuf ? fetch_pixbuf_async (string uri, GLib.Cancellable ? cancellable = null) {
        Gdk.Pixbuf? pixbuf = null;
        var stream = yield send_message_image_async (uri, cancellable);

        if (stream == null) {
            return null;
        }
        var loader = new Gdk.PixbufLoader ();

        loader.area_prepared.connect (() => {
            pixbuf = loader.get_pixbuf ();
        });
        
        yield read_image_stream_async (loader, stream, cancellable);
        return pixbuf;
    }

    // Private functions
    Gdk.Pixbuf ? fetch_pixbuf (string uri, GLib.Cancellable ? cancellable = null) {
        Gdk.Pixbuf? pixbuf = null;

        var stream = send_message_image (uri, cancellable);
        if (stream == null) {
            return null;
        }
        var loader = new Gdk.PixbufLoader ();

        loader.area_prepared.connect (() => {
            pixbuf = loader.get_pixbuf ();
        });

        read_image_stream (loader, stream, cancellable);
        return pixbuf;
    }

    async GLib.DataInputStream ? send_message_image_async (string uri, GLib.Cancellable ? cancellable = null) {
        var message = new Soup.Message ("GET", uri);
        if (message == null) {
            return null;
        }
        try {
            GLib.InputStream stream = yield session.send_async (message, GLib.Priority.DEFAULT_IDLE, cancellable);

            var data_input_stream = new GLib.DataInputStream (stream);

            if (Utils.check_response_status_is_ok (message) && Utils.check_content_type_is_image (message, data_input_stream)) {
                return data_input_stream;
            } else {
                return null;
            }
        } catch (GLib.Error err) {
            warning ("Couldn't Load Icon form address %s: %s.\n", uri, err.message);
            return null;
        }
    }

    GLib.DataInputStream ? send_message_image (string uri, GLib.Cancellable ? cancellable = null) {
        var message = new Soup.Message ("GET", uri);
        if (message == null) {
            return null;
        }
        try {
            GLib.InputStream stream = session.send (message, cancellable);
            var data_input_stream = new GLib.DataInputStream (stream);

            if (Utils.check_response_status_is_ok (message) && Utils.check_content_type_is_image (message, data_input_stream)) {
                return data_input_stream;
            } else {
                return null;
            }
        } catch (GLib.Error err) {
            warning ("Couldn't Load Icon form address %s: %s.\n", uri, err.message);
            return null;
        }
    }

    async bool read_image_stream_async (Gdk.PixbufLoader loader, GLib.DataInputStream stream, GLib.Cancellable ? cancellable = null) {
        GLib.Bytes bytes;
        long bytes_len = 0;

        try {

            do {
                bytes = yield stream.read_bytes_async (8192, GLib.Priority.DEFAULT_IDLE, cancellable);

                bytes_len = bytes.length;
                loader.write_bytes (bytes);
            } while ( bytes_len > 0 && !cancellable.is_cancelled ());

            loader.close ();
            stream.close ();

            return true;

        } catch (GLib.Error err) {

            try {
                loader.close ();
                stream.close ();
            } catch (GLib.Error error) {
                warning (@"Couldn't close PixbufLoader: $(error.message).\n");
            }

            warning (@"Couldn't parse image: $(err.message).\n");
            return false;
        }
    }

    bool read_image_stream (Gdk.PixbufLoader loader, GLib.DataInputStream stream, GLib.Cancellable ? cancellable = null) {
        GLib.Bytes bytes;
        long bytes_len = 0;

        try {
            do {
                bytes = stream.read_bytes (8192, cancellable);

                bytes_len = bytes.length;
                loader.write_bytes (bytes);
            } while ( bytes_len > 0 && !cancellable.is_cancelled ());

            loader.close ();
            stream.close ();

            return true;

        } catch (GLib.Error err) {

            try {
                loader.close ();
                stream.close ();
            } catch (GLib.Error error) {
                warning (@"Couldn't close PixbufLoader: $(error.message).\n");
            }

            warning (@"Couldn't parse image: $(err.message).\n");
            return false;
        }
    }
}
