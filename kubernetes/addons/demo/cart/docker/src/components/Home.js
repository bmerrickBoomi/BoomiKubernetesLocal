import React from 'react';
import acme  from '../images/Acme-corp.webp';

export default class Home extends React.Component {

  submit(e) {
    var attrs = {
      'response_type': 'code',
      'client_id': process.env.REACT_APP_CLIENT_ID,
      'redirect_uri': encodeURI(process.env.REACT_APP_REDIRECT_URI),
      'scope': 'openid',
      'state': Math.random().toString(36)
    };
	  
    window.location.href = `${process.env.REACT_APP_IDP_HOST}/authorize?response_type=${attrs.response_type}&client_id=${attrs.client_id}&redirect_uri=${attrs.redirect_uri}&scope=${attrs.scope}&state=${attrs.state}`
    e.preventDefault();
    return false;
  }

  render() {

    return (
      <div className="wrapper fadeInDown">
        <div id="formContent">
          <div className="fadeIn first">
            <img src={acme} id="icon" alt="User Icon" />
          </div>
 
          <form>
            <input type="text" id="login" className="fadeIn second" name="login" placeholder="login" />
            <input type="text" id="password" className="fadeIn third" name="login" placeholder="password" />
            <input type="submit" className="fadeIn fourth" value="Log In" onClick={this.submit} />
          </form>

          <div id="formFooter">
            <a className="underlineHover" href="https://google.com">Forgot Password?</a>
          </div>
        </div>
      </div>);
  }
}
