# SolidityTest

1. Design a proxy contract Proxy, this proxy
contract can call the external contract
FuncWithSelector. All external contracts
implement an external function, which is
uniquely identified in the proxy contract. When
a call is made to the Proxy, it is routed to the
correct external contract using a function
selector. There is an admin that can register
external contracts in the proxy. When
registering, the agent deploys it using its
selector as the salt.

2. Complete the Multicall contract and
implement a function multicall to call
testMulticall and testMulticall1 in the external
contract FuncWithSelector
