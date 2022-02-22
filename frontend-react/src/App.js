import React from 'react';

import Header from './components/Header';
import Listings from './pages/Listings';
import Home from './pages/Home';
import { Switch} from "react-router-dom";


import {BrowserRouter, Routes, Route} from "react-router-dom";

function App() {
  return (
    <div className = "App">
      <Header />
      <BrowserRouter>
        <Routes>
          <Route path="/home" exact component ={<Home />}/>
          <Route path="/listings" exact component ={<Listings />}/>
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
