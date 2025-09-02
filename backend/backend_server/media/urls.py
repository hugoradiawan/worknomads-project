from django.urls import path
from .views import MediaUploadView, MediaListView, MediaFileView

urlpatterns = [
    path('upload/', MediaUploadView.as_view(), name='media-upload'),
    path('list/', MediaListView.as_view(), name='media-list'),
    path('<int:media_id>/', MediaFileView.as_view(), name='media-file'),
]
