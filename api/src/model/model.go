package model

import (
    "log"
    "errors"
    "database/sql"
)

type Bookmark struct {
    ID  int  `json:"id"`
    URL  string  `json:"url"`
    Title string  `json:"title"`
    Description  string `json:"description"`
    Tag  string `json:"name"`
    TagID  int `json:"tag_id"`
}

type BookmarkInput struct {
    URL  string  `json:"url"`
    Title string  `json:"title"`
    Description  string `json:"description"`
    TagID  int `json:"tag_id"`
}

func SelectAll(db *sql.DB) (lists []Bookmark, err error) {
    sql := "SELECT B.id, B.url, B.title, B.description, T.name, T.id FROM Bookmarks B LEFT JOIN Tags T ON B.tag_id = T.id"
    res, _ := db.Query(sql)
    for res.Next() {
        current := Bookmark{}
        err = res.Scan(
            &current.ID,
            &current.URL,
            &current.Title,
            &current.Description,
            &current.Tag,
            &current.TagID,
        )
        if err != nil {
            log.Println(err)
            return lists, err
        }

        lists = append(lists, current)
    }
    return lists, err
}

func SelectById(db *sql.DB, id int) (list Bookmark, err error) {
    sql := "SELECT B.id, B.url, B.title, B.description, T.name, T.id FROM Bookmarks B LEFT JOIN Tags T ON B.tag_id = T.id WHERE B.id = ?"
    res := db.QueryRow(sql, id)
    err = res.Scan(
        &list.ID,
        &list.URL,
        &list.Title,
        &list.Description,
        &list.Tag,
        &list.TagID,
    )
    if err != nil {
        log.Println(err)
        return list, err
    }
    return list, err
}

func Insert(db *sql.DB, input BookmarkInput) (insertId int, err error) {
    sql := "INSERT INTO Bookmarks (url,title,description,tag_id) VALUES(?,?,?,?)"
    insert, err := db.Prepare(sql)
    if err != nil {
        log.Fatal(err)
        return insertId, err
    }
    result, err := insert.Exec(
        input.URL,
        input.Title,
        input.Description,
        input.TagID,
    )
    id, _ := result.LastInsertId()
    affected, _ := result.RowsAffected()
    insertId = int(id)

    log.Printf("log err : %v\n", err)
    log.Printf("log insert : %v\n", int(id))
    log.Printf("log update : %v\n", int(affected))

    return insertId, err
}

func Update(db *sql.DB, inputId int, input BookmarkInput) (err error) {
    sql := "UPDATE Bookmarks SET url=?,title=?,description=?,tag_id=? WHERE id=?"
    update, err := db.Prepare(sql)
    if err != nil {
        log.Fatal(err)
        return err
    }
    result, err := update.Exec(
        input.URL,
        input.Title,
        input.Description,
        input.TagID,
        inputId,
    )
    if err != nil {
        log.Fatal(err)
        return err
    }

    affected, _ := result.RowsAffected()
    if affected == 0 {
        err = errors.New("no update")
        return err
    }
    return err
}

func Delete(db *sql.DB, inputId int) (err error) {
    sql := "DELETE FROM Bookmarks WHERE id=?"
    delete, err := db.Prepare(sql)
    if err != nil {
        log.Fatal(err)
        return err
    }
    result, err := delete.Exec(inputId)
    if err != nil {
        log.Fatal(err)
        return err
    }
    affected, _ := result.RowsAffected()
    if affected == 0 {
        err = errors.New("no update")
        return err
    }
    return err
}

func Search(db *sql.DB, q string) (lists []Bookmark, err error) {
    sql := "SELECT B.id, B.url, B.title, B.description, T.name, T.id FROM Bookmarks B LEFT JOIN Tags T ON B.tag_id = T.id WHERE B.title LIKE '%"+q+"%'"
    res, err := db.Query(sql)

    log.Printf("err: %v\n", err)
    log.Printf("sql: %v\n", sql)
    log.Printf("q: %v\n", q)

    for res.Next() {
        current := Bookmark{}
        err = res.Scan(
            &current.ID,
            &current.URL,
            &current.Title,
            &current.Description,
            &current.Tag,
            &current.TagID,
        )
        log.Printf("current: %v\n", current)
        if err != nil {
            log.Println(err)
            return lists, err
        }

        lists = append(lists, current)
    }

    log.Printf("res: %v\n", res)
    log.Printf("lists: %v, err: %v\n", lists, err)
    return lists, err
}
