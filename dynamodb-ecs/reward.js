const fastify = require('fastify')();
const AWS = require('aws-sdk');
AWS.config.update({
    region: 'ap-northeast-2',
    });
const docClient = new AWS.DynamoDB.DocumentClient();

fastify.get('/reward', async (request, reply) => {
  const params = {
    TableName: 'reward',
    };
    
try {
  const data = await docClient.scan(params).promise();
    reply
    .code(200)
    .header('Content-type', 'application/json')
    .send(data.Items);
    } catch (error) {
    console.error(error);
    reply.code(500).send('Internal Server Error');
    }
});


fastify.listen({
    port: 3000,
    host: '0.0.0.0'
  }, (err, address) => {
    if (err) {
      console.error(err)
      process.exit(1)
    }
    console.log(`Server listening on ${address}`)
  })