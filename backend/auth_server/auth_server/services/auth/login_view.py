from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from rest_framework import status
from django.contrib.auth import get_user_model
from ...shared.responses import BaseResponse
from ...shared.server_enum import ServerID
from rest_framework.permissions import AllowAny

User = get_user_model()


class LoginView(TokenObtainPairView):
    permission_classes = [AllowAny]
    def post(self, request, *args, **kwargs):
        email = request.data.get("email")
        password = request.data.get("password")

        if not email or not password:
            return BaseResponse.error(
                code_id=3003,
                message="Email and password are required",
                error_code="MISSING_CREDENTIALS",
                server_id=ServerID.AUTH_SERVER,
                status_code=status.HTTP_400_BAD_REQUEST,
            )
        user = User.objects.get_user_by_email(email)  # type: ignore[attr-defined]

        if not user:
            return BaseResponse.error(
                code_id=3004,
                message="Account not found",
                error_code="ACCOUNT_NOT_FOUND",
                server_id=ServerID.AUTH_SERVER,
                status_code=status.HTTP_404_NOT_FOUND,
            )

        # Check if account is active
        if not user.is_active:
            return BaseResponse.error(
                code_id=3005,
                message="Account is inactive",
                error_code="ACCOUNT_INACTIVE",
                server_id=ServerID.AUTH_SERVER,
                status_code=status.HTTP_403_FORBIDDEN,
            )

        try:
            response = super().post(request, *args, **kwargs)
            if response.status_code == status.HTTP_200_OK:
                user_data = {
                    "user_id": user.id,
                    "email": user.email,
                    "username": user.username,
                }

                # Only include fields if they have non-empty values
                if user.first_name.strip():
                    user_data["first_name"] = user.first_name
                if user.last_name.strip():
                    user_data["last_name"] = user.last_name

                # Only include full_name if it's not just whitespace
                full_name = user.get_full_name().strip()
                if full_name:
                    user_data["full_name"] = full_name

                return BaseResponse.success(
                    data={
                        'user': user_data,
                        'token': response.data,
                    },
                    message="Token obtained successfully",
                    server_id=ServerID.AUTH_SERVER,
                )
            else:
                # This would be wrong password case
                return BaseResponse.error(
                    code_id=3001,
                    message="Invalid password",
                    error_code="INVALID_PASSWORD",
                    server_id=ServerID.AUTH_SERVER,
                    status_code=status.HTTP_401_UNAUTHORIZED,
                )
        except (InvalidToken, TokenError) as e:
            return BaseResponse.error(
                code_id=3002,
                message="Authentication failed",
                error_code="AUTHENTICATION_FAILED",
                server_id=ServerID.AUTH_SERVER,
                status_code=status.HTTP_401_UNAUTHORIZED,
            )
