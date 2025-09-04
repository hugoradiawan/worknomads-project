# WorkNomads Backend

A Django-based microservices backend architecture with authentication, gateway, and core business logic services.

## Project Overview

Backend implements a **microservices architecture** with three main services:

- **Auth Server** - User authentication and authorization service
- **Backend Server** - Core business logic and data management
- **Gateway** - API gateway for request routing and load balancing

### Key Features

- **Microservices Architecture** - Distributed services with clear separation of concerns
- **JWT Authentication** - Secure token-based authentication system
- **API Gateway** - Centralized request routing and middleware
- **Database Management** - SQLite databases for development
- **Environment Configuration** - Flexible environment-based settings
- **Django Framework** - Robust web framework with ORM

## Architecture

```
┌─────────────────────┐
│      Gateway        │  ← API Gateway & Load Balancer
├─────────────────────┤
│   Auth Server       │  ← Authentication & User Management
├─────────────────────┤
│  Backend Server     │  ← Core Business Logic & Data
└─────────────────────┘
```

## 📂 Project Structure

```
backend/
├── auth_server/                         # Authentication microservice
│   ├── .env.dev                         # Development environment variables
│   ├── .env.dev.example                 # Environment template
│   ├── manage.py                        # Django management script
│   ├── accounts/                        # User account management
│   │   ├── models/                      # User models
│   │   ├── migrations/                  # Database migrations
│   │   └── custom_user_manager.py       # Custom user management
│   └── auth_server/                     # Django project settings
│       ├── config/                      # Configuration files
│       ├── middleware/                  # Custom middleware
│       ├── services/                    # Business logic services
│       └── shared/                      # Shared utilities
├── backend_server/                      # Core business logic service
│   ├── .env.dev                         # Development environment variables
│   ├── manage.py                        # Django management script
│   ├── backend_server/                  # Django project settings
│   ├── shared/                          # Shared utilities
│   ├── media/                           # Media file storage
│   └── uploaded/                        # File upload storage
└── gateway/                             # API Gateway service
    ├── manage.py                        # Django management script
    └── gateway/                         # Gateway configuration
```

## Getting Started

### Prerequisites

- **Python**: 3.8+ (recommended 3.11+)
- **pip**: Latest version
- **virtualenv**: For environment isolation
- **SQLite**: Built-in with Python

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/hugoradiawan/worknomads-project.git
   cd worknomads-project/backend
   ```

2. **Set up Auth Server**

   ```bash
   cd auth_server

   # Create virtual environment
   python -m venv env

   # Activate virtual environment
   env\Scripts\activate

   # Install dependencies
   pip install django django-environ djangorestframework djangorestframework-simplejwt environ

   # Set up environment variables
   cp .env.dev.example .env.dev
   # Edit .env.dev with your configuration

   # Run migrations
   python manage.py migrate
   ```

3. **Set up Backend Server**

   ```bash
   cd ../backend_server

   # Create virtual environment
   python -m venv env

   # Activate virtual environment
   env\Scripts\activate

   # Install dependencies
   pip install django django-environ djangorestframework djangorestframework-simplejwt environ

   # Set up environment variables
   cp .env.dev .env.dev.local
   # Edit environment variables as needed

   # Run migrations
   python manage.py migrate
   ```

4. **Set up Gateway**

   ```bash
   cd ../gateway

   # Create virtual environment
   python -m venv env

   # Activate virtual environment
   env\Scripts\activate

   # Install dependencies
   pip install django

   # Run migrations
   python manage.py migrate
   ```

### Running the Services

Each service runs on a different port to avoid conflicts:

1. **Start Auth Server** (Port 8001)

   ```bash
   cd auth_server
   env\Scripts\activate
   python manage.py runserver 8001
   ```

2. **Start Backend Server** (Port 8002)

   ```bash
   cd backend_server
   env\Scripts\activate
   python manage.py runserver 8002
   ```

3. **Start Gateway** (Port 8000)
   ```bash
   cd gateway
   env\Scripts\activate
   python manage.py runserver 8000
   ```

### Service URLs

- **Gateway**: http://localhost:8000
- **Auth Server**: http://localhost:8001
- **Backend Server**: http://localhost:8002

## Technology Stack

### Core Technologies

- **Django**: Web framework
- **Django REST Framework**: API development
- **SQLite**: Development database
- **Python**: Programming language

### Authentication

- **Django REST Framework SimpleJWT**: JWT token authentication

### Development Tools

- **Django Management Commands**: Database migrations
- **Environment Variables**: Configuration management
- **Virtual Environments**: Dependency isolation

## Environment Configuration

Each service uses environment variables for configuration:

### Auth Server (.env.dev)

```env
DEBUG=True
SECRET_KEY=your-secret-key
DATABASE_URL=sqlite:///db.sqlite3
JWT_SECRET_KEY=your-jwt-secret
```

### Backend Server (.env.dev)

```env
DEBUG=True
SECRET_KEY=your-secret-key
DATABASE_URL=sqlite:///db.sqlite3
MEDIA_ROOT=media/
UPLOAD_ROOT=uploaded/
```

### Database Management

```bash
# Create migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

```

### Development Server

```bash
# Run development server
python manage.py runserver

# Run on specific port
python manage.py runserver 8001
```

## API Authentication

The system uses JWT tokens for authentication:

1. **Login**: POST to `/auth/login/` with credentials
2. **Token Refresh**: POST to `/auth/refresh/` with refresh token
3. **Authenticated Requests**: Include `Authorization: Bearer <token>` header

## API Documentation

- **Auth Server**: http://localhost:8001/api/docs/
- **Backend Server**: http://localhost:8002/api/docs/
- **Gateway**: http://localhost:8000/api/docs/

## Troubleshooting

### Common Issues

1. **Port Already in Use**

   ```bash
   # Kill process on port
   netstat -ano | findstr :8000
   taskkill /PID <PID> /F
   ```

2. **Database Migration Issues**

   ```bash
   # Reset migrations
   python manage.py migrate --fake-initial

   # Or delete migration files and recreate
   rm -rf migrations/
   python manage.py makemigrations
   python manage.py migrate
   ```

3. **Virtual Environment Issues**
   ```bash
   # Recreate virtual environment
   rm -rf env/
   python -m venv env
   env\Scripts\activate
   pip install -r requirements.txt
   ```
