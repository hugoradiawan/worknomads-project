from django.db import models

class Media(models.Model):
    user_id = models.IntegerField()
    file = models.FileField(upload_to='media/')
    media_type = models.CharField(max_length=10, choices=[('image', 'Image'), ('audio', 'Audio')])
    uploaded_at = models.DateTimeField(auto_now_add=True)
    metadata = models.JSONField(null=True, blank=True)

    def __str__(self):
        return f"{self.user_id} - {self.file.name}"
