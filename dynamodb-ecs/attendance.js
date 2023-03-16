const fastify = require('fastify')();
const AWS = require('aws-sdk');
AWS.config.update({
  region: 'ap-northeast-2',
});
const docClient = new AWS.DynamoDB.DocumentClient();

module.exports = async function (fastify, options) {

fastify.get('/', async (request, reply) => {
  const params = {
    TableName: 'user',
    KeyConditionExpression: 'email = :email',
    ExpressionAttributeValues: {
    ':email': request.query.Customer_Email
    }
  };
  console.log(params)

  try {
    const data = await docClient.query(params).promise();
    reply.send(data.Items);
  } catch (error) {
    console.error(error);
    reply.code(500).send('Internal Server Error');
  }
});

fastify.get('/compensation', async (request, reply) => {
  const email = request.query.Customer_Email;

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
  const lastAttendanceDate = (userData && userData.last_attendance_count) || '';

  if (lastAttendanceDate !== today) {
    const attendanceCount = (userData && userData.attendance_count) || 0;
    const updateParams = {
      TableName: 'user',
      Key: { email: email },
      UpdateExpression: 'SET attendance_count = :attendanceCount, last_attendance_count = :today',
      ExpressionAttributeValues: {
        ':attendanceCount': attendanceCount + 1,
        ':today': today
      },
      ReturnValues: 'UPDATED_NEW'
    };

    try {
      await docClient.update(updateParams).promise();
      reply.send(`${email}님의 출석이 완료되었습니다.`);

      const rewardTable = 'reward';
      const rewardCount = attendanceCount + 1;
      const rewardGetParams = {
        TableName: rewardTable,
        Key: { reward_number: rewardCount }
      };

      try {
        const rewardResult = await docClient.get(rewardGetParams).promise();
        if (rewardResult.Item) {
          const rewardUpdateParams = {
            TableName: rewardTable,
            Key: { reward_number: rewardCount },
            UpdateExpression: 'SET reward_count = :rewardCount',
            ExpressionAttributeValues: {
              ':rewardCount': rewardResult.Item.reward_count - 1
            },
            ReturnValues: 'UPDATED_NEW'
          };
      
          await docClient.update(rewardUpdateParams).promise();
      
          if (rewardResult.Item.reward_count <= 25) {
            const SNS = new AWS.SNS();
            const topicArn = process.env.TOPICARN;
            const message = `${rewardResult.Item.reward_name} 보상이 부족합니다. 현재 보유 개수: ${rewardResult.Item.reward_count-1}`;
            const params = {
              TopicArn: topicArn,
              Message: message
            };
            await SNS.publish(params).promise();
          }
      
          // Check if user is eligible for compensation
          const compensationTable = 'compensation';
          const rewardName = rewardResult.Item.reward_name;
          const now = new Date();
          const today = now.toISOString().substr(0, 10);
          const compensationGetParams = {
            TableName: compensationTable,
            Key: { email: email }
          };
          
          try {
            const compensationResult = await docClient.get(compensationGetParams).promise();
            if (compensationResult.Item && compensationResult.Item.attendance_date === today) {
              reply.send(`${email}님은 오늘 이미 출석하셨습니다.`);
            } else {
              const attendanceSetParams = {
                TableName: compensationTable,
                Key: { email: email },
                UpdateExpression: 'ADD reward_name :r SET attendance_date = :a',
                ExpressionAttributeValues: {
                  ':r': docClient.createSet([rewardName]),
                  ':a': today
                },
                ReturnValues: 'UPDATED_NEW'
              };
              await docClient.update(attendanceSetParams).promise();
              reply.send(`${email}님의 출석 보상 ${rewardName}이(가) 지급되었습니다.`);
            }
          } catch (error) {
            console.error(error);
            reply.code(500).send('Internal Server Error');
          }
        }
      } catch (error) {
        console.error(error);
        reply.code(500).send('Internal Server Error');
      }
    } catch (error) {
      console.error(error);
      reply.code(500).send('Internal Server Error');
    }
  } else {
    reply.send(`${email}님은 오늘 이미 출석하셨습니다.`);
  }
});
}