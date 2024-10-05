from django.core.validators import validate_email as is_email_valid

from users import serializers
from users.models import CustomUser


class UserValidator:
    @staticmethod
    def validate_email(email: str) -> bool:
        # check if email has proper structure
        try:
            is_email_valid(email)
        except serializers.ValidationError:
            return False

        # is email already exists in db = is not valid
        return not CustomUser.objects.filter(email=email).exists()
