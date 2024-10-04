package main

import (
	"backend/internal/auth"
	"backend/internal/config"
	"backend/internal/server"
	"log"

	"github.com/joho/godotenv"
)

func init() {
	err := godotenv.Load("../../.env")
	if err != nil {
		log.Fatalf("Error loading .env file")
	}
	// db.Connect()
}

func main() {
	auth.NewAuth()
	cfg := config.Load()
	s := server.New(cfg)
	if err := s.Run(); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}

}
