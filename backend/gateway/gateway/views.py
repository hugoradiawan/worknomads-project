from revproxy.views import ProxyView

class AuthProxyView(ProxyView):
    upstream = 'http://127.0.0.1:8001'

class BackendProxyView(ProxyView):
    upstream = 'http://127.0.0.1:8000'
