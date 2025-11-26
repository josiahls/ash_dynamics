from subprocess import run
from testing.suite import TestSuiteReport, TestReport, TestResult
from builtin._location import __call_location
from pathlib import Path
from time import perf_counter_ns


comptime TEST_DIR = Path("tests")


def test_file(file: Path) -> TestReport:
    var result = String()
    # Lol this is rough
    var name_as_bytes = file.name().as_bytes().copy()
    var ptr = UnsafePointer(to=name_as_bytes)

    var test_result = TestReport(
        name=StringSlice[mut=False, origin = origin_of(name_as_bytes)](
            unsafe_from_utf8_ptr=ptr
        ),  # Lol this is rough
        duration_ns=0,
        result=TestResult.PASS,
    )
    return test_result^


def walk_tests(path: Path, mut test_results: List[TestReport]):
    for f in path.listdir():
        file = path / f
        if file.is_file() and file.suffix() == ".mojo":
            var result = test_file(file)
            test_results.append(result^)
        elif file.is_dir():
            walk_tests(file, test_results)


def main():
    var test_results = List[TestReport]()
    walk_tests(TEST_DIR, test_results)
    var report = TestSuiteReport(
        reports=test_results^, location=__call_location[inline_count=0]()
    )
    print(report)
