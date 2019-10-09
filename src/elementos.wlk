import jugador.*
import niveles.*
import tablero.*
import wollok.game.*

class CosaEnTablero {

	var property position

	method image()

	method dejaPasar()

}

class CosaInteractiva inherits CosaEnTablero {

	override method dejaPasar() = true

	method teChocasteCon(cosa) {
	}

}

class Pared inherits CosaEnTablero {

	override method image() = "muro.png"

	override method dejaPasar() = false

}

class Bloque inherits CosaInteractiva {

	var estaPintado = false

	override method image() = if (estaPintado) "bloquePintado.png" else "bloqueSinPintar.png"

	override method teChocasteCon(cosa) {
		estaPintado = not estaPintado
	}

}

