from django.urls import path

from users.views import (
    ContinueWithGoogleView,
    LoginView,
    GetFriends,
    SendFriendRequest,
    User,
)


urlpatterns = [
    path("", User.as_view(), name="user-data"),
    path("login/", LoginView.as_view(), name="login"),
    path("google-login/", ContinueWithGoogleView.as_view(), name="google_login"),
    path("friend/", GetFriends.as_view(), name="friends"),
    path("add-friend/", SendFriendRequest.as_view(), name="friends"),
]
