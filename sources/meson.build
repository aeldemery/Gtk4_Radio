subdir ('Library')
subdir ('Tests')

sources = files (
    'Main.vala',
    'Application.vala',

    'Views/MainWindow.vala',
    'Views/StationColumnView.vala',
    'Views/StationsListModel.vala',
)

executable (
    meson.project_name (),
    resources,
    sources: [sources],
    dependencies: [external_dependencies, radio_browser_dep],
    install: true,
)
