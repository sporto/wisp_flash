import gleam/option.{type Option}
import wisp.{type Request, type Response}

const session_cookie_alert_kind = "alert_kind"

const session_cookie_alert_message = "alert_message"

const expiration = 15

/// Set a flash message in the session cookie.
/// This will store two cookies. One for the message and one for the notification kind.
///
/// ## Example
///
/// ```gleam
/// wisp.redirect("/home")
/// |> wisp_flash.set_flash(request, "success", "Document Saved")
/// ```
pub fn set_flash(
  response response: Response,
  request request: Request,
  kind kind: String,
  message message: String,
) -> Response {
  set_flash_with_exp(
    response: response,
    request: request,
    kind: kind,
    message: message,
    expiration: expiration,
  )
}

fn set_flash_with_exp(
  response response: Response,
  request request: Request,
  kind kind: String,
  message message: String,
  expiration expiration: Int,
) -> Response {
  response
  |> wisp.set_cookie(
    request,
    session_cookie_alert_kind,
    kind,
    wisp.PlainText,
    expiration,
  )
  |> wisp.set_cookie(
    request,
    session_cookie_alert_message,
    message,
    wisp.PlainText,
    expiration,
  )
}

/// Get the flash message and kind.
/// This middleware goes around your request.
/// This gets the values from the cookies and then deletes them.
/// The middleware callback will return the alert kind and message.
/// After putting these values in the context, you can use them to render alerts in your view.
///
/// ## Example
///
/// ```gleam
/// use kind, message <- wisp_flash.get_flash(request)
///
/// let ctx = Context(..ctx, flash_kind: kind, flash_message: message)
/// ```
pub fn get_flash(
  request: Request,
  next: fn(Option(String), Option(String)) -> Response,
) {
  let #(kind, message) = get_flash_in(request)

  let response = next(kind, message)

  // Remove the flash cookies on the way out
  get_flash_out(response, request)
}

/// Just the incoming part of the get_flash around middleware.
/// This gives you the values to put in the context.
///
/// ## Example
///
/// ```gleam
/// let #(kind, message) = wisp_flash.get_flash_in(request)
/// ```
fn get_flash_in(request: Request) -> #(Option(String), Option(String)) {
  let kind =
    wisp.get_cookie(request, session_cookie_alert_kind, wisp.PlainText)
    |> option.from_result

  let message =
    wisp.get_cookie(request, session_cookie_alert_message, wisp.PlainText)
    |> option.from_result

  #(kind, message)
}

/// The outgoing part of the get_flash around middleware.
/// This deletes the cookies.
///
/// ## Example
///
/// ```gleam
/// response |> get_flash_out(request)
/// ```
fn get_flash_out(response, request) {
  set_flash_with_exp(response, request, "", "", 0)
}
