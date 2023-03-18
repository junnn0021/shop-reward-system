const AWS = require('aws-sdk');
const nodemailer = require('nodemailer');
const ses = new AWS.SES({
  endpoint: process.env.ENDPOINT
  // endpoint: 'vpce-01984a4efad70611f-orh7rxhg.email-smtp.ap-northeast-2.vpce.amazonaws.com'
  // endpoint: 'vpce-01984a4efad70611f-orh7rxhg-ap-northeast-2a.email-smtp.ap-northeast-2.vpce.amazonaws.com'
});
const dynamodb = new AWS.DynamoDB.DocumentClient({
    // endpoint: 'vpce-0475e97ff8c207147-com.amazonaws.ap-northeast-2.dynamodb',
    // region: 'ap-northeast-2'
});

exports.handler = async (event) => {
  try {
    const today = new Date().toISOString().slice(0, 10);
    const tableName = "user";
    const users = await dynamodb.scan({ TableName: tableName }).promise();
    const filteredUsers = users.Items.filter(user => user.last_attendance_count !== today);
    const emailAddresses = filteredUsers.map(user => user.email);

    if (emailAddresses.length === 0) {
      console.log('No users to notify');
      return;
    }

    const params = {
      Identities: emailAddresses
    };
    console.log(params)
    const verificationStatus = await ses.getIdentityVerificationAttributes(params).promise();

    const unverifiedEmails = emailAddresses.filter(email => {
      const status = verificationStatus.VerificationAttributes[email].VerificationStatus;
      return (status !== "Success");
    });

    if (unverifiedEmails.length > 0) {
      const verifyParams = {
        EmailAddress: unverifiedEmails[0]
      };
      await ses.verifyEmailIdentity(verifyParams).promise();
      console.log(`Email address ${unverifiedEmails[0]} verified successfully`);
    }

    const emailParams = {
      Destination: {
        BccAddresses: emailAddresses
      },
      Message: {
        Body: {
          Text: {
            Data: '아직까지 출석하지 않으셨습니다, 보상이 얼마 남지 않았어요!'
          }
        },
        Subject: {
          Data: 'Last Attendance Count Not Updated'
        }
      },
      Source: process.env.SOURCEEMAIL //보내는 이메일 주소
    };

    await ses.sendEmail(emailParams).promise();
    console.log('Email sent successfully');
  } catch (error) {
    console.error('Error sending email:', error);
  }
};