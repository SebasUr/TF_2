import { BookOpen, Heart, Leaf, Users } from 'lucide-react';

const Card = ({ children, className = "" }: { children: any; className?: string }) => (
  <div className={`rounded-lg border border-border bg-card ${className}`}>{children}</div>
);
const CardContent = ({ children, className = "" }: { children: any; className?: string }) => (
  <div className={`p-4 ${className}`}>{children}</div>
);

const About = () => {
  return (
    <div className="min-h-screen py-8">
      {/* Hero Section */}
      <section className="text-center mb-12">
        <div className="max-w-3xl mx-auto">
          <h1 className="font-sans text-4xl md:text-5xl font-bold text-foreground mb-6">
            Acerca de Biblioteca 
          </h1>
          <p className="text-lg text-muted-foreground leading-relaxed">
            Más que una tienda de libros, somos un refugio para los amantes de la literatura 
            que buscan experiencias de lectura únicas y sostenibles.
          </p>
        </div>
      </section>

      {/* Mission Section */}
      <section className="mb-12">
        <Card className="bg-gradient-hero border-none shadow-elegant">
          <CardContent className="p-8 md:p-12 text-center">
            <BookOpen className="h-12 w-12 text-primary mx-auto mb-6" />
            <h2 className="font-sans text-2xl md:text-3xl font-semibold text-foreground mb-4">
              Nuestra Misión
            </h2>
            <p className="text-muted-foreground leading-relaxed max-w-2xl mx-auto">
              Conectar a los lectores con obras literarias cuidadosamente seleccionadas, 
              promoviendo la lectura consciente y el amor por los libros que transforman vidas. 
              Creemos que cada libro tiene el poder de cambiar perspectivas y enriquecer el alma.
            </p>
          </CardContent>
        </Card>
      </section>

      {/* Values Grid */}
      <section className="mb-12">
        <h2 className="font-sans text-2xl md:text-3xl font-semibold text-center text-foreground mb-8">
          Nuestros Valores
        </h2>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Card className="text-center hover:shadow-book transition-all duration-300">
            <CardContent className="p-6">
              <Heart className="h-10 w-10 text-primary mx-auto mb-4" />
              <h3 className="font-semibold text-foreground mb-3">Pasión por la Literatura</h3>
              <p className="text-sm text-muted-foreground">
                Cada libro en nuestro catálogo ha sido seleccionado con amor y dedicación 
                por nuestro equipo de expertos literarios.
              </p>
            </CardContent>
          </Card>

          <Card className="text-center hover:shadow-book transition-all duration-300">
            <CardContent className="p-6">
              <Leaf className="h-10 w-10 text-primary mx-auto mb-4" />
              <h3 className="font-semibold text-foreground mb-3">Compromiso Ecológico</h3>
              <p className="text-sm text-muted-foreground">
                Trabajamos con editoriales que priorizan materiales sostenibles y 
                prácticas respetuosas con el medio ambiente.
              </p>
            </CardContent>
          </Card>

          <Card className="text-center hover:shadow-book transition-all duration-300">
            <CardContent className="p-6">
              <Users className="h-10 w-10 text-primary mx-auto mb-4" />
              <h3 className="font-semibold text-foreground mb-3">Comunidad Lectora</h3>
              <p className="text-sm text-muted-foreground">
                Fomentamos el intercambio de ideas y experiencias entre lectores, 
                creando una comunidad vibrante y acogedora.
              </p>
            </CardContent>
          </Card>
        </div>
      </section>

      {/* Story Section */}
      <section>
        <div className="max-w-4xl mx-auto">
          <h2 className="font-sans text-2xl md:text-3xl font-semibold text-center text-foreground mb-8">
            Nuestra Historia
          </h2>
          
          <div className="space-y-6 text-muted-foreground leading-relaxed">
            <p>
              Biblioteca nació con una visión simple: crear un espacio 
              donde los libros y la naturaleza se encuentren. Inspirados por la tranquilidad de los 
              bosques y la sabiduría de las páginas, creamos una experiencia única.
            </p>
            
            <p>
              Nuestro equipo está formado por amantes de la literatura 
              que entienden que cada lector es único. Por eso, ofrecemos 
              libros y experiencias que enriquezcan la vida de nuestros clientes.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
};

export default About;