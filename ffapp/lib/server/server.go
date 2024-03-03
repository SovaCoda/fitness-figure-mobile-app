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

const (
	DefaultFigure = "none"
	DefaultCurrency = 0
	DefaultWeekComplete = 0
	DefaultWeekGoal = 0
	DefaultCurWorkout = "2001-09-04 19:21:00"
)

type server struct {
	pb.UnimplementedRoutesServer
	db *sql.DB
}

func newServer(db *sql.DB) *server {
	return &server{db: db}
}

// BEGIN USER METHODS //

/* all methods return a user object and an error if there is one */

func (s *server) GetUser(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User

	err := s.db.QueryRowContext(ctx, "SELECT email, cur_figure, name, currency, week_complete, week_goal, cur_workout, workout_min_time FROM users WHERE email = ?", in.Email).Scan(&user.Email, &user.CurFigure, &user.Name, &user.Currency, &user.WeekComplete, &user.WeekGoal, &user.CurWorkout, &user.WorkoutMinTime)
	if err != nil {
		return nil, fmt.Errorf("could not get user: %v", err)
	}
	return &user, nil
}

func (s *server) CreateUser(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User

	s.db.QueryRowContext(ctx, "INSERT INTO users (email, cur_figure, name, currency, week_complete, week_goal, cur_workout) VALUES (?, ?, ?, ?, ?, ?, ?)", in.Email, DefaultFigure, in.Name, DefaultCurrency, DefaultWeekComplete, DefaultWeekGoal, DefaultCurWorkout)

	return &user, nil
}

func (s *server) UpdateUser(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User

	// Retrieve existing user information
	err := s.db.QueryRowContext(ctx, "SELECT email, cur_figure, name, currency, week_complete, week_goal, cur_workout, workout_min_time FROM users WHERE email = ?", in.Email).Scan(&user.Email, &user.CurFigure, &user.Name, &user.Currency, &user.WeekComplete, &user.WeekGoal, &user.CurWorkout, &user.WorkoutMinTime)
	if err != nil {
		return nil, fmt.Errorf("could not get user: %v", err)
	}

	// Update specified fields with the values from the passed user
	if in.CurFigure != "" {
		user.CurFigure = in.CurFigure
	}
	if in.Name != "" {
		user.Name = in.Name
	}
	if in.Currency != 0 {
		user.Currency = in.Currency
	}
	if in.WeekComplete != 0 {
		user.WeekComplete = in.WeekComplete
	}
	if in.WeekGoal != 0 {
		user.WeekGoal = in.WeekGoal
	}
	if in.CurWorkout != "" {
		user.CurWorkout = in.CurWorkout
	}
	if in.WorkoutMinTime != 0 {
		user.WorkoutMinTime = in.WorkoutMinTime
	}

	// Update the user in the database
	_, err = s.db.ExecContext(ctx, "UPDATE users SET cur_figure = ?, name = ?, currency = ?, week_complete = ?, week_goal = ?, cur_workout = ?, workout_min_time = ? WHERE email = ?", user.CurFigure, user.Name, user.Currency, user.WeekComplete, user.WeekGoal, user.CurWorkout, user.WorkoutMinTime, user.Email)
	if err != nil {
		return nil, fmt.Errorf("could not update user: %v", err)
	}

	return &user, nil
}

func (s *server) DeleteUser(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User

	err := s.db.QueryRowContext(ctx, "SELECT email, cur_figure, name, currency, week_complete, week_goal, cur_workout FROM users WHERE email = ?", in.Email).Scan(&user.Email, &user.CurFigure, &user.Name, &user.Currency, &user.WeekComplete, &user.WeekGoal, &user.CurWorkout)
	if err != nil {
		return nil, fmt.Errorf("could not get user: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM users WHERE email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not delete user: %v", err)
	}

	return &user, nil
}

// END USER METHODS //

// BEGIN WORKOUT METHODS //

func (s *server) CreateWorkout(ctx context.Context, in *pb.Workout) (*pb.Workout, error) {

	var workout pb.Workout;

	_, err := s.db.ExecContext(ctx, "INSERT INTO workouts (email, start_date, elapsed, currency_add, end_date, charge_add) VALUES (?, ?, ?, ?, ?, ?)", in.Email, in.StartDate, in.Elapsed, in.Currency_Add, in.End_Date, in.Charge_Add)
	if err != nil {
		return nil, fmt.Errorf("could not create workout: %v", err)
	}

	// Theres something wrong with getting the smae workout back idk why but you cant create and get in the same function \_(*-*)_/
	// scnderr := s.db.QueryRowContext(ctx, "SELECT email, start_date, elapsed, currency_add, end_date, charge_add FROM workouts WHERE email = ? AND start_date = ?", in.Email, in.StartDate).Scan(&workout.Email, &workout.StartDate, &workout.Elapsed, &workout.Currency_Add, &workout.End_Date, &workout.Charge_Add)
	// if scnderr != nil {
	// 	return nil, fmt.Errorf("could not get workout: %v", scnderr)
	// }

	return &workout, nil
}

func (s *server) GetWorkouts(ctx context.Context, in *pb.User) (*pb.MultiWorkout, error) {
	workouts := &pb.MultiWorkout{} // Initialize workouts

	rows, err := s.db.QueryContext(ctx, "SELECT email, start_date, elapsed, currency_add, end_date, charge_add FROM workouts WHERE email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not get workouts: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var workout pb.Workout
		err := rows.Scan(&workout.Email, &workout.StartDate, &workout.Elapsed, &workout.Currency_Add, &workout.End_Date, &workout.Charge_Add)
		if err != nil {
			return nil, fmt.Errorf("could not scan workout: %v", err)
		}
		workouts.Workouts = append(workouts.Workouts, &workout)

		// Log output for each workout
		log.Printf("Retrieved workout: Email=%s, StartDate=%s, Elapsed=%d, Currency_Add=%d, End_Date=%s, Charge_Add=%d", workout.Email, workout.StartDate, workout.Elapsed, workout.Currency_Add, workout.End_Date, workout.Charge_Add)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over workouts: %v", err)
	}

	return workouts, nil
}

func (s *server) GetWorkout(ctx context.Context, in *pb.Workout) (*pb.Workout, error) {
	var workout pb.Workout

	err := s.db.QueryRowContext(ctx, "SELECT email, start_date, elapsed, currency_add, end_date, charge_add FROM workouts WHERE email = ? AND start_date = ?", in.Email, in.StartDate).Scan(&workout.Email, &workout.StartDate, &workout.Elapsed, &workout.Currency_Add, &workout.End_Date, &workout.Charge_Add)
	if err != nil {
		return nil, fmt.Errorf("could not get workout: %v", err)
	}

	return &workout, nil
}

func (s *server) UpdateWorkout(ctx context.Context, in *pb.Workout) (*pb.Workout, error) {
	_, err := s.db.ExecContext(ctx, "UPDATE workouts SET elapsed = ?, currency_add = ?, end_date = ?, charge_add = ? WHERE email = ? AND start_date = ?", in.Elapsed, in.Currency_Add, in.End_Date, in.Charge_Add, in.Email, in.StartDate)
	if err != nil {
		return nil, fmt.Errorf("could not update workout: %v", err)
	}

	return in, nil
}

func (s *server) DeleteWorkout(ctx context.Context, in *pb.Workout) (*pb.Workout, error) {
	var workout pb.Workout

	err := s.db.QueryRowContext(ctx, "SELECT email, start_date, elapsed, currency_add, end_date, charge_add FROM workouts WHERE email = ? AND start_date = ?", in.Email, in.StartDate).Scan(&workout.Email, &workout.StartDate, &workout.Elapsed, &workout.Currency_Add, &workout.End_Date, &workout.Charge_Add)
	if err != nil {
		return nil, fmt.Errorf("could not get workout: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM workouts WHERE email = ? AND start_date = ?", in.Email, in.StartDate)
	if err != nil {
		return nil, fmt.Errorf("could not delete workout: %v", err)
	}

	return &workout, nil
}

// END WORKOUT METHODS //

// BEGIN FIGURE METHODS //

func (s *server) GetFigure(ctx context.Context, in *pb.Figure) (*pb.Figure, error) {
	var figure pb.Figure

	err := s.db.QueryRowContext(ctx, "SELECT figure_id, name, evo_points, stage, user_email, charge FROM figures WHERE user_email = ? AND figure_id = ?", in.UserEmail, in.Figure_Id).Scan(&figure.Figure_Id, &figure.Name, &figure.EvoPoints, &figure.Stage, &figure.UserEmail, &figure.Charge)
	if err != nil {
		return nil, fmt.Errorf("could not get figure: %v", err)
	}

	return &figure, nil
}

func (s *server) UpdateFigure(ctx context.Context, in *pb.Figure) (*pb.Figure, error) {
	_, err := s.db.ExecContext(ctx, "UPDATE figures SET name = ?, evo_points = ?, stage = ?, user_email = ?, charge = ? WHERE figure_id = ?", in.Name, in.EvoPoints, in.Stage, in.UserEmail, in.Charge, in.Figure_Id)
	if err != nil {
		return nil, fmt.Errorf("could not update figure: %v", err)
	}

	return in, nil
}

func (s *server) CreateFigure(ctx context.Context, in *pb.Figure) (*pb.Figure, error) {
	_, err := s.db.ExecContext(ctx, "INSERT INTO figures (figure_id, name, evo_points, stage, user_email, charge) VALUES (?, ?, ?, ?, ?, ?)", in.Figure_Id, in.Name, in.EvoPoints, in.Stage, in.UserEmail, in.Charge)
	if err != nil {
		return nil, fmt.Errorf("could not create figure: %v", err)
	}

	return in, nil
}

func (s *server) DeleteFigure(ctx context.Context, in *pb.Figure) (*pb.Figure, error) {
	var figure pb.Figure

	err := s.db.QueryRowContext(ctx, "SELECT figure_id, name, evo_points, stage, user_email, charge FROM figures WHERE figure_id = ?", in.Figure_Id).Scan(&figure.Figure_Id, &figure.Name, &figure.EvoPoints, &figure.Stage, &figure.UserEmail, &figure.Charge)
	if err != nil {
		return nil, fmt.Errorf("could not get figure: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM figures WHERE figure_id = ?", in.Figure_Id)
	if err != nil {
		return nil, fmt.Errorf("could not delete figure: %v", err)
	}

	return &figure, nil
}

func (s *server) GetFigures(ctx context.Context, in *pb.User) (*pb.MultiFigure, error) {
	figures := &pb.MultiFigure{} // Initialize figures

	rows, err := s.db.QueryContext(ctx, "SELECT figure_id, name, evo_points, stage, user_email, charge FROM figures WHERE user_email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not get figures: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var figure pb.Figure
		err := rows.Scan(&figure.Figure_Id, &figure.Name, &figure.EvoPoints, &figure.Stage, &figure.UserEmail, &figure.Charge)
		if err != nil {
			return nil, fmt.Errorf("could not scan figure: %v", err)
		}
		figures.Figures = append(figures.Figures, &figure)

		// Log output for each figure
		log.Printf("Retrieved figure: FigureId=%s, Name=%s, EvoPoints=%d, Stage=%d, UserEmail=%s, Charge=%d", figure.Figure_Id, figure.Name, figure.EvoPoints, figure.Stage, figure.UserEmail, figure.Charge)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over figures: %v", err)
	}

	return figures, nil
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
	log.Printf("Server is listening on %s", lis.Addr().String())
	s := grpc.NewServer()
	reflection.Register(s)
	pb.RegisterRoutesServer(s, newServer(db))
	if err := s.Serve(lis); err != nil {
		log.Fatalf("could not serve: %v", err)
	}
}
