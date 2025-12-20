from testing.suite import TestSuite
from testing.testing import assert_equal


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
