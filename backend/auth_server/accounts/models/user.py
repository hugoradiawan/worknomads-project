from django.contrib.auth.models import AbstractUser
from django.db import models
from ..custom_user_manager import CustomUserManager


class CustomUser(AbstractUser):
    """
    Custom user model that extends Django's AbstractUser.
    You can add your own fields here while keeping all the default Django user functionality.
    """

    email = models.EmailField(unique=True, blank=False, null=False)

    first_name = models.CharField(max_length=30, blank=True)
    last_name = models.CharField(max_length=30, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["username"]

    # Use the custom manager
    objects = CustomUserManager()  # type: ignore[assignment]

    class Meta:
        db_table = "custom_user"
        verbose_name = "User"
        verbose_name_plural = "Users"

    def __str__(self):
        return self.email

    def get_full_name(self):
        """Return the first_name plus the last_name, with a space in between."""
        full_name = f"{self.first_name} {self.last_name}"
        return full_name.strip()

    def get_short_name(self):
        """Return the short name for the user."""
        return self.first_name
