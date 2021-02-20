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
        if (msg.status_code < Soup.Status.OK || msg.status_code > Soup.Status.PARTIAL_CONTENT) {
            debug (@"Returned Status: $(msg.status_code), Reson: $(msg.reason_phrase).\n");
            throw new Error.NetworkError (@"Returned Status: $(msg.status_code), Reson: $(msg.reason_phrase).\n");
        } else {
            return true;
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
    public static bool check_content_type_is_image (Soup.Message msg, GLib.DataInputStream stream) {
        var sniffer = new Soup.ContentSniffer ();
        uint8 buffer[4096];
        size_t size = stream.peek (buffer);
        string content_type = sniffer.sniff (msg, new Bytes (buffer), null);
        if (content_type.has_prefix ("image")) {
            return true;
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
