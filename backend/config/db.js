import { DynamoDBClient } from "@aws-sdk/client-dynamodb";


const connectDB = () => {
  const client = new DynamoDBClient({
    region: process.env.AWS_REGION || process.env.AWS_DEFAULT_REGION,
    // Use AWS SDK default credential provider chain (IMDS, env, profile)
  });

  console.log('BookStore is connected to Dynamo'.yellow);

  return client;
}

export default connectDB;