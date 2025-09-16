import { BookOpen } from 'lucide-react';

const Footer = () => {
  return (
    <footer className="bg-primary text-primary-foreground mt-auto">
      <div className="container mx-auto px-4 py-8">
        <div className="flex flex-col md:flex-row items-center justify-between">
          <div className="flex items-center space-x-2 mb-4 md:mb-0">
            <BookOpen className="h-6 w-6" />
            <span className="font-sans text-lg font-semibold">Biblioteca</span>
          </div>
          
          <div className="text-center md:text-right">
            <p className="text-sm">
              © 2024 Biblioteca. Todos los derechos reservados.
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;