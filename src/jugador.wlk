import elementos.*
import niveles.*
import tablero.*
import wollok.game.*

object jugador inherits CosaInteractiva {

	var izq = self.position().left(1)
	var der = self.position().right(1)
	var arr = self.position().up(1)
	var aba = self.position().down(1)
	
	const irIzquierda = { if (self.posicionValida(izq)) self.moverIzq() else game.removeTickEvent("irIzquierda")
	}
	const irDerecha = { if (self.posicionValida(der)) self.moverIzq() else game.removeTickEvent("irDerecha")
	}
	const irArriba = { if (self.posicionValida(arr)) self.moverIzq() else game.removeTickEvent("irArriba")
	}
	const irAbajo = { if (self.posicionValida(aba)) self.moverIzq() else game.removeTickEvent("irAbajo")
	}

	override method image() = "player.png"

	override method teChocasteCon(cosa) {
		cosa.teChocasteCon(self)
	}

	method mover(posicion) {
		self.position(posicion)
	}

	method moverIzq() {
		self.mover(izq)
	}

	method moverDer() {
		self.mover(der)
	}

	method moverArr() {
		self.mover(arr)
	}

	method moverAba() {
		self.mover(aba)
	}

	method izquierda() {
		game.onTick(10, "irIzquierda", irIzquierda)
	}

	method derecha() {
		game.onTick(10, "irDerecha", irDerecha)
	}

	method arriba() {
		game.onTick(10, "irArriba", irArriba)
	}

	method abajo() {
		game.onTick(10, "irAbajo", irAbajo)
	}

	method posicionValida(posicion) {
		return controladorDeTablero.sePuedeMoverA(posicion)
	}

}

