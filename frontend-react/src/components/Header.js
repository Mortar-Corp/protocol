import React from 'react'
import {Nav, NavLink} from "react-bootstrap"
import MortarLogo from "../components/MortarLogo.png"


const Header = () => {
  return (
    <div style ={{"background-color": "#212529"}}>
        <Nav class="site-header sticky-top py-1" usedbyfluent="true">
          <div class="container d-flex flex-column flex-md-row justify-content-between" usedbyfluent="true">
            <NavLink class="py-2" href="/">
              <img src = {MortarLogo} alt="Mortar" width = "120" height = "20"></img>
            </NavLink>
            <NavLink class="py-2 d-none d-md-inline-block" href="/listings">Browse Listings</NavLink>
            <NavLink class="py-2 d-none d-md-inline-block" href="https://discord.gg/fHWjBbEX">Community</NavLink>
            <NavLink class="py-2 d-none d-md-inline-block" href="/FAQ">FAQ</NavLink>
            <NavLink class="py-2 d-none d-md-inline-block" href="/contact">Contact</NavLink>
            <NavLink class="py-2 d-none d-md-inline-block" href="/start">Get Started</NavLink>
          </div>
        </Nav>
    </div>
  )
}
// #999
export default Header