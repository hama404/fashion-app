package database

import (
    "log"
    "os"
	"database/sql"
    "github.com/go-sql-driver/mysql"
)

func init() {

    db_cfg := mysql.Config{
        DBName:    os.Getenv("MYSQL_DATABASE"),
        User:      os.Getenv("MYSQL_USER"),
        Passwd:    os.Getenv("MYSQL_PASSWORD"),
        Addr:      os.Getenv("DB_ADDRESS"),
        Net:       os.Getenv("DB_PROTOCOL"),
        AllowNativePasswords: true,
	}

    db, err := sql.Open("mysql", db_cfg.FormatDSN())
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

    err = db.Ping()
    if err != nil {
        log.Fatal(err.Error())
    } 

    log.Print("success connect database!")
}
