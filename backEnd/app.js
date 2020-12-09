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

app.get('/accountsRecievable', (req, res) => {
    console.log("GET request on '/accountsRecievable'\n");
    res.json([
        {AccountNumber:"001", CompanyName:"Redstone", AmountOwed:1200.23, DateDue:"10/05/2020"},
        {AccountNumber: "002", CompanyName: "Gillis Inc.", AmountOwed:500.12, DateDue: "10/10/2020"},
        {AccountNumber: "003", CompanyName: "Powers Trucking", AmountOwed:150.00, DateDue: "10/20/2020"}
    ]);
});

app.put('/accountsRecievable/paid', (req, res) => {
    console.log("PUT request sent on '/accountsRecievable/paid'\n");
    console.log(req.body.AccountNumber);
    console.log(req.body.AmountPaid)
    res.sendStatus(200);
});

app.post('/register', (req, res) => {
    console.log(req.body.name);
    res.sendStatus(200);
});

app.listen(port, () =>{
    console.log("Listening on port 3000\n")
});