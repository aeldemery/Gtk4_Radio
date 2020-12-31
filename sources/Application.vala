public class Gtk4Radio.RadioApplication : Gtk.Application {
    public RadioApplication () {
    }

    protected override void activate () {
        var win = this.active_window;
        if (win == null) {
            win = new Gtk4Radio.MainWindow (this);
        }
        win.present ();
    }
}