package database

import (
    "log"

	"database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func init() {
    db, err := sql.Open("mysql",
		"root:password@tcp(db:3306)/mysql")
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
