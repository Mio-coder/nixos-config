options for tar:
https://stackoverflow.com/a/27541309

list of tools:
https://lib.rs/compression
https://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/archivers/index.html
https://lz4.org/#compati

Used:
| tool      | usage         |
| --------- | ------------- |
| rapidgzip | gzip decomp   |
| pigz      | gzip comp     |

All:
| tool      | usage         |
| --------- | ------------- |
| pigz      | zip comp      |
| lbzip2    | bzip2         |
| pigz      | zlib comp     |
| zlib-ng   | zlib          |
| Plzip     | lzip          |
| pbzip2    | bzip2 comp    |
| rzip      | rzip          |
| pxz       | LZMA          |
| xz        | xz            |
| xz        | lzma (legacy) |
| 7z -mmt   | 7z            |
| igzip     | gzip          |
| bgzip     | gzip          |
| zstd      | .zst (zstd)   |
| zstd      | .gz (gzip)    |
| zstd      | .xz (xz)      |
| zstd      | .lz4          |
| brotli    | brotli        |
| pugz      | gzip decomp   |
| igzip     | gzip          |
| miniz (l) | gzip          |
| miniz (l) | zlib          |
| miniz (l) | zip           |
| lz4       | lz4           |
| nvcomp    | lz4           |
| nvcomp    | zstd           |
l - lib

Benchmarks:
https://github.com/facebook/zstd
https://github.com/lz4/lz4
https://quixdb.github.io/squash-benchmark/
https://mattmahoney.net/dc/text.html
https://sites.google.com/site/powturbo/home/benchmark
https://github.com/powturbo/TurboBench

# Gzip decomp

| tool      |
| --------- |
| igzip     |
| bgzip     |
| pugz      |
| rapidgzip |
| zstd      |
| miniz (l) |

## Benchmarks

https://stackoverflow.com/a/76122225 
not included: miniz

# Gzip comp
| tool      |
| --------- |
| igzip     |
| bgzip     |
| zstd      |
| pigz      |


