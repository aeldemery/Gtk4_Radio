sources = files (
    'Main.vala',
    'MainWindow.vala',
    'Application.vala',
)

dependencies = [
    dependency ('glib-2.0'),
    dependency ('gobject-2.0'),
    dependency ('gtk4'),
    dependency ('libsoup-2.4'),
    dependency ('json-glib-1.0'),
]

executable (
    meson.project_name (),
    resources,
    sources: sources,
    dependencies: dependencies,
    install: true,
)