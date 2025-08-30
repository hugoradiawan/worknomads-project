from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password


class UserRepository:
    @staticmethod
    def create_user(username: str, password: str):
        return User.objects.create(username=username, password=make_password(password))

    @staticmethod
    def username_exists(username: str) -> bool:
        return User.objects.filter(username=username).exists()
