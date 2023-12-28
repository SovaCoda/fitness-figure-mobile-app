package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net"
	"os"

	pb "server/pb/routes"

	_ "github.com/go-sql-driver/mysql"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type server struct {
	pb.UnimplementedRoutesServer
	db *sql.DB
}

func newServer(db *sql.DB) *server {
	return &server{db: db}
}

func (s *server) GetUser(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User

	err := s.db.QueryRowContext(ctx, "SELECT * FROM users WHERE email = ?", in.Email).Scan(&user.Email, &user.CurFigure, &user.Name, &user.Pass, &user.Currency, &user.WeekComplete, &user.WeekGoal, &user.CurWorkout)
	if err != nil {
		return nil, fmt.Errorf("could not get user: %v", err)
	}
	return &user, nil
}

func main() {
	dbHost := os.Getenv("DB_HOST")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")

	db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s)/%s", dbUser, dbPassword, dbHost, dbName))
	if err != nil {
		log.Fatalf("could not connect to database: %v", err)
	}
	defer db.Close()

	lis, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatalf("could not listen: %v", err)
	}

	s := grpc.NewServer()
	reflection.Register(s)
	pb.RegisterRoutesServer(s, newServer(db))
	if err := s.Serve(lis); err != nil {
		log.Fatalf("could not serve: %v", err)
	}
}
