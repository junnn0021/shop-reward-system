const mysql = require('mysql2/promise');
const AWS = require('aws-sdk');
const sqs = new AWS.SQS();

exports.handler = async (event) => {
  const connection = await mysql.createConnection({
    host: process.env.rds_host,
    user: process.env.rds_user,
    password: process.env.rds_password,
    database: process.env.rds_db_name
  });
  
  const [rows] = await connection.execute('SELECT * FROM Purchasedetails WHERE Customer_Email = ?', [event.email]);
  console.log(rows)

  const params = {
    MessageBody: JSON.stringify(rows),
    QueueUrl: process.env.SQS_QUEUE_URL
  };

  if (rows.length > 0) {
    const result = await sqs.sendMessage(params).promise();
    console.log(result);
    return {result:'구매내역 인증에 성공하셨습니다.'};
  } else {
    return {result:'구매내역 인증에 실패하셨습니다.'};
  }
};
