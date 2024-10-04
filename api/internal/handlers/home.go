package handlers

import (
	"backend/internal/response"
	"net/http"

	"github.com/gin-gonic/gin"
)

func Home(c *gin.Context) {
	r := response.Gin{Ctx: c}

	r.NewResponse(http.StatusOK, response.Message("Home"), "")
}
