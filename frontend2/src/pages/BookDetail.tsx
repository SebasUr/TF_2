import React, { useEffect, useState } from 'react';
import { useParams, Link, Navigate } from 'react-router-dom';
import { ArrowLeft, Package, User } from 'lucide-react';
import { getBookById } from '@/lib/api';

const BookDetail = () => {
  const { id } = useParams<{ id: string }>();
  const [book, setBook] = useState<any | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      if (!id) return;
      try {
        const data = await getBookById(id);
        setBook(data);
      } catch (e) {
        setBook(null);
      } finally {
        setLoading(false);
      }
    })();
  }, [id]);

  if (!loading && !book) {
    return <Navigate to="/not-found" replace />;
  }

  const isInStock = (book?.countInStock ?? 0) > 0;

  return (
    <div className="min-h-screen py-8">
      {/* Back button */}
      <div className="mb-8">
        <Link to="/" className="inline-flex items-center space-x-2 px-3 py-2 border border-border rounded-md hover:bg-accent">
          <ArrowLeft className="h-4 w-4" />
          <span>Volver al Catálogo</span>
        </Link>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
        {/* Book Image */}
        <div className="space-y-4">
          <div className="aspect-[3/4] overflow-hidden rounded-lg shadow-book">
            {!loading && book && (
              <img
                src={book.image}
                alt={`Portada de ${book.name}`}
                className="w-full h-full object-cover"
              />
            )}
          </div>
        </div>

        {/* Book Details */}
        <div className="space-y-6">
          {/* Title and Author */}
          <div>
            <h1 className="font-sans text-3xl md:text-4xl font-bold text-foreground mb-2">
              {loading ? 'Cargando...' : book?.name}
            </h1>
            <div className="flex items-center space-x-2 text-muted-foreground mb-4">
              <User className="h-4 w-4" />
              <span className="text-lg">por {loading ? '...' : book?.author}</span>
            </div>
          </div>

          {/* Price and Stock */}
          <div className="space-y-4">
            <div className="flex items-center space-x-4">
              <span className="text-3xl font-bold text-primary">
                {loading ? '...' : book?.price}
              </span>
              <span className={`inline-flex items-center space-x-1 text-xs px-2 py-1 rounded ${isInStock ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                <Package className="h-3 w-3" />
                <span>
                  {isInStock 
                    ? `${book?.countInStock ?? 0} disponibles` 
                    : 'Agotado'}
                </span>
              </span>
            </div>
          </div>

          {/* Description */}
          <div className="space-y-3">
            <h3 className="text-lg font-semibold">Descripción</h3>
            <p className="text-muted-foreground leading-relaxed">
              {loading ? '...' : book?.description}
            </p>
          </div>

          {/* Action Buttons */}
          <div className="space-y-3 pt-6">
            <button 
              className="w-full px-4 py-3 rounded-md text-white bg-primary disabled:opacity-60" 
              disabled={!isInStock}
            >
              {isInStock ? 'Añadir al Carrito' : 'No Disponible'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default BookDetail;