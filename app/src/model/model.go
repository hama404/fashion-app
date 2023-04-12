package model

import (
    "log"
    "database/sql"
)

var table = "Items"

type Item struct {
    ID     string  `json:"id"`
    Title  string  `json:"title"`
    Artist string  `json:"artist"`
    Price  float64 `json:"price"`
}

func SelectAllItems(db *sql.DB) (items []Item) {

    res, _ := db.Query("SELECT *  FROM " + table)
    for res.Next() {
        current_item := Item{}
        err := res.Scan(
            &current_item.ID, &current_item.Title, &current_item.Artist, &current_item.Price,
        )
        if err != nil {
            log.Println(err)
        }

        items = append(items, current_item)
    }
    return items
}

func SelectItemById(db *sql.DB, id string) (item Item) {

    res, _ := db.Query("SELECT *  FROM " + table + " WHERE id = " + id)
    for res.Next() {
        err := res.Scan(
            &item.ID, &item.Title, &item.Artist, &item.Price,
        )
        if err != nil {
            log.Println(err)
        }
    }

    return item
}

func InsertItem(db *sql.DB, item Item) (newItem Item) {

    insert, err := db.Prepare("INSERT INTO " + table + "(id,title,artist,price) VALUES(?,?,?,?)")
    if err != nil {
        log.Fatal(err)
    }
    insert.Exec(item.ID, item.Title, item.Artist, item.Price)
    newItem = item

    return newItem
}

func UpdateItem(db *sql.DB, id string, item Item) (newItem Item) {

    update, err := db.Prepare("UPDATE " + table + " SET title=?,artist=?,price=? WHERE id=?")
    if err != nil {
        log.Fatal(err)
    }
    update.Exec(item.Title, item.Artist, item.Price, id)
    newItem = item

    return newItem
}

func DeleteItem(db *sql.DB, id string) (deleteId string) {

    delete, err := db.Prepare("DELETE FROM " + table + " WHERE id=?")
    if err != nil {
        log.Fatal(err)
    }
    delete.Exec(id)
    deleteId = id

    return deleteId
}

func SearchItem(db *sql.DB, q string) (items []Item) {

    res, _ := db.Query("SELECT *  FROM " + table + " WHERE title LIKE '%" + q + "%'")
    for res.Next() {
        current_item := Item{}
        err := res.Scan(
            &current_item.ID, &current_item.Title, &current_item.Artist, &current_item.Price,
        )
        if err != nil {
            log.Println(err)
        }

        items = append(items, current_item)
    }
    return items
}