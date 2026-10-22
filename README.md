# Abla MessagePack

A [MessagePack](https://msgpack.org/) encoder and decoder written in
[Abla](https://github.com/AndreBaltazar8/ablac), with no C library.

## Features

- every format in the spec: nil, bool, all int / uint widths, float32 and
  float64, str, bin, array, map (any key type) and ext (fixext and ext8/16/32);
- integers written in their smallest form;
- uint64 values at or above 2^63 kept exactly (their bit pattern, `unsigned`);
- a streaming `MsgpackWriter` / `MsgpackReader` for codecs over your own types,
  with no intermediate tree;
- a `MsgpackValue` tree on top, with a nesting limit on decode; and
- bad input (truncation, reserved bytes, lengths past the end, extra bytes)
  reported as errors, never read out of bounds.

## Import

```abla
import github("AndreBaltazar8/abla-msgpack")
```

For sibling-checkout development:

```abla
import "../../abla-msgpack/src/msgpack.ab"
```

## Example

```abla
import "abla/io"
import "../../abla-msgpack/src/msgpack.ab"

fun main: int {
    // [1, "hi", {"ok": true}]
    var w = msgpackWriter()
    w.writeArrayHeader(3)
    w.writeInt(1)
    w.writeStr("hi")
    w.writeMapHeader(1)
    w.writeStr("ok")
    w.writeBool(true)
    val bytes = w.bytes()

    val decoded = msgpackDecodeValue(bytes)
    if (!decoded.ok) return 1
    println(decoded.value.items[1].text)
    if (decoded.value.items[2].field("ok").boolean) 0 else 2
}
```

`MsgpackReader.next()` returns one token at a time (an array or map header
carries its `count`), and `skip()` passes over a whole item.

## Testing

`make check` runs the fixtures for every format, the reader, and the error
cases.

Licensed under the Mozilla Public License 2.0.
