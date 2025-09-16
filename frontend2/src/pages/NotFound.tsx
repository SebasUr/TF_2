import React from 'react';

const NotFound = () => {
  return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-3xl font-bold mb-2">Página no encontrada</h1>
        <p className="text-muted-foreground">La ruta que intentas abrir no existe.</p>
      </div>
    </div>
  );
};

export default NotFound;
