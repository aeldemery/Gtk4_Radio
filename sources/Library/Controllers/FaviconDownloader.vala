// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

public class Gtk4Radio.FaviconDownloader : GLib.Object {
    Soup.Session session;

    public FaviconDownloader () {
        session = new Soup.Session ();
        // session.user_agent = USER_AGENT;
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
    public async Gdk.Texture ? get_favicon_texture_async (string url) {
        if (Utils.check_url_is_valid (url) != true) {
            return null;
        }

        Gdk.Texture texture = null;
        Gdk.Pixbuf pixbuf = yield fetch_pixbuf_async (url);

        if (pixbuf != null) {
            Gdk.MemoryFormat memory_format = pixbuf.has_alpha ?
                                             Gdk.MemoryFormat.R8G8B8A8_PREMULTIPLIED :
                                             Gdk.MemoryFormat.R8G8B8;
            texture = new Gdk.MemoryTexture (196, 196, memory_format, pixbuf.pixel_bytes, pixbuf.rowstride);
        }

        return texture;
    }

    /**
     * Async Version: Download a favicon url into {@Gdk.Texture}
     * Currently it doesn't decode image correctly.
     *
     * @param url address to download from.
     * @return Gdk.Texture texture data with constant size.
     */
    public Gdk.Texture ? get_favicon_texture (string url) {
        if (Utils.check_url_is_valid (url) != true) {
            return null;
        }

        Gdk.Texture texture = null;
        Gdk.Pixbuf pixbuf = fetch_pixbuf (url);

        if (pixbuf != null) {
            Gdk.MemoryFormat memory_format = pixbuf.has_alpha ?
                                             Gdk.MemoryFormat.R8G8B8A8_PREMULTIPLIED :
                                             Gdk.MemoryFormat.R8G8B8;
            texture = new Gdk.MemoryTexture (196, 196, memory_format, pixbuf.pixel_bytes, pixbuf.rowstride);
        }

        return texture;
    }

    /**
     * Async Version: Download a favicon url into {@Gdk.Pixbuf}
     *
     * @param url address to download from.
     * @return Gdk.Pixbuf contains pixbuf data.
     */
    public async Gdk.Pixbuf ? get_favicon_pixbuf_async (string url) {
        return yield fetch_pixbuf_async (url);
    }

    /**
     * Download a favicon url into {@Gdk.Pixbuf}
     *
     * @param url address to download from.
     * @return Gdk.Pixbuf contains pixbuf data.
     */
    public Gdk.Pixbuf ? get_favicon_pixbuf (string url) {
        return fetch_pixbuf (url);
    }

    /**
     * Download a favicon url into {@Gdk.Pixbuf}.
     * If it couldn't be downloaded, return placeholder image instead.
     *
     * @param url address to download from.
     * @return Gdk.Pixbuf contains pixbuf data or placeholder image.
     */
    public Gdk.Pixbuf get_favicon_pixbuf_else_placeholder (string url) {
        var pixbuf = fetch_pixbuf (url);
        if (pixbuf == null) {
            return Utils.load_pic_not_found ();
        } else {
            return pixbuf;
        }
    }

    /*
     * Private methods
     */
    async Gdk.Pixbuf ? fetch_pixbuf_async (string url) {
        if (Utils.check_url_is_valid (url) != true) {
            return null;
        }

        Gdk.Pixbuf pixbuf = null;

        var message = new Soup.Message ("GET", url);
        if (message != null) {
            try {
                GLib.InputStream stream = yield session.send_async (message, GLib.Priority.DEFAULT);

                if (Utils.check_response_status_is_ok (message) && Utils.check_content_type_is_image (message, stream)) {
                    return pixbuf = yield new Gdk.Pixbuf.from_stream_async (stream);
                } else {
                    return null;
                }
            } catch (GLib.Error err) {
                info ("Couldn't Load Icon: %s, form address %s.\n", err.message, url);
            }
        }
        return pixbuf;
    }

    // Private functions
    Gdk.Pixbuf ? fetch_pixbuf (string url) {
        if (Utils.check_url_is_valid (url) != true) {
            return null;
        }

        Gdk.Pixbuf pixbuf = null;

        var message = new Soup.Message ("GET", url);
        if (message != null) {
            try {
                GLib.InputStream stream = session.send (message);

                if (Utils.check_response_status_is_ok (message) && Utils.check_content_type_is_image (message, stream)) {
                    return pixbuf = new Gdk.Pixbuf.from_stream (stream);
                } else {
                    return null;
                }
            } catch (GLib.Error err) {
                info ("Couldn't Load Icon: %s, form address %s.\n", err.message, url);
            }
        }
        return pixbuf;
    }
}
