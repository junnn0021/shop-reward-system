const AWS = require('aws-sdk');
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider();
const userPoolId = process.env.USERPOOL;

exports.handler = async (event) => {
  const name = event.body.name;
  console.log(name)
  const params = {
    UserPoolId: userPoolId,
    Filter: `name = "${name}"`
  };

  const result = await cognito.initiateAuth({
    AuthFlow: 'USER_PASSWORD_AUTH',
    ClientId: clientId,
    AuthParameters: {
      name: requestBody.username,
      PASSWORD: requestBody.password
    }
  }).promise();

  try {
    const data = await cognitoIdentityServiceProvider.listUsers(params).promise();
    console.log(data)
    if (data.Users.length > 0) {
      return {
        statusCode: 200,
        body: "인증에 성공하셨습니다." + JSON.stringify(result.AuthenticationResult.AccessToken)
      };
    } else {
      return {
        statusCode: 404,
        body: 'Name does not exist in Cognito User Pool'
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