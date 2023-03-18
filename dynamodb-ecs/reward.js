const fastify = require('fastify')();
const AWS = require('aws-sdk');
AWS.config.update({
    region: 'ap-northeast-2',
    });
const docClient = new AWS.DynamoDB.DocumentClient();

module.exports = async function (fastify, options) {

fastify.get('/reward', async (request, reply) => {
  const params = {
    TableName: 'reward',
    };
    console.log(params)
    
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
}