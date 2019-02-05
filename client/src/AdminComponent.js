import React, { Component } from 'react'
import Header from './Header.js';



class AdminComponent extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      openStoreRequests: []
    };

    this.handleApproveStoreRequest = this.handleApproveStoreRequest.bind(this);
    this.updateOpenStoreOwnerRequests = this.updateOpenStoreOwnerRequests.bind(this);
  }

  componentDidMount() {
    this.updateOpenStoreOwnerRequests();

    this.props.marketplace.MEWStoreOwnerAdded().watch((error, result) => {
      if (!error) {
        this.updateOpenStoreOwnerRequests();
      }
    });
  }

  updateOpenStoreOwnerRequests() {
    this.props.marketplace.MEWfetchOwnerRequests.call().then(requests => {
      this.props.marketplace.MEWStoreOwnerAdded({}, {fromBlock: 0, toBlock: 'latest'}).get((error, events) => {
        if (!error) {
          const ownersAdded = events.map(event => event.args.MEWstoreOwnerAddress);
          this.setState({
            openStoreRequests: requests.filter(n => !ownersAdded.includes(n)),
            loading: false
          })
        }
      });
    });
  }

  handleApproveStoreRequest(index, requestAddress) {
    this.setState(
      {loading: true},
      () => this.props.marketplace.MEWaddStoreOwner.sendTransaction(index, requestAddress, {from: this.props.currentAccount}));
  }

  render() {
    const requests = this.state.openStoreRequests.length
      ? this.state.openStoreRequests.map((request, index) =>
        <div key={request}>
          <span style={{marginRight: '10px'}}>Requesting Address: {request}</span>
          <button onClick={() => this.handleApproveStoreRequest(index, request)}>Approve</button>
        </div>)
      : <div>No open requests...</div>;

    return (
      <div>

        <Header currentAccount={this.props.currentAccount}  pageTitle='ADMIN MODE'>
        </Header>

        <div style={{
          border: '1px solid #0000001e',
          borderRadius: '4px',
          backgroundColor: '#4eca95',
          padding: '15px 15px 60px 15px',
          margin: '55px',
          position: 'relative'}}>
          <div style={{fontSize: '24px'}}>Open MEW Store Owner Requests</div>

          {this.state.loading ? <div>Loading...</div> : requests}
        </div>

      </div>
    );
  }
}

export default AdminComponent
