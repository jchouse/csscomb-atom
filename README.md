# Csscomb package
CSScomb is a coding style formatter for CSS.

Based on [csscombjs 3.0](https://github.com/csscomb/csscomb.js)

## Configure
### Default settings
Set below code to your config file.
```js
'css-comb':
    'config': 'config_name'
```
`yandex` is the default setting.  If you want to use it don't write anything down.
Already have [configs](https://github.com/csscomb/csscomb.js/tree/master/config) (`yandex`, `zen`, `csscomb`), or you can use your own.
### User settings
You can generate your own config. To do this in the module menu, select `User config` (Packages -> Css Comb -> User config). For more information about [settings](https://github.com/csscomb/csscomb.js/blob/master/doc/options.md). After that in you
After this in your `config.cson` will be added to the following construction
```js
'css-comb':
    'userConfig': true
```
A `config` option higher priority than `userConfig`. Remove the 'config' if you want to use 'userConfig'.
## How to use
Open any file and press `ctrl+alt+c`, or use context menu.
