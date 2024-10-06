from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from api import settings
from users.serializers import CustomUserSerializer, FriendRequestSerializer
from users.models import CustomUser
from google.oauth2 import id_token
from google.auth.transport import requests
from users.validator import UserValidator


class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email: str = request.data.get("email")
        password: str = request.data.get("password")
        user = authenticate(request, email=email, password=password)

        if user is not None:
            refresh = RefreshToken.for_user(user)
            return Response(
                {
                    "refresh": str(refresh),
                    "access": str(refresh.access_token),
                },
                status=status.HTTP_200_OK,
            )
        return Response(
            {"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED
        )


class ContinueWithGoogleView(APIView):
    permission_classes = [AllowAny]

    # TODO: check or fix
    def post(self, request):
        id_token_received = request.data.get("idToken")

        try:
            idinfo = id_token.verify_oauth2_token(
                id_token_received, requests.Request(), settings.GOOGLE_CLIENT_ID
            )
            email = idinfo["email"]
            user, _ = CustomUser.objects.get_or_create(
                email=email,
                username=idinfo.get("nickname", ""),
                defaults={
                    "email": email,
                    "first_name": idinfo.get("given_name", ""),
                    "last_name": idinfo.get("family_name", ""),
                },
            )
            refresh = RefreshToken.for_user(user)
            return Response(
                {
                    "refresh": str(refresh),
                    "access": str(refresh.access_token),
                }
            )
        except ValueError:
            return Response(
                {"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST
            )


class RegisterView(APIView):
    permission_classes = [AllowAny]
    serializer_class = CustomUserSerializer

    def post(self, request):
        s = self.serializer_class(data=request.data)

        if s.is_valid() and UserValidator.validate_email(s.data["email"]):
            s.save()
            return Response(status=status.HTTP_201_CREATED, data=s.data)

        return Response(status=status.HTTP_400_BAD_REQUEST, data=s.errors)


class GetFriends(APIView):
    permission_classes = [IsAuthenticated]
    serializer_class = CustomUserSerializer

    def get(self, _):
        user = CustomUser.objects.filter(id=self.request.user.id).first()

        if _status := self.request.GET.get("status"):
            match _status:
                case "accepted":
                    friends = user.friends.all()
                    return Response(
                        data=self.serializer_class(friends, many=True).data,
                        status=status.HTTP_200_OK,
                    )
                case _:
                    req = user.received_friend_requests.filter(status=_status)
                    return Response(
                        data=self.serializer_class(req, many=True).data,
                        status=status.HTTP_200_OK,
                    )

        return Response(status=status.HTTP_400_BAD_REQUEST)


class SendFriendRequest(APIView):
    permission_classes = [IsAuthenticated]
    serializer_class = FriendRequestSerializer

    def post(self, _):
        sender = CustomUser.objects.filter(id=self.request.user.id).first()
        receiver = CustomUser.objects.filter(id=self.request.GET.get("id"))

        if receiver is None:
            return Response(
                status=status.HTTP_400_BAD_REQUEST,
                data="There is not user with given ID",
            )

        data = {
            "sender": sender,
            "receiver": receiver,
        }

        self.serializer_class(data=data)

        if self.serializer_class.is_valid():
            self.serializer_class.save()
            return Response(status=status.HTTP_201_CREATED)

        return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ResponseFriendRequest(APIView):
    permission_classes = [IsAuthenticated]
    serializer_class = CustomUserSerializer

    def put(self, _): ...


class RemoveFromFriend(APIView):
    permission_classes = [IsAuthenticated]
    serializer_class = CustomUserSerializer

    def delete(self, _): ...
