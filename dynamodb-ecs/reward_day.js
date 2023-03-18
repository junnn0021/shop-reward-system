const fastify = require('fastify')();
const AWS = require('aws-sdk');
AWS.config.update({
    region: 'ap-northeast-2',
    });
const docClient = new AWS.DynamoDB.DocumentClient();

module.exports = async function (fastify, options) {

fastify.get('/reward_day', async (request, reply) => {
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
      const user = data.Items[0];
        console.log(user)
      const rewardsParams = {
        TableName: 'reward',
        FilterExpression: 'attendance_date = :attendance_date',
        ExpressionAttributeValues: {
          ':attendance_date': (user.attendance_count)
        }
      };

      const rewardsData = await docClient.scan(rewardsParams).promise();
      const reward = rewardsData.Items.find(item => item.attendance_date === user.attendance_count);
      const rewardName = reward ? reward.reward_name : 'no reward found';

      const nextrewardsParams = {
        TableName: 'reward',
        FilterExpression: 'attendance_date = :attendance_date',
        ExpressionAttributeValues: {
          ':attendance_date': (user.attendance_count+1)
        }
      };

      const nextrewardsData = await docClient.scan(nextrewardsParams).promise();
      const nextreward = nextrewardsData.Items.find(item => item.attendance_date === user.attendance_count + 1);
      const nextrewardName = nextreward ? nextreward.reward_name : 'no reward found';


      reply.send(`${user.email}님의 출석일수는 ${user.attendance_count}일이며, 보상은 ${rewardName}입니다. 
      다음 보상은 ${nextrewardName} 입니다.`);
    } catch (error) {
      console.error(error);
      reply.code(500).send('Internal Server Error');
    }
  });
}