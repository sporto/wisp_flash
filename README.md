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
use kind, message <- wisp_flash.get_flash(request)

let ctx = Context(..ctx, flash_kind: kind, flash_message: message)
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
