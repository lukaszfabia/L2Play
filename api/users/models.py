from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.
class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    google_id = models.CharField(max_length=255, unique=True)
    profile_image = models.URLField(max_length=200, blank=True, null=True)
    friends = models.ManyToManyField(
        "self", symmetrical=False, related_name="friends_of", blank=True
    )

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    class Meta:
        ordering = ["last_name", "first_name"]

    def __str__(self):
        return self.username
