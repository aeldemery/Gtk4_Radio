lib_sources = files (
    'Models/Station.vala',
    'Models/StationQueryFilter.vala',
    'Models/ListFilter.vala',
    'Models/ErrorDomain.vala',
    'Models/ServerStats.vala',
    'Models/RadioBrowserLists.vala',

    'Controllers/NetworkController.vala',
    'Controllers/EndpointDiscovery.vala',
)

lib_dependencies = [
    dependency ('glib-2.0', version: '>=2.66'),
    dependency ('gobject-2.0'),
    dependency ('libsoup-3.0'),
    dependency ('json-glib-1.0'),
    dependency ('gee-0.8'),
    dependency ('gio-2.0'),
    dependency ('gtk4'),
]

lib_inc = include_directories ('.')

radio_browser_lib = library (
    'radiobrowserlib',
    config_constants,
    sources: lib_sources,
    dependencies: lib_dependencies,
    install: true,
    install_dir: [true, true, true],
)

radio_browser_dep = declare_dependency (
    include_directories: lib_inc,
    link_with: radio_browser_lib,
)