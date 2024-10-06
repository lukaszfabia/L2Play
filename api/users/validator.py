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

    @staticmethod
    def validate_friendship(sender: CustomUser, receiver: CustomUser) -> bool:
        # we can't add yourself
        if sender == receiver:
            return False

        # bad cause we want new friend
        if sender.friends.filter(id=receiver.id).exists():
            return False

        # if already sent
        if sender.received_friend_requests.filter(
            sender=sender, receiver=receiver, status="pending"
        ).exists():
            return False

        return True
