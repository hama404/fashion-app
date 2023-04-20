package controller

import (
    "net/http"

    "mymodule/model"
    "mymodule/database"

    "github.com/gin-gonic/gin"
)

var tag = model.Tag{}

func GetTags(c *gin.Context) {
    // connect database
    db := database.Connect()
	defer db.Close()

    // db query
    lists, err := tag.SelectAll(db)
    if err != nil {
        responce := gin.H{"message": err.Error()}
        c.IndentedJSON(http.StatusInternalServerError, responce)
        return
    }

    // responce
    c.IndentedJSON(http.StatusOK, lists)
}
