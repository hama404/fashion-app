package controller

import (
    // "log"
    "net/http"
    "strconv"

    "mymodule/model"
    "mymodule/database"

    "github.com/gin-gonic/gin"
)

// get all items
func GetItems(c *gin.Context) {
    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    lists, err := model.SelectAll(db)
    if err != nil {
        responce := gin.H{"message": err.Error()}
        c.IndentedJSON(http.StatusInternalServerError, responce)
        return
    }

    // responce
    c.Header("Access-Control-Allow-Origin", "*")
    c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
    c.Header("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
    c.IndentedJSON(http.StatusOK, lists)
}

// post new item
func PostItems(c *gin.Context) {
    new := model.BookmarkInput{}
    c.BindJSON(&new)

    // validation

    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    insertId, err := model.Insert(db, new)
    if err != nil {
        responce := gin.H{"message": err.Error()}
        c.IndentedJSON(http.StatusInternalServerError, responce)
        return
    }
    list, err := model.SelectById(db, insertId)

    // responce
    c.Header("Access-Control-Allow-Origin", "*")
    c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
    c.Header("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
    c.IndentedJSON(http.StatusCreated, list)
}

// get detail
func GetItemByID(c *gin.Context) {
    id, err := strconv.Atoi(c.Param("id"))
    if err != nil {
        responce := gin.H{"message": "id must be integer!"}
        c.IndentedJSON(http.StatusBadRequest, responce)
        return
    }

    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    list, err := model.SelectById(db, id)
    if err != nil {
        responce := gin.H{"message": "item not found"}
        c.IndentedJSON(http.StatusNotFound, responce)
        return
    }

    // responce
    c.IndentedJSON(http.StatusOK, list)
}

// update detail
func PostItemByID(c *gin.Context) {
    id, err := strconv.Atoi(c.Param("id"))
    if err != nil {
        responce := gin.H{"message": "id must be integer!"}
        c.IndentedJSON(http.StatusBadRequest, responce)
        return
    }
    input := model.BookmarkInput{}
    c.BindJSON(&input)

    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    err = model.Update(db,id,input)
    if err != nil {
        responce := gin.H{"message": err.Error()}
        c.IndentedJSON(http.StatusNotFound, responce)
        return
    }
    list, err := model.SelectById(db, id)

    // responce
    c.IndentedJSON(http.StatusCreated, list)
}

// delete item
func DeleteItemByID(c *gin.Context) {
    id, err := strconv.Atoi(c.Param("id"))
    if err != nil {
        responce := gin.H{"message": "id must be integer!"}
        c.IndentedJSON(http.StatusBadRequest, responce)
        return
    }

    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    err = model.Delete(db,id)
    if err != nil {
        responce := gin.H{"message": err.Error()}
        c.IndentedJSON(http.StatusNotFound, responce)
        return
    }

    // responce
    responce := gin.H{"delete id": id}
    c.IndentedJSON(http.StatusOK, responce)
}

// search item
func SearchItem(c *gin.Context) {
    // q = title
    q := c.Query("q")

    // connect database
    db := database.Connect()
    defer db.Close()

    // db query
    lists, err := model.Search(db,q)
    if err != nil {
        responce := gin.H{"message": err.Error()}
        c.IndentedJSON(http.StatusInternalServerError, responce)
        return
    }

    // responce
    c.IndentedJSON(http.StatusCreated, lists)
}
