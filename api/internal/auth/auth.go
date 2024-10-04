package auth

import (
	"fmt"
	"os"

	"github.com/gorilla/sessions"
	"github.com/markbates/goth"
	"github.com/markbates/goth/gothic"
	"github.com/markbates/goth/providers/google"
)

const (
	MaxAge = 60 * 60 * 24 * 30
	IsProd = true
)

func NewAuth() {
	sessionSecret := os.Getenv("SESSION_SECRET")
	googleClientID := os.Getenv("GOOGLE_CLIENT_ID")
	googleClientSecret := os.Getenv("GOOGLE_CLIENT_SECRET")
	port := os.Getenv("API_PORT")

	store := sessions.NewCookieStore([]byte(sessionSecret))
	store.MaxAge(MaxAge)

	store.Options.Path = "/"
	store.Options.HttpOnly = true
	store.Options.Secure = IsProd

	gothic.Store = store

	goth.UseProviders(google.New(
		googleClientID,
		googleClientSecret,
		fmt.Sprintf("http://localhost:%s/api/auth/google/callback/", port)),
	)
}
