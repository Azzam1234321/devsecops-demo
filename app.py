from http.server import SimpleHTTPRequestHandler, HTTPServer

class MyHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(b"<h1>Hello from Secure DevSecOps Pipeline!</h1>")

server = HTTPServer(('0.0.0.0', 8080), MyHandler)
print("Server running on port 8080...")
server.serve_forever()

