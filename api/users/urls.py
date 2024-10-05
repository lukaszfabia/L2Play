from django.urls import path

from users.views import (
    ContinueWithGoogleView,
    LoginView,
    RegisterView,
    FriendRequestsView,
    FriendsView,
)


urlpatterns = [
    path("login/", LoginView.as_view(), name="login"),
    path("register/", RegisterView.as_view(), name="register"),
    path("google-login/", ContinueWithGoogleView.as_view(), name="google_login"),
    path("friend-requests/", FriendRequestsView.as_view(), name="friend-requests"),
    path("friend/", FriendsView.as_view(), name="friends"),
]
