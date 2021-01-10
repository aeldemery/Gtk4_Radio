project (
    'github.aeldemery.gtk4_radio',
    'c', 'vala',
    version: '0.1.0',
)

APP_ID = meson.project_name ()
APP_VERSION = meson.project_version ()
API_URL = 'all.api.radio-browser.info'
USER_AGENT = APP_ID + '/' + APP_VERSION

vapi_dir = ['/opt/share/vala/vapi']

add_project_arguments(
    ['--vapidir', vapi_dir],
    language: 'vala',
)

conf_data = configuration_data ()
conf_data.set ('APP_ID', APP_ID)
conf_data.set ('APP_VERSION', APP_VERSION)
conf_data.set ('API_URL', API_URL)
conf_data.set ('USER_AGENT', USER_AGENT)

config_constants = configure_file (
    input: 'Constants.vala.in',
    output: 'Constants.vala',
    configuration: conf_data
)

external_dependencies = [
    dependency ('glib-2.0', version: '>=2.66'),
    dependency ('gobject-2.0'),
    dependency ('gtk4', version: '>=4.0'),
    dependency ('libsoup-3.0'),
    dependency ('json-glib-1.0'),
    dependency ('gee-0.8'),
    dependency ('gio-2.0'),
]

subdir ('resources')
subdir ('sources')
