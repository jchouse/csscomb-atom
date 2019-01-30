const Comb = require('csscomb');

module.exports = function(config, syntax, text) {
    var comb = new Comb(config),
        callback;

    callback = this.async();

    return comb.processString(text, {syntax: syntax})
        .then(result => emit('comb-text-success', result))
        .catch(error => emit('comb-text-error', error));
};
