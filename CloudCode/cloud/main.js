
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var fs = require('fs');
var layer = require('cloud/layer-parse-module/layer-module.js');
var layerProviderID = 'layer:///providers/ff12845a-b270-11e5-b2a6-2584730b1501';  // Should have the format of layer:///providers/<GUID>
var layerKeyID = 'layer:///keys/366d7b06-b732-11e5-95a8-fd7be611250c';   // Should have the format of layer:///keys/<GUID>
var privateKey = fs.readFileSync('cloud/layer-parse-module/keys/layer-key.js');
layer.initialize(layerProviderID, layerKeyID, privateKey);

Parse.Cloud.define("generateToken", function(request, response) {
    var currentUser = request.user;
    if (!currentUser) throw new Error('You need to be logged in!');
    var userID = currentUser.id;
    var nonce = request.params.nonce;
    if (!nonce) throw new Error('Missing nonce parameter');
        response.success(layer.layerIdentityToken(userID, nonce));
});

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
