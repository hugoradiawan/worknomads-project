from django.http import HttpResponse
from django.shortcuts import get_object_or_404
import mimetypes
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser

from backend_server.shared.server_enum import (  # pyright: ignore[reportMissingImports]
    ServerID,
)
from .models import Media
from backend_server.shared.responses import (  # pyright: ignore[reportMissingImports]
    BaseResponse,
)
from .serializers import MediaSerializer
from .permissions import IsAuthenticated
from rest_framework.pagination import PageNumberPagination


class MediaUploadView(APIView):
    parser_classes = (MultiPartParser, FormParser)
    permission_classes = [IsAuthenticated]

    def post(self, request, *_, **__):
        file_serializer = MediaSerializer(data=request.data)
        if file_serializer.is_valid():
            file_serializer.save(user_id=request.user_id)
            return BaseResponse.success(
                data=file_serializer.data,
                message="File uploaded successfully.",
                status_code=status.HTTP_201_CREATED,
                server_id=ServerID.BACKEND_SERVER,
            )
        else:
            return BaseResponse.validation_error(
                errors=file_serializer.errors,
                code_id=5001,
                server_id=ServerID.BACKEND_SERVER,
            )


class MediaListView(APIView):
    permission_classes = [IsAuthenticated]
    pagination_class = PageNumberPagination

    def get(self, request, *_, **__):
        media = Media.objects.filter(user_id=request.user_id)
        paginator = self.pagination_class()
        page = paginator.paginate_queryset(media, request, view=self)
        if page is not None:
            serializer = MediaSerializer(page, many=True)
            return paginator.get_paginated_response(serializer.data)

        serializer = MediaSerializer(media, many=True)
        return BaseResponse.success(
            data=serializer.data,
            message="Media list retrieved successfully.",
            server_id=ServerID.BACKEND_SERVER,
        )


class MediaFileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, media_id, *_, **__):
        media = get_object_or_404(Media, id=media_id)
        if media.user_id != request.user_id:
            return BaseResponse.forbidden(
                code_id=6002,
                message="You do not have permission to access this file.",
                server_id=ServerID.BACKEND_SERVER,
            )

        try:
            with media.file.open("rb") as f:
                content_type, encoding = mimetypes.guess_type(media.file.name)
                if content_type is None:
                    content_type = "application/octet-stream"

                response = HttpResponse(f.read(), content_type=content_type)
                response["Content-Disposition"] = (
                    f'inline; filename="{media.file.name}"'
                )
                return response
        except IOError:
            return BaseResponse.not_found(
                code_id=6003,
                message="File not found.",
                server_id=ServerID.BACKEND_SERVER,
            )
