package main

import (
    "time"

    "mymodule/controller"
    _ "mymodule/database"

    "github.com/gin-gonic/gin"
    "github.com/gin-contrib/cors"
)

func main() {
    router := gin.Default()
    // router.Use(cors.Default())
    router.Use(cors.New(cors.Config{
        AllowOrigins: []string{
            "*",
        },
        AllowMethods: []string{
            "POST",
            "GET",
            "OPTIONS",
        },
        AllowHeaders: []string{
            "Access-Control-Allow-Credentials",
            "Access-Control-Allow-Headers",
            "Content-Type",
            "Content-Length",
            "Accept-Encoding",
            "Authorization",
        },
        AllowCredentials: true,
        MaxAge: 24 * time.Hour,
    }))

    api := router.Group("api/v1")

    tags := api.Group("tags")
    tags.GET("", controller.GetTags)

    items := api.Group("items")
    items.GET("", controller.GetItems)
    items.POST("", controller.PostItems)
    items.GET("/:id", controller.GetItemByID)
    items.POST("/:id", controller.PostItemByID)
    items.DELETE("/:id", controller.DeleteItemByID)
    items.GET("/search", controller.SearchItem)

    router.Run(":8000")
}
