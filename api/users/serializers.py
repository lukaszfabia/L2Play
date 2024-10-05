from rest_framework import serializers

from users.models import CustomUser
from users.validator import UserValidator


class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ["email", "password", "first_name", "last_name"]
        extra_kwargs = {"password": {"write_only": True}}

    def create(self, validated_data) -> CustomUser | None:
        if not UserValidator.validate_email(validated_data.get("email")):
            return None

        user = CustomUser(
            email=validated_data["email"],
            first_name=validated_data["first_name"],
            last_name=validated_data["last_name"],
        )
        user.set_password(validated_data["password"])
        user.save()
        return user

    def to_json(self, instance):
        """
        Serializacja obiektu użytkownika do formatu JSON.
        """
        return {
            "email": instance.email,
            "first_name": instance.first_name,
            "last_name": instance.last_name,
        }
