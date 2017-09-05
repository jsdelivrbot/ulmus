
const Elm = require('./Main.elm');

require('./stylus/index.styl');

const mount = document.getElementById('mount');
const app = Elm.Main.embed(mount);
