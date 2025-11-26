from subprocess import run
from testing.suite import TestSuiteReport, TestReport, TestResult
from builtin._location import __call_location
from pathlib import Path
from time import perf_counter_ns


comptime TEST_DIR = Path("tests")


def test_file(file: Path) -> TestReport:
    var start = perf_counter_ns()
    var result = run("pixi run test " + String(file))
    var end = perf_counter_ns()
    var duration_ns = end - start
    if "Unhandled exception caught during execution" in result:
        return TestReport.failed(
            name=file.name(), duration_ns=duration_ns, error=Error(result)
        )

    return TestReport.passed(name=file.name(), duration_ns=duration_ns)


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
