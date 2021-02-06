/**
 * Contains some utility function.
 */
public class Gtk4Radio.Utils : GLib.Object {

    /**
     * Try to validate a string to check if it's a valid uri
     *
     * @return true if it's a valid Uri otherwise false
     */
    public static bool check_url_is_valid (string url) {
        try {
            return GLib.Uri.is_valid (url, GLib.UriFlags.NONE);
        } catch (GLib.Error err) {
            info ("Failed to parse url string: %s\n", err.message);
            return false;
        }
    }

    /**
     * Return true if result of transaction is Soup.Status.OK, otherwise false
     *
     * @param msg the Soup.Message to check
     * @return true if Soup.Status.OK othewise false
     * @throw Gtk4Radio.Error.NetworkError
     */
    public static bool check_response_status_is_ok (Soup.Message msg) throws Gtk4Radio.Error {
        if (msg.status_code == Soup.Status.OK) {
            debug ("check_response_status_is_ok result: %s, %s\n", msg.status_code.to_string (), msg.reason_phrase);
            return true;
        } else {
            debug ("check_response_status result: %s, %s\n", msg.status_code.to_string (), msg.reason_phrase);
            throw new Error.NetworkError ("check_response_status_is_ok: %s\n", msg.reason_phrase);
        }
    }

    /**
     * Tries to get the `GLib.ContentType` of the returned transaction.
     * First it checks the `msg` response header to check if content type is image. If this is null,
     * it tries to guess the type form the `stream` using `GLib.ContentType.guess()`. Returns true if type
     * is image, otherwise false.
     *
     * @param msg the Soup.Message to check
     * @param stream the stream to check if the header method fails
     * @return true if image otherwise false
     */
    public static bool check_content_type_is_image (Soup.Message msg, GLib.InputStream stream) {
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

    /**
     * Loads a placeholder image form the resources
     */
    public static Gdk.Pixbuf ? load_pic_not_found () {
        try {
            return new Gdk.Pixbuf.from_resource (Constants.SCHEMA_PATH + "images/image-not-found-multicolor.svg");
        } catch (GLib.Error err) {
            warning ("Couldn't Load resource: %s\n", err.message);
            return null;
        }
    }
}
