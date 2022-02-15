import React    from 'react';
import Checkout from './components/Checkout';
import Auth     from './components/Auth';
import Home     from './components/Home';

import {
  BrowserRouter as Router,
  Routes,
  Route,
} from "react-router-dom";

import './App.css';

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/addons/demo/cart/checkout" element={<Checkout />} />
        <Route path="/addons/demo/cart/auth"     element={<Auth />}     />
        <Route path="/addons/demo/cart/"         element={<Home />}     />
      </Routes>
    </Router>
  );
}
