const { json } = require("express");
const express = require("express");
const app = express();
const port = 3000;

app.use(express.json())

app.get('/login', (req, res) => {
    console.log(req.body.username);
    console.log(req.body.password);
    res.sendStatus(200);
});

app.post('/register', (req, res) => {
    console.log(req.body.name);
    res.sendStatus(200);
});

app.listen(port, () =>{
    console.log("Listening on port 3000\n")
});