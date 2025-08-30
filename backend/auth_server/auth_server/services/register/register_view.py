from rest_framework import generics, status
from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from typing import TYPE_CHECKING, cast
from django.contrib.auth import get_user_model
from .register_request_serializer import RegisterSerializer
from ...shared.responses import BaseResponse
from ...shared.server_enum import ServerID

if TYPE_CHECKING:
    from accounts.models.user import CustomUser
    from accounts.custom_user_manager import CustomUserManager

User = get_user_model()


class RegisterView(generics.CreateAPIView):
    permission_classes = [AllowAny]

    def post(self, request: Request, *_, **__) -> Response:
        serializer = RegisterSerializer(data=request.data)
        if not serializer.is_valid():
            return BaseResponse.validation_error(
                errors=serializer.errors, code_id=1002, server_id=ServerID.AUTH_SERVER
            )

        email = serializer.validated_data["email"]
        username = serializer.validated_data["username"]
        password = serializer.validated_data["password"]

        try:
            # Cast manager to CustomUserManager for proper typing
            manager = cast("CustomUserManager", User.objects)

            if manager.email_exists(email):
                return BaseResponse.error(
                    code_id=1001,
                    message="Email already exists.",
                    error_code="EMAIL_EXISTS",
                    server_id=ServerID.AUTH_SERVER,
                )

            if manager.username_exists(username):
                return BaseResponse.error(
                    code_id=1002,
                    message="Username already exists.",
                    error_code="USERNAME_EXISTS",
                    server_id=ServerID.AUTH_SERVER,
                )

            manager.create_user_with_username_fallback(
                email=email, password=password, username=username
            )
            return BaseResponse.success(
                message="User registered successfully.",
                status_code=status.HTTP_201_CREATED,
                server_id=ServerID.AUTH_SERVER,
            )
        except Exception as e:
            return BaseResponse.error(
                code_id=1003,
                message=f"Database error: {str(e)}",
                error_code="DATABASE_ERROR",
                server_id=ServerID.AUTH_SERVER,
                status_code=500,
            )
