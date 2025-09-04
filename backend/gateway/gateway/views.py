import os
from revproxy.views import ProxyView


class AuthProxyView(ProxyView):
    upstream = f'http://127.0.0.1:{os.getenv("AUTH_PORT", "8001")}'


class BackendProxyView(ProxyView):
    upstream = f'http://127.0.0.1:{os.getenv("BACKEND_PORT", "8000")}'
