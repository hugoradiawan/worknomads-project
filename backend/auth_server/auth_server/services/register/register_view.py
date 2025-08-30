from rest_framework import generics, status
from rest_framework.permissions import AllowAny
from .register_request_serializer import RegisterSerializer
from .user_repository import UserRepository
from ...shared.responses import BaseResponse
from ...shared.server_enum import ServerID


class RegisterView(generics.CreateAPIView):
    permission_classes = [AllowAny]

    def post(self, request, *_, **__):
        serializer = RegisterSerializer(data=request.data)
        if not serializer.is_valid():
            return BaseResponse.validation_error(
                errors=serializer.errors, code_id=1002, server_id=ServerID.AUTH_SERVER
            )

        username = serializer.validated_data["username"]
        password = serializer.validated_data["password"]

        if UserRepository.username_exists(username):
            return BaseResponse.error(
                code_id=1001,
                message="Username already exists.",
                error_code="USERNAME_EXISTS",
                server_id=ServerID.AUTH_SERVER,
            )

        user = UserRepository.create_user(username, password)
        return BaseResponse.success(
            message="User registered successfully.",
            status_code=status.HTTP_201_CREATED,
            data={"user_id": user.id, "username": user.username},
            server_id=ServerID.AUTH_SERVER,
        )
