const lambdaLocal = require('lambda-local');
const AWS = require('aws-sdk-mock');
const assert = require('assert');

AWS.mock('CognitoIdentityServiceProvider', 'initiateAuth', (params, callback) => {
  if (params.AuthParameters.USERNAME === 'testuser' && params.AuthParameters.PASSWORD === 'testpassword') {
    callback(null, { AuthenticationResult: { AccessToken: 'testtoken' } });
  } else {
    callback(new Error('Invalid credentials'));
  }
});

lambdaLocal.execute({
  event: {
    body: JSON.stringify({
      username: 'testuser',
      password: 'testpassword'
    })
  },
  lambdaPath: 'index.js',
  timeoutMs: 3000,
  callback: (err, result) => {
    if (err) {
      console.error(err);
      return;
    }

    assert.strictEqual(result.statusCode, 200);
    assert.strictEqual(result.body, JSON.stringify('testtoken'));
    console.log('Test passed');
  }
});