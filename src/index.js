
const firebase = require('firebase');
const Elm = require('./Main.elm');
require('./stylus/index.styl');

const config = {
    apiKey: 'AIzaSyD5t66GPKV2t8lLRE70v41rKYCDAcvRR5c',
    authDomain: 'local-life-6a815.firebaseapp.com',
    databaseURL: 'https://local-life-6a815.firebaseio.com/',
    storageBucket: 'gs://local-life-6a815.appspot.com/'
};

const mount = document.getElementById('mount');
const app = Elm.Main.embed(mount);
