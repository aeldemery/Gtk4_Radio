int main (string[] args) {
    var loop = new MainLoop ();
    var session = new Soup.Session ();
    GLib.Bytes bytes = new GLib.Bytes (null);
    get_uri_contents.begin (session, (obj, res) => {
        bytes = get_uri_contents.end (res);
        loop.quit ();
    });
    loop.run ();
    print ((string)bytes.get_data());
    return 0;
}

// var app = new Gtk4Radio.RadioApplication ();
// return app.run (args);
async GLib.Bytes? get_uri_contents (Soup.Session session) {
    var content_type = "";
    try {
        var bytes = yield session.load_uri_bytes_async (Gtk4Radio.API_URL, Priority.DEFAULT, null, out content_type);
        return bytes;
    } catch (Error err) {
        warning ("Error: %s\n", err.message);
        return null;
    }
}