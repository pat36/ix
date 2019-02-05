public class IXviewer : GLib.Object {
    
    private Gtk.Window window;
    private Gtk.Image image;
    private string[] images;
    public int image_number;
    public int height;
    public int width;
    public int zoom;

    public IXviewer(int _height, int _width) {
        image_number = 0;
        height = _height;
        width = _width;
        zoom = 1;
        window = new Gtk.Window();
        window.set_title("ix - Image Viewer");
        window.set_default_size(height, width);  
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0); 
        image = new Gtk.Image();
        box.pack_start(image, true, true, 0);
        window.add(box);
        window.show_all();
        window.key_press_event.connect(on_key_press);
        window.destroy.connect(on_destroy);
    }
    
    public void change_image(int number) {
        try{
            zoom = 1;
            string path = images[number];
            int len = images.length;
            string str = @"$path [$(number+1)/$(len+1)]";
            window.set_title(str);
            this.image.set_from_pixbuf(new Gdk.Pixbuf.from_file_at_size(images[number], (int)height, (int)width));
        } catch(GLib.Error e) {
            return;
        }
    }
    public void change_image_size(int symbol) {
        try {
            if(symbol == 1) zoom += 1;
            if(symbol == 0) zoom -= 1;
            if(zoom <= 0) zoom = 1;
            this.image.set_from_pixbuf(
                new Gdk.Pixbuf.from_file_at_size(
                    images[image_number],
                    zoom * (int)height,
                    zoom * (int)width
                )
            );
        } catch(GLib.Error e) {
            return;
        }
    }
    public void on_destroy(Gtk.Widget window) {
        Gtk.main_quit();
    }
    public bool on_key_press(Gdk.EventKey e) {
        switch(e.keyval) {
            case Gdk.Key.Right:
                image_number++;
                if(image_number >= images.length) image_number = 0;
                this.change_image(image_number);
                break;
            case Gdk.Key.Left:
                image_number--;
                if(image_number < 0) image_number = images.length-1;
                this.change_image(image_number);
                break;
            case Gdk.Key.q:
                Gtk.main_quit();
                break;
            case Gdk.Key.plus:
                this.change_image_size(1);
                break;
            case Gdk.Key.minus:
                this.change_image_size(0);
                break;

        }
        return true;
    }
    static int main(string[] args) {
        Gtk.init(ref args);
        var app = new IXviewer(900, 450);
        app.images = args[1:args.length];
        app.change_image((int) app.image_number);
        Gtk.main();
        return 0;
    }
}
