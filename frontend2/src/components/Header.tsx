import React from 'react';
import { NavLink } from 'react-router-dom';

const Header = () => {
    return (
        <header className="bg-background border-b border-border">
            <div className="container mx-auto px-4 py-4 flex items-center justify-between">
                <NavLink to="/" className="font-sans text-xl font-bold">
                    Biblioteca
                </NavLink>
                <nav className="flex items-center gap-6">
                    <NavLink
                        to="/"
                        className={({ isActive }) =>
                            `text-sm ${isActive ? 'text-primary font-semibold' : 'text-foreground hover:text-primary'}`
                        }
                    >
                        Inicio
                    </NavLink>
                    <NavLink
                        to="/about"
                        className={({ isActive }) =>
                            `text-sm ${isActive ? 'text-primary font-semibold' : 'text-foreground hover:text-primary'}`
                        }
                    >
                        Acerca de
                    </NavLink>
                </nav>
            </div>
        </header>
    );
};

export default Header;
