# hubot-etcd

A Hubot script for querying an Etcd cluster

[![NPM](https://nodei.co/npm/hubot-etcd.png)](https://nodei.co/npm/hubot-etcd)


## Installation

In hubot project repo, run:

`npm install hubot-etcd --save`

Then add **hubot-etcd** to your `external-scripts.json`:

```json
[
  "hubot-etcd"
]
```

## Sample Interaction

```
user1>> hubot etcd add alias local localhost 4001
hobot>> Alias added
user1>> hubot etcd show aliases
hubot>> { "local": { "host:" "localhost", "port": "4001"}}
user1>> hubot etcd local get key1/subkey1
hubot>> {"key":"/key1/subkey1","value":"awubawub","modifiedIndex":22,"createdIndex":22}
```

## Roadmap

0.2.0 - Cluster health
