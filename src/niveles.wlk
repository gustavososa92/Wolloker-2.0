import elementos.*
import jugador.*
import tablero.*
import wollok.game.*

object nivel1 {

	const ancho = game.width() - 1
	const largo = game.height() - 1
	

	method cargar() {
//		controladorDeTablero.sacarTodo()
		self.agregarCosas()
		self.gameConfig()
		game.errorReporter(jugador)
	}

	method agregarCosas() {
		self.cargarBordeV(0)
		self.cargarBordeV(ancho)
		self.cargarBordeH(0)
		self.cargarBordeH(largo)
		jugador.position(game.at(2,2))
		game.addVisual(jugador)
		self.agregarBloques()
	}

	method cargarBordeV(x) {
		self.cargarCosaV(x, new Pared())
	}

	method cargarBordeH(y) {
		self.cargarCosaH(y, new Pared())
	}

	method cargarCosaV(x,cosa) {
		new Range(start=0,end=largo).forEach({ n => game.addVisualIn(cosa, game.at(x, n))})
	}

	method cargarCosaH(y,cosa) {
		new Range(start=1,end=ancho-1).forEach({ n => game.addVisualIn(cosa, game.at(n, y))})
	}

	method gameConfig() {
		game.whenCollideDo(jugador, { objeto => jugador.teChocasteCon(objeto)})
		keyboard.right().onPressDo({ jugador.derecha()})
		keyboard.left().onPressDo({ jugador.izquierda()})
		keyboard.down().onPressDo({ jugador.abajo()})
		keyboard.up().onPressDo({ jugador.arriba()})
	}

	method agregarBloques() {
		new Range(start = 1, end = ancho-1).forEach({n=>self.cargarCosaV(n, new Bloque())})
	}

//	method gano()
}

