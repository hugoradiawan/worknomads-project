from enum import Enum


class ServerID(Enum):
    """Enum for server identification"""

    BACKEND_SERVER = "backend-server"

    # Default/Unknown
    UNKNOWN = "unknown-server"

    def __str__(self):
        return self.value
