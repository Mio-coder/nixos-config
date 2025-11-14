options for tar:
https://stackoverflow.com/a/27541309

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

Gzip:
| tool      | usage         |
| --------- | ------------- |
| igzip     | gzip          |
| bgzip     | gzip          |
| pugz      | gzip decomp   |
| rapidgzip | gzip decomp   |
| pigz      | gzip comp     |
| zstd      | .gz (gzip)    |


Benchmarks:
https://stackoverflow.com/a/76122225 
https://github.com/facebook/zstd
https://github.com/lz4/lz4
https://quixdb.github.io/squash-benchmark/
https://mattmahoney.net/dc/text.html
https://sites.google.com/site/powturbo/home/benchmark
