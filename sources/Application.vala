public class Gtk4Demo.RadioApplication : Gtk.Application {
    public RadioApplication () {
    }

    protected override void activate () {
        var win = this.active_window;
        if (win == null) {
            win = new Gtk4Demo.MainWindow (this);
        }
        win.present ();
    }
}