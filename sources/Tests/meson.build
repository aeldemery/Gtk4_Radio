test_sources = files (
    'Test.vala',
)

test_exe = executable (
    'testlib',
    sources: test_sources,
    dependencies: [external_dependencies, radio_browser_dep],
)

test (
    'testlib',
    test_exe,
)