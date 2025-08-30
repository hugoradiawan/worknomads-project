from django.utils.deprecation import MiddlewareMixin
from django.views.decorators.csrf import csrf_exempt


class CSRFExemptAPIMiddleware(MiddlewareMixin):
    """
    Middleware to exempt API endpoints from CSRF protection.
    """

    def process_view(self, request, view_func, view_args, view_kwargs):
        if request.path.startswith("/api/"):
            return csrf_exempt(view_func)(request, *view_args, **view_kwargs)
        return None
