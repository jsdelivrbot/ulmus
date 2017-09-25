
const Elm = require('./Main.elm');

require('./stylus/index.styl');

const mount = document.getElementById('mount');
const app = Elm.Main.embed(mount);

document.addEventListener('keydown', function(e) {
    if(e.keyCode === 9) {
        e.preventDefault();
        app.ports.tabKeyDown.send(null);
    }
});
