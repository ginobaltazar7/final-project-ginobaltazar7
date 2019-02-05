import React, { Component } from 'react'

class Header extends Component {
  render() {
    return (
      <header style={{
        height: '125px', 
        backgroundColor: '#184fd2', 
        position: 'absolute',
        top: '0',
        left: '0',
        right: '0',
        color: '#ffffff',
        padding: '0 15px 0 15px',
        overflow: 'auto'}}>
        <div style={{fontSize: '20px', lineHeight: '125px', float: 'left'}}>{this.props.pageTitle}</div>
        <div style={{fontSize: '20px', lineHeight: '125px', float: 'right'}}>Current Address: {this.props.currentAccount}</div>
      </header>
    );
  }
}

export default Header;
