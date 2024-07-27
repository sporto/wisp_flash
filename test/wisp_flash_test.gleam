import gleam/dict
import gleam/http/response
import gleam/option.{Some}
import gleeunit
import gleeunit/should
import wisp
import wisp/testing
import wisp_flash

pub fn main() {
  gleeunit.main()
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
  |> dict.has_key("alert_kind")
  |> should.equal(True)

  cookies
  |> dict.has_key("alert_message")
  |> should.equal(True)
}

pub fn get_flash_test() {
  let request =
    testing.get("/", [])
    |> testing.set_cookie("alert_kind", "error", wisp.Signed)
    |> testing.set_cookie("alert_message", "Failed", wisp.Signed)

  use kind, message <- wisp_flash.get_flash(request)

  kind |> should.equal(Some("error"))
  message |> should.equal(Some("Failed"))
  wisp.ok()
}
