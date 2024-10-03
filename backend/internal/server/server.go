package server

import (
	"backend/internal/config"
	"log"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

type Server struct {
	config *config.Config
	router *gin.Engine
}

func New(cfg *config.Config) *Server {
	router := gin.Default()

	router.Use(cors.New(cfg.CorsConfig))

	err := router.SetTrustedProxies(nil)
	if err != nil {
		log.Fatalf("Failed to set trusted proxies: %v", err)
	}

	return &Server{
		config: cfg,
		router: router,
	}
}

func (s *Server) Run() error {
	DefineRoutes(s.router)
	log.Printf("Starting server on %s", s.config.Port)
	return s.router.Run(":" + s.config.Port)
}
