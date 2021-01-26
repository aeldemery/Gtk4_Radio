// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

public class Gtk4Radio.FaviconDownloader : GLib.Object {
    Soup.Session session;

    public FaviconDownloader () {
        session = new Soup.Session ();
        session.user_agent = USER_AGENT;
        session.max_conns = 256;
        session.timeout = 15;
    }

    public async Gdk.Texture ? get_favicon_texture (string url) {
        Gdk.Texture texture = null;
        Gdk.Pixbuf pixbuf = yield yield fetch_pixbuf (url);

        if (pixbuf != null) {
            Gdk.MemoryFormat memory_format = pixbuf.has_alpha ?
                                             Gdk.MemoryFormat.R8G8B8A8_PREMULTIPLIED :
                                             Gdk.MemoryFormat.R8G8B8;
            texture = new Gdk.MemoryTexture (196, 196, memory_format, pixbuf.pixel_bytes, pixbuf.rowstride);
        }

        return texture;
    }

    public async Gdk.Pixbuf ? get_favicon_pixbuf (string url) {
        return yield fetch_pixbuf (url);
    }

    async Gdk.Pixbuf ? fetch_pixbuf (string url) {
        if (check_url_is_valid (url) != true) {
            return null;
        }

        Gdk.Pixbuf pixbuf = null;
        var message = new Soup.Message ("GET", url);

        if (message != null) {
            try {
                GLib.InputStream stream = yield session.send_async (message, GLib.Priority.DEFAULT);

                if (check_response_status (message) && check_content_type_is_image (message, stream)) {
                    pixbuf = yield new Gdk.Pixbuf.from_stream_async (stream);
                }
            } catch (GLib.Error err) {
                info ("Couldn't Load Icon: %s, form address %s.\n", err.message, url);
            }
        }

        return pixbuf;
    }

    bool check_response_status (Soup.Message msg) throws Gtk4Radio.Error {
        if (msg.status_code == Soup.Status.OK) {
            debug ("check_response_status result: %s, %s\n", msg.status_code.to_string (), msg.reason_phrase);
            return true;
        } else {
            debug ("check_response_status result: %s, %s\n", msg.status_code.to_string (), msg.reason_phrase);
            throw new Error.NetworkError ("FaviconDownloader:check_response_status: %s\n", msg.reason_phrase);
        }
    }

    bool check_content_type_is_image (Soup.Message msg, GLib.InputStream stream) {
        Soup.MessageHeaders headers = msg.get_response_headers ();
        string content_type = headers.get_content_type (null);

        if (content_type != null && content_type.has_prefix ("image")) {
            return true;
        } else {
            try {
                bool uncertain = true;
                string type = GLib.ContentType.guess (null, stream.read_bytes (4096, null).get_data (), out uncertain);

                if (uncertain == false && type.contains ("image")) {
                    return true;
                }
            } catch (GLib.Error err) {
                info ("%s\n", err.message);
            }
        }
        return false;
    }

    bool check_url_is_valid (string url) {
        try {
            return GLib.Uri.is_valid (url, GLib.UriFlags.NONE);
        } catch (GLib.Error err) {
            info ("Failed to parse url string: %s\n", err.message);
            return false;
        }
    }
}
