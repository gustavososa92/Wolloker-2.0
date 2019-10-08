import wollol.game.*
import personaje.*
import nivel.*


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

object movedor {

	const limiteSuperior = (game.height() - 2)
	const limiteCero = 1

	method moverNivel1() {
		self.moverJefe()
		self.moverEnigma()
		self.moverZombie()
		nivel1.plantarBomba()
	}

	method moverJefe() {
		self.darMovimiento(jefe, 600, "movimientoJefe", 4, 2, true, true, true)
	}

	method moverEnigma() {
		self.darMovimiento(enigma, 300, "movimientoEnigma", 0, 1, true, true, true)
	}

	method moverZombie() {
		self.darMovimiento(zombie, 500, "movimientoZombie", 3, 2, true, true, true)
	}

	method darMovimiento(cosa, tiempo, nombre, limiteV, limiteH, idaYVuelta, arriba, derecha) {
		const objeto = new Limitador(up = arriba, right = derecha, limV = limiteV, limH = limiteH, objetoAMover = cosa, cambiaSentido = idaYVuelta, posInicial = cosa.position())
		game.onTick(tiempo, nombre, {=>
			if (limiteV != 0) {
				if (objeto.up()) controladorDeTablero.moverArr(cosa) else controladorDeTablero.moverAba(cosa)
				objeto.sumarV()
			}
			if (limiteH != 0) {
				if (objeto.right()) controladorDeTablero.moverDer(cosa) else controladorDeTablero.moverIzq(cosa)
				objeto.sumarH()
			}
		})
	}

	method moverProyectiles(lista, paraArriba) {
		var nroProyectil = 0
		lista.forEach{ proyectil => game.onTick(proyectil.tiempo(), "proyectil" + nroProyectil, {=>
			if (paraArriba) {
				self.moverHaciaArriba(proyectil)
			} else {
				self.moverHaciaAbajo(proyectil)
			}
			nroProyectil++
		})}
	}

	method moverNivel2() {
		self.moverProyectiles(nivel2.lineaLava1(), true)
		self.moverProyectiles(nivel2.lineaLava3(), true)
		self.moverProyectiles(nivel2.lineaLava2(), false)
		self.moverProyectiles(nivel2.lineaLava4(), false)
		self.moverProyectiles(nivel2.bolasAbajo(), false)
		self.moverProyectiles(nivel2.bolasArriba(), true)
	}

	method moverArriba(objeto, velocidad, nombre) {
		self.darMovimiento(objeto, velocidad, nombre, 13, 0, false, true, true)
	}

	method moverAbajo(objeto, velocidad, nombre) {
		self.darMovimiento(objeto, velocidad, nombre, 13, 0, false, false, true)
	}

	method moverHaciaArriba(objeto) {
		self.moverElemento(objeto, self.arribaDeTodo(objeto.position()), self.posicionTodoAbajo(objeto.position()), objeto.position().up(1))
	}

	method moverHaciaAbajo(objeto) {
		self.moverElemento(objeto, self.abajoDeTodo(objeto.position()), self.posicionTodoArriba(objeto.position()), objeto.position().down(1))
	}

	method moverElemento(objeto, condicion, alBorde, normal) {
		if (condicion) objeto.moverse(alBorde) else objeto.moverse(normal)
	}

	method arribaDeTodo(posicion) = posicion.y() == limiteSuperior

	method abajoDeTodo(posicion) = posicion.y() == limiteCero

	method posicionTodoAbajo(posicion) = game.at(posicion.x(), limiteCero)

	method posicionTodoArriba(posicion) = game.at(posicion.x(), limiteSuperior)

}

class Limitador {

	var pasosV = 0
	var pasosH = 0
	var property up
	var property right
	const limV
	const limH
	const cambiaSentido
	const objetoAMover
	const posInicial

	method sumarV() {
		pasosV += 1
		self.debeCambiar()
	}

	method sumarH() {
		pasosH += 1
		self.debeCambiar()
	}

	method debeCambiar() {
		if (pasosV > limV) {
			if (cambiaSentido) self.cambiarSentido('y') else self.irAInicio()
			pasosV = 0
		}
		if (pasosH > limH) {
			if (cambiaSentido) self.cambiarSentido('x') else self.irAInicio()
			pasosH = 0
		}
	}

	method cambiarSentido(eje) {
		if (eje == 'x') right = not right
		if (eje == 'y') up = not up
	}

	method irAInicio() {
		objetoAMover.moverse(posInicial)
	}

}

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

	method moverIzq(cosa) {
		self.moverA(cosa.position().left(1), cosa)
	}

	method moverDer(cosa) {
		self.moverA(cosa.position().right(1), cosa)
	}

	method moverArr(cosa) {
		self.moverA(cosa.position().up(1), cosa)
	}

	method moverAba(cosa) {
		self.moverA(cosa.position().down(1), cosa)
	}

	method moverA(posicion, cosa) {
		cosa.moverse(posicion)
	}

}

class CosaInteractiva inherits CosaEnTablero {

	override method dejaPasar() = true

	method teChocasteCon(cosa) {
	}

	method aparecer() {
		game.addVisual(self)
	}

}

class Equipo inherits CosaInteractiva {

	override method teChocasteCon(cosa) {
		cosa.equipo().add(self)
		game.removeVisual(self)
	}

	method puedeSerLlevado() = false

}

class Pared inherits CosaEnTablero {

	override method image() = "muro.png"

	override method dejaPasar() = false

}

