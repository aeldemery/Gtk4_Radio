test_sources = files (
    'Test.vala',
)


test_dependencies = [
    glib_dep,
    gobject_dep,
    gtk4_dep,
    libsoup_dep,
    json_dep,
    gee_dep,
    gio_dep,
]

test_exe = executable (
    'testlib',
    sources: test_sources,
    dependencies: [test_dependencies, radio_browser_dep],
)

test (
    'testlib',
    test_exe,
)