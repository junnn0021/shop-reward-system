const mysql = require('mysql2/promise');
require('dotenv').config()

const {
  HOSTNAME: host,
  USERNAME: user,
  PASSWORD: password,
  DATABASE: database
} = process.env;

const connectDb = async (req, res, next) => {
    try {
      req.conn = await mysql.createConnection({ host, user, password, database })
      next()
    }
    catch(e) {
      console.log(e)
      res.status(500).json({ message: "데이터베이스 연결 오류" })
    }
  }