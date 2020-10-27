const { json } = require("express");
const express = require("express");
const app = express();
const port = 3000;

app.use(express.json())

app.get('/', (req, res) => {
    res.json('{ "name": "Cade" }');
    console.log("Hello on server");
});

app.put('/', (req, res) => {
    console.log(req.body.name);
    res.send("Recieved")
});

app.listen(port, () =>{
    console.log("Listening on port 3000\n")
});