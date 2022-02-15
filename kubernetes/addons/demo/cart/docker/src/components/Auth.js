import React      from 'react';
import { css }    from "@emotion/react";
import ClipLoader from "react-spinners/ClipLoader";

import './Auth.css';

export default class Auth extends React.Component {
  componentDidMount() {
    let code = new URLSearchParams(window.location.search).get("code");
    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ code: code })
    };

    fetch('https://localhost/apim/ws/rest/v1/Authentication/token', requestOptions)
      .then(response => response.json())
      .then(data => {
          window.sessionStorage.setItem("id_token", data.id_token);
	  window.location.href = "/addons/demo/cart/checkout";
        }
      );
  }

  render() {
    const override = css`
      display: block;
      margin: 0 auto;
    `;

    return (
      <ClipLoader color={'blue'} loading={true} css={override} size={150} />
    );
  }
}
