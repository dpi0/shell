## how `ya pack -a` works

<https://yazi-rs.github.io/docs/cli>

pack means **packages**

`ya pack -a PLUGIN_OR_THEME_NAME`

- clones to `$HOME/.local/state/yazi/packages/`
- copies the plugin to `$HOME/.config/yazi/plugins or flavors`
- and most importantly adds it to `$HOME/.config/package.toml`

like installing this theme `ya pack -a gosxrgxx/flexoki-dark`

- clones the repo in `$HOME/.local/state/yazi/packages/d0a2ce5bc421682753a163590915625f`
- copies the repo to `$HOME/.config/yazi/flavors/flexoki-dark`
- updates the `package.toml` with below

```toml
[[flavor.deps]]
use = "gosxrgxx/flexoki-dark"
rev = "65ba744"
hash = "13cc1e635e5571d749f606bdbde23a0d"
```

### to install all plugins in `package.toml` on a new system

`ya pack --install` or `-i`

or add a single plugin from `package.toml`

`ya pack --add gosxrgxx/flexoki-dark`

### update all plugins

`ya pack -u`

### to delete a plugin

`ya pack -d gosxrgxx/flexoki-dark`

- this deletes the `package.toml` listing
- and deletes the `$HOME/.config/yazi/flavors or plugins` directory

### list all plugins

`ya pack -l`

## manually installing theme

get theme from: <https://github.com/yazi-rs/flavors>

- clone the repo somewhere
- copy it to `$HOME/.config/yazi/flavors/THEME_NAME`
- inside of `THEME_NAME` `flavor.toml` is the theme.

## changing theme

in `$HOME/.config/yazi/theme.toml` set the `[flavor]`

only 1 flavor at a time.
