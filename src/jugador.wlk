import elementos.*
import niveles.*
import tablero.*
import wollok.game.*

object jugador inherits CosaInteractiva {

	override method image() = "player.png"

	override method teChocasteCon(cosa) {
		cosa.teChocasteCon(self)
	}

	method moverse(posicion) {
		if (self.posicionValida(posicion)) self.position(posicion)
	}

	method posicionValida(posicion) {
		return controladorDeTablero.sePuedeMoverA(posicion)
	}

	method teGolpeo() {
		self.morir()
	}

}

