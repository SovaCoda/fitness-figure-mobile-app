package main

import (
	pb "lib/server/pb"
	"context"
	"database/sql"
	"fmt"
	"log"
	"net"

	_ "github.com/go-sql-driver/mysql"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type server struct {
	pb.UnimplementedRoutesServer
	db *sql.DB
}

func newServer(db * sql.DB) *server {
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
	db, err := sql.Open("mysql", "ffigure:QuinnIsANanimal229@tcp(fitness-figure.cnrjdxyoeizn.us-east-2.rds.amazonaws.com)/test")
	if err != nil {
		log.Fatalf("could not connect to database: %v", err)
	}
	defer db.Close()

	s := newServer(db)
	pb.RegisterRoutesServer(grpc.NewServer(), s)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("could not serve: %v", err)
	}
}