import elementos.*
import jugador.*
import niveles.*
import wollok.game.*

object controladorDeTablero {

	var property limiteSuperior = (game.height() - 1)
	var property limiteDerecho = (game.width() - 1)
	var property limiteCeroX = 0
	var property limiteCeroY = 0

	/*aca se manda la proxima ubicacion */
	method sePuedeMoverA(posicion) = not self.seVaDelTablero(posicion) and (self.cosasDejanPasar(posicion) or self.lugarEstaVacio(posicion))

	method seVaDelTablero(posicion) = self.seVaDeAbajo(posicion) or self.seVaDeArriba(posicion) or self.seVaDeIzq(posicion) or self.seVaDeDer(posicion)

//----------------------------------------------------------------------------------------------------
	/*estas son las comprobaciones de si se sale de cada uno de los bordes */
	method seVaDeAbajo(posicion) = posicion.y() < self.limiteCeroY()

	method seVaDeArriba(posicion) = posicion.y() > self.limiteSuperior()

	method seVaDeIzq(posicion) = posicion.x() < self.limiteCeroX()

	method seVaDeDer(posicion) = posicion.x() > self.limiteDerecho()

//----------------------------------------------------------------------------------------------------
	method cosasDejanPasar(posicion) = self.cosasEn(posicion).all({ c => c.dejaPasar() })

	method cosasEn(posicion) = game.getObjectsIn(posicion)

	method lugarEstaVacio(posicion) = self.cosasEn(posicion).isEmpty()

//*************************************************************************************
	method sacarTodo() {
		game.clear()
	}

	method removerCosasEn(posicion) {
		self.cosasEn(posicion).forEach({ c => game.removeVisual(c)})
	}

	method moverA(posicion, cosa) {
		cosa.moverse(posicion)
	}

}

object scheduler {

	var count = 0

	method schedule(milliseconds, action) {
		count += 1
		const name = "scheduler" + count
		game.onTick(milliseconds, name, { =>
			action.apply()
			game.removeTickEvent(name)
		})
	}

}

