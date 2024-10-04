from django.urls import path

from users.views import LoginViaGoogle, LoginView


urlpatterns = [
    path("login/", LoginView.as_view(), name="login"),
    path("google-login/", LoginViaGoogle.as_view(), name="google_login"),
]
