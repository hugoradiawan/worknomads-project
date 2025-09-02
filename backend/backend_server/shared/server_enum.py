from enum import Enum


class ServerID(Enum):
    AUTH_SERVER = "auth-server"
    BACKEND_SERVER = "backend-server"
    UNKNOWN = "unknown-server"
