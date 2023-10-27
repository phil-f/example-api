import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

const dynamo = new DynamoDBClient();
const ddocClient = DynamoDBDocumentClient.from(dynamo);

export async function handler(event) {
    const cmd = new GetCommand({
      TableName: process.env.WEATHER_TABLE_NAME,
      Key: {
        key: "weather",
      },
    });
    const data = await ddocClient.send(cmd);
    const weather = data.Item;
    
    if (!weather)
    {
      return {
        statusCode: 404,
        body: "nothing to see here."
      }  
    }

    return {
        statusCode: 200,
        body: JSON.stringify(weather)
    }
}
