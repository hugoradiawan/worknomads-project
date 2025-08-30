from enum import Enum


class ServerID(Enum):
    """Enum for server identification"""

    AUTH_SERVER = "auth-server"

    # Default/Unknown
    UNKNOWN = "unknown-server"

    def __str__(self):
        return self.value
