const AWS = require('aws-sdk');
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider();
const userPoolId = process.env.USERPOOL;
const mysql = require('mysql2/promise');

exports.auth = async (event) => {
  const email = event.body.email;
  console.log(email);
  
  const userPoolParams = {
    UserPoolId: userPoolId,
    Filter: `email = "${email}"`
  };
  
  const connectionParams = {
    host: process.env.rds_host,
    user: process.env.rds_user,
    password: process.env.rds_password,
    database: process.env.rds_db_name
  };
  
  try {
    const userPoolData = await cognitoIdentityServiceProvider.listUsers(userPoolParams).promise();
    console.log(userPoolData);
    if (userPoolData.Users.length > 0) {
      const connection = await mysql.createConnection(connectionParams);
      const [rows] = await connection.execute('SELECT * FROM Purchasedetails WHERE Customer_Email = ?', [email]);
      console.log(rows);
      if (rows.length > 0) {
        return {
          statusCode: 200,
          body: JSON.stringify('이메일 및 구매내역 인증에 성공하셨습니다.')
        };
      } else {
        return {
          statusCode: 404,
          body: JSON.stringify('구매내역 인증에 실패하셨습니다.')
        };
      }
    } else {
      return {
        statusCode: 404,
        body: JSON.stringify('이메일 인증에 실패하셨습니다.')
      };
    }
  } catch (err) {
    console.log(err);
    return {
      statusCode: 500,
      body: JSON.stringify({
        result: 'Internal Server Error'
      })
    };
  }
};

exports.purchase = async (event) => {
  const email = event.body.email;
  console.log(email);
  
  const userPoolParams = {
    UserPoolId: userPoolId,
    Filter: `email = "${email}"`
  };
  
  const connectionParams = {
    host: process.env.rds_host,
    user: process.env.rds_user,
    password: process.env.rds_password,
    database: process.env.rds_db_name
  };
  
  try {
    const userPoolData = await cognitoIdentityServiceProvider.listUsers(userPoolParams).promise();
    console.log(userPoolData);
    if (userPoolData.Users.length > 0) {
      const connection = await mysql.createConnection(connectionParams);
      const [rows] = await connection.execute(`
        SELECT Purchasedetails_id, Customer_Email, Purchasedetails.Product_Id, Product.Product_Name
        FROM Purchasedetails
        JOIN Product ON Purchasedetails.Product_Id = Product.Product_Id
        WHERE Customer_Email = ?
      `, [email]);
      console.log(rows);
      if (rows.length > 0) {
        const purchasedProducts = rows.map(row => ({
          purchasedDetailsId: row.Purchasedetails_id,
          customerEmail: row.Customer_Email,
          productId: row.Product_Id,
          productName: row.Product_Name
        }));
        return {
          statusCode: 200,
          body: `고객님의 구매내역은 ${JSON.stringify(purchasedProducts)} 입니다`
        };
      } else {
        return {
          statusCode: 404,
          body: JSON.stringify('구매내역 인증에 실패하셨습니다.')
        };
      }
    } else {
      return {
        statusCode: 404,
        body: JSON.stringify('이메일 인증에 실패하셨습니다.')
      };
    }
  } catch (err) {
    console.log(err);
    return {
      statusCode: 500,
      body: JSON.stringify({
        result: 'Internal Server Error'
      })
    };
  }
};