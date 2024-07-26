# wisp_flash

Middleware to add flash messages in Wisp

[![Package Version](https://img.shields.io/hexpm/v/wisp_flash)](https://hex.pm/packages/wisp_flash)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/wisp_flash/)

## Setting the flash message

In your handler:

```gleam
wisp.redirect("/home")
|> wisp_flash.set_flash(request, "success", "Document Saved")
```

## Retrieving the flash message

In your router:

```gleam
let set_in_context = fn(kind: Option(String), message: Option(String)) {
  Context(..ctx, flash_kind: kind, flash_message: message)
}

use ctx <- wisp_flash.get_flash(request, set_in_context)
```

In your view:

```gleam
fn alert(ctx: Context) {
  case ctx.flash_message {
    Some(flash_message) -> {
      let kind = ctx.flash_kind |> option.unwrap("notice")

      ...
    }
    None -> div([], [])
  }
}
```
