import React from 'react';
import Header from './components/Header';
import Listings from './pages/Listings';
import Home from './pages/Home';
import FAQ from './pages/FAQ';
import Contact from './pages/Contact';


import { Routes, Route, BrowserRouter} from "react-router-dom";

function App() {
  return (
    <div className = "App">
      <BrowserRouter>
        <Header />
        <main>
          <Routes>
            <Route path="/" element ={<Home />} />
            <Route path="/listings" exact element ={<Listings />} />
            <Route path="/FAQ" exact element ={<FAQ />} />
            <Route path="/Contact" exact element ={<Contact />} />
          </Routes>
        </main>
      </BrowserRouter>
    </div>
  );
}

export default App;
