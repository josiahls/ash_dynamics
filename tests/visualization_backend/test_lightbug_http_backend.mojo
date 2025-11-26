from testing import assert_equal, TestSuite


def test_lightbug_http_backend():
    assert_equal(2, 1)


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
