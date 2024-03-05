import "bialet" for Request, Response
import "_app/layout" for Layout
import "_app/domain" for Usuario, Dominio
import "_app/validator" for Validator

if (Usuario.estaLogueado) {
  return Response.redirect("/dashboard")
}

var q = Dominio.normalizarDominio(Request.get("q"))
var encontrado = Dominio.findByFqdn(q)
var valido = Dominio.valido(q)
var error = false

if (Request.isPost && !encontrado && valido && Dominio.quedan > 0) {
  var email = Request.post("email")
  var password = Request.post("password")
  var domain = q
  var referrer = Request.get("ref")
  if (!Request.post("terminos")) {
    error = "Debes aceptar los términos y condiciones"
  }
  if (!Validator.email(email)) {
    error = "Correo electrónico no válido"
  } else if (Usuario.findByEmail(email)) {
    error = "El correo electrónico ya está registrado"
  }
  if (!error) {
    Usuario.guardar(email, password, domain, referrer)
    return Response.redirect("/dashboard")
  }
}

var html = Layout.render("Buscar dominio %(q)", '

  %( Layout.headerBuscar(q) )

  %( encontrado || !valido ? '
<section class="features-icons bg-light text-center">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-xl-6">
        <h2 class="alert alert-warning text-center" role="alert">El dominio se encuentra registrado 😞</h2>
      </div>
    </div>
  </div>
</section>
  ' : '
<section class="features-icons bg-light">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-xl-6">
        %( error ?
          '<h2 class="alert alert-danger text-center" role="alert">%(error)</h2>':
          '<h2 class="alert alert-success text-center" role="alert">¡El dominio esta disponible! 🥳</h2>'
        )
      </div>
    </div>
    %( Dominio.quedan > 0 ? '
    <div class="row justify-content-center mt-4">
      <div class="col-xl-6">
        <form method="POST">
          <div class="mb-3">
            <h1>
              Registrar <strong class="text-secondary">%(q)</strong>
            </h1>
          </div>
          <div class="form-floating mb-3">
            <input type="email" class="form-control" name="email" id="email" placeholder="nombre@ejemplo.com" value="%( Request.post("email") )">
            <label for="email">Correo electrónico</label>
          </div>
          <div class="form-floating mb-3">
            <input type="password" class="form-control" name="password" id="password" placeholder="Contraseña">
            <label for="password">Contraseña</label>
          </div>
          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="terminos" %( Request.post("terminos") ? 'checked="checked"' : "")" id="terminos">
            <label class="form-check-label" for="terminos">
              Acepto los <a href="/terminos-y-condiciones" target="_blank">términos y condiciones</a>
            </label>
          </div>
          <button type="submit" class="btn btn-primary">Crear cuenta</button>
        </form>
    </div>
    ' : '
      <p class="text-center mt-2 fs-3">No contamos con cupo para registrarlo en este momento.</p>
      <p class="text-center mt-2 fs-3">📣 Se aproxima una nueva tanda de dominios</p>
      <p class="text-center mt-2 fs-3">Seguinos en <a href="https://twitter.com/pragmore" target="_blank">Twitter</a> y <a href="https://www.linkedin.com/company/pragmore/" target="_blank">LinkedIn</a> para ser tener tu dominio antes que nadie</p>
    ')
  </div>
</section>
')
')
Response.out(html)
