import React, { useEffect, useState } from 'react';
import BookCard from '@/components/BookCard';
import { Search } from 'lucide-react';
import { getBooks } from '@/lib/api';

const Home = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [books, setBooks] = useState<Array<any>>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      try {
        const data = await getBooks();
        setBooks(data);
      } finally {
        setLoading(false);
      }
    })();
  }, []);

  const filteredBooks = books.filter(book =>
    book.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    book.author.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative h-96 overflow-hidden rounded-lg mb-12">
        <div 
          className="absolute inset-0 bg-cover bg-center"
        >
          <div className="absolute inset-0 bg-gradient-primary opacity-80"></div>
        </div>
        
        <div className="relative z-10 h-full flex items-center justify-center text-center text-white px-4">
          <div className="max-w-2xl">
            <h1 className="font-sans text-4xl md:text-6xl font-bold mb-4">
              Biblioteca
            </h1>
            <p className="text-lg md:text-xl opacity-90 mb-8">
              Descubre tu próxima lectura favorita en nuestra cuidada selección de libros
            </p>
            <a href="#catalogo" className="inline-block bg-primary text-primary-foreground rounded-md text-lg px-8 py-3">
              Explorar Catálogo
            </a>
          </div>
        </div>
      </section>

      {/* Search Section */}
      <section className="mb-8">
        <div className="relative max-w-md mx-auto">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-5 w-5" />
          <input
            type="text"
            placeholder="Buscar libros o autores..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2 rounded-md bg-card border border-border focus:outline-none focus:border-primary transition-colors duration-300"
          />
        </div>
      </section>

      {/* Books Grid */}
      <section id="catalogo">
        <div className="flex items-center justify-between mb-8">
          <h2 className="font-sans text-2xl md:text-3xl font-semibold text-foreground">
            {searchTerm ? `Resultados para "${searchTerm}"` : 'Nuestro Catálogo'}
          </h2>
          {!loading && (
            <span className="text-muted-foreground">
              {filteredBooks.length} {filteredBooks.length === 1 ? 'libro' : 'libros'}
            </span>
          )}
        </div>

        {loading ? (
          <div className="text-center py-12 text-muted-foreground">Cargando...</div>
        ) : filteredBooks.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {filteredBooks.map((book) => (
              <div key={book.id}>
                <BookCard book={book} />
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center py-12">
            <p className="text-muted-foreground text-lg">
              No se encontraron libros que coincidan con tu búsqueda.
            </p>
            <button 
              className="mt-4 px-4 py-2 border border-border rounded-md hover:bg-accent"
              onClick={() => setSearchTerm('')}
            >
              Ver todos los libros
            </button>
          </div>
        )}
      </section>
    </div>
  );
};

export default Home;