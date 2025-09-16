import React from 'react';
import { Container } from 'react-bootstrap';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';


import Header from './components/Header';
import Footer from './components/Footer';

import HomeScreen from './screens/HomeScreen';
import BookScreen from './screens/BookScreen';
import AboutScreen from './screens/AboutScreen';



const App = () => {
    return(
        <Router>
            <Header />
            <main className='py-3'>
                <Container>
                    <Routes>
                        <Route path='/' element={<HomeScreen />} />
                        <Route path='/book/:id' element={<BookScreen />} />
                        <Route path='/about' element={<AboutScreen />} />
                    </Routes>
                </Container>
            </main>
            <Footer/>
        </Router>
    );
}
export default App;