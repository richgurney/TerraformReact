import React, { Component } from 'react';
import logo from './logo.png';
import Post from './Post';
import dotenv from 'dotenv';


class Posts extends Component {

  constructor() {
    super();
    dotenv.config()
    this.state = {
      posts: []
    }
  }

  render() {
    return (
      <div id="posts">
        <img src={logo} alt="logo" />
        <h1>Recent Posts</h1>
        <hr/>
        {
          this.state.posts.map((object, i) =>  <Post key={i} title={object.title} body={object.body}/>)
        }
      </div>
    );
  }

  componentDidMount() {
    fetch(process.env.REACT_APP_HOST).then(results => {
      return results.json();
    }).then(data => {
      this.setState(data);
    });
  }
}

export default Posts;
