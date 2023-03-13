const fastify = require('fastify')();
const AWS = require('aws-sdk');
AWS.config.update({
    region: 'ap-northeast-2',
    });
const docClient = new AWS.DynamoDB.DocumentClient();

fastify.get('/reward_day', async (request, reply) => {
    const params = {
      TableName: 'user',
      KeyConditionExpression: 'email = :email',
      ExpressionAttributeValues: {
        ':email': 'aaa@bbb.ccc'
      }
    };
  
    try {
      const data = await docClient.query(params).promise();
      const user = data.Items[0];
  
      const rewardsParams = {
        TableName: 'reward',
        FilterExpression: 'attendance_date = :attendance_date',
        ExpressionAttributeValues: {
          ':attendance_date': user.attendance_count
        }
      };
  
      const rewardsData = await docClient.scan(rewardsParams).promise();
      const reward = rewardsData.Items.find(item => item.attendance_date === user.attendance_count);
      const rewardName = reward ? reward.reward_name : 'no reward found';
  
      const nextRewardsParams = {
        TableName: 'reward',
        FilterExpression: 'attendance_date = :attendance_date',
        ExpressionAttributeValues: {
          ':attendance_date': user.attendance_count + 1
        }
      };
  
      const nextRewardsData = await docClient.scan(nextRewardsParams).promise();
      const nextReward = nextRewardsData.Items.find(item => item.attendance_date === user.attendance_count + 1);
      const nextRewardName = nextReward ? nextReward.reward_name : 'no reward found';
  
      reply.send(`${user.email}님의 출석일수는 ${user.attendance_count}일이며, 보상은 ${rewardName}입니다. 다음 출석 시 받을 보상은 ${nextRewardName}입니다.`);
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