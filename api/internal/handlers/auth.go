package handlers

import (
	"backend/internal/response"
	"context"
	"log"
	"net/http"
	"text/template"

	"github.com/gin-gonic/gin"
	"github.com/markbates/goth/gothic"
)

const PROVIDER_KEY string = "provider"

func Callback(c *gin.Context) {
	// port := os.Getenv("API_PORT")
	r := response.Gin{Ctx: c}

	c.Request = c.Request.WithContext(context.WithValue(context.Background(), PROVIDER_KEY, c.Param(PROVIDER_KEY)))

	user, err := gothic.CompleteUserAuth(c.Writer, c.Request)
	if err != nil {
		r.NewResponse(http.StatusInternalServerError, response.InvalidData, err.Error())
		return
	}

	// log.Println(user.AccessToken)
	// log.Println(user.NickName)
	// c.Redirect(http.StatusFound, fmt.Sprintf("http://localhost:%s", port))
	t, _ := template.New("foo").Parse(userTemplate)
	t.Execute(c.Writer, user)
}

func Logout(c *gin.Context) {
	r := response.Gin{Ctx: c}
	if err := gothic.Logout(c.Writer, c.Request); err != nil {
		r.NewResponse(http.StatusInternalServerError, response.Fail, err.Error())
		return
	}

	r.NewResponse(http.StatusOK, response.Success, "Successfully logged out!")
}

func Login(c *gin.Context) {
	r := response.Gin{Ctx: c}
	c.Request = c.Request.WithContext(context.WithValue(context.Background(), PROVIDER_KEY, c.Param(PROVIDER_KEY)))

	if gothUser, err := gothic.CompleteUserAuth(c.Writer, c.Request); err == nil {
		log.Println(gothUser)
		r.NewResponse(http.StatusOK, response.Success, "")
	} else {
		gothic.BeginAuthHandler(c.Writer, c.Request)
		r.NewResponse(http.StatusOK, response.Success, "")
	}

}

var userTemplate = `
<p><a href="/{{.Provider}}/logout/">logout</a></p>
<p>Name: {{.Name}} [{{.LastName}}, {{.FirstName}}]</p>
<p>Email: {{.Email}}</p>
<p>NickName: {{.NickName}}</p>
<p>Location: {{.Location}}</p>
<p>AvatarURL: {{.AvatarURL}} <img src="{{.AvatarURL}}"></p>
<p>Description: {{.Description}}</p>
<p>UserID: {{.UserID}}</p>
<p>AccessToken: {{.AccessToken}}</p>
<p>ExpiresAt: {{.ExpiresAt}}</p>
<p>RefreshToken: {{.RefreshToken}}</p>
`
