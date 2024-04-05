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
	"github.com/golang/protobuf/ptypes/empty"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

const (
	DefaultFigure       = "none"
	DefaultCurrency     = 0
	DefaultWeekComplete = 0
	DefaultWeekGoal     = 0
	DefaultCurWorkout   = "2001-09-04 19:21:00"
	DefaultMinTime      = 0
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

	s.db.QueryRowContext(ctx, "INSERT INTO users (email, cur_figure, name, currency, week_complete, week_goal, cur_workout, workout_min_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", in.Email, DefaultFigure, in.Name, DefaultCurrency, DefaultWeekComplete, DefaultWeekGoal, DefaultCurWorkout, DefaultMinTime)

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

	var workout pb.Workout

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

// INSTANCES //
func (s *server) GetFigureInstance(ctx context.Context, in *pb.FigureInstance) (*pb.FigureInstance, error) {
	var figureInstance pb.FigureInstance

	err := s.db.QueryRowContext(ctx, "SELECT Figure_Id, Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge FROM figure_instances WHERE User_Email = ? AND Figure_Name = ?", in.User_Email, in.Figure_Name).Scan(&figureInstance.Figure_Id, &figureInstance.Figure_Name, &figureInstance.User_Email, &figureInstance.Cur_Skin, &figureInstance.Ev_Points, &figureInstance.Charge)
	if err != nil {
		return nil, fmt.Errorf("could not get figureInstance: %v", err)
	}

	return &figureInstance, nil
}

func (s *server) UpdateFigureInstance(ctx context.Context, in *pb.FigureInstance) (*pb.FigureInstance, error) {
	var existingFigureInstance pb.FigureInstance

	err := s.db.QueryRowContext(ctx, "SELECT Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge FROM figure_instances WHERE Figure_Id = ?", in.Figure_Id).Scan(&existingFigureInstance.Figure_Name, &existingFigureInstance.User_Email, &existingFigureInstance.Cur_Skin, &existingFigureInstance.Ev_Points, &existingFigureInstance.Charge)
	if err != nil {
		return nil, fmt.Errorf("could not get existing figureInstance: %v", err)
	}

	if in.Figure_Name != "" && in.Figure_Name != existingFigureInstance.Figure_Name {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Figure_Name = ? WHERE Figure_Id = ?", in.Figure_Name, in.Figure_Id)
		if err != nil {
			return nil, fmt.Errorf("could not update Figure_Name: %v", err)
		}
	}

	if in.User_Email != "" && in.User_Email != existingFigureInstance.User_Email {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET User_Email = ? WHERE Figure_Id = ?", in.User_Email, in.Figure_Id)
		if err != nil {
			return nil, fmt.Errorf("could not update User_Email: %v", err)
		}
	}

	if in.Cur_Skin != "" && in.Cur_Skin != existingFigureInstance.Cur_Skin {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Cur_Skin = ? WHERE Figure_Id = ?", in.Cur_Skin, in.Figure_Id)
		if err != nil {
			return nil, fmt.Errorf("could not update Cur_Skin: %v", err)
		}
	}

	if in.Ev_Points != 0 && in.Ev_Points != existingFigureInstance.Ev_Points {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Ev_Points = ? WHERE Figure_Id = ?", in.Ev_Points, in.Figure_Id)
		if err != nil {
			return nil, fmt.Errorf("could not update Ev_Points: %v", err)
		}
	}

	if in.Charge != 0 && in.Charge != existingFigureInstance.Charge {
		_, err = s.db.ExecContext(ctx, "UPDATE figure_instances SET Charge = ? WHERE Figure_Id = ?", in.Charge, in.Figure_Id)
		if err != nil {
			return nil, fmt.Errorf("could not update Charge: %v", err)
		}
	}

	return in, nil
}

func (s *server) CreateFigureInstance(ctx context.Context, in *pb.FigureInstance) (*pb.FigureInstance, error) {
	_, err := s.db.ExecContext(ctx, "INSERT INTO figure_instances (Figure_Id, Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge) VALUES (?, ?, ?, ?, ?, ?)", in.Figure_Id, in.Figure_Name, in.User_Email, in.Cur_Skin, in.Ev_Points, in.Charge)
	if err != nil {
		return nil, fmt.Errorf("could not create figureInstance: %v", err)
	}

	return in, nil
}

func (s *server) DeleteFigureInstance(ctx context.Context, in *pb.FigureInstance) (*pb.FigureInstance, error) {
	var figureInstance pb.FigureInstance

	err := s.db.QueryRowContext(ctx, "SELECT Figure_Id, Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge FROM figureInstances WHERE Figure_Id = ?", in.Figure_Id).Scan(&figureInstance.Figure_Id, &figureInstance.Figure_Name, &figureInstance.User_Email, &figureInstance.Cur_Skin, &figureInstance.Ev_Points, &figureInstance.Charge)
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

	rows, err := s.db.QueryContext(ctx, "SELECT Figure_Id, Figure_Name, User_Email, Cur_Skin, Ev_Points, Charge FROM figure_instances WHERE User_Email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not get figureInstances: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var figureInstance pb.FigureInstance
		err := rows.Scan(&figureInstance.Figure_Id, &figureInstance.Figure_Name, &figureInstance.User_Email, &figureInstance.Cur_Skin, &figureInstance.Ev_Points, &figureInstance.Charge)
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

func (s *server) GetFigures(ctx context.Context, in *empty.Empty) (*pb.MultiFigure, error) {
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

	err := s.db.QueryRowContext(ctx, "SELECT Skin_Id, Skin_Name, User_Email FROM skin_instances WHERE Skin_Id = ?", in.Skin_Id).Scan(&skinstance.Skin_Id, &skinstance.Skin_Name, &skinstance.User_Email)
	if err != nil {
		return nil, fmt.Errorf("could not get skin instance: %v", err)
	}

	return &skinstance, nil
}

func (s *server) UpdateSkinInstance(ctx context.Context, in *pb.SkinInstance) (*pb.SkinInstance, error) {
	_, err := s.db.ExecContext(ctx, "UPDATE skin_instances SET Skin_Name = ?, User_Email = ? WHERE Skin_Id = ?", in.Skin_Name, in.User_Email, in.Skin_Id)
	if err != nil {
		return nil, fmt.Errorf("could not update skin instance: %v", err)
	}

	return in, nil
}

func (s *server) CreateSkinInstance(ctx context.Context, in *pb.SkinInstance) (*pb.SkinInstance, error) {
	_, err := s.db.ExecContext(ctx, "INSERT INTO skin_instances (Skin_Name, User_Email) VALUES (?, ?)", in.Skin_Name, in.User_Email)
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

	rows, err := s.db.QueryContext(ctx, "SELECT Skin_Id, Skin_Name, User_Email FROM skin_instances WHERE User_Email = ?", in.Email)
	if err != nil {
		return nil, fmt.Errorf("could not get skin instances: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var skinstance pb.SkinInstance
		err := rows.Scan(&skinstance.Skin_Id, &skinstance.Skin_Name, &skinstance.User_Email)
		if err != nil {
			return nil, fmt.Errorf("could not scan skin instance: %v", err)
		}
		skinInstances.SkinInstances = append(skinInstances.SkinInstances, &skinstance)

		// Log output for each skin instance
		log.Printf("Retrieved skin instance: Skin_Id=%s, Skin_Name=%s, User_Email=%s", skinstance.Skin_Id, skinstance.Skin_Name, skinstance.User_Email)
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

func (s *server) GetSkins(ctx context.Context, in *empty.Empty) (*pb.MultiSkin, error) {
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
