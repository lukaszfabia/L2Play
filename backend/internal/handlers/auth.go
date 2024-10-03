package handlers

import (
	"backend/internal/response"
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/markbates/goth/gothic"
)

func Callback(c *gin.Context) {
	port := os.Getenv("API_PORT")
	r := response.Gin{Ctx: c}

	provider := c.Query("provider")

	req := c.Request.WithContext(context.WithValue(context.Background(), "provider", provider))

	user, err := gothic.CompleteUserAuth(c.Writer, req)
	if err != nil {
		r.NewResponse(http.StatusInternalServerError, response.InvalidData, err.Error())
		return
	}

	log.Println(user)
	c.Redirect(http.StatusFound, fmt.Sprintf("http://localhost:%s", port))
}

func Logout(c *gin.Context) {
	r := response.Gin{Ctx: c}
	if err := gothic.Logout(c.Writer, c.Request); err != nil {
		r.NewResponse(http.StatusInternalServerError, response.Fail, err.Error())
		return
	}

	r.NewResponse(http.StatusOK, response.Success, "Successfully logged out!")
}

func BeginAuthProviderCallback(c *gin.Context) {
	r := response.Gin{Ctx: c}
	provider := c.Query("provider")
	req := c.Request.WithContext(context.WithValue(context.Background(), "provider", provider))
	gothic.BeginAuthHandler(c.Writer, req)

	r.NewResponse(http.StatusOK, response.Success, "")
}
