from rest_framework import serializers

from users.models import CustomUser, FriendRequest


class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = [
            "email",
            "password",
            "first_name",
            "last_name",
            "profile_image",
            "google_id",
        ]
        extra_kwargs = {"password": {"write_only": True}}

    def create(self, validated_data) -> CustomUser:
        user = CustomUser(
            email=validated_data["email"],
            first_name=validated_data["first_name"],
            last_name=validated_data["last_name"],
            google_id=validated_data.get("google_id", ""),
            profile_image=validated_data.get("profile_image", ""),
        )
        user.set_password(validated_data["password"])
        user.save()
        return user

    def to_json(self, instance):
        """Serialization to JSON object"""
        return {
            "email": instance.email,
            "first_name": instance.first_name,
            "last_name": instance.last_name,
        }


class FriendRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = FriendRequest
        fields = ["sender", "reciever", "status"]

    def create(self, validated_data):
        request = FriendRequest(
            sender=validated_data["sender"],
            receiver=validated_data["receiver"],
        )

        request.save()
        return request
