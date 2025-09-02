from rest_framework.permissions import BasePermission
import jwt
from django.conf import settings

class IsAuthenticated(BasePermission):
    def has_permission(self, request, view):  # type: ignore
        auth_header = request.headers.get('Authorization')
        if not auth_header:
            return False

        try:
            token = auth_header.split(' ')[1]
            decoded_token = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
            request.user_id = int(decoded_token['user_id'])
            return True
        except Exception as e:
            return False
