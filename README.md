# rtexlua

experiments in calling texlua from (non-luatex) tex

## quick start

Try

```
pdftex --shell-escape rtl-example

```

to see text substititions vial Lua patterns and some floating point
Lua arithmentic in a pdfTeX docuemnt.

While testing this requires the `--shell-escape` flag to allow Lua
(`texlua`) to be called. However, the intention is that this
configuration makes a sandboxed Lua environment that would be suitable
to allow this script in the safe command list that is allowed in the
default restricted shell escape mode, so `--shell-escape` would not be
needed.
