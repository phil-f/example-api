import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";

const dynamo = new DynamoDBClient();
const ddocClient = DynamoDBDocumentClient.from(dynamo);

export async function handler(event) {
    const body = event.body || {};
    const data = JSON.parse(body);
    const { description } = data;

    if (!description)
    {
      return {
        statusCode: 400,
        body: "bad request - description cannot be empty."
      };
    }

    const cmd = new PutCommand({
        TableName: process.env.WEATHER_TABLE_NAME,
        Item: {
          key: "weather",
          description
        },
      });
    await ddocClient.send(cmd);
    return { statusCode: 200 };
}
