import gleam/dict
import gleam/http
import gleam/http/response
import gleam/option.{Some}
import gleeunit
import wisp
import wisp/simulate
import wisp_flash

pub fn main() {
  gleeunit.main()
}

pub fn set_cookies_test() {
  let request = simulate.request(http.Post, "/delete")

  let response =
    wisp.redirect("/")
    |> wisp_flash.set_flash(request, "error", "Failed")

  let cookies =
    response.get_cookies(response)
    |> dict.from_list

  assert cookies
    |> dict.has_key("alert_kind")

  assert cookies
    |> dict.has_key("alert_message")
}

pub fn get_flash_test() {
  let request =
    simulate.request(http.Get, "/")
    |> simulate.cookie("alert_kind", "error", wisp.Signed)
    |> simulate.cookie("alert_message", "Failed", wisp.Signed)

  use kind, message <- wisp_flash.get_flash(request)

  assert kind == Some("error")
  assert message == Some("Failed")
  wisp.ok()
}
