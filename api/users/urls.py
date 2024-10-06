from django.urls import path

from users.views import (
    ContinueWithGoogleView,
    LoginView,
    RegisterView,
    GetFriends,
    SendFriendRequest,
)


urlpatterns = [
    path("login/", LoginView.as_view(), name="login"),
    path("register/", RegisterView.as_view(), name="register"),
    path("google-login/", ContinueWithGoogleView.as_view(), name="google_login"),
    path("friend/", GetFriends.as_view(), name="friends"),
    path("add-friend/", SendFriendRequest.as_view(), name="friends"),
]
