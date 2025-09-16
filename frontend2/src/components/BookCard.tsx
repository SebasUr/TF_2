import React from 'react';
import { Link } from 'react-router-dom';

interface Book {
  id: string;
  name: string;
  price: string;
  image: string;
  author?: string;
}

interface BookCardProps {
  book: Book;
}

const BookCard = ({ book }: BookCardProps) => {
  return (
    <div className="group overflow-hidden rounded-lg border bg-card border-border hover:shadow-book transition-all duration-500 hover:-translate-y-2">
      <Link to={`/book/${book.id}`} className="block">
        <div className="aspect-[3/4] overflow-hidden">
          <img
            src={book.image}
            alt={`Portada de ${book.name}`}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
          />
        </div>
        <div className="p-4">
          <h3 className="font-sans text-lg font-semibold text-foreground group-hover:text-primary transition-colors duration-300 line-clamp-2">
            {book.name}
          </h3>
          {book.author && (
            <p className="text-sm text-muted-foreground mt-1">por {book.author}</p>
          )}
        </div>
        <div className="px-4 pb-4 pt-0">
          <div className="flex items-center justify-between w-full">
            <span className="text-xl font-bold text-primary">{book.price}</span>
            <span className="text-xs text-muted-foreground group-hover:text-secondary transition-colors duration-300">
              Ver detalles →
            </span>
          </div>
        </div>
      </Link>
    </div>
  );
};

export default BookCard;