import lightbug_http


from lightbug_http import (
    Server,
    HTTPService,
    HTTPRequest,
    HTTPResponse,
    OK,
    NotFound,
)
from lightbug_http.io.bytes import Bytes, bytes
from ash_dynamics.visualization_backend import VisualizationBackendable


@fieldwise_init
struct Welcome(HTTPService, Movable):
    fn func(mut self, req: HTTPRequest) raises -> HTTPResponse:
        if req.uri.path == "/":
            with open("static/lightbug_welcome.html", "r") as f:
                return OK(Bytes(f.read_bytes()), "text/html; charset=utf-8")

        if req.uri.path == "/logo.png":
            with open("static/logo.png", "r") as f:
                return OK(Bytes(f.read_bytes()), "image/png")

        return NotFound(req.uri.path)


@fieldwise_init
struct LightbugHTTPBackend(VisualizationBackendable):
    var name: String
    var port: UInt8
    var server: Server
    var handler: Welcome

    fn __init__(out self, name: String, port: UInt8) raises:
        self.name = name
        self.port = port
        self.server = Server()
        self.handler = Welcome()

    fn setup(mut self) raises:
        print("setup")

    fn run(mut self) raises:
        self.server.listen_and_serve(
            "localhost:" + String(self.port), self.handler
        )

    fn teardown(mut self) raises:
        print("teardown")
