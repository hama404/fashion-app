package controller

import (
    "net/http"
    "github.com/gin-gonic/gin"
)

type item struct {
    ID     string  `json:"id"`
    Title  string  `json:"title"`
    Artist string  `json:"artist"`
    Price  float64 `json:"price"`
}

var items = []item{
    {ID: "1", Title: "Blue Train", Artist: "John Coltrane", Price: 56.99},
    {ID: "2", Title: "Jeru", Artist: "Gerry Mulligan", Price: 17.99},
    {ID: "3", Title: "Sarah Vaughan and Clifford Brown", Artist: "Sarah Vaughan", Price: 39.99},
}

func GetItems(c *gin.Context) {
    c.IndentedJSON(http.StatusOK, items)
}

func GetItemByID(c *gin.Context) {
    id := c.Param("id")

    for _, item := range items {
        if item.ID == id {
            c.IndentedJSON(http.StatusOK, item)
            return
        }
    }
    c.IndentedJSON(http.StatusNotFound, gin.H{"message": "item not found"})
}

func PostItemByID(c *gin.Context) {
    var newItem item

    if err := c.BindJSON(&newItem); err != nil {
        return
    }

    items = append(items, newItem)
    c.IndentedJSON(http.StatusCreated, newItem)
}

func DeleteItemByID(c *gin.Context) {
    id := c.Param("id")

    for _, item := range items {
        if item.ID == id {
            c.IndentedJSON(http.StatusOK, item)
            return
        }
    }
    c.IndentedJSON(http.StatusNotFound, gin.H{"message": "item not found"})
}


func SearchItemByID(c *gin.Context) {
    q := c.Query("q")
    c.IndentedJSON(http.StatusNotFound, gin.H{"message": "search for " + q})
}
