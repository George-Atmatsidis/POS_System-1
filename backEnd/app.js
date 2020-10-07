const { json } = require("express");
const express = require("express");
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send("Hello World");
    console.log("Hello on server");
});

app.listen(port, () =>{
    console.log("Listening on port 3000\n")
});