import { fromEnv } from "@aws-sdk/credential-providers";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, ScanCommand, GetCommand } from "@aws-sdk/lib-dynamodb";

import dotenv from "dotenv";
 
dotenv.config()

const getBooks = async (req, res) => {
  try {
    const client = new DynamoDBClient({
      region: process.env.AWS_REGION || process.env.AWS_DEFAULT_REGION,
    });

    const docClient = DynamoDBDocumentClient.from(client);
    const command = new ScanCommand({
      TableName: "tb_books",
    });

    const response = await docClient.send(command);

    const books = [];
    for (var i in response.Items) {
      books.push(response.Items[i]);
    }

    res.contentType = 'application/json';
    console.log(books);
    res.json(books);
  } catch (error) {
    console.error('Error fetching books from DynamoDB:', error);
    // Return mock data for development
    const mockBooks = [
      {
        id: '1',
        name: 'Libro de Ejemplo 1',
        image: '/images/img-hk-liderazgo.jpeg',
        price: '$20.00',
        author: 'Autor 1',
        description: 'Descripción del libro 1',
        countInStock: 10
      },
      {
        id: '2',
        name: 'Libro de Ejemplo 2',
        image: '/images/img-ld-inteligenciagenial.jpeg',
        price: '$25.00',
        author: 'Autor 2',
        description: 'Descripción del libro 2',
        countInStock: 5
      }
    ];
    res.json(mockBooks);
  }
  return res;
};

const getBooksById = async (req, res) => {
  try {
    const client = new DynamoDBClient({
      region: process.env.AWS_REGION || process.env.AWS_DEFAULT_REGION,
    });

    const docClient = DynamoDBDocumentClient.from(client);

    const command = new GetCommand({
      TableName: "tb_books",
      Key: {
        id: req.params.id,
      },
    });

    const response = await docClient.send(command);
    console.log(response.Item);
    res.json(response.Item);
  } catch (error) {
    console.error('Error fetching book from DynamoDB:', error);
    // Return mock data for development
    const mockBook = {
      id: req.params.id,
      name: 'Libro de Ejemplo',
      image: '/images/img-ma-meditaciones.jpeg',
      price: '$20.00',
      author: 'Autor Ejemplo',
      description: 'Descripción del libro de ejemplo',
      countInStock: 10
    };
    res.json(mockBook);
  }
  return res;
};

export { getBooksById, getBooks }