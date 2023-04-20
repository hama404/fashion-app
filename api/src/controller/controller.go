package controller

import (
    "net/http"

    "mymodule/model"
    "mymodule/database"

    "github.com/gin-gonic/gin"
)

func GetItems(c *gin.Context) {
    // get all items
    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    items := model.SelectAllItems(db)

    // responce
    c.IndentedJSON(http.StatusOK, items)
}

func PostItems(c *gin.Context) {
    // post new item

    var item model.Item
    c.BindJSON(&item)

    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    newItem := model.InsertItem(db, item)

    // responce
    c.IndentedJSON(http.StatusCreated, newItem)
}

func GetItemByID(c *gin.Context) {
    id := c.Param("id")

    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    items := model.SelectAllItems(db)

    // responce
    for _, item := range items {
        if item.ID == id {
            c.IndentedJSON(http.StatusOK, item)
            return
        }
    }
    c.IndentedJSON(http.StatusNotFound, gin.H{"message": "item not found"})
}

func PostItemByID(c *gin.Context) {
    id := c.Param("id")

    var item model.Item
    c.BindJSON(&item)

    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    newItem := model.UpdateItem(db,id,item)

    // responce
    c.IndentedJSON(http.StatusCreated, newItem)
}

func DeleteItemByID(c *gin.Context) {
    id := c.Param("id")

    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    deleteId := model.DeleteItem(db,id)

    // responce
    c.IndentedJSON(http.StatusCreated, deleteId)
}


func SearchItem(c *gin.Context) {
    // q = title
    q := c.Query("q")

    // connect database
    db := database.Connect()
    defer db.Close()

    // db query
    searchItem := model.SearchItem(db,q)

    // responce
    c.IndentedJSON(http.StatusCreated, searchItem)
}
