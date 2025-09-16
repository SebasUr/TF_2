import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, BatchWriteCommand } from "@aws-sdk/lib-dynamodb";
import { fromEnv } from "@aws-sdk/credential-providers";
import dotenv from "dotenv";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const TABLE_NAME = process.env.DDB_TABLE_NAME || "tb_books";

function getClient() {
  const base = { region: process.env.AWS_REGION };
  return new DynamoDBClient({ ...base, credentials: fromEnv() });
}

function chunk(array, size) {
  const res = [];
  for (let i = 0; i < array.length; i += size) res.push(array.slice(i, i + size));
  return res;
}

async function seed() {
  const client = getClient();
  const doc = DynamoDBDocumentClient.from(client);
  const dataPath = path.join(__dirname, "seed-data.json");
  const raw = fs.readFileSync(dataPath, "utf-8");
  const items = JSON.parse(raw);

  const batches = chunk(items, 25);

  for (const batch of batches) {
    const requestItems = batch.map((item) => ({ PutRequest: { Item: item } }));
    const command = new BatchWriteCommand({
      RequestItems: {
        [TABLE_NAME]: requestItems,
      },
    });

    const resp = await doc.send(command);
    if (resp.UnprocessedItems && Object.keys(resp.UnprocessedItems).length) {
      console.warn("Unprocessed items detected, retrying once...");
      const retry = new BatchWriteCommand({ RequestItems: resp.UnprocessedItems });
      await doc.send(retry);
    }
  }

  console.log(`Seed completed for table ${TABLE_NAME}`);
}

seed().catch((e) => {
  console.error("Seeder failed:", e);
  process.exit(1);
});
