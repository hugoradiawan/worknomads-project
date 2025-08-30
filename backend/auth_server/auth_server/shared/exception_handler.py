from rest_framework.views import exception_handler
from rest_framework.response import Response
from rest_framework import status
import logging

logger = logging.getLogger(__name__)


def custom_exception_handler(exc, context):
    """
    Custom exception handler for Django REST Framework.
    """

    response = exception_handler(exc, context)

    logger.error(f"API Exception: {type(exc).__name__}: {str(exc)}")

    if response is not None:
        return response
    try:
        from auth_server.shared.responses import BaseResponse
        from auth_server.shared.server_enum import ServerID

        return BaseResponse.error(
            code_id=5000,
            message=f"Internal server error: {str(exc)}",
            error_code="INTERNAL_SERVER_ERROR",
            server_id=ServerID.AUTH_SERVER,
            status_code=500,
        )
    except Exception as e:
        logger.error(f"BaseResponse failed in exception handler: {str(e)}")
        return Response(
            {
                "error": True,
                "message": f"Internal server error: {str(exc)}",
                "error_code": "INTERNAL_SERVER_ERROR",
            },
            status=status.HTTP_500_INTERNAL_SERVER_ERROR,
        )
