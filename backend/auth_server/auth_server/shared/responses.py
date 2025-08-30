from rest_framework.response import Response
from rest_framework import status
from typing import Any, Optional, Dict, Union
import uuid
import socket
from .server_enum import ServerID


class BaseResponse:
    @staticmethod
    def _get_trace_info(server_id: Optional[Union[str, ServerID]] = None):
        """Generate trace information for debugging"""
        if isinstance(server_id, ServerID):
            server_id_str = server_id.value
        else:
            server_id_str = server_id or socket.gethostname()

        return {"server_id": server_id_str, "trace_id": str(uuid.uuid4())}

    @staticmethod
    def success(
        data: Any = None,
        message: str = "Success",
        status_code: int = status.HTTP_200_OK,
        extra_data: Optional[Dict] = None,
        server_id: Optional[Union[str, ServerID]] = ServerID.UNKNOWN,
    ) -> Response:
        """
        Standard success response format
        """
        response_data = {
            "success": True,
            "message": message,
            **BaseResponse._get_trace_info(server_id),
        }

        if data is not None:
            response_data["data"] = data

        if extra_data:
            response_data.update(extra_data)

        return Response(response_data, status=status_code)

    @staticmethod
    def error(
        code_id: int,
        message: str = "An error occurred",
        status_code: int = status.HTTP_400_BAD_REQUEST,
        errors: Optional[Dict] = None,
        error_code: Optional[str] = None,
        server_id: Optional[Union[str, ServerID]] = ServerID.UNKNOWN,
    ) -> Response:
        """
        Standard error response format
        """
        response_data = {
            "success": False,
            "message": message,
            "code_id": code_id,
            **BaseResponse._get_trace_info(server_id),
        }

        if errors:
            response_data["errors"] = errors

        if error_code:
            response_data["error_code"] = error_code

        return Response(response_data, status=status_code)

    @staticmethod
    def validation_error(
        errors: Dict,
        code_id: int,
        message: str = "Validation failed",
        server_id: Optional[Union[str, ServerID]] = ServerID.UNKNOWN,
    ) -> Response:
        """
        Standard validation error response
        """
        return BaseResponse.error(
            code_id=code_id,
            message=message,
            status_code=status.HTTP_400_BAD_REQUEST,
            errors=errors,
            error_code="VALIDATION_ERROR",
            server_id=server_id,
        )

    @staticmethod
    def not_found(
        code_id: int = 2001,
        message: str = "Resource not found",
        server_id: Optional[Union[str, ServerID]] = ServerID.UNKNOWN,
    ) -> Response:
        """
        Standard not found response
        """
        return BaseResponse.error(
            code_id=code_id,
            message=message,
            status_code=status.HTTP_404_NOT_FOUND,
            error_code="NOT_FOUND",
            server_id=server_id,
        )

    @staticmethod
    def unauthorized(
        code_id: int = 3001,
        message: str = "Unauthorized access",
        server_id: Optional[Union[str, ServerID]] = ServerID.UNKNOWN,
    ) -> Response:
        """
        Standard unauthorized response
        """
        return BaseResponse.error(
            code_id=code_id,
            message=message,
            status_code=status.HTTP_401_UNAUTHORIZED,
            error_code="UNAUTHORIZED",
            server_id=server_id,
        )

    @staticmethod
    def forbidden(
        code_id: int = 4001,
        message: str = "Access forbidden",
        server_id: Optional[Union[str, ServerID]] = ServerID.UNKNOWN,
    ) -> Response:
        """
        Standard forbidden response
        """
        return BaseResponse.error(
            code_id=code_id,
            message=message,
            status_code=status.HTTP_403_FORBIDDEN,
            error_code="FORBIDDEN",
            server_id=server_id,
        )
