// Copyright (c) 2021 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

int main (string[] args) {
    try {
        var endpoint = new Gtk4Radio.EndpoinDiscovery (Gtk4Radio.USER_AGENT);
        var urls = endpoint.get_api_urls ("api", "tcp", "radio-browser.info");

        foreach (var url in urls) {
            print (url + "\n");
        }

        // var session = new Soup.Session ();
        // var message = new Soup.Message ("GET", ip_addresses[0]);
        // var input_stream = session.send (message);
        // var data_input_stream = new GLib.DataInputStream (input_stream);
        // var str = data_input_stream.read_line_utf8 ();
        // print ("s%\n", str);
    } catch (Error err) {
        print (err.message);
    }

    // return 0;

    // var loop = new MainLoop ();
    // var session = new Soup.Session ();
    // GLib.Bytes bytes = new GLib.Bytes (null);
    // get_uri_contents.begin (session, str_records[0], (obj, res) => {
    // bytes = get_uri_contents.end (res);
    // loop.quit ();
    // });
    // loop.run ();
    // if (bytes != null) {
    // print ((string) bytes.get_data ());
    // }
    return 0;
}

// var app = new Gtk4Radio.RadioApplication ();
// return app.run (args);
async GLib.Bytes ? get_uri_contents (Soup.Session session, string address) {
    var content_type = "";
    try {
        var api_address = "https://" + address + "/json/stations";
        var bytes = yield session.load_uri_bytes_async (api_address, Priority.DEFAULT, null, out content_type);

        return bytes;
    } catch (Error err) {
        warning ("Error: %s\n", err.message);
        return null;
    }
}