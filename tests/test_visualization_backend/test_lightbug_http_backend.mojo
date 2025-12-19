# from testing import assert_equal, TestSuite


# from algorithm.functional import sync_parallelize
# from ash_dynamics.visualization_backend.lightbug_http_backend import (
#     LightbugHTTPBackend,
# )


# def test_lightbug_http_backend():
#     backend1 = LightbugHTTPBackend(name="test 1", port=8080)
#     backend2 = LightbugHTTPBackend(name="test 2", port=8081)

#     @parameter
#     fn parallel_fn(thread_id: Int):
#         try:
#             if thread_id == 0:
#                 backend1.run()
#             else:
#                 backend2.run()
#         except e:
#             print(e)

#     sync_parallelize[parallel_fn](2)


def main():
    pass
    # TestSuite.discover_tests[__functions_in_module()]().run()
