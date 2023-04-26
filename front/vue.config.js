const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    proxy: {
      "/api/": {
        target: "https://fashion-app-z2zcp4g4ca-uw.a.run.app",
      }
    }
  }
})
