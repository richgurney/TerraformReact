import React, { Component } from 'react';
import logo from './logo.png';

class Home extends Component {
  render() {
    return (
      <div id="home">
        <h1>The app is running correctly.</h1>

        <p>Welcome to the Sparta Test App</p>
        <img alt="logo" src={logo} />
      </div>
    );
  }
}

export default Home;
