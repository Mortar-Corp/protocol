import React from 'react';
import Header from './components/Header';
import Listings from './pages/Listings';
import Home from './pages/Home';
import FAQ from './pages/FAQ'

import { Routes, Route, BrowserRouter} from "react-router-dom";

function App() {
  return (
    <div className = "App">
      <BrowserRouter>
        <Header />
        <main>
          <Routes>
            <Route path="/home" exact element ={<Home />} />
            <Route path="/listings" element ={<Listings />} />
            <Route path="/FAQ" element ={<FAQ />} />
          </Routes>
        </main>
      </BrowserRouter>
    </div>
  );
}

export default App;
