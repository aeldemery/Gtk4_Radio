subdir ('library')

sources = files (
    'Main.vala',
    'Application.vala',
    'Constants.vala',

    'Views/MainWindow.vala',
)

dependencies = [
    dependency ('glib-2.0', version: '>=2.66'),
    dependency ('gobject-2.0'),
    dependency ('gtk4', version: '>=4.0'),
    dependency ('libsoup-3.0'),
    dependency ('json-glib-1.0'),
    dependency ('gee-0.8'),
    dependency ('gio-2.0'),
]

executable (
    meson.project_name (),
    resources,
    sources: [sources, lib_sources],
    dependencies: dependencies,
    install: true,
)
