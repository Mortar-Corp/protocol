import React from 'react';

import './App.css';
import Navbar from './components/Navbar';

import { BrowserRouter, Routes, Route} from "react-router-dom";


function App() {
  const name = "yeet"
  return (
    <div className = "App">
      <Navbar />
      <h1>hey {name}</h1>
      
    </div>
  );
}

export default App;
