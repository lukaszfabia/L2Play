from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny
from api import settings
from users.serializers import RegisterSerializer
from users.models import CustomUser
from google.oauth2 import id_token
from google.auth.transport import requests


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
    serializer_class = RegisterSerializer

    def post(self, request):
        s = self.serializer_class(data=request.data)

        if s.is_valid():
            s.save()
            return Response(status=status.HTTP_201_CREATED, data=s.data)

        return Response(status=status.HTTP_400_BAD_REQUEST, data=s.errors)


class FriendsView(APIView): ...


class FriendRequestsView(APIView): ...
