import json
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin
from django.core.exceptions import SuspiciousOperation
from django.http import Http404
import logging

logger = logging.getLogger(__name__)


class APIErrorMiddleware(MiddlewareMixin):
    """
    Middleware to convert server errors to JSON responses for API endpoints.
    """

    def process_exception(self, request, exception):
        # Only handle API requests
        if request.path.startswith("/api/"):
            logger.error(f"API Exception: {type(exception).__name__}: {str(exception)}")

            # Import here to avoid circular imports
            try:
                from ..shared.responses import BaseResponse
                from ..shared.server_enum import ServerID

                exception_details = (
                    str(exception) if hasattr(exception, "__str__") else "Unknown error"
                )
                return BaseResponse.error(
                    code_id=5000,
                    message=f"Internal server error: {exception_details}",
                    error_code="INTERNAL_SERVER_ERROR",
                    server_id=ServerID.AUTH_SERVER,
                    status_code=500,
                )
            except Exception as e:
                # Fallback to simple JsonResponse if BaseResponse fails
                logger.error(f"BaseResponse failed, using fallback: {str(e)}")
                return JsonResponse(
                    {
                        "error": True,
                        "message": f"Internal server error: {str(exception)}",
                        "error_code": "INTERNAL_SERVER_ERROR",
                    },
                    status=500,
                )

        # Let Django handle non-API requests normally
        return None

    def process_response(self, request, response):
        # Handle cases where response content is not rendered for API requests
        if (
            request.path.startswith("/api/")
            and hasattr(response, "render")
            and not response.is_rendered
        ):
            try:
                response.render()
            except Exception as e:
                logger.error(f"Response rendering failed: {str(e)}")
                # Return a simple JSON error response
                return JsonResponse(
                    {
                        "error": True,
                        "message": "Response rendering failed",
                        "error_code": "CONTENT_NOT_RENDERED",
                    },
                    status=500,
                )

        return response
