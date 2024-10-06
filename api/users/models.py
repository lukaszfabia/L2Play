from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.
class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    google_id = models.CharField(max_length=255, unique=True, blank=True, null=True)
    profile_image = models.URLField(max_length=200, blank=True, null=True)
    friends = models.ManyToManyField("self", blank=True)

    received_friend_requests = models.ManyToManyField(
        "FriendRequest", related_name="receiver_requests", blank=True
    )

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    class Meta:
        ordering = ["last_name", "first_name"]

    def __str__(self):
        return self.email


class FriendRequest(models.Model):
    class FriendRequestStatus(models.TextChoices):
        PENDING = "pending", "Pending"
        ACCEPTED = "accepted", "Accepted"
        REJECTED = "rejected", "Rejected"

    sender = models.ForeignKey(
        CustomUser, related_name="sent_friend_requests", on_delete=models.CASCADE
    )
    receiver = models.ForeignKey(
        CustomUser,
        related_name="received_friend_requests_set",
        on_delete=models.CASCADE,
    )
    status = models.CharField(
        max_length=10,
        choices=FriendRequestStatus.choices,
        default=FriendRequestStatus.PENDING,
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Friend request from {self.sender.email} to {self.receiver.email} ({self.status})"
