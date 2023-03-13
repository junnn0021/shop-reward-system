const fastify = require('fastify')();
const AWS = require('aws-sdk');
AWS.config.update({
    region: 'ap-northeast-2',
    });
const docClient = new AWS.DynamoDB.DocumentClient();

fastify.get('/', async (request, reply) => {
  const params = {
    TableName: 'user',
    KeyConditionExpression: 'email = :email',
    ExpressionAttributeValues: {
        ':email': 'aaa@bbb.ccc'
    }
    };
    
try {
  const data = await docClient.query(params).promise();
    reply.send(data.Items);
    } catch (error) {
    console.error(error);
    reply.code(500).send('Internal Server Error');
    }
});

fastify.get('/attendance', async (request, reply) => {
    const email = 'aaa@bbb.ccc';
  
    const getParams = {
      TableName: 'user',
      Key: { email: email }
    };
    let userData = null;
    try {
      const result = await docClient.get(getParams).promise();
      userData = result.Item;
    } catch (error) {
      console.error(error);
      reply.code(500).send('Internal Server Error');
      return;
    }
  
    const today = new Date().toISOString().slice(0, 10);
    const lastAttendanceDate = (userData && userData.last_attnedance_count) || '';
  
    if (lastAttendanceDate !== today) {
      const attendanceCount = (userData && userData.attendance_count) || 0;
      const updateParams = {
        TableName: 'user',
        Key: { email: email },
        UpdateExpression: 'SET attendance_count = :attendanceCount, last_attnedance_count = :today',
        ExpressionAttributeValues: {
          ':attendanceCount': attendanceCount + 1,
          ':today': today
        },
        ReturnValues: 'UPDATED_NEW'
      };
  
      try {
        await docClient.update(updateParams).promise();
        reply.send(`${email}님의 출석이 완료되었습니다.`);
      } catch (error) {
        console.error(error);
        reply.code(500).send('Internal Server Error');
      }
    } else {
      reply.send(`${email}님은 오늘 이미 출석하셨습니다.`);
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