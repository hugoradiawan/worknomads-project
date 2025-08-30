from rest_framework_simplejwt.views import TokenRefreshView
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from rest_framework import status
from ...shared.responses import BaseResponse
from ...shared.server_enum import ServerID


class CustomTokenRefreshView(TokenRefreshView):
    def post(self, request, *args, **kwargs):
        try:
            response = super().post(request, *args, **kwargs)
            if response.status_code == status.HTTP_200_OK:
                return BaseResponse.success(
                    data=response.data,
                    message="Token refreshed successfully",
                    server_id=ServerID.AUTH_SERVER,
                )
            else:
                return BaseResponse.error(
                    code_id=3003,
                    message="Token expired or invalid",
                    error_code="TOKEN_EXPIRED",
                    server_id=ServerID.AUTH_SERVER,
                    status_code=status.HTTP_401_UNAUTHORIZED,
                )
        except (InvalidToken, TokenError) as e:
            return BaseResponse.error(
                code_id=3004,
                message="Token expired or invalid",
                error_code="TOKEN_EXPIRED",
                server_id=ServerID.AUTH_SERVER,
                status_code=status.HTTP_401_UNAUTHORIZED,
            )
