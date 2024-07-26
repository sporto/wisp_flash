import gleam/dict
import gleam/option.{type Option, Some}
import gleeunit
import gleeunit/should
import wisp
import wisp/testing
import wisp_flash

pub fn main() {
  gleeunit.main()
}

type Context {
  Context(kind: Option(String), message: Option(String))
}

pub fn set_cookies_test() {
  let request = testing.post("/delete", [], "")

  let response =
    wisp.redirect("/")
    |> wisp_flash.set_flash(request, "error", "Failed")

  let cookies =
    response.get_cookies(response)
    |> dict.from_list

  cookies
  |> dict.get("alert_kind")
  // base64 encoded
  |> should.equal(Ok("ZXJyb3I"))
}

pub fn get_flash_test() {
  let request =
    testing.get("/", [])
    |> testing.set_cookie("alert_kind", "error", wisp.PlainText)
    |> testing.set_cookie("alert_message", "Failed", wisp.PlainText)

  let set_in_context = fn(kind, message) {
    Context(kind: kind, message: message)
  }

  wisp_flash.get_flash(request, set_in_context, fn(ctx) {
    ctx.kind |> should.equal(Some("error"))
    ctx.message |> should.equal(Some("Failed"))
    wisp.ok()
  })
}
