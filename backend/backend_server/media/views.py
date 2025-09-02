from django.http import HttpResponse
from django.shortcuts import get_object_or_404
import mimetypes
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser
from .models import Media
from .serializers import MediaSerializer
from .permissions import IsAuthenticated
from rest_framework.pagination import PageNumberPagination


class MediaUploadView(APIView):
    parser_classes = (MultiPartParser, FormParser)
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        file_serializer = MediaSerializer(data=request.data)
        if file_serializer.is_valid():
            file_serializer.save(user_id=request.user_id)
            return Response(file_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MediaListView(APIView):
    permission_classes = [IsAuthenticated]
    pagination_class = PageNumberPagination

    def get(self, request, *args, **kwargs):
        media = Media.objects.filter(user_id=request.user_id)
        paginator = self.pagination_class()
        page = paginator.paginate_queryset(media, request, view=self)
        if page is not None:
            serializer = MediaSerializer(page, many=True)
            return paginator.get_paginated_response(serializer.data)

        serializer = MediaSerializer(media, many=True)
        return Response(serializer.data)


class MediaFileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, media_id, *args, **kwargs):
        media = get_object_or_404(Media, id=media_id)
        if media.user_id != request.user_id:
            return Response(
                {"detail": "You do not have permission to access this file."},
                status=status.HTTP_403_FORBIDDEN,
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
            return Response(
                {"detail": "File not found."}, status=status.HTTP_404_NOT_FOUND
            )
