const AWS = require('aws-sdk');
AWS.config.logger = console;
const ses = new AWS.SES({});
const dynamodb = new AWS.DynamoDB.DocumentClient({});

exports.handler = async (event) => {
  try {
    const today = new Date().toISOString().slice(0, 10);
    const tableName = "user";
    const users = await dynamodb.scan({ TableName: tableName }).promise();
    const filteredUsers = users.Items.filter(user => user.last_attendance_count !== today);
    const emailAddresses = filteredUsers.map(user => user.email);
    console.log(emailAddresses)
    if (emailAddresses.length === 0) {
      console.log('No users to notify');
      return;
    }

    for (const email of emailAddresses) {
      try {
        const verificationStatus = await ses.getIdentityVerificationAttributes({ Identities: [email] }).promise();
        const status = verificationStatus.VerificationAttributes[email]?.VerificationStatus;
        if (status !== "Success") {
          const verifyParams = {
            EmailAddress: email
          };
          await ses.verifyEmailIdentity(verifyParams).promise();
          console.log(`Email address ${email} verified successfully`);
        }
      } catch (error) {
        console.error(`Failed to verify email address: ${email}`);
        console.error(error);
        continue;
      }

      // Send message to the verified email
      const params = {
        Source: process.env.SOURCEEMAIL,
        Destination: {
          ToAddresses: [email],
        },
        Message: {
          Subject: {
            Data: '메시지 제목',
          },
          Body: {
            Text: {
              Data: '아직까지 출석하지 않으셨습니다, 보상이 얼마 남지 않았어요!',
            },
          },
        },
      };

      try {
        const result = await ses.sendEmail(params).promise();
        console.log(`Sent email to ${email}: MessageID ${result.MessageId}`);
      } catch (error) {
        console.error(`Failed to send email to ${email}`);
        console.error(error);
      }
    }

    return 'Successfully sent emails';
  } catch (error) {
    console.error(error);
    return 'Failed to send emails';
  }
};