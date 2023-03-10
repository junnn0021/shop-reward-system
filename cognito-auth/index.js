const AWS = require('aws-sdk');
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider();
const userPoolId = process.env.USERPOOL;

exports.handler = async (event) => {
  const email = event.body.email;
  console.log(email)
  const params = {
    UserPoolId: userPoolId,
    Filter: `email = "${email}"`
  };

  try {
    const data = await cognitoIdentityServiceProvider.listUsers(params).promise();
    console.log(data)
    if (data.Users.length > 0) {
      return {
        statusCode: 200,
        body: '인증에 성공하셨습니다.'
      };
    } else {
      return {
        statusCode: 404,
        body: '인증에 실패하셨습니다.'
      };
    }
  } catch (err) {
    console.log(err);
    return {
      statusCode: 500,
      body: 'Internal Server Error'
    };
  }
};