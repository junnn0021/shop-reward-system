//exports.handler = async (event) => {
// const email = event.email;
//  console.log(email);
//};

const mysql = require('mysql2/promise');

exports.handler = async (event) => {
  const connection = await mysql.createConnection({
    host: process.env.rds_host,
    user: process.env.rds_user,
    password: process.env.rds_password,
    database: process.env.rds_db_name
  });
  
  const [rows] = await connection.execute('SELECT * FROM Purchasedetails WHERE Customer_Email = ?', [event.email]);
  console.log(rows)
  if (rows.length > 0) {
    return { result: '구매내역 인증에 성공하셨습니다.' };
  } else {
    return { result: '구매내역 인증에 실패하셨습니다.' };
  }
};