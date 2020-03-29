Useful commands:

- `elmstatic watch` - watch for changes
- ` cd _site && browser-sync start --server --files "." --no-ui  --reload-delay 500 --reload-debounce 500` - start browser sync
- `cd _site && http-server` - in the site directory, start up an http server
- `elmstatic build && cd _site && aws s3 sync . s3://mweiss.me/` - sync the compiled site
