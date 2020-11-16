const express = require("express");
const app = express();
const port = 3000;

const argon2 = require("argon2");

const redis = require('redis');
const session = require('express-session');
const Knex = require("knex");
const RedisStore = require('connect-redis')(session);
const redisClient = redis.createClient();

const db = require("knex")({
    client: "pg",
    connection: {
      host: "localhost",
      user: "postgres",
      password: "",
      database: "knex-test"
    }
  });

const sess = session({
    store: new RedisStore({ 
        client: redisClient, // our redis client
        host: 'localhost',   // redis is running locally on our VM (we don't want anyone accessing it)
        port: 6379,          // 6379 is the default redis port (you don't have to set this unless you change port)
        ttl: 12 * 60 * 60,   // 12 hours
    }),
    secret: 'something secret', // Change This
    resave: false, 
    cookie: {
        httpOnly: true,
        maxAge: 12 * 60 * 60  // 12 hours
    },
    saveUninitialized: false, // set this to false so we can control when the cookie is set (i.e. when the user succesfully logs in)
});

app.use(sess);

app.use(express.json())

app.put('/login', async (req, res) => {
    const {email, password} = req.body; //add rest of data needed...
    
    //check data...
    if (!email || !password){  
        return res.sendStatus(400); //Bad Req.
    }

    //hash password
    const passwordHash = await argon2.hash(password);
    
    //Add User to DB

    //const user = {email, passwordhash,...} add default role
    // if( await database.adduser(user) ) {
    //    return res.sendStatus(201);
    //} else {
//      return res.sendStatus(409); //conflict
    //}

    // add user to db via knex?
    try {
        await Knex('user').insert(user);
        return res.sendstatus(200);  //succeeded
    } catch (err) {
        return res.sendstatus(401); //failed
    }

})

app.post('/register', async (req, res) => {
    const {name, email, password, employeeID, address, phoneNumber} = req.body; //add rest of data needed...

    //check data...
    if (!email || !password){  
        return res.sendStatus(400); //Bad Req.
    }

    const user = await database.getUser(email);

    if (user) {
        const passwordHash = user.passwordHash;

        if ( await argon2.verify(passwordHash, password) ) {
            req.session.user = {
                email: user.email,
                role: user.role,
                phoneNumber: user.phoneNumber
            };
        } else{ //passwords dont match
        return res.sendstatus(401) 
        }
    }  else { //email doesn't match
        res.sendstatus(401)
    }
    return res.sendStatus(200) //user registered
})

app.get('/inventoryManagement/partsManagement', async (req, res) => {  // DO it for all Routes asap
    res.sendStatus(501); //Not Implemented
})

app.listen(port, () =>{
    console.log("Listening on port 3000\n")
});

app.put('/inventory', async (req, res) => {
    if (!req.session.user) {
        return res.send(401); //unauth
    }

    const { partnumber, partname, quantity} = req.body;

    //if(!partnumber...)
    // return res.sendStatus(400)
})