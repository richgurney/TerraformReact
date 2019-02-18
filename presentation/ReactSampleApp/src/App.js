import React, { Component } from 'react';
import './App.css';
import {
  Route,
  NavLink,
  HashRouter
} from "react-router-dom";
import Home from "./Home";
import Posts from "./Posts";

class App extends Component {
  render() {
    return (
      <HashRouter>
        <div>
          <nav>
            <li><NavLink to="/">Home</NavLink></li>
            <li><NavLink to="/posts">Posts</NavLink></li>
          </nav>
          <div className="content">
              <Route exact path="/" component={Home}/>
              <Route path="/posts" component={Posts}/>
          </div>
        </div>
      </HashRouter>
    );
  }
}

export default App;
