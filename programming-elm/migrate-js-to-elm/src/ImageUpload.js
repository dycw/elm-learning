import React, { Component } from "react";
import { Elm } from "./ImageUpload.elm";
import "./ImageUpload.css";

class ImageUpload extends Component {
  constructor(props) {
    super(props);
    this.elmRef = React.createRef();
  }
  componentDidMount() {
    this.elm = Elm.ImageUpload.init({
      node: this.elmRef.current,
    });
  }
  render() {
    return <div ref={this.elmRef} />;
  }
}
export default ImageUpload;
