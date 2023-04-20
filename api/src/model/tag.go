package model

import (
    "log"
    "database/sql"
)

type Tag struct {
    ID  int  `json:"id"`
    Name  string  `json:"name"`
}

func (tag *Tag) SelectAll(db *sql.DB) (lists []Tag, err error) {
    sql := "SELECT id, name FROM Tags"
    res, _ := db.Query(sql)
    for res.Next() {
        current := Tag{}
        err = res.Scan(
            &current.ID,
            &current.Name,
        )
        if err != nil {
            log.Println(err)
            return lists, err
        }

        lists = append(lists, current)
    }
    return lists, err
}
