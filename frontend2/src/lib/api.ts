import axios from "axios";

// Base URL: in dev we rely on Vite proxy. In prod use env var if provided.
const instance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "/",
});

export const getBooks = async () => {
  const { data } = await instance.get("/api/books/");
  return data as Array<{
    id: string;
    name: string;
    image: string;
    price: string;
    author?: string;
    description?: string;
    countInStock?: number;
  }>;
};

export const getBookById = async (id: string) => {
  const { data } = await instance.get(`/api/books/${id}`);
  return data as {
    id: string;
    name: string;
    image: string;
    price: string;
    author?: string;
    description?: string;
    countInStock?: number;
  };
};
