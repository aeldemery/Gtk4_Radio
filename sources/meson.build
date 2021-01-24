subdir ('Library')
subdir ('Tests')

exe_sources = files (
    'Main.vala',
    'Application.vala',

    'Views/MainWindow.vala',
    'Views/StationColumnView.vala',
    'Views/StationsListModel.vala',
    'Views/FaviconGridView.vala',
)

exe_dependencies = [
    glib_dep,
    gobject_dep,
    gtk4_dep,
    libsoup_dep,
    json_dep,
    gee_dep,
    gio_dep,
]

executable (
    meson.project_name (),
    resources,
    sources: [exe_sources],
    dependencies: [exe_dependencies, radio_browser_dep],
    install: true,
)
