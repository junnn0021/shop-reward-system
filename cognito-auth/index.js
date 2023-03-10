const AWS = require('aws-sdk');
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider();
const userPoolId = process.env.USERPOOL;
const lambda = new AWS.Lambda();

exports.handler = async (event) => {
  const email = event.body.email;
  console.log(email)
  const params = {
    UserPoolId: userPoolId,
    Filter: `email = "${email}"`
  };

  const invokeParams = {
    FunctionName: 'purchase-auth-dev-api',
    Payload: JSON.stringify({ email: email }),
  };

  try {
    const data = await cognitoIdentityServiceProvider.listUsers(params).promise();
    console.log(data)
    if (data.Users.length > 0) {
      //return {
      //  statusCode: 200,
      //  body: '인증에 성공하셨습니다.'
      //};
      const result = await lambda.invoke(invokeParams).promise();
      return result;
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