# onetbb-snow-leopard

Build **oneTBB 2021.5.0** static for **Mac OS X 10.6.8 / i386**.

```sh
./build.sh      # -> prefix/lib/libtbb.a, libtbbmalloc.a (i386)
```

Key 10.6/i386 fix: oneTBB 2021.5 dropped 32-bit macOS and ships no
`mac32-*.def` symbol-export files, so `build.sh` copies the `mac64-*.def` to
`mac32-*.def` (the export list is irrelevant for a static archive) to satisfy
the build's `LINK_DEPENDS`. Uses the clang/`ld64-274` toolchain.
