import "_app/domain" for Usuario

class Layout {
  static render(title, children) { '
    <html lang="es">
      <head>
        <meta charset="UTF-8"/>
        <title>%( title )</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="data:image/svg+xml,<svg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 00 100 100\'><text y=\'.9em\' font-size=\'90\'>👩‍💻</text></svg>" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css" />
      </head>
      <body>
        %( header(title) )
        <main>
          %( children )
          %( footer )
        </main>
      </body>
    </html>
  ' }

  static header(title) { '
    <header>
      <span><a href="/">👩‍💻 .dev.ar</a></span>
      <h1>%( title )</h1>
      %( Usuario.estaLogueado ? '<a href="/cerrar-sesion">Cerrar sesión</a>' : "" )
    </header>
  ' }

  static footer { '
    <footer>
      Hecho con ❤️ por <a href="https://pragmore.com">Pragmore</a>
    </footer>' }
}
