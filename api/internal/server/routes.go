package server

import (
	"backend/internal/handlers"

	"github.com/gin-gonic/gin"
)

func DefineRoutes(router *gin.Engine) {
	router.GET("/", handlers.Home)

	api := router.Group("/api")
	{
		auth := api.Group("/auth/:provider")
		{
			auth.GET("", handlers.Login)
			auth.GET("/callback/", handlers.Callback)
			auth.GET("/logout/", handlers.Logout)
		}
	}
}
