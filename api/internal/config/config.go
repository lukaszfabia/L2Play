package config

import (
	"os"
	"strings"
	"time"

	"github.com/gin-contrib/cors"
)

type Config struct {
	Port       string
	CorsConfig cors.Config
}

func Load() *Config {
	const sep string = ","

	corsConfig := cors.Config{
		AllowOrigins:     strings.Split(os.Getenv("ALLOW_ORIGINS"), sep),
		AllowMethods:     strings.Split(os.Getenv("ALLOW_METHODS"), sep),
		AllowHeaders:     strings.Split(os.Getenv("ALLOW_HEADERS"), sep),
		ExposeHeaders:    strings.Split(os.Getenv("EXPOSE_HEADERS"), sep),
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}

	return &Config{
		Port:       os.Getenv("API_PORT"),
		CorsConfig: corsConfig,
	}
}
