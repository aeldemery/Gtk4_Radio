project (
    'github.aeldemery.gtk4_radio',
    'c', 'vala',
    version: '0.1.0',
)

cc = meson.get_compiler ('c')
valac = meson.get_compiler ('vala')

application_id = meson.project_name ()
prefix = get_option ('prefix')
datadir = prefix / get_option ('datadir')
pkg_datadir = datadir / meson.project_name ()
gettext_package = application_id

api_domain = 'radio-browser.info'
api_service = 'api'
schema_path = '/github/aeldemery/gtk4_radio/'

conf_data = configuration_data ()
conf_data.set ('PROJECT_NAME', meson.project_name())
conf_data.set ('PREFIX', prefix)
conf_data.set ('DATADIR', datadir)
conf_data.set ('PKGDATADIR', pkg_datadir)
conf_data.set ('GETTEXT_PACKAGE', gettext_package)
conf_data.set ('LOCALE_DIR', prefix / get_option ('localedir'))
conf_data.set ('VERSION', meson.project_version())
conf_data.set ('APP_ID', application_id)
conf_data.set ('USER_AGENT', application_id + '/' + meson.project_version ())
conf_data.set ('API_DOMAIN', api_domain)
conf_data.set ('API_SERVICE', api_service)
conf_data.set ('SCHEMA_PATH', schema_path)

config_constants = configure_file(
    input: 'Constants.vala.in',
    output: 'Constants.vala',
    configuration: conf_data
)
config_include = include_directories ('.')


vapi_dir = ['/opt/share/vala/vapi']
add_project_arguments(
    [
        '--vapidir', vapi_dir, 
        '--debug', 
        '--save-temps',
        #'--enable-experimental-non-null',
    ],
    language: 'vala',
)

glib_dep = dependency ('glib-2.0', version: '>=2.66')
gobject_dep = dependency ('gobject-2.0')
gtk4_dep = dependency ('gtk4', version: '>=4.0')
libsoup_dep = dependency ('libsoup-3.0')
json_dep = dependency ('json-glib-1.0')
gee_dep = dependency ('gee-0.8')
gio_dep = dependency ('gio-2.0')
pixbuf_dep = dependency ('gdk-pixbuf-2.0')
math_dep = cc.find_library ('m', required: false)

subdir ('resources')
subdir ('sources')
