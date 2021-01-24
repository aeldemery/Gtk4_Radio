lib_sources = files (
    'Models/Station.vala',
    'Models/StationQueryFilter.vala',
    'Models/ListFilter.vala',
    'Models/ErrorDomain.vala',
    'Models/ServerStats.vala',
    'Models/RadioBrowserLists.vala',

    'Controllers/NetworkController.vala',
    'Controllers/EndpointDiscovery.vala',
    'Controllers/FaviconDownloader.vala',
)

lib_dependencies = [
    glib_dep,
    gobject_dep,
    gtk4_dep,
    libsoup_dep,
    json_dep,
    gee_dep,
    gio_dep,
    pixbuf_dep,
]

lib_inc = include_directories ('.')

radio_browser_lib = library (
    'radiobrowserlib',
    config_constants,
    sources: lib_sources,
    dependencies: lib_dependencies,
    include_directories: [lib_inc, config_include,],
    install: true,
    install_dir: [true, true, true],
)

radio_browser_dep = declare_dependency (
    include_directories: lib_inc,
    link_with: radio_browser_lib,
)