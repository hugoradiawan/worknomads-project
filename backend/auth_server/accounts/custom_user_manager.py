from django.contrib.auth.models import BaseUserManager
from typing import Any, Optional


class CustomUserManager(BaseUserManager):
    """
    Custom user manager where email is the unique identifier
    for authentication instead of usernames.
    """

    def create_user(
        self,
        email: str,
        username: str,
        password: Optional[str] = None,
        **extra_fields: Any
    ) -> "CustomUser":
        """
        Create and save a User with the given email and password.
        """
        if not email:
            raise ValueError("The Email must be set")
        email = self.normalize_email(email)
        user = self.model(email=email, username=username, **extra_fields)  # type: ignore[misc]
        if password:
            user.set_password(password)
        user.save(using=self._db)
        return user

    def email_exists(self, email: str) -> bool:
        """Check if a user with this email already exists."""
        return self.filter(email=email).exists()

    def username_exists(self, username: str) -> bool:
        """Check if a user with this username already exists."""
        return self.filter(username=username).exists()

    def get_user_by_email(self, email: str) -> Optional["CustomUser"]:
        """Get user by email address."""
        try:
            return self.get(email=email)
        except self.model.DoesNotExist:
            return None

    def get_user_by_username(self, username: str) -> Optional["CustomUser"]:
        """Get user by username."""
        try:
            return self.get(username=username)
        except self.model.DoesNotExist:
            return None

    def create_user_with_username_fallback(
        self,
        email: str,
        password: str,
        username: Optional[str] = None,
        **extra_fields: Any
    ) -> "CustomUser":
        """
        Create a new user with email and password.
        If username is not provided, it will be derived from email.
        """
        if not username:
            username = email.split("@")[0]

        return self.create_user(
            email=email, password=password, username=username, **extra_fields
        )


from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .models.user import CustomUser
