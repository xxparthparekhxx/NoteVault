const AWS = require("aws-sdk");
const express = require("express");
const serverless = require("serverless-http");
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const app = express();

const USERS_TABLE = process.env.USERS_TABLE;
const ACCESS_KEY = process.env.JWT_ACCESS_KEY;
const REFRESH_KEY = process.env.JWT_REFRESH_KEY;

const dynamoDbClient = new AWS.DynamoDB.DocumentClient();

app.use(express.json());


app.get('/refresh/:token',async function (req,res){
  try {
    var decoded = jwt.verify(req.params.token, REFRESH_KEY);
    return res.json({
      "AccessToken":jwt.sign({userEmail:decoded.userEmail,exp: Math.floor(Date.now() / 1000) + (60 * 60),},ACCESS_KEY),
      "RefreshToken":jwt.sign({userEmail:decoded.userEmail,exp: Math.floor(Date.now() / 1000) + (((60 * 60) * 24)* 7),},REFRESH_KEY)
    })
  } catch(err) {
    return res.status(500).json({ message:err});
  }
})


app.post("/users/validate", async function (req, res) {
  const { userId,password }= req.body;
  
  const params = {
    TableName: USERS_TABLE,
    Key: {
      userId: userId,
    },
  };

  try {
    const { Item } = await dynamoDbClient.get(params).promise();
    if (Item) {      
      //check password validity
      const validpassword = await bcrypt.compare(password, Item.password);
      if(validpassword){
        return res.json({
          "AccessToken":jwt.sign({userEmail:Item.userId,exp: Math.floor(Date.now() / 1000) + (60 * 60),},ACCESS_KEY),
          "RefreshToken":jwt.sign({userEmail:Item.userId,exp: Math.floor(Date.now() / 1000) + (((60 * 60) * 24)* 7),},REFRESH_KEY)
        })
      }
    } else {
      return res
        .status(404)
        .json({ error: 'Could not find user with provided "userId"' });
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Could not retreive user" });
  }
});



app.post("/users/create", async function (req, res) {
  const { userId, password } = req.body;
  if (typeof userId !== "string") {
    return res.status(400).json({ error: '"userId" must be a string' });
  } else if (typeof password !== "string") {
    return res.status(400).json({ error: '"name" must be a string' });
  }
  const isUserInDB  = {
    TableName: USERS_TABLE,
    Key: {
      userId: userId,
    },
  };
  let previousDetails;
  try {
    const {Item} = await dynamoDbClient.get(isUserInDB).promise();
    previousDetails = Item; 
  } catch (error) {}
  if(previousDetails){
      return res.status(400).json({"message":"user Already exists"})
  }
  
  const passwordHash = await bcrypt.hash(password,12)

  const params = {
    TableName: USERS_TABLE,
    Item: {
      userId: userId,
      password: passwordHash,
    },
  };

  try {
    await dynamoDbClient.put(params).promise();
    return res.json({ message: "user created successfully" });
    
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Could not create user" });
    
  }
});

app.use((req, res, next) => {
  return res.status(404).json({
    error: "Not Found",
  });
});


module.exports.handler = serverless(app);
