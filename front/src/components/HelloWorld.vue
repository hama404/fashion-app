<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <p>
      create bookmark,<br>
      use backend api golang
      <a href="https://github.com/hama404/storage" target="_blank" rel="noopener">
          github strage documentation</a>.
    </p>
    <h3>New Bookmark</h3>
    <div>
      <div>
        <label>url: </label>
        <input v-model="url" placeholder="url" />
      </div>
      <div>
        <label>title: </label>
        <input v-model="title" placeholder="title" />
      </div>
      <div>
        <div><label>description</label></div>
        <textarea v-model="description" placeholder="description" ></textarea>
      </div>
      <div><select v-model="tag_id">
        <option disabled value="">tag</option>
        <option value="1">Web site</option>
        <option value="2">youtube</option>
        <option value="3">youtube playlist</option>
      </select></div>
      <div><button type="button" @click="create">Create</button></div>
    </div>
    <h3>Bookmark Lists</h3>
    <ul>
      <li v-for="list in lists" :key="list.id">
        {{ list.id }}: {{ list.url }}
      </li>
    </ul>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data(){
    return{
      url: "",
      title: "",
      description: "",
      tag_id: "",
      lists: [],
    }
  },
  mounted(){
    axios.interceptors.request.use(request => {
      console.log('Starting Request: ', request)
      return request
    })

    axios.interceptors.response.use(response => {
      console.log('Response: ', response)
      return response
    })

    const BaseURL = "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/items"
    axios.get(BaseURL)
      .then(response => {
        console.log({ response: response })
        this.lists = response.data
      })
      .catch(error => console.log({ error: error }))
  },
  methods: {
    create: function () {
      axios.interceptors.request.use(request => {
        console.log('Starting Request: ', request)
        return request
      })

      axios.interceptors.response.use(response => {
        console.log('Response: ', response)
        return response
      })

      const BaseURL = "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/items"
      const data = {
        url: this.url,
        title: this.title,
        description: this.description,
        tag_id: Number(this.tag_id),
      }
      axios.post(BaseURL,data)
        .then((res) => {
          console.log(res);
        })
        .catch((err) => {
          console.log(err);
        })
    },
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  margin: 10px 0;
}
a {
  color: #42b983;
}
</style>
