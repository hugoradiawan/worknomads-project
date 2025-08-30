from django.contrib import admin
from django.urls import path

from auth_server.services.register.register_view import RegisterView
from auth_server.services.auth.token_obtain_view import CustomTokenObtainPairView
from auth_server.services.auth.token_refresh_view import CustomTokenRefreshView

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/register", view=RegisterView.as_view(), name="register"),
    path("api/login", CustomTokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/refreshtoken", CustomTokenRefreshView.as_view(), name="token_refresh"),
]
