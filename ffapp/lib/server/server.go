package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net"
	"os"
	"time"

	pb "server/pb/routes"

	_ "github.com/go-sql-driver/mysql"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"google.golang.org/protobuf/types/known/emptypb"
)

const (
	DefaultFigure       = "none"
	DefaultCurrency     = 0
	DefaultWeekComplete = 0
	DefaultWeekGoal     = 0
	DefaultCurWorkout   = "2001-09-04 19:21:00"
	DefaultMinTime      = 0
	DefaultLastReset    = "2001-09-04 19:21:00"
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

	err := s.db.QueryRowContext(ctx, "SELECT email, cur_figure, name, currency, week_complete, week_goal, cur_workout, workout_min_time, last_login, streak, premium, ready_for_week_reset, is_in_grace_period FROM users WHERE email = ?", in.Email).Scan(&user.Email, &user.CurFigure, &user.Name, &user.Currency, &user.WeekComplete, &user.WeekGoal, &user.CurWorkout, &user.WorkoutMinTime, &user.LastLogin, &user.Streak, &user.Premium, &user.ReadyForWeekReset, &user.IsInGracePeriod)
	if err != nil {
		return nil, fmt.Errorf("could not get user: %v", err)
	}
	return &user, nil
}

func (s *server) CreateUser(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User

	s.db.QueryRowContext(ctx, "INSERT INTO users (email, cur_figure, name, currency, week_complete, week_goal, cur_workout, workout_min_time, last_login, streak, premium, ready_for_week_reset, is_in_grace_period) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", in.Email, DefaultFigure, in.Name, DefaultCurrency, DefaultWeekComplete, DefaultWeekGoal, DefaultCurWorkout, DefaultMinTime, time.Now().Format("2006-01-02 15:04:05"), 0, 0, "no", "yes")

	return &user, nil
}

func (s *server) UpdateUser(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User

	// Retrieve existing user information
	err := s.db.QueryRowContext(ctx, "SELECT email, cur_figure, name, currency, week_complete, week_goal, cur_workout, workout_min_time, last_login, streak, premium, ready_for_week_reset, is_in_grace_period FROM users WHERE email = ?", in.Email).Scan(&user.Email, &user.CurFigure, &user.Name, &user.Currency, &user.WeekComplete, &user.WeekGoal, &user.CurWorkout, &user.WorkoutMinTime, &user.LastLogin, &user.Streak, &user.Premium, &user.ReadyForWeekReset, &user.IsInGracePeriod)
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
	if in.WeekComplete != 0 { // temp fix for resetting user goal
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
	if in.LastLogin != "" {
		user.LastLogin = in.LastLogin
	}
	if in.Streak != 0 { // temp fix for resetting user streak
		user.Streak = in.Streak
	}
	if in.Premium == -1 { // temp fix next to a temp fix how funny
		user.Premium = 0
	} else if in.Premium != 0 {
		user.Premium = in.Premium
	}
	if in.ReadyForWeekReset != "" {
		user.ReadyForWeekReset = in.ReadyForWeekReset
	}
	if in.IsInGracePeriod != "" {
		user.IsInGracePeriod = in.IsInGracePeriod
	}

	// Update the user in the database
	_, err = s.db.ExecContext(ctx, "UPDATE users SET cur_figure = ?, name = ?, currency = ?, week_complete = ?, week_goal = ?, cur_workout = ?, workout_min_time = ?, last_login = ?, streak = ?, premium = ?, ready_for_week_reset = ?, is_in_grace_period = ? WHERE email = ?", user.CurFigure, user.Name, user.Currency, user.WeekComplete, user.WeekGoal, user.CurWorkout, user.WorkoutMinTime, user.LastLogin, user.Streak, user.Premium, user.ReadyForWeekReset, user.IsInGracePeriod, user.Email)
	if err != nil {
		return nil, fmt.Errorf("could not update user: %v", err)
	}

	return &user, nil
}

func (s *server) DeleteUser(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User

	err := s.db.QueryRowContext(ctx, "SELECT email, cur_figure, name, currency, week_complete, week_goal, cur_workout, workout_min_time, last_login, streak, premium, ready_for_week_reset, is_in_grace_period FROM users WHERE email = ?", in.Email).Scan(&user.Email, &user.CurFigure, &user.Name, &user.Currency, &user.WeekComplete, &user.WeekGoal, &user.CurWorkout, &user.WorkoutMinTime, &user.LastLogin, &user.Streak, &user.Premium, &user.ReadyForWeekReset, &user.IsInGracePeriod)
	if err != nil {
		return nil, fmt.Errorf("could not get user: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM users WHERE email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not delete user: %v", err)
	}

	return &user, nil
}

func (s *server) ResetUserStreak(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User
	result, err := s.db.ExecContext(ctx, "UPDATE users SET Streak = ? WHERE email = ?", int64(0), in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not reset user streak: %v", err)
	}

	rowsAffected, _ := result.RowsAffected()
	fmt.Printf("Number of rows affected: %d\n", rowsAffected)

	return &user, nil
}

func (s *server) ResetUserWeekComplete(ctx context.Context, in *pb.User) (*pb.User, error) {
	var user pb.User
	_, err := s.db.ExecContext(ctx, "UPDATE users SET week_complete = ? WHERE email = ?", 0, in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not reset user week complete: %v", err)
	}

	return &user, nil
}

func (s *server) UpdateUserEmail(ctx context.Context, in *pb.UpdateEmailRequest) (*pb.User, error) {
	// Start a transaction
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("could not begin transaction: %v", err)
	}
	defer tx.Rollback() // Roll back the transaction if it's not committed

	// Update the email in the users table
	_, err = tx.ExecContext(ctx, "UPDATE users SET email = ? WHERE email = ?", in.NewEmail, in.OldEmail)
	if err != nil {
		return nil, fmt.Errorf("could not update user email: %v", err)
	}

	// Update the email in other related tables
	tables := []string{"workouts", "figure_instances", "skin_instances", "survey_responses"}
	for _, table := range tables {
		if (table == "figure_instances") || (table == "skin_instances") {
			_, err = tx.ExecContext(ctx, fmt.Sprintf("UPDATE %s SET user_email = ? WHERE user_email = ?", table), in.NewEmail, in.OldEmail)
			if err != nil {
				return nil, fmt.Errorf("could not update email in %s table: %v", table, err)
			}
		} else {
			_, err = tx.ExecContext(ctx, fmt.Sprintf("UPDATE %s SET email = ? WHERE email = ?", table), in.NewEmail, in.OldEmail)
			if err != nil {
				return nil, fmt.Errorf("could not update email in %s table: %v", table, err)
			}
		}
	}

	// Commit the transaction
	if err = tx.Commit(); err != nil {
		return nil, fmt.Errorf("could not commit transaction: %v", err)
	}

	// Fetch and return the updated user
	var user pb.User
	err = s.db.QueryRowContext(ctx, "SELECT email, cur_figure, name, currency, week_complete, week_goal, cur_workout, workout_min_time, last_login, streak, premium, ready_for_week_reset, is_in_grace_period FROM users WHERE email = ?", in.NewEmail).
		Scan(&user.Email, &user.CurFigure, &user.Name, &user.Currency, &user.WeekComplete, &user.WeekGoal, &user.CurWorkout, &user.WorkoutMinTime, &user.LastLogin, &user.Streak, &user.Premium, &user.ReadyForWeekReset, &user.IsInGracePeriod)
	if err != nil {
		return nil, fmt.Errorf("could not get updated user: %v", err)
	}

	return &user, nil
}

// END USER METHODS //

// BEGIN DAILY SNAPSHOT METHODS //

func (s *server) CreateDailySnapshot(ctx context.Context, in *pb.DailySnapshot) (*pb.DailySnapshot, error) {
	_, err := s.db.ExecContext(ctx, "INSERT INTO daily_snapshots (user_email, date, figure_name, ev_points, charge, user_streak, user_week_complete, user_week_goal, user_workout_min_time, user_currency) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", in.User_Email, in.Date, in.Figure_Name, in.Ev_Points, in.Charge, in.User_Streak, in.User_Week_Complete, in.User_Week_Goal, in.User_Workout_Min_Time, in.User_Currency)
	if err != nil {
		return nil, fmt.Errorf("could not create daily snapshot: %v", err)
	}

	return in, nil
}

func (s *server) GetDailySnapshots(ctx context.Context, in *pb.DailySnapshot) (*pb.MultiDailySnapshot, error) {
	dailySnapshots := &pb.MultiDailySnapshot{}

	rows, err := s.db.QueryContext(ctx, "SELECT user_email, date, figure_name, ev_points, charge, user_streak, user_week_complete, user_week_goal, user_workout_min_time, user_currency FROM daily_snapshots WHERE user_email = ? AND figure_name = ?", in.User_Email, in.Figure_Name)
	if err != nil {
		return nil, fmt.Errorf("could not get daily snapshots: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var dailySnapshot pb.DailySnapshot
		err := rows.Scan(&dailySnapshot.User_Email, &dailySnapshot.Date, &dailySnapshot.Figure_Name, &dailySnapshot.Ev_Points, &dailySnapshot.Charge, &dailySnapshot.User_Streak, &dailySnapshot.User_Week_Complete, &dailySnapshot.User_Week_Goal, &dailySnapshot.User_Workout_Min_Time, &dailySnapshot.User_Currency)
		if err != nil {
			return nil, fmt.Errorf("could not scan daily snapshot: %v", err)
		}
		dailySnapshots.DailySnapshots = append(dailySnapshots.DailySnapshots, &dailySnapshot)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over daily snapshots: %v", err)
	}

	return dailySnapshots, nil
}

func (s *server) GetDailySnapshot(ctx context.Context, in *pb.DailySnapshot) (*pb.DailySnapshot, error) {
	var dailySnapshot pb.DailySnapshot

	err := s.db.QueryRowContext(ctx, "SELECT user_email, date, figure_name, ev_points, charge, user_streak, user_week_complete, user_week_goal, user_workout_min_time, user_currency FROM daily_snapshots WHERE user_email = ? AND date = ? AND figure_name = ?", in.User_Email, in.Date, in.Figure_Name).Scan(&dailySnapshot.User_Email, &dailySnapshot.Date, &dailySnapshot.Figure_Name, &dailySnapshot.Ev_Points, &dailySnapshot.Charge, &dailySnapshot.User_Streak, &dailySnapshot.User_Week_Complete, &dailySnapshot.User_Week_Goal, &dailySnapshot.User_Workout_Min_Time, &dailySnapshot.User_Currency)
	if err != nil {
		return nil, fmt.Errorf("could not get daily snapshot: %v", err)
	}

	return &dailySnapshot, nil
}

func (s *server) UpdateDailySnapshot(ctx context.Context, in *pb.DailySnapshot) (*pb.DailySnapshot, error) {
	_, err := s.db.ExecContext(ctx, "UPDATE daily_snapshots SET ev_points = ?, charge = ?, user_streak = ?, user_week_complete = ?, user_week_goal = ?, user_workout_min_time = ?, user_currency = ? WHERE user_email = ? AND date = ? AND figure_name = ?", in.Ev_Points, in.Charge, in.User_Streak, in.User_Week_Complete, in.User_Week_Goal, in.User_Workout_Min_Time, in.User_Currency, in.User_Email, in.Date, in.Figure_Name)
	if err != nil {
		return nil, fmt.Errorf("could not update daily snapshot: %v", err)
	}

	return in, nil
}

func (s *server) DeleteDailySnapshot(ctx context.Context, in *pb.DailySnapshot) (*pb.DailySnapshot, error) {
	var dailySnapshot pb.DailySnapshot

	err := s.db.QueryRowContext(ctx, "SELECT user_email, date, figure_name, ev_points, charge, user_streak, user_week_complete, user_week_goal, user_workout_min_time, user_currency FROM daily_snapshots WHERE user_email = ? AND date = ? AND figure_name = ?", in.User_Email, in.Date, in.Figure_Name).Scan(&dailySnapshot.User_Email, &dailySnapshot.Date, &dailySnapshot.Figure_Name, &dailySnapshot.Ev_Points, &dailySnapshot.Charge, &dailySnapshot.User_Streak, &dailySnapshot.User_Week_Complete, &dailySnapshot.User_Week_Goal, &dailySnapshot.User_Workout_Min_Time, &dailySnapshot.User_Currency)
	if err != nil {
		return nil, fmt.Errorf("could not get daily snapshot: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM daily_snapshots WHERE user_email = ? AND date = ? AND figure_name = ?", in.User_Email, in.Date, in.Figure_Name)
	if err != nil {
		return nil, fmt.Errorf("could not delete daily snapshot: %v", err)
	}

	return &dailySnapshot, nil
}

// END DAILY SNAPSHOT METHODS //

// BEGIN WORKOUT METHODS //
func (s *server) CreateWorkout(ctx context.Context, in *pb.Workout) (*pb.Workout, error) {
	var workout pb.Workout

	_, err := s.db.ExecContext(ctx, "INSERT INTO workouts (email, start_date, elapsed, evo_add, end_date, charge_add, countable, robot_name, investment) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", in.Email, in.StartDate, in.Elapsed, in.Evo_Add, in.End_Date, in.Charge_Add, in.Countable, in.Robot_Name, in.Investment)
	if err != nil {
		return nil, fmt.Errorf("could not create workout: %v", err)
	}

	return &workout, nil
}

func (s *server) GetWorkouts(ctx context.Context, in *pb.User) (*pb.MultiWorkout, error) {
	workouts := &pb.MultiWorkout{} // Initialize workouts

	rows, err := s.db.QueryContext(ctx, "SELECT email, start_date, elapsed, evo_add, end_date, charge_add, countable, robot_name, investment FROM workouts WHERE email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not get workouts: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var workout pb.Workout
		err := rows.Scan(&workout.Email, &workout.StartDate, &workout.Elapsed, &workout.Evo_Add, &workout.End_Date, &workout.Charge_Add, &workout.Countable, &workout.Robot_Name, &workout.Investment)
		if err != nil {
			return nil, fmt.Errorf("could not scan workout: %v", err)
		}
		workouts.Workouts = append(workouts.Workouts, &workout)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over workouts: %v", err)
	}

	return workouts, nil
}

func (s *server) GetWorkout(ctx context.Context, in *pb.Workout) (*pb.Workout, error) {
	var workout pb.Workout

	err := s.db.QueryRowContext(ctx, "SELECT email, start_date, elapsed, evo_add, end_date, charge_add, countable, robot_name, investment FROM workouts WHERE email = ? AND start_date = ?", in.Email, in.StartDate).Scan(&workout.Email, &workout.StartDate, &workout.Elapsed, &workout.Evo_Add, &workout.End_Date, &workout.Charge_Add, &workout.Countable, &workout.Robot_Name, &workout.Investment)
	if err != nil {
		return nil, fmt.Errorf("could not get workout: %v", err)
	}

	return &workout, nil
}

func (s *server) UpdateWorkout(ctx context.Context, in *pb.Workout) (*pb.Workout, error) {
	_, err := s.db.ExecContext(ctx, "UPDATE workouts SET elapsed = ?, evo_add = ?, end_date = ?, charge_add = ?, countable = ?, robot_name = ?, investment = ? WHERE email = ? AND start_date = ?", in.Elapsed, in.Evo_Add, in.End_Date, in.Charge_Add, in.Countable, in.Robot_Name, in.Investment, in.Email, in.StartDate)
	if err != nil {
		return nil, fmt.Errorf("could not update workout: %v", err)
	}

	return in, nil
}

func (s *server) DeleteWorkout(ctx context.Context, in *pb.Workout) (*pb.Workout, error) {
	var workout pb.Workout

	err := s.db.QueryRowContext(ctx, "SELECT email, start_date, elapsed, evo_add, end_date, charge_add, countable, robot_name, investment FROM workouts WHERE email = ? AND start_date = ?", in.Email, in.StartDate).Scan(&workout.Email, &workout.StartDate, &workout.Elapsed, &workout.Evo_Add, &workout.End_Date, &workout.Charge_Add, &workout.Countable, &workout.Robot_Name, &workout.Investment)
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

// INSTANCES //
func (s *server) GetFigureInstance(ctx context.Context, in *pb.FigureInstance) (*pb.FigureInstance, error) {
	var figureInstance pb.FigureInstance

	err := s.db.QueryRowContext(ctx, "SELECT Figure_Id, Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge, Mood, Last_Reset, Ev_Level FROM figure_instances WHERE User_Email = ? AND Figure_Name = ?", in.User_Email, in.Figure_Name).Scan(&figureInstance.Figure_Id, &figureInstance.Figure_Name, &figureInstance.User_Email, &figureInstance.Cur_Skin, &figureInstance.Ev_Points, &figureInstance.Charge, &figureInstance.Mood, &figureInstance.Last_Reset, &figureInstance.Ev_Level)
	if err != nil {
		return nil, fmt.Errorf("could not get figureInstance: %v", err)
	}

	return &figureInstance, nil
}

func (s *server) UpdateFigureInstance(ctx context.Context, in *pb.FigureInstance) (*pb.FigureInstance, error) {
	var existingFigureInstance pb.FigureInstance

	err := s.db.QueryRowContext(ctx, "SELECT Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge, Mood, Last_Reset, Ev_Level FROM figure_instances WHERE Figure_Name = ? AND User_Email = ?", in.Figure_Name, in.User_Email).Scan(&existingFigureInstance.Figure_Name, &existingFigureInstance.User_Email, &existingFigureInstance.Cur_Skin, &existingFigureInstance.Ev_Points, &existingFigureInstance.Charge, &existingFigureInstance.Mood, &existingFigureInstance.Last_Reset, &existingFigureInstance.Ev_Level)
	if err != nil {
		return nil, fmt.Errorf("could not get existing figureInstance: %v", err)
	}

	if in.Figure_Name != "" && in.Figure_Name != existingFigureInstance.Figure_Name {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Figure_Name = ? WHERE Figure_Name = ? AND User_Email = ?", in.Figure_Name, existingFigureInstance.Figure_Name, existingFigureInstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not update Figure_Name: %v", err)
		}
	}

	if in.User_Email != "" && in.User_Email != existingFigureInstance.User_Email {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET User_Email = ? WHERE Figure_Name = ? AND User_Email = ?", in.User_Email, existingFigureInstance.Figure_Name, existingFigureInstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not update User_Email: %v", err)
		}
	}

	if in.Cur_Skin != "" && in.Cur_Skin != existingFigureInstance.Cur_Skin {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Cur_Skin = ? WHERE Figure_Name = ? AND User_Email = ?", in.Cur_Skin, existingFigureInstance.Figure_Name, existingFigureInstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not update Cur_Skin: %v", err)
		}
	}

	if in.Ev_Points != 0 && in.Ev_Points != existingFigureInstance.Ev_Points {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Ev_Points = ? WHERE Figure_Name = ? AND User_Email = ?", in.Ev_Points, existingFigureInstance.Figure_Name, existingFigureInstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not update Ev_Points: %v", err)
		}
	}

	if in.Charge != 0 && in.Charge != existingFigureInstance.Charge {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Charge = ? WHERE Figure_Name = ? AND User_Email = ?", in.Charge, existingFigureInstance.Figure_Name, existingFigureInstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not update Charge: %v", err)
		}
	}

	if in.Mood != 0 && in.Mood != existingFigureInstance.Mood {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Mood = ? WHERE Figure_Name = ? AND User_Email = ?", in.Mood, existingFigureInstance.Figure_Name, existingFigureInstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not update Mood: %v", err)
		}
	}

	if in.Last_Reset != "" && in.Last_Reset != existingFigureInstance.Last_Reset {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Last_Reset = ? WHERE Figure_Name = ? AND User_Email = ?", in.Last_Reset, existingFigureInstance.Figure_Name, existingFigureInstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not update Last_Reset: %v", err)
		}
	}

	if in.Ev_Level != 0 && in.Ev_Level != existingFigureInstance.Ev_Level {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Ev_Level = ? WHERE Figure_Name = ? AND User_Email = ?", in.Ev_Level, existingFigureInstance.Figure_Name, existingFigureInstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not update Ev_Level: %v", err)
		}
	}

	return in, nil
}

func (s *server) CreateFigureInstance(ctx context.Context, in *pb.FigureInstance) (*pb.FigureInstance, error) {
	_, err := s.db.ExecContext(ctx, "INSERT INTO figure_instances (Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge, Mood, Last_Reset, Ev_Level) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", in.Figure_Name, in.User_Email, in.Cur_Skin, in.Ev_Points, in.Charge, in.Mood, in.Last_Reset, in.Ev_Level)
	if err != nil {
		return nil, fmt.Errorf("could not create figureInstance: %v", err)
	}

	return in, nil
}

func (s *server) DeleteFigureInstance(ctx context.Context, in *pb.FigureInstance) (*pb.FigureInstance, error) {
	var figureInstance pb.FigureInstance

	err := s.db.QueryRowContext(ctx, "SELECT Figure_Id, Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge, Mood, Last_Reset, Ev_Level FROM figure_instances WHERE Figure_Id = ?", in.Figure_Id).Scan(&figureInstance.Figure_Id, &figureInstance.Figure_Name, &figureInstance.User_Email, &figureInstance.Cur_Skin, &figureInstance.Ev_Points, &figureInstance.Charge, &figureInstance.Mood, &figureInstance.Last_Reset, &figureInstance.Ev_Level)
	if err != nil {
		return nil, fmt.Errorf("could not get figure_instances: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM figure_instances WHERE Figure_Id = ?", in.Figure_Id)
	if err != nil {
		return nil, fmt.Errorf("could not delete figure_instances: %v", err)
	}

	return &figureInstance, nil
}

func (s *server) GetFigureInstances(ctx context.Context, in *pb.User) (*pb.MultiFigureInstance, error) {
	figureInstances := &pb.MultiFigureInstance{} // Initialize figureInstances

	rows, err := s.db.QueryContext(ctx, "SELECT Figure_Id, Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge, Mood, Last_Reset, Ev_Level FROM figure_instances WHERE User_Email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not get figureInstances: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var figureInstance pb.FigureInstance
		err := rows.Scan(&figureInstance.Figure_Id, &figureInstance.Figure_Name, &figureInstance.User_Email, &figureInstance.Cur_Skin, &figureInstance.Ev_Points, &figureInstance.Charge, &figureInstance.Mood, &figureInstance.Last_Reset, &figureInstance.Ev_Level)
		if err != nil {
			return nil, fmt.Errorf("could not scan figureInstance: %v", err)
		}
		figureInstances.FigureInstances = append(figureInstances.FigureInstances, &figureInstance)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over figureInstances: %v", err)
	}

	return figureInstances, nil
}

// FIGURES //

func (s *server) GetFigure(ctx context.Context, in *pb.Figure) (*pb.Figure, error) {
	var figure pb.Figure

	err := s.db.QueryRowContext(ctx, "SELECT Figure_Name, Base_Ev_Gain, Base_Currency_Gain, Price, Stage1_Ev_Cutoff, Stage2_Ev_Cutoff, Stage3_Ev_Cutoff, Stage4_Ev_Cutoff, Stage5_Ev_Cutoff, Stage6_Ev_Cutoff, Stage7_Ev_Cutoff, Stage8_Ev_Cutoff, Stage9_Ev_Cutoff, Stage10_Ev_Cutoff FROM figures WHERE Figure_Name = ?", in.Figure_Name).Scan(&figure.Figure_Name, &figure.Base_Ev_Gain, &figure.Base_Currency_Gain, &figure.Price, &figure.Stage1_Ev_Cutoff, &figure.Stage2_Ev_Cutoff, &figure.Stage3_Ev_Cutoff, &figure.Stage4_Ev_Cutoff, &figure.Stage5_Ev_Cutoff, &figure.Stage6_Ev_Cutoff, &figure.Stage7_Ev_Cutoff, &figure.Stage8_Ev_Cutoff, &figure.Stage9_Ev_Cutoff, &figure.Stage10_Ev_Cutoff)
	if err != nil {
		return nil, fmt.Errorf("could not get figure: %v", err)
	}

	return &figure, nil
}

func (s *server) UpdateFigure(ctx context.Context, in *pb.Figure) (*pb.Figure, error) {
	_, err := s.db.ExecContext(ctx, "UPDATE Figures SET Base_Ev_Gain = ?, Base_Currency_Gain = ?, Price = ?, Stage1_Ev_Cutoff = ?, Stage2_Ev_Cutoff = ?, Stage3_Ev_Cutoff = ?, Stage4_Ev_Cutoff = ?, Stage5_Ev_Cutoff = ?, Stage6_Ev_Cutoff = ?, Stage7_Ev_Cutoff = ?, Stage8_Ev_Cutoff = ?, Stage9_Ev_Cutoff = ?, Stage10_Ev_Cutoff = ? WHERE Figure_Name = ?", in.Base_Ev_Gain, in.Base_Currency_Gain, in.Price, in.Stage1_Ev_Cutoff, in.Stage2_Ev_Cutoff, in.Stage3_Ev_Cutoff, in.Stage4_Ev_Cutoff, in.Stage5_Ev_Cutoff, in.Stage6_Ev_Cutoff, in.Stage7_Ev_Cutoff, in.Stage8_Ev_Cutoff, in.Stage9_Ev_Cutoff, in.Stage10_Ev_Cutoff, in.Figure_Name)
	if err != nil {
		return nil, fmt.Errorf("could not update figure: %v", err)
	}

	return in, nil
}

func (s *server) CreateFigure(ctx context.Context, in *pb.Figure) (*pb.Figure, error) {
	_, err := s.db.ExecContext(ctx, "INSERT INTO Figures (Figure_Name, Base_Ev_Gain, Base_Currency_Gain, Price, Stage1_Ev_Cutoff, Stage2_Ev_Cutoff, Stage3_Ev_Cutoff, Stage4_Ev_Cutoff, Stage5_Ev_Cutoff, Stage6_Ev_Cutoff, Stage7_Ev_Cutoff, Stage8_Ev_Cutoff, Stage9_Ev_Cutoff, Stage10_Ev_Cutoff) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", in.Figure_Name, in.Base_Ev_Gain, in.Base_Currency_Gain, in.Price, in.Stage1_Ev_Cutoff, in.Stage2_Ev_Cutoff, in.Stage3_Ev_Cutoff, in.Stage4_Ev_Cutoff, in.Stage5_Ev_Cutoff, in.Stage6_Ev_Cutoff, in.Stage7_Ev_Cutoff, in.Stage8_Ev_Cutoff, in.Stage9_Ev_Cutoff, in.Stage10_Ev_Cutoff)
	if err != nil {
		return nil, fmt.Errorf("could not create figure: %v", err)
	}

	return in, nil
}

func (s *server) DeleteFigure(ctx context.Context, in *pb.Figure) (*pb.Figure, error) {
	var figure pb.Figure

	err := s.db.QueryRowContext(ctx, "SELECT Figure_Name, Base_Ev_Gain, Base_Currency_Gain, Price, Stage1_Ev_Cutoff, Stage2_Ev_Cutoff, Stage3_Ev_Cutoff, Stage4_Ev_Cutoff, Stage5_Ev_Cutoff, Stage6_Ev_Cutoff, Stage7_Ev_Cutoff, Stage8_Ev_Cutoff, Stage9_Ev_Cutoff, Stage10_Ev_Cutoff FROM Figures WHERE Figure_Name = ?", in.Figure_Name).Scan(&figure.Figure_Name, &figure.Base_Ev_Gain, &figure.Base_Currency_Gain, &figure.Price, &figure.Stage1_Ev_Cutoff, &figure.Stage2_Ev_Cutoff, &figure.Stage3_Ev_Cutoff, &figure.Stage4_Ev_Cutoff, &figure.Stage5_Ev_Cutoff, &figure.Stage6_Ev_Cutoff, &figure.Stage7_Ev_Cutoff, &figure.Stage8_Ev_Cutoff, &figure.Stage9_Ev_Cutoff, &figure.Stage10_Ev_Cutoff)
	if err != nil {
		return nil, fmt.Errorf("could not get figure: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM Figures WHERE Figure_Name = ?", in.Figure_Name)
	if err != nil {
		return nil, fmt.Errorf("could not delete figure: %v", err)
	}

	return &figure, nil
}

func (s *server) GetFigures(ctx context.Context, in *emptypb.Empty) (*pb.MultiFigure, error) {
	figures := &pb.MultiFigure{} // Initialize figures

	rows, err := s.db.QueryContext(ctx, "SELECT Figure_Name, Base_Ev_Gain, Base_Currency_Gain, Price, Stage1_Ev_Cutoff, Stage2_Ev_Cutoff, Stage3_Ev_Cutoff, Stage4_Ev_Cutoff, Stage5_Ev_Cutoff, Stage6_Ev_Cutoff, Stage7_Ev_Cutoff, Stage8_Ev_Cutoff, Stage9_Ev_Cutoff, Stage10_Ev_Cutoff FROM figures")
	if err != nil {
		return nil, fmt.Errorf("could not get figures: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var figure pb.Figure
		err := rows.Scan(&figure.Figure_Name, &figure.Base_Ev_Gain, &figure.Base_Currency_Gain, &figure.Price, &figure.Stage1_Ev_Cutoff, &figure.Stage2_Ev_Cutoff, &figure.Stage3_Ev_Cutoff, &figure.Stage4_Ev_Cutoff, &figure.Stage5_Ev_Cutoff, &figure.Stage6_Ev_Cutoff, &figure.Stage7_Ev_Cutoff, &figure.Stage8_Ev_Cutoff, &figure.Stage9_Ev_Cutoff, &figure.Stage10_Ev_Cutoff)
		if err != nil {
			return nil, fmt.Errorf("could not scan figure: %v", err)
		}
		figures.Figures = append(figures.Figures, &figure)

		// Log output for each figure
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over figures: %v", err)
	}

	return figures, nil
}

// END FIGURE METHODS //
// BEGIN SKIN METHODS //

func (s *server) GetSkinInstance(ctx context.Context, in *pb.SkinInstance) (*pb.SkinInstance, error) {
	var skinstance pb.SkinInstance

	err := s.db.QueryRowContext(ctx, "SELECT Skin_Id, Skin_Name, Figure_Name, User_Email FROM skin_instances WHERE Skin_Id = ?", in.Skin_Id).Scan(&skinstance.Skin_Id, &skinstance.Skin_Name, &skinstance.Figure_Name, &skinstance.User_Email)
	if err != nil {
		return nil, fmt.Errorf("could not get skin instance: %v", err)
	}

	return &skinstance, nil
}

func (s *server) UpdateSkinInstance(ctx context.Context, in *pb.SkinInstance) (*pb.SkinInstance, error) {
	_, err := s.db.ExecContext(ctx, "UPDATE skin_instances SET Skin_Name = ?, Figure_Name = ?, User_Email = ? WHERE Skin_Id = ?", in.Skin_Name, in.Figure_Name, in.User_Email, in.Skin_Id)
	if err != nil {
		return nil, fmt.Errorf("could not update skin instance: %v", err)
	}

	return in, nil
}

func (s *server) CreateSkinInstance(ctx context.Context, in *pb.SkinInstance) (*pb.SkinInstance, error) {
	rows, checkerr := s.db.QueryContext(ctx, "SELECT skin_name, user_email, figure_name FROM skin_instances WHERE user_email = ?", in.User_Email)
	if checkerr != nil {
		return nil, fmt.Errorf("could not check for existing skin instance: %v", checkerr)
	}
	defer rows.Close()

	for rows.Next() {
		var skinstance pb.SkinInstance
		err := rows.Scan(&skinstance.Skin_Name, &skinstance.User_Email, &skinstance.Figure_Name)
		if err != nil {
			return nil, fmt.Errorf("could not scan skin instance: %v", err)
		}
		if skinstance.Skin_Name == in.Skin_Name && skinstance.Figure_Name == in.Figure_Name && skinstance.User_Email == in.User_Email {
			return nil, fmt.Errorf("Skin already exists for user")
		}
	}

	_, err := s.db.ExecContext(ctx, "INSERT INTO skin_instances (Skin_Name, Figure_Name, User_Email) VALUES (?, ?, ?)", in.Skin_Name, in.Figure_Name, in.User_Email)
	if err != nil {
		return nil, fmt.Errorf("could not create skin instance: %v", err)
	}

	return in, nil
}

func (s *server) DeleteSkinInstance(ctx context.Context, in *pb.SkinInstance) (*pb.SkinInstance, error) {
	_, err := s.db.ExecContext(ctx, "DELETE FROM skin_instances WHERE Skin_Id = ?", in.Skin_Id)
	if err != nil {
		return nil, fmt.Errorf("could not delete skin instance: %v", err)
	}

	return in, nil
}

func (s *server) GetSkinInstances(ctx context.Context, in *pb.User) (*pb.MultiSkinInstance, error) {
	skinInstances := &pb.MultiSkinInstance{}

	rows, err := s.db.QueryContext(ctx, "SELECT Skin_Id, Skin_Name, Figure_Name, User_Email FROM skin_instances WHERE User_Email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not get skin instances: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var skinstance pb.SkinInstance
		err := rows.Scan(&skinstance.Skin_Id, &skinstance.Skin_Name, &skinstance.Figure_Name, &skinstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not scan skin instance: %v", err)
		}
		skinInstances.SkinInstances = append(skinInstances.SkinInstances, &skinstance)

		// Log output for each skin instance
		log.Printf("Retrieved skin instance: Skin_Id=%s, Skin_Name=%s, Figure_Name=%s, User_Email=%s", skinstance.Skin_Id, skinstance.Skin_Name, skinstance.Figure_Name, skinstance.User_Email)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over skin instances: %v", err)
	}

	return skinInstances, nil
}

// SKIN ROUTES //
func (s *server) GetSkin(ctx context.Context, in *pb.Skin) (*pb.Skin, error) {
	var skin pb.Skin

	err := s.db.QueryRowContext(ctx, "SELECT Skin_Name, Figure_Name, Price FROM skin WHERE Skin_Name = ?", in.Skin_Name).Scan(&skin.Skin_Name, &skin.Figure_Name, &skin.Price)
	if err != nil {
		return nil, fmt.Errorf("could not get skin: %v", err)
	}

	return &skin, nil
}

func (s *server) GetSkins(ctx context.Context, in *emptypb.Empty) (*pb.MultiSkin, error) {
	skins := &pb.MultiSkin{}

	rows, err := s.db.QueryContext(ctx, "SELECT Skin_Name, Figure_Name, Price FROM skins")
	if err != nil {
		return nil, fmt.Errorf("could not get skins: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var skin pb.Skin
		err := rows.Scan(&skin.Skin_Name, &skin.Figure_Name, &skin.Price)
		if err != nil {
			return nil, fmt.Errorf("could not scan skin: %v", err)
		}
		skins.Skins = append(skins.Skins, &skin)

		// Log output for each skin
		log.Printf("Retrieved skin: Skin_Name=%s, Figure_Name=%s, Price=%f", skin.Skin_Name, skin.Figure_Name, skin.Price)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over skins: %v", err)
	}

	return skins, nil
}

func (s *server) UpdateSkin(ctx context.Context, in *pb.Skin) (*pb.Skin, error) {
	var skin pb.Skin

	err := s.db.QueryRowContext(ctx, "UPDATE skins SET Figure_Name = ?, Price = ? WHERE Skin_Name = ?", in.Figure_Name, in.Price, in.Skin_Name).Scan(&skin.Skin_Name, &skin.Figure_Name, &skin.Price)
	if err != nil {
		return nil, fmt.Errorf("could not update skin: %v", err)
	}

	return &skin, nil
}

func (s *server) CreateSkin(ctx context.Context, in *pb.Skin) (*pb.Skin, error) {
	var skin pb.Skin

	_, err := s.db.ExecContext(ctx, "INSERT INTO skins (Skin_Name, Figure_Name, Price) VALUES (?, ?, ?)", in.Skin_Name, in.Figure_Name, in.Price)
	if err != nil {
		return nil, fmt.Errorf("could not create skin: %v", err)
	}

	skin.Skin_Name = in.Skin_Name
	skin.Figure_Name = in.Figure_Name
	skin.Price = in.Price

	return &skin, nil
}

func (s *server) DeleteSkin(ctx context.Context, in *pb.Skin) (*pb.Skin, error) {
	var skin pb.Skin

	err := s.db.QueryRowContext(ctx, "DELETE FROM skins WHERE Skin_Name = ?", in.Skin_Name).Scan(&skin.Skin_Name, &skin.Figure_Name, &skin.Price)
	if err != nil {
		return nil, fmt.Errorf("could not delete skin: %v", err)
	}

	return &skin, nil
}

// END SKIN METHODS //
// BEGIN SURVEY METHODS //

func (s *server) GetSurveyResponse(ctx context.Context, in *pb.SurveyResponse) (*pb.SurveyResponse, error) {
	var surveyResponse pb.SurveyResponse

	err := s.db.QueryRowContext(ctx, "SELECT Email, Question, Answer, Date FROM survey_responses WHERE Email = ? AND Question = ? AND Date = ?", in.Email, in.Question, in.Date).Scan(&surveyResponse.Email, &surveyResponse.Question, &surveyResponse.Answer, &surveyResponse.Date)
	if err != nil {
		return nil, fmt.Errorf("could not get survey response: %v", err)
	}

	return &surveyResponse, nil
}

func (s *server) UpdateSurveyResponse(ctx context.Context, in *pb.SurveyResponse) (*pb.SurveyResponse, error) {
	var surveyResponse pb.SurveyResponse

	_, err := s.db.ExecContext(ctx, "UPDATE survey_responses SET Answer = ? WHERE Email = ? AND Question = ? AND Date = ?", in.Answer, in.Email, in.Question, in.Date)
	if err != nil {
		log.Printf("Failed to update survey response: %v", err)
		return nil, err
	}

	surveyResponse.Email = in.Email
	surveyResponse.Question = in.Question
	surveyResponse.Answer = in.Answer
	surveyResponse.Date = in.Date

	return &surveyResponse, nil
}

func (s *server) CreateSurveyResponse(ctx context.Context, in *pb.SurveyResponse) (*pb.SurveyResponse, error) {
	var surveyResponse pb.SurveyResponse

	_, err := s.db.ExecContext(ctx, "INSERT INTO survey_responses (Email, Question, Answer, Date) VALUES (?, ?, ?, ?)", in.Email, in.Question, in.Answer, in.Date)
	if err != nil {
		log.Printf("Failed to create survey response: %v", err)
		return nil, err
	}

	surveyResponse.Email = in.Email
	surveyResponse.Question = in.Question
	surveyResponse.Answer = in.Answer
	surveyResponse.Date = in.Date

	return &surveyResponse, nil
}

func (s *server) DeleteSurveyResponse(ctx context.Context, in *pb.SurveyResponse) (*pb.SurveyResponse, error) {
	var surveyResponse pb.SurveyResponse

	err := s.db.QueryRowContext(ctx, "SELECT Email, Question, Answer, Date FROM survey_responses WHERE Email = ? AND Question = ? AND Date = ?", in.Email, in.Question, in.Date).Scan(&surveyResponse.Email, &surveyResponse.Question, &surveyResponse.Answer, &surveyResponse.Date)
	if err != nil {
		return nil, fmt.Errorf("could not get survey response: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM survey_responses WHERE Email = ? AND Question = ? AND Date = ?", in.Email, in.Question, in.Date)
	if err != nil {
		return nil, fmt.Errorf("could not delete survey response: %v", err)
	}

	return &surveyResponse, nil
}

func (s *server) GetSurveyResponses(ctx context.Context, in *pb.User) (*pb.MultiSurveyResponse, error) {
	surveyResponses := &pb.MultiSurveyResponse{}

	rows, err := s.db.QueryContext(ctx, "SELECT Email, Question, Answer, Date FROM survey_responses WHERE Email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not get survey responses: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var surveyResponse pb.SurveyResponse
		err := rows.Scan(&surveyResponse.Email, &surveyResponse.Question, &surveyResponse.Answer, &surveyResponse.Date)
		if err != nil {
			return nil, fmt.Errorf("could not scan survey response: %v", err)
		}
		surveyResponses.SurveyResponses = append(surveyResponses.SurveyResponses, &surveyResponse)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("could not iterate over survey responses: %v", err)
	}

	return surveyResponses, nil
}

func (s *server) CreateSurveyResponseMulti(ctx context.Context, in *pb.MultiSurveyResponse) (*pb.MultiSurveyResponse, error) {
	responses := []*pb.SurveyResponse{}

	for _, response := range in.SurveyResponses {
		createdResponse, err := s.CreateSurveyResponse(ctx, response)
		if err != nil {
			return nil, err
		}
		responses = append(responses, createdResponse)
	}

	return &pb.MultiSurveyResponse{SurveyResponses: responses}, nil
}

// END SURVEY METHODS //

// BEGIN OFFLINE DATE TIME METHODS //

func (s *server) GetOfflineDateTime(ctx context.Context, in *pb.OfflineDateTime) (*pb.OfflineDateTime, error) {
	// Implement logic to retrieve offline date time for the given email
	var offlineDateTime pb.OfflineDateTime

	err := s.db.QueryRowContext(ctx, "SELECT Email, Currency FROM offline_date_times WHERE Email = ?", in.Email).Scan(&offlineDateTime.Email, &offlineDateTime.Currency)
	if err != nil {
		_, err = s.db.ExecContext(ctx, "INSERT INTO offline_date_times (Email, Currency) VALUES (?, CURRENT_TIMESTAMP)", in.Email)
		if err != nil {
			log.Printf("Failed to create offline date time: %v", err)
			return nil, err
		}

		err := s.db.QueryRowContext(ctx, "SELECT Email, Currency FROM offline_date_times WHERE Email = ?", in.Email).Scan(&offlineDateTime.Email, &offlineDateTime.Currency)
		if err != nil {
			return nil, fmt.Errorf("could not get offline date time: %v", err)
		}
		return &offlineDateTime, nil
	}
	return &offlineDateTime, nil
}

func (s *server) UpdateOfflineDateTime(ctx context.Context, in *pb.OfflineDateTime) (*pb.OfflineDateTime, error) {
	// Implement logic to update offline date time for the given email
	var offlineDateTime pb.OfflineDateTime

	_, err := s.db.ExecContext(ctx, "UPDATE offline_date_times SET Currency = ? WHERE Email = ?", in.Currency, in.Email)
	if err != nil {
		log.Printf("Failed to update offline date time: %v", err)
		// If not found, create a new offline date time
		_, err = s.db.ExecContext(ctx, "INSERT INTO offline_date_times (Email, Currency) VALUES (?, ?)", in.Email, in.Currency)
		if err != nil {
			log.Printf("Failed to create offline date time: %v", err)
			return nil, err
		}
	}

	offlineDateTime.Email = in.Email
	offlineDateTime.Currency = in.Currency

	return &offlineDateTime, nil
}

func (s *server) DeleteOfflineDateTime(ctx context.Context, in *pb.OfflineDateTime) (*pb.OfflineDateTime, error) {
	// Implement logic to delete offline date time for the given email
	var offlineDateTime pb.OfflineDateTime

	err := s.db.QueryRowContext(ctx, "SELECT Email, Currency FROM offline_date_time WHERE Email = ?", in.Email).Scan(&offlineDateTime.Email, &offlineDateTime.Currency)
	if err != nil {
		return nil, fmt.Errorf("could not get offline date time: %v", err)
	}

	_, err = s.db.ExecContext(ctx, "DELETE FROM offline_date_time WHERE Email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not delete offline date time: %v", err)
	}

	return &offlineDateTime, nil
}

// END OFFLINE DATE TIME METHODS //

// BEGIN SERVER ACTIONS //

func (s *server) FigureDecay(ctx context.Context, in *pb.FigureInstance) (*pb.GenericStringResponse, error) {
	fmt.Println("Applying Figure Charge Decay")
	rows, err := s.db.Query("CALL sp_figureDecaySingle(?)", in.User_Email)
	if err != nil {
		log.Fatalf("could not decay figures: %v", err)
		return nil, fmt.Errorf("could not decay figures: %v", err)
	}
	var alteredFigureInstances []*pb.FigureInstance
	for rows.Next() {
		var figureInstance pb.FigureInstance
		err := rows.Scan(&figureInstance.Charge, &figureInstance.User_Email)
		if err != nil {
			log.Fatalf("could not scan figure instance: %v", err)
			return nil, fmt.Errorf("could not iterate figures for decay: %v", err)
		}
		alteredFigureInstances = append(alteredFigureInstances, &figureInstance)
	}
	var alteredFigureInstancesString string
	for _, figureInstance := range alteredFigureInstances {
		alteredFigureInstancesString += fmt.Sprintf("%s ", figureInstance.User_Email)
	}
	log.Default().Printf("Decayed %d figure instances for users %s for charge totaling %d", len(alteredFigureInstances), alteredFigureInstancesString, len(alteredFigureInstances)*10)
	rows.Close()
	return &pb.GenericStringResponse{Message: "Decayed figures"}, nil
}

func (s *server) UserWeeklyReset(ctx context.Context, in *pb.User) (*pb.GenericStringResponse, error) {
	fmt.Println("Applying User Weekly Reset to User: ", in.Email)
	rows, err := s.db.Query("CALL sp_userResetSingle(?)", in.Email)
	if err != nil {
		log.Fatalf("could not decay users: %v", err)
		return nil, fmt.Errorf("could not decay users: %v", err)
	}
	rows.Close()
	return &pb.GenericStringResponse{Message: "Decayed Users"}, nil
}

func ServerInitiatedFigureDecay(db *sql.DB) error {
	fmt.Println("Applying Figure Charge Decay")
	rows, err := db.Query("CALL sp_figureDecay()")
	if err != nil {
		log.Fatalf("could not decay figures: %v", err)
		return fmt.Errorf("could not decay figures: %v", err)
	}
	var alteredFigureInstances []*pb.FigureInstance
	for rows.Next() {
		var figureInstance pb.FigureInstance
		err := rows.Scan(&figureInstance.Charge, &figureInstance.User_Email, &figureInstance.Figure_Name, &figureInstance.Ev_Points, &figureInstance.Ev_Level)
		if err != nil {
			log.Fatalf("could not scan figure instance: %v", err)
			return fmt.Errorf("could not iterate figures for decay: %v", err)
		}
		alteredFigureInstances = append(alteredFigureInstances, &figureInstance)
	}
	var alteredFigureInstancesString string
	for _, figureInstance := range alteredFigureInstances {
		alteredFigureInstancesString += fmt.Sprintf("%s ", figureInstance.User_Email)
	}
	log.Default().Printf("Decayed %d figure instances for users %s for charge totaling %d", len(alteredFigureInstances), alteredFigureInstancesString, len(alteredFigureInstances)*10)
	rows.Close()
	return nil
}

func ServerIntiaitedUserDecay(db *sql.DB) error {
	fmt.Println("Applying User Weekly Reset")
	rows, err := db.Query("CALL sp_userReset()")
	if err != nil {
		log.Fatalf("could not decay users: %v", err)
		return fmt.Errorf("could not decay users: %v", err)
	}
	var alteredUsers []*pb.User
	for rows.Next() {
		var user pb.User
		err := rows.Scan(&user.Email)
		if err != nil {
			log.Fatalf("could not scan user: %v", err)
			return fmt.Errorf("could not iterate users for decay: %v", err)
		}
		alteredUsers = append(alteredUsers, &user)
	}
	var alteredUsersString string
	for _, user := range alteredUsers {
		alteredUsersString += fmt.Sprintf("%s ", user.Email)
	}
	log.Default().Printf("Decayed %d users: %s", len(alteredUsers), alteredUsersString)
	rows.Close()
	return nil
}

// const resetTimer = 24 * time.Hour
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

	// resetticker := time.NewTicker(resetTimer)

	// go func() {
	// 	for {
	// 		select {
	// 		case <-resetticker.C:
	// 			err = ServerInitiatedFigureDecay(db)
	// 			if err != nil {
	// 				log.Fatalf("could not decay figures: %v", err)
	// 			}
	// 		}
	// 	}
	// }()

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
