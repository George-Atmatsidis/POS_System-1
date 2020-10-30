const { json } = require("express");
const express = require("express");
const app = express();
const port = 3000;

app.use(express.json())

app.get('/', (req, res) => {
    console.log(req.body.username);
    console.log(req.body.password);
    console.log(req.body.status);
    res.send({ "username": req.body.username,
        "role": "admin",
        "status": "authorized"})
});

app.put('/', (req, res) => {
    console.log(req.body.name);
    res.send("Recieved")
});

app.listen(port, () =>{
    console.log("Listening on port 3000\n")
});