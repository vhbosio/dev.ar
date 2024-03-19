import "bialet" for Db

Db.migrate("Tabla usuarios", `
  CREATE TABLE usuarios (
    id INTEGER NOT NULL PRIMARY KEY,
    email TEXT,
    password TEXT,
    ref INTEGER
  )
`)

Db.migrate("Tabla dominios", `
  CREATE TABLE dominios (
    id INTEGER NOT NULL PRIMARY KEY,
    usuario INTEGER NOT NULL,
    fqdn TEXT,
    redirect TEXT
  )
`)

Db.migrate("Normalizar en minuscula", `
  UPDATE usuarios SET email = LOWER(email);
  UPDATE dominios SET fqdn = LOWER(fqdn)
`)

Db.migrate("Agregar created", `
  ALTER TABLE dominios ADD COLUMN created_at TIMESTAMP;
  ALTER TABLE usuarios ADD COLUMN created_at TIMESTAMP
`)

Db.migrate("Agregar DNS", `
  ALTER TABLE dominios ADD COLUMN dns TEXT
`)
